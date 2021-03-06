do

function get_last_id()
  local res,code  = https.request("http://xkcd.com/info.0.json")
  if code ~= 200 then return "HTTP ERROR" end
  local data = json:decode(res)
  return data.num
end

function get_xkcd(id)
  local last = get_last_id()

  local value = tonumber(id)
  -- Negative numbers get the nth last comic
  if value <= 0 and last - value > 0 then
    id = tostring(last + value)
  end
  
  local comic_url = "http://xkcd.com/"..id
  local res,code  = http.request(comic_url.."/info.0.json")
  if code ~= 200 then return "HTTP ERROR" end
  local data = json:decode(res)
  local link_image = data.img
  if link_image:sub(0,2) == '//' then
    link_image = msg.text:sub(3,-1)
  end
  return link_image, data.title, data.alt, comic_url
end


function get_xkcd_random()
  local last = get_last_id()
  local i = math.random(1, last)
  return get_xkcd(i)
end

function send_data(cb_extra, success, result)
  if success then
    msg_to_send = "Title: " .. cb_extra[2] .. "\nAlt: "..cb_extra[3].."\nSource: "..cb_extra[4]
    send_msg(cb_extra[1], msg_to_send, ok_cb, false)
  end
end

function run(msg, matches)
  local receiver = get_receiver(msg)
  if matches[1] == "xkcd" then
    url, title, alt, comic_url = get_xkcd_random()
  else
    url, title, alt, comic_url = get_xkcd(matches[1])
  end
  send_photo_from_url(receiver, url, send_data, {receiver, title, alt, comic_url})
  return false
end

return {
  description = "Send comic images from xkcd",
  usage = {"!xkcd (id): Send an xkcd image and title. If not id, send a random one"},
  patterns = {
    "^!(xkcd)$",
    "^!xkcd (-?%d+)",
    "xkcd.com/(-?%d+)"
  }, 
  run = run 
}

end
