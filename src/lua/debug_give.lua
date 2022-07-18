
-- Lua 5.2; OpenComputers 1.6.1.11;
-- rm 1.lua&&edit 1.lua&&1

local component, term, s, io = require('component'), require('term'), require('serialization'), require('io')
local debug_card = component.debug
if debug_card == nil then do return end end

local function execute(command, replace1, replace2)
  print('Command: ' .. command) -- Executing
  local success, details = debug_card.runCommand(command)
  
  if (success ~= 1) then
    print('Something wrong: ' .. details)
  else
    if details ~= nil then
      print('Details: ' .. details)
    else
      print('Command flagged as successfully executed, but no details provided.')
    end
  end

  if (replace1 ~= nil) then
    local t, i = {}, 1
    details = details:gsub(replace1, replace2)
    --details:gsub("(.)", function(c) table.insert(t, c) end)
    for word in details:gmatch('[^,%s]+') do
      table.insert(t, i, word)
      i = i + 1
    end
    return success, details, t
  end
  return success, details
end

print('Connect debug card and get any item.')
term.write('Enter Username [@p]: ')
local err, user = pcall(io.read)
if ((user == '') or (user == nil)) then user = '@p' end

term.write('Enter block or item name [minecraft:command_block]: ')
local err, id = pcall(io.read)
if ((id == '') or (id == nil)) then id = 'minecraft:command_block' end

term.write('Enter amount [1]: ')
local err, amount = pcall(io.read)
if ((amount == '') or (amount == nil)) then amount = 1 end

term.write('Mute executing [yes]: ')
local err, mute = pcall(io.read)
if ((tostring(mute) ~= 'yes') or (tostring(mute) ~= 'y') or (tostring(mute) ~= 'true') or (tostring(mute) ~= 't')) then mute = false
else mute = true end


local _, _, rules = execute('/gamerule', '% and ', ', ')
print('rules: ' .. s.serialize(rules))

execute('/gamerule logAdminCommands')
execute('/gamerule commandBlockOutput')

if (mute) then execute('/gamerule logAdminCommands false') end
if (mute) then execute('/gamerule commandBlockOutput false') end
execute('/give ' .. user .. ' ' .. id .. ' ' .. amount)
if (mute) then execute('/gamerule commandBlockOutput true') end
if (mute) then execute('/gamerule logAdminCommands true') end
