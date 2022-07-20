
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

local component, sides, s, io = require('component'), require('sides'), require('serialization'), require('io')
local tank_controller = component.tank_controller
if tank_controller == nil then do return end end


print('tank_controller methods: ' .. s.serialize(component.methods(tank_controller.address)))

local side = -1
print('Searching side...')
for i = 0, 5, 1 do
  local FluidInTank, TankCapacity, TankLevel = tank_controller.getFluidInTank(i)['n'], tank_controller.getTankCapacity(i), tank_controller.getTankLevel(i)
  if ((math.abs(FluidInTank) + math.abs(TankCapacity) + math.abs(TankLevel)) > 0) then
    print('Side found! Side: ' .. sides[i] .. ' (' .. i .. ')')
    side = i
    print('getFluidInTank(' .. i .. '): ' .. s.serialize(FluidInTank))
    print('getTankCapacity(' .. i .. '): ' .. s.serialize(TankCapacity))
    print('getTankLevel(' .. i .. '): ' .. s.serialize(TankLevel))
    --break
  else
    print('Side ' .. sides[i] .. ' (' .. i .. ') seems empty...')
  end
end

if (side == -1) then
  print('Error: Can\'t find side.')
  return
end

