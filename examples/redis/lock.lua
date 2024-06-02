#!lua name=liblock

--- Acquire a lock on a resource.
--- It sets a key with a cookie value if the key does not exist.
---@param keys table A single element list - lock name
---@param args table A two-element list - cookie and timeout
local function lock(keys, args)
    local name = keys[1]
    local cookie = args[1]
    local timeout = args[2]
    return redis.call('set', name, cookie, 'NX', 'PX', timeout)
end

--- Release the lock on a resource.
--- It deletes the key if the value matches the cookie.
---@param keys table A single element list - lock name
---@param args table A single-element list - cookie
local function unlock(keys, args)
    local name = keys[1]
    local cookie = args[1]
    local existing_cookie = redis.call('get', name)
    if existing_cookie == cookie then
        return redis.call('del', name)
    else
        return 0
    end
end

local function assert_locked(keys, args)
    return 0
end

--- Register the functions.
redis.register_function('lock', lock)
redis.register_function('unlock', unlock)
