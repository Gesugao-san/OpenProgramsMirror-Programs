
local term          = require('term')
local component     = require('component')
local ev            = require('event')
local serialization = require('serialization')
local fs            = require('filesystem')

local target_type = 'inventory_controller' --'database' --'redstone'

local function table_print(table)
  --term.write(table.serialize())
  term.write(serialization.serialize(table) .. '\n')
  for index, param in pairs(table) do
    print(index .. ': ' .. tostring(param))
  end
end

local function table_save(table)
  for index, param in pairs(table) do
    print(index .. ': ' .. tostring(param))
    local path = '/home/' .. index .. '.txt'
    local file = io.open(path, 'w') --fs.open(path, 'r')
    if file == nil then
      term.write('Can\'t open file. Stopping.\n')
      return
    end
    file:write(tostring(param) .. '\n')
    file:close()
  end
end

for address, componentType in component.list() do
  term.write(address .. ' ' .. componentType .. '\n')
end

local target = component.list(target_type)
table_print(target)
table_save(target)
for _address, _ in pairs(target) do
  target = _address
end
local address = component.get(target.address)
print(address)
local proxy = component.proxy(address)
table_print(proxy)
table_save(proxy)

term.write(proxy.address .. ' ' .. proxy.type)


--[[ local path = '/home/debug.txt'
local file = io.open(path) --fs.open(path, 'r')

if file == nil then
  term.write('Can\'t open file. Stopping.')
  return
end

file:write(serialization.serialize(proxy) .. '\n')
file:close() ]]

--