
local gatespeed = .01

local mon = peripheral.find("monitor")
local gate = peripheral.find("advanced_crystal_interface")
gate.disconnectStargate()

 
-- gate addresses
local gateTable = {
    {27,25,4,35,10,28,0},           --overworld
    {27,23,4,34,12,28,0},           --theNether
    {13,24,2,19,3,30,0},            --theEnd
    {26,6,14,31,11,29,0},           --abidos
    {8,1,22,14,36,19,0},            --chulak
    {26,20,4,36,9,27,0},            --glacio
    {34,14,25,35,17,33,0},          --theOther
    {21,22,5,11,20,27,0},           --theBeyond
    {10,9,6,28,21,35,0},            --theAether
    {20,10,26,5,18,3,0},            --voidscape
    {16,7,9,29,5,1,0},              --miningdim
    {8,16,7,25,19,30,0},            --everbright
    {23,11,21,10,26,31,0},          --otherSide
    {25,34,29, 30,5,15,0},          --marble
    {25,5,32,35,23,2,0},            --lostCity
    {18,20,1,15,14,7,19,0},         --lanteaAddress
    {11,13,2,34,25,3,28,1,0},       --MYSTAJ
    {25,2,24,19,9,6,1,11,0},        --MainTF
    {32,27,30,26,3,12,33,2,0},      --Asteria
    {33,18,28,15,22,16,9,13,0},     --moon
    {6,8,25,28,33,12,30,35,0},      --mars
    {34,17,21,6,15,27,5,30,0},      --venus
    {23,4,18,5,31,1,2,22,0}}        --mercury  


--screenNames
local screenNames = {
    "SPAWN",
    "Nether",
    "End",
    "Abidos",
    "Chulak",
    "Glacio",
    "Other",
    "Beyond",
    "Aether",
    "Void",
    "Mining",
    "Everbri",
    "otherSide",
    "marble",
    "lostCity",
    "Atlantis",
    "MYST&AJ",
    "MainTF",
    "Asteria",
    "Moon",
    "mars",
    "Venus",
    "Mercury"
    }

-- outgoing variables
local touchEvent = false
local nameOfDest = ""
local destAddress = {}
local buttonXY = {}
local destAddressname = ""
local x = 0
local y = 0
local selx = 0
local sely = 0
local dialing = false

--Incoming variables
local incomingWormhole = false
local IncomingAddress = nil
local incomingNameMatch = ""
local incomingEntityType = ""
local incomingEntityName = ""

-- menu/general variables

local choice = 0
local disconnnect = false

 
function SelectDial() --Draws screen for address selection
 
    mon.setBackgroundColor(colors.black)

        local x1 = 0
        local x2 = 0
        local count = 0
        
        y = 2

        mon.clear()
        mon.setBackgroundColor(colors.green)
        for i = 1,#screenNames do
            
            if count == 0 then
                x = 2
                count = count + 1
            elseif count == 1 then
                x=11
                count = count + 1
            else
                x = 20
                count = count + 1
            end
            mon.setCursorPos(x,y)

            
    
            if screenNames[i] == "Moon" then
                mon.setBackgroundColor(colors.red)
            end
            mon.write(screenNames[i])
    
            x1 = x
            x2 = x + 7
    
            table.insert(buttonXY, {x1,x2,y})

            if count == 3 then
                y = y + 2
                count = 0
            end
            
        end
    
    
    return 1
end


function GetClick() -- gets click information
    mon.setTextScale(1)
    local event, _, xPos, yPos = os.pullEvent("monitor_touch")
    return xPos, yPos
end

function GetActivation() -- gets incoming wormhole event
    IncomingAddress = os.pullEvent("stargate_incoming_wormhole")
    incomingWormhole = true
    return 1
end

function CheveronActivation() -- checks if cheverons are activating on their own
    local event,_,incomingBool = os.pullEvent("stargate_chevron_engaged")
    if incomingBool == true then
        incomingWormhole = true
        print("external dial")
        
    else
        incomingWormhole =  false
        print("internal dial")
        end
    return 1
end

function EntityRead() --reads incoming entities
    
    _, incomingEntityType, incomingEntityName, _ = os.pullEvent("stargate_reconstructing_entity")
    return 1
end

function DisconnectCheck() -- does exactly what you think it does (if an unexpected error is thrown this siezes the program too)
    
    local disCode = os.pullEvent("stargate_disconnected")
    if (disCode ~= 7 or 8 or 9 or 10 or -1 or -15 or -16 or -19 or "stargate_disconnected") then
        
            print(disCode)
        
    end
    return 2
end

function PRIMARYwormholeIncoming() --code dealing with incoming wormholes and incoming entities
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setBackgroundColor(colors.red)
    mon.setTextScale(1)
    mon.setCursorPos(9,4)
    mon.write("INCOMING")

    local gateType = gate.getStargateType()
    

    
    IncomingAddress = gate.getConnectedAddress()

    local stringIA = gate.addressToString(IncomingAddress)
    -- print(IncomingAddress)

    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setBackgroundColor(colors.red)
    mon.setTextScale(1)

    for i = 1, #gateTable do
        if gateTable[i] == IncomingAddress then
            incomingNameMatch = screenNames[i]
        end
    end
    mon.setCursorPos(1,2)
    mon.write("incoming wormhole from")
    mon.setCursorPos(1,3)
    mon.write(incomingNameMatch)
    mon.setCursorPos(1,4)
    print(stringIA)
    mon.write(stringIA)

    IncomingAddress = nil


    sleep(2)
    while (disconnnect == false) do 
        local incomingcheck = parallel.waitForAny(EntityRead, DisconnectCheck, ParaDisconnect)
        if (incomingcheck == 1) then
            mon.setTextScale(1)
            mon.setCursorPos(1,6)
            mon.write(incomingEntityType)
            print(incomingEntityType)
            mon.setCursorPos(1,8)
            mon.write(incomingEntityName)
            print(incomingEntityName)
            incomingEntityType = ""
            incomingEntityName = ""
        else
            disconnnect = true
        end

    
    end
    disconnnect = false
end

function Dial(address) --borrowed code to dial the gate. credit: Povstalec
    --Milky Way Stargate is a special case when it comes
    --to dialing

    local gateType = gate.getStargateType()

    if gateType == "sgjourney:milky_way_stargate" then

        mon.setBackgroundColor(colors.black)
        mon.clear()
        mon.setBackgroundColor(colors.red)
        mon.setTextScale(2)
        mon.setCursorPos(2,3)
        mon.write("DIALING GATE") 
        
        local addressLength = #address
        --You don't really need to have this variable,
        --I just like to use lots of variables with
        --names to make everything immediately clear

        if addressLength == 8 then
            gate.setChevronConfiguration({1, 2, 3, 4, 6, 7, 8, 5})
        elseif addressLength == 9 then
            gate.setChevronConfiguration({1, 2, 3, 4, 5, 6, 7, 8})
        end
        
        local start = gate.getChevronsEngaged() + 1
        --This is a helpful variable we'll be using to
        --make resuming dialing easier.
        --Basically what this does is it makes the computer
        --check how many chevrons are engaged and start from
        --the next one (that's why there's a +1)
        
        for chevron = start,addressLength,1
        do
            --This is a loop that will go through all the
            --symbols in an address

            
            
            local symbol = address[chevron]
            
            if chevron % 2 == 0 then
                gate.rotateClockwise(symbol)
            else
                gate.rotateAntiClockwise(symbol)
            end
            --Here we're basically making sure the gate ring
            --rotates clockwise when the number of chevrons
            --engaged is even and counter-clockwise when odd
            
            while(not gate.isCurrentSymbol(symbol))
            do
                sleep(0)
            end
            --This effectively ensures the program doesn't
            --do anything else and lets the dialing finish
            --rotating to the correct symbol
            
            sleep(1)
            --We want to wait 1 second before we
            --engage the chevron
            gate.openChevron() --This opens the chevron
            sleep(1)
            gate.closeChevron() -- and this closes it
            sleep(1)

            mon.setBackgroundColor(colors.black)
            mon.clear()
            mon.setBackgroundColor(colors.red)
            mon.setTextScale(2)
            mon.setCursorPos(2,3)
            mon.write("DIALING GATE") 
            mon.setCursorPos(4,5)
            mon.write("CHEVERON")
            mon.setCursorPos(7,7)
            mon.setBackgroundColor(colors.black)
            mon.write(chevron)
            mon.setBackgroundColor(colors.red)
            

            if symbol ~= 0 then
                mon.setCursorPos(4,9)
                mon.write("ENGAGED") 
            else 
                mon.setCursorPos(5,9)
                mon.setBackgroundColor(colors.green)
                mon.write("LOCKED")
                
            end
            
            --Note that from many of the functions here,
            --you can get Stargate Feedback
            
            --For example, the raiseChevron() function will output
            --a number corresponding to some feedback value which you'll
            --be able to find in the video description
        end 
    else
        mon.setBackgroundColor(colors.black)
        mon.clear()
        mon.setBackgroundColor(colors.red)
        mon.setTextScale(2)
        mon.setCursorPos(2,3)
        mon.write("DIALING GATE") 
        
        local addressLength = #address
        --You don't really need to have this variable,
        --I just like to use lots of variables with
        --names to make everything immediately clear

        if addressLength == 8 then
            gate.setChevronConfiguration({1, 2, 3, 4, 6, 7, 8, 5})
        elseif addressLength == 9 then
            gate.setChevronConfiguration({1, 2, 3, 4, 5, 6, 7, 8})
        end
        
        local start = gate.getChevronsEngaged() + 1
        --This is a helpful variable we'll be using to
        --make resuming dialing easier.
        --Basically what this does is it makes the computer
        --check how many chevrons are engaged and start from
        --the next one (that's why there's a +1)
        
        for chevron = start,addressLength,1
        do
            --This is a loop that will go through all the
            --symbols in an address

            
            
            local symbol = address[chevron]
            
            -- if chevron % 2 == 0 then
            --     gate.rotateClockwise(symbol)
            -- else
            --     gate.rotateAntiClockwise(symbol)
            -- end
            -- --Here we're basically making sure the gate ring
            -- --rotates clockwise when the number of chevrons
            -- --engaged is even and counter-clockwise when odd
            gate.engageSymbol(symbol)
            sleep(gatespeed)
            

            
            
            -- while(not gate.isCurrentSymbol(symbol))
            -- do
            --     sleep(0)
            -- end
            --This effectively ensures the program doesn't
            --do anything else and lets the dialing finish
            --rotating to the correct symbol
            
            -- sleep(1)
            -- --We want to wait 1 second before we
            -- --engage the chevron
            -- gate.openChevron() --This opens the chevron
            -- sleep(1)
            -- gate.closeChevron() -- and this closes it
            -- sleep(1)

            

            mon.setBackgroundColor(colors.black)
            mon.clear()
            mon.setBackgroundColor(colors.red)
            mon.setTextScale(2)
            mon.setCursorPos(2,3)
            mon.write("DIALING GATE") 
            mon.setCursorPos(4,5)
            mon.write("CHEVERON")
            mon.setCursorPos(7,7)
            mon.setBackgroundColor(colors.black)
            mon.write(chevron)
            mon.setBackgroundColor(colors.red)
            

            if (symbol) ~= 0 then
                mon.setCursorPos(4,9)
                mon.write("ENGAGED") 
            else 
                mon.setCursorPos(5,9)
                mon.setBackgroundColor(colors.green)
                mon.write("LOCKED")
                
                
            end

            
            
            --Note that from many of the functions here,
            --you can get Stargate Feedback
            
            --For example, the raiseChevron() function will output
            --a number corresponding to some feedback value which you'll
            --be able to find in the video description
        end
    end

end

function ParaDial() -- seperating touch dialing so timeout function can work
    while dialing == false do

        selx, sely = GetClick()
        for i = 1, #buttonXY do

        
            if (sely == buttonXY[i][3]) and ((selx >= buttonXY[i][1]) and (selx <= buttonXY[i][2])) then
            
                Dial(gateTable[i])
                destAddressname = screenNames[i]
                destAddress = gateTable[i]
                dialing = true
                sely = (0)
                selx = (0)
            end
        end    
    end
    return 1
end

function Paratimeout() -- timeout function
    sleep(300)
    return 2
end

function ParaDisconnect() -- parrallel function for disconnecting
    local dx = 0
    local dy = 0
    
    _, _, dx, dy = os.pullEvent("monitor_touch")
    
    if ((dx ~= 0) and (dy ~= 0)) then
        gate.disconnectStargate()
    end
    return 1
end

function DialText()
    -- mon.setBackgroundColor(colors.black)
    -- mon.clear()
    -- mon.setBackgroundColor(colors.red)
    -- mon.setTextScale(2)
    -- mon.setCursorPos(9,1)
    -- mon.write("DIALING GATE") 
    mon.setBackgroundColor(colors.green)
    mon.clear()
    mon.setTextScale(1)
    mon.setCursorPos(6,5)
    mon.write(destAddressname)

    mon.setCursorPos(3,10)
    for i = 1, #destAddress do
        mon.write(destAddress[i])
        mon.write(" ")
    end
    destAddress = {}
    destAddressname = ""
end

function PRIMARYDialingOut() -- what it says
    
    local PDO = 0


   
    PDO = parallel.waitForAny(SelectDial, Paratimeout)
    

    if (PDO == 1) then
        
        ParaDial()

        os.pullEvent(stargate_outgoing_wormhole)
        
        DialText()

        if (gate.isStargateConnected() == true) then
            
            PDO = parallel.waitForAny(DisconnectCheck, ParaDisconnect, Paratimeout)
            dialing = false
        else 
        end
    end

        
end

function Menu()
    while true do
        mon.setTextScale(1)
        mon.setBackgroundColor(colors.black)
        mon.clear()
        mon.setCursorPos(9,1)
        mon.setBackgroundColor(colors.red)
        mon.write("press to start")

        local answer = parallel.waitForAny(GetClick, CheveronActivation, GetActivation)

        if (answer == 1) then
            PRIMARYDialingOut()
        else
            if incomingWormhole == true then
            PRIMARYwormholeIncoming()
            end
        end
    end
end
-- 29x19
 



 
Menu()
    
 