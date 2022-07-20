
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

-- http://youtu.be/qI46IvQL9X4 http://pastebin.com/6QDe4kZH
-- pastebin get 6QDe4kZH Buttons

local component = require('component')
local computer = require('computer')
local unicode = require('unicode')
local event = require('event')
local term = require('term')
local gpu = component.gpu
local redstone = component.redstone
local width, height = gpu.getResolution()

local timeout = 1


-- Escape for Visual Studio Code — Lua Diagnostics: Undefined field `sleep`.
local function sleep(n)
  os.sleep(n)
end

-- table.insert(foo, "bar")
--[[ local function tableInsert(table, data)
  table[#table + 1] = data
  return table
end ]]

local function funcYourCodeButton()
  -- Put your nice code here
end

local function funcButtonExit()
  term.clear()
  os.exit() --do return end
end

local function funcAddToUpdateToggle(table, data)
  if not table then do return end end
  if table[data] then
    table.remove(table, data)
    print('Removed: ' .. tostring(table) .. ', ' .. tostring(data))
  else
    table.insert(table, data)
    print('Added: ' .. tostring(table) .. ', ' .. tostring(data))
  end
end

local function funcShowNotify()
  gpu.set((Buttons.button1.x + Buttons.button1.width + 2 + 4), (Buttons.button1.y), 'Information about this platform:')
  gpu.set((Buttons.button1.x + Buttons.button1.width + 2 + 4), (Buttons.button1.y + 1), 
    'Energy: ' .. string.format("%.3f", computer.energy()) .. '/'.. tostring(computer.maxEnergy() .. ', ' ..
    'Memory: ' .. tostring(computer.freeMemory()) .. '/'.. tostring(computer.totalMemory())
  ))
  gpu.set((Buttons.button1.x + Buttons.button1.width + 2 + 4), (Buttons.button1.y + 2), 
    'Uptime: ' .. string.format("%.1f", computer.uptime())
  )
  gpu.set((Buttons.button1.x + Buttons.button1.width + 2 + 4), (Buttons.button1.y + 3), 
    'Address: '.. tostring(computer.tmpAddress())
  )
end

local function funcShowBadButton()
  sleep(4)
  for _, button in pairs(Buttons) do
    button.active = false
  end
  Buttons.button3.active = true
  DrawGraphics()
end

local function funcSendRedstone()
  sleep(4)
  redstone.setOutput(0, 255)
  funcButtonExit()
end


Buttons = {
  button = {
    x = 2,
    y = 3,
    text = 'Custom code',
    active = true,
    switchedButton = true,
    autoSwitch = false,
    buttonPressed = false,
    func = funcYourCodeButton,
    func_args = nil,
    height = 3,
    cFore = 0xFFFFFF,
    cBack = 0xFF0000,
    cFore1 = 0x000000,
    cBack1 = 0x00FF00,
  },
  button1 = {
    x = 2,
    y = 7,
    text = 'Show notify',
    active = true,
    switchedButton = false,
    autoSwitch = false,
    buttonPressed = false,
    func = funcShowNotify, -- funcAddToUpdateToggle
    func_args = nil, -- DataToUpdate, funcShowNotify,
    height = 2,
    cFore = 0xFFFFFF,
    cBack = 0x0000FF,
    --cFore1 = 0x000000,
    --cBack1 = 0x00FF00,
  },
  button2 = {
    x = 2,
    y = 10,
    text = 'Show bad button',
    active = true,
    switchedButton = true,
    autoSwitch = true,
    buttonPressed = false,
    func = funcShowBadButton,
    func_args = nil,
    height = 4,
    cFore = 0xFFFFFF,
    cBack = 0x222200,
    cFore1 = 0xFFFFFF,
    cBack1 = 0x002222,
  },
  button3 = {
    x = 2,
    y = 15,
    text = 'Do not touch!',
    active = false,
    switchedButton = true,
    autoSwitch = false,
    buttonPressed = false,
    func = funcSendRedstone,
    func_args = nil,
    height = 5,
    cFore = 0x333333,
    cBack = 0xFF0000,
    cFore1 = 0xFFFFFF,
    cBack1 = 0xFF0000,
  },
  button4 = {  -- width, height
    x = width - 2,
    y = 1,
    text = 'X',
    active = true,
    switchedButton = false,
    autoSwitch = false,
    buttonPressed = false,
    func = funcButtonExit,
    func_args = nil,
    height = 1,
    cFore = 0x333333,
    cBack = 0xFF0000,
    cFore1 = 0xFFFFFF,
    cBack1 = 0xFF0000,
  },
}

DataToUpdate = {}

local function initButtons()
  for _, button in pairs(Buttons) do
    button.width = unicode.wlen(button.text) + 2
  end
end

local function drawBar()
  gpu.setBackground(0x555555)
  --gpu.setForeground(0x555555)
  gpu.fill(1, 1, width, 1, ' ')
end

local function drawButtons()
  for _, button in pairs(Buttons) do
    if (button.active) then
      if (not button.buttonPressed) then
        gpu.setForeground(button.cFore)
        gpu.setBackground(button.cBack)
      else
        gpu.setForeground(button.cFore1)
        gpu.setBackground(button.cBack1)
      end
      gpu.fill(button.x, button.y, button.width, button.height, ' ') -- set button Background
      if (button.height == 1) then
        gpu.set(button.x + 1, button.y, button.text)
      elseif ((button.height % 2) == 0) then   -- if button height is an even number
        gpu.set(button.x + 1, button.y + (button.height / 2 - 1), button.text)
      elseif ((button.height % 2) == 1) then   -- if button height is odd number
        gpu.set(button.x + 1, button.y + (math.ceil(button.height / 2) - 1), button.text)
      end
      if ((button.autoSwitch == true) and (button.buttonPressed == true)) then
        button.buttonPressed = false
        sleep(4)
        DrawGraphics()
      end
    end
  end
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x000000)
end

local function drawUpdateble()
  for _, func in pairs(DataToUpdate) do
    func()
  end
end

local function searchButton()
  local name, _, x, y = event.pull(timeout, 'touch') -- name, address, x, y
  if name == nil then DrawGraphics(); do return end end
  for _, button in pairs(Buttons) do
    if ((x >= button.x) and (x < button.x + button.width + 2) and (y >= button.y) and (y < button.y + button.height) and (button.active)) then
      if (button.switchedButton == true) then
        if (not button.autoSwitch) then
          if (button.buttonPressed == false) then
            button.buttonPressed = true
          else
            button.buttonPressed = false
          end
        else
          button.buttonPressed = true
        end
        DrawGraphics()
      end
      button.func(button.func_args)
    end
  end
end

function DrawGraphics(clear)
  if (clear == nil) then clear = true end
  if (clear) then term.clear() end
  drawBar()
  drawButtons()
  drawUpdateble()
end


function Main()
  computer.beep()
  initButtons()
  DrawGraphics()
  while true do
    searchButton()
  end
  os.exit() --do return end
end


if not package.loaded['modulename'] then return Main() --[[ main case ]] else return Main --[[ module case ]] end

