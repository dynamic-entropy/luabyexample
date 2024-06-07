#!lua name=liblock

local operationFactory = require "operationFactory"

--- Linux Error codes
local lerrorCodes = {
    EPERM = 1,
    ENOENT = 2,
    EBUSY = 16,
    EEXIST = 17
}

--- dummy function to call from lock liblock
local function testlockscope()
    return "Hello From Lock Lib"
end

local function testfunc(keys, args)
    local functoCall = args[1]
    -- return functoCall
    return testoperation()
end

--- Acquire a lock on a resource.
--- It sets a key with a cookie value if the key does not exist.
--- If the key exists and the value is same as cookie, it extends the lock.
--- If the key exists and the value is different from cookie, it fails.  
---@param keys table A single element list - lock name
---@param args table A two-element list - cookie and timeout
local function lock(keys, args)
    local name = keys[1]
    local cookie = args[1]
    local timeout = args[2]
    local lock_status = assert_lock(keys, args)
    if lock_status == 0 then
        redis.call('PEXPIRE', name, timeout)
        return 0
    elseif lock_status == -lerrorCodes.ENOENT then
        redis.call('SET', name, cookie, 'PX', timeout)
        return 0
    end
    return lock_status
end

--- Release the lock on a resource.
--- It deletes the key if the value matches the cookie.
---@param keys table A single element list - lock name
---@param args table A single-element list - cookie
local function unlock(keys, args)
    local name = keys[1]
    local cookie = args[1]
    local existing_cookie = redis.call('GET', name)
    if existing_cookie == cookie then
        return redis.call('DEL', name)
    end
    return 0
end

--- Assert if the lock is held by the owner of the cookie
--- @param keys table A single element list - lock name
--- @param args table A single-element list - cookie 
local function assert_lock(keys, args)
    local name = keys[1]
    local cookie = args[1]
    if redis.call('EXISTS', name) == 1 then
        local existing_cookie = redis.call('GET', name)
        if existing_cookie == cookie then
            return 0 -- success
        else
            return -lerrorCodes.EBUSY
        end
    end
    return -lerrorCodes.ENOENT
end

--- Register the functions.
redis.register_function('lock', lock)
redis.register_function('unlock', unlock)
redis.register_function('assert_lock', assert_lock)

local function testoperation(keys, args)
    --- get last element from keys and args
    local name = keys[#keys]
    local arg = args[#args]
    return name .. arg
end
