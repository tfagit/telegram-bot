--lmgtfy.lua
do

function create_lmgtfy_url(search_terms)
  return "http://lmgtfy.com/?q=" .. (search_terms:gsub(" ", "+"))
end


function run(msg, matches)
  url = create_lmgtfy_url(matches[1])
  return url
end

return{
  description = "Retorna um link do lmgtfy",
  usage = "!lmgtfy [termo de pesquisa]: retorna um lmgtfy para o termo",
  patterns = {
    "^[!#]lmgtfy (.*)$"
  },
  run = run
}
end
