local modules = node.modules
local cmd = modules.cmd

return function(_, bot)
	bot:on('ready', function()
		for i,v in pairs(modules) do
			node:add(i)
		end
	end)
	
	bot:on('messageCreate', function(msg)
		if not msg.author.bot then
			if cmd and msg.content:find('!') then
				cmd(msg)
			end
		end
	end)
end