local txt = "nill"
msgr = require "mqttLoveLibrary"
local minhamat = '1234'

function love.draw()
    love.graphics.print(txt, 400, 300)
end

local function mensagemRecebida (mensagem)
  txt = mensagem
  end

function love.load()
  msgr.start("test.mosquitto.org", minhamat, _,  mensagemRecebida)  
end

function love.update(dt)
  msgr.checkMessages() -- tem que constar no love.update!!!
end