--[[
    nil
    number 1 1.23
    string 'hello' "world"
    boolean true false
    table

]] --
local a
print(a)

a = 10 + 20
print(a)

local name = "Babiyorum"
print("Her name is " .. name .. " and " .. name .. " is the most awesome person.")

local description = [[
    Her eyes are brown and they surprise me every time look into them.
    She is super cute and super cool.
]]
print(description)

-- False and nil are the only truthValues that evaluate to false in lua
local boolf = false
local truthValue = nil

-- All other values, even 0, empty-strings "", evaluate to true
local boolt = true

print(boolf, boolt, truthValue)

print(true == 1)

--- Global Scope Variable

C = 20

-- Type
print(type(C))
print(type(truthValue))
print(type(boolf))
