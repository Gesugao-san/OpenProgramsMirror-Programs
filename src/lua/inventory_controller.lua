
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

local component, term, s, io = require('component'), require('term'), require('serialization'), require('io')
local inventory_controller = component.inventory_controller
if inventory_controller == nil then do return end end


print('inventory_controller methods: ' .. s.serialize(component.methods(inventory_controller.address)))

local side = -1
print('Searching side...')
for i = 0, 5, 1 do
  local InventorySize = inventory_controller.getInventorySize(i)
  print('InventorySize(' .. i .. '): ' .. s.serialize(InventorySize))
end

if (side == -1) then
  print('Error: Can\'t find side.')
  return
end

