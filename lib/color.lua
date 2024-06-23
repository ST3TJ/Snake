---@class color
---@field r number
---@field g number
---@field b number
---@field a number
---@field unpack fun(self: color, d?: number): number, number?, number?
---@field lerp fun(self: color, goal: color, time: number): color
---@field set fun(self: color, back?: boolean)
---@operator add: color
---@operator sub: color
---@operator mul: color
---@operator div: color
---@operator unm: color
---@operator pow: color
---@operator concat: string

local color_mt = {
    __add = function(a, b)
        if type(a) == "number" then
            return color(a + b.r, a + b.g, a + b.b, a + b.a)
        end

        if type(b) == "number" then
            return color(a.r + b, a.g + b, a.b + b, a.a + b)
        end

        return color(a.r + b.r, a.g + b.g, a.b + b.b, a.a + b.a)
    end,
    __sub = function(a, b)
        if type(a) == "number" then
            return color(a - b.r, a - b.g, a - b.b, a - b.a)
        end

        if type(b) == "number" then
            return color(a.r - b, a.g - b, a.b - b, a.a - b)
        end

        return color(a.r - b.r, a.g - b.g, a.b - b.b, a.a - b.a)
    end,
    __mul = function(a, b)
        if type(a) == "number" then
            return color(a * b.r, a * b.g, a * b.b, a * b.a)
        end

        if type(b) == "number" then
            return color(a.r * b, a.g * b, a.b * b, a.a * b)
        end

        return color(a.r * b.r, a.g * b.g, a.b * b.b, a.a * b.a)
    end,
    __div = function(a, b)
        if type(a) == "number" then
            return color(a / b.r, a / b.g, a / b.b, a / b.a)
        end

        if type(b) == "number" then
            return color(a.r / b, a.g / b, a.b / b, a.a / b)
        end

        return color(a.r / b.r, a.g / b.g, a.b / b.b, a.a / b.a)
    end,
    __eq = function(a, b)
        if type(a) == "number" then
            return a == b.r and a == b.g and a == b.b and a == b.a
        end

        if type(b) == "number" then
            return a.r == b and a.g == b and a.b == b and a.a == b
        end

        return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
    end,
    __ne = function(a, b)
        return not a == b
    end,
    __unm = function(self)
        return color(-self.r, -self.g, -self.b, -self.a)
    end,
    __pow = function(self)
        return color(self.r ^ 2, self.g ^ 2, self.b ^ 2, self.a ^ 2)
    end,
    __concat = function(a, b)
        return string.format("%s %s", tostring(a), tostring(b))
    end,
    __newindex = function(self, k, v)
        if type(k) == 'number' then
            k = math.clamp(k, 1, 4)

            local values = {'r', 'g', 'b', 'a'}
            local id = values[k]

            self[id] = v
        end

        rawset(self, k, v)
    end,
    unpack = function(self, d)
        d = d or 3
        local values = {self.r, self.g, self.b, self.a}
        return unpack(values, 1, math.clamp(d, 1, 4))
    end,
    lerp = function(a, b, t)
        return a * (1 - t) + b * t
    end,
    __type = 'color',
}

color_mt.__index = function(self, k, v)
    if type(k) == 'number' then
        local values = {self.r, self.g, self.b, self.a}
        k = math.clamp(k, 1, 4)
        return values[k]
    end

    return rawget(color_mt, k)
end

color_mt.__tostring = function(self)
    return string.format("color(%s, %s, %s, %s)", self:unpack(4))
end

color_mt.set = function(self, back)
    if back then
        love.graphics.setBackgroundColor(self:unpack(4))
        return
    end
    love.graphics.setColor(self:unpack(4))
end

---Creates a new color
---@param r? number
---@param g? number
---@param b? number
---@param a? number
---@return color
function color(r, g, b, a)
    r = r or 0
    g = g or r
    b = b or g
    a = a or 1

    return setmetatable({
        r = r,
        g = g,
        b = b,
        a = a,
    }, color_mt)
end