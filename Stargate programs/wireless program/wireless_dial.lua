local gatespeed = .5




--gate addresses
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
    {26,28,13,33,7,35,0},           --twiforest
    {16,7,9,29,5,1,0},              --miningdim
    {8,16,7,25,19,30,0},            --everbright
    {23,11,21,10,26,31,0},          --otherSide
    {25,34,29, 30,5,15,0},          --marble
    {25,5,32,35,23,2,0},            --lostCity
    {18,20,1,15,14,7,19,0},         --lanteaAddress
    {11,13,2,34,25,3,28,1,0},       --MYSTAJ
    {33,16,25,7,23,9,34,4,0},        --magicINC
    {32,27,30,26,3,12,33,2,0},      --Asteria
    {33,18,28,15,22,16,9,13,0},     --moon
    {6,8,25,28,33,12,30,35,0},      --mars
    {34,17,21,6,15,27,5,30,0},      --venus
    {23,4,18,5,31,1,2,22,0}}        --mercury     
--22
local buttonXY = {}

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
    "T forest",
    "Mining",
    "Everbri",
    "otherSide",
    "marble",
    "lostCity",
    "Atlantis",
    "MYST&AJ",
    "magicINC",
    "Asteria",
    "Moon",
    "mars",
    "Venus",
    "Mercury"
    }
--22

modem = peripheral.find("modem")
local gate = nil

local pComp = nil
local i = 1
local selAdress = nil

local _,_,_,reply,signal,_ = nil,nil,nil,nil,nil,nil
local symbol = ""

function pararecieve()
    _,_,_,reply,signal,_ = os.pullEvent("modem_message")
    return 1
end

function recieveDial() --computer end: recieves address request and dials gate this also waits for disconnect command
    print("opening channel")
    

    local address = signal
    for i = 1, #address do
        term.write(address[i])
        term.write(" ")
    end

    Dial(address)

    modem.open(1327)
    modem.transmit(8750,1327,"dialing complete")
    _,_,_,reply,signal,_ = os.pullEvent("modem_message")
    if signal == 100 then
        redstone.setOutput("front",false)
        gate.disconnectStargate()
    end
end

function TermDraw() --tables side: draws selection options on the terminal
    local x = 0
    local y = 0
    local x1 = 0
    local x2 = 0
    term.clear()
    term.setBackgroundColor(colors.green)
    for i = 1,#screenNames do
        if i % 2 == 0 then
            x = 15
        else
            x = 2
            y = y + 1
        end
        term.setCursorPos(x,y)

        if screenNames[i] == "Moon" then
            term.setBackgroundColor(colors.red)
        end
        term.write(screenNames[i])

        x1 = x
        x2 = x + 9

        table.insert(buttonXY, {x1,x2,y})
    end

end

function SelectSend() --tablest side: gets input and trnasmits selected gate request to computer
    local dialing = false
    local _, _, cursX, cursY = os.pullEvent("mouse_click")
    term.setBackgroundColor(colors.black)
    term.clear()

    
    while dialing == false do
        for i = 1, #buttonXY do
            if (cursY == buttonXY[i][3]) and ((cursX >= buttonXY[i][1]) and (cursX <= buttonXY[i][2])) then
                dialing = true
                modem.open(8750)
                modem.transmit(1327, 8750, gateTable[i])
                term.setCursorPos(10,10)
                term.write("dialing gate")
                local _,_,_,_,dialreply,_ = os.pullEvent("modem_message")
                term.clear()
                term.write(dialreply)
                selAdress = screenNames[i]
                sleep(5)
                cursX = 0
                cursY= 0

                
                
            end
        
        end
    end
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

        if addressLength == 8 then
            gate.setChevronConfiguration({1, 2, 3, 4, 6, 7, 8, 5})
        elseif addressLength == 9 then
            gate.setChevronConfiguration({1, 2, 3, 4, 5, 6, 7, 8})
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

function termDisconnect() --tablet side: sends dissconect code to computer
    term.setBackgroundColor(colors.green)
    term.clear()
    term.setCursorPos(8,8)
    term.write(selAdress)
    os.pullEvent("mouse_click")
    modem.transmit(1327, 8750, 100)
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(4,8)
    term.write("disconnected")
    sleep(4)
end

function DisconnectCheck() -- does exactly what you think it does (if an unexpected error is thrown this siezes the program too)
    
    local disCode = os.pullEvent("stargate_disconnected")
    if (disCode ~= 7 or 8 or 9 or 10 or -1 or -15 or -16 or -19 or "stargate_disconnected") then
            redstone.setOutput("front",false)
            print(disCode)
        
    end
    return 2
end

function timeout() 
    sleep(300)
    return 1
    
end

function PassthroughDisconnect()
    os.pullEvent("stargate_reconstructing_entity")
    sleep(20)
    local gatecheck2 = gate.isStargateConnected()
    if gatecheck2 == true then

        gate.disconnectStargate()
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
            
            
                TermDraw()
                SelectSend()
                parallel.waitForAny(timeout, termDisconnect)
            
        end 
    end
end

terminalMain()