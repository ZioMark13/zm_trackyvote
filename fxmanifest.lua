author "ZioMark | Outlaws Roleplay"
version '1.0.0'

fx_version "adamant"

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game "rdr3"
lua54 'yes'



files {
    "locales/italian.json"
}

server_scripts {
    "config.lua",
    "server/server.lua"
}

client_scripts {
    "client/language.lua"
}