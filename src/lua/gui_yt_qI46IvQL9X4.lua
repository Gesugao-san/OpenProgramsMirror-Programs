
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
  -- Здесь мог бы быть Ваш шикарнейший код
end

local function funcButton1()
  gpu.set(Buttons.button1.x + Buttons.button1.width + 2 + 4 , Buttons.button1.y, "Кнопка нажата")
end

local function funcButton2()
  sleep(4)
  for k,v in pairs(Buttons) do
  v.active = false
  end
  Buttons.button3.active = true
  term.clear()
  DrawButtons()
end

local function funcDont_Touch()
  sleep(4)
  redstone.setOutput(0, 255)
end

Buttons = {button =  {x=2, y=2, text="button", active=true, switchedButton = true, autoSwitch=false, buttonPressed = false, func = funcButton, height=3, cFore = 0xFFFFFF, cBack = 0xFF0000, cFore1 = 0x000000, cBack1 = 0x00FF00},
  button1 = {x=16, y=4, text="button1", active=true, switchedButton = false, autoSwitch=false, buttonPressed = false, func = funcButton1, height=2, cFore = 0xFFFFFF, cBack = 0x0000FF},
  button2 = {x=4, y=16, text="button2", active=true, switchedButton = true, autoSwitch=true, buttonPressed = false, func = funcButton2, height=4, cFore = 0xFFFFFF, cBack = 0xFFFF00, cFore1 = 0xFFFFFF, cBack1 = 0x00FFFF},
  button3 = {x=72, y=24, text="Не нажимать!", active=false, switchedButton = true, autoSwitch=false, buttonPressed = false, func = funcDont_Touch, height=5, cFore = 0x333333, cBack = 0xFF0000, cFore1 = 0xFFFFFF, cBack1 = 0xFF0000}}

local function initButtons()
  for k,v in pairs(Buttons) do
    v.width = unicode.wlen(v.text) + 2
  end
end

initButtons()

function DrawButtons()
  for k,v in pairs(Buttons) do
    if v.active then
      if not v.buttonPressed then -- если кнопка не нажата
        gpu.setForeground(v.cFore)
        gpu.setBackground(v.cBack)
      else                      -- в ином случае
        gpu.setForeground(v.cFore1)
        gpu.setBackground(v.cBack1)
      end
      gpu.fill(v.x, v.y, v.width, v.height, " ") -- фон для кнопки
      if v.height == 1 then         -- если высота кнопки равна 1
        gpu.set(v.x+1, v.y, v.text)
      elseif v.height%2 == 0 then   -- если высота кнопки равна четному числу
        gpu.set(v.x+1, v.y + (v.height/2 - 1), v.text)
      elseif v.height%2 == 1 then   -- если высота кнопки равна нечетному числу
        gpu.set(v.x+1, v.y + (math.ceil(v.height/2) - 1), v.text)
      end
      if v.autoSwitch == true and v.buttonPressed == true then
        v.buttonPressed = false
        sleep(4)
        DrawButtons()
      end
    end
  end
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x000000)
end

local function searchButton()
  while true do
    local _,_,x,y = event.pull("touch")
    for k,v in pairs(Buttons) do
      if x >= v.x and x < v.x + v.width+2 and y >= v.y and y < v.y + v.height and v.active then
        if v.switchedButton == true then
          if not v.autoSwitch then
            if v.buttonPressed == false then
              v.buttonPressed = true
            else
              v.buttonPressed = false
            end
          else
            v.buttonPressed = true
          end
          term.clear()
          DrawButtons()
        end
        v.func()
      end
    end
  end
end

DrawButtons()
searchButton()

