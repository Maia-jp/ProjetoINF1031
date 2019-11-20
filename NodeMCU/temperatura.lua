local t = require("ds18b20")
local pin = 7
local atual = 0 
local  loop = true

local function readout(temp)
  for addr, temp in pairs(temp) do
    if temp then atual = temp end
  end
print("Temperatura: "..atual.." °C")
end

t:read_temp(readout, pin, t.C)
