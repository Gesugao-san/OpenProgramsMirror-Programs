
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

 -- http://minecraft.fandom.com/ru/wiki/OpenComputers/Робот-дровосек
local robot = require("robot")
local comp = require("computer")


local function jack()
  while robot.detect() do
    if not robot.up() then
    robot.swingUp()
    robot.up()
  end
  end
  while not robot.detectDown() do
    robot.down()
  robot.swing()
  end
  robot.place()
  robot.up()
end

local function unload()
  robot.turnAround()
  robot.down()
  for c = 2, 16 do
    robot.select(c)
    if robot.count() > 0 then
      robot.drop()
    end
  end
  robot.select(1)
  robot.up()
  robot.turnAround()
end

while true do
  robot.up()
  if robot.detect() then
    jack()
    if robot.count(2) == 64 then
      unload()
    end
  end
  robot.down()

  if comp.energy() < 10 then
    print("Error! Low energy level.")
    break
  end

  os.sleep(30)
end