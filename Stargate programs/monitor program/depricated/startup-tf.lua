local mon = peripheral.wrap("top") 
local gate = peripheral.find("advanced_crystal_interface")
gate.disconnectStargate()

 
-- gate addresses
local overworld = {27,25,4,35,10,28,0} 
local theNether = {27,23,4,34,12,28,0}
local theEnd    = {13,24,2,19,3,30,0}
local abidos    = {26,6,14,31,11,29,0}
local chulak    = {8,1,22,14,36,19,0}
local glacio    = {26,20,4,36,9,27,0}
local theOther  = {34,14,25,35,17,33,0}
local theBeyond = {21,22,5,11,20,27,0}
local theAether = {10,9,6,28,21,35,0}
local voidscape = {20,10,26,5,18,3,0}
local twiforest = {26,28,13,33,7,35,0}
local miningdim = {16,7,9,29,5,1,0}
local everbright= {8,16,7,25,19,30,0}
local otherSide = {23,11,21,10,26,31,0}
local marble    = {25,34,29, 30,5,15,0}
local lostCity  = {25,5,32,35,23,2,0}
local lanteaAddress = {18,20,1,15,14,7,19,0}
local mainTF = {25,2,24,19,9,6,1,11,0}
local MYSTAJ = {11,13,2,34,25,3,28,1,0}
local moon      = {33,18,28,15,22,16,9,13,0}
local mars      = {6,8,25,28,33,12,30,35,0}
local venus     = {34,17,21,6,15,27,5,30,0}
local mercury   = {23,4,18,5,31,1,2,22,0}

-- outgoing variables
local touchEvent = false
local nameOfDest = ""
local destAddress = {}
local destAddressname = ""
local x = 0
local y = 0
local dialing = false

--Incoming variables
local incomingWormhole = false
local IncomingAddress = {}
local incomingNameMatch = ""
local incomingEntityType = ""
local incomingEntityName = ""

-- menu/general variables

local choice = 0
local disconnnect = false

 
function SelectDial() --Draws screen for address selection
 
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setTextColor(colors.white)
    mon.setBackgroundColor(colors.green)
    mon.setTextScale(1)
    -- listing addresses on monitor
    
    -- overworld 
    --mon.setCursorPos(2,2)
    --mon.write("Earth")
    -- Everbright
    mon.setCursorPos(2,2)
    mon.write("Earth")
    -- the nether
    mon.setCursorPos(11,2)
    mon.write("Nether")
    -- the End
    mon.setCursorPos(20,2)
    mon.write("End")
    -- Abidos
    mon.setCursorPos(2,4)
    mon.write("Abidos")
    -- Chulak
    mon.setCursorPos(11,4)
    mon.write("Chulak")
    -- Glacio
    mon.setCursorPos(20,4)
    mon.write("Glacio")
    -- The Other
    mon.setCursorPos(2,6)
    mon.write("Other")
    -- The Beyond
    mon.setCursorPos(11,6)
    mon.write("Beyond")
    -- the Aether
    mon.setCursorPos(20,6)
    mon.write("Aether")
    -- Voidscape
    mon.setCursorPos(2,8)
    mon.write("Void")
    -- Twilight Forest
    mon.setCursorPos(11,8)
    mon.write("Everbri")
    -- Mining Dimension
    mon.setCursorPos(20,8)
    mon.write("Mining")
    --marble
    --mon.setCursorPos(2,10)
    --mon.write("marble")
    -- otherSide
    mon.setCursorPos(11,10)
    mon.write("otherSide")
    -- Lost city
    mon.setCursorPos(20,10)
    mon.write("lostCity")
    --marble
    mon.setCursorPos(2,12)
    mon.write("Atlantis")
    -- MAIN TF
    mon.setCursorPos(11,12)
    mon.write("Main TF")

    mon.setBackgroundColor(colors.red)
    -- moon
    mon.setCursorPos(20,12)
    mon.write("Moon")
    --mars
    mon.setCursorPos(2,14)
    mon.write("mars")
    -- venus
    mon.setCursorPos(11,14)
    mon.write("Venus")
    -- Mercury
    mon.setCursorPos(20,14)
    mon.write("Mercury")

    mon.setBackgroundColor(colors.green)
    -- MAIN TF
    mon.setCursorPos(20,16)
    mon.write("MYST&AJ")
    mon.setBackgroundColor(colors.red)




    
    return 1
end


function GetClick() -- gets click information
    mon.setTextScale(1)
    local event, _, xPos, yPos = os.pullEvent("monitor_touch")
    return xPos, yPos
end

function GetActivation() -- gets incoming wormhole event
    local wormholeaddress = os.pullEvent("stargate_incoming_wormhole")
    return wormholeaddress
end

function CheveronActivation() -- checks if cheverons are activating on their own
    local event,_,incomingBool = os.pullEvent("stargate_chevron_engaged")
    if incomingBool == true then
        incomingWormhole = true
        
    else
        incomingWormhole =  false
        end
end

function EntityRead() --reads incoming entities
    
    incomingEntityType, incomingEntityName, _ = os.pullEvent("stargate_reconstructing_entity")
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

    IncomingAddress = os.pullEvent("stargate_incoming_wormhole")

    -- local stringIA = gate.addressToString(IncomingAddress)
    print(IncomingAddress)

    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setBackgroundColor(colors.red)
    mon.setTextScale(1)
    mon.setCursorPos(1,4)
    mon.write(IncomingAddress)
    IncomingAddress = {}


    sleep(2)
    while (disconnnect == false) do 
        local incomingcheck = parallel.waitForAny(EntityRead, DisconnectCheck, ParaDisconnect)
        if (incomingcheck == 1) then
            mon.setBackgroundColor(colors.black)
            mon.clear()
            mon.setBackgroundColor(colors.red)
            mon.setTextScale(1)
            mon.setCursorPos(1,4)
            mon.write(incomingEntityType)
            print(incomingEntityType)
            mon.setCursorPos(1,7)
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
            sleep(1)

            
            
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
    end

end


function ParaDial() -- seperating touch dialing so timeout function can work
    while dialing == false do
        x = 0
        y = 0
        x, y = GetClick()

        
        -- if (y == 2) and ((x >= 2) and (x <= 9)) then
        --     Dial(overworld)
        --     destAddress = overworld
        --     dialing = true
        if (y == 2) and ((x >= 2) and (x <= 9)) then
            Dial(overworld)
            destAddressname = "earth"
            dialing = true
        elseif (y == 2) and ((x >= 11) and (x <= 18)) then
            Dial(theNether)
            destAddressname = "the Nether"
            dialing = true
        elseif (y == 2) and ((x >= 20) and (x <= 27)) then
            Dial(theEnd)
            destAddressname = "the End"
            dialing = true
        elseif (y == 4) and ((x >= 2) and (x <= 9)) then
            Dial(abidos)
            destAddressname = "abidos"
            dialing = true
        elseif (y == 4) and ((x >= 11) and (x <= 18)) then
            Dial(chulak)
            destAddressname = "chulak"
            dialing = true
        elseif (y == 4) and ((x >= 20) and (x <= 27)) then
            Dial(glacio)
            destAddressname = "glacio"
            dialing = true
        elseif (y == 6) and ((x >= 2) and (x <= 9)) then
            Dial(theOther)
            destAddressname = "the Other"
            dialing = true
        elseif (y == 6) and ((x >= 11) and (x <= 18)) then
            Dial(theBeyond)
            destAddressname = "the Beyond"
            dialing = true
        elseif (y == 6) and ((x >= 20) and (x <= 27)) then
            Dial(theAether)
            destAddressname = "the Aether"
            dialing = true
        elseif (y == 8) and ((x >= 2) and (x <= 9)) then
            Dial(voidscape)
            destAddressname = "voidscape"
            dialing = true
        elseif (y == 8) and ((x >= 11) and (x <= 18)) then
            Dial(everbright)
            destAddressname = "everbright"
            dialing = true
        elseif (y == 8) and ((x >= 20) and (x <= 27)) then
            Dial(miningdim)
            destAddressname = "miningdim"
            dialing = true
        elseif (y == 10) and ((x >= 2) and (x <= 9)) then
            Dial(marble)
            destAddressname = "marble"
            dialing = true
        elseif (y == 10) and ((x >= 11) and (x <= 18)) then
            Dial(otherSide)
            destAddressname = "otherSide"
            dialing = true
        elseif (y == 10) and ((x >= 20) and (x <= 27)) then
            Dial(lostCity)
            destAddressname = "lostCity"
            dialing = true
        elseif (y == 12) and ((x >= 2) and (x <= 9)) then
            Dial(lanteaAddress)
            destAddressname = "Atlantis"
            dialing = true
        elseif (y == 12) and ((x >= 11) and (x <= 18)) then
            Dial(mainTF)
            destAddressname = "main TF"
            dialing = true
        elseif (y == 12) and ((x >= 20) and (x <= 27)) then
            Dial(moon)
            destAddressname = "the Moon"
            dialing = true
        elseif (y == 14) and ((x >= 2) and (x <= 9)) then
            Dial(mars)
            destAddressname = "Mars"
            dialing = true
        elseif (y == 14) and ((x >= 11) and (x <= 18)) then
            Dial(venus)
            destAddressname = "Venus"
            dialing = true
        elseif (y == 14) and ((x >= 20) and (x <= 27)) then
            Dial(mercury)
            destAddressname = "Mercury"
            dialing = true
        elseif (y == 16) and ((x >= 20) and (x <= 27)) then
            Dial(MYSTAJ)
            destAddressname = "MYST & AJ"
            dialing = true
        else
            
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
    mon.setTextScale(2)
    mon.setCursorPos(2,5)
    mon.write(destAddressname)
    mon.setCursorPos(2,7)
    local foraddress = gate.addressToString(destAddress)
    mon.write(destAddress)
    print(destAddress)
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

        local answer = parallel.waitForAny(GetClick, CheveronActivation)

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
    
 