local component = require("component")
local gpu = component.gpu
gpu.setResolution(68, 25)
local event = require("event")
local sides = require("sides")
local colors = require("colors")
local shell = require("shell")
local rs = component.redstone
 
local prgName = "turbineController"
local version = "v1.0"
 
local rsFace = sides.front
local all_colors = {colors.white, colors.orange, colors.magenta, colors.lightblue, colors.yellow, colors.lime, colors.pink, colors.gray, colors.silver, colors.cyan, colors.purple, colors.blue, colors.brown, colors.green, colors.red, colors.black}

-- For Turbines: 1 = OFF (Signal Inverted for Safety Fallbacks)
-- For Reactor: 1 = ON (Reactor is OFF on startup)
local turbineStates = {1, 1, 1, 1, 0}
 
 
function turbineOn(target)
    if (target == 6) then
        local targetColor = all_colors[5]
        turbineStates[5] = 1
    elseif (target == 5) then
        turbineOn(1)
        turbineOn(2)
        turbineOn(3)
        turbineOn(4)
    else
        print("** Enabled Turbine " .. target .. " **")
        local targetColor = all_colors[target]
        turbineStates[target] = 0
    end
    redstoneBackbone()
end
 
 
function turbineOff(target)
    if (target == 6) then
        local targetColor = all_colors[5]
        turbineStates[5] = 0
    elseif (target == 5) then
        turbineOff(1)
        turbineOff(2)
        turbineOff(3)
        turbineOff(4)
    else
        print("** Disabled Turbine " .. target .. " **")
        local targetColor = all_colors[target]
        turbineStates[target] = 1
    end
    redstoneBackbone()    
end
 
 
function redstoneBackbone()
    local enabledColors = {}
    for i,col in ipairs(all_colors) do
        if (turbineStates[i] == 1) then
            rs.setBundledOutput(rsFace, all_colors[i], 255)
        else
            rs.setBundledOutput(rsFace, all_colors[i], 0)
        end
    end
    --rs.setBundledOutput(rsFace, enabledColors)
end
 
 
function displayCurrentState()
    print("====================>>> \27[35mCurrent System State\27[37m <<<===================")
    if (turbineStates[5] == 1) then
        print("-----------------<<<  \27[33mReactor  \27[37mState: \27[32mENABLED\27[37m  >>>-----------------")
    else
        print("-----------------<<<  \27[33mReactor  \27[37mState: \27[31mDISABLED\27[37m >>>-----------------")
    end
    for i,state in ipairs(turbineStates) do
        if (i == 5) then
            local chew = 0
        else
            if (state == 0) then
                print("-----------------<<< \27[36mTurbine " .. (i) .. " \27[37mState: \27[32mENABLED\27[37m  >>>-----------------")
            else
                print("-----------------<<< \27[36mTurbine " .. (i) .. " \27[37mState: \27[31mDISABLED\27[37m >>>-----------------")
            end
        end
    end
end
 
 
function getInput()
    shell.execute("clear")
    displayCurrentState()
    local valid_inputs = {"1", "2", "3", "4"}
    
    local dl_1 = "===================================================================\n" 
    local dl_2 = "====                          Actions                          ====\n" 
    local dl_3 = "====    \27[32mER\27[37m: Enable Reactor            \27[31mDR\27[37m: Disable Reactor      ====\n"
    local dl_4 = "====    \27[32mEX\27[37m: Enable Turbine X          \27[31mDX\27[37m: Disable Turbine X    ====\n" 
    local dl_5 = "====    \27[32mEA\27[37m: Enable All Turbines       \27[31mDA\27[37m: Disable All Turbines ====\n"
    local dl_6 = "====    \27[31mXX\27[37m: Exit.\27[37m This maintains the system state, but upon    ====\n"
    local dl_7 = "====              restart, shuts \27[31meverything\27[37m off. Be careful.   ====\n"
    local dl_8 = "===================================================================\n"
    
    local choice_display = dl_1 .. dl_2 .. dl_3 .. dl_4 .. dl_5 .. dl_6 .. dl_7 .. dl_8
    print(choice_display)
 
    print("vvv INPUT vvv")
    local action,tar = io.read(1,1)
    local junkVar = io.read("*l")
    local target = tonumber(tar)
 
    if (tar == "A") then
        target = 5
    elseif (tar == "X") then
        os.exit()
    elseif (tar == "R") then
        target = 6
    else
        local valid = 0
        for i,val in ipairs(valid_inputs) do
            if (tar == val) then
                target = tonumber(tar)
                valid = 1
            end
        end
        if (valid == 0) then
            print("--** Your turbine selection was out of range. Please try again **--")
            return
        end
    end
    
    if (action == "E") then
        turbineOn(target)
    elseif (action == "D") then
        turbineOff(target)
    else
        print("--** Please enter a valid action (E/D) **--")
        return
    end 
end
 
while true do
    getInput()
    os.sleep(0.25)
end
