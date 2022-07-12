
--lua
C = require('component')
S = require('serialization')
print(S.serialize(C.methods(C.getPrimary('type').address)))
print(S.serialize(C.getPrimary('type').address))
