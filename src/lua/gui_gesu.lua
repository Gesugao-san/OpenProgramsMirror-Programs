
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

-- http://youtu.be/qI46IvQL9X4 http://pastebin.com/6QDe4kZH
-- pastebin get 6QDe4kZH Buttons

local component = require("component")
local computer = require("computer")
local unicode = require("unicode")
local event = require("event")
local term = require("term")
local width, height = gpu.getResolution()
local gpu = component.gpu
local redstone = component.redstone


-- Escape for Visual Studio Code — Lua Diagnostics: Undefined field `sleep`.
local function sleep(n)
  os.sleep(n)
end

local function funcYourCodeButton()
  -- Put your nice code here
end

local function funcButtonExit()
  term.clear()
  os.exit() --do return end
end

local function funcShowNotify()
  gpu.set((Buttons.button1.x + Buttons.button1.width + 2 + 4), Buttons.button1.y, "The button was pressed!")
end

local function funcShowBadButton()
  sleep(4)
  for _, button in pairs(Buttons) do
    button.active = false
  end
  Buttons.button3.active = true
  DrawButtons()
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
    text = "Custom code",
    active = true,
    switchedButton = true,
    autoSwitch = false,
    buttonPressed = false,
    func = funcYourCodeButton,
    height = 3,
    cFore = 0xFFFFFF,
    cBack = 0xFF0000,
    cFore1 = 0x000000,
    cBack1 = 0x00FF00,
  },
  button1 = {
    x = 2,
    y = 7,
    text = "Show notify",
    active = true,
    switchedButton = false,
    autoSwitch = false,
    buttonPressed = false,
    func = funcShowNotify,
    height = 2,
    cFore = 0xFFFFFF,
    cBack = 0x0000FF,
    --cFore1 = 0x000000,
    --cBack1 = 0x00FF00,
  },
  button2 = {
    x = 2,
    y = 10,
    text = "Show bad button",
    active = true,
    switchedButton = true,
    autoSwitch = true,
    buttonPressed = false,
    func = funcShowBadButton,
    height = 4,
    cFore = 0xFFFFFF,
    cBack = 0x222200,
    cFore1 = 0xFFFFFF,
    cBack1 = 0x002222,
  },
  button3 = {
    x = 2,
    y = 15,
    text = "Do not touch!",
    active = false,
    switchedButton = true,
    autoSwitch = false,
    buttonPressed = false,
    func = funcSendRedstone,
    height = 5,
    cFore = 0x333333,
    cBack = 0xFF0000,
    cFore1 = 0xFFFFFF,
    cBack1 = 0xFF0000,
  },
  button4 = {  -- width, height
    x = width - 2,
    y = 1,
    text = "X",
    active = true,
    switchedButton = false,
    autoSwitch = false,
    buttonPressed = false,
    func = funcButtonExit,
    height = 1,
    cFore = 0x333333,
    cBack = 0xFF0000,
    cFore1 = 0xFFFFFF,
    cBack1 = 0xFF0000,
  },
}

local function initButtons()
  for _, button in pairs(Buttons) do
    button.width = unicode.wlen(button.text) + 2
  end
end

local function drawBar()
  gpu.setBackground(0x555555)
  --gpu.setForeground(0x555555)
  gpu.fill(1, 1, width, 1, " ")
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
      gpu.fill(button.x, button.y, button.width, button.height, " ") -- set button Background
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

function DrawGraphics()
  term.clear()
  drawBar()
  drawButtons()
end

local function searchButton()
  local _, _, x, y = event.pull("touch")
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
        DrawButtons()
      end
      button.func()
    end
  end
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

