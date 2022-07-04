
local term = require('term')
local component = require('component')
local ev = require('event')

--local components = components.list()


--[[ for address, componentType in components do
    term.write(address)
    ev.pull('key_down')
end ]]

local var = component.get("b679ea9")
term.write(var == nil)
if var == nil then
    term.write('yes')
else
    term.write('no')
end
term.write(var)
