local RegFK = {}
local dataFilePath = "/farks/RegFK.json"  -- Cambia esta ruta según sea necesario

-- Función para cargar datos desde el archivo .json
local function loadData()
    if fs.exists(dataFilePath) then
        local file = fs.open(dataFilePath, "r")
        local content = file.readAll()
        file.close()
        return textutils.unserializeJSON(content)
    else
        return {}
    end
end

-- Función para guardar datos en el archivo .json
local function saveData(data)
    local file = fs.open(dataFilePath, "w")
    file.write(textutils.serializeJSON(data))
    file.close()
end

function RegFK.SetKey(key, value, notify)
    notify = notify or false

    local data = loadData()
    data[key] = value
    saveData(data)
    if notify then
        print("Key set successfully: " .. key)
    end
end

function RegFK.GetKey(key)
    local data = loadData()
    return data[key]
end

function RegFK.RemoveKey(key, notify)
    notify = notify or false

    local data = loadData()
    if data[key] then
        data[key] = nil
        saveData(data)
        if notify then
            print("Key removed successfully: " .. key)
        end
    else
        if notify then
            print("Key not found: " .. key)
        end
    end
end

return RegFK
