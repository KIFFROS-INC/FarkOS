local command = {commandName='echo'}

function command.OnExecute(args)
    local txt = table.concat(args, " ")
    print(txt)    
end

return command
