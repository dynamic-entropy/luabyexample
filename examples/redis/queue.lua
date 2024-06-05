#!lua name=libqueue

--- Enqueue an item to a list.
--- @param keys table A single element list - list name
--- @param args table A single-element list - item
local function enqueue(keys, args)
    local name = keys[1]
    return redis.call('LPUSH', name, unpack(args))
end

redis.register_function('enqueue', enqueue)
redis.register_function('enqueue2', enqueue)
