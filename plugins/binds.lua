do

local bind_file = './data/binds_data.lua'
local binds_data

function load_binds()
  local f = io.open(bind_file, 'r+')
  if f == nil then
    print "Não há arquivo de binds"
    return nil
  end
  f:close()
  return loadfile(bind_file)()
end

binds_data = load_binds()

function get_espinhao()
  return (binds_data.espinhao[math.random(#(binds_data.espinhao))])
end

function get_esquilo()
  return binds_data.esquilo
end

function get_vacilao()
  return binds_data.vacilao
end

function get_kaponei()
  return binds_data.kaponei
end

function get_assis(){
  return binds_data.assis
}

function get_cobretti(){
  return binds_data.cobretti
}

function get_sapequinha(){
  return binds_data.sapequinha
}

function get_bind()
  return (binds_data.binds[math.random(#(binds_data.binds))])
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
  
  if matches[1] == "kaponei" then
    return get_kaponei()
  end
  
  if matches[1] == "assis" then
    return get_assis()
  end
  
  if matches[1] == "cobretti" then
    return get_cobretti()
  end
  
  if matches[1] == "sapequinha" then
    return get_sapequinha()
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
    "!kaponei",
	"!assis",
    "!cobretti",
    "!sapequinha",
    "!bind: Retorna um bind aleatório"
  },
  patterns = {
    "^[!#](espinhao)$",
    "^[!#](esquilo)$",
    "^[!#](vacilao)$",
    "^[!#](kaponei)$",
	"^[!#](assis)$",
    "^[!#](cobretti)$",
    "^[!#](sapequinha)$",
    "^[!#](bind)s?$"
  },
  run = run
}

end
