









local destAddress = {}

local gate = peripheral.find("advanced_crystal_interface")
local modem = peripheral.find("modem")

local manualDial = true
local speed = 1

function NewDial() -- dialling code for the gates
    local gateType = gate.getStargateType()
    local gatevarient = gate.getStargateVariant()
    local address = destAddress
    local chevnum = 0 --transmit code for monitors
    -- print(gate.addressToString(address))

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
            sleep(speed)

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


local function MAIN()
    while true do
        NewDial()
    end
end

MAIN()