---@diagnostic disable: inject-field, undefined-field
local engine = {}; do
    ---@return vector
    engine.get_screen_size = function()
        return vector(ffi.C.GetSystemMetrics(0), ffi.C.GetSystemMetrics(1))
    end

    ---@return vector
    engine.get_window_size = function()
        return vector(love.graphics.getDimensions())
    end

    ---@param code number
    ---@return number
    engine.get_key_state = function(code)
        return ffi.C.GetAsyncKeyState(code)
    end

    ---@param str string
    ---@param n number
    ---@return string|boolean
    engine.get_line = function(str, n)
        local i = 0
        for line in string.gmatch(str, '([^\n]*)\n?') do
            if i == n then
                return line
            end
            i = i + 1
        end
        return false
    end

    engine.get_directory_items = function(path)
        local find_data = ffi.new('WIN32_FIND_DATAA')
        local find_handle = ffi.C.FindFirstFileA(path .. '\\*', find_data)

        if find_handle == INVALID_HANDLE_VALUE then
            error('Cannot open directory: ' .. path)
        end

        local files = {}
        repeat
            table.insert(files, ffi.string(find_data.cFileName))
        until ffi.C.FindNextFileA(find_handle, find_data) == 0

        ffi.C.FindClose(find_handle)

        return files
    end

    engine.open_as = function(path)
        local sei = ffi.new("SHELLEXECUTEINFOA")
        sei.cbSize = ffi.sizeof("SHELLEXECUTEINFOA")
        sei.fMask = SEE_MASK_NOCLOSEPROCESS
        sei.lpVerb = "openas"
        sei.lpFile = path
        sei.nShow = SW_SHOW

        return shell32.ShellExecuteExA(sei) ~= 0
    end

    engine.get_mouse_scroll = function()
        local speed = ffi.new("DWORD[1]")
        if user32.SystemParametersInfoA(SPI_GETWHEELSCROLLLINES, 0, speed, 0) then
            return speed[0]
        end
    end

    engine.set_fullscreen = function(bool)
        love.window.setFullscreen(bool)
        window = engine.get_window_size()
    end
end

return engine