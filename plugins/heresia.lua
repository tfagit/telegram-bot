-- heresia.lua
do
local heresia_file = './data/heresia.lua'
local heresia_data

function ler_heresia()
  local f = io.open(heresia_file, 'r+')
  if f = nil then
    print('Novo arquivo de heresia criado')
    serialize_to_file({ num_hereges = 0, dados = nil },heresia_file)
  else
    f:close()
  end
  return loadfile(heresia_file)()
end

heresia_data = ler_heresia()

function mostrar_hereges(num)
  local num_hereges = heresia_data.num_hereges
  local hereges = heresia_data.dados
  if num_hereges == 0 then
    return "Não há hereges. Por enquanto."
  end
  local msg_retorno = ""
  local top_a_mostrar = 0
  if num == nil or num > num_hereges then
    top_a_mostrar = num_hereges
  else
    top_a_mostrar = num
  end
  -- Função para ordenar a tabela pela contagem de heresias
  local sort_rank = function (a, b)
    return a.cont >= b.cont
  end

  table.sort(hereges, sort_rank)

  for i, user in pairs(hereges) do
    msg_retorno = msg_retorno..user.print_name.."["..user.id.."]:"..user.cont.."\n"
  end
  return msg_retorno
end

function registrar_heresia(msg)
  local id = msg.from.id
  local print_name = msg.from.print_name
  print (print_name..' cometeu heresia')
  if heresia_data.dados[id] = nil then
    heresia_data.num_hereges = heresia_data.num_hereges + 1
    heresia_data.dados[id] = {
      name = print_name,
      user_id = id,
      cont = 1
    }
  else
    heresia_data.dados[id].name = print_name
    heresia_data.dados[id].cont = heresia_data.dados[id].cont + 1
  end
  serialize_to_file(heresia_data, heresia_file)
end

function run(msg, matches)
  if matches[1] == "hereges" then
    return mostrar_hereges(matches[2])
  end
  registrar_heresia(msg)
end

return = {
  description = "Detecta palavras heréticas",
  usage = { 
    "!hereges: retorna contagem de heresia para cada pessoa",
    "!hereges [número]: retorna os top [número] hereges"
  },
  patterns = {
    "[ts]ua mãe",
    "ur mom",
    "your mom",
    "batata",
    "potato",
    "bataton",
    "^[!#](hereges) (%d*)"
  },
  run = run
}
end
