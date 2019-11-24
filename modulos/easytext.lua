math.randomseed(os.time())
local cores = {
  "black","white","red","green","blue",
  black = {1,1,1},
  white = {1, 1, 1},
  red =  {1, 0, 0},
  green =  {0.13, 0.47, 0.18},
  blue =  {0.25, 0.1, 0.85},
}
local ancoras = {
  c = true,
  ne = true
}

local text = {}

text.setColor = function (meutexto, cor1, cor2, cor3)
  if type(cor1) == "string" then
    if cor1 == "random" then
      meutexto.cor = cores[cores[math.random(1,5)]]
    else
    assert (cores[cor1], "cor inexistente")
    meutexto.cor = cores[cor1]
    end
  else
    meutexto.cor = {cor1, cor2, cor3}
  end
end

text.setAnchor = function (meutexto, anc)
  assert (ancoras[anc], "ancora nÃ£o definida")
  meutexto.ancora = anc
end

local function cantoesqsup (texto, x, y)
-- calcula a posiÃ§Ã£o no canto superior esquerdo do 
-- retÃ¢ngulo de texto
  local dx, dy = texto.textoLove:getDimensions()
  if texto.ancora == "c" then 
    x = x - dx/2
    y = y - dy/2
  elseif texto.ancora == "ne" then
    x = x - dx
  else
    -- outros casos 
  end
  return x, y
end

text.draw = function (meutexto, ax, ay)
  love.graphics.setColor(meutexto.cor)
  local x, y = cantoesqsup (meutexto, ax, ay)
  love.graphics.draw(meutexto.textoLove, x, y)
end

text.getDimensions = function (meutexto)
  local dimx, dimy =  meutexto.textoLove:getDimensions()
  return dimx, dimy
end

text.new = function (fontname, tam, str)
  local meutexto = {}
  local fonte = love.graphics.newFont(fontname .. ".ttf",tam)
  local textoLove = love.graphics.newText(fonte, str)
  meutexto.textoLove = textoLove
  -- cor default
  meutexto.cor = cores.black
  -- ancoragem default
  meutexto.ancora = 'c'
  return meutexto
end

return text
