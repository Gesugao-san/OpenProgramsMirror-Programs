
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

local component, term, s, io = require('component'), require('term'), require('serialization'), require('io')
local debug_card = component.debug
if debug_card == nil then do return end end
Rules = {}


local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function is_in_table(table, target)
  local is_in = false
  if ((tablelength(table) == 0) and (target == '/gamerule')) then
    print('Warning: List of rules empty. Passing.')
    is_in = true
    return is_in
  end
  for _, v in pairs(table) do
    if v == target then
      is_in = true
      break
    end
  end
  return is_in
end

local function execute(command, replace)
  print(command) -- Executing

  if string.find(command, '/gamerule ') then
    if (not is_in_table(Rules, command:gsub('%/gamerule ', ''))) then
      local details = 'Error: Command "' .. command:gsub('%/gamerule ', '') .. '" not in the avaliable rules list.'
      print(details)
      return false, details
    end
  end

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

  if (replace == true) then
    local t, i = {}, 1
    details = details:gsub('% and ', ', ')
    --details:gsub("(.)", function(c) table.insert(t, c) end)
    for word in details:gmatch('[^,%s]+') do
      table.insert(t, i, word)
      i = i + 1
    end
    return success, details, t
  end
  return success, details
end

local function get_rules(rules)
  local _, _, rules = execute('/gamerule', true)
  return rules
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


Rules = get_rules(Rules)

execute('/gamerule logAdminCommands')
execute('/gamerule commandBlockOutput')

if (mute) then execute('/gamerule logAdminCommands false') end
if (mute) then execute('/gamerule commandBlockOutput false') end
execute('/give ' .. user .. ' ' .. id .. ' ' .. amount)
if (mute) then execute('/gamerule commandBlockOutput true') end
if (mute) then execute('/gamerule logAdminCommands true') end
