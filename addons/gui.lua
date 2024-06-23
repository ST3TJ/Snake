---@class guiItem
---@field type string
---@field origin vector
---@field size vector
---@field accent color
---@field text string
---@field options table

local gui = {
    data = {},
}; do
    gui.in_bounds = function(origin, size)
        local c = vector(love.mouse.getPosition())
        local max = origin + size

        return (c.x >= origin.x and c.x <= max.x) and (c.y >= origin.y and c.y <= max.y)
    end

    ---@param id any
    ---@param origin? vector
    ---@param size? vector
    ---@param text? string
    ---@param accent? color
    ---@param centered? boolean
    gui.add_button = function(id, origin, size, text, accent, centered)
        --TODO: gui items id
        origin = check(origin, 'vector', vector())
        size = check(size, 'vector', vector())
        text = check(text, 'string', 'Text')
        accent = check(accent, 'color', color())

        gui.data[id] = {
            type = 'button',
            origin = origin,
            size = size,
            accent = accent,
            text = text,
            options = {
                centered = centered
            }
        }
    end

    gui.draw = {
        ---@param item guiItem
        button = function(item)
            item.accent:set()

            if item.options.centered then
                item.origin = item.origin - item.size / 2
            end

            graphics.rectangle('fill', item.origin.x, item.origin.y, item.size.x, item.size.y)

            color():set()
        end
    }

    gui.handler = function()
        for _, item in ipairs(gui.data) do
            local draw_fn = gui.draw[item.type]

            if not draw_fn then
                goto continue
            end

            draw_fn(item)
            ::continue::
        end
    end

    callbacks.add('draw', gui.handler)
end

return gui