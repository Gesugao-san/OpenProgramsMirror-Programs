
-- Lua 5.2; OpenComputers 1.6.1.11;

C = require('component'); S = require('serialization')

function debug(type)
  if type == nil then print('no type'); require('os').exit() end
  if next(C.list(type)) == nil then print('no type in list'); require('os').exit() end
  X = C.getPrimary(type)
  if X == nil then print('no getPrimary'); require('os').exit() end
  print('type: "' .. type .. '", address: ' .. X.address)
  print(S.serialize(C.methods(X.address)))
  for method, _ in pairs(C.methods(X.address)) do
    print(method .. ': ' .. C.invoke(X.address, method))
    --print(C.doc(X.address, method))
  end
  for field, _ in pairs(C.fields(X.address)) do
    print(field)
  end
  X = nil
end

debug('component')
