
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

local internalComputerID = settings.get("CID.settings")

if not internalComputerID then 
    settings.define("CID.settings",{
        description = "computer ID",
        type = "number"
        })
    settings.set("CID.settings", computerID)
    settings.save()
    print("Computer ID configured")
else
    print("computer"..computerID.. "already configured")
end

local internalDialType = settings.get("dial.settings")

if not internalDialType then 
    settings.define("CID.settings",{
        description = "computer ID",
        default = 2,
        type = "number"
        })
    settings.set("CID.settings", computerID)
    settings.save()
    print("Dial setting configured")
else
    print("dial type already configured")
end

print("END OF SETTING CONFIGURATION")
---END OF SETTING CONFIGURATION

---ganenumber requester

--variables
local MGnum = 


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



            -- if #MainGates ~= 0 then
            --     mon.setBackgroundColor(colors.black)
            --     mon.clear()

            --     mon.setBackgroundColor(colors.purple)
            --     count, y = screenWrite(MainGates,count,y)

            --     local returnstate = ParaDial()

            --     if returnstate == true then
            --         state = false
            --     end

            --     computerAddresses = {}
            --     computerNames = {}
            -- else
            --     mon.setCursorPos(9,7)
            --     mon.write("no gates available")
            --     sleep(5)
            -- end

        elseif (taby >= 2) and (taby <= 6) and ((tabx >= 16) and (tabx <= 27)) then
            -- if #playerGates ~= 0 then
            --     mon.setBackgroundColor(colors.black)
            --     mon.clear()

            --     mon.setBackgroundColor(colors.green)
            --     count, y = screenWrite(playerGates,count,y)

            --     local returnstate = ParaDial()

            --     if returnstate == true then
            --         state = false
            --     end

            --     computerAddresses = {}
            --     computerNames = {}
            -- else
            --     mon.setCursorPos(9,7)
            --     mon.write("no gates available")
            --     sleep(5)
            -- end

        elseif (((taby >= 8) and (taby <= 12)) and ((tabx >= 2) and (tabx <= 13))) and (canAccessHazardGates == true) then
            -- if (#hazardGates ~= 0) and (canAccessHazardGates == true) then
            --     mon.setBackgroundColor(colors.black)
            --     mon.clear()

            --     mon.setBackgroundColor(colors.red)
            --     count, y = screenWrite(hazardGates,count,y)

            --     local returnstate = ParaDial()

            --     if returnstate == true then
            --         state = false
            --     end

            --     computerAddresses = {}
            --     computerNames = {}
            -- else
            --     mon.setCursorPos(9,7)
            --     mon.write("no gates available")
            --     sleep(5)
            -- end

        elseif (((taby >= 8) and (taby <= 12)) and ((tabx >= 16) and (tabx <= 27))) and (canAccessPrivateGates == true) then
            -- if (#privateGates ~= 0) and (canAccessPrivateGates == true) then
            --     mon.setBackgroundColor(colors.black)
            --     mon.clear()

            --     mon.setBackgroundColor(colors.blue)
            --     count, y = screenWrite(privateGates,count,y)

            --     local returnstate = ParaDial()

            --     if returnstate == true then
            --         state = false
            --     end

            --     computerAddresses = {}
            --     computerNames = {}
            -- else
            --     mon.setCursorPos(9,7)
            --     mon.write("no gates available")
            --     sleep(5)
            -- end

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

local function infoRequester(HP, PP, gateName, dialRequest, info)


end
