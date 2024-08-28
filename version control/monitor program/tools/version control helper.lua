-- ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA
-- ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA
-- ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA
-- ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA ASTERIA



--update this to change how fast the gate dials on non universe or manualy dialing milky way gates pegesus gates must be 0--
local gatespeed = 0

-- update these settings to change which types of gates this SG can access
local canAccessPrivateGates = true
local canAccessHazardGates = true

 
-- Safe Gate Addresses
local MainGates = {
    {"SPAWN",       3,6,1,24,22,30,10,31,0},       --overworld
    {"Nether",      27,23,4,34,12,28,0},           --theNether
    {"End",         13,24,2,19,3,30,0},            --theEnd
    {"Abidos",      26,6,14,31,11,29,0},           --abidos
    {"Chulak",      8,1,22,14,36,19,0},            --chulak
    {"Glacio",      26,20,4,36,9,27,0},            --glacio
    {"Other",       34,14,25,35,17,33,0},          --theOther
    {"Beyond",      21,22,5,11,20,27,0},           --theBeyond
    {"Aether",      10,9,6,28,21,35,0},            --theAether
    {"Void",        20,10,26,5,18,3,0},            --voidscape
    {"T forest",    26,28,13,33,7,35,0},           --twiforest
    {"Mining",      16,7,9,29,5,1,0},              --miningdim
    {"Everbri",     8,16,7,25,19,30,0},            --everbright
    {"otherSide",   23,11,21,10,26,31,0},          --otherSide
    {"marble",      25,34,29, 30,5,15,0},          --marble
    {"lostCity",    25,5,32,35,23,2,0},            --lostCity
    {"Atlantis",    18,20,1,15,14,7,19,0}          --lanteaAddress 
}

-- player gate addresses
local playerGates = {
    {"MYST&AJ",     11,13,2,34,25,3,28,1,0},       --MYSTAJ
    {"magicINC",    33,16,25,7,23,9,34,4,0},       --magicINC
}

-- hazard gate addresses
local hazardGates = {
    {"Moon",        33,18,28,15,22,16,9,13,0},     --moon
    {"mars",        6,8,25,28,33,12,30,35,0},      --mars
    {"Venus",       34,17,21,6,15,27,5,30,0},      --venus
    {"Mercury",     23,4,18,5,31,1,2,22,0}         --mercury 
}

-- personal gate addresses
local privateGates = {
    {"Mcolony",     6,10,25,11,30,15,28,4,0}      --Mysts's colony
}



-- MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC 
-- MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC 
-- MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC 
-- MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC MAGICINC 

--update this to change how fast the gate dials on non universe or manualy dialing milky way gates--
local gatespeed = .01

-- update these settings to change which types of gates this SG can access
local canAccessPrivateGates = true
local canAccessHazardGates = true

 
-- Safe Gate Addresses
local MainGates = {
    {"SPAWN",       27,25,4,35,10,28,0},           --overworld
    {"Nether",      27,23,4,34,12,28,0},           --theNether
    {"End",         13,24,2,19,3,30,0},            --theEnd
    {"Abidos",      26,6,14,31,11,29,0},           --abidos
    {"Chulak",      8,1,22,14,36,19,0},            --chulak
    {"Glacio",      26,20,4,36,9,27,0},            --glacio
    {"Other",       34,14,25,35,17,33,0},          --theOther
    {"Beyond",      21,22,5,11,20,27,0},           --theBeyond
    {"Aether",      10,9,6,28,21,35,0},            --theAether
    {"Void",        20,10,26,5,18,3,0},            --voidscape
    {"MainTF",      25,2,24,19,9,6,1,11,0},        --MainTF
    {"Mining",      16,7,9,29,5,1,0},              --miningdim
    {"Everbri",     8,16,7,25,19,30,0},            --everbright
    {"otherSide",   23,11,21,10,26,31,0},          --otherSide
    {"marble",      25,34,29, 30,5,15,0},          --marble
    {"lostCity",    25,5,32,35,23,2,0},            --lostCity
    {"Atlantis",    18,20,1,15,14,7,19,0}          --lanteaAddress 
}

-- player gate addresses
local playerGates = {
    {"MYST&AJ",     11,13,2,34,25,3,28,1,0},       --MYSTAJ
    {"Asteria",     32,27,30,26,3,12,33,2,0}       --Asteria
}

-- hazard gate addresses
local hazardGates = {
    {"Moon",        33,18,28,15,22,16,9,13,0},     --moon
    {"mars",        6,8,25,28,33,12,30,35,0},      --mars
    {"Venus",       34,17,21,6,15,27,5,30,0},      --venus
    {"Mercury",     23,4,18,5,31,1,2,22,0}         --mercury 
}

-- personal gate addresses
local privateGates = {

}

-- MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ
-- MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ
-- MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ
-- MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ MYST&AJ

--update this to change how fast the gate dials on non universe or manualy dialing milky way gates--
local gatespeed = .5

-- update these settings to change which types of gates this SG can access
local canAccessPrivateGates = true
local canAccessHazardGates = true
 
-- Main  Gate Addresses
local MainGates = {
    {"SPAWN",       3,6,1,24,22,30,10,31,0},       --overworld
    {"Nether",      27,23,4,34,12,28,0},           --theNether
    {"End",         13,24,2,19,3,30,0},            --theEnd
    {"Abidos",      26,6,14,31,11,29,0},           --abidos
    {"Chulak",      11,22,18,9,34,21,14,23,0},     --chulak
    {"Glacio",      3,14,31,23,17,33,26,28,0},     --glacio
    {"Other",       34,14,25,35,17,33,0},          --theOther
    {"Beyond",      21,22,5,11,20,27,0},           --theBeyond
    {"Aether",      10,9,6,28,21,35,0},            --theAether
    {"Void",        20,10,26,5,18,3,0},            --voidscape
    {"T forest",    26,28,13,33,7,35,0},           --twiforest
    {"Mining",      16,7,9,29,5,1,0},              --miningdim
    {"Everbri",     8,16,7,25,19,30,0},            --everbright
    {"otherSide",   23,11,21,10,26,31,0},          --otherSide
    {"marble",      25,34,29, 30,5,15,0},          --marble
    {"lostCity",    25,5,32,35,23,2,0},            --lostCity
    {"Atlantis",    18,20,1,15,14,7,19,0}          --lanteaAddress 
}

-- player gate addresses
local playerGates = {
    --{"MYST&AJ",     11,13,2,34,25,3,28,1,0},       --MYSTAJ
    {"magicINC",    33,16,25,7,23,9,34,4,0},       --magicINC
    {"Asteria",     32,27,30,26,3,12,33,2,0}       --Asteria
}

-- hazard gate addresses
local hazardGates = {
    {"Moon",        33,18,28,15,22,16,9,13,0},     --moon
    {"mars",        6,8,25,28,33,12,30,35,0},      --mars
    {"Venus",       34,17,21,6,15,27,5,30,0},      --venus
    {"Mercury",     23,4,18,5,31,1,2,22,0}         --mercury 
}

-- personal gate addresses

local privateGates = {
    {"Mcolony",     6,10,25,11,30,15,28,4,0},      --Mysts's colony
    {"reactor",     9,24,35,17,26,20,28,22,0},     --Reactor room
    {"station",     24,20,15,23,6,12,1,19,0},      -- space station
}

-- MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE
-- MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE
-- MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE
-- MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE MAINGATE

--update this to change how fast the gate dials on non universe or manualy dialing milky way gates--
local gatespeed = .5

-- update these settings to change which types of gates this SG can access
local canAccessPrivateGates = false
local canAccessHazardGates = false

 
-- Safe Gate Addresses
local MainGates = {
    {"Nether",      27,23,4,34,12,28,0},           --theNether
    {"End",         13,24,2,19,3,30,0},            --theEnd
    {"Abidos",      26,6,14,31,11,29,0},           --abidos
    {"Chulak",      8,1,22,14,36,19,0},            --chulak
    {"Glacio",      26,20,4,36,9,27,0},            --glacio
    {"Other",       34,14,25,35,17,33,0},          --theOther
    {"Beyond",      21,22,5,11,20,27,0},           --theBeyond
    {"Aether",      10,9,6,28,21,35,0},            --theAether
    {"Void",        20,10,26,5,18,3,0},            --voidscape
    {"T forest",    26,28,13,33,7,35,0},           --twiforest
    {"Mining",      16,7,9,29,5,1,0},              --miningdim
    {"Everbri",     8,16,7,25,19,30,0},            --everbright
    {"otherSide",   23,11,21,10,26,31,0},          --otherSide
    --{"marble",      25,34,29, 30,5,15,0},          --marble
    {"lostCity",    25,5,32,35,23,2,0},            --lostCity
    {"Atlantis",    18,20,1,15,14,7,19,0}          --lanteaAddress 
}

-- player gate addresses
local playerGates = {
    {"MYST&AJ",     11,13,2,34,25,3,28,1,0},       --MYSTAJ
    {"magicINC",    33,16,25,7,23,9,34,4,0},       --magicINC
    {"Asteria",     32,27,30,26,3,12,33,2,0}       --Asteria
}

-- hazard gate addresses
local hazardGates = {
    {"Moon",        33,18,28,15,22,16,9,13,0},     --moon
    {"mars",        6,8,25,28,33,12,30,35,0},      --mars
    {"Venus",       34,17,21,6,15,27,5,30,0},      --venus
    {"Mercury",     23,4,18,5,31,1,2,22,0}         --mercury 
}

-- personal gate addresses
local privateGates = {

}