--cores
local colorBase = {57/255, 57/255, 49/255} -- cor base|| cor de fundo
local colorGrafico = {241/255, 241/255, 230/255} -- branco claro
local colorGraficoshade = {29/255, 29/255, 23/255} -- cor do grafico como sombra
local colorGreen = {138/255, 152/255, 32/255} -- verde "ok"
local colorAmarelo = {215/255, 162/255, 58/255} -- amarelo aviso
local colorRed = {152/255,46/255,32/255} -- vermelho alerta
local colorAzulsoft = {67/255,124/255,215/255} -- azul "soft"
local colorAzulhard = {32/255, 78/255, 152/255} -- azul escuro


--codigo principal 
local msgr = require "modulos.mqttLoveLibrary"
local easytext = require "modulos.easytext"

local txt = "||Procesando|"
local minhamat = '1234'
local temp = {}

-- preparando planilha da sessao
local data = io.open("data.csv","w")
data:write('Temperatura,Hora,Data \n')

-- estado da bomba

local estadobomba = true

--ultima ultimaAtt
local ultimaAtt = "nill"



function love.draw()

	-- Titulo
	Titulo = easytext.new('modulos/lion_king', 50, "Aquario")
    easytext.setColor (Titulo, 215/255, 162/255, 58/255)
    easytext.draw(Titulo,225, 40)

	-- Borda do Grafico
	love.graphics.setColor(colorGraficoshade)
	love.graphics.rectangle( "fill", 38, 48+25, 424, 124 )

	-- Grafico
	love.graphics.setColor(colorGrafico)
	love.graphics.rectangle( "fill", 40, 50+25, 420, 120 )

    love.graphics.print("Temperatura: "..txt, 40, 240,0,1.2)
  
    grafico(temp)

    --bomba
    DisplayBomba(estadobomba)
    love.graphics.setColor(colorGrafico)
    love.graphics.print("Estado da Bomba: "..string.format("%s\n", tostring(estadobomba)), 40, 280,0,1.2)

    -- atualizacao
    love.graphics.print(ultimaAtt,40, 200,0,1.2)
end

local function mensagemRecebida (mensagem)
  txt = mensagem
  ultimaAtt = os.date()
  -- tranforma os dados em um arquivo csv
  data:write(mensagem..","..os.date("%X")..","..os.date("%x").."\n")
  -- Adiciona cada temperatura a tabela
  table.insert(temp, mensagem)

  --enviar estado da bomba
  hora = os.date("%M")
  if hora % 2 == 0 then
	bomba(true)
	estadobomba = true
else
	bomba(false)
	estadobomba = false
  end
end

function love.load()
love.window.setMode(500, 309.006)
love.graphics.setBackgroundColor(colorBase)
msgr.start("test.mosquitto.org", minhamat, _,  mensagemRecebida)
love.window.setTitle("Aquario v0.2")
end

function love.update(dt)
  msgr.checkMessages() --Procura por mensagens
end

function grafico(tabela)

	--Atribui cores relacionadas a temperatura
	for i=1, # tabela do
		if tonumber(tabela[i]) >= 27 and tonumber(tabela[i]) < 33 then
			love.graphics.setColor(colorAmarelo) 
		elseif tonumber(tabela[i]) >= 33 then
			love.graphics.setColor(colorRed)
		elseif tonumber(tabela[i]) >= 21  and tonumber(tabela[i]) < 27 then
			love.graphics.setColor(colorGreen) 
		elseif tonumber(tabela[i]) < 21 and tonumber(tabela[i])>=15  then
			love.graphics.setColor(colorAzulsoft) 
		elseif tonumber(tabela[i]) < 15 then
			love.graphics.setColor(colorAzulhard)
		end

		if i == 418 then -- para de plotar quando o grafico chega no maximo, dados continuam sendo salvos em csv
			break
		end

		--retangulo da temperatura
		love.graphics.rectangle( "fill",  42, 226, 100, 10)

		-- Plota no grafico
		love.graphics.circle( "fill", 42+i, 160+25-tabela[i]*2, 3)
		love.graphics.setColor(244/255,251/255,252/255)
		
	end
end

-- Envia para o node a situacao da bomba
function bomba(status)
  if status then
    msgr.sendMessage("true",minhamat.."node")
    
  else
    msgr.sendMessage("false",minhamat.."node")
    
	end
end
-- exibe o estado da bomba
function DisplayBomba(estado)
	love.graphics.setColor(colorAzulhard)
	if estado then
		love.graphics.setColor(colorGreen)
	else
		love.graphics.setColor(colorRed)
	end
	love.graphics.rectangle( "fill",  42, 267, 100, 10)

end
