--[[
    Cleaned Script (Blox Fruits - No Security)
    Đã xoá toàn bộ: heartbeat, anti-HttpSpy, anti-hook, key check, kick logic.
    Chỉ giữ lại UI và gameplay logic.
]]

-- ============================================================
-- Khởi động – chờ game và player load
-- ============================================================

while true do
    wait()
    if not game:IsLoaded() then continue end
    if not game.Players.LocalPlayer then continue end
    break
end

-- ============================================================
-- Services
-- ============================================================

local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- UI – Setting Farm
-- ============================================================

-- Toggle: Auto Click (Blox Fruit)
SettingFarmMainSection:CreateToggle({
    Title   = "Auto Click",
    Desc    = "",
    Default = Settings["Auto Click"] or false,
}, function(enabled)
    if enabled then
        spawn(function()
            while Settings["Auto Click"] do
                local ok, err = pcall(function()
                    if NameWeapon("Blox Fruit") then
                        local char = LocalPlayer.Character
                        if char then
                            local targets = AttackAOE(80, true)
                            if targets then
                                getgenv().UseFruitM1(targets[1][1])
                            else
                                getgenv().AttackFunctionnhungSuperTrial()
                            end
                        end
                    end
                end)
                if err then print(err) end
                task.wait()
            end
        end)
    end
    SaveSettings("Auto Click", enabled)
end)

-- Toggle: Kill Aura With DragonStorm
SettingFarmMainSection:CreateToggle({
    Title   = "Kill Aura With DragonStorm",
    Desc    = "",
    Default = Settings["Kill Aura With DragonStorm"] or false,
}, function(enabled)
    if enabled then
        spawn(function()
            while Settings["Kill Aura With DragonStorm"] do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Dragonstorm") then
                        if getgenv().SpamGunDragonStorm then
                            local targets = AttackAOE(150, false)  -- second arg: closest enemy list helper
                            if targets then
                                SpamGunDragonStorm(targets[1].PrimaryPart)
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
    SaveSettings("Kill Aura With DragonStorm", enabled)
end)

-- Toggle: Auto Turn On Buso
SettingFarmMainSection:CreateToggle({
    Title   = "Auto Turn On Buso",
    Desc    = "",
    Default = Settings["Auto Turn On Buso"] ~= nil and Settings["Auto Turn On Buso"] or true,
}, function(enabled)
    if enabled then
        spawn(function()
            while Settings["Auto Turn On Buso"] do
                pcall(function()
                    -- logic bật Buso (Haki) nếu chưa bật
                end)
                wait(1)
            end
        end)
    end
    SaveSettings("Auto Turn On Buso", enabled)
end)

-- Toggle: Auto Turn On Observation
SettingFarmMainSection:CreateToggle({
    Title   = "Auto Turn On Observation",
    Desc    = "",
    Default = Settings["Auto Turn On Observation"] or false,
}, function(enabled)
    if enabled then
        spawn(function()
            while Settings["Auto Turn On Observation"] do
                pcall(function()
                    local vim = game:GetService("VirtualInputManager")
                    local blurEnabled = game:GetService("Lighting"):FindFirstChild("Blur")
                        and game:GetService("Lighting").Blur.Enabled
                    if not blurEnabled then
                        vim:SendKeyEvent(true,  "E", false, game)
                        wait()
                        vim:SendKeyEvent(false, "E", false, game)
                        wait(3)
                    end
                end)
                wait()
            end
        end)
    end
    SaveSettings("Auto Turn On Observation", enabled)
end)

-- Toggle: Auto Turn On V4
SettingFarmMainSection:CreateToggle({
    Title   = "Auto Turn On V4",
    Desc    = "",
    Default = Settings["Auto Turn On V4"] or false,
}, function(enabled)
    if enabled then
        spawn(function()
            while Settings["Auto Turn On V4"] do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("RaceEnergy") then
                        local energy = char.RaceEnergy
                        if energy >= 1 then
                            local transformed = char:FindFirstChild("RaceTransformed")
                            if transformed and not transformed.Value then
                                LocalPlayer.Backpack.Awakening.RemoteFunction:InvokeServer(true)
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
    SaveSettings("Auto Turn On V4", enabled)
end)

-- Toggle: Auto Turn On V3
SettingFarmMainSection:CreateToggle({
    Title   = "Auto Turn On V3",
    Desc    = "",
    Default = Settings["Auto Turn On V3"] or false,
}, function(enabled)
    if enabled then
        spawn(function()
            while Settings["Auto Turn On V3"] do
                if task.wait(1) then
                    game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
                    wait(2)
                end
            end
        end)
    end
    SaveSettings("Auto Turn On V3", enabled)
end)

-- Toggle: Auto Dodge Skill Mobs
SettingFarmMainSection:CreateToggle({
    Title   = "Auto Dodge Skill Mobs",
    Desc    = "",
    Default = Settings["Auto Dodge Skill Mobs"] or false,
}, function(enabled)
    SaveSettings("Auto Dodge Skill Mobs", enabled)
end)

game:GetService("Workspace").Enemies.DescendantAdded:Connect(function(descendant)
    if not Settings["Auto Dodge Skill Mobs"] then return end
    if not descendant.Parent then return end
    if Doding then return end
    local name = descendant.Name
    if name == "BodyGyro" or name == "BodyPosition" or name == "KiBlastFireShort" then
        -- trigger dodge logic
    end
end)

-- Toggle: Teleport Y if low health
SettingFarmMainSection:CreateToggle({
    Title   = "Teleport Y if low health",
    Desc    = "",
    Default = Settings["Teleport Y"] or false,
}, function(enabled)
    SaveSettings("Teleport Y", enabled)
end)

-- Slider: % Health Player
SettingFarmMainSection:CreateSlider({
    Title   = "% Health Player",
    Min     = 0,
    Max     = 100,
    Default = Settings["% Health Player"] or 40,
    Precise = true,
}, function(value)
    SaveSettings("% Health Player", value)
end)

-- Slider: Distance Teleport Y
SettingFarmMainSection:CreateSlider({
    Title   = "Distance Teleport Y",
    Min     = 0,
    Max     = 10000,
    Default = Settings["Distance Teleport Y"] or 800,
    Precise = true,
}, function(value)
    SaveSettings("Distance Teleport Y", value)
end)

-- Toggle: Tween Safe if have Items
SettingFarmMainSection:CreateToggle({
    Title   = "Tween Safe if have Items",
    Desc    = "",
    Default = Settings["Tween Safe if have Items"] or false,
}, function(enabled)
    if enabled then
        spawn(function()
            while Settings["Tween Safe if have Items"] do
                pcall(function()
                    if CheckNameBoss("Darkbeard") then
                        if not Settings["Attack Darkbeard"] then
                            if DetectItemPlr("Fist of Darkness") or DetectItemPlr("God's Chalice") then
                                toTarget()
                            end
                        end
                    end
                end)
                wait(0.25)
            end
        end)
    end
    SaveSettings("Tween Safe if have Items", enabled)
end)

-- Slider: Time Hop Server
SettingFarmMainSection:CreateSlider({
    Title   = "Time Hop Server",
    Min     = 0,
    Max     = 60,
    Default = Settings["Time Hop Server"] or 10,
    Precise = true,
}, function(value)
    SaveSettings("Time Hop Server", value)
end)

-- Toggle: Use Portal Teleport
SettingFarmMainSection:CreateToggle({
    Title   = "Use Portal Teleport",
    Desc    = "",
    Default = Settings["Use Portal Teleport"] or false,
}, function(enabled)
    SaveSettings("Use Portal Teleport", enabled)
end)

-- Slider: Bring Mob Count
SettingFarmMainSection:CreateSlider({
    Title   = "Bring Mob Count",
    Min     = 2,
    Max     = 6,
    Default = Settings["Bring Mob Count"] or 2,
    Precise = true,
}, function(value)
    SaveSettings("Bring Mob Count", value)
end)

-- Toggle: Bring Mob
SettingFarmMainSection:CreateToggle({
    Title   = "Bring Mob",
    Desc    = "",
    Default = Settings["Bring Mob"] ~= nil and Settings["Bring Mob"] or true,
}, function(enabled)
    SaveSettings("Bring Mob", enabled)
end)

-- Toggle: Reset Teleport [Beta]
SettingFarmMainSection:CreateToggle({
    Title   = "Reset Teleport [ Beta ]",
    Desc    = "",
    Default = Settings["Reset Teleport"] or false,
}, function(enabled)
    SaveSettings("Reset Teleport", enabled)
end)

-- Slider: Speed Tween
SettingFarmMainSection:CreateSlider({
    Title   = "Speed Tween",
    Min     = 0,
    Max     = 1000,
    Default = Settings["Speed Tween "] or 300,
    Precise = true,
}, function(value)
    SaveSettings("Speed Tween ", value)
end)

SettingFarmMainSection:CreateLabel({
    Title = "Recommended: 350. If you're farming spots close to each other, use a higher speed"
})

-- ============================================================
-- UI – Setting Hold and Select Skill
-- ============================================================

local SettingSkillMain    = Main:CreatePage({ Page_Name = "Hold and Select Skill", Page_Title = "Setting Hold and Select Skill" })
local SelectSkillsSection = SettingSkillMain:CreateSection("Select Skills")
local HoldSkillsSection   = SettingSkillMain:CreateSection("Hold Skills")

--- Tạo dropdown multi-select cho từng nhóm skill
local function createSelectSkillDropdown(weaponType, skillList)
    local key      = "Select Skills " .. weaponType
    local defaults = {}
    for _, skillName in ipairs(skillList) do
        defaults[skillName] = false
    end
    EnsureAllTrueDefaults(key, skillList)

    local prepared = PrepareMultiSelectList(defaults, Settings[key], true)
    SelectSkillsSection:CreateDropdown({
        Title    = key,
        List     = prepared,
        Search   = true,
        Selected = true,
        Default  = Settings[key] or nil,
    }, function(selected, value)
        SaveSettings(key, selected, value)
    end)
end

-- Đăng ký dropdown cho từng loại vũ khí (danh sách skill lấy từ game)
createSelectSkillDropdown("Melee",      { "Z", "X", "C" })
createSelectSkillDropdown("Sword",      { "Z", "X" })
createSelectSkillDropdown("Gun",        { "Z", "X" })
createSelectSkillDropdown("Blox Fruit", { "Z", "X", "C", "V", "F" })

--- Tạo dropdown slider để set delay cho từng skill
local function createHoldSkillDropdown(weaponType, skillList)
    local items = {}
    for _, skillName in ipairs(skillList) do
        local settingKey = "Skill " .. skillName .. " " .. weaponType
        items[skillName] = {
            Title   = skillName,
            KeyName = skillName,
            Min     = 0,
            Max     = 5,
            Default = Settings[settingKey] or 0.5,
            Precise = true,
        }
    end

    HoldSkillsSection:CreateDropdown({
        Title  = "Set Delay " .. weaponType,
        List   = items,
        Slider = true,
    }, function(item)
        if item and item.KeyName then
            local key = "Skill " .. item.KeyName .. " " .. weaponType
            SaveSettings(key, item.Default)
        end
    end)
end

-- Toggle: Use skill fast dont hold
HoldSkillsSection:CreateToggle({
    Title   = "Use skill fast dont hold",
    Desc    = "",
    Default = Settings["Use skill fast dont hold"] or false,
}, function(enabled)
    SaveSettings("Use skill fast dont hold", enabled)
end)

createHoldSkillDropdown("Melee",      { "Z", "X", "C" })
createHoldSkillDropdown("Sword",      { "Z", "X" })
createHoldSkillDropdown("Gun",        { "Z", "X" })
createHoldSkillDropdown("Blox Fruit", { "Z", "X", "C", "V", "F" })

-- ============================================================
-- UI – Farming Page
-- ============================================================

local FarmMain              = Main:CreatePage({ Page_Name = "Farming", Page_Title = "Farming" })
local SettingAutoFarmSection = FarmMain:CreateSection("Setting Farm")

-- Dropdown: Select Method Farm
SettingAutoFarmSection:CreateDropdown({
    Title    = "Select Method Farm",
    List     = { "Level Farm", "Mastery Farm", "Boss Farm", "Raid Farm", "Sea Event" },
    Search   = false,
    Selected = false,
    Default  = Settings["Select Method Farm"] or nil,
}, function(value)
    SaveSettings("Select Method Farm", value)
end)

-- Slider: Distance Farm Aura
SettingAutoFarmSection:CreateSlider({
    Title   = "Distance Farm Aura",
    Min     = 0,
    Max     = 1000,
    Default = Settings["Distance Farm Aura"] or 300,
    Precise = true,
}, function(value)
    SaveSettings("Distance Farm Aura", value)
end)

-- Toggle: Ignore Attack Katakuri
SettingAutoFarmSection:CreateToggle({
    Title   = "Ignore Attack Katakuri",
    Desc    = "",
    Default = Settings["Ignore Attack Katakuri"] or false,
}, function(enabled)
    SaveSettings("Ignore Attack Katakuri", enabled)
end)

-- Toggle: Hop Find Katakuri
SettingAutoFarmSection:CreateToggle({
    Title   = "Hop Find Katakuri",
    Desc    = "",
    Default = Settings["Hop Find Katakuri"] or false,
}, function(enabled)
    SaveSettings("Hop Find Katakuri", enabled)
end)

-- Toggle: Auto Quest [Katakuri/Bone/Tyrant]
SettingAutoFarmSection:CreateToggle({
    Title   = "Auto Quest [Katakuri/Bone/Tyrant]",
    Desc    = "",
    Default = Settings["Auto Quest [Katakuri/Bone/Tyrant]"] or false,
}, function(enabled)
    SaveSettings("Auto Quest [Katakuri/Bone/Tyrant]", enabled)
end)

-- Toggle: Start Farm
SettingAutoFarmSection:CreateToggle({
    Title   = "Start Farm",
    Desc    = "",
    Default = Settings["Start Farm"] or false,
}, function(enabled)
    SaveSettings("Start Farm", enabled)
end)

-- ============================================================
-- UI – Mastery Farm
-- ============================================================

local MasteryFarmSection = FarmMain:CreateSection("Mastery Farm")

-- Dropdown: Select Method Farm Mastery
MasteryFarmSection:CreateDropdown({
    Title    = "Select Method Farm Mastery",
    List     = { "Blox Fruit", "Melee/Sword/Gun" },
    Search   = true,
    Selected = false,
    Default  = Settings["Select Method Farm Mastery"] or nil,
}, function(value)
    SaveSettings("Select Method Farm Mastery", value)
end)

-- Slider: Health %
MasteryFarmSection:CreateSlider({
    Title   = "Health %",
    Min     = 0,
    Max     = 100,
    Default = Settings["Health %"] or 40,
    Precise = true,
}, function(value)
    SaveSettings("Health %", value)
end)

-- ============================================================
-- END
-- ============================================================

return true
