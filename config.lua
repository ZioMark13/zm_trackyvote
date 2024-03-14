Config = {}

Config.trackyServerId = "TRACKYSERVERID"
Config.trackyServerKey = "TRACKYSERVERKEY"
Config.identifier = "steam" -- If your players vote with Steam on Trackyserver.com leave this variable to the word **steam**. If your players vote with Discord set this variable to the word **discord**
Config.DiscordWebhook = 'https://discord.com/api/webhooks/..'


Config.Rewards = {
    ["@"] = {
        "_givemoney {playerid} 0 3",
        "zm_tracky_announce ~o~{playername} ~q~ha votato su TrackyServer ed è stato ricompensato!",
        "zm_tracky_announce_ds **{playername}** ha votato il server ed ha riscattato il suo premio in gioco!"
    },
    ["10"] = {
        "_givemoney {playerid} 0 10",
        "zm_tracky_announce ~o~{playername} ~q~ha votato ~t~10 VOLTE~q~ su TrackyServer ed è stato ricompensato!",
        "zm_tracky_announce_ds **{playername}** ha votato il server **10 VOLTE** ed ha riscattato il suo premio in gioco!"
    },
    ["25"] = {
        "_givemoney {playerid} 1 5",
        "zm_tracky_announce ~o~{playername} ~q~ha votato ~t~25 VOLTE~q~ su TrackyServer ed è stato ricompensato!",
        "zm_tracky_announce_ds **{playername}** ha votato il server **25 VOLTE** ed ha riscattato il suo premio in gioco!"
    },
    ["50"] = {
        "_givemoney {playerid} 1 10",
        "zm_tracky_announce ~o~{playername} ~q~ha votato ~t~50 VOLTE~q~ su TrackyServer ed è stato ricompensato!",
        "zm_tracky_announce_ds **{playername}** ha votato il server **50 VOLTE** ed ha riscattato il suo premio in gioco!"
    },
    ["100"] = {
        "_givemoney {playerid} 1 10",
        "_givemoney {playerid} 0 50",
        "zm_tracky_announce ~o~{playername} ~q~ha votato ~t~100 VOLTE~q~ su TrackyServer ed è stato ricompensato con un Bonus!",
        "zm_tracky_announce_ds **{playername}** ha votato il server **100 VOLTE** ed ha riscattato il suo premio in gioco!"
    },
    ["150"] = {
        -- "announce [VOTE] {playername} has 150 votes !"
    }
}

-- add in vorp core
 

--[[
    RegisterCommand("_givemoney", function(source, args, rawCommand)
    local _source = source
    --local group   = VorpCore.getUser(_source).getGroup
    if source > 0 then -- it's a player.
                TriggerClientEvent("vorp:Tip", source, "You cannot do this!", 4000)
    else
        local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        TriggerEvent("vorp:addMoney", target, montype, quantity)
    end
end, false)
]]