
local command = {commandName='play'}
local SPlayer = require('farks.core.soundplayer')


local available = false
if SPlayer ~= false then
    available = true
else
    available = false
end


function command.OnExecute(args)
    if available == true then
        if args ~= {} then
            SPlayer.playDFPWM(args[1])
        else
            print('Usage: play <filepath>')
            print('Made by FarkOS')
        end
    else
        print('Play command is not available. Do you have a speaker?')
    end
end

return command
