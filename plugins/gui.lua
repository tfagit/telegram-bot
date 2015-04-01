do

local gui_count = 0

function contar_gui(msg)
  if _config.id_gui == nil then
    print("Favor indicar um id pro Gui")
    return nil
  end
  if msg.from.id ~= _config.id_gui then
    gui_count = 0
    return nil
  end
  gui_count += 1
  if gui_count == 4 then
    return "CALA A BOCA, GUI"
  end
end


function run(msg, matches)
  if matches[1] == "!guii" then
    return "VAI SE FUDER, GUI"
  end
  return contar_gui(msg)
end

return{
  description = [[Pode mandar o Gui se fuder no seu lugar,\n
      também manda ele calar a boca automaticamente\n
      id_gui deve ser setado no config.]],
  usage = "!guii: Retorna 'VAI SE FUDER, GUI'"
  patterns = {
    "^!guii$",
    "^#guii$"
    ".",
  },
  run = run
}

end