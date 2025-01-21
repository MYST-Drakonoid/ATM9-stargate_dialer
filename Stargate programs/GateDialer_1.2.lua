
local computerID = 10 --identifies the user for the server
local GDO = 01100011011100100110100101101101011100110110111101101110001100010011000101100100011001010110110001101001011001110110100001110100011100000110010101110100011100100110100101100011011010000110111101110010

-- update these settings to change which types of gates this SG/TERMINAL can access (0 = false/1 = true)
local canAccessPrivateGates = 1
local canAccessHazardGates = 1

-------------------------------------------------------------------------------------------------------------
-----------DONT FIDDLE WITH ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING----------------------
-------------------------------------------------------------------------------------------------------------

---checking/building neccesary settings for the code --------------------------------------------------------

print("CONFIGURING SETTINGS")

settings.load()

local internalComputerID = settings.get("CID.settings") -- gett

if not internalComputerID then -- setting up somputer ID setting
    settings.define("CID.settings",{
        description = "computer ID",
        type = "number"
        })
    settings.set("CID.settings", computerID)
    settings.save()
    print("Computer ID configured")
    internalComputerID = settings.get("CID.settings")
else -- computer ID is already set up
    print("computer"..computerID.. "already configured")
end

local internalDialType = settings.get("dial.settings")

if not internalDialType then -- setting up the DIaltype setting
    settings.define("DT.settings",{
        description = "Dialtype",
        default = 2,
        type = "number"
        })
    settings.set("DT.settings", computerID)
    settings.save()
    print("Dial setting configured")
    internalDialType = settings.get("dial.settings")

else -- dial type alreay set up
    print("dial type already configured")
end

print("END OF SETTING CONFIGURATION")


---END OF SETTING CONFIGURATION ------SETTING UP PERIPHERALS------------------------------------------------

local modem = peripheral.find("modem")

local mon = peripheral.find("monitor")
local detector = peripheral.wrap("right")

---gatenumber requester

--variables

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
local addressbook = {}
local incomingSignal = nil

--internal gate variables
local MainGates = {}
local hazardGates = {}
local playerGates = {}
local privateGates = {}

local _,_,_,reply,signal,distance = nil,nil,nil,nil,nil,nil

local function pararecieve() -- function to make modem message events simpler
    modem.open(1237)
    _,_,_,_,signal,distance = os.pullEvent("modem_message")
    if ((distance <= 64)and (distance ~= nil)) then
        incomingSignal = signal
        modem.close(1237)
        return 1
    end
end

local function AddressBookProcessing(rawAddresses)

    MainGates = rawAddresses["MG"]
    playerGates = rawAddresses["PG"]
    hazardGates = rawAddresses["HG"]
    privateGates = rawAddresses["PRG"]

end

local function simplerecieve() -- function to make modem message events simpler
    _,_,_,_,signal,distance = os.pullEvent("modem_message")
    return signal, distance
end

local function disconcode()
    modem.transmit(5572, 1237, 345000)
end

local function Netdisconnect()
    local disconnect = false

    while disconnect == false do
        modem.open()
        _,_,_,_,signal,distance = os.pullEvent("modem_message")
        if signal == 345001 then
            disconnect = true
        end
    end
    
    return 1
end

local function AddressBookRetrieval(compID, hazPerm, privPerm)
    local recieved = false
    local infosignal = {}
    while recieved == false do -- loop for checking if recieved addressbook is correct addressbook
        local dimension = detector.getDimension()
        local addressRequest = {}

        addressRequest["hp"] = hazPerm
        addressRequest["pp"] = privPerm
        addressRequest["dim"] = dimension
        addressRequest["id"] = compID

        modem.open(4256) --opening modem to info recieve frequency

        modem.transmit(1329, 4256, addressRequest)

        infosignal, _ = simplerecieve()

        if infosignal["ID"] == compID then
            recieved = true

            modem.close(4256) --closing modem to info recieve frequency

            table.remove(infosignal[1]) -- removing computerID from signal for ease of use

            AddressBookProcessing(infosignal)
        end
    end

    return infosignal
end
    

local function GetClick() -- gets click information
    mon.setTextScale(1)
    local _, _, xPos, yPos = os.pullEvent("monitor_touch")
    return xPos, yPos
end

local function incomingCode()

    mon.setBackgroundColor(colors.green)
    mon.clear()
    mon.setCursorPos(9,9)
    mon.write("incoming Wormhole")
    redstone.setOutput("bottom", true)

    local insig, indis = simplerecieve()

    if indis < 64 and insig == 421732 then
        mon.setBackgroundColor(colors.blue)
        mon.clear()
        mon.setCursorPos(9,9) 
        mon.write("Incoming Wormhole Esatablished")
        redstone.setOutput("bottom", false)
    end

    local dissig, disdis = simplerecieve()

    if dissig == 345001 and disdis < 64 then
        mon.setBackgroundColor(colors.black)
        mon.clear()
        mon.setCursorPos(9,9) 
        mon.write("Wormhole Disconnected")
    end

    

end



local function screenWrite(list,fcount, fy) -- iterates through lists and dispalys them neatly on screens
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

local function selectionTabs() --draws the initial selection menu for both tablet and monitor
    
    if pocket == false then -- if the computer is a fixed monitor draw the buttons this way
        mon.setBackgroundColor(colors.black)
        mon.clear()
        local oldterm = term.redirect(mon)


        if MGnum ~= 0 then                                        --MAINGATES BUTTON
            paintutils.drawFilledBox(2,2,13,6,colors.purple)
            mon.setCursorPos(4,4)
            mon.setBackgroundColor(colors.purple)
            mon.write("Main Gates")
        end

        if #playerGates ~= 0 then                                      --PLAYERGATES BUTTON
            paintutils.drawFilledBox(16,2,27,6,colors.green)
            mon.setCursorPos(18,4)
            mon.setBackgroundColor(colors.green)
            mon.write("Player")
            mon.setCursorPos(18,5)
            mon.write("Base gates")
        end

        if (#hazardGates ~= 0) and (canAccessHazardGates == true) then --HAZARDGATES BUTTON
            paintutils.drawFilledBox(2,8,13,12,colors.red)
            mon.setCursorPos(4,9)
            mon.setBackgroundColor(colors.red)
            mon.write("Hazard")
            mon.setCursorPos(4,11)
            mon.write("gates")
        end

        if (#privateGates ~= 0) and (canAccessPrivateGates == true) then --privateGates BUTTON
            paintutils.drawFilledBox(16,8,27,12,colors.blue)
            mon.setCursorPos(18,9)
            mon.setBackgroundColor(colors.blue)
            mon.write("Private")
            mon.setCursorPos(18,11)
            mon.write("gates")
        end
        
        --EXIT BUTTON--
        paintutils.drawFilledBox(23,17,28,19,colors.red)
        mon.setCursorPos(24,18)
        mon.write("Back")

            --SLOW BUTTON--
            paintutils.drawFilledBox(23,17,28,19,colors.red)
            mon.setCursorPos(24,18)
            mon.write("Back")

            --MID BUTTON
            paintutils.drawFilledBox(23,17,28,19,colors.red)
            mon.setCursorPos(24,18)
            mon.write("Back")

            --FAST BUTTON
            paintutils.drawFilledBox(23,17,28,19,colors.red)
            mon.setCursorPos(24,18)
            mon.write("Back")

        term.redirect(oldterm)

    elseif pocket == true then

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
    
        if (#hazardGates ~= 0) then
            paintutils.drawFilledBox(2,9,14,13,colors.red)
            term.setCursorPos(4,10)
            term.setBackgroundColor(colors.red)
            term.write("Hazard")
            term.setCursorPos(4,12)
            term.write("Gates")
        end
    
        if (#privateGates ~= 0) then
            paintutils.drawFilledBox(16,9,28,13,colors.blue)
            term.setCursorPos(18,10)
            term.setBackgroundColor(colors.blue)
            term.write("Private")
            term.setCursorPos(18,12)
            term.write("gates")
        end

        --SLOW BUTTON--
        paintutils.drawFilledBox(23,17,28,19,colors.red)
        term.setCursorPos(24,18)
        term.write("Back")

        --MID BUTTON
        paintutils.drawFilledBox(23,17,28,19,colors.red)
        term.setCursorPos(24,18)
        term.write("Back")

        --FAST BUTTON
        paintutils.drawFilledBox(23,17,28,19,colors.red)
        term.setCursorPos(24,18)
        term.write("Back")
    end
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

local function ParaDial() -- seperating touch dialing so timeout function can work

    local selecting = true
    while dialing == false and selecting == true do

        selx, sely = GetClick()
        if pocket == true then
            for i = 1, #buttonXY do

                if (sely == buttonXY[i][3]) and ((selx >= buttonXY[i][1]) and (selx <= buttonXY[i][2])) then

                    local transmitList = {{computerAddresses[i]}, GDO}


                    modem.transmit(5572, 1237, transmitList) -- transmitting address to gate fro dialling
                    destAddressname = computerNames[i]
                    destAddress = computerAddresses[i]
                    dialing = true
                    sely = (0)
                    selx = (0)
                    local endcode = parallel.waitForAny(GetClick, Netdisconnect)
                    if endcode == 1 then
                        disconcode()
                    end


                elseif sely >= 17 and selx >= 23 then

                    selecting = false
                    sely = (0)
                    selx = (0)

                end
            end
        else 
            for i = 1, #buttonXY do
                if (cursY == buttonXY[i][3]) and ((cursX >= buttonXY[i][1]) and (cursX <= buttonXY[i][2])) then

                    local transmitList = {{computerAddresses[i]}, GDO}

                    dialing = true
                    modem.open(8750)
                    modem.transmit(5572, 1237, transmitList)
                    mon.setCursorPos(10,10)
                    mon.clear()
                    mon.write("dialing gate")
                    while dialing == true do
                        modem.open(1237)
                        local number, gatedistance = simplerecieve()
                        if number == 0 and ((distance <= 64)and (distance ~= nil)) then
                            modem.close(1237)
                            dialing = false
                            mon.setCursorPos(10,10)
                            mon.clear()
                            mon.write("dialing gate")
                            mon.setCursorPos(10,11)
                            mon.write("cheveron")
                            mon.setCursorPos(10,12)
                            mon.write(number)
                            mon.setCursorPos(10,13)
                            mon.write("locked")
                        elseif number ~= 0 and ((distance <= 64)and (distance ~= nil)) then
                            mon.setCursorPos(10,10)
                            mon.clear()
                            mon.write("dialing gate")
                            mon.setCursorPos(10,11)
                            mon.write("cheveron")
                            mon.setCursorPos(10,12)
                            mon.write(number)
                            mon.setCursorPos(10,13)
                            mon.write("engaged")
                        end

                        DialText()

                        local endcode = parallel.waitForAny(GetClick, Netdisconnect)
                        if endcode == 1 then
                            disconcode()
                        end
                    end
                    term.clear()
                    term.setCursorPos(10,10)
                    term.write()
                    selAdress = computerNames[i]
                    sleep(5)
                    cursX = 0
                    cursY= 0
                elseif cursY >= 17 and cursX >= 20 then
                    selecting = false
                end
            end
        end

        buttonXY = nil
        computerAddresses = nil
        computerNames = nil
        
    end
    return dialing
end

local function TermDraw(list) --tablets side: draws selection options on the terminal
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

local function tabSelector() --using tabselector , termdraw and screenwrite manages the menues for both monitor and tablet
                             --this also initialises the paradial sequence to send informatiuon to the gate
    

    local state = true
    
    if pocket == true then -- code fot the tablets
        while state == true do

            selectionTabs()

            if (taby >= 2) and (taby <= 7) and ((tabx >= 2) and (tabx <= 14)) then

                if #MainGates ~= 0 then
                    term.setBackgroundColor(colors.black)
                    term.clear()
                    term.setBackgroundColor(colors.purple)

                    TermDraw(MainGates)

                    local returnstate = ParaDial()

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

                    local returnstate = ParaDial()

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

                    local returnstate = ParaDial()

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

                    local returnstate = ParaDial()

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
    else -- code for the monitors
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
    end
    return 1
end

local function infoRequester(HP, PP, gateName, dialRequest, info)

end

local function PRIMARYDialingOut()

    tabSelector()

end

local function Main() -- main program operating the application

    if  mon ~= nil then
        while true do
            mon.setTextScale(1)
            mon.setBackgroundColor(colors.black)
            mon.clear()
            mon.setCursorPos(9,1)
            mon.setBackgroundColor(colors.red)
            mon.write("press to start")
    
            local answer = parallel.waitForAny(GetClick, pararecieve)
    
            if (answer == 1) then
                AddressBookRetrieval()

    
                PRIMARYDialingOut()
            else
                if incomingSignal == 421732 then
                    

                    incomingCode()
                    
                end
            end
        end
    elseif pocket == true then

        while true do
            term.setTextScale(1)
            term.setBackgroundColor(colors.black)
            term.clear()
            term.setCursorPos(10,1)
            term.setBackgroundColor(colors.red)
            term.write("press to start")
        
            GetClick()

            AddressBookRetrieval()

            PRIMARYDialingOut()
        end

    end

end

Main()


