#!lua name=mylib1

-- require "mylib2"
local function myfunc1(keys, args)
    local res = mylib2.myfunc2()
    return res
end

redis.register_function('myfunc1', myfunc1)
