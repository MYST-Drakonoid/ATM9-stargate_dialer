
local computerID = nil --identifies the user for the server

-- update these settings to change which types of gates this SG/TERMINAL can access
local canAccessPrivateGates = true
local canAccessHazardGates = true

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
local gate = peripheral.find("advanced_crystal_interface")
local mon = peripheral.find("monitor")

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

local _,_,_,reply,signal,distance = nil,nil,nil,nil,nil,nil


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

local function selectionTabs() --draws the initial selection menu
    
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

local function ParaDial() -- seperating touch dialing so timeout function can work

    local selecting = true
    while dialing == false and selecting == true do

        selx, sely = GetClick()
        for i = 1, #buttonXY do

            if (sely == buttonXY[i][3]) and ((selx >= buttonXY[i][1]) and (selx <= buttonXY[i][2])) then

                modem.transmit(5572, 1237, computerAddresses[i]) -- transmitting address to gate fro dialling
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


local function Dial() --borrowed code to dial the gate. credit: Povstalec
    --Milky Way Stargate is a special case when it comes
    --to dialing

    local address = destAddress
    print(gate.addressToString(address))

    local gateType = gate.getStargateType()

    if gateType == "sgjourney:milky_way_stargate" and manualDial == true then -- code for manually dialling a milky way SG

        local addressLength = #address

        --CONVERTING THE ORDER IN WHICH THE GATE ENGAGES THE CHEVERONS
        if addressLength == 8 then 
            print(gate.setChevronConfiguration({1, 2, 3, 4, 6, 7, 8, 5}))
        elseif addressLength == 9 then
            print(gate.setChevronConfiguration({1, 2, 3, 4, 5, 6, 7, 8}))
        end

        local start = gate.getChevronsEngaged() + 1 --failsafe code to make sure the gate continues dialling where it is supposed to

        for chevron = start,addressLength,1 do -- beginning the iteration on the address to encode it to the gate

            local symbol = address[chevron]

            -- GATE ROTATION CODE --
            if chevron % 2 == 0 then
                gate.rotateClockwise(symbol)
            else
                gate.rotateAntiClockwise(symbol)
            end

            -- protective code keeps the program from doing anything until the rotation completes
            while(not gate.isCurrentSymbol(symbol))
            do
                sleep(0)
            end

            sleep(1)

            gate.openChevron() --This opens the chevron
            sleep(1)
            gate.closeChevron() -- and this closes it
            sleep(1)


            // input-- proper code here for wireless gate communication of dial sequence
        end 
    else

        if gateType ~= "sgjourney:universe_stargate" then

            if addressLength == 8 then
                gate.setChevronConfiguration({1, 2, 3, 4, 6, 7, 8, 5})
            elseif addressLength == 9 then
                gate.setChevronConfiguration({1, 2, 3, 4, 5, 6, 7, 8})
            end
        end

        local start = gate.getChevronsEngaged() + 1 --makes sure the gate starts where its supposed to



        for chevron = start,#address,1 --dialing loop for  all non rotating gates and auto MW gates
        do

            local symbol = address[chevron]

            gate.engageSymbol(symbol)
            sleep(gatespeed) -- detemining factor in how fast the gate dials

            // input --proper code here for wireless gate communication of dial sequence

            if (symbol) ~= 0 then

            -- THIS CODE CHECKS IF THE GATE IS A UNIVERSE GATE SO IT CAN LIGHT UP A CHEVEERON ON THE FLOOR--
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

            end

        end

        address = nil -- CLEARS THE VARIABLE FOR CODE RELIABILITY
    end

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

local function infoRequester(HP, PP, gateName, dialRequest, info)


end

local function Main() -- main program operating the application

    if gate ~= nil then
        while true do
            local tempcheck = nil

            _,_,_,reply,signal,distance = os.pullEvent("modem_message")

            if signal[3] ~= 0 then
                
            end

            tempcheck = parallel.waitForAny(Dial, paraShutdown)

            if tempcheck == 1 then
                parallel.waitForAny(paraShutdown, DisconnectCheck)
            end
        end
    elseif mon ~= nil then
        
    elseif pocket == true then

    end

end

Main()