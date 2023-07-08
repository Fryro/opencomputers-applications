local component = require("component")
local gpu = component.gpu
gpu.setResolution(160,50)
local event = require("event")
local sides = require("sides")
local colors = require("colors")
local shell = require("shell")
local rs = component.redstone
 
local prgName = "TeleTronServer"
local version = "v1.0"
 
local lastRequestLocation = -1
 
--[[
DESCRIPTION:
This program is meant to be run as the main server on an ME Spatial Drive MultiDIM Teleportation Network.
 
VERSION: v1.0
AUTHOR: Nickolos Monk, Fryro@Github, thenickmonk@gmail.com
DATE: 2023-06-24
 
REQUIREMENTS:
    1. This server takes a ProjectRed Bundled Cable Input through the back, and a Bundled Cable Output through the front.
    2. Some form of sorting system attached to the output cable, where each channel (color) is a distinct dimension.
        - Note that the inputs determine the outputs directly. An input of WHITE will send the spatial disk to the WHITE target.
    3. This server expects only one of the 16 channels on the input cable to be active at once.
END REQUIREMENTS
 
 
STEPTHROUGH:
Step 1: Once a signal is detected with a strength of x>0, the teleportation signal is fired with that color as the target.
 
Step 2: After 5 seconds, a redstone signal is output on channel 14 (RED, RESERVED FOR RECALL SIGNALS).
    - This recall signal needs to be routed to a pulse maker at each Client Spatial/IO Port.
    - This pulls the spatial disk, regardless of location, to the sorting system input inventory.
 
Step 3: After 2 seconds, a redstone signal is output on the same channel as the input channel.
    - This should activate a filter on the sorting system which allows the disk through to Dimension 12.
 
Step 4: The teleportation should be complete. The client should detect a disk arrived and pulse a signal to the IO/Port to release the contents.
END STEPTHROUGH
 
Note: Do not use channels 14 and 15 on the input and output cables. THese channels are reserved for system operation.

TODO: Reduce magic numbers, convert redstone in/out to binary.
--]]
 
-- Begin: Global Variables
local all_colors = {colors.white, colors.orange, colors.magenta, colors.lightblue, colors.yellow, colors.lime, colors.pink, colors.gray, colors.silver, colors.cyan, colors.purple, colors.blue, colors.brown, colors.green, colors.red, colors.black}
local destinations = {"hub", "dima", "dimb", "dimc"}
local target = 15
 
local debug = 1
 
local inputFace = sides.back
local rsFace = sides.front
-- End: Global Variables
 
 
-- Begin: Functions
function recallDisk()
    if (debug == 1) then
        print("--> Recalling Disks to Hub")
    end
    turnOffRedstone()
    os.sleep(5)
    rs.setBundledOutput(rsFace, colors.red, 200)
    rs.setBundledOutput(rsFace, colors.black, 200)
    os.sleep(3)
    rs.setBundledOutput(rsFace, colors.red, 0)
end    
 
function turnOffRedstone()
    for i,col in ipairs(all_colors) do
        rs.setBundledOutput(rsFace, col, 0)
    end
end
 
function handleRedstone(targetC)
    rs.setBundledOutput(rsFace, targetC, 255)        
end
 
function teleport(target)
    if (debug == 1) then
        print("--> Teleporting Disk to Target: Dimension " .. (target))
    end
    local targetColor = all_colors[target + 1]
    rs.setBundledOutput(rsFace, targetColor, 255)
    if (debug == 1) then
        print("---- CONCLUDE TELEPORTATION SEQUENCE ----\n")
    end
end
 
 
function readInputs()
    local inputStr = 0
    local inputTarget = 15
    for i,col in ipairs(all_colors) do
        inputStr = rs.getBundledInput(inputFace, col)
        if (inputStr > 0) then
            ---if (col ~= lastRequestLocation) then
            ---lastRequestLocation = col
            inputTarget = col
            if (debug == 1) then
                print("==== START TELEPORTATION SEQUENCE ====")
                print("Detected a Teleportation Request (Destination: Dimension " .. inputTarget .. ")")
                ---end
            end
        end
    end
    if (inputTarget ~= 15) then
        recallDisk()
        os.sleep(5)
        rs.setBundledOutput(rsFace, colors.black, 0)
        teleport(inputTarget)
        os.sleep(15)
    end
end
 
-- End: Functions
 
 
-- Main loop
while true do
   readInputs()
   os.sleep(0.25)
   --gui.runGui(mainGui)
end
