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
local msgr = require "mqttLoveLibrary"
local easytext = require "easytext"

local txt = "||Procesando|"
local minhamat = '1234'
local data = io.open("data.txt","w")
local temp = {}


function love.draw()

	-- Titulo
	Titulo = easytext.new('lion_king', 50, "Aquario")
    easytext.setColor (Titulo, 215/255, 162/255, 58/255)
    easytext.draw(Titulo,225, 40)

	-- Borda do Grafico
	love.graphics.setColor(colorGraficoshade)
	love.graphics.rectangle( "fill", 38, 48+25, 424, 124 )

	-- Grafico
	love.graphics.setColor(colorGrafico)
	love.graphics.rectangle( "fill", 40, 50+25, 420, 120 )

    love.graphics.print("Temperatura: "..txt, 40, 200,0,1.2)
  
    grafico(temp)
end

local function mensagemRecebida (mensagem)
  txt = mensagem
  -- tranforma os dados em um arquivo txt
  data:write(mensagem.." "..os.date()..'\n')
  -- Adiciona cada temperatura a tabela
  table.insert(temp, mensagem)
  end

function love.load()
love.window.setMode(500, 600)
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

		-- trata valores para o grafico completo||Remove todos os itens da tabela quando ela estiver completa
		-- os dados nao sao perdidos pois sao salvos em txt
		if i == 418 then
			for r=1, #tabela do
				tabela[r] = nil
			end
		end

		-- Plota no grafico
		love.graphics.circle( "fill", 42+i, 160+25-tabela[i]*2, 3)
		love.graphics.setColor(244/255,251/255,252/255)
		
	end
end