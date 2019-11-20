local mytimer = tmr.create()
function temp()
	dofile("temperatura.lua")
end
temp()
mytimer:register(3000, 1,temp)
mytimer:start()