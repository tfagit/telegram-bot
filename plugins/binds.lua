do

function getEspinhao()
  local espinhaoTable = {
    "espinhao: mto fasil bota no easy",
    "épine de grande envergure: mpour fasil botte sur les facile",
    "big spike: mto fasil boot on easy",
    "espiegfried: mittelfristige Ziel fasil Boot auf einfache",
    "espiñon: mto arranque fasil de sencillo",
    "espignotti: boot obiettivo a medio termine Fasil il facile",
    "еспинхао: мто фасил бота но еасы цыка бляд"
  }
  return(espinhaoTable[math.random(#espinhaoTable)])
end

function getEsquilo()
  return "esquilo: foda é quando seu cachorro pula na tua cama e lambe teu pau com gosto de calabreza'"
end

function getBind()
  local bindTable = {
    "gangue do kaponei :  nem noé pra carregar tanto animal",
    "SqS.Daten: parece q toh com um motorsinho na bunda",
    "vigos: mais facil q dar a bunda",
    "mymind. skull : VAMO RAPIDO preciso me masturbar exatamente 22:50",
    "Rique : tu domina nem as suas cuecas aquiles",
    "macachorro: entra um médico aí pra soltar magia",
    "LrS! EiKO :  te metes con migo, te metes con la fiera",
    "zunto : quer ajuda manda uma carta pro criança esperança",
    "C A | BielS : essa foi nubisse com serteza",
    "Hypnos: meu pau parece um xis salada"
  }
  return (bindTable[math.random(#bindTable)])
end

function run(msg, matches)
  if matches[1] == "espinhao" then
    return getEspinhao()
  end

  if matches[1] == "esquilo" then
    return getEsquilo()
  end
  
  if matches[1] == "bind" then
    return getBind()
  end
end

return {
  description = "Coleção de binds",
  usage = {
    "[!/#]espinhao",
    "[!/#]esquilo",
    "[!/#]bind"
  },
  patterns = {
    "^[!#](espinhao)$",
    "^[!#](esquilo)$",
    "^[!#](bind)$"
  },
  run = run
}

end