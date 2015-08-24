do

local ROLL_USAGE = "!<# of dice>d<# of faces>"
local DEFAULT_SIDES = 100
local DEFAULT_NUMBER_OF_DICE = 1
local MAX_NUMBER_OF_DICE = 100

function run(msg, matches)
  if #matches == 1 then
    num_dice = DEFAULT_NUMBER_OF_DICE
    faces = tonumber(matches[1])
  else
    num_dice = tonumber(matches[1])
    faces = tonumber(matches[2])
  end

  if num_dice > MAX_NUMBER_OF_DICE then
    num_dice = MAX_NUMBER_OF_DICE
  end

  local sum = math.random(faces)
  local results = tostring(sum)

  for i = 2, num_dice do
    local roll = math.random(faces)
    sum = sum + roll
    results = string.format("%s + %d", results, roll)
  end

  results = string.format("%s = %d", results, sum)
  return string.format("%s rolls %dd%d:\n%s", msg.from.print_name, num_dice,
    faces, results)
end

return {
  description = "Actually roll some dice!",
  usage = ROLL_USAGE,
  patterns = {
    "^!(%d+)d(%d+)",
    "^!d(%d+)"
  },
  run = run
}

end

