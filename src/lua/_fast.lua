
-- Environment: Lua 5.2 - 5.3; OpenComputers 1.6.1.11;
-- Platform requirements: N\A
-- Command: rm 1.lua&&edit 1.lua&&1

C = require('component'); S = require('serialization')

function debug(type)
  if type == nil then print('no "' .. type .. '"'); do return end end
  if next(C.list(type)) == nil then print('no "' .. type .. '" in list'); do return end end
  X = C.getPrimary(type)
  if X == nil then print('no getPrimary "' .. type .. '"'); do return end end
  print('type: "' .. type .. '", address: ' .. X.address)
  M = C.methods(X.address)
  MM = {}; N = 0
  for k, v in pairs(M) do N = N + 1; MM[N] = k end
  print('Methods: ' .. S.serialize(MM):gsub('{', ''):gsub('}', '')) -- print(S.serialize(M))
  --write_to_file('/home/_fast.txt', 'Methods: ' .. S.serialize(MM))
  for method, _ in pairs(C.methods(X.address)) do
    print(method .. ': ' .. C.invoke(X.address, method))
    --print(C.doc(X.address, method))
  end
  for field, _ in pairs(C.fields(X.address)) do
    print(field)
  end
  X = nil
end

function Main()
  debug('tank_controller')
end


if not package.loaded['modulename'] then return Main() --[[ main case ]] else return Main --[[ module case ]] end

