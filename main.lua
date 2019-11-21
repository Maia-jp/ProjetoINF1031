local txt = "123.000"
msgr = require "mqttLoveLibrary"
local minhamat = '1234'
local data = io.open("data.txt","w")
local temp = {}

function love.draw()
	love.graphics.setColor(244/255,251/255,252/255)
	love.graphics.rectangle( "fill", 40, 50, 420, 120 )
    love.graphics.print(txt, 250, 300)
    grafico(temp)
end

local function mensagemRecebida (mensagem)
  txt = mensagem
  data:write(mensagem.." "..os.date()..'\n')
  table.insert(temp, mensagem)
  end

function love.load()
love.window.setMode(500, 600)
love.graphics.setBackgroundColor(41/255,51/255,65/255)
msgr.start("test.mosquitto.org", minhamat, _,  mensagemRecebida)
end

function love.update(dt)
  msgr.checkMessages() -- tem que constar no love.update!!!
end
function grafico(tabela)
	--Atribui cores relacionadas a temperatura
	for i=1, # tabela do
		if tonumber(tabela[i]) >= 27 and tonumber(tabela[i]) < 33 then
			love.graphics.setColor(232/255,99/255,70/255)
		elseif tonumber(tabela[i]) >= 33 then
			love.graphics.setColor(144/255, 15/255, 4/255)
		elseif tonumber(tabela[i]) >= 21  and tonumber(tabela[i]) < 27 then
			love.graphics.setColor(88/255, 157/255, 44/255)
		elseif tonumber(tabela[i]) < 21 and tonumber(tabela[i])>=15  then
			love.graphics.setColor(0, 114/255, 194/255)
		elseif tonumber(tabela[i]) < 15 then
			love.graphics.setColor(0/255, 111/255, 172/255)
		end
		-- Plota no grafico
		love.graphics.circle( "fill", 41+i, 160-tabela[i], 2)
		love.graphics.setColor(244/255,251/255,252/255)
	end
end