print("[BAF] Loading Build A Factory GUI")
getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- local vars
local ws = game:GetService("Workspace")
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local Humanoid = character:WaitForChild("Humanoid")
local plot, xval, zval
local traintotal = 0
local trainfull = false
local rowCounter = 0
local mineCounter = 0
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
local autocollecttoggle = false
local autocollectdelay = 10
local autotraintoggle = false
local autoMineRows = 1
local autoMineToggle = false
local autoMineBlock = false
local WalkspeedToggleOld = false
local WalkspeedToggle = false
local Walkspeed = 30
local JumpPowerToggle = false
local JumpPower = 50

print("[BAF] Loading Window")

local Window = Rayfield:CreateWindow({
    Name = "Build A Factory",
    LoadingTitle = "Build A Factory GUI",
    LoadingSubtitle = "by penguin",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "buildafactorygui", -- Create a custom folder for your hub/game
        FileName = "buildafactorygui_config"
    },
    Discord = { 
        Enabled = false,
        Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
        RememberJoins = false -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
        SaveKey = true, -- The user's key wiCH be saved, but if you change the key, they wiCH be unable to use your script
        GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
        Key = {"random"} -- List of keys that wiCH be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("heCHo","key22")
    }
})

print("[BAF] Loading Info Tab")

local CreditTab = Window:CreateTab("Info", nil) -- Title, Image

local CreditLabel1 = CreditTab:CreateLabel("Developed by penguin586970")

local CreditLabel2 = CreditTab:CreateLabel("Executor used: MacSploit (not affiliated!)")

local CreditLabel3 = CreditTab:CreateLabel("For questions, concerns, contact windows1267 on discord")

print("[BAF] Loading Auto Tab")

local AutoTab = Window:CreateTab("Auto", nil) -- Title, Image

local AutoParagraph1 = AutoTab:CreateParagraph({Title = "Auto Collect", Content = "Collects all currencies automatically every x seconds"})

local AutoToggle1 = AutoTab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = false,
    Flag = "AutoToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autocollecttoggle = Value
    end,
})

local AutoSlider1 = AutoTab:CreateSlider({
    Name = "Auto Collect Delay",
    Range = {1, 60},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = 10,
    Flag = "AutoCollectSlider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autocollectdelay = Value
    end,
})

local AutoParagraph2 = AutoTab:CreateParagraph({Title = "Auto Call Train", Content = "Calls train when the amount in train is more than the amount missing in tank or when the train is almost full. "})

local AutoToggle2 = AutoTab:CreateToggle({
    Name = "Auto Call Train",
    CurrentValue = false,
    Flag = "AutoToggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autotraintoggle = Value
    end,
})

print("[BAF] Loading Auto Mine Tab")

local AutoMineTab = Window:CreateTab("Auto Mine", nil) -- Title, Image

local AutoMineSlider1 = AutoMineTab:CreateSlider({
    Name = "Auto Mine Range",
    Range = {1, 6},
    Increment = 1,
    Suffix = "rows at once",
    CurrentValue = 1,
    Flag = "AutoMineSlider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autoMineRows = Value
    end,
})

local AutoMineButton1 = AutoMineTab:CreateButton({
    Name = "Auto Mine",
    Callback = function()
        if autoMineBlock == false then
            autoMine(autoMineRows)
        else
            Rayfield:Notify({
                Title = "Slow Down!",
                Content = "Only press the button again when a run is done. ",
                Duration = 5,
                Image = nil,
                Actions = { -- Notification Buttons
                },
            })
        end
    end,
})


local AutoMineToggle1 = AutoMineTab:CreateToggle({
    Name = "Auto Mine (looped)",
    CurrentValue = false,
    Flag = "AutoMineToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        autoMineToggle = Value
    end,
})




print("[BAF] Loading Tools Tab")

local ToolTab = Window:CreateTab("Tools", nil) -- Title, Image

local ToolParagraph1 = ToolTab:CreateParagraph({Title = "Small Things", Content = "These are probably availiable in other universal scripts but I find it easy to access here. "})

local ToolLabel1 = ToolTab:CreateLabel("Walkspeed")

local ToolToggle1 = ToolTab:CreateToggle({
   Name = "Walkspeed Toggle",
   CurrentValue = false,
   Flag = "ToolToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      WalkspeedToggle = Value
   end,
})

local ToolSlider1 = ToolTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Studs/Sec",
   CurrentValue = 30,
   Flag = "ToolSlider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      Walkspeed = Value
   end,
})

local ToolToggle2 = ToolTab:CreateToggle({
   Name = "Jump Power Toggle",
   CurrentValue = false,
   Flag = "ToolToggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      JumpPowerToggle = Value
   end,
})

local ToolSlider2 = ToolTab:CreateSlider({
   Name = "Jump Power",
   Range = {0, 200},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 50,
   Flag = "ToolSlider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      JumpPower = Value
   end,
})

local ToolSection1 = ToolTab:CreateSection("Universal Scripts")

local ToolButton1 = ToolTab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() -- Credit: Infinite Yield
   end,
})

local ToolButton2 = ToolTab:CreateButton({
   Name = "Remote Spy (Simple Spy v3)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))() -- Credit: SimpleSpy v3
   end,
})

local ToolButton3 = ToolTab:CreateButton({
   Name = "Remote Spy (Simple Spy v2.2)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))() -- Credit: SimpleSpy v3
   end,
})

local ToolButton4 = ToolTab:CreateButton({
   Name = "Orca",
   Callback = function()
      loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua"))() -- Credit: orca
   end,
})

local ToolButton5 = ToolTab:CreateButton({
   Name = "CMD-X",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source",true))() -- Credit: CMD-X
   end,
})

local ToolButton6 = ToolTab:CreateButton({
   Name = "Dex",
   Callback = function()
      loadstring(game:HttpGet('https://ithinkimandrew.site/scripts/tools/dark-dex.lua'))()
   end,
})

-- functions
function parseValue(valuestr)
    if not valuestr or valuestr == "" then
        return nil
    end

    local multiplier = 1
    local suffix = valuestr:sub(-1)

    if suffix == 'K' then
        multiplier = 1000
    elseif suffix == 'M' then
        multiplier = 1000000
    end

    local numericvaluestr = valuestr:gsub("[KM]", "")
    local numericValue = tonumber(numericvaluestr)

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
    if autoMineBlock == false then
        spawn(function()
            autoMineBlock = true
            tpto(CFrame.new(xval, 3, zval))
            wait(0.2)
            teleportController(rowCount)
            for n = 0, 28 do
                while rowCounter >= rowCount do -- assign and start mining rowcount rows
                    wait()
                end
                mineRow(n)
                rowCounter = rowCounter + 1
            end
            autoMineBlock = false
        end)
    end
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
    end
end

-- define plot stuff
local plotfolder = ws.Plots:FindFirstChild(plot)
local traincars = plotfolder.Core.Train.Main.Cars
local tankdisplay = plotfolder.Core.TankDisplay.SurfaceGui.Amount

-- autocollect
spawn(function()
    while wait(autocollectdelay) do
        if autocollecttoggle then
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
                if v.Name == "1" and carvalue.Value > 0 then trainfull = true end
            end
            local tanktext = tankdisplay.Text
            local valuestr1 = tanktext:match("^(.-)/")
            local tankValue = parseValue(valuestr1)
            local valuestr2 = tanktext:match("/(.-)$")
            local tankMaxValue = parseValue(valuestr2)
            local tankMissingValue = tankMaxValue - tankValue
            --print(tankValue .. " / " .. tankMaxValue .. ", " .. traintotal .. " | " .. tankMissingValue)
            if (tankMissingValue < traintotal or trainfull == true) and traintotal > 0 and autotraintoggle == true then
                game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("CallTrain"):FireServer()
                trainfull = false
                --print("called train")
                wait(40)
            end
        end
    end
end)

-- automine
spawn(function()
    while wait(0.1) do
        if autoMineToggle == true and autoMineBlock == false then
            autoMine(autoMineRows)
            wait(1)
        end
    end
end)

-- tools
spawn(function()
   while wait(0.01) do
      if WalkspeedToggleOld == true and WalkspeedToggle == false then
         Humanoid.WalkSpeed = 16
      end
      if WalkspeedToggle then
         Humanoid.WalkSpeed = Walkspeed
      end
      if JumpPowerToggleOld == true and JumpPowerToggle ==false then
         Humanoid.JumpPower = 50
      end
      if JumpPowerToggle then
         Humanoid.JumpPower = JumpPower
      end
      WalkspeedToggleOld = WalkspeedToggle
      JumpPowerToggleOld = JumpPowerToggle
   end
end)
