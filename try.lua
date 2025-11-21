-- Universal Hitbox Extender with Rayfield UI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Load Universal Hitbox Extender core
getgenv().UHECore = getgenv().UHECore or loadstring(game:HttpGet("https://raw.githubusercontent.com/ronbernarte18-rgb/T/refs/heads/main/try.lua"))()
local HitboxExtender = getgenv().UHECore

-- Settings table
local d = HitboxExtender.settings or {
    extendHitbox = false,
    hitboxSize = Vector3.new(5,5,5),
    hitboxTransparency = 0,
    hitboxCanCollide = false,
    customPartName = "HeadHB",
    ignoreTeammates = false,
    ignoreFF = false,
    ignoreSitting = false,
    ignorePlayerList = {},
    ignoreTeamList = {}
}

-- Load Rayfield UI
getgenv().uilibray = getgenv().uilibray or loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Rayfield = getgenv().uilibray

-- Create main window
local Window = Rayfield:CreateWindow({
    Name = "Universal Hitbox Extender",
    LoadingTitle = "Hitbox Extender",
    Theme = "Default",
    DisableRayfieldPrompts = true,
    ConfigurationSaving = { Enabled = true, FolderName = "HitboxExtenderConfigs", FileName = "Configuration" }
})

-- Create Tabs
local SettingsTab = Window:CreateTab("Settings", "gear")
local TargetTab = Window:CreateTab("Target", "crosshair")
local ThemesTab = Window:CreateTab("Themes", "palette") -- Optional

-- SETTINGS TAB
SettingsTab:CreateToggle({
    Name = "Enable Hitbox",
    CurrentValue = d.extendHitbox,
    Flag = "HitboxToggle",
    Callback = function(Value)
        d.extendHitbox = Value
    end
})

SettingsTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = d.hitboxSize.X,
    Flag = "HitboxSize",
    Callback = function(Value)
        d.hitboxSize = Vector3.new(Value, Value, Value)
    end
})

SettingsTab:CreateSlider({
    Name = "Hitbox Transparency",
    Range = {0,1},
    Increment = 0.05,
    CurrentValue = d.hitboxTransparency,
    Flag = "HitboxTransparency",
    Callback = function(Value)
        d.hitboxTransparency = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Hitbox Can Collide",
    CurrentValue = d.hitboxCanCollide,
    Flag = "HitboxCanCollide",
    Callback = function(Value)
        d.hitboxCanCollide = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Ignore Teammates",
    CurrentValue = d.ignoreTeammates,
    Flag = "IgnoreTeammates",
    Callback = function(Value)
        d.ignoreTeammates = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Ignore Force Fields",
    CurrentValue = d.ignoreFF,
    Flag = "IgnoreFF",
    Callback = function(Value)
        d.ignoreFF = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Ignore Sitting",
    CurrentValue = d.ignoreSitting,
    Flag = "IgnoreSitting",
    Callback = function(Value)
        d.ignoreSitting = Value
    end
})

-- TARGET TAB
local TargetLimbDropdown = TargetTab:CreateDropdown({
    Name = "Target Limb",
    Options = {},
    CurrentOption = {d.customPartName},
    MultipleOptions = false,
    Flag = "TargetLimb",
    Callback = function(Option)
        d.customPartName = Option[1]
    end
})

-- Dynamically add limbs to dropdown
local limbs = {}
local function addLimbIfNew(name)
    if not name then return end
    if not table.find(limbs, name) then
        table.insert(limbs, name)
        table.sort(limbs)
        TargetLimbDropdown:Refresh(limbs)
    end
end

local function onCharacterAdded(Character)
    if not Character then return end
    for _, part in ipairs(Character:GetChildren()) do
        addLimbIfNew(part.Name)
    end
    Character.ChildAdded:Connect(function(part)
        addLimbIfNew(part.Name)
    end)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- Integrate original Universal Hitbox Extender hooks
local Entities = HitboxExtender.loadEntities or {}
task.spawn(function()
    while task.wait(0.1) do
        if d.extendHitbox then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player ~= LocalPlayer then
                    HitboxExtender.addEntity(player.Character)
                end
            end
        end
    end
end)

-- Load Rayfield configuration
Rayfield:LoadConfiguration()
