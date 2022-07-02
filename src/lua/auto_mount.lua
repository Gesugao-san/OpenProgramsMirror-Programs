
 -- http://minecraft.fandom.com/ru/wiki/OpenComputers/Туториал:_Работаем_с_дисками
local fs = require('filesystem')
local proxy = ...
fs.mount(proxy, '/test')
