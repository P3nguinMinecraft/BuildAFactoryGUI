-- vars
local autoclaim = true
local autotrain = true
local ws = game:GetService("Workspace")
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local plot, xval, zval
local traintotal = 0
local plotCoordinates = {
    [1] = { xval = -432, zval = -285 },
    [2] = { xval = -781, zval = -285 },
    [3] = { xval = -1130, zval = -285 },
    [4] = { xval = -1487, zval = -285 },
    [5] = { xval = -1130, zval = 144 },
    [6] = { xval = -781, zval = 144 },
    [7] = { xval = -1487, zval = 144 },
    [8] = { xval = -432, zval = 144 },
}
local autoMineRows = 6
local rowCounter = 0
local mineCounter = 0


-- functions
function parseValue(valueStr)
    if not valueStr or valueStr == "" then
        return nil
    end

    local multiplier = 1
    local suffix = valueStr:sub(-1)

    if suffix == 'K' then
        multiplier = 1000
    elseif suffix == 'M' then
        multiplier = 1000000
    end

    local numericValueStr = valueStr:gsub("[KM]", "")
    local numericValue = tonumber(numericValueStr)

    if not numericValue then
        return nil
    end

    return numericValue * multiplier
end

function tpto(location)    
    humanoidRootPart.CFrame = location
end

function mineblock(blockName)
    game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("MineBlock"):InvokeServer(blockName)
end

function mineRow(row)
    spawn(function()
        for j = 0, 14 do
            local blockString = row .. "_" .. j
            mineblock(blockString)
            wait(0.2)
        end
        mineCounter = mineCounter + 1
    end)
end

function teleportController(rowCount)
    spawn(function()
        for i = 0, 28 do
            while mineCounter < rowCount do
                wait()
            end
            --print("teleport")
            zval = zval + (70/29) * rowCount
            tpto(CFrame.new(xval, 3, zval))
            wait(0.2)
            mineCounter = 0
            rowCounter = 0
        end
    end)
end

function autoMine(rowCount)
    xval = plotCoordinates[plot].xval
    zval = plotCoordinates[plot].zval
    print(rowCount)
    spawn(function()
        tpto(CFrame.new(xval, 3, zval))
        wait(0.2)
        teleportController(rowCount)
        for n = 0, 28 do
            while rowCounter >= rowCount do -- assign and start mining rowcount rows
                wait()
            end
            mineRow(n)
            --print("mining" .. n)
            rowCounter = rowCounter + 1
         end
    end)
end










-- doing things

-- find plot
for _, v in pairs(ws.Plots:GetChildren()) do
    local owner = v:FindFirstChild("Owner")
    if owner then
        if tostring(owner.Value) == player.Name then
            plot = tonumber(v.Name)
            print("Plot Found: " .. plot)
            xval = plotCoordinates[plot].xval
            zval = plotCoordinates[plot].zval
            break
        end
    else
        print("Owner not found... how did this happen?")
    end
end

-- define plot stuff
local plotfolder = ws.Plots:FindFirstChild(plot)
local traincars = plotfolder.Core.Train.Main.Cars
local tankdisplay = plotfolder.Core.TankDisplay.SurfaceGui.Amount

-- autoclaim
spawn(function()
    while wait(10) do
        if autoclaim then
            game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("SellItems"):InvokeServer()
            game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("CollectSkyIslandTank"):FireServer("Island1")
        end
    end
end)

-- autotrain
spawn(function()
    while wait(0.5) do
        if plot then
            traintotal = 0
            for _,v in pairs(traincars:GetChildren()) do
                local carvalue = v:FindFirstChild("Value")
                traintotal = traintotal + carvalue.Value
            end
            local tanktext = tankdisplay.Text
            local ValueStr1 = tanktext:match("^(.-)/")
            local tankValue = parseValue(ValueStr1)
            local ValueStr2 = tanktext:match("/(.-)$")
            local tankMaxValue = parseValue(ValueStr2)
            local tankMissingValue = tankMaxValue - tankValue
            --print(tankValue .. " / " .. tankMaxValue .. ", " .. traintotal .. " | " .. tankMissingValue)
            if tankMissingValue < traintotal and traintotal > 0 and autotrain == true then
                game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("CallTrain"):FireServer()
                --print("called train")
                wait(40)
            end
        end
    end
end)

autoMine(autoMineRows)