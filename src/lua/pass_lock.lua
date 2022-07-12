
-- Lua 5.2; OpenComputers 1.6.1.11;

 -- http://minecraft.fandom.com/ru/wiki/OpenComputers/Программа:_кодовый_замок

-- подключаем необходимые интерфейсы
local term      = require("term")
local sides     = require("sides")
local note      = require("note")
local component = require("component")
local string    = require("string")
-- находим красную плату компьютера
local rs = component.redstone

-- объявляем переменные: пароли и переменную для записи ввода
local password = "mad"
local admin    = "exit"
local seconds  = 3 -- more than 0.6!
local try --, position

-- отключаем сигнал на переднюю панель компьютера (дверь закрыта)
rs.setOutput(sides.south, 0)
-- очищаем терминал
term.clear()

while true do
  -- ввод пароля
  io.write("Enter password: ")
  local err, try = pcall(io.read)
  
  -- если игрок попытался прервать программу
  if not err then
    print("No, no, no!")
  -- если пароль верный
  elseif try == password then
    --position = term.getCursor()
    --print("position:" .. position)
    term.clear() --  term.clearLine()
    io.write("Enter password: ")
    for i = 1, string.len(password), 1 do
      io.write("*")
    end
    -- пускаем сигнал на переднюю сторону компьютера (дверь открыта)
    rs.setOutput(sides.south, 15)
    print("\nOk. " .. seconds .. " seconds!")
    -- воспроизводим звуковой сигнал
    note.play(83, 0.3)
    note.play(90, 0.2)
    -- ожидаем две с половиной секунды
    os.sleep(seconds - 0.5)
    -- закрываем дверь
    rs.setOutput(sides.south, 0)
    print("Locked!")
  -- если введенное слово совпало с администраторским паролем
  elseif try == admin then
    -- прерываем выполнение программы
    break
  -- если была введена команда "cls"
  elseif try == "cls" then
    -- очищаем консоль
    term.clear()
  -- если было введено что-то другое
  else
    -- выводим сообщение, и воспроизводим звук ошибки
    print("Wrong password! Try again.")
    note.play(70, 0.2)
  end
end
