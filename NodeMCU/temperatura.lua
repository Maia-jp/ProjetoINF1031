local t = require("ds18b20")
local pin = 7
local atual = 0 
local  loop = true
local minhamat = "1234"
local led1 = 3
local led2 = 6

local msgr = require("mqttNodeMCULibrary")

local function readout(temp)
  for addr, temp in pairs(temp) do
    if temp then atual = temp end
  end
print("Temperatura: "..atual.." °C")
msgr.sendMessage(atual,minhamat.."love")
end

function minharead()
  t:read_temp(readout, pin, t.C)
end

function mensagemRecebida(msgn)
	print(msgn)
	if msgn == "true" then
    gpio.write(led2, gpio.HIGH)
    gpio.write(led1, gpio.LOW)
  elseif msgn == "false" then
    gpio.write(led1, gpio.HIGH)
    gpio.write(led2, gpio.LOW)
  end

end


msgr.start("test.mosquitto.org", minhamat, minhamat .. "node", mensagemRecebida)
