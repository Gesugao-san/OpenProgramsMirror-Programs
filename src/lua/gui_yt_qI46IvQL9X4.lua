
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

-- http://youtu.be/qI46IvQL9X4 http://pastebin.com/6QDe4kZH
-- pastebin get 6QDe4kZH Buttons

local component = require("component")
local event = require("event")
local gpu = component.gpu
local redstone = component.redstone
local unicode = require("unicode")
local term = require("term")


local function sleep(n)
  os.sleep(n)
end

local function funcButton()
  -- Put your nice code here
end

local function funcButton1()
  gpu.set((Buttons.button1.x + Buttons.button1.width + 2 + 4), Buttons.button1.y, "Кнопка нажата")
end

local function funcButton2()
  sleep(4)
  for _, button in pairs(Buttons) do
    button.active = false
  end
  Buttons.button3.active = true
  term.clear()
  DrawButtons()
end

local function funcDont_Touch()
  sleep(4)
  redstone.setOutput(0, 255)
end

Buttons = {
  button  = {
    x = 2,
    y = 2,
    text = "Your code",
    active = true,
    switchedButton = true,
    autoSwitch = false,
    buttonPressed = false,
    func = funcButton,
    height = 3,
    cFore = 0xFFFFFF,
    cBack = 0xFF0000,
    cFore1 = 0x000000,
    cBack1 = 0x00FF00,
  },
  button1 = {
    x = 16,
    y = 4,
    text = "Notify",
    active = true,
    switchedButton = false,
    autoSwitch = false,
    buttonPressed = false,
    func = funcButton1,
    height = 2,
    cFore = 0xFFFFFF,
    cBack = 0x0000FF,
    --cFore1 = 0x000000,
    --cBack1 = 0x00FF00,
  },
  button2 = {
    x = 4,
    y = 16,
    text = "Show bad button",
    active = true,
    switchedButton = true,
    autoSwitch = true,
    buttonPressed = false,
    func = funcButton2,
    height = 4,
    cFore = 0xFFFFFF,
    cBack = 0xFFFF00,
    cFore1 = 0xFFFFFF,
    cBack1 = 0x00FFFF,
  },
  button3 = {
    x = 72,
    y = 24,
    text = "Не нажимать!",
    active = false,
    switchedButton = true,
    autoSwitch = false,
    buttonPressed = false,
    func = funcDont_Touch,
    height = 5,
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

function DrawButtons()
  term.clear()
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
        DrawButtons()
      end
    end
  end
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x000000)
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
  initButtons()
  DrawButtons()
  while true do
    searchButton()
  end
  os.exit() --do return end
end


if not package.loaded['modulename'] then return Main() --[[ main case ]] else return Main --[[ module case ]] end

