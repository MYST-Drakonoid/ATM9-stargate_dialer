







local privategate = false
local password = nil

local destAddress = {}

local gate = peripheral.find("advanced_crystal_interface")
local modem = peripheral.find("modem")

local manualDial = nil
local speed = nil
local GDO = nil

local function DisconnectCheck() -- does exactly what you think it does (if an unexpected error is thrown this siezes the program too)
    
    local _,_,disCode = os.pullEvent("stargate_disconnected")
    if (disCode ~= 7 or 8 or 9 or 10 or -1 or -15 or -16 or -19 or "stargate_disconnected") then
            redstone.setOutput("front",false)
            print(disCode)
            modem.transmit(8750,1237,345001)
        
    end
    return 2
end

local function paraShutdown()
    _,_,_,reply,signal,distance = os.pullEvent("modem_message")
    if signal == 100 and ((distance <= 64)and (distance ~= nil)) then
        redstone.setOutput("front",false)
        gate.disconnectStargate()
    end
end

local function incomingWormhole() -- incoming wormhole detection

    local _,_,_,_,incomingBool = os.pullEvent("stargate_chevron_engaged")
    if privategate == true then
        modem.transmitmodem.transmit(1237,5572,421732) -- transmit code for incoming wormholes
        gate.closeIris()
        os.pullEvent("stargate_incoming_wormhole")
        local _,_,GDO = os.pullEvent("stargate_message_received")
        if GDO == password then
            gate.openIris()
        end
    else
        modem.transmitmodem.transmit(1237,5572,421732) -- transmit code for incoming wormholes
    end

end



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

        local _, _, internalAddress = os.pullEvent("stargate_outgoing_wormhole")

        sleep(2.5)

        modem.transmit(1237,5572,internalAddress)
        
        gate.sendStargateMessage(GDO)

        address = {_, _, _, _, _, _, _, _, _}

    elseif gateType == "sgjourney:tollen_stargate" then

        for _, chevron in pairs(address) do
            gate.engageSymbol(chevron)
            sleep(gatespeed)

            chevnum = chevnum + 1
            modem.transmit(1237,5572,chevnum)

        end

        local _, _, internalAddress = os.pullEvent("stargate_outgoing_wormhole")

        sleep(2.5)

        modem.transmit(1237,5572,internalAddress)
        
        gate.sendStargateMessage(GDO)

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
        local _, _, internalAddress = os.pullEvent("stargate_outgoing_wormhole")

        sleep(2.5)

        modem.transmit(1237,5572,internalAddress)
        
        gate.sendStargateMessage(GDO)

        address = {_, _, _, _, _, _, _, _, _}
    end
end


local function MAIN()
    while true do
        
    end
end

MAIN()