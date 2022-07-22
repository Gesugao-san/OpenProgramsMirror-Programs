
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

local robot = require('robot')
local computer = require('computer')


-- Warning escape for Visual Studio Code — Lua Diagnostics: Undefined field `sleep`.
local function sleep(n)
  os.sleep(n)
end

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

function Main()
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
  
    sleep(30)
  end
end


if not package.loaded['modulename'] then return Main() --[[ main case ]] else return Main --[[ module case ]] end

