do

function run(msg, matches)
  return 'telegram-bot v'.. VERSION .. [[ -tfa
  Código-fonte: https://github.com/tfagit/telegram-bot
  Este programa está disponível sob a licença GNU GPL v2.]]
end

return {
  description = "Shows bot version", 
  usage = "!version: Shows bot version",
  patterns = {
    "^!version$",
  }, 
  run = run 
}

end
