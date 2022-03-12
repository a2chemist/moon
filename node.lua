local read = require('fs').readFileSync
local node = {modules = {}}
local ecosystem = setmetatable({
    require = require;
    node = node
}, {__index = _G})

function node:add(name)
    local func = loadstring(
        read(('./modules/%s.lua'):format(name)),
        '@' .. name,
        't',
        ecosystem
    )

    node.modules[name] = func() or function() end
end

function node:delete(name)
    node.modules[name] = nil
end

return node
