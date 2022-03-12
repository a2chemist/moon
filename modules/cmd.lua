local cmds = {}
local replies = {}
local random, floor = math.random, math.floor
local insert, sort, concat = table.insert, table.sort, table.concat
local env = require('../env')
local modules = node.modules
local util = modules.util

cmds['help'] = {
    'Shows this.';
    function(args, msg, bot)
        local list = {}

        for i,v in pairs(cmds) do
            insert(list, ('`%s` -> %s'):format(i, v[1]))
        end

        return concat(list, '\n')
    end
}

cmds['add'] = {
    'Adds a module to the node.';
    function(args, msg, bot)
        if env.studio[msg.author.id] then
            node:add(args[1])
        
            return 'Module added to the node.'
        end
    end
}

cmds['delete'] = {
    'Deletes a module from the node.';
    function(args, msg, bot)
        if env.studio[msg.author.id] then
            node:delete(args[1])
        
            return 'Module removed from the node.'
        end
    end
}

cmds['modules'] = {
    'Shows all modules in the node.';
    function(args, msg, bot)
        local list = {}

        for i,v in pairs(modules) do
            insert(list, ('`%s`'):format(i))
        end

        return 'Node modules: ' .. concat(list, ', ')
    end
}

cmds['clean'] = {
    'Cleans up stored bot replies and cmds.';
    function(args, msg, bot)
        local list = {}
        local channel = msg.channel
        
        if #replies > 100 then
            for i,v in ipairs(replies) do
                insert(list, v)

                if #list == 100 then
                    channel:bulkDelete(list)
                end
            end

            if #list > 2 then
                channel:bulkDelete(list)
            end
        else
            channel:bulkDelete(replies)
        end

        return 'Stored bot replies and cmds cleaned up.'
    end
}

cmds['ping'] = {
    'Shows the classic ping.';
    function(args, msg, bot)
        local ms = os.time() - msg.createdAt

        return ('Classic ping: `%sms`'):format(floor(ms))
    end
}

cmds['avatar'] = {
    'Shows an avatar.';
    function(args, msg, bot)
        local user = msg.author or msg.mentionedUsers.first

        if args[1] then
            user = util:search(args[1]) or user
        end

        return {
            embed = {
                color = 0x2f3136;
                image = {url = user.avatarURL};
                author = {
                    name = user.tag;
                    icon_url = user.avatarURL
                }
            }
        }
    end
}

cmds['lookup'] = {
    'Shows a user profile.';
    function(args, msg, bot)
        local user = msg.author or msg.mentionedUsers.first

        if args[1] then
            user = util:search(args[1]) or user
        end

        return {
            embed = {
                color = 0x2f3136;
                author = {
                    name = user.tag;
                    icon_url = user.avatarURL
                };
                description = concat({
                    ('Mutual guilds: `%s`'):format(#user.mutualGuilds:toArray());
                    ('Is a bot: `%s`'):format(user.bot);
                    ('Registered at: `%s`'):format(user.timestamp:sub(1, 10))
                }, '\n')
            }
        }
    end
}

return function(msg)
    local args = {}
    local cmd

    for v in msg.content:sub(2):gmatch('%S+') do
        if #args == 0 and not cmd then
            cmd = cmds[v]
        else
            insert(args, v)
        end
    end

    if cmd then
        local good, data = pcall(cmd[2], args, msg, msg.client)

        if not good then
            msg:reply(('```%s```'):format(data))
		else
	        insert(replies, msg.id)
			
            if data then
                insert(replies, msg:reply(data).id)
            end
		end
    end
end
