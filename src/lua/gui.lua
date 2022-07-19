
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

-- http://ocdoc.cil.li/component:gpu

local ev = require('event')
local os = require('os')
local component = require("component")
local gpu = component.gpu -- get primary gpu component
local w, h = gpu.getResolution()

local function sleep(n)
  os.sleep(n)
end

gpu.fill(1, 1, w, h, " ") -- clears the screen
sleep(0.1)
gpu.setForeground(0x000000)
sleep(0.1)
gpu.setBackground(0xFFFFFF)
sleep(0.1)
gpu.fill(1, 1, w/2, h/2, "X") -- fill top left quarter of screen
sleep(0.1)
gpu.copy(1, 1, w/2, h/2, w/2, h/2) -- copy top left quarter of screen to lower right
sleep(0.1)


--print('Press any key to close.')
ev.pull('key_down') --term.read()
require('term').clear()
gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ")
return

