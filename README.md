# RedM vote script for Trackyserver.com (Edited for VORP by ZioMark)

A simple plugin to allow players to vote and claim rewards for their favourite servers.

## Installation

Open an account on [Trackyserver.com](https://trackyserver.com/) and add a RedM server.

Download this script and extract it to your `/resources` folder on your RedM server.

To start the script, add this line ***at the end*** of your resources in server.cfg: `ensure zm_trackyvote`

## Edits to VORP CORE
 
vorp_core > server > sv_commands.lua and **add**

```
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
```

### Edit Language

Go to fxmanifest.lua and edit this

```
files {
    "locales/italian.json"
}
```

adding the language file you want, you can create as many as you want

#### Configuration

There's only tree server vars needed to set up this resource in `config.lua` file.

`Config.trackyServerId` - The ID of your server on [TrackyServer](https://www.trackyserver.com/). This is must be a number.

`Config.trackyServerKey` - The key for the server on [TrackyServer](https://www.trackyserver.com/).

`Config.identifier` - If you want your players to vote with Steam on Trackyserver leave this variable to the word **steam**. If your players vote with Discord set this variable to the word **discord**

#### Commands configuration (CHECK THE FILES TO EDIT YOUR COMMANDS)

In the `config.lua` file you will see a table called `Config.Rewards`.
This is meant to contain the commands to be triggered when a certain number of votes are reached.
The `["@"]` array represents "all votes" and will always be triggered regardless of vote count.

If a command needs the player's live ID, you can put `{playerid}` in it's place.
The same goes for the player's name with `{playername}`.
Use `{playerlicence}` for the player GTA licence

Below is the default configuration for the rewards table.
```lua
Config.Rewards = {
    ["@"] = { -- @ = all votes
        "giveaccountmoney {playerid} bank 100", -- ESX framework command (ex_extended command)
        "qbgivemoney {playerid} bank 100", -- QBCore framework command
        "announce [VOTE] {playername} has voted and won $100 ! Number of votes: {votescount}. Type /vote to vote"
    },
    ["10"] = { -- When the player has 10 votes
        "announce [VOTE] {playername} has voted 10 times !"
    },
    ["100"] = {
        "announce [VOTE] {playername} has 100 votes !"
    }
}
```

### Chat commands

`/vote` - To display the server's voting link.

`/checkvote` - Type this command after voting for the server to receive your reward.
