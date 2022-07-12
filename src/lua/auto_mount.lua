
-- Lua 5.2; OpenComputers 1.6.1.11;

 -- http://minecraft.fandom.com/ru/wiki/OpenComputers/Туториал:_Работаем_с_дисками
local fs = require('filesystem')
local proxy = ...
fs.mount(proxy, '/test')
