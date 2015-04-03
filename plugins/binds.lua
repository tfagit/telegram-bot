do

function get_espinhao()
  local espinhao_table = {
    "espinhao: mto fasil bota no easy",
    "épine de grande envergure: mpour fasil botte sur les facile",
    "big spike: mto fasil boot on easy",
    "espiegfried: mittelfristige Ziel fasil Boot auf einfache",
    "espiñon: mto arranque fasil de sencillo",
    "espignotti: boot obiettivo a medio termine Fasil il facile",
    "еспинхао: мто фасил бота но еасы цыка бляд"
  }
  return(espinhao_table[math.random(#espinhao_table)])
end

function get_esquilo()
  return "esquilo: foda é quando seu cachorro pula na tua cama e lambe teu pau com gosto de calabreza'"
end

function get_medico()
  return "*DEAD* Médico Racista : vacilao"
end

function get_bind()
  local bind_table = {
    "gangue do kaponei :  nem noé pra carregar tanto animal",
    "mymind. skull : VAMO RAPIDO preciso me masturbar exatamente 22:50", 
    "vigos: mais facil q dar a bunda", 
    "mackbad: ok give me 8 minutes for TS e reunir o clan", 
    "KmK.DanielKiller: sou um jenio", 
    "Aqua'H2O: cara comigo é assim tf2 > mulher.", 
    "6.c4bR4L: oq tem falando nisso vai ter isame de dope?", 
    "Jensen Button: round one.. funght !", 
    "apex LOL - RKO: conecssao*", 
    "KmK.ninjaz0rz: vo toma banho faiz 2 dias que to sem tomar", 
    "SqS.Daten: parece q toh com um motorsinho na bunda", 
    "(o) fefe: meu primo morreu vou ver um filme", 
    "kill4fun : flor, quantos anos tu nasceu?", 
    "Rique : tu domina nem as suas cuecas aquiles", 
    "bone -btk : usa minigun, natalia é um lixoa", 
    "Empada de Frango xD: *, eles construiram sanduiche lá, agora fudeu", 
    "?-core² | Alastor quer dormir: esse é o ip da tinta?", 
    "Jezah : eu to querendo a crossbow do medigo", 
    "macachorro: entra um médico aí pra soltar magia", 
    "Sr.age: eu adoro esse negoço redondo do demo, ela até explode", 
    "Big Boss: essa aí eu já tinha ouvisto!", 
    "C A | BielS : essa foi nubisse com serteza", 
    "SDS | ZID : precizase de heavy", 
    "Glorieux Roi ? : vou sair tenho que faze coco =(", 
    "zunto : quer ajuda manda uma carta pro criança esperança", 
    "RAPIDIUL-SAMA : Eu chupo pintos.", 
    "(O melhor rebatedor)Cash Hunter : o q um item vantage fais?", 
    "OM | Orange: ONTEM COMI UMA MINA NO THE SIMS", 
    "auditor ? bazzinga : não sou eu que deciso", 
    "mackbad: finded easi", 
    "FireObstract : pra eu construir a centry.", 
    "bomboniere : difiscil construi intel", 
    "Hypnos: meu pau parece um xis salada", 
    "uk | gog : que lag, meu pai deve estar baixando o ipad", 
    "Brad Bellick: só eu que já namorei e ainda sou bv?", 
    "STAGE7- Nouk: essa busola n fica invisivel", 
    "Mind : Po vei hj peguei uma lanterna e coloquei no meu pal ele fico brilhando e gozei vei", 
    "Evil Ghost | : algm tem facalhão?", 
    "LrS! EiKO :  te metes con migo, te metes con la fiera",
    "esquilo: foda é quando seu cachorro pula na tua cama e lambe teu pau com gosto de calabreza'",
    "espinhao: mto fasil bota no easy",
    "*DEAD* Médico Racista : vacilao"
  }
  return (bind_table[math.random(#bind_table)])
end

function run(msg, matches)
  if matches[1] == "espinhao" then
    return get_espinhao()
  end

  if matches[1] == "esquilo" then
    return get_esquilo()
  end
    
  if matches[1] == "vacilao" then
    return get_medico()
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