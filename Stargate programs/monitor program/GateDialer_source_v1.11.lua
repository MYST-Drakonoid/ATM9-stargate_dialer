


--update this to change how fast the gate dials on non universe or direct encoding milky way gates--
local FastGateSpeed = .05

local medGateSpeed = .5

local slowGateSpeed = 1



-- four gate catagories , MAIN GATES for those gates that are mostly dialled with 7 chevron addresses
-- player gates for those gates that are direct dialing other players bases (mostly 9 cheveron addresses)
-- hazard gates for gates that are hostile on the destination
-- private 9 cheveron gates for specific players




-------------------------------------------------------------------------------------------------------------
-----------DONT FIDDLE WITH ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING----------------------
-------------------------------------------------------------------------------------------------------------

settings.load()

local fullGates = 

-- Main Gate Addresses
local MainGates = 

-- player gate addresses
local playerGates = 

-- hazard gate addresses
local hazardGates = 

-- personal gate addresses
local privateGates = 

local mon = peripheral.find("monitor")
local gate = peripheral.find("advanced_crystal_interface") or peripheral.find("crystal_interface") or peripheral.find("basic_interface")
if gate == nil then
    error("The interface is not connected")
end
gate.disconnectStargate()









-- outgoing variables
local destAddress = {}
local buttonXY = {}
local computerAddresses = {}
local computerNames = {}
local destAddressname = ""
local x = 0
local y = 0
local selx = 0
local sely = 0
local dialing = false
local totalstate = nil



--Incoming variables
local incomingWormhole = false
local IncomingAddress = {}
local incomingNameMatch = ""
local incomingEntityType = ""
local incomingEntityName = ""

-- menu/general variables

local choice = 0
local disconnnect = false


local function screenWrite(list,fcount, fy)
    local internaladdress = {}

    for i = 1, #list do
        local x1 = 0
        local x2 = 0

        if fcount == 0 then
            x = 2
            fcount = fcount + 1
        elseif fcount == 1 then
            x=11
            fcount = fcount + 1
        else
            x = 20
            fcount = fcount + 1
        end
        mon.setCursorPos(x,fy)

        mon.write(list[i][1])

        x1 = x
        x2 = x + 7

        table.insert(buttonXY, {x1,x2,fy})

        table.insert(computerNames, list[i][1])

        local addresstranslate = list[i]
        for i = 2, #addresstranslate do 
            table.insert(internaladdress, addresstranslate[i])
        end
        table.insert(computerAddresses, internaladdress)
        internaladdress = {}

        if fcount == 3 then
            fy = fy + 2
            fcount = 0
        end
    end

    local oldterm = term.redirect(mon)

    paintutils.drawFilledBox(23,17,28,19,colors.red)
    mon.setCursorPos(24,18)
    mon.write("Back")

    term.redirect(oldterm)
    return fcount, fy
end

local function SelectDial() --Draws screen for address selection
 
    

    local x1 = 0
    local x2 = 0
    local count = 0
    
    y = 2

    mon.setBackgroundColor(colors.black)
    mon.clear()
    
    if #MainGates ~= 0 then
        mon.setBackgroundColor(colors.purple)
        count, y = screenWrite(MainGates,count,y)
    end

    if #playerGates ~= 0 then
        mon.setBackgroundColor(colors.green)
        count, y = screenWrite(playerGates,count,y)
    end

    if (#hazardGates ~= 0) and (canAccessHazardGates == true) then
        mon.setBackgroundColor(colors.red)
        count, y = screenWrite(hazardGates,count,y)
    end

    if (privateGates ~= 0) and (canAccessPrivateGates == true) then
        mon.setBackgroundColor(colors.blue)
        count, y = screenWrite(privateGates,count,y)
    end
    
    return 1
end

local function GetClick() -- gets click information
    mon.setTextScale(1)
    local _, _, xPos, yPos = os.pullEvent("monitor_touch")
    return xPos, yPos
end

local function GetActivation() -- gets incoming wormhole event
    _, IncomingAddress = os.pullEvent("stargate_incoming_wormhole")
    incomingWormhole = true
    return 1
end

local function CheveronActivation() -- checks if cheverons are activating on their own
    local _,_,_,incomingBool = os.pullEvent("stargate_chevron_engaged")
    if incomingBool == true then
        incomingWormhole = true
        print("external dial")
        
    else
        incomingWormhole =  false
        print("internal dial")
        end
    return 1
end

local function ParaDisconnect() -- parrallel function for disconnecting
    local dx = 0
    local dy = 0
    
    _, _, dx, dy = os.pullEvent("monitor_touch")
    
    if ((dx ~= 0) and (dy ~= 0)) then
        gate.disconnectStargate()
        redstone.setOutput("top",false)
    end
    return 1
end

local function EntityRead() --reads incoming entities
    
    sleep (.1)
    _, incomingEntityType, incomingEntityName, _ = os.pullEvent("stargate_reconstructing_entity")
    return 1
end

local function DisconnectCheck() -- does exactly what you think it does (if an unexpected error is thrown this siezes the program too)
    
    local _,_,disCode = os.pullEvent("stargate_disconnected")
    if (disCode ~= 7 or 8 or 9 or 10 or -1 or -15 or -16 or -19 or "stargate_disconnected") then
            redstone.setOutput("top",false)
            print(disCode)
        
    end
    return 2
end

local function PRIMARYwormholeIncoming() --code dealing with incoming wormholes and incoming entities
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setBackgroundColor(colors.red)
    mon.setTextScale(1)
    mon.setCursorPos(9,4)
    mon.write("INCOMING")

    local gateType = gate.getStargateType()
    
    if gateType ~= "sgjourney:universe_stargate" then
        IncomingAddress = os.pullEvent("stargate_incoming_wormhole")
    end
    
    if gate.isWormholeOpen() and gateType == "sgjourney:universe_stargate" then
        IncomingAddress = gate.getConnectedAddress()
      end
    
    -- local stringIA = gate.addressToString(IncomingAddress)
    -- print(IncomingAddress)

    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setBackgroundColor(colors.red)
    mon.setTextScale(1)

    
    mon.setCursorPos(1,2)
    mon.write("incoming wormhole established")
    
    -- mon.setCursorPos(1,4)
    -- print(stringIA)
    -- mon.write(stringIA)
    
    IncomingAddress = nil


    
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

local function Dial(address) --borrowed code to dial the gate. credit: Povstalec
    --Milky Way Stargate is a special case when it comes
    --to dialing

    print(gate.addressToString(address))

    local gateType = gate.getStargateType()

    if gateType == "sgjourney:milky_way_stargate" and manualDial == true then

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

        if gateType ~= "sgjourney:universe_stargate" then

            if addressLength == 8 then
                gate.setChevronConfiguration({1, 2, 3, 4, 6, 7, 8, 5})
            elseif addressLength == 9 then
                gate.setChevronConfiguration({1, 2, 3, 4, 5, 6, 7, 8})
            end
        end

        local start = gate.getChevronsEngaged() + 1 --makes sure the gate starts where its supposed to



        for chevron = start,#address,1 --dialing loop
        do

            local symbol = address[chevron]

            gate.engageSymbol(symbol)
            sleep(gatespeed)

            

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


            if (gateType == "sgjourney:universe_stargate") or (gateType == "sgjourney:pegasus_stargate")  then
                os.pullEvent(gate.stargate_chevron_engaged) 
            end

            else 
                if gateType == "sgjourney:universe_stargate" then
                    os.pullEvent(gate.stargate_chevron_engaged)
                    redstone.setOutput("top",true)
                elseif (gateType == "sgjourney:pegasus_stargate") then
                    os.pullEvent(gate.stargate_chevron_engaged)
                end

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

        address = nil
    end

end

local function ParaDial() -- seperating touch dialing so timeout function can work

    local selecting = true
    while dialing == false and selecting == true do

        selx, sely = GetClick()
        for i = 1, #buttonXY do

            if (sely == buttonXY[i][3]) and ((selx >= buttonXY[i][1]) and (selx <= buttonXY[i][2])) then

                Dial(computerAddresses[i])
                destAddressname = computerNames[i]
                destAddress = computerAddresses[i]
                dialing = true
                sely = (0)
                selx = (0)

            elseif sely >= 17 and selx >= 23 then
                selecting = false
                sely = (0)
                selx = (0)
            end
        end

        local buttonXY = {}
        local computerAddresses = {}
        local computerNames = {}
        
    end
    return dialing
end

local function selectionTabs()
    mon.setBackgroundColor(colors.black)
    mon.clear()
    local oldterm = term.redirect(mon)

    if #MainGates ~= 0 then
        paintutils.drawFilledBox(2,2,13,6,colors.purple)
        mon.setCursorPos(4,4)
        mon.setBackgroundColor(colors.purple)
        mon.write("Main Gates")
    end

    if #playerGates ~= 0 then
        paintutils.drawFilledBox(16,2,27,6,colors.green)
        mon.setCursorPos(18,4)
        mon.setBackgroundColor(colors.green)
        mon.write("Player")
        mon.setCursorPos(18,5)
        mon.write("Base gates")
    end

    if (#hazardGates ~= 0) and (canAccessHazardGates == true) then
        paintutils.drawFilledBox(2,8,13,12,colors.red)
        mon.setCursorPos(4,9)
        mon.setBackgroundColor(colors.red)
        mon.write("Hazard")
        mon.setCursorPos(4,11)
        mon.write("gates")
    end

    if (#privateGates ~= 0) and (canAccessPrivateGates == true) then
        paintutils.drawFilledBox(16,8,27,12,colors.blue)
        mon.setCursorPos(18,9)
        mon.setBackgroundColor(colors.blue)
        mon.write("Private")
        mon.setCursorPos(18,11)
        mon.write("gates")
    end

    paintutils.drawFilledBox(23,17,28,19,colors.red)
    mon.setCursorPos(24,18)
    mon.write("Back")

    term.redirect(oldterm)
end

local function tabSelector()
    

    local state = true
    
    
    while state == true do
        mon.setBackgroundColor(colors.black)
        mon.clear()
        
        selectionTabs()

        local tabx, taby = GetClick()

        y = 2
        local count = 0

        if (taby >= 2) and (taby <= 6) and ((tabx >= 2) and (tabx <= 13)) then

            if #MainGates ~= 0 then
                mon.setBackgroundColor(colors.black)
                mon.clear()

                mon.setBackgroundColor(colors.purple)
                count, y = screenWrite(MainGates,count,y)

                local returnstate = ParaDial()

                if returnstate == true then
                    state = false
                end

                computerAddresses = {}
                computerNames = {}
            else
                mon.setCursorPos(9,7)
                mon.write("no gates available")
                sleep(5)
            end

        elseif (taby >= 2) and (taby <= 6) and ((tabx >= 16) and (tabx <= 27)) then
            if #playerGates ~= 0 then
                mon.setBackgroundColor(colors.black)
                mon.clear()

                mon.setBackgroundColor(colors.green)
                count, y = screenWrite(playerGates,count,y)

                local returnstate = ParaDial()

                if returnstate == true then
                    state = false
                end

                computerAddresses = {}
                computerNames = {}
            else
                mon.setCursorPos(9,7)
                mon.write("no gates available")
                sleep(5)
            end

        elseif (((taby >= 8) and (taby <= 12)) and ((tabx >= 2) and (tabx <= 13))) and (canAccessHazardGates == true) then
            if (#hazardGates ~= 0) and (canAccessHazardGates == true) then
                mon.setBackgroundColor(colors.black)
                mon.clear()

                mon.setBackgroundColor(colors.red)
                count, y = screenWrite(hazardGates,count,y)

                local returnstate = ParaDial()

                if returnstate == true then
                    state = false
                end

                computerAddresses = {}
                computerNames = {}
            else
                mon.setCursorPos(9,7)
                mon.write("no gates available")
                sleep(5)
            end

        elseif (((taby >= 8) and (taby <= 12)) and ((tabx >= 16) and (tabx <= 27))) and (canAccessPrivateGates == true) then
            if (#privateGates ~= 0) and (canAccessPrivateGates == true) then
                mon.setBackgroundColor(colors.black)
                mon.clear()

                mon.setBackgroundColor(colors.blue)
                count, y = screenWrite(privateGates,count,y)

                local returnstate = ParaDial()

                if returnstate == true then
                    state = false
                end

                computerAddresses = {}
                computerNames = {}
            else
                mon.setCursorPos(9,7)
                mon.write("no gates available")
                sleep(5)
            end

        elseif (taby >= 17) and  (tabx >= 23) then
            state = false
            totalstate = false
        end
    end
    return 1
end

local function Paratimeout() -- timeout function
    sleep(300)
    return 2
end



local function DialText()
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

local function PRIMARYDialingOut() -- what it says
    totalstate = true
    local PDO = 0
   
    PDO = parallel.waitForAny(tabSelector, Paratimeout)
    

    if (PDO == 1) and totalstate == true then

        sleep(1)

        os.pullEvent(stargate_outgoing_wormhole)
        
        DialText()

        if (gate.isStargateConnected() == true) then
            
            PDO = parallel.waitForAny(DisconnectCheck, ParaDisconnect, Paratimeout)
            dialing = false
        else 
        end
    end
    computerAddresses = {}
    computerNames = {}

        
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
    
 