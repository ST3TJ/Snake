local keyboard = {
    msg = "",
    selected = { Line = 0, Cur = 0, Start = 0, End = 0 },
    reading = false,
}; do
    keyboard.shift = function(v)
        keyboard.selected.Cur = keyboard.selected.Cur + v
    end

    keyboard.on_textinput = function(text)
        if not keyboard.reading then
            return
        end

        keyboard.msg = keyboard.msg .. text
        keyboard.shift(1)
    end

    keyboard.on_update = function()
        if not keyboard.reading then
            return
        end

        if engine.get_key_state(0x08) == -32767 then
            keyboard.msg = keyboard.msg:sub(1, -2)
        end

        if engine.get_key_state(0x0D) == -32767 then
            keyboard.shift(1)
            keyboard.msg = keyboard.msg .. "\n"
        end
    end

    ---@param font love.Font
    ---@param x number
    ---@param y number
    keyboard.draw = function(font, x, y)
        font = font or graphics.getFont()
        x = x or 0
        y = y or 0

        local msg = keyboard.msg
        local selected = keyboard.selected
        local cur = selected.Cur

        local msgObj = graphics.newText(font, string.format("%s|%s", msg:sub(1, cur), msg:sub(cur + 1)))

        graphics.draw(msgObj, x, y)
    end
end

callbacks.add("textinput", keyboard.on_textinput)
callbacks.add("update", keyboard.on_update)

return keyboard