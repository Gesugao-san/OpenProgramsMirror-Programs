
local term = require('term')
local component = require("component")
local serialization = require('serialization')
local event = require('event')


local function find_component(target_type)
  term.write('Finding component: "' .. target_type .. '" . . . ')
  if (not component.isAvailable(target_type)) then
    print('Error\nDetails: Component isn\'t available.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
    do return end
  end

  --[[ local components = component.list(target_type)
  if (next(components) == nil) then
    print('Error: No component "' .. target_type .. '" found.')
    do return end
  end ]]

  local target = component.getPrimary(target_type) --components[0]
  if (target == nil) then
    print('Error\nDetails: No component found.\nSolution: Check is component name correct, connected to the operated computer case and then try again.')
    do return end
  end

  print('Ok\nAddress: ' .. target.address .. '\nDebug: ' .. serialization.serialize(target))
end


find_component('motion_sensor1')
print('')
find_component('motion_sensor')
print('')

