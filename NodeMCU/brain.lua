local led1 = 3
local led2 = 6
local bomba = true

local mytimer = tmr.create()
dofile("temperatura.lua")
function temp()
	minharead()  
  end
mytimer:register(1500, 1,temp)
mytimer:start()