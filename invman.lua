local crystalizer = peripheral.wrap("front")
local Chest = peripheral.wrap("top")



print("chest storage")
for slot, item in pairs(Chest.list()) do
  print(("%d x %s in slot %d"):format(item.count, item.name, slot))
end

local storageChest = peripheral.getName(Chest)

local slot2Count = 0
local slot3Count = 0

print("crystalizer storage")

for slot, item in pairs(crystalizer.list()) do
    if slot == 2 then
        slot2Count = item.count   
        print(("%d x %s in slot %d"):format(item.count, item.name, slot))
    elseif slot == 3 then
        slot3Count = item.count   
        print(("%d x %s in slot %d"):format(item.count, item.name, slot))      
    end
  end

  if (slot2Count == 64) and (slot3Count == 64) then
    print("crystalizer ready")
  end





local function Slot2Refill()

    while (slot2Count < 64) do
    
        if slot2Count ~= 64 then
            crystalizer.pullItems(storageChest, 1, 1, 2)
        else 
            sleep(0)
        end
        sleep(.01)

        for slot, item in pairs(crystalizer.list()) do
            if slot == 2 then
                slot2Count = item.count  
                print(("%d x %s in slot %d"):format(item.count, item.name, slot))
            end
        end
    end

end

local function Slot3Refill()

    while (slot3Count < 64) do

        if slot3Count ~= 64 then
            crystalizer.pullItems(storageChest, 2, 1, 3)
        else
            sleep(0)
        end
        sleep(.01)
        
        for slot, item in pairs(crystalizer.list()) do
            if slot == 3 then
                slot3Count = item.count  
                print(("%d x %s in slot %d"):format(item.count, item.name, slot))
            end
        end
    end
end

    

local function readyCheck()
    local readyReport = false

    while true do
        
    if readyReport == true then
        print("crystalizer ready")
        sleep(1)
        readyReport = false
        for slot, item in pairs(crystalizer.list()) do
            if slot == 2 then
                slot2Count = item.count   
                print(("%d x %s in slot %d"):format(item.count, item.name, slot))
            elseif slot == 3 then
                slot3Count = item.count   
                print(("%d x %s in slot %d"):format(item.count, item.name, slot))      
            end
        end
    end


        for slot, item in pairs(crystalizer.list()) do
            if slot == 2 then
                slot2Count = item.count   
                
            elseif slot == 3 then
                slot3Count = item.count   
                    
            end
          end

          if (slot3Count < 64) or (slot3Count == nil)then
            
            print("refilling")

            Slot3Refill()

            print("slot 3 ready")

            if (slot2Count == 64) and (slot3Count == 64) then
                readyReport = true
            end

          elseif (slot2Count < 64) or (slot2Count == nil) then
            
            print("refilling")

            Slot2Refill()

            print("slot 2 ready")
            
            
            if (slot2Count == 64) and (slot3Count == 64) then
                readyReport = true
            end

          end

        
    end
end
readyCheck()


