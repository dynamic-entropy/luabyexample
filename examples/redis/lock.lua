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
    if redis.call('EXISTS', name) == 1 then
        local existing_cookie = redis.call('GET', name)
        if existing_cookie == cookie then
            return redis.call('PEXPIRE', name, timeout)
        else
            return -lerrorCodes.EBUSY
        end
    end
    redis.call('SET', name, cookie, 'PX', timeout)
    return 0
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

--- Perform another operation if the lock is acquired.
--- The operation to perform is a function name.
--- The args should be of the form - {cookie, NUMKEYS, key1, key2, ..., args1, args2, ...}
--- @param keys table A two-element list - lock name and operation name
--- @param args table A three-element list - cookie and operation arguments
local function assert_lock_and_perform(keys, args)
    local name = keys[1]
    local operation = keys[2]
    local cookie = args[1]
    if redis.call('EXISTS', name) == 1 then
        local existing_cookie = redis.call('GET', name)
        if existing_cookie == cookie then
            return redis.call("FCALL", operation, unpack(args, 1))
        else
            return -lerrorCodes.EBUSY
        end
    end
    return -lerrorCodes.ENOENT
end

local function assert_lock_and_perform2(keys, args)
    local name = keys[1]
    local operation = keys[2]
    local cookie = args[1]
    if redis.call('EXISTS', name) == 1 then
        local existing_cookie = redis.call('GET', name)
        if existing_cookie == cookie then
            fn = operationFactory(operation)
            return fn(unpack(args, 1))
        else
            return -lerrorCodes.EBUSY
        end
    end
    return -lerrorCodes.ENOENT
end
--- Register the functions.
redis.register_function('lock', lock)
redis.register_function('unlock', unlock)
redis.register_function('assert_lock_and_perform', assert_lock_and_perform)
redis.register_function('assert_lock_and_perform2', assert_lock_and_perform2)
redis.register_function('testlockscope', testlockscope)
redis.register_function('testfunc', testfunc)
