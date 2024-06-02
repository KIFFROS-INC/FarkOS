
local RegFK = require('farks.core.regfk')
term.clear()

-- Farks OS start

local Version = RegFK.GetKey('__VERSION__')
local BuildName = RegFK.GetKey('__BUILD__')
local OsName = RegFK.GetKey('__OSNAME__')

local commands = {} -- Table to hold internal commands
local loadedcommands = {} -- Table to see what commands have been loaded. 

function __START__()
    LoadCommandsInFolder('/farks/commands')

    RegFK.SetKey('__MACHINE_ID__', os.getComputerID())
    RegFK.SetKey('__MACHINE_LABEL__', os.getComputerLabel())

    print('Farks OS (2024-2025) ('..Version..' '..BuildName..' '..OsName..')')
    print('FarksOS.')
end

function LoadCommandsInFolder(folder)
    local files = fs.list(folder)
    for _, file in ipairs(files) do
        local fullPath = fs.combine(folder, file)
        if not fs.isDir(fullPath) and file:match("%.lua$") then
            local moduleName = file:match("^(.*)%.lua$")
            local command = require('farks.commands.'..moduleName)
            if type(command) == "table" and command.commandName then
                commands[command.commandName] = command.OnExecute
            end
        end
    end
end

local function parse(input)
    local args = {}
    for word in input:gmatch("%S+") do
        table.insert(args, word)
    end
    local command = table.remove(args, 1)
    return command, args
end

function tableToString(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            result = result .. k .. "=" .. tableToString(v) .. ","
        else
            result = result .. k .. "=" .. tostring(v) .. ","
        end
    end
    result = result .. "}"
    return result
end

function __FARKS__()
    print()
    local function ReadAndParseInput()
        local cwd = shell.dir()
        term.setTextColor(colors.cyan)
        term.write('FarksOS ('..cwd..') >> ')
        term.setTextColor(colors.white)
        local c = read()
        local cm, a = parse(c)
        return cm, a, c
    end

    local function executeCommand(cmd, args)
        args = args or {}

        if commands[cmd] ~= nil then
            commands[cmd](args)
        elseif commands[cmd] == nil then
            local success, err = pcall(function() shell.run(cmd .. " " .. table.concat(args, " ")) end)
            if not success then
                printError("Command not found: " .. cmd)
            end
        end
    end

    local function processCommands(cmdLine)
        local parts = {}
        for part in string.gmatch(cmdLine, "[^|&]+") do
            table.insert(parts, part)
        end
        
        local i = 1
        while i <= #parts do
            local cmd = parts[i]
            local nextCmd = parts[i + 1]

            local cmdTrimmed = cmd:match("^%s*(.-)%s*$")
            local command, args = parse(cmdTrimmed)

            local executeNext = true
            if nextCmd then
                local separator = cmdLine:sub(#table.concat(parts, "", 1, i) + 1, #table.concat(parts, "", 1, i) + 2)
                if separator == "||" then
                    executeNext = (not pcall(executeCommand, command, args))
                elseif separator == "&&" then
                    executeNext = pcall(executeCommand, command, args)
                end
            else
                pcall(executeCommand, command, args)
            end

            if not executeNext then
                break
            end
            
            i = i + 1
        end
    end
    
    while true do
        local command, args, rawcommand = ReadAndParseInput()
        processCommands(rawcommand)
    end
end

function FARKS_PREVENT_TERM()
    while true do
        local event = os.pullEventRaw("terminate")
        if event == "terminate" then end
    end
end

commands.exit = function(args)
    shell.exit()
end

commands.get = function(args)
    if args then
        if args[1] == 'commands' then
            print(tableToString(commands))
        end
    end
end

-- Start Farks OS
__START__()
parallel.waitForAll(FARKS_PREVENT_TERM, __FARKS__)
