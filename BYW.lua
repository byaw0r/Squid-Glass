--BYW SCRIPT

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Gerad's/source.lua"))()

local Window = Library:CreateWindow('Segment Colorer')
local Section = Window:Section('Segment Coloring')

local originalColors = {}
local autoWinConnection
local isAutoWinRunning = false
local autoWinEnabled = false

local function findSegmentSystem()
    return workspace:FindFirstChild("segmentSystem")
end

local function getSegments()
    local segmentSystem = findSegmentSystem()
    return segmentSystem and segmentSystem:FindFirstChild("Segments")
end

local function processSegmentParts(callback)
    local segments = getSegments()
    if not segments then
        warn("Segments not found!")
        return
    end
    
    for _, segment in ipairs(segments:GetChildren()) do
        if segment:IsA("Model") and segment.Name:match("Segment%d+") then
            for _, folder in ipairs(segment:GetChildren()) do
                if folder:IsA("Folder") then
                    for _, part in ipairs(folder:GetChildren()) do
                        if part:IsA("Part") then
                            callback(part)
                        end
                    end
                end
            end
        end
    end
end

local function saveOriginalColors()
    originalColors = {}
    processSegmentParts(function(part)
        originalColors[part] = {
            BrickColor = part.BrickColor,
            Material = part.Material,
            Transparency = part.Transparency
        }
    end)
end

local function restoreOriginalColors()
    processSegmentParts(function(part)
        if originalColors[part] then
            part.BrickColor = originalColors[part].BrickColor
            part.Material = originalColors[part].Material
            part.Transparency = originalColors[part].Transparency
        end
    end)
end

local function colorSegmentsByBreakable()
    saveOriginalColors()
    
    processSegmentParts(function(part)
        if part:FindFirstChild("breakable") then
            part.BrickColor = BrickColor.new("Really red")
            part.Material = Enum.Material.Neon
            part.Transparency = 0.2
        else
            part.BrickColor = BrickColor.new("Lime green")
            part.Material = Enum.Material.Neon
            part.Transparency = 0.2
        end
    end)
end

local function getPlayerRoot()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    return character:WaitForChild("HumanoidRootPart")
end

local function teleportToFinish()
    local humanoidRootPart = getPlayerRoot()
    humanoidRootPart.CFrame = CFrame.new(-744.015198, 75, -556.055664)
end

local function startAutoWin()
    if isAutoWinRunning then return end
    isAutoWinRunning = true
    autoWinEnabled = true
    
    local player = game.Players.LocalPlayer
    
    autoWinConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoWinEnabled then
            autoWinConnection:Disconnect()
            isAutoWinRunning = false
            return
        end
        
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            humanoidRootPart.CFrame = CFrame.new(-744.015198, 75, -556.055664)
        end
    end)
end

local function stopAutoWin()
    autoWinEnabled = false
    if autoWinConnection then
        autoWinConnection:Disconnect()
        autoWinConnection = nil
    end
    isAutoWinRunning = false
end

Section:Toggle('Esp Block', {flag = 'EspBlock'}, function(value)
    if value then
        colorSegmentsByBreakable()
    else
        restoreOriginalColors()
    end
end)

Section:Button('Teleport to Finish', function()
    teleportToFinish()
end)

Section:Toggle('Auto Win', {flag = 'AutoWin'}, function(value)
    if value then
        startAutoWin()
        print("Auto Win: ON")
    else
        stopAutoWin()
        print("Auto Win: OFF")
    end
end)

print("BYW SCRIPT loaded successfully!")
