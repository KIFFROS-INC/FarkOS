local function logMessage(level, color, message)
    term.setTextColor(colors.gray)
    term.write('[')
    term.setTextColor(color)
    term.write(level)
    term.setTextColor(colors.gray)
    term.write(']: ')
    term.setTextColor(colors.white)
    print(message)  -- Using print to ensure the message ends with a new line
end

function OK(message)
    logMessage('OK', colors.green, message)
end

function INFO(message)
    logMessage('INFO', colors.blue, message)
end

function ERROR(message)
    logMessage('ERROR', colors.red, message)
end

function FAIL(message)
    logMessage('FAIL', colors.red, message)
end

function NetInstall(http, filename)
    shell.run('wget '..http..' '..filename)
end

function MakeFolder(folder, path)
    path = path or '/'
    shell.run('mkdir '..path..''..folder)
end

function printBanner()
    local banner = [[
 _____          _     ___      
|  ___|_ _ _ __| | __/ _ \ ___ 
| |_ / _` | '__| |/ / | | / __|
|  _| (_| | |  |   <| |_| \__ \
|_|  \__,_|_|  |_|\_\\___/|___/
    ]]
    print(banner)
end


-- /////////////////////////////////////////////////
-- /////////////////INSTALLER START////////////////
-- ////////////////////////////////////////////////

term.clear()

printBanner()
INFO('Starting the installer. FarkOS')
INFO('Preparing files or folders.')

MakeFolder('farks')
MakeFolder('commands', 'farks/')
MakeFolder('core', 'farks/')

OK('Made the required folder.')
INFO('Installing OS.')
NetInstall('https://kiffros-inc.github.io/FarkOS/FarksOS.lua', 'FarkOS.lua')

NetInstall('https://kiffros-inc.github.io/FarkOS/farks/commands/echo.lua', '/farks/commands/echo.lua')
NetInstall('https://kiffros-inc.github.io/FarkOS/farks/commands/play.lua', '/farks/commands/play.lua')

NetInstall('https://kiffros-inc.github.io/FarkOS/farks/core/regfk.lua', '/farks/core/regfk.lua')
NetInstall('https://kiffros-inc.github.io/FarkOS/farks/core/soundplayer.lua', '/farks/core/soundplayer.lua')

NetInstall('https://kiffros-inc.github.io/FarkOS/startup.lua', 'startup')
OK('FarkOS Installed.')
