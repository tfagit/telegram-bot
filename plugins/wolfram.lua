-- wolfram.lua
do

local xml = require "xml"
local query_url = "http://api.wolframalpha.com/v2/query?format=image&appid="..config.wolf_appid.."&input="

function run(msg, matches)
  if matches[2] == nil then
    return nil
  end
  local receiver = get_receiver(msg)
  local query = query_url..matches[2]
  local res, status = http.request(query)
  if core ~= 200 then 
    return "Falha em conectar ao WolframAlhpa"
  end
  local data = xml.load(res)
  local result = xml.find(data, "pod", "title", "result")
  local img_table = xml.find(result, "img")
  local photo_file = download_to_file(img_table.src)
  if photo_file == nil then
    return "Falha em salvar imagem"
  end
  _send_photo(receiver, photo_file)
end
return {
  description = "Sends a query to Wolfram Alpha and returns the result",
  usage = {
    "!wolfram [query]",
    "!= [query]"
  },
  patterns = {
    "^[!#]wolfram (.*)$",
    "^[!#]= (.*)$"  
  },
  run = run
}

end