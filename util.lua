local util = {}
local insert, concat = table.insert, table.concat

function util:search(guild, query)
    local member = guild:getMember(query)

    if member then
        return member
    end

    for v in guild.members:iter() do
        if v.id == query or v.tag == query or v.username:find(query) then
            return v
        end
    end

    return nil
end

function util:title(str)
    local titled = {}

    for v in str:gmatch("%S+") do
        local head = v:gmatch('%S')():upper()
        
        insert(titled, head .. v:sub(2))
    end

    return concat(titled, ' ')
end

return util