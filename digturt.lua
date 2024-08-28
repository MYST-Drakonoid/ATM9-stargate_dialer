local block = peripheral.find("blockReader")

while true do
    sleep(5)
    local veiwBlock = block.getBlockName()
    if veiwBlock == "sgjourney:classic_stargate" then
        turtle.dig()
    end



end