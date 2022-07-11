
-- OpenComputers 1.6.1.11

local term = require('term')
local component = require("component")
local serialization = require('serialization')
local sides = require("sides")

local running = true
local path = '/home/enter_logger.log'


Target1 = nil
local function find_component(target_type, need_second)
  if need_second == nil then need_second = false end
  local debug = false
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

  --[[ local n = 0
  for address, componentType in components do
    n = n + 1
    if (n == 1) then
      Target1 = component.getPrimary(target_type) -- = component.proxy(address) -- = components[n]
    end
  end ]]
  Target1 = component.getPrimary(target_type) -- = component.proxy(address) -- = components[n]

  if (Target1 == nil) then
    print('Error\nDetails: No component found.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
    if debug then print(serialization.serialize(components)) end
    os.exit() --do return end
  end

  print('Ok\nAddress: ' .. Target1.address) -- .. '\nDebug: ' .. serialization.serialize(Target1))
  if debug then print(serialization.serialize(components)) end

end

find_component('motion_sensor')
find_component('redstone')

local function write_to_file(path, data)
  File = io.open(path, 'a')
  if File == nil then
    print('Error: Can\'t open file "' .. path .. '".')
    os.exit() --do return end
  end
  local result = File:write(data .. '\n')
  File:close()
  if (not result) then
    print('Error: Can\'t write file "' .. path .. '", data: "' .. data .. '".')
    os.exit() --do return end
  end
end

-- https://ocdoc.cil.li/component:signals#motion_sensor_block
local function motion(address, relativeX, relativeY, relativeZ, entityName)
  --local a = string.sub(address, 1, 8)
  --local d = os.date()
  local t = os.time()
  --local vectorSum = x + y + z
  local v = tonumber(string.format("%.3f", math.sqrt(math.abs(relativeX) + math.abs(relativeY) + math.abs(relativeZ)))) --vectorLength
  local x = tonumber(string.format("%.3f", relativeX))
  local y = tonumber(string.format("%.3f", relativeY))
  local z = tonumber(string.format("%.3f", relativeZ))
  print(t .. ' Motion: ' .. entityName)-- .. ' ' .. v .. ' ' .. x .. ' ' .. y .. ' ' .. z)
  write_to_file(path, t .. ' Motion: ' .. entityName)-- .. ' ' .. v .. ' ' .. x .. ' ' .. y .. ' ' .. z)
end

Side1 = nil
Side2 = nil
local function redstone_changed(address, side, oldValue, newValue, color)
  local t = os.time()
  if oldValue == 0 then
    if ((Side1 == nil) and (Side2 == nil)) then
      Side1 = side
    elseif (Side2 == nil) then
      Side2 = side
    end
    print(t .. ' Redstone: ' .. sides[side]) --Side triggered
    write_to_file(path, os.time() .. ' Redstone: ' .. sides[side])
  end

  --if ((Side1 ~= nil) and (Side2 ~= nil)) then
  --  print('Side1: ' .. sides[Side1] .. ', Side2: ' .. sides[Side2])
  --end
  --print(address, side, oldValue, newValue, color)
end


--event.ignore('motion')
--local event_id = event.listen('motion', motion)
write_to_file(path, '[LOG START - ' .. os.date() ..']')
write_to_file(path, '[ Time | Thing | Entity Name ]')
print('Entering loop. Press any key to stop.') -- relative X | relative Y | relative Z | vector Length
print('[ Time | Thing | Entity Name ]')
while running do
  --event.shouldInterrupt = function() return false end -- disable Alt+Ctrl+C
  local event, address, arg1, arg2, arg3, arg4 = term.pull()
  -- if address == term.keyboard() or address == term.screen() then local blink = true end
  if event == 'key_down' then
    print('Stopping...')
    write_to_file(path, '[LOG END - ' .. os.date() .. ']')
    running = false
  elseif event == 'redstone_changed' then
    redstone_changed(address, arg1, arg2, arg3, arg4)
  elseif event == 'motion' then --and not readonly
    motion(address, arg1, arg2, arg3, arg4)
  --else
  --  print('Waiting for moving...')
  end
  --os.sleep(1)
  --running = false
end

--
