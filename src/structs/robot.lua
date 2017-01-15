local Vector = dofile("math/vector.lua")
local Direct = dofile("structs/direct.lua")
local Way = dofile("structs/way.lua")
local Loader = dofile("structs/loader.lua")

local Robot = {}

function Robot:load(path)
    local args = Loader.arguments(path)
    assert(#args == 6)
    local color = tonumber(args[1])
    local lightColor = tonumber(args[2])
    local direct = Direct.valueOf(args[3])
    local position = Vector:new(tonumber(args[4]), tonumber(args[5]), tonumber(args[6]))
    if (not direct) then
        error("Wrong Arguments: direct is not recognised")
    end
    return Robot:init(color, lightColor, position, direct)
end

function Robot:init(color, lightColor, position, direct)
    local object = {
        robot = require("robot"),
        position = position,
        direct = direct
    }
    object.robot.setLightColor(lightColor)
    require("component").colors.setColor(color)
    self.__index = self
    return setmetatable(object, self)
end

function Robot:forward()
    local result = self.robot.forward()
    if (result) then
        self.position = self.position + self.direct
    end
    return result
end

function Robot:back()
    local result = self.robot.back()
    if (result) then
        self.position = self.position - self.direct
    end
    return result
end

function Robot:up()
    local result = self.robot.up()
    if (result) then
        self.position = self.position + Direct.Up
    end
    return result
end

function Robot:down()
    local result = self.robot.down()
    if (result) then
        self.position = self.position + Direct.Down
    end
    return result
end

function Robot:turnLeft()
    local result = self.robot.turnLeft()
    if (result) then
        self.direct = self.direct:left()
    end
    return result
end

function Robot:turnRight()
    local result = self.robot.turnRight()
    if (result) then
        self.direct = self.direct:right()
    end
    return result
end

function Robot:turnAround()
    local result = self.robot.turnAround()
    if (result) then
        self.direct = self.direct:back()
    end
    return result
end

function Robot:turn(direct)
    if (direct:equals(self.direct)) then 
        return true
    elseif (direct:equals(self.direct:left())) then  
        return self:turnLeft()
    elseif (direct:equals(self.direct:right())) then  
        return self:turnRight()
    elseif (direct:equals(self.direct:back())) then 
        return self:turnAround()
    else
        return false
    end
end

function Robot:wait(index, way)

end

function Robot:go(direct)
    if (direct:equals(Direct.Up)) then
        return not self.robot.detectUp() and self:up()
    elseif (direct:equals(Direct.Down)) then
        return not self.robot.detectDown() and self:down()
    else
        return self:turn(direct) and not self.robot.detect() and self:forward()
    end
end

return Robot