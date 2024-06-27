_G.SuperEpicAutoFarm34 = {
    ["AttackMode"] = "3", -- // 1 Punch // 2 Super Punch // 3 Knife //
    ["Fps"] = 60, -- // FPS Cap //
    ["PerformanceMode"] = false, -- // Recommending this false //
    ["ShowStats"] = true, -- Wallet // Profit // Time // ATM's Farmed //
    ["Logging"] = true, -- // is for issues //
    ["HideUsername"] = true,
    ["WebhookMode"] = false,
    ["WebhookTest"] = false,
    ["Webhook"] = "", -- // Webhook Url //
    ["WebhookCooldown"] = 1, -- // Minutes //
}

if (not game:IsLoaded()) then 
    game.Loaded:Wait()
    task.wait(1)
end

repeat task.wait(0.1) until (game:GetService("Players").LocalPlayer) and (game:GetService("Players").LocalPlayer.Character)

local Player = game:GetService("Players").LocalPlayer
local DataFolder
repeat
    DataFolder = Player:FindFirstChild("DataFolder")
    task.wait(1)
until DataFolder

-- Create a performance mode screen
local PerformanceScreen = Instance.new("ScreenGui")
local PerformanceFrame = Instance.new("Frame")
local PerformanceText = Instance.new("TextLabel")

PerformanceScreen.Name = "PerformanceScreen"
PerformanceScreen.Parent = game:GetService("CoreGui")

PerformanceFrame.Name = "PerformanceFrame"
PerformanceFrame.Parent = PerformanceScreen
PerformanceFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PerformanceFrame.Size = UDim2.new(1, 0, 1, 0)
PerformanceFrame.Visible = _G.SuperEpicAutoFarm34.PerformanceMode

PerformanceText.Name = "PerformanceText"
PerformanceText.Parent = PerformanceFrame
PerformanceText.Size = UDim2.new(1, 0, 0, 50)
PerformanceText.Position = UDim2.new(0, 0, 0.5, -25)
PerformanceText.Font = Enum.Font.SourceSansBold
PerformanceText.TextSize = 24
PerformanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
PerformanceText.TextWrapped = true
PerformanceText.Text = "@supercoolboi34 | discord.gg/sharpcc"

-- Create a cleaner stats UI
local StatsBar = Instance.new("ScreenGui")
local StatsFrame = Instance.new("Frame")
local StatsText = Instance.new("TextLabel")
local StatsCorner = Instance.new("UICorner")
local StatsGradient = Instance.new("UIGradient")

StatsBar.Name = "StatsBar"
StatsBar.Parent = game:GetService("CoreGui")
StatsFrame.Name = "StatsFrame"
StatsFrame.Parent = StatsBar
StatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
StatsFrame.BackgroundTransparency = 0.3
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(1, -210, 0, 10)
StatsFrame.Size = UDim2.new(0, 180, 0, 90)
StatsFrame.Visible = _G.SuperEpicAutoFarm34.ShowStats
StatsFrame.AnchorPoint = Vector2.new(1, 0)

StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsFrame

StatsGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 200, 200))
}
StatsGradient.Parent = StatsText

StatsText.Name = "StatsText"
StatsText.Parent = StatsFrame
StatsText.Size = UDim2.new(1, -16, 1, -16)
StatsText.Position = UDim2.new(0, 8, 0, 8)
StatsText.Font = Enum.Font.SourceSansBold
StatsText.TextSize = 16 
StatsText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsText.TextWrapped = true
StatsText.Text = ""
StatsText.TextXAlignment = Enum.TextXAlignment.Left
StatsText.TextYAlignment = Enum.TextYAlignment.Top

-- Create a cleaner log bar under the stats bar
local LogBar = Instance.new("ScreenGui")
local LogFrame = Instance.new("Frame")
local LogText = Instance.new("TextLabel")
local LogCorner = Instance.new("UICorner")
local LogGradient = Instance.new("UIGradient")
local LogType = "Information" -- Default log type

LogBar.Name = "LogBar"
LogBar.Parent = game:GetService("CoreGui")
LogFrame.Name = "LogFrame"
LogFrame.Parent = LogBar
LogFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LogFrame.BackgroundTransparency = 0.3
LogFrame.BorderSizePixel = 0
LogFrame.Position = UDim2.new(1, -210, 0, 110)
LogFrame.Size = UDim2.new(0, 180, 0, 40)
LogFrame.Visible = _G.SuperEpicAutoFarm34.Logging
LogFrame.AnchorPoint = Vector2.new(1, 0)

LogCorner.CornerRadius = UDim.new(0, 8)
LogCorner.Parent = LogFrame

LogGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 200, 200))
}
LogGradient.Parent = LogText

LogText.Name = "LogText"
LogText.Parent = LogFrame
LogText.Size = UDim2.new(1, -16, 1, -16)
LogText.Position = UDim2.new(0, 8, 0, 8)
LogText.Font = Enum.Font.SourceSansBold
LogText.TextSize = 14
LogText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogText.TextWrapped = true
LogText.Text = ""
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top

local function UpdateStats(text)
    if StatsText then
        StatsText.Text = text
    else
        warn("StatsText is not initialized.")
    end
end

local function UpdateLog(text, logType)
    LogText.Text = text
    
    if logType == "Success" then
        LogFrame.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    elseif logType == "Error" then
        LogFrame.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
    elseif logType == "Warning" then
        LogFrame.BackgroundColor3 = Color3.fromRGB(243, 156, 18)
    else
        LogFrame.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
    end
end

local function sendWebhook(profit, webhookTest)
    local placeName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    local username = game.Players.LocalPlayer.Name
    local userId = tostring(game.Players.LocalPlayer.UserId)
    local wallet = Player.DataFolder.Currency.Value

    local msg = {
        embeds = {{
            title = "SuperEpicAutoFarm34",
            description = "Informations:",
            fields = {
                { name = "Username", value = username, inline = true },
                { name = "Wallet", value = "$"..wallet, inline = true },
                { name = "Profit", value = "$"..profit, inline = true },
            },
            color = webhookTest and tonumber(0x00FF00) or tonumber(0xa0e040),
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            type = "rich"
        }}
    }

    local response = http.request({
        Url = _G.SuperEpicAutoFarm34.Webhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(msg)
    })
end

local UIS = game:GetService("UserInputService")
local Cashiers = workspace.Cashiers

repeat task.wait() until (Player.Character:FindFirstChild("FULLY_LOADED_CHAR"))
pcall(function()
    local a = game:GetService("ReplicatedStorage").MainEvent
    local b = {"CHECKER_1", "TeleportDetect", "OneMoreTime"}
    local c
    c = hookmetamethod(game, "__namecall", function(...)
        local d = {...}
        local self = d[1]
        local e = getnamecallmethod()
        local f = getcallingscript()
        if e == "FireServer" and self == a and table.find(b, d[2]) then
            return
        end
        return c(...)
    end)
end)
task.wait(1)

Player.Idled:Connect(function()
    for i = 1, 10 do 
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame) 
        task.wait(0.2) 
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(0.2)
    end
end)

setfpscap(_G.SuperEpicAutoFarm34.Fps)

game:GetService("RunService"):Set3dRenderingEnabled(not _G.SuperEpicAutoFarm34.PerformanceMode)
if _G.SuperEpicAutoFarm34.PerformanceMode then
    pcall(function() UserSettings().GameSettings.MasterVolume = 0 end)
    pcall(function() settings().Rendering.QualityLevel = "Level01" end)
end

task.spawn(function()
    for i,v in pairs(workspace:GetDescendants()) do 
        if (v:IsA("Seat") or (v:IsA("VehicleSeat"))) then 
            v:Destroy()
        end
    end
end)

local StartedWith = DataFolder.Currency.Value
local Cashier, Dist, Index = nil, 0, 0 
local StartTick = os.time()
local Shutdown = false
local Unarresting = false
local LastLog = os.time()+3
local BrokenATMs = 0

local Log = function(Msg, logType)
    UpdateLog(Msg, logType)
end

local IsDead = function()
    return (Player.Character:FindFirstChild("Humanoid") == nil) or (Player.Character.Humanoid.Health <= 0)
end

local GetMag = function(Part) 
    if (not Part) then return 0 end
    return (Part.Position - Player.Character:WaitForChild("Head").Position).Magnitude
end

local ToCurrency = function(Num)
    return tostring(Num):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local GetCashier = function()
    local Cashier, Index = nil, 0
    for i,v in pairs(Cashiers:GetChildren()) do 
        if (v.Humanoid.Health > 0) then 
            if (Cashier == nil) then 
                Cashier = v 
            else 
                if (GetMag(v.Head) < GetMag(Cashier.Head)) then 
                    Cashier = v
                    Index = i
                end
            end
        end
    end

    if (Cashier ~= nil) then 
        return Cashier, GetMag(Cashier.Head), Index
    else 
        return nil
    end
end

local GetCloseCash = function()
    local Am = 0
    
    for i,v in pairs(workspace.Ignored.Drop:GetChildren()) do 
        if (v.Name == "MoneyDrop") and (v:FindFirstChild("ClickDetector")) and (GetMag(v) < 17) then 
            Am += 1
        end
    end
    return Am
end

local function CollectMoney()
    while GetCloseCash() > 0 and not IsDead() and not Shutdown do
        for i,v in pairs(workspace.Ignored.Drop:GetChildren()) do 
            if v.Name == "MoneyDrop" and v:FindFirstChild("ClickDetector") and GetMag(v) < 17 then 
                Player.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3.2, 0)
                fireclickdetector(v.ClickDetector)
                task.wait(0.1)
            end
        end
        task.wait(0.1)
    end
end

local Attack = function()
    local Mode = tonumber(_G.SuperEpicAutoFarm34.AttackMode)

    if (Mode == nil) then
        return Log("INVALID ATTACK METHOD!!!", "Error")
    end

    if (Mode == 1) or (Mode == 2) then 
        if (Player.Backpack:FindFirstChild("Combat")) then 
            task.wait(1.5)
            pcall(function()
                Player.Backpack.Combat.Parent = Player.Character
            end)
        end

        local Combat = Player.Character:FindFirstChild("Combat")
        if (Combat == nil) then return Log("no combat tool found.", "Error") end

        Combat:Activate()

        if (Mode == 1) then 
            task.wait()
            Combat:Deactivate()
        end
    elseif (Mode == 3) then
        if (DataFolder.Currency.Value < 200) then 
            task.spawn(function()
                UpdateStats("| Not enough dhc.")
                task.wait(10)
                UpdateStats("|")
            end)
            return Log("Not enough currency to buy a knife.", "Warning")
        end

        if (Player.Backpack:FindFirstChild("[Knife]") == nil) and (Player.Character:FindFirstChild("[Knife]") == nil) then 
            Log("buying knife.", "Information")
            
            UpdateStats("| Buying knife.")

            repeat 
                local KnifeBuy = workspace.Ignored.Shop["[Knife] - $159"]
                Player.Character.HumanoidRootPart.CFrame = KnifeBuy.Head.CFrame + Vector3.new(0, 3.2, 0)
                task.wait(0.2)
                fireclickdetector(KnifeBuy.ClickDetector)
            until (Player.Backpack:FindFirstChild("[Knife]")) or (Player.Character:FindFirstChild("[Knife]")) or (Shutdown == true)
            UpdateStats("|")
        end

        if (Player.Backpack:FindFirstChild("[Knife]")) then 
            task.wait(0.66)
            pcall(function()
                Player.Backpack["[Knife]"].Parent = Player.Character
            end)
        end

        local Knife = Player.Character:FindFirstChild("[Knife]")
        if (Knife == nil) then return Log("no knife tool found.", "Error") end

        Knife:Activate()
        task.wait(0.1)
    end
end

local AntiSit = function(Char)
    task.wait(1)    
    local Hum = Char:WaitForChild("Humanoid")
    Hum.Seated:Connect(function()
        warn("SITTING")
        Hum.Sit = false
        Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        task.wait(0.3)
        Hum.Jump = true
    end)
end

task.spawn(function()
    while true and task.wait(0.2) do 
        if (Player.Character) and (Player.Character:FindFirstChild("FULLY_LOADED_CHAR")) and (Shutdown == false) then 
            local Root, Hum = Player.Character:WaitForChild("HumanoidRootPart"), Player.Character:WaitForChild("Humanoid")
            local Start = os.time()
            repeat 
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 500, 0)
                UpdateStats("| Finding ATM.")
                
                Cashier, Dist, Index = GetCashier() 
                task.wait()
            until (Cashier ~= nil) or (IsDead() == true) or (Shutdown == true) 
            UpdateStats("|")
            Log("found atm "..tostring(Index)..", distance: "..tostring(Dist)..".", "Success")
            
            if (Unarresting == true) then 
                UpdateStats("| Uncuffing.")

                task.wait(0.5)
                repeat 
                    local Key = workspace.Ignored.Shop["[Key] - $133"]

                    Player.Character.HumanoidRootPart.CFrame = Key.Head.CFrame + Vector3.new(0, 1, 0)
                    task.wait(0.5)

                    fireclickdetector(Key.ClickDetector)

                    if (Player.Backpack:FindFirstChild("[Key]")) then 
                        pcall(function()
                            Player.Backpack["[Key]"].Parent = Player.Character
                        end)
                    end
                    task.wait()
                until (Shutdown == true) or (IsDead() == true) or (Unarresting == false)
            end
            
            repeat 
                Root.Velocity = Vector3.new(0, 0, 0)
                if (_G.SuperEpicAutoFarm34.AttackMode == "4") then 
                    if (Index == 15) or (Index == 16) then 
                        Root.CFrame = Cashier.Head.CFrame + Cashier.Head.CFrame.LookVector * Vector3.new(-12, 2, -12) + Vector3.new(0, -2, 0)
                    else 
                        Root.CFrame = Cashier.Head.CFrame + Cashier.Head.CFrame.LookVector * Vector3.new(-4, 1, -4)  + Vector3.new(0, -2, 0)
                    end
                else 
                    Root.CFrame = Cashier.Head.CFrame + Cashier.Head.CFrame.LookVector * Vector3.new(-2.2, -1, -2.2) + Vector3.new(0, -2, 0)
                end
                
                task.wait(0.25)
                Attack()
            until (Cashier.Humanoid.Health <= 0) or (IsDead() == true) or (Shutdown == true) or (os.time()-Start>=16)

            Root.CFrame = CFrame.new(Cashier.Head.Position) + Vector3.new(math.random(-2, 2), 1, math.random(-2, 2))
            
            UpdateStats("| Picking Cash.")
            
            if (Cashier.Humanoid.Health <= 0) then 
                BrokenATMs += 1
            end
            
            -- Un-equip tool to pick up money
            if Player.Character:FindFirstChildOfClass("Tool") then
                Player.Character:FindFirstChildOfClass("Tool").Parent = Player.Backpack
            end
            
            -- Collect the money
            CollectMoney()

            UpdateStats("|")
            Cashier = nil
        end
    end
end)

Player.CharacterAdded:Connect(AntiSit)
task.spawn(function()
    task.wait(3)
    AntiSit(Player.Character)
end)

local function HideUsername(statsText)
    if _G.SuperEpicAutoFarm34.HideUsername then
        return statsText:gsub("Username: %w+\n", "")
    else
        return statsText
    end
end

task.spawn(function()
    while true and task.wait() do 
        if (Shutdown == true) then return end
        local statsText = string.format("Username: %s\nWallet: $%s\nProfit: $%s\nTime: %02i:%02i:%02i\nATMs: %d",
            Player.Name,
            ToCurrency(DataFolder.Currency.Value),
            ToCurrency(DataFolder.Currency.Value - StartedWith),
            math.floor((os.time()-StartTick)/3600),
            math.floor((os.time()-StartTick)/60%60),
            (os.time()-StartTick)%60,
            BrokenATMs
        )
        statsText = HideUsername(statsText)
        UpdateStats(statsText)
        
        for i,v in pairs(Cashiers:GetChildren()) do 
            if (i == 15) then 
                v:MoveTo(Vector3.new(-621.948, 24, -286.52))
                for x,z in pairs(v:GetChildren()) do 
                    if (z:IsA("Part")) or (z:IsA("BasePart")) then 
                        z.CanCollide = false 
                        z.Anchored = false 
                    end
                end
            elseif (i == 16) then 
                v:MoveTo(Vector3.new(-631.948, 24, -286.52))
                for x,z in pairs(v:GetChildren()) do 
                    if (z:IsA("Part")) or (z:IsA("BasePart")) then 
                        z.CanCollide = false 
                        z.Anchored = false 
                    end
                end
            end
        end
        
        pcall(function()
            Unarresting = Player.Character.BodyEffects.Cuff.Value
            if (Unarresting == nil) then 
                Unarresting = false
            end
        end)
        
        if (UIS:IsKeyDown(Enum.KeyCode.LeftControl)) and (UIS:IsKeyDown(Enum.KeyCode.L)) then 
            Shutdown = true 

            StatsBar:Destroy()
            LogBar:Destroy()
            PerformanceScreen:Destroy()
            game:GetService("RunService"):Set3dRenderingEnabled(true)
            break
        end
    end
end)

if _G.SuperEpicAutoFarm34.WebhookTest then
    sendWebhook(0, true)
end

if _G.SuperEpicAutoFarm34.WebhookMode then
    task.spawn(function()
        while not Shutdown do
            task.wait(_G.SuperEpicAutoFarm34.WebhookCooldown * 60)
            sendWebhook(DataFolder.Currency.Value - StartedWith, false)
        end
    end)
end