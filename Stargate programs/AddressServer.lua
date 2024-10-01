settings.load()

local modem = peripheral.find("modem")

local fulladdresses = settings.get("Adresses.setting") -- pulling addresses from the settin

-- extracting gate lists from settings

-- Main Gate Addresses
local MainGates = fulladdresses[1]

-- player gate addresses
local playerGates = fulladdresses[2]

-- hazard gate addresses
local hazardGates = fulladdresses[3]

-- personal gate addresses
local privateGates = fulladdresses[4]

local function pararecieve() -- function to make modem message events simpler
    _,_,_,reply,signal,_ = os.pullEvent("modem_message")
    return signal, reply
end

local tempMAIN = nil
local tempPLAYER = nil
local tempHAZARD = nil
local tempPRIVATE = nil
-- startup == 1452
-- recieve info == 1327
-- transmit code == 4256
-- to gate == 5572
-- from gate == 1237

--info request format
--{
--0-1 = hazardgatePerm
--0-1 = privategatePerm
--string = gateName
--0-1 = dialRequest/tablerequest
--int = inforequest
--}

---basic startup signal info
---startup  string
---computerID
---
---
---
---



local function requestinfo(signalinfo) --functions both as a startup numbwer of address counter and a computer ID filter

    tempMAIN = MainGates
    tempPLAYER = playerGates
    tempHAZARD = hazardGates
    tempPRIVATE = privateGates
    local retruninfo 

    local startupreturn = {}
    local length = #MainGates
    table.insert(startupreturn, length)

    for i = 1, #playerGates do -- filtering player gates with the Computer ID
        if playerGates[i] == signalinfo[2] *-1 then
            table.remove(tempPLAYER, i) 
        end
    end
    table.insert(startupreturn, #tempPLAYER)
    table.insert(startupreturn, #hazardGates)

    for i = 1, #privateGates do -- filtering private gates with the Computer ID
        if privateGates[i] == signalinfo[2] then
            table.remove(tempPRIVATE, i) 
        end
    end
    table.insert(startupreturn, #tempPRIVATE)

    local tempfull = {
        tempMAIN, tempPLAYER, tempHAZARD, tempPRIVATE
    }

    if signalinfo[1] ~= "startup" then
        retruninfo = tempfull
    else 
        retruninfo = startupreturn
    end
    return retruninfo
end

local function infoChecker(info)

end

local function Main() -- main function for the code
    while true do
        modem.open(1327)
        local signal = pararecieve()

        if signal[1] == "startup" then
            local response = requestinfo(signal)
            modem.transmit(1452, _, response)
        end

    end
end

Main()