do

function run(msg, matches)
	os.execute("cd ~/telegram-bot/; git pull")
	return "O robô pode ter sido atualizado (rode !plugins reload agora)"
end

return {
  description = "Atualiza a árvore git do bot",
  usage = "!pull: atualiza a árvore git do bot",
  patterns = {
    "^[!#]pull$"
  }, 
  run = run 
}

end
