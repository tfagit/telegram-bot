do

-- Utility
-- Number of elements in a table
local function table_count(table)
    local count = 0
    for k,v in pairs(table) do
        count = count + 1
    end
    return count
end

local function get_next_id()
    local counters = _config.bot_db .. ".counters"
    local q = _mongo:query(counters, {_id = "events"})
    p = q:next()
    if p then
        _mongo:update(counters, {_id = "events"}, {["$inc"] = {value = 1}})
        return p.id
    else
        _mongo:insert(counters, {_id = "events", value = 1})
        return 1
    end
end

edb = _config.bot_db .. ".events" -- "path to events namespace"

-- ACTUAL FUNCTIONALITY

help_text = [[TEAMSPEAK-BOT EVENT HANDLER PLUGIN by @Blekwave

Create events, invite your friends and handle your scheduling and notification needs through Telegram!

Usage:
!events
Lists all events you can see - public events, events to which you've been invited and events which you've joined.

!event info (event_id)
Fetches detailed information about a given event.

!event create ("event_name") ("event_description") [private]
Creates a new event with a custom title and a custom description. These must be between quotes. May take an optional 'private' parameter (no quotes necessary). If this is the case, only invited members may join it.

!event close (event_id)
Closes an event. Can only be done by the owner or by someone with super user permissions.

!event edit description (event_id) ("new_description")
Edits an event's description. (Description must be between quotes)

!event invite (event_id) (user_id)
Invites a user to an event.

!event join (event_id)
Joins an existing event. Public events can always be joined. Private events may be joined if the user has been invited previously by the owner.

!event leave (event_id)
Leaves an event.

!event broadcast (event_id) ("message")
Sends a message to all participants.

!event help
Prints this help dialog.

Note: user ids may be gotten by typing !stats, and event ids can be obtained through the !events command.

]]

-- Sends help dialog to user
local function event_help(user)
    _send_msg("user#id"..user.id, help_text)
    return nil
end

-- Creates event with given title and description
local function event_create(owner, title, description, privacy)
    local new_event = {
        id = get_next_id(),
        owner = owner.id,
        title = title,
        description = description,
        participants = {[owner.id] = owner.print_name},
        private = privacy == "private" and true or false,
        invites = {}
    }
    _mongo:insert(edb, new_event)
    return "Event created! ID: " .. tostring(new_event.id)
end

-- Closes an event
local function event_close(owner, event_id)
    local event = _mongo:query(edb, {id = event_id})
    if not event then
        return "There's no such event."
    end
    event = event:next()
    if event.owner == owner.id or is_sudo(owner.id) then
        _mongo:remove(edb, {id = event_id})
        return "Event " .. event_id .. " successfully closed."
    else
        return "You're not allowed to do that."
    end
end

-- Edits an event's description
local function event_edit_description(owner, event_id, description)
    local event = _mongo:query(edb, {id = event_id})
    if not event then
        return "There's no such event."
    end
    event = event:next()
    if event.owner == owner.id then
        _mongo:update(edb, {description = description})
        return "Description updated."
    else
        return "You're not allowed to do that."
    end
end

-- Invites a user to an event
local function event_invite(owner, event_id, invitee_id)
    local event = _mongo:query(edb, {id = event_id})
    if not event then
        return "There's no such event."
    end
    event = event:next()
    if event.owner == owner.id then
        local inv_id_str = tostring(invitee_id)
        if event.participants[inv_id_str] then
            return "This user is already a participant of this event."
        elseif event.invites[inv_id_str] then
            return "This user has already been invited to the event."
        else
            _mongo:update(edb, {id = event_id},
                {['$set'] = {
                    ["invites." .. inv_id_str] = true
                }})
            _send_msg("user#id"..inv_id_str,
                owner.print_name .. " has invited you to \"" .. event.title ..
                    " (" .. event_id .. "). Type !event join " .. event_id ..
                    " to accept your invite.")
            return "User " .. inv_id_str .. " invited to the event."
        end
    else
        return "You're not allowed to do that."
    end
end

-- User tries to join an event
local function event_join(user, event_id)
    local event = _mongo:query(edb, {id = event_id})
    if not event then
        return "There's no such event."
    end
    event = event:next()
    local user_id_str = tostring(user.id)
    if event.private == false or event.invites[user_id_str] then
        if event.participants[user_id_str] then
            return "You are already a participant of this event."
        else
            _mongo:update(edb, {id = event_id},
                {
                    ["$set"] = {
                        ["participants." .. user_id_str] = user.print_name
                    },
                    ["$unset"] = {
                        ["invites." .. user_id_str] = ""
                    }
                })
            _send_msg("user#id"..event.owner, user.print_name.." has joined event #"..event_id)
            return "You have successfully joined event " ..  event_id .. "!"
        end
    else
        return "You haven't been invited to the event."
    end
end

-- Leaves an event
local function event_leave(user, event_id)
    local event = _mongo:query(edb, {id = event_id})
    if not event then
        return "There's no such event."
    end
    local user_id_str = tostring(user.id)
    if event.participants[user_id_str] then
        if event.owner == user.id then
            return "The owner may not leave directly. Use !event close <id> instead."
        end
        _mongo:update(edb, {id = event_id},
            {["$unset"] = {
                ["participants." .. user_id_str] = ""
            }})
        _send_msg("user#id" .. event.owner, user.print_name .. " has left event #" .. event_id)
        return "You have left the event."
    else
        return "You are not a participant of this event"
    end
end

-- Sends a message to all event members
local function event_broadcast(owner, event_id, message)
    local event = _mongo:query(edb, {id = event_id})
    if not event then
        return "There's no such event."
    end
    event = event:next()
    if event.owner == owner.id then
        message = "Broadcast from event #" .. event_id .. " (\"" .. event.title .. "\"):\n" .. message
        for id, name in pairs(event.participants) do
            if name then
                _send_msg("user#id"..id, message)
            end
        end
        return "Broadcast successfully delivered."
    else
        return "You're not allowed to do that."
    end
end

-- Lists all events
local function event_list(user)
    local output = ""
    local q = _mongo:query(edb, {})
    local user_id_str = tostring(user.id)
    for event in q:results() do
        if event.participants[user_id_str] then
            output = output .. event.id .. ": " .. event.title .. " (Joined!) [" .. table_count(event.participants) .. "]\n"
        elseif event.invites[user_id_str] then
            output = output .. event.id .. ": " .. event.title .. " (Invite pending) [" .. table_count(event.participants) .. "]\n"
        elseif event.private == false then
            output = output .. event.id .. ": " .. event.title .. " (Public) [" .. table_count(event.participants) .. "]\n"
        end
    end
    if output == "" then output = "No events available now. Be the first to create one!" end
    _send_msg("user#id" .. user_id_str, output)
    return nil
end

-- Sends detailed info about the event to the user
local function event_info(user, event_id)
    local event = _mongo:query(edb, {id = event_id})
    if not event then
        return "There is no such event"
    end
    event = event:next()
    local user_id_str = tostring(user.id)
    if event and 
        (event.private == false or event.participants[user_id_str] or event.invites[user_id_str]) then
        local message = "" .. event.id .. ": " .. event.title .. " (" .. 
            event.participants[user_id_str] and "Joined" or event.invites[user_id_str] and "Invited" or "Private" ..
            ")\n" .. event.description .. "\n\nParticipants:\n"
        for id, print_name in pairs(event.participants) do
            if print_name then
                message = message .. print_name .. " [" .. id .. "]\n"
            end
        end
        _send_msg("user#id" .. user_id_str, message)
        return nil
    else
        return "This event is either private or non-existant."
    end
end

_events_commands = {
    ["help"] = function(msg, matches)
        return event_help(msg.from)
    end,
    ["info"] = function(msg, matches)
        return event_info(msg.from, tonumber(matches[2]))
    end,
    ["create"] = function(msg, matches)
        return event_create(msg.from, matches[2], matches[3], matches[4])
    end,
    ["close"] = function(msg, matches)
        return event_close(msg.from, tonumber(matches[2]))
    end,
    ["edit description"] = function(msg, matches)
        return event_edit_description(msg.from, tonumber(matches[2]), matches[3])
    end,
    ["invite"] = function(msg, matches)
        return event_invite(msg.from, tonumber(matches[2]), tonumber(matches[3]))
    end,
    ["join"] = function(msg, matches)
        return event_join(msg.from, tonumber(matches[2]))
    end,
    ["leave"] = function(msg, matches)
        return event_leave(msg.from, tonumber(matches[2]))
    end,
    ["broadcast"] = function(msg, matches)
        return event_broadcast(msg.from, tonumber(matches[2]), matches[3])
    end,
    ["events"] = function(msg, matches)
        return event_list(msg.from)
    end
}

local function run(msg, matches)
    if _events_commands[matches[1]] then
        return _events_commands[matches[1]](msg, matches)
    else
        return "Command not recognized. Type !event help for helpful information."
    end
end

return {
    description = "Event manager for telegram-bot.",
    usage = [[!events
              !event info (event_id)
              !event create ("event_name") ("event_description") [private]
              !event close (event_id)
              !event edit description (event_id) ("new_description")
              !event invite (event_id) (user_id)
              !event join (event_id)
              !event leave (event_id)
              !event broadcast (event_id) ("message")
              !event help
    ]],
    patterns = {
        "^[#!](events)$",
        "^[#!]event (info) (%d+)$",
        "^[#!]event (create) \"(.+)\" \"(.+)\" ?(%l*)$",
        "^[#!]event (close) (%d+)$",
        "^[#!]event (edit description) (%d+) \"(.+)\"$",
        "^[#!]event (invite) (%d+) (%d+)$",
        "^[#!]event (join) (%d+)$",
        "^[#!]event (leave) (%d+)$",
        "^[#!]event (broadcast) (%d+) \"(.+)\"$",
        "^[#!]events? (help)$"
    },
    run = run
}

end