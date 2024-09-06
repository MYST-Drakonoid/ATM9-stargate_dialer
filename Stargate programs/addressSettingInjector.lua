
local gatespeed = .5

-- configures whether the milky way gates manually dial or not
local manualDial = true

-- update these settings to change which types of gates this SG/TERMINAL can access
local canAccessPrivateGates = true
local canAccessHazardGates = true

-- four gate catagories , MAIN GATES for those gates that are mostly dialled with 7 chevron addresses
-- player gates for those gates that are direct dialing other players bases (mostly 9 cheveron addresses)
-- hazard gates for gates that are hostile on the destination
-- private 9 cheveron gates for specific players

-- Main Gate Addresses
local MainGates = {
    {"OVERWORLD",   27,25,4,35,10,28,0},           --overworld
    {"Nether",      27,23,4,34,12,28,0},           --theNether
    {"End",         13,24,2,19,3,30,0},            --theEnd
    {"Abidos",      26,6,14,31,11,29,0},           --abidos
    {"Chulak",      8,1,22,14,36,19,0}             --chulak
}

-- player gate addresses
local playerGates = {
}

-- hazard gate addresses
local hazardGates = {
}

-- personal gate addresses
local privateGates = {

}


local publicaddressCheck = nil
local playeraddressCheck = nil
local hazardaddressCheck = nil
local privateaddressCheck = nil
local speedCheck = nil
local manualCheck = nil


local settingsList = settings.getNames()

local fulladdresses = {
    ["MainGates"] = MainGates,
    ["playergates"] = playerGates,
    ["hazardGates"] = hazardGates,
    ["privateGates"] = privateGates
}

for i = 1, settingsList do 
    if settingsList[i] == "Adresses.setting" then
        settings.unset(Addresses.setting)
        local addressCheck = true
    elseif settingsList[i] == "Manualdial.setting" then
        speedCheck = true
    elseif settingsList[i] == "Gatespeed.setting" then
        manualCheck = true
    end

end

if addressCheck == false do 
    settings.define("Addresses.setting",{
        description = "gate addresses to be referenced on this computer"
        })
    settings.set("Addresses.settings", fulladdresses)
else
    settings.set("Addresses.settings", fulladdresses)
    
if speedCheck == false then
    settings.define("GateSpeed.setting",{
        description = "gate addresses to be referenced on this computer"
        })