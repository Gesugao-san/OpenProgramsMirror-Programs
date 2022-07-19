
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

 -- http://minecraft.fandom.com/ru/wiki/OpenComputers/Туториал:_Работаем_с_дисками
local fs = require('filesystem')
local proxy = ...
fs.mount(proxy, '/test')
