local t = require("ds18b20")
local pin = 7 -- gpio0 = 3, gpio2 = 4

local function readout(temp)
  if t.sens then
    print("Total number of DS18B20 sensors: ".. #t.sens)
    for i, s in ipairs(t.sens) do
     print(string.format("  sensor #%d address: %s%s",  i, ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(s:byte(1,8)), s:byte(9) == 1 and " (parasite)" or ""))
    end
  end
  for addr, temp in pairs(temp) do
    print(string.format("Sensor %s: %s <--TEMP", ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(addr:byte(1,8)), temp))
  end

  -- Module can be released when it is no longer needed
  t = nil
  package.loaded["ds18b20"] = nil
end

t:read_temp(readout, pin, t.C)