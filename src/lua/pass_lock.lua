
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

 -- http://minecraft.fandom.com/ru/wiki/OpenComputers/Программа:_кодовый_замок

-- connect the necessary interfaces
local term      = require("term")
local sides     = require("sides")
local note      = require("note")
local component = require("component")
local string    = require("string")
-- find the red computer board
local rs = component.redstone

-- declare variables: passwords and a variable to record input
local password = "mad"
local admin    = "exit"
local seconds  = 3 -- more than 0.6!
local try --, position

-- Warning escape for Visual Studio Code — Lua Diagnostics: Undefined field `sleep`.
local function sleep(n)
  os.sleep(n)
end

-- turn off the signal to the front panel of the computer (the door is closed)
rs.setOutput(sides.south, 0)
-- clear the terminal
term.clear()

while true do
  -- password entry
  io.write("Enter password: ")
  local err, try = pcall(io.read)
  
  -- if the player tried to interrupt the program
  if not err then
    print("No, no, no!")
  -- if the password is correct
  elseif try == password then
    --position = term.getCursor()
    --print("position:" .. position)
    term.clear() --  term.clearLine()
    io.write("Enter password: ")
    for i = 1, string.len(password), 1 do
      io.write("*")
    end
    -- we send a signal to the front side of the computer (the door is open)
    rs.setOutput(sides.south, 15)
    print("\nOk. " .. seconds .. " seconds!")
    -- play sound signal
    note.play(83, 0.3)
    note.play(90, 0.2)
    -- wait two and a half seconds
    sleep(seconds - 0.5)
    -- close the door
    rs.setOutput(sides.south, 0)
    print("Locked!")
  -- if the entered word matches the administrator password
  elseif try == admin then
    -- interrupt program execution
    break
  -- if the "cls" command was entered
  elseif try == "cls" then
    -- clearing the console
    term.clear()
  -- if something else was entered
  else
    -- display a message and play the error sound
    print("Wrong password! Try again.")
    note.play(70, 0.2)
  end
end
