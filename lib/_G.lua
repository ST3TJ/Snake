---@diagnostic disable: discard-returns
math.randomseed(os.time() ^ 2 / 2)

rad, deg, cos, sin, tan, random = math.rad, math.deg, math.cos, math.sin, math.tan, math.random
unpack = unpack or table.unpack
graphics = love.graphics
native_type = type

---@diagnostic disable-next-line: duplicate-set-field
function math.clamp(v, mn, mx)
    return v >= mx and mx or (v <= mn and mn or v)
end

---@param value any
---@return string
function type(value)
    local meta = getmetatable(value)
    if meta and meta.__type then
        return meta.__type
    end
    return native_type(value)
end

---@param s string
---@param ... any
function printf(s, ...)
    print(string.format(s, ...))
end

---@param s string
---@param ... any
function printd(s, ...)
    if not SETUP.DEBUG then
        return
    end
    printf(string.format(s .. ' - %s', os.clock()), ...)
end

---@param reason? string
---@param ... any
function exit(reason, ...)
    if reason then
        printf(reason, ...)
    end
    print("\nPress enter to exit...")
    io.read()
    love.event.quit()
end

---@param s? string
---@param ... any
---@return any
function input(s, ...)
    if s then
        printf(s, ...)
    end
    return io.read()
end

---@diagnostic disable-next-line: duplicate-set-field
function table.pack(...)
    return {
        ['n'] = #{...},
        ...
    }
end

---Checks if the value type is correct
---@param value any
---@param check_type string
---@param default any
---@return any
function check(value, check_type, default)
    if type(value) ~= check_type then
        return default
    end
    return value
end