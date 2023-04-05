Log = {
    -- Set the lowest log level. If the loglevel is trace it will show all levels above. If you set it to e.g. error just error and fatal will be shown.
    -- It would recommend this on live servers. For test servers enable everything
    LogLevel = "error",
    -- If enabled the diffrent levels will have different colors in the Console
    UserColors = true,
    -- These are all the available Log levels, you can acess. You can use them by simply triggering the function Log.level e.g. Log.trace
    Levels = {
        {
            name = 'trace',
            color = "\27[34m",
            print = true,
        },
        {
            name = 'debug',
            color = "\27[36m",
            print = true,
        },
        {
            name = 'info',
            color = "\27[33m",
            print = true,
        },
        {
            name = 'warn',
            color = "\27[35m",
            print = true,
        },
        {
            name = 'error',
            color = "\27[31m",
            file = "logs/%s.txt",
            print = true,
        },
        {
            name = 'fatal',
            -- You can just use ansi colors
            color = "\27[41m",
            -- If you set an file, it will create an file in fx directory of your server where you can see all e.g. fatal logs.
            -- To disable this, simple remove the line or add it to the level you wish.
            -- %s is an placeholder for the name of the resource where the prints come from
            file = "logs/%s.txt",
            -- You can set this to false if you dont want to have the prints in the server console
            -- It still wll save them to the file, if you have set one
            print = true,
        },
        {
            name = 'discord',
            color = "\27[34m",
            -- You could add an webhook to every option if you want
            -- Set here the webhook of one of your discord channels
            webhook = "",
            print = false,
        },
    },
    -- The scripts who are listed here wont be displayed in your console if they have d-logging prints
    HideScripts = {
        -- 'd-phone'
    },
    -- If this isnt empty just the scripts, which are in this array will be displayed
    ShowOnlyScript = {
        -- 'd-phone',
    }
}

local overloglevel = false
Citizen.CreateThread(function()
    for i, v in pairs(Log.Levels) do
        Log[v.name] = function(msg)
            if OverlogLevel(v.name) == true then
                for _, script in pairs(Log.HideScripts) do
                    if script == GetCurrentResourceName() then
                        return
                    end
                end

                if #Log.ShowOnlyScript > 0 then
                    local found = false
                    for _, script in pairs(Log.ShowOnlyScript) do
                        if script == GetCurrentResourceName() then
                            found = true
                        end
                    end

                    if found == false then
                        return
                    end
                end

                local color = ""
                local info = debug.getinfo(2, "Sl")
                local lineinfo = info.short_src .. ":" .. info.currentline
                local nameupper = v.name:upper()
                if Log.UserColors then color = v.color end
                if v.print == nil or v.print and v.print == true then
                    local text = string.format("%s[%-6s%s]%s [%s] %s",
                        IsDuplicityVersion() and color or '',
                        nameupper,
                        IsDuplicityVersion() and os.date("%H:%M:%S") or '',
                        Log.UserColors and "\27[0m" and IsDuplicityVersion() or "",
                        lineinfo,
                        msg)

                    print(text)
                end

                if v.file and IsDuplicityVersion() then
                    local fp = io.open(string.format(v.file, GetCurrentResourceName()), "a")
                    if not fp then
                        os.execute("mkdir logs")
                        fp = io.open(string.format(v.file, GetCurrentResourceName()), "a")
                    end

                    local str = string.format("[%-6s%s] %s: %s\n",
                        nameupper, os.date(), lineinfo, msg)
                    fp:write(str)
                    fp:close()
                end

                if v.webhook and IsDuplicityVersion() then
                    sendDiscordLog(v.webhook, msg)
                end
            end
        end
    end
end)

function OverlogLevel(level)
    local i = 0
    local overi = 0
    for i_, v in pairs(Log.Levels) do
        if v.name == level then
            i = i_
        end
        if v.name == Log.LogLevel or Log.LogLevel:upper() == "ALL" then
            overi = i_
        end
    end

    if i >= overi then
        return true
    else
        return false
    end
end

function sendDiscordLog(webhook, description)
    PerformHttpRequest(webhook, function(err, text, headers)
    end, 'POST', json.encode({
        username = " ",
        embeds = { {
            ["color"] = 10650848,
            ["author"] = {
                ["name"] = "D-Logging",
            },
            ["description"] = tostring(description),
            ["footer"] = {
                ["text"] = os.date("%H:%M:%S"),
            },
        } },
        avatar_url = 'https://cdn.discordapp.com/attachments/890638170247561277/939834062674206770/blackpurple.png'
    }), {
        ['Content-Type'] = 'application/json'
    })
end
