settings.load()

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
        {"all", "SPAWN",       3,6,1,24,22,30,10,31,0},       --overworld
        {"all", "Nether",      27,23,4,34,12,28,0},           --theNether
        {"all", "End",         13,24,2,19,3,30,0},            --theEnd
        {"all", "Abidos",      26,6,14,31,11,29,0},           --abidos
        {"all", "Chulak",      11,22,18,9,34,21,14,23,0},     --chulak
        {"all", "Glacio",      3,14,31,23,17,33,26,28,0},     --glacio
        {"all", "Other",       34,14,25,35,17,33,0},          --theOther
        {"all", "Beyond",      21,22,5,11,20,27,0},           --theBeyond
        {"all", "Aether",      10,9,6,28,21,35,0},            --theAether
        {"all", "Void",        20,10,26,5,18,3,0},            --voidscape
        {"all", "T forest",    26,28,13,33,7,35,0},           --twiforest
        {"all", "Mining",      16,7,9,29,5,1,0},              --miningdim
        {"all", "Everbri",     8,16,7,25,19,30,0},            --everbright
        {"all", "Everdusk",    21,25,8,35,3,1,0},             --everdusk
        {"all", "otherSide",   23,11,21,10,26,31,0},          --otherSide
        {"all", "marble",      25,34,29, 30,5,15,0},          --marble
        {"all", "lostCity",    25,5,32,35,23,2,0},            --lostCity
        {"all", "Atlantis",    18,20,1,15,14,7,19,0}          --lanteaAddress 
    }

-- player gate addresses
    local playerGates = {
        {-00, "MYST&AJ",     18,22,34,14,21,19,9,23,0},       --MYSTAJ
        {-01, "magicINC",    11,24,31,14,9,26,27,20,0},       --magicINC
        {-02, "Asteria",     32,27,30,26,3,12,33,2,0},        --Asteria
        {-03, "foxtrot",     19,12,8,24,22,14,1,30,0}         -- fort foxtrot
    }

-- hazard gate addresses
    local hazardGates = {
        {"haz", "Moon",        33,18,28,15,22,16,9,13,0},     --moon
        {"haz", "mars",        6,8,25,28,33,12,30,35,0},      --mars
        {"haz", "Venus",       34,17,21,6,15,27,5,30,0},      --venus
        {"haz", "Mercury",     23,4,18,5,31,1,2,22,0}         --mercury 
    }

-- personal gate addresses
    local privateGates = {
        {00, "Mcolony",     6,10,25,11,30,15,28,4,0},         --Mysts's colony
        {00, "reactor",     9,24,35,17,26,20,28,22,0},        --Reactor room
        {00, "station",     24,20,15,23,6,12,1,19,0},         -- space station
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
        local addressCheck = true
    else 
        local addressCheck = false
    end
end



