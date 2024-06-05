#!lua name=operationFactory

--- dummy function to call from lock liblock
local function testoperation()
    return "Hello From Operation Factory"
end

--- Factory function to return and operation function.
--- @param operation string The operation name
--- @return function The operation function
local function operationFactory(operation)
    if operation == 'queue' then
        return enqueue
    end
end

redis.register_function('operationFactory', operationFactory)
redis.register_function('testoperation', testoperation)
