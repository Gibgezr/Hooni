--[[
Hooni , a Windower addon by Gibbles and Kaius @Bahamut
Super-simple automated songs for BRD
Replaces our static's BRD
]]


_addon.name = 'Hooni'
_addon.version = '1.3'
_addon.author = 'Gibbles@Bahamut'
_addon.command = 'hooni'

--Requiring libraries used in this addon
--These should be saved in addons/libs
require('logger')
require('tables')
require('strings')
res = require('resources')

delayBetweenSongs  = 5 
delayBetweenRounds  = 610 
songs = {"Valor Minuet II", "Valor Minuet III", "Valor Minuet IV", "Valor Minuet V", "Honor March"}
stop = true --used to stop repeating
nitro = true

function singsong(song)
	if stop == false then
		windower.chat.input('/ma "'..song..'" <me>')
	end
end

function JA(jobAbility)
	if stop == false then
		windower.chat.input('/ja "'..jobAbility..'" <me>')
	end
end

function go()    
	if stop == false then
		
		local delay = 1	
		
		JA:schedule(delay, "Soul Voice") --attempt to soul voice
		delay = delay + 2
		
		if nitro then
			JA:schedule(delay, "Nightingale")
			delay = delay + 2
			JA:schedule(delay, "Troubadour")
			delay = delay + 2
			delayBetweenRounds = 610
		else
			delayBetweenRounds = 240
		end				
		
		for i, song in ipairs(songs) do
			if (song == "Honor March") then
				JA:schedule(delay, "Marcato")
				delay = delay + 2
			end
			singsong:schedule(delay, song)
			delay = delay + delayBetweenSongs	
		end
	
		go:schedule(delayBetweenRounds)
    end
end

windower.register_event('addon command', function(...)
    local args    = T{...}:map(string.lower)
	local num = 0
    for _ in pairs(args) do num = num + 1 end
	
    if args[1] == "stop" or args[1] == "s" then
		log('HOONI IS NO LONGER SINGING')
		stop = true
	
	elseif args[1] == "help" or args[1] == "-help" then
		log('USAGE: hooni sing/stop')		
		log('hooni nitro on/off')
		
	elseif args[1] == "nitro" then
		if num == 2 then
			if args[2] == "on" or args[2] == "ON" then
				nitro = true
			elseif args[2] == "off" or args[2] == "OFF" then
				nitro = false;
			end
		end
		if nitro == true then
			log('nitro is ON')
		else
			log('nitro is OFF')
		end	
		
	elseif args[1] == "go" or args[1] == "start" or args[1] == "sing" then
		log('HOONI IS SINGING')
		log('//hooni stop to halt')
		stop = false
		go()		
	end
end)
