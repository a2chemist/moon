local env = require('./env')
local discordia = require('discordia')
local bot = discordia.Client {cacheAllMembers = true}
local read = require('fs').readdirSync
local node = require('./node')
local modules = node.modules

for i,v in ipairs(read('./modules')) do
    node:add(v:gsub('.lua', ''))
end

modules:event(bot)
bot:run(env.token)