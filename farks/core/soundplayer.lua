-- play_audio.lua
local speaker = peripheral.find("speaker")
if not speaker then
    return false
end


local SPlayer = {}
    local function readFile(path)
        local file = fs.open(path, "rb")
        if not file then
            error("File not found: " .. path)
        end
        local data = file.readAll()
        file.close()
        return data
    end

    function SPlayer.playDFPWM(filePath)
        local data = readFile(filePath)
        local decoder = require("cc.audio.dfpwm").make_decoder()
        local CHUNK_SIZE = 4096
        local AUDIO_BUFFER_SIZE = 1024
    
        local buffer = {}
        for i = 1, #data, CHUNK_SIZE do
            local chunk = data:sub(i, i + CHUNK_SIZE - 1)
            local decoded = decoder(chunk)
            for j = 1, #decoded, AUDIO_BUFFER_SIZE do
                local audioChunk = {}
                for k = 0, AUDIO_BUFFER_SIZE - 1 do
                    audioChunk[#audioChunk + 1] = decoded[j + k]
                end
                table.insert(buffer, audioChunk)
            end
        end
    
        for _, audioChunk in ipairs(buffer) do
            speaker.playAudio(audioChunk)
            -- sleep(0.05) Ajusta el tiempo de espera según sea necesario
        end
    end
return SPlayer
