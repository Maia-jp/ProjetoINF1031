local t = require("ds18b20")
local pin = 7
local atual = 0 
local  loop = true
local mySsid="UIB"
local myKey="C@r@i100"
local minhamat = "1234"

local msgr = require("mqttNodeMCULibrary")

local function readout(temp)
  for addr, temp in pairs(temp) do
    if temp then atual = temp end
  end
print("Temperatura: "..atual.." °C")
msgr.sendMessage(atual,minhamat.."love")
end

t:read_temp(readout, pin, t.C)
msgr.start("test.mosquitto.org", minhamat, minhamat .. "node", mensagemRecebida)
