local endpoints = {
    ["vote"] = "https://trackyserver.com/server/%d",
    ["status"] = "https://api.trackyserver.com/vote/?action=status&key=%s&"..Config.identifier.."id=%s&customid=%s",
    ["claim"] = "https://api.trackyserver.com/vote/?action=claim&key=%s&"..Config.identifier.."id=%s&customid=%s"
}

local voteCache = LoadResourceFile(GetCurrentResourceName(), "votes.json")
if (not voteCache) then
    voteCache = {}
else
    voteCache = json.decode(voteCache)
end

if Config.trackyServerId == "" then
    print("Please set Config.trackyServerId to your server ID from https://trackyserver.com in config.lua file")
end
if Config.trackyServerKey == "" then
    print("Please set Config.trackyServerKey to your server key from https://trackyserver.com in config.lua file")
end
if Config.identifier ~= "discord" and Config.identifier ~= "steam" then
    print("Please set Config.identifier to word steam or discord in config.lua file")
end

RegisterCommand("vota", function(src, args, raw)

    TriggerClientEvent('vorp:NotifyLeft', tonumber(src), 'Tracky Server Vote', "Il link per votare il server lo trovi sul nostro discord!", 'itemtype_textures', 'itemtype_gang_savings_special', 4000, "COLOR_BLUE")
end, false)

RegisterCommand("premio", function(src, args, raw)
    local source = tonumber(src)
    local Orig_Identifier, player_local_identifier, player_licence

    for k,v in pairs(GetPlayerIdentifiers(source)) do   
        if Config.identifier == "steam" then
            if (string.starts(v, "steam:")) then
                player_local_identifier = tonumber(string.sub(v, 7), 16)
                Orig_Identifier = v
            end
        elseif Config.identifier == "discord" then
            if (string.starts(v, "discord:")) then
                player_local_identifier = string.gsub(v, "discord:", "")
                Orig_Identifier = player_local_identifier
            end
		end

		if (string.starts(v, "license:")) or (string.starts(v, "licence:")) then
			player_licence = string.gsub(v, "licence:", "")
			player_licence = string.gsub(v, "license:", "")
		end
    end
    
    if (player_local_identifier == nil) then

        TriggerClientEvent('vorp:NotifyLeft', source, 'Tracky Server Vote', "Il tuo account steam non è stato rilevato, contatta gli amministratori", 'itemtype_textures', 'itemtype_gang_savings_special', 4000, "COLOR_REDDARK")
        return
    end

    local statusUrl = string.format(endpoints["status"], Config.trackyServerKey, player_local_identifier, player_licence)
    
    PerformHttpRequest(statusUrl, function(statusCode, responseText, _)
        if (statusCode ~= 200) then
            print("Error getting status: " .. statusCode .. " : " .. tostring(responseText))
            return
        end
        if string.find(responseText, "0") then

            TriggerClientEvent('vorp:NotifyLeft', source, 'Tracky Server Vote', "Il link per votare il server lo trovi sul nostro discord!", 'itemtype_textures', 'itemtype_gang_savings_special', 4000, "COLOR_REDDARK")
        elseif string.find(responseText, "1") then

            PerformHttpRequest(string.format(endpoints["claim"], Config.trackyServerKey, player_local_identifier, player_licence), function(statusCode, responseText, _)
                if (statusCode ~= 200) then
                    print("Error claiming vote")
                    return
                end

                if string.find(responseText, "0") then

                    TriggerClientEvent('vorp:NotifyLeft', source, 'Tracky Server Vote', "Il link per votare il server lo trovi sul nostro discord!", 'itemtype_textures', 'itemtype_gang_savings_special', 4000, "COLOR_REDDARK")
                elseif string.find(responseText, "1") then

                    claimedVote(source, Orig_Identifier, player_licence)

                elseif string.find(responseText, "2") then

                    TriggerClientEvent('vorp:NotifyLeft', source, 'Tracky Server Vote', "Hai già riscattato il tuo premio! Vota nuovamente tra 24 Ore", 'itemtype_textures', 'itemtype_gang_savings_special', 4000, "COLOR_REDDARK")
                end
            end, "GET", "", {})

        elseif string.find(responseText, "2") then

            TriggerClientEvent('vorp:NotifyLeft', source, 'Tracky Server Vote', "Hai già riscattato il tuo premio! Vota nuovamente tra 24 Ore", 'itemtype_textures', 'itemtype_gang_savings_special', 4000, "COLOR_REDDARK")
        end
    end, "GET", "", {})

end, false)



function claimedVote(playerId, Orig_Identifier, player_licence)
    if player_licence then
        Orig_Identifier = player_licence
    end
    if (voteCache[Orig_Identifier]) then
        voteCache[Orig_Identifier] = voteCache[Orig_Identifier] + 1
    else
        voteCache[Orig_Identifier] = 1
    end


    SaveResourceFile(GetCurrentResourceName(), "votes.json", json.encode(voteCache, {indent = true}))

    local amountOfVotes = voteCache[Orig_Identifier]
    local playerName = GetPlayerName(playerId)
    
    if Config.Rewards["@"] and type(Config.Rewards["@"] == "table") then
        for k,v in ipairs(Config.Rewards["@"]) do
            local command = v
            command = string.gsub(command, "{playername}", playerName)
            command = string.gsub(command, "{playerid}", playerId)
            command = string.gsub(command, "{playerlicence}", player_licence)
            command = string.gsub(command, "{votescount}", tostring(amountOfVotes))                     
            ExecuteCommand(command)
        end
    end

    if Config.Rewards[tostring(amountOfVotes)] then
        for k,v in ipairs(Config.Rewards[tostring(amountOfVotes)]) do
            local command = v
            command = string.gsub(command, "{playername}", playerName)
            command = string.gsub(command, "{playerid}", playerId)
            command = string.gsub(command, "{playerlicence}", player_licence)
            command = string.gsub(command, "{votescount}", tostring(amountOfVotes))         
            ExecuteCommand(command)
        end
    end
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

RegisterCommand("zm_tracky_announce", function(src, args, raw)
    if src > 0 then
        return false
    elseif #args < 2 then
        return false
    end
    local title = args[1]
    args[1] = ""
    local words = table.concat(args, " ")
    TriggerClientEvent("vorp:Tip", -1, ""..title.." "..words, 4000)
end, false)

RegisterCommand("zm_tracky_announce_ds", function(src, args, raw)
    if src > 0 then
        return false
    elseif #args < 2 then
        return false
    end
    local title = args[1]
    args[1] = ""
    local words = table.concat(args, " ")
    local description = ""..title.." "..words.."<:outlaws2023:1076938375317180436>"
    local color = 11929902
    Discord(Config.DiscordWebhook,"Tracky Server Vote", description, color)
end, false)

function Discord(webhook, title, description, color)
    local _source = source
    local logs = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = description,
        }
    }
  
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = logs}), { ['Content-Type'] = 'application/json' })
  end
