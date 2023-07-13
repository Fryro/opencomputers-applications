local component = require("component")
local gpu = component.gpu
gpu.setResolution(80,25)
local gui = require("gui")
local event = require("event")
local sides = require("sides")
local colors = require("colors")
local shell = require("shell")
 
local rs = component.redstone
 
gui.checkVersion(2,5)
 
local prgName = "example"
local version = "v1.0"
 
 
local all_colors = {colors.white, colors.orange, colors.magenta, colors.lightblue, colors.yellow, colors.lime, colors.pink, colors.gray, colors.silver, colors.cyan, colors.purple, colors.blue, colors.brown, colors.green, colors.red, colors.black}
local destinations = {"hub", "dima", "dimb", "dimc"}
local target = 15
 
local rsFace = sides.back
 
-- NOTE: DO NOT USE TARGETS 14 AND 15
--       - Target 14 is the Recall Signal
--       - Target 15 is RESERVED (Illegal State)
-- END NOTE
-- Begin: Callbacks
local function radio_dim0(guiID, radioID, status)
    target = 0
end
 
local function radio_dim1(guiID, radioID, status)
    target = 1
end
 
local function radio_dim2(guiID, radioID, status)
    target = 2
end
 
local function radio_dim3(guiID, radioID, status)
    target = 3
end
 
local function radio_dim4(guiID, radioID, status)
    target = 4
end
 
local function radio_dim5(guiID, radioID, status)
    target = 5
end
 
local function initialize_teleport(guiID, buttonID)
    recallDisk()
    os.sleep(2)
    teleport(target)
    os.sleep(10)
    turnOffRedstone()
end
 
-- End: Callbacks
 
 
-- Begin: User Functions
function recallDisk()
    turnOffRedstone()
    os.sleep(2)
    rs.setBundledOutput(rsFace, colors.red, 40)
    os.sleep(1)
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
    local targetColor = all_colors[target + 1]
    rs.setBundledOutput(rsFace, targetColor, 255)
end
 
-- End: User Functions
 
 
-- Begin: Menu definitions
mainGui = gui.newGui(1, 2, 79, 23, true)
header_label = gui.newLabel(mainGui, 26, 1, "Select Target Dimension", 0xc0c0c0, 0x0, 10)
hline_0 = gui.newHLine(mainGui, 1, 2, 75)
radio_dim0 = gui.newRadio(mainGui, 1, 5, radio_dim0)
radio_dim1 = gui.newRadio(mainGui, 37, 5, radio_dim1)
radio_dim2 = gui.newRadio(mainGui, 1, 8, radio_dim2)
radio_dim3 = gui.newRadio(mainGui, 37, 8, radio_dim3)
radio_dim4 = gui.newRadio(mainGui, 1, 11, radio_dim4)
radio_dim5 = gui.newRadio(mainGui, 37, 11, radio_dim5)
label_dim0 = gui.newLabel(mainGui, 5, 5, "Earth", 0xc0c0c0, 0x0, 7)
label_dim1 = gui.newLabel(mainGui, 41, 5, "Phobos", 0xc0c0c0, 0x0, 7)
label_dim2 = gui.newLabel(mainGui, 5, 8, "Asteroid Base", 0xc0c0c0, 0x0, 7)
label_dim3 = gui.newLabel(mainGui, 41, 8, "Callisto", 0xc0c0c0, 0x0, 7)
label_dim4 = gui.newLabel(mainGui, 5, 11, "Dim 5", 0xc0c0c0, 0x0, 7)
label_dim5 = gui.newLabel(mainGui, 41, 11, "Dim 6", 0xc0c0c0, 0x0, 7)
init_tp_button = gui.newButton(mainGui, 30, 20, "init_tp_button", initialize_teleport)
hline_1 = gui.newHLine(mainGui, 1, 18, 75)
-- End: Menu definitions
 
gui.clearScreen()
gui.setTop("InterDim-o-Tron 9000")
gui.setBottom("Sponsored by FactoryCo")
 
-- Main loop
while true do
   gui.runGui(mainGui)
end
