#!lua name=mylib2

local function myfunc2(keys, args)
    return "Hello from lib2"
end

redis.register_function('myfunc2', myfunc2)
