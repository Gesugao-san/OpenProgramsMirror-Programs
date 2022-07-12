
--lua
local c = require('component')
local s = require('serialization')
print(s.serialize(c.getPrimary('type').methods))
