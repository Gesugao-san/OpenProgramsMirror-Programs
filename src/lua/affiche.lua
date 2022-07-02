
local term = require('term')
local fs = require('filesystem')
local ev = require("event")

local path = "/home/affiche.txt"


if not term.isAvailable() then
    term.write('Can\'t write. Stopping.')
    return
end

term.clear()
term.write('Program started.\n')

if not fs.isAutorunEnabled() then
    term.write('Warning: Enabling autorun.')
    fs.setAutorunEnabled(true)
end

if not fs.exists(path) then
    term.write('Please create '..path..'\n')
    term.write('Fatal error: File does not exist. Stopping.')
    return
end

local file = io.open(path) --fs.open(path, 'r')

if file == nil then
    term.write('Can\'t open file. Stopping.')
    return
end

term.write(file:read('*a'))

file:close()

ev.pull("key_down") --term.read()

