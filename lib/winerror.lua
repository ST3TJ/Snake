local winerror = { data = {} }; do
    local pattern = ([[
        <p><span id="([^"]+)"></span><span id="([^"]+)"></span><strong>([^<]+)</strong></p>
        </dt> <dd> <dl> <dt>
        <p>(%d+) %(0x%x+%)</p>
        </dt> <dt>
        <p>([^<]+)</p>
        </dt> </dl> </dd> <dt>
    ]]):gsub('  ', '')

    local main_url = "https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--"
    local url_postfix = {
        "0-499-",
        "500-999-",
        "1000-1299-",
        "1300-1699-",
        "1700-3999-",
        "4000-5999-",
        "6000-8199-",
        "8200-8999-",
        "9000-11999-",
        "12000-15999-",
    }

    winerror.parse = function(text)
        for a, _, _, d, e in text:gmatch(pattern) do
            winerror.data[tonumber(d)] = { name = a, description = e }
        end
    end

    winerror.main = function()
        SETUP.WINERROR = true
        for i = 1, #url_postfix do
            local url = main_url .. url_postfix[i]
            local data = http.get(url)
            winerror.parse(data)
        end
    end

    winerror.get = function()
        if not SETUP.WINERROR then
            printf("WINERROR library is not setuped")
            return
        end

        local last_error = ffi.C.GetLastError()
        local data = winerror.data[last_error]

        if data then
            printf("%s (%s)\n%s", data.name, last_error, data.description)
            return last_error
        else
            printf("Unknown error code (%s)", last_error)
        end
    end

    if SETUP.WINERROR then
        winerror.main()
    end
end

return winerror