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
    mon.setBackgroundColor(colors.red)
    mon.setTextScale(1)
    -- listing addresses on monitor
    
    -- overworld 
    --mon.setCursorPos(2,2)
    --mon.write("Earth")
    -- Everbright
    mon.setCursorPos(2,2)
    mon.write("Everbri")
    -- the nether
    mon.setCursorPos(11,2)
    mon.write("Nether")
    -- the End
    --mon.setCursorPos(20,2)
    --mon.write("End")s
    -- Abidos
    mon.setCursorPos(2,4)
    mon.write("Abidos")
    -- Chulak
    mon.setCursorPos(11,4)
    mon.write("Chulak")
    -- Glacio
    --mon.setCursorPos(20,4)
    --mon.write("Glacio")
    -- The Other
    mon.setCursorPos(2,6)
    mon.write("Other")
    -- The Beyond
    --mon.setCursorPos(11,6)
    --mon.write("Beyond")
    -- the Aether
    mon.setCursorPos(20,6)
    mon.write("Aether")
    -- Voidscape
    --mon.setCursorPos(2,8)
    --mon.write("Void")
    -- Twilight Forest
    mon.setCursorPos(11,8)
    mon.write("Twilight")
    -- Mining Dimension
    mon.setCursorPos(20,8)
    mon.write("Mining")
    --marble
    --mon.setCursorPos(2,10)
    --mon.write("marble")
    -- Twilight Forest
    --mon.setCursorPos(11,10)
    --mon.write("otherSide")
    -- Mining Dimension
    mon.setCursorPos(20,10)
    mon.write("lostCity")

    
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
        return true
        
    else
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


    
    while (disconnnect == false) do 
        local incomingcheck = parallel.waitForAny(EntityRead, DisconnectCheck)
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
            
            --Note that from many of the functions here,
            --you can get Stargate Feedback
            
            --For example, the raiseChevron() function will output
            --a number corresponding to some feedback value which you'll
            --be able to find in the video description
            
        end 
end


function ParaDial() -- seperating touch dialing so timeout function can work
    while dialing == false do
        -- if (y == 2) and ((x >= 2) and (x <= 9)) then
        --     Dial(overworld)
        --     destAddress = overworld
        --     dialing = true
        if (y == 2) and ((x >= 2) and (x <= 9)) then
            Dial(everbright)
            destAddressname = "everbright"
            dialing = true
        elseif (y == 2) and ((x >= 11) and (x <= 18)) then
            Dial(theNether)
            destAddressname = "theNether"
            dialing = true
        elseif (y == 2) and ((x >= 20) and (x <= 27)) then
            Dial(theEnd)
            destAddressname = "theEnd"
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
            destAddressname = "theOther"
            dialing = true
        elseif (y == 6) and ((x >= 11) and (x <= 18)) then
            Dial(theBeyond)
            destAddressname = "theBeyond"
            dialing = true
        elseif (y == 6) and ((x >= 20) and (x <= 27)) then
            Dial(theAether)
            destAddressname = "theAether"
            dialing = true
        elseif (y == 8) and ((x >= 2) and (x <= 9)) then
            Dial(voidscape)
            destAddressname = "voidscape"
            dialing = true
        elseif (y == 8) and ((x >= 11) and (x <= 18)) then
            Dial(twiforest)
            destAddressname = "twiforest"
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
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setBackgroundColor(colors.red)
    mon.setTextScale(2)
    mon.setCursorPos(9,1)
    mon.write("DIALING GATE") 
    mon.setCursorPos(11,1)
    mon.write(destAddressname)
    mon.setCursorPos(13,1)
    mon.write(gate.addressToString(destAddress))
    print(gate.addressToString(destAddress))
    destAddress = {}
    destAddressname = ""

end



function PRIMARYDialingOut() -- what it says
    
    local PDO = 0


    while (dialing == false) do 
        PDO = parallel.waitForAny(SelectDial, Paratimeout)
    end

    if (PDO == 1) then
        x, y = GetClick()

        ParaDial()
        
        DialText()

        if (gate.isStargateConnected() == true) then
            
            PDO = parallel.waitForAny(ParaDisconnect, Paratimeout)
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
            PRIMARYwormholeIncoming()
        end
    end
end
-- 29x19
 



 
Menu()
    
 