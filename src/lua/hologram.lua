
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

Target1.clear()
-- Target1.setScale(0.3) -- 1х1х1
if Target1.setRotationSpeed(0, 1, 0, 0) then
  print('setRotationSpeed - Ok?')
else
  print('setRotationSpeed - Error?')
end

if Target1.setRotationSpeed(1, 1, 0, 0) then
  print('setRotationSpeed - Ok?')
else
  print('setRotationSpeed - Error?')
end

for x = 1, 16, 1 do
  for y = 9, 24, 1 do
    for z = 1, 16, 1 do
      Target1.set(x, y, z, true)
    end
    os.sleep(0.05)
  end
end



