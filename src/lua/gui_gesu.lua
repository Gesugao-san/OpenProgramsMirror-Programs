
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
local width, height = gpu.getResolution()
local clrBlack, clrWhite, clrRed, clrGreen, clrBlue = 0x000000, 0xFFFFFF, 0xFF0000, 0x00FF00, 0x0000FF
local clrBlood = 0x333333

local timeout = 0.5
local programName = 'Gesugao-san\'s GUI (develop)'


-- Warning escape for Visual Studio Code — Lua Diagnostics: Undefined field `sleep`.
local function sleep(n)
  os.sleep(n)
end

local function colorsReset()
  gpu.setBackground(clrBlack)
  gpu.setForeground(clrWhite)
end

local function funcDummyButton()
  -- Put your nice code here
end

local function funcButtonExit()
  term.clear()
  os.exit() --do return end
end

local function funcShowNotify()
  local energy, maxEnergy   = computer.energy(),     computer.maxEnergy()
  local memory, totalMemory = computer.freeMemory(), computer.totalMemory()
  local uptime, tmpAddress  = computer.uptime(),     computer.tmpAddress()
  local maxSteps = 10
  local mesuresInOneStep = maxEnergy / maxSteps -- 4500 / 10 = 450
  local step = 1 -- dozen
  local target = tonumber(math.floor(energy))
  local targetWidth = 0
  while (target > 0) do
    target = target - mesuresInOneStep
    targetWidth = targetWidth + 1
  end
  -- local targetWidth = step * (string.len(tostring(math.floor(energy))) - 3) -- 4500 = 4 len
  --print(string.len(tostring(math.floor(energy))))
  colorsReset()
  gpu.set((Buttons.button4.x + Buttons.button4.width + 2 + 4), (Buttons.button4.y), 'Info about this platform:')
  gpu.set((Buttons.button4.x + Buttons.button4.width + 2 + 4), (Buttons.button4.y + 1),
    'Energy: ' .. string.format("%.3f", energy) .. '/'.. tostring(maxEnergy .. ', ' ..
    'Memory: ' .. tostring(memory) .. '/'.. tostring(totalMemory)
  ))

  gpu.setBackground(clrRed)
  gpu.fill((Buttons.button4.x + Buttons.button4.width + 2 + 4), (Buttons.button4.y + 2), maxSteps, 1, ' ')
  gpu.setBackground(clrGreen)
  gpu.fill((Buttons.button4.x + Buttons.button4.width + 2 + 4), (Buttons.button4.y + 2), targetWidth, 1, ' ') -- targetWidth
  colorsReset()

  gpu.set((Buttons.button4.x + Buttons.button4.width + 2 + 4), (Buttons.button4.y + 3),
    'Uptime: ' .. string.format("%.1f", uptime)
  )
  gpu.set((Buttons.button4.x + Buttons.button4.width + 2 + 4), (Buttons.button4.y + 4),
    'Address: '.. tostring(tmpAddress)
  )
end

Buttons = {
  button1 = {  -- width, height
    x = 2,
    y = 1,
    text = '[Options]',
    active = true,
    switchedButton = false,
    autoSwitch = false,
    buttonPressed = false,
    func = funcDummyButton,
    funcToggleable = false,
    funcTriggerPerFrame = false,
    height = 1,
    cFore = clrBlack,
    cBack = clrBlue,
    --cFore1 = clrWhite,
    --cBack1 = clrRed,
  },
  button2 = {  -- width, height
    x = width - 2,
    y = 1,
    text = 'X',
    active = true,
    switchedButton = false,
    autoSwitch = false,
    buttonPressed = false,
    func = funcButtonExit,
    funcToggleable = false,
    funcTriggerPerFrame = false,
    height = 1,
    cFore = clrBlood,
    cBack = clrRed,
    --cFore1 = clrWhite,
    --cBack1 = clrRed,
  },
  button3 = {
    x = 2,
    y = 3,
    text = 'Custom code',
    active = true,
    switchedButton = true,
    autoSwitch = false,
    buttonPressed = false,
    func = funcDummyButton,
    funcToggleable = false,
    funcTriggerPerFrame = false,
    height = 3,
    cFore = clrWhite,
    cBack = clrRed,
    cFore1 = clrBlack,
    cBack1 = clrGreen,
  },
  button4 = {
    x = 2,
    y = 7,
    text = 'Toggle notify',
    active = true,
    switchedButton = false,
    autoSwitch = false,
    buttonPressed = false,
    func = funcShowNotify,
    funcToggleable = true,
    funcTriggerPerFrame = false,
    height = 2,
    cFore = clrWhite,
    cBack = clrBlue,
    --cFore1 = clrBlack,
    --cBack1 = clrGreen,
  },
}

local function initButtons()
  for _, button in pairs(Buttons) do
    button.width = unicode.wlen(button.text) + 2
  end
end

local function drawTaskBar()
  gpu.setBackground(0x555555)
  gpu.fill(1, 1, width, 1, ' ')
  gpu.setForeground(clrBlack)
  gpu.set((width - (string.len(programName) * 2)), (1), programName)
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
  gpu.setForeground(clrWhite)
  gpu.setBackground(clrBlack)
end

local function triggerUpdatable()
  for _, button in pairs(Buttons) do
    if (button.funcTriggerPerFrame) then
      button.func()
    end
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
      if (button.funcToggleable) then
        button.funcTriggerPerFrame = not button.funcTriggerPerFrame
        DrawGraphics()
      end
      button.func()
    end
  end
end

function DrawGraphics()
  term.clear()
  colorsReset()
  drawTaskBar()
  drawButtons()
  triggerUpdatable()
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

