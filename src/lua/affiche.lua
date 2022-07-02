
local term = require('term')
local fs = require('filesystem')
local sz = require('serialization')

local path = '/home/affiche.txt'


if not term.isAvailable() then
    term.write('Can\'t write. Stopping.')
    return
end

term.clear()
term.write('Program started.')

if not fs.isAutorunEnabled() then
    term.write('Enabling autorun.')
    fs.setAutorunEnabled(true)
end

if not fs.exists(path) then
    term.write(sz.serialize(path, 'does not exist. Stopping.'))
    return
end

local file = fs.open(path, 'r')

if file == nil then
    term.write('Can\'t open file. Stopping.')
    return
end

term.write(file)

file.close()

