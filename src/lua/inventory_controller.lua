
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

local component, sides, s = require('component'), require('sides'), require('serialization')
local inventory_controller = component.inventory_controller
if inventory_controller == nil then do return end end


print('inventory_controller methods: ' .. s.serialize(component.methods(inventory_controller.address)))

local _side = -1
print('Searching side...')
for side = 0, 5, 1 do
  local countEmpty, countOk = 0, 0
  local InventorySize = inventory_controller.getInventorySize(side)
  if InventorySize then
    print('InventorySize(' .. side .. '): ' .. s.serialize(InventorySize))
  --[[ else
    print('InventorySize(' .. side .. ') is empty') ]]
    for slot = 1, InventorySize, 1 do
      local item = inventory_controller.getStackInSlot(side, slot)
      if item then
        countOk = countOk + 1
        print("Item id: ", item.id)
        print("Item name: ", item.name)
        print("Item label: ", item.label)
        print("Item count: ", item.size)
        print("Item damage: ", item.damage)
        print("Item maxDamage: " .. item.maxDamage)
        print("Item size: ", item.size)
        print("Item maxSize: ", item.maxSize)
      else
        countEmpty = countEmpty + 1
        --print("Slot " .. slot .. " is empty")
      end
    end
    _side = side
  end
  print('Side ' .. side .. ' (' .. sides[side] .. ')', ': ' .. countEmpty .. ' empty slots, ' .. countOk .. ' filled slots')
end

if (_side == -1) then
  print('Error: Can\'t find _side.')
  return
end

