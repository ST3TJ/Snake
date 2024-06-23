---@class vector
---@field x number
---@field y number
---@field length fun(self: vector): number
---@field length_sqr fun(self: vector): number
---@field dot fun(self: vector, b: vector): number
---@field unpack fun(self: vector, d?: number): number, number?, number?
---@field lerp fun(self: vector, goal: vector, time: number): vector
---@operator add: vector
---@operator sub: vector
---@operator mul: vector
---@operator div: vector
---@operator unm: vector
---@operator pow: vector
---@operator concat: string

local vector_mt = {
    __add = function(a, b)
        if type(a) == "number" then
            return vector(a + b.x, a + b.y, a + b.z)
        end

        if type(b) == "number" then
            return vector(a.x + b, a.y + b, a.z + b)
        end

        return vector(a.x + b.x, a.y + b.y, a.z + b.z)
    end,
    __sub = function(a, b)
        if type(a) == "number" then
            return vector(a - b.x, a - b.y, a - b.z)
        end

        if type(b) == "number" then
            return vector(a.x - b, a.y - b, a.z - b)
        end

        return vector(a.x - b.x, a.y - b.y, a.z - b.z)
    end,
    __mul = function(a, b)
        if type(a) == "number" then
            return vector(a * b.x, a * b.y, a * b.z)
        end

        if type(b) == "number" then
            return vector(a.x * b, a.y * b, a.z * b)
        end

        return vector(a.x * b.x, a.y * b.y, a.z * b.z)
    end,
    __div = function(a, b)
        if type(a) == "number" then
            return vector(a / b.x, a / b.y, a / b.z)
        end

        if type(b) == "number" then
            return vector(a.x / b, a.y / b, a.z / b)
        end

        return vector(a.x / b.x, a.y / b.y, a.z / b.z)
    end,
    __eq = function(a, b)
        if type(a) == "number" then
            return a == b.x and a == b.y and a == b.z
        end

        if type(b) == "number" then
            return a.x == b and a.y == b and a.z == b
        end

        return a.x == b.x and a.y == b.y and a.z == b.z
    end,
    __ne = function(a, b)
        return not a == b
    end,
    __unm = function(self)
        return vector(-self.x, -self.y, -self.z)
    end,
    __lt = function(a, b)
        return a:length() < b:length()
    end,
    __le = function(a, b)
        return a:length() <= b:length()
    end,
    __pow = function(self)
        return vector(self.x ^ 2, self.y ^ 2, self.z ^ 2)
    end,
    __concat = function(a, b)
        return string.format("%s %s", tostring(a), tostring(b))
    end,
    unpack = function(self, d)
        d = d or 2
        local values = {self.x, self.y, self.z}
        return unpack(values, 1, math.clamp(d, 1, 3))
    end,
    length = function(self)
        return math.sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
    end,
    length_sqr = function(self)
        return self.x ^ 2 + self.y ^ 2 + self.z ^ 2
    end,
    dot = function(a, b)
        if type(b) == "number" then
            return a.x * b + a.y * b + a.z * b
        end

        return a.x * b.x + a.y * b.y + a.z * b.z
    end,
    dist = function(a, b)
        if not b then
            return a:length()
        else
            return (a - b):length()
        end
    end,
    normalized = function(self)
        return self / self:length()
    end,
    normalize = function(self)
        self = self / self:length()
    end,
    lerp = function(a, b, t)
        return a * (1 - t) + b * t
    end,
    __newindex = function(self, k, v)
        if type(k) == 'number' then
            k = math.clamp(k, 1, 3)

            local values = {'x', 'y', 'z'}
            local id = values[k]

            self[id] = v
        end

        rawset(self, k, v)
    end,
    __type = 'vector',
}

vector_mt.__index = function(self, k, v)
    if type(k) == 'number' then
        local values = {self.x, self.y, self.z}
        k = math.clamp(k, 1, 3)
        return values[k]
    end

    return rawget(vector_mt, k)
end

vector_mt.__tostring = function(self)
    return string.format("vector(%s, %s, %s)", self:unpack(3))
end

---Creates a new vector
---@param x? number
---@param y? number
---@param z? number
---@return vector
function vector(x, y, z)
    x = x or 0
    y = y or x
    z = z or y

    return setmetatable({
        x = x,
        y = y,
        z = z
    }, vector_mt)
end

print(tostring(vector()))