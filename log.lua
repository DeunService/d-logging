Log = {
    -- Set the lowest log level. If the loglevel is trace it will show all levels above. If you set it to e.g. error just error and fatal will be shown.
    -- It would recommend this on live servers. For test servers enable everything
    LogLevel = "trace",
    -- If enabled the diffrent levels will have different colors in the Console
    UserColors = true,
    -- These are all the available Log levels, you can acess. You can use them by simply triggering the function Log.level e.g. Log.trace
    Levels = {
        {
            name = 'trace',
            color = "\27[34m",
        },
        {
            name = 'debug',
            color = "\27[36m"
        },
        {
            name = 'info',
            color = "\27[33m"
        },
        {
            name = 'warn',
            color = "\27[35m"
        },
        {
            name = 'error',
            color = "\27[31m",
            file = "d-log.txt"
        },
        {
            name = 'fatal',
            -- You can just use ansi colors
            color = "\27[41m",
            -- If you set an file, it will create an file in fx directory of your server where you can see all e.g. fatal logs.
            -- To disable this, simple remove the line or add it to the level you wish.
            -- %s is an placeholder for the name of the resource where the prints come from
            file = "logs/%s.txt"
        },
        {
            name = 'discord',
            color = "\27[34m",
            -- You could add an webhook to every option if you want
            -- Set here the webhook of one of your discord channels
            webhook = ""
        },
    },
    -- The scripts who are listed here wont be displayed in your console if they have d-logging prints
    HideScripts = {
        -- 'd-phone'
    }
}

local overloglevel = false
for i, v in pairs(Log.Levels) do
    if v.name == Log.LogLevel then
        overloglevel = true
    end

    if overloglevel == true then
        Log[v.name] = function(msg)
            for _, script in pairs(Log.HideScripts) do
                if script == GetCurrentResourceName() then
                    return
                end
            end

            local color = ""
            local info = debug.getinfo(2, "Sl")
            local lineinfo = info.short_src .. ":" .. info.currentline
            local nameupper = v.name:upper()
            if Log.UserColors then color = v.color end
            local text = string.format("%s[%-6s%s]%s [%s] %s",
                color,
                nameupper,
                IsDuplicityVersion() and os.date("%H:%M:%S") or '',
                Log.UserColors and "\27[0m" or "",
                lineinfo,
                msg)

            print(text)

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

function sendDiscordLog(webhook, description)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
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
