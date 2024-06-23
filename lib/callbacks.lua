local callbacks = { list = {} }; do
    ---@param name string
    ---@param fn function
    callbacks.add = function(name, fn)
        local callback = enums.callbacks[name]
        assert(callback, "Callback with the name \"" .. name .. "\" was not found!")

        if not callbacks.list[callback] then
            callbacks.list[callback] = {}
        end

        table.insert(callbacks.list[callback], fn)
    end

    callbacks.init = function()
        for callback, data in pairs(callbacks.list) do
            love[callback] = function(...)
                for _,  fn in ipairs(data) do
                    fn(...)
                end
            end
        end
        printd('Callbacks initialized successfully')
    end
end

return callbacks