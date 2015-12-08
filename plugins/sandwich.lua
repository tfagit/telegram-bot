do

local function getSandwich()
  local res,status = http.request("http://boards.420chan.org/static/sandwich.php")
  if status ~= 200 then return nil end

  local where = string.find(res, "' />")
  local sandwich = string.sub(res, 11, where-1)

  return "http://boards.420chan.org/static/" .. sandwich
end

local function run(msg, matches)
  local url = nil

  if matches[1] == "sandwich" then
    url = getSandwich()
  end

  if url ~= nil then
    local receiver = get_receiver(msg)
    send_photo_from_url(receiver, url)
  else
    return 'The sandwich shop is closed'
  end
end

return {
  description = "Get a random sandwich",
  usage = {
    "!sandwich"
  },
  patterns = {
    "^[!#](sandwich)$"
  }, 
  run = run
}

end
