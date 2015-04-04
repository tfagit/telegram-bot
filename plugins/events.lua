do

-- FILE HANDLING

function read_file_events(location)
    local file = io.open(location, "r+")
    if file == nil then
        print('Created new events table at ' .. location)
        serialize_to_file({last_id = 0, db = {}}, location)
    else
        print('Events loaded from ' .. location)
        file:close()
    end
    return loadfile(location)() -- Parses content in file
end

function save_file_events(events, location)
    serialize_to_file(events, location)
end

local _file_events = './data/events.lua'
local _events

_events = read_file_events(_file_events)

-- ACTUAL FUNCTIONALITY

local function event_help(user)
    local help_text = [[Under construction.]]
    _send_msg("user#id"..user.id, help_text)
    return nil
end
 
local function event_create(owner, title, description, privacy)
    _events.last_id = _events.last_id + 1
    local new_event = {
        id = _events.last_id,
        owner = owner.id,
        title = title,
        description = description,
        participants = {[owner.id] = owner.print_name},
        private = privacy == "private" and true or false,
        invites = {}
    }
    _events.db[new_event.id] = new_event
    save_file_events(_events, _file_events)
    return "Event created! ID: " .. tostring(new_event.id)
end

local function event_close(owner, event_id)
    if _events.db[event_id] == nil then
        return "There's no such event."
    end
    if _events.db[event_id].owner == owner.id or is_sudo(owner.id) then
        _events.db[event_id] = nil
        save_file_events(_events, _file_events)
        return "Event " .. event_id .. " successfully closed."
    else
        return "You're not allowed to do that."
    end
end

local function event_edit_description(owner, event_id, description)
    if _events.db[event_id] == nil then
        return "There's no such event."
    end
    if _events.db[event_id].owner == owner.id then
        _events.db[event_id].description = description
        save_file_events(_events, _file_events)
        return "Description updated."
    else
        return "You're not allowed to do that."
    end
end

local function event_invite(owner, event_id, invitee_id)
    if _events.db[event_id] == nil then
        return "There's no such event."
    end
    if _events.db[event_id].owner == owner.id then
        if _events.db[event_id].participants[invitee_id] then
            return "This user is already a participant of this event."
        elseif _events.db[event_id].invites[invitee_id] then
            return "This user has already been invited to the event."
        else
            _events.db[event_id].invites[invitee_id] = true
            save_file_events(_events, _file_events)
            _send_msg("user#id"..invitee_id,
                owner.print_name .. " has invited you to \"" .. _events.db[event_id].title .. " (" .. event_id .. "). Type !event join " .. event_id .. " to accept your invite.")
            return "User " .. invitee_id .. " invited to the event."
        end
    else
        return "You're not allowed to do that."
    end
end

local function event_join(user, event_id)
    if _events.db[event_id] == nil then
        return "There's no such event."
    end
    if _events.db[event_id].private == false or _events.db[event_id].invites[user.id] then
        if _events.db[event_id].participants[user.id] then
            return "You are already a participant of this event."
        else
            _events.db[event_id].invites[user.id] = nil
            _events.db[event_id].participants[user.id] = user.print_name
            save_file_events(_events, _file_events)
            return "You have successfully joined event " ..  event_id .. "!"
        end
    else
        return "You haven't been invited to the event."
    end
end

local function event_leave(user, event_id)
    if _events.db[event_id] == nil then
        return "There's no such event."
    end
    if _events.db[event_id].participants[user.id] then
        _events.db[event_id].participants[user.id] = nil
        save_file_events(_events, _file_events)
        return "You have left the event."
    else
        return "You are not a participant of this event"
    end
end

local function event_broadcast(owner, event_id, message)
    if _events.db[event_id] == nil then
        return "There's no such event."
    end
    if _events.db[event_id].owner == owner.id then
        for id, _ in pairs(_events.db[event_id].participants) do
            _send_msg("user#id"..id, message)
        end
        return "Broadcast successfully delivered."
    else
        return "You're not allowed to do that."
    end
end

local function event_list(user)
    local output = ""
    for event_id, event in pairs(_events.db) do
        if event.participants[user.id] then
            output = output .. event.id .. ": " .. event.title .. " (Joined!) [" .. table_count(event.participants) .. "]\n"
        elseif event.invites[user.id] then
            output = output .. event.id .. ": " .. event.title .. " (Invite pending) [" .. table_count(event.participants) .. "]\n"
        elseif event.private == false then
            output = output .. event.id .. ": " .. event.title .. " (Public) [" .. table_count(event.participants) .. "]\n"
        end
    end
    if output == "" then output = "No events available now. Be the first to create one!" end
    _send_msg("user#id"..user.id, output)
    return nil
end

local function event_info(user, event_id)
    event = _events.db[event_id]
    if event and 
        (event.private == false or event.participants[user.id] or event.invites[user.id]) then
        local message = "" .. event.id .. ": " .. event.title .. "\n" .. event.description .. "\n\nParticipants:\n"
        for id, print_name in event.participants do
            message = message .. print_name .. " [" .. id .. "]\n"
        end
        _send_msg("user#id"..user.id, message)
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