local http = {}; do
    ---@param url string
    ---@return string
    http.get = function(url)
      local h_internet = WININET.InternetOpenA("LuaJIT", 0, nil, nil, 0)
      local h_url = WININET.InternetOpenUrlA(h_internet, url, nil, 0, 0x04000000, 0)

      local buffer = ffi.new("char[?]", 4096)
      local bytes_read = ffi.new("UINT[1]")
      bytes_read[0] = 0

      local response = ""

      while WININET.InternetReadFile(h_url, buffer, ffi.sizeof(buffer), bytes_read) ~= 0 and bytes_read[0] ~= 0 do
        response = response .. ffi.string(buffer, bytes_read[0])
        bytes_read[0] = 0
      end

      WININET.InternetCloseHandle(h_url)
      WININET.InternetCloseHandle(h_internet)

      return response
    end
end

return http