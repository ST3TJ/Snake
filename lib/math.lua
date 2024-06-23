---@param a number
---@param b number
---@param t number
---@return number
function math.lerp(a, b, t)
    return a + t * (b - a);
end

---@param v number
---@param mn number
---@param mx number
---@return number
function math.clamp(v, mn, mx)
    return math.max(math.min(v, mx), mn)
end

return math