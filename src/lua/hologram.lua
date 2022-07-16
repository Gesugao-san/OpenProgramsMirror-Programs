
-- Lua 5.2; OpenComputers 1.6.1.11;



local term = require('term')
local component = require("component")
local serialization = require('serialization')
local os = require('os')


local function find_component(target_type, need_second)
  local debug = true
  term.write('Finding component: "' .. target_type .. '"... ')
  if (not component.isAvailable(target_type)) then
    print('Error\nDetails: Component isn\'t available.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
    do return end
  end

  local components = component.list(target_type)
  if (next(components) == nil) then
    print('Error: List of searched components is empty.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
    if debug then print('components:' .. serialization.serialize(components)) end
    do return end
  end

  local n = 0
  for address, componentType in components do
    n = n + 1
    if (n == 1) then
      Target1 = component.getPrimary(target_type) -- = component.proxy(address) -- = components[n]
      if debug then print('Target1: ' .. serialization.serialize(Target1.address)) end
    elseif ((need_second) and (n == 2)) then
      Target2 = component.proxy(address) --components[n]
      if debug then print('Target2: ' .. serialization.serialize(Target2.address)) end
      break
    end
  end

  if need_second then
    Target1 = components[0]
  else
    Target1 = component.getPrimary(target_type) --components[0]
  end
  if debug then print('Target1: ' .. serialization.serialize(Target1)) end
  if (Target1 == nil) then
    print('Error\nDetails: No component found.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
    if debug then print(serialization.serialize(components)) end
    do return end
  end

  if need_second then
    if (components[1] == nil) then
      print('Error\nDetails: No component found.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
        if debug then print(serialization.serialize(components)) end
      do return end
    end
    Target2 = components[1]
    print('Ok\nTarget1: Address: ' .. Target1.address .. '\nDebug: ' .. serialization.serialize(Target1))
    print('Target2: Address: ' .. Target2.address .. '\nDebug: ' .. serialization.serialize(Target2))
  else
    print('Ok\nAddress: ' .. Target1.address .. '\nDebug: ' .. serialization.serialize(Target1))
  end
  if debug then print(serialization.serialize(components)) end

end



find_component('hologram')
print('')
if Target1 == nil then do return end end

print('Target1.maxDepth:' .. serialization.serialize(Target1.maxDepth()))
print('Target1.getScale:' .. serialization.serialize(Target1.getScale()))
local block_length = 16

Target1.clear()
-- Target1.setScale(0.3) -- 1х1х1
if Target1.setRotationSpeed(0, 1, 1, 1) then
  print('setRotationSpeed - Ok?')
else
  print('setRotationSpeed - Error?')
end

if Target1.setRotationSpeed(1, 0, 0, 1) then
  print('setRotationSpeed - Ok?')
else
  print('setRotationSpeed - Error?')
end

local function block_make(offset_x, offset_y, offset_z, data)
  for x = offset_x + 1, offset_x + 16, 1 do
    for y = offset_y + 9, offset_y + 24, 1 do
      for z = offset_z + 1, offset_z + 16, 1 do
        Target1.set(x, y, z, data or math.random(0, 1))
        -- if (math.fmod(x, 4) == 0) then end
      end
    end
    os.sleep(0.01)
  end
end

local function block_empty(offset_x, offset_y, offset_z)
  for x = offset_x + 2, offset_x + 15, 1 do
    for y = offset_y + 10, offset_y + 23, 1 do
      for z = offset_z + 2, offset_z + 15, 1 do
        Target1.set(x, y, z, false)
        -- if (math.fmod(x, 4) == 0) then end
      end
    end
    os.sleep(0.01)
  end
  
end


local block_count = block_length * 2
for offset_x = 0, block_count, block_length do
  for offset_y = 0, 0, block_length do
    for offset_z = 0, block_count, block_length do
      block_make(offset_x, offset_y, offset_z)
      block_empty(offset_x, offset_y, offset_z)
    end
  end
end

os.sleep(3)

for offset_x = 0, block_count, block_length do
  for offset_y = 0, 0, block_length do
    for offset_z = 0, block_count, block_length do
      block_make(offset_x, offset_y, offset_z, 0)
    end
  end
end

Target1.clear()


