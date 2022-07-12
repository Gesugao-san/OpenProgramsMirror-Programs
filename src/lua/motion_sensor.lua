
-- Lua 5.2; OpenComputers 1.6.1.11;

--[[ for i = 1, 3, 1 do
  print(i)
  os.sleep(1)
end ]]
--if debug then print('component.getPrimary(target_type): ' .. serialization.serialize(component.getPrimary(target_type))) end
--if debug then print(serialization.serialize(components)); print(serialization.serialize(pairs(components))) end

local term = require('term')
local component = require("component")
local serialization = require('serialization')
local event = require('event')
--local os = require('os')

local fs = require("filesystem")
local keyboard = require("keyboard")
local shell = require("shell")
local text = require("text")
local unicode = require("unicode")

local running = true
Target1 = nil
Target2 = nil


local function find_component(target_type, need_second)
  if need_second == nil then need_second = false end
  local debug = true
  term.write('Finding component: "' .. target_type .. '"... ')
  if (not component.isAvailable(target_type)) then
    print('Error\nDetails: Component isn\'t available.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
    os.exit() --do return end
  end

  local components = component.list(target_type)
  if (next(components) == nil) then
    print('Error: List of searched components is empty.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
    if debug then print('components:' .. serialization.serialize(components)) end
    os.exit() --do return end
  end

  local n = 0
  for address, componentType in components do
    n = n + 1
    if (n == 1) then
      Target1 = component.getPrimary(target_type) -- = component.proxy(address) -- = components[n]
    elseif ((need_second) and (n == 2)) then
      Target2 = component.proxy(address) --components[n]
      break
    end
  end

  if (Target1 == nil) then
    print('Error\nDetails: No component found.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
    if debug then print(serialization.serialize(components)) end
    os.exit() --do return end
  end

  if need_second then
    if (components[1] == nil) then
      print('Error\nDetails: No component found.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
        if debug then print(serialization.serialize(components)) end
      os.exit() --do return end
    end
    Target2 = components[1]
    print('Ok\nTarget1: Address: ' .. Target1.address .. '\nDebug: ' .. serialization.serialize(Target1))
    if Target1 ~= nil then print('Target2: Address: ' .. Target2.address .. '\nDebug: ' .. serialization.serialize(Target2)) end
  else
    print('Ok\nAddress: ' .. Target1.address .. '\nDebug: ' .. serialization.serialize(Target1))
  end
  if debug then print(serialization.serialize(components)) end

end

find_component('motion_sensor')
print('')

-- https://ocdoc.cil.li/component:signals#motion_sensor_block
local function motion(address, relativeX, relativeY, relativeZ, entityName)
  local a = string.sub(address, 1, 8)
  --local vectorSum = x + y + z
  local v = tonumber(string.format("%.3f", math.sqrt(math.abs(relativeX) + math.abs(relativeY) + math.abs(relativeZ)))) --vectorLength
  local x = tonumber(string.format("%.3f", relativeX))
  local y = tonumber(string.format("%.3f", relativeY))
  local z = tonumber(string.format("%.3f", relativeZ))
  print(a .. ' | ' .. entityName .. ' | ' .. v .. ' | ' .. x .. ' | ' .. y .. ' | ' .. z)
end


--event.ignore('motion')
--local event_id = event.listen('motion', motion)
print('Entering loop. Press any key to stop.')
print('HWID | relative X | relative Y | relative Z | entity Name | vector Length')
while running do
  --event.shouldInterrupt = function() return false end -- disable Alt+Ctrl+C
  local event, address, arg1, arg2, arg3, arg4 = term.pull()
  -- if address == term.keyboard() or address == term.screen() then local blink = true end
  if event == "key_down" then
    print('Stopping...')
    running = false
  elseif event == "motion" then --and not readonly 
    motion(address, arg1, arg2, arg3, arg4)
  else
    print('Waiting for moving...')
  end
  --os.sleep(1)
  --running = false
end

--
