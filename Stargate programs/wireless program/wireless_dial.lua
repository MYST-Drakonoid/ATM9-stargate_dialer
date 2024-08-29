--update this to change how fast the gate dials on non universe or manualy dialing milky way gates--
local gatespeed = .5

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



-------------------------------------------------------------------------------------------------------------
-----------DONT FIDDLE WITH ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING----------------------
-------------------------------------------------------------------------------------------------------------




-- 26x20

modem = peripheral.find("modem")

local buttonXY = {}
local computerAddresses = {}
local computerNames = {}
local gate = nil

local pComp = nil

local selAdress = nil

local _,_,_,reply,signal,_ = nil,nil,nil,nil,nil,nil
local symbol = ""



local function pararecieve()
    _,_,_,reply,signal,_ = os.pullEvent("modem_message")
    return 1
end

local function paraShutdown()
    _,_,_,reply,signal,_ = os.pullEvent("modem_message")
    if signal == 100 then
        redstone.setOutput("front",false)
        gate.disconnectStargate()
    end
end

local function DisconnectCheck() -- does exactly what you think it does (if an unexpected error is thrown this siezes the program too)
    
    local disCode = os.pullEvent("stargate_disconnected")
    if (disCode ~= 7 or 8 or 9 or 10 or -1 or -15 or -16 or -19 or "stargate_disconnected") then
            redstone.setOutput("front",false)
            print(disCode)
            modem.transmit(8750,1327,1000)
        
    end
    return 2
end

local function recieveDial() --computer end: recieves address request and dials gate this also waits for disconnect command
    print("opening channel")
    

    local address = signal
    for i = 1, #address do
        term.write(address[i])
        term.write(" ")
    end

    Dial(address)

    modem.open(1327)
    modem.transmit(8750,1327,"dialing complete")
    local Rcheck = parallel.waitForAny(paraShutdown, DisconnectCheck)

    if Rcheck == 2 then
        modem.transmit(8750,1327,1000)
    end

end

local function GetClick() -- gets click information
    
    local event, _, xPos, yPos = os.pullEvent("mouse_click")
    return xPos, yPos
end

local function TermDraw(list) --tables side: draws selection options on the terminal
    local x = 0
    local y = -1
    local x1 = 0
    local x2 = 0
    local internaladdress = {}

    for i = 1,#list do
        if i % 2 == 0 then
            x = 15
        else
            x = 2
            y = y + 2
        end
        term.setCursorPos(x,y)



        term.write(list[i][1])

        x1 = x
        x2 = x + 9

        table.insert(buttonXY, {x1,x2,y})

        table.insert(computerNames, list[i][1])

        local addresstranslate = list[i]
        for i = 2, #addresstranslate do 
            table.insert(internaladdress, addresstranslate[i])
        end
        table.insert(computerAddresses, internaladdress)
        internaladdress = {}
    end

    paintutils.drawFilledBox(20,17,26,19,colors.red)
    term.setCursorPos(21,18)
    term.write("Back")

end

local function selectionTabs()
    term.setBackgroundColor(colors.black)
    term.clear()
    

    if #MainGates ~= 0 then
        paintutils.drawFilledBox(2,3,14,7,colors.purple)
        term.setCursorPos(3,5)
        term.setBackgroundColor(colors.purple)
        term.write("Main Gates")
    end

    if #playerGates ~= 0 then
        paintutils.drawFilledBox(16,3,28,7,colors.green)
        term.setCursorPos(19,4)
        term.setBackgroundColor(colors.green)
        term.write("Player")
        term.setCursorPos(18,6)
        term.write("Base gates")
    end

    if (#hazardGates ~= 0) and (canAccessHazardGates == true) then
        paintutils.drawFilledBox(2,9,14,13,colors.red)
        term.setCursorPos(4,10)
        term.setBackgroundColor(colors.red)
        term.write("Hazard")
        term.setCursorPos(4,12)
        term.write("Gates")
    end

    if (#privateGates ~= 0) and (canAccessPrivateGates == true) then
        paintutils.drawFilledBox(16,9,28,13,colors.blue)
        term.setCursorPos(18,10)
        term.setBackgroundColor(colors.blue)
        term.write("Private")
        term.setCursorPos(18,12)
        term.write("gates")
    end

    
end

local function SelectSend() --tablest side: gets input and trnasmits selected gate request to computer
    local dialing = false
    local selecting = true


    while dialing == false and selecting == true do
    
            local cursX, cursY = GetClick()
            
        for i = 1, #buttonXY do

            

            if (cursY == buttonXY[i][3]) and ((cursX >= buttonXY[i][1]) and (cursX <= buttonXY[i][2])) then
                dialing = true
                modem.open(8750)
                modem.transmit(1327, 8750, computerAddresses[i])
                term.setCursorPos(10,10)
                term.clear()
                term.write("dialing gate")
                local _,_,_,_,dialreply,_ = os.pullEvent("modem_message")
                term.clear()
                term.setCursorPos(10,10)
                term.write(dialreply)
                selAdress = computerNames[i]
                sleep(5)
                cursX = 0
                cursY= 0
            elseif cursY >= 17 and cursX >= 20 then
                selecting = false
            end
        end
    end
    print("test")
    return dialing
end

function Dial(address) --computer side:borrowed code to dial the gate. credit: Povstalec
    --Milky Way Stargate is a special case when it comes
    --to dialing

    

    local gateType = gate.getStargateType()
    print(gateType)

    if gateType == false then

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
            
             symbol = address[chevron]
            
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
            
    else
        
        local addressLength = #address
        
        local start = gate.getChevronsEngaged() + 1

        if gateType == "wigglywiglgly" then
            if addressLength == 8 then
                gate.setChevronConfiguration({1, 2, 3, 4, 6, 7, 8, 5})
            elseif addressLength == 9 then
                gate.setChevronConfiguration({1, 2, 3, 4, 5, 6, 7, 8})
            end
        end
        
        
        for chevron = start,addressLength,1
        do


            
            
            local symbol = address[chevron]
            
            gate.engageSymbol(symbol)

            
                sleep(gatespeed)    
                      
                
            
            if gateType == "sgjourney:universe_stargate" then
                os.pullEvent(gate.stargate_chevron_engaged)
                if symbol == 0 then
                    redstone.setOutput("front",true)
                end
            
            end
            
        end
        
        local engagedChevrons = gate.getChevronsEngaged()

        if symbol ~= 0 and engagedChevrons == (#address - 1 ) then 
            gate.engageSymbol(0)
            os.pullEvent(gate.stargate_chevron_engaged)
            redstone.setOutput("front",true)
        end

    end
end

local function termDisconnect() --tablet side: sends dissconect code to computer
    local intcheck = true


    term.setBackgroundColor(colors.green)
    term.clear()
    term.setCursorPos(8,8)
    term.write(selAdress)
    while intcheck == true do
        local Rcheck = parallel.waitForAny(GetClick, pararecieve)

        if Rcheck == 1 then
            modem.transmit(1327, 8750, (100))
            intcheck = false
            term.setBackgroundColor(colors.black)
            term.clear()
            term.setCursorPos(4,8)
            term.write("disconnected")
            sleep(1.5)
        elseif (Rcheck == 2) and (signal == 1000) then
            intcheck = false
            term.setBackgroundColor(colors.black)
            term.clear()
            term.setCursorPos(4,8)
            term.write("disconnected")
            sleep(1.5)
        end
    end
end

local function DisconnectCheck() -- does exactly what you think it does (if an unexpected error is thrown this siezes the program too)
    
    local disCode = os.pullEvent("stargate_disconnected")
    if (disCode ~= 7 or 8 or 9 or 10 or -1 or -15 or -16 or -19 or "stargate_disconnected") then
            redstone.setOutput("front",false)
            print(disCode)
            modem.transmit(8750,1327,1000)
        
    end
    return 2
end

local function timeout() 
    sleep(300)
    return 1
    
end

local function PassthroughDisconnect()
    os.pullEvent("stargate_reconstructing_entity")
    sleep(20)
    local gatecheck2 = gate.isStargateConnected()
    if gatecheck2 == true then

        gate.disconnectStargate()
        modem.transmit(8750,1327,1000)
    end
    return 1
end

local function tabSelector()
    

    local state = true
    
    
    while state == true do
        term.setBackgroundColor(colors.black)
        term.clear()
        
        selectionTabs()

        local tabx, taby = GetClick()

        local count = 0

        if (taby >= 2) and (taby <= 7) and ((tabx >= 2) and (tabx <= 14)) then

            if #MainGates ~= 0 then
                term.setBackgroundColor(colors.black)
                term.clear()
                term.setBackgroundColor(colors.purple)

                TermDraw(MainGates)

                local returnstate = SelectSend()

                if returnstate == true then
                    state = false
                end

                computerAddresses = {}
                computerNames = {}
            else
                term.setCursorPos(9,7)
                term.clear()
                term.write("no gates available")
                sleep(5)
            end

        elseif (taby >= 3) and (taby <= 7) and ((tabx >= 16) and (tabx <= 28)) then

            if #playerGates ~= 0 then
                term.setBackgroundColor(colors.black)
                term.clear()
                term.setBackgroundColor(colors.green)

                TermDraw(playerGates, colours.green)

                local returnstate = SelectSend()

                if returnstate == true then
                    state = false
                end

                computerAddresses = {}
                computerNames = {}
            else
                term.setCursorPos(9,7)
                term.clear()
                term.write("no gates available")
                sleep(5)
            end

        elseif (((taby >= 9) and (taby <= 13)) and ((tabx >= 2) and (tabx <= 14))) and (canAccessHazardGates == true) then
            if (#hazardGates ~= 0) and (canAccessHazardGates == true) then
                term.setBackgroundColor(colors.black)
                term.clear()
                term.setBackgroundColor(colors.red)

                TermDraw(hazardGates)

                local returnstate = SelectSend()

                if returnstate == true then
                    state = false
                end

                computerAddresses = {}
                computerNames = {}
            else
                term.setCursorPos(9,7)
                term.clear()
                term.write("no gates available")
                sleep(5)
            end

        elseif (((taby >= 9) and (taby <= 13)) and ((tabx >= 16) and (tabx <= 28))) and (canAccessPrivateGates == true) then
            if (#privateGates ~= 0) and (canAccessPrivateGates == true) then
                term.setBackgroundColor(colors.black)
                term.clear()
                term.setBackgroundColor(colors.blue)

                TermDraw(privateGates)

                local returnstate = SelectSend()

                if returnstate == true then
                    state = false
                end

                computerAddresses = {}
                computerNames = {}
            else
                term.setCursorPos(9,7)
                term.clear()
                term.write("no gates available")
                sleep(5)
            end
        end
    end
    return 1
end

function terminalMain()--main function


    if pocket then
        pComp = true
        print("i am a tablet")
        --sleep(5)
    else
        pComp = false
        
        modem.open(1327)
        print("i am a computer")


        gate = peripheral.find("advanced_crystal_interface")

        local gateCheck = gate.isStargateConnected()
        if gateCheck == true then
            sleep(20)
            redstone.setOutput("front",false)
            gate.disconnectStargate()
        end

        --sleep(5)
    end

    while true do

        if pComp == false then

            local choice = parallel.waitForAny(pararecieve,PassthroughDisconnect)
            if signal == 100 then
                gate.disconnectStargate()
                choice = 0
            else
                if choice == 1 then
                    local waht = parallel.waitForAny(recieveDial, DisconnectCheck)
                end
            end
            
        else
                modem.open(8750)
            
                tabSelector()
                
                parallel.waitForAny(timeout, termDisconnect)
            
        end 
    end
end

terminalMain()