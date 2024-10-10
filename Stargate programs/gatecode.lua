


local function Dial(address, dialtype) --borrowed code to dial the gate. credit: Povstalec
    --Milky Way Stargate is a special case when it comes
    --to dialing

    print(gate.addressToString(address))

    local gateType = gate.getStargateType()

    if gateType == "sgjourney:milky_way_stargate" and manualDial == true then
        
        local addressLength = #address
        --You don't really need to have this variable,
        --I just like to use lots of variables with
        --names to make everything immediately clear

        if addressLength == 8 then
            print(gate.setChevronConfiguration({1, 2, 3, 4, 6, 7, 8, 5}))
        elseif addressLength == 9 then
            print(gate.setChevronConfiguration({1, 2, 3, 4, 5, 6, 7, 8}))
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


    function NewDial()
        local gateType = gate.getStargateType()
        local gatevarient = gate.getStargateVariant()
        local address = destAddress
        local chevnum = 0 --transmit code for monitors
        print(gate.addressToString(address))

        redstone.setOutput("back",true)

        if gateType ~= "sgjourney:universe_stargate" then
            if addressLength == 8 then 
                print(gate.setChevronConfiguration({1, 2, 3, 4, 6, 7, 8, 5}))
            elseif addressLength == 9 then
                print(gate.setChevronConfiguration({1, 2, 3, 4, 5, 6, 7, 8}))
            end
        end

        if gateType == "sgjourney:milky_way_stargate" and manualDial == true then --- rotational gate dialling for the milky way gates
            
            for _, chevron in pairs(address) do 

                if chevron % 2 == 0 then -- checking if the chevron number is even or odd to tell the gate which way to rotate
                    gate.rotateClockwise(chevron)
                else
                    gate.rotateAntiClockwise(chevron)
                end

                while (not gate.isCurrentSymbol(chevron)) do
                    sleep(0)
                end

                sleep(1)

                gate.openChevron()
                sleep(.5)
                gate.closeChevron()
                sleep(.5)


                chevnum = chevnum + 1
                modem.transmit(1237,5572,chevnum)

            end
            address = {_, _, _, _, _, _, _, _, _}
        elseif gateType == "sgjourney:tollen_stargate" then

            for _, chevron in pairs(address) do
                gate.engageSymbol(chevron)
                sleep(gatespeed)

                chevnum = chevnum + 1
                modem.transmit(1237,5572,chevnum)

            end
            address = {_, _, _, _, _, _, _, _, _}
        else
            for _, chevron in pairs(address) do
                gate.engageSymbol(chevron)
                sleep(1)

                chevnum = chevnum + 1
                modem.transmit(1237,5572,chevnum)

                if (chevron) ~= 0 then
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
            address = {_, _, _, _, _, _, _, _, _}
        end
    end
end