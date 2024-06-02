local str = "18"
print(type(str))

print(type(tonumber(str)))

--

print(10 / 2)
print(10 / 3)
print(10 % 3)
print(100 / 3.14)
print(10 % 3.1)

--- The math library

print(math.pi)
print(math.sin(30))
print(math.random())

-- The OS library

math.randomseed(os.time())
print(math.random())
print(os.time())
