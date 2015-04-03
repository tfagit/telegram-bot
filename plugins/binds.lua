do

local bind_file = '.data/binds_data.lua'
local binds_data

function load_binds()
  local f = io.open(bind_file, 'r+')
  if f = nil then
    print "Não há arquivo de binds"
    return
  end
  f:close()
  return loadfile(bind_file)()
end

binds_data = load_binds()

function get_espinhao()
  return (binds_data.espinhao[math.random(#binds_data.espinhao)])
end

function get_esquilo()
  return binds_data.esquilo
end

function get_vacilao()
  return binds_data.vacilao
end

function get_bind()
  return (binds_data.binds([math.random(#binds_data.binds)])
end

function run(msg, matches)
  if matches[1] == "espinhao" then
    return get_espinhao()
  end

  if matches[1] == "esquilo" then
    return get_esquilo()
  end
    
  if matches[1] == "vacilao" then
    return get_vacilao()
  end
  
  if matches[1] == "bind" then
    return get_bind()
  end
end

return {
  description = "Coleção de binds",
  usage = {
    "!espinhao",
    "!esquilo",
    "!vacilao",
    "!bind: Retorna um bind aleatório"
  },
  patterns = {
    "^[!#](espinhao)$",
    "^[!#](esquilo)$",
    "^[!#](vacilao)$",
    "^[!#](bind)s?$"
  },
  run = run
}

end