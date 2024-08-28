local drive = peripheral.wrap("top")
local path = nil
local fileName = "wireless_dial.lua"

local function movingFile(filename, funpath, fundrive) --executes the moving of the file
    local check = fundrive.isDiskPresent()

    if check == true then
        fs.copy("./"..fileName, funpath)
        fs.delete(funpath.."/./startup.lua")
        fs.move(funpath.."/./"..fileName, funpath.."/./startup.lua")
    end

end

local function insertedDrive(fundrive) -- event detector and drive path reciever
    os.pullEvent("disk")
    local check = drive.isDiskPresent()
    local funpath = nil

    if check == true then
        funpath = drive.getMountPath()
        print(funpath)
    end

    return funpath
end

local function main()
    while true do
        path = insertedDrive(drive)
        movingFile(fileName, path, drive)
        drive.ejectDisk()
    end
end

main()