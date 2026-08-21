--[[
    Banana Cat / Blox Fruits - Readable Rebuild
    Goal: readable, maintainable runtime reconstructed from the decompiled source.

    Important:
    - This file intentionally does NOT execute the decompiler's artificial root CFG.
    - Every subsystem is isolated so one failure does not stop the whole runtime.
    - Remote/API calls are guarded because Blox Fruits can change between updates.
]]

repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

-- ============================================================================
-- 1. SERVICES / STATE
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")

local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Net = Modules and require(Modules:WaitForChild("Net")) or nil
local CombatUtil = Modules and require(Modules:WaitForChild("CombatUtil")) or nil

local Runtime = {
    Version = "readable-rebuild-1.3-melee-fruit-fixes",
    StartedAt = os.clock(),
    CurrentAction = "Idle",
    CurrentTarget = nil,
    CurrentQuest = nil,
    LastError = {},
    LastErrorAt = {},
    Loops = {},
    Connections = {},
    FeatureStatus = {},
    Tween = nil,
    TweenTarget = nil,
    BoatTween = nil,
    BoatTweenTarget = nil,
    BoatMode = false,
    PriorityTask = nil,
    PriorityReason = nil,
    InventoryCache = nil,
    InventoryCacheAt = 0,
    Stopped = false,
}

getgenv().BananaRuntime = Runtime

local sendWebhook -- forward declaration for feature modules defined before webhook section

local Settings =
    rawget(getgenv(), "Configs")
    or rawget(getgenv(), "Config")
    or rawget(getgenv(), "Settings")
    or {}

getgenv().Configs = Settings
getgenv().Config = Settings
getgenv().Settings = Settings

local EXPLICIT_RANDOM_FRUIT = Settings["Random Devil Fruit"]
local EXPLICIT_GET_FRUITS = Settings["Get Fruits"]

local DEFAULTS = {
    ["Start Farm"] = false,
    ["Skip Level"] = false,
    ["Select Method Farm"] = "Level Farm",
    ["Select Weapon"] = "Melee",
    ["Speed Tween "] = 300,
    ["Bring Mob"] = true,
    ["Bring Mob Count"] = 2,
    ["Auto Turn On Buso"] = true,
    ["Auto Turn On Observation"] = false,
    ["Auto Turn On V3"] = false,
    ["Auto Turn On V4"] = false,
    ["Auto Store Fruit"] = false,
    ["Random Devil Fruit"] = true,
    ["Get Fruits"] = true,
    ["Auto Chest"] = false,
    ["Auto Chest Hop"] = false,
    ["Kill Boss"] = false,
    ["Kill All Boss"] = false,
    ["Auto Raid"] = false,
    ["Auto Multi Raid"] = false,
    ["Auto Sea Event"] = false,
    ["Auto Find Leviathan"] = false,
    ["Auto Attack Leviathan"] = false,
    ["Auto Saber"] = false,
    ["Auto Yama"] = false,
    ["Auto Tushita"] = false,
    ["Auto CDK"] = false,
    ["Auto Soul Guitar"] = false,
    ["Auto Craft Item Shark Anchor"] = false,
    ["Auto Upgrade Race V2-V3"] = false,
    ["Auto Get Cyborg"] = false,
    ["Auto Get Ghoul"] = false,
    ["Auto Pull Lever"] = false,
    ["Auto Trial"] = false,
    ["Auto Upgrade Race V2-V3 Draco"] = false,
    ["Auto Quest Dojo Trainer"] = false,
    ["Auto Quest Dragon Hunter"] = false,
    ["Auto Crafting Volcanic Magnet"] = false,
    ["Auto Find Prehistoric Island"] = false,
    ["Fully Event Prehistoric Island"] = false,
    ["Farm Material"] = false,
    ["Select Material"] = "",
    ["Auto Quest [Katakuri/Bone/Tyrant]"] = true,
    ["Ignore Attack Katakuri"] = false,
    ["Farm Mastery"] = false,
    ["Select Method Farm Mastery"] = "Blox Fruit",
    ["Health %"] = 40,
    ["Use skill fast dont hold"] = false,
    ["% Health Player"] = 40,
    ["Teleport Y"] = false,
    ["Distance Teleport Y"] = 800,
    ["Distance Farm Aura"] = 300,
    ["Auto rejoin Disconnect"] = false,
    ["Auto New World"] = false,
    ["Auto Third World"] = false,
    ["Auto Elite Hunter"] = false,
    ["Auto Pirate Raid"] = false,
    ["Auto Factory"] = false,
    ["Auto Get Rainbow Haki"] = false,
    ["Auto Touch Pad Haki"] = false,
    ["Auto UP Observation V2"] = false,
    ["Auto Collect Berry"] = false,
    ["Teleport To Fruit"] = false,
    ["Teleport To Fruit [ Hop Server ]"] = false,
    ["Auto Spawn Kitsune Island"] = false,
    ["Auto Find Mirage"] = false,
    ["Auto Fishing"] = false,
    ["Select Bait"] = "Basic Bait",
    ["Auto Tween To Event Fishing Spot"] = false,
    ["Auto Join Dungeon"] = false,
    ["Auto Attack Dungeon"] = false,
    ["Auto TTK"] = false,
    ["Auto Buy Legendary Sword"] = false,
    ["Auto Awake Fruit"] = false,
    ["Auto Buy Chip and Attack Law"] = false,
    ["Auto Yoru Mini"] = false,
    ["Auto Yoru Mini (Hop Server)"] = false,
    ["Auto Stats"] = false,
    ["Auto Collect Bone"] = false,
    ["Auto Trade Bone"] = false,
    ["Auto Trade Azure Ember"] = false,
    ["Auto Summon Rip Indra"] = false,
    ["Summon Darkbeard"] = false,
    ["Summon Soul Reaper"] = false,
    ["Attack Rip Indra"] = false,
    ["Attack Darkbeard"] = false,
    ["Attack Soul Reaper"] = false,
    ["Auto Buy Haki Color"] = false,
    ["Auto Upgrade Sword Inventory"] = false,
    ["Auto Upgrade Gun Inventory"] = false,
    ["Auto Farm Mastery 600 Melees"] = false,
    ["Auto Farm Mastery 600 Sword In Inventory"] = false,
    ["Fully Trial Draco"] = false,
    ["Auto Trial Draco"] = false,
    ["Auto Choose Gears"] = false,
    ["Auto Buy Gear"] = false,
    ["Auto Buy Gear Draco"] = false,
    ["Boost Fps"] = false,
    ["ESP Fruit"] = false,
    ["ESP Player"] = false,
    ["ESP Island"] = false,
    ["Debug Runtime"] = false,
    ["Auto Fully Fighting Style"] = false,
    ["Melee Mastery Target"] = 600, -- only used by explicit Auto Farm Mastery 600 Melees
    ["Auto Buy Basic Abilities"] = false,
    ["Auto Stats Melee Percent"] = 70,
    ["Auto Stats Defense Percent"] = 30,
    ["Sea Search Speed"] = 350,
    ["Sea Search Step"] = 6500,
    ["Boat Search Altitude"] = 160,
    ["Priority Tasks Preempt Farm"] = true,
}

for key, value in pairs(DEFAULTS) do
    if Settings[key] == nil then
        Settings[key] = value
    end
end

-- Accept the older Banana/Kaitun nested config shape without forcing users to
-- duplicate the same switch at top level.
do
    local oneclick = Settings["Oneclick"]
    if type(oneclick) == "table" then
        if oneclick["Auto Fully Fighting Style"] ~= nil and Settings["Auto Fully Fighting Style"] == false then
            Settings["Auto Fully Fighting Style"] = oneclick["Auto Fully Fighting Style"]
        end
        if oneclick["Saber"] ~= nil and Settings["Auto Saber"] == false then
            Settings["Auto Saber"] = oneclick["Saber"]
        end
        if oneclick["Skull Guitar"] ~= nil and Settings["Auto Soul Guitar"] == false then
            Settings["Auto Soul Guitar"] = oneclick["Skull Guitar"]
        end
        if oneclick["Cursed Dual Katana"] ~= nil and Settings["Auto CDK"] == false then
            Settings["Auto CDK"] = oneclick["Cursed Dual Katana"]
        end
        if oneclick["Get Ghoul"] ~= nil and Settings["Auto Get Ghoul"] == false then
            Settings["Auto Get Ghoul"] = oneclick["Get Ghoul"]
        end
    end

    -- Legacy kaitun compatibility: older configs expose fruit gacha as
    -- ["Get Fruits"]. Keep both names synchronized.
    if EXPLICIT_RANDOM_FRUIT ~= nil then
        Settings["Random Devil Fruit"] = EXPLICIT_RANDOM_FRUIT == true
        Settings["Get Fruits"] = Settings["Random Devil Fruit"]
    elseif EXPLICIT_GET_FRUITS ~= nil then
        Settings["Get Fruits"] = EXPLICIT_GET_FRUITS == true
        Settings["Random Devil Fruit"] = Settings["Get Fruits"]
    else
        Settings["Get Fruits"] = Settings["Random Devil Fruit"] == true
    end
end

-- ============================================================================
-- 2. GENERAL HELPERS
-- ============================================================================

local function setAction(action, target)
    Runtime.CurrentAction = action or "Idle"
    Runtime.CurrentTarget = target
end

local function logError(name, err)
    name = tostring(name or "Unknown")
    Runtime.LastError[name] = tostring(err)
    local now = os.clock()
    if now - (Runtime.LastErrorAt[name] or 0) >= 5 then
        Runtime.LastErrorAt[name] = now
        warn(("[BananaRebuild/%s] %s"):format(name, tostring(err)))
    end
end

local function safeCall(name, callback, ...)
    local args = table.pack(...)
    local handler = debug and debug.traceback or tostring
    local result = table.pack(xpcall(function()
        return callback(table.unpack(args, 1, args.n))
    end, handler))
    if not result[1] then
        logError(name, result[2])
        return false, result[2]
    end
    return true, table.unpack(result, 2, result.n)
end

-- Capability probes use this only when failure is expected and not actionable.
local function tryCall(callback, ...)
    local args = table.pack(...)
    local result = table.pack(pcall(function()
        return callback(table.unpack(args, 1, args.n))
    end))
    return table.unpack(result, 1, result.n)
end

local function safeInvoke(...)
    local args = table.pack(...)
    local route = tostring(args[1] or "CommF")
    local ok, result = safeCall("CommF:" .. route, function()
        return CommF:InvokeServer(table.unpack(args, 1, args.n))
    end)
    return ok and result or nil
end

local function safeRemoteInvoke(label, remote, ...)
    if not remote or type(remote.InvokeServer) ~= "function" then
        Runtime.FeatureStatus[label] = "remote unavailable"
        return nil
    end
    local args = table.pack(...)
    local ok, result = safeCall(label, function()
        return remote:InvokeServer(table.unpack(args, 1, args.n))
    end)
    return ok and result or nil
end

local function safeRemoteFire(label, remote, ...)
    if not remote or type(remote.FireServer) ~= "function" then
        Runtime.FeatureStatus[label] = "remote unavailable"
        return false
    end
    local args = table.pack(...)
    local ok = safeCall(label, function()
        remote:FireServer(table.unpack(args, 1, args.n))
    end)
    return ok
end

local function notify(text)
    print("[BananaRebuild] " .. tostring(text))
end

local function getCharacter()
    local character = LocalPlayer.Character
    if not character then
        return nil, nil, nil
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    return character, humanoid, root
end

local function isAlive(model)
    if not model or not model.Parent then
        return false
    end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")
    return humanoid ~= nil and root ~= nil and humanoid.Health > 0
end

local function cleanMobName(name)
    name = tostring(name or "")
    name = name:gsub(" %pLv%.? %d+%p", "")
    name = name:gsub(" %[Lv%.? %d+%]", "")
    return name
end

local function nameMatches(modelName, wanted)
    if type(wanted) == "table" then
        for _, value in pairs(wanted) do
            if modelName == value or cleanMobName(modelName) == cleanMobName(value) then
                return true
            end
        end
        return false
    end
    return modelName == wanted or cleanMobName(modelName) == cleanMobName(wanted)
end

function FFCMatch(instance, pattern)
    if not instance or not pattern then
        return nil
    end
    for _, child in ipairs(instance:GetChildren()) do
        if string.match(child.Name, pattern) then
            return child
        end
    end
    return nil
end

local function findDescendant(parent, name)
    return parent and parent:FindFirstChild(name, true) or nil
end

local function getSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1 end
    if placeId == 4442272183 then return 2 end
    if placeId == 7449423635 then return 3 end
    if placeId == 122478697296975 then return 4 end
    return 0
end

getgenv().Sea = getSea()

local function runLoop(name, interval, enabled, callback)
    if Runtime.Loops[name] then
        return
    end
    Runtime.Loops[name] = task.spawn(function()
        while not Runtime.Stopped do
            task.wait(interval or 0.1)
            local shouldRun = false
            local enabledOk, enabledValue = safeCall(name .. ".Enabled", enabled)
            if enabledOk then
                shouldRun = enabledValue == true
            end
            if shouldRun then
                local success = safeCall(name, callback)
                if not success then
                    task.wait(0.5)
                end
            end
        end
    end)
end

local function fireConnections(signal)
    if not signal or not getconnections then
        return false
    end
    local fired = false
    for _, connection in ipairs(getconnections(signal)) do
        tryCall(function()
            if connection.Function then
                connection.Function()
            elseif connection.Fire then
                connection:Fire()
            end
        end)
        fired = true
    end
    return fired
end

-- ============================================================================
-- 3. TEAM / CHARACTER / HAKI
-- ============================================================================

local function selectPirates()
    if LocalPlayer.Team then
        return true
    end
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local main = playerGui and (playerGui:FindFirstChild("Main") or playerGui:FindFirstChild("Main (minimal)"))
    local choose = main and main:FindFirstChild("ChooseTeam")
    if not choose or not choose.Visible then
        return LocalPlayer.Team ~= nil
    end

    local pirates = choose:FindFirstChild("Pirates", true)
    local button = pirates and pirates:FindFirstChildWhichIsA("GuiButton", true)
    if button then
        if not fireConnections(button.Activated) then
            safeCall("TeamSelect.Activate", function() button:Activate() end)
        end
    end
    return LocalPlayer.Team ~= nil
end

task.spawn(function()
    local timeoutAt = os.clock() + 20
    while not LocalPlayer.Team and os.clock() < timeoutAt do
        safeCall("TeamSelect", selectPirates)
        task.wait(0.5)
    end
end)

LocalPlayer.Idled:Connect(function()
    safeCall("AntiIdle", function()
        VirtualUser:Button2Down(Vector2.zero, Workspace.CurrentCamera.CFrame)
        task.wait(0.5)
        VirtualUser:Button2Up(Vector2.zero, Workspace.CurrentCamera.CFrame)
    end)
end)

local function turnOnBuso()
    local character = LocalPlayer.Character
    if not character then return end
    if character:FindFirstChild("HasBuso") or FFCMatch(character, "_BusoLayer") then
        return
    end
    safeInvoke("Buso")
end

local function turnOnObservation()
    -- Source-proven behavior: Banana checks Lighting.Blur.Enabled before
    -- pressing E. Pressing E blindly every interval toggles Observation back
    -- off, so never send the key while the observation blur is already active.
    local blur = game:GetService("Lighting"):FindFirstChild("Blur")
    if blur and blur.Enabled then
        Runtime.FeatureStatus.Observation = "Active"
        return true
    end
    local ok = safeCall("Observation", function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
    if ok then Runtime.FeatureStatus.Observation = "Activation requested" end
    return ok
end

local function turnOnRaceV3()
    -- Source-proven route from the decompile: Remotes.CommE("ActivateAbility").
    local commE = Remotes:FindFirstChild("CommE")
    if commE and commE:IsA("RemoteEvent") then
        return safeRemoteFire("RaceV3.ActivateAbility", commE, "ActivateAbility")
    end
    Runtime.FeatureStatus.RaceV3 = "CommE unavailable"
    return false
end

local function turnOnRaceV4()
    local character = LocalPlayer.Character
    if not character then return end
    local energy = character:FindFirstChild("RaceEnergy")
    local transformed = character:FindFirstChild("RaceTransformed")
    if not energy or not transformed or transformed.Value then
        return
    end
    if energy.Value < 1 then
        return
    end
    local awakening =
        character:FindFirstChild("Awakening")
        or LocalPlayer.Backpack:FindFirstChild("Awakening")
    local remote = awakening and awakening:FindFirstChild("RemoteFunction")
    if remote then
        safeRemoteInvoke("RaceV4.Awakening", remote, true)
    end
end

runLoop("Buso", 1.0, function()
    return Settings["Auto Turn On Buso"] == true
end, turnOnBuso)

runLoop("Observation", 3.0, function()
    return Settings["Auto Turn On Observation"] == true
end, turnOnObservation)

runLoop("RaceV3", 1.0, function()
    return Settings["Auto Turn On V3"] == true
end, turnOnRaceV3)

runLoop("RaceV4", 0.5, function()
    return Settings["Auto Turn On V4"] == true
end, turnOnRaceV4)

-- ============================================================================
-- 4. MOVEMENT / NOCLIP
-- ============================================================================

local IslandPositions = {
    Sea1 = {
        ["Colosseum"] = Vector3.new(-2143.41333, 152.074326, -3025.54614),
        ["Desert"] = Vector3.new(1330.68298, 103.55368, 4489.30615),
        ["Jungle"] = Vector3.new(-1340.21948, 136.020538, -101.374214),
        ["Marine Fortress"] = Vector3.new(-5180.23828, 281.343445, 4383.03174),
        ["Middle Town"] = Vector3.new(-703.16748, 9.55188751, 1575.1864),
        ["Pirate Village"] = Vector3.new(-807.662109, 27.8020515, 4119.30127),
        ["Prison"] = Vector3.new(5270.56934, 163.508469, 844.72821),
        ["Sky"] = Vector3.new(-4808.76904, 721.326355, -2668.81787),
        ["Snow"] = Vector3.new(1394.46399, 39.0448875, -1321.63904),
        ["Starter Island"] = Vector3.new(1038.29968, 112.1365051, 1287.83447),
        ["Starter Marine"] = Vector3.new(-3096.51929, 231.443558, 2087.51929),
        ["Underwater"] = Vector3.new(61147.9766, 20.5708408, 1366.09839),
        ["Upper Sky"] = Vector3.new(-7950.03662, 5815.68457, -1968.3374),
        ["Volcano"] = Vector3.new(-5513.97852, 64.4943161, 8577.40039),
    },
    Sea2 = {
        ["Cafe"] = Vector3.new(-382, 74, 356),
        ["Colosseum"] = Vector3.new(-1836, 46, 1642),
        ["Dark Arena"] = Vector3.new(3948, 13, -3479),
        ["Docks 1"] = Vector3.new(-923, 8, 1810),
        ["Docks 2"] = Vector3.new(-13, 39, 2708),
        ["Docks 3"] = Vector3.new(-1944, 9, -2594),
        ["Docks 4"] = Vector3.new(-5798, 1, -5021),
        ["Doghouse"] = Vector3.new(-1984, 125, -82),
        ["Graveyard"] = Vector3.new(-5710, 126, -775),
        ["Haunted Ship"] = Vector3.new(937, 125, 32879),
        ["Lab"] = Vector3.new(-5542, 335, -5924),
        ["Lava"] = Vector3.new(-5280, 7, -5618),
        ["Mansion"] = Vector3.new(-494, 339, 593),
        ["Raid"] = Vector3.new(-6503, 251, -4495),
        ["Remote"] = Vector3.new(4766, 8, 2911),
        ["Skull"] = Vector3.new(-2956.24341, 123.399323, -9981.06934),
        ["Snow"] = Vector3.new(1210, 429, -4663),
        ["Winter Castle"] = Vector3.new(5544.71777, 60.1393852, -6359.08887),
    },
    Sea3 = {
        ["Cake Land"] = Vector3.new(-2098.970458984375, 76.39494323730469, -12128.359375),
        ["Chocolate Land"] = Vector3.new(379.1396179199219, 130.20599365234375, -12720.83984375),
        ["Great Tree"] = Vector3.new(4345.09375, 575.0524291992188, -6159.00439453125),
        ["Haunted Castle"] = Vector3.new(-9515.0009765625, 149.18876647949, 5534.0502929688),
        ["Hydra Arena"] = Vector3.new(5020.94580078125, 174.08645629882812, -2011.18505859375),
        ["Hydra Town"] = Vector3.new(5661.53, 1013.41, -334.96),
        ["Ice Cream Land"] = Vector3.new(-917.54852294922, 63.364143371582, -10858.696289062),
        ["Peanut Land"] = Vector3.new(-2037.8001708984, 13.651118278503, -9948.2021484375),
        ["Port"] = Vector3.new(-342.4343566894531, 23.8315486907959, 5547.345703125),
        ["Sea Castle"] = Vector3.new(-5502.1787109375, 323.6708984375, -2863.4616699219),
        ["Tiki Outpost"] = Vector3.new(-16456.4629, 530.251953, 436.231812),
        ["Turtle Center"] = Vector3.new(-12007.979492188, 339.15548706055, -9178.580078125),
        ["Turtle Entrance"] = Vector3.new(-10163.96484375, 340.29028320313, -8320.767578125),
        ["Turtle Mansion"] = Vector3.new(-12538.421875, 339.39358520508, -7817.0708007813),
        ["Turtle Mountain"] = Vector3.new(-12856.61328125, 852.75360107422, -10715.23046875),
    },
}

local function cancelTween()
    if Runtime.Tween then
        tryCall(function() Runtime.Tween:Cancel() end)
        tryCall(function() Runtime.Tween:Destroy() end)
    end
    Runtime.Tween = nil
    Runtime.TweenTarget = nil
    getgenv().Tween = nil
end

local function ensureFloatForce(root)
    local bodyVelocity = root:FindFirstChild("FloatForce")
    if bodyVelocity then
        return bodyVelocity
    end
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FloatForce"
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = root
    return bodyVelocity
end

function toTarget(targetCFrame, instant)
    if typeof(targetCFrame) == "Vector3" then
        targetCFrame = CFrame.new(targetCFrame)
    end
    if typeof(targetCFrame) ~= "CFrame" then
        return nil
    end

    local character, humanoid, root = getCharacter()
    if not character or not humanoid or not root or humanoid.Health <= 0 then
        return nil
    end

    if humanoid.Sit then
        humanoid.Sit = false
        humanoid.Jump = true
        task.wait()
    end

    local distance = (root.Position - targetCFrame.Position).Magnitude
    if instant == true or distance <= 8 then
        cancelTween()
        root.CFrame = targetCFrame
        return nil
    end

    cancelTween()
    ensureFloatForce(root)

    local speed = tonumber(Settings["Speed Tween "]) or tonumber(Settings["Speed Tween"]) or 300
    speed = math.max(speed, 1)
    local duration = math.max(distance / speed, 0.05)

    local tween = TweenService:Create(
        root,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        {CFrame = targetCFrame}
    )
    Runtime.Tween = tween
    Runtime.TweenTarget = targetCFrame
    getgenv().Tween = tween

    tween.Completed:Connect(function()
        if Runtime.Tween == tween then
            Runtime.Tween = nil
            Runtime.TweenTarget = nil
            getgenv().Tween = nil
        end
    end)
    tween:Play()
    return tween
end

local function setCharacterNoclip(enabled)
    local character = LocalPlayer.Character
    if not character then return end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = not enabled
        end
    end
end

RunService.Stepped:Connect(function()
    local active =
        Runtime.Tween ~= nil
        or Settings["Noclip"] == true
        or Settings["Start Farm"] == true
        or Settings["Auto Raid"] == true
        or Settings["Auto Sea Event"] == true
        or Settings["Auto Attack Leviathan"] == true
        or Settings["Fully Event Prehistoric Island"] == true

    if active then
        safeCall("Noclip", setCharacterNoclip, true)
    end
end)

-- ============================================================================
-- 5. WEAPONS / COMBAT
-- ============================================================================

function NameWeapon(toolType)
    local character = LocalPlayer.Character
    local containers = {LocalPlayer:FindFirstChild("Backpack"), character}

    -- A melee unlock task may temporarily request one exact style. Otherwise
    -- keep the melee that is already equipped; newly purchased styles stay in
    -- Backpack until a later unlock actually needs their mastery.
    if toolType == "Melee" then
        local preferred = Settings["Preferred Melee"]
        if type(preferred) == "string" and preferred ~= "" then
            for _, container in ipairs(containers) do
                local tool = container and container:FindFirstChild(preferred)
                if tool and tool:IsA("Tool") then
                    return preferred
                end
            end
        end

        if character then
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                    return tool.Name
                end
            end
        end
    end

    for _, container in ipairs(containers) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    if tool.ToolTip == toolType then
                        return tool.Name
                    end
                    if tool:GetAttribute("WeaponType") == toolType then
                        return tool.Name
                    end
                end
            end
        end
    end
    return nil
end

function equiptool(toolName)
    if not toolName then
        return nil
    end
    local character, humanoid = getCharacter()
    if not character or not humanoid or humanoid.Health <= 0 or humanoid.Sit then
        return nil
    end
    local tool = character:FindFirstChild(toolName) or LocalPlayer.Backpack:FindFirstChild(toolName)
    if tool and tool:IsA("Tool") and tool.Parent ~= character then
        humanoid:EquipTool(tool)
    end
    return tool
end

function UsedualFlock()
    local weaponType = Settings["Select Weapon"] or "Melee"
    return equiptool(NameWeapon(weaponType))
end

local RegisterAttack = nil
local RegisterHit = nil
local CombatRemoteThreadKnown = false
local CombatRemoteThread = false
local LastCombatAttack = 0

do
    local flagsModule = Modules and Modules:FindFirstChild("Flags")
    if flagsModule then
        local ok, flags = safeCall("Combat.Flags", require, flagsModule)
        if ok and type(flags) == "table" then
            CombatRemoteThreadKnown = true
            CombatRemoteThread = flags.COMBAT_REMOTE_THREAD == true
        end
    end
end

local function equippedAttackCooldown()
    local character = LocalPlayer.Character
    local tool = character and character:FindFirstChildOfClass("Tool")
    local cooldown = tool and tool:FindFirstChild("Cooldown")
    local value = cooldown and tonumber(cooldown.Value) or 0.3
    -- Keep a sane floor/ceiling. Current public combat code uses the equipped
    -- tool Cooldown value rather than FireServer(0).
    return math.clamp(value, 0.08, 1.5)
end

-- Current Blox Fruits Net API resolves these by logical name, not by forcing
-- the internal "RE/" path. The second boolean argument used by the earlier
-- reconstruction caused Modules.Net to throw "Failed to find RemoteEvent".
if Net then
    local okAttack, attackRemote = tryCall(function()
        return Net:RemoteEvent("RegisterAttack")
    end)
    if okAttack then RegisterAttack = attackRemote end

    local okHit, hitRemote = tryCall(function()
        return Net:RemoteEvent("RegisterHit")
    end)
    if okHit then RegisterHit = hitRemote end
end

-- Conservative instance fallback for executors/versions where Net cannot be
-- required correctly. Do not create remotes; only bind ones that already exist.
local NetModuleScript = Modules and Modules:FindFirstChild("Net")
if not RegisterAttack and NetModuleScript then
    RegisterAttack = NetModuleScript:FindFirstChild("RE/RegisterAttack")
end
if not RegisterHit and NetModuleScript then
    RegisterHit = NetModuleScript:FindFirstChild("RE/RegisterHit")
end

local ValidHitPart = {
    RightUpperArm = true,
    RightLowerArm = true,
    RightHand = true,
    RightUpperLeg = true,
    RightLowerLeg = true,
    RightFoot = true,
    LeftUpperArm = true,
    LeftLowerArm = true,
    LeftHand = true,
    LeftUpperLeg = true,
    LeftLowerLeg = true,
    LeftFoot = true,
    UpperTorso = true,
    LowerTorso = true,
    Head = true,
    HumanoidRootPart = true,
    ModelHitbox = true,
}

local function chooseHitPart(model)
    if not model then return nil end
    for _, name in ipairs({
        "HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "ModelHitbox"
    }) do
        local part = model:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

function AttackAOE(radius, includePlayers)
    radius = tonumber(radius) or 80
    local character, humanoid, root = getCharacter()
    if not character or not humanoid or not root or humanoid.Health <= 0 then
        return nil
    end

    local results = {}
    local seen = {}

    local function scan(folder)
        if not folder then return end
        for _, model in ipairs(folder:GetChildren()) do
            if model ~= character and not seen[model] and isAlive(model) then
                local targetRoot = model:FindFirstChild("HumanoidRootPart")
                if targetRoot and (targetRoot.Position - root.Position).Magnitude <= radius then
                    local hitPart = chooseHitPart(model)
                    if hitPart and ValidHitPart[hitPart.Name] then
                        if not CombatUtil or CombatUtil:IsVulnerable(model) ~= false then
                            seen[model] = true
                            results[#results + 1] = {model, hitPart}
                        end
                    end
                end
            end
        end
    end

    scan(Workspace:FindFirstChild("Enemies"))
    if includePlayers then
        scan(Workspace:FindFirstChild("Characters"))
    end
    return #results > 0 and results or nil
end

function AttackFunction(radius, includePlayers)
    local hits = AttackAOE(radius, includePlayers)
    if not hits then
        return false
    end

    local cooldown = equippedAttackCooldown()
    local now = tick()
    if (now - LastCombatAttack) < cooldown then
        return true
    end
    LastCombatAttack = now

    -- Newer Blox Fruits builds can route combat through a client combat thread.
    -- In that mode, forcing RE/RegisterHit directly can produce malformed client
    -- projectile/effect payloads. Use normal Tool activation unless the current
    -- Flags module explicitly permits the direct remote path.
    if CombatRemoteThreadKnown and CombatRemoteThread then
        local character = LocalPlayer.Character
        local tool = character and character:FindFirstChildOfClass("Tool")
        if tool then
            safeCall("Combat.ThreadedToolActivate", function() tool:Activate() end)
            return true
        end
        return false
    end

    if RegisterAttack and RegisterHit then
        local primaryPart = hits[1] and hits[1][2]
        if primaryPart and primaryPart.Parent then
            local ok = safeCall("Combat.RegisterHit", function()
                RegisterAttack:FireServer(cooldown)
                RegisterHit:FireServer(primaryPart, hits)
            end)
            if ok then return true end
        end
    end

    local character = LocalPlayer.Character
    local tool = character and character:FindFirstChildOfClass("Tool")
    if tool then
        safeCall("Combat.ToolActivate", function() tool:Activate() end)
        return true
    end
    return false
end

local function useFruitM1(target)
    if not target or not isAlive(target) then
        return false
    end
    local character = LocalPlayer.Character
    local fruitName = NameWeapon("Blox Fruit")
    local fruit = fruitName and character and character:FindFirstChild(fruitName)
    if not fruit and fruitName then
        fruit = LocalPlayer.Backpack:FindFirstChild(fruitName)
        if fruit then equiptool(fruitName) end
    end
    fruit = fruitName and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(fruitName)
    if not fruit then return false end

    local aimPart = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
    if not aimPart then return false end

    local clickRemote = fruit:FindFirstChild("LeftClickRemote")
    if clickRemote then
        safeRemoteFire("FruitM1.LeftClick", clickRemote, aimPart.Position)
        return true
    end

    local remoteEvent = fruit:FindFirstChild("RemoteEvent")
    local remoteFunction = fruit:FindFirstChild("RemoteFunction")
    if remoteEvent then
        safeRemoteFire("FruitM1.RemoteEvent", remoteEvent, aimPart.Position)
    end
    if remoteFunction then
        safeRemoteInvoke("FruitM1.RemoteFunction", remoteFunction, "TAP")
        return true
    end
    return false
end

function ClickM1(target, wide)
    if not target or not isAlive(target) then
        return false
    end
    if Settings["Select Weapon"] == "Blox Fruit" then
        return useFruitM1(target)
    end
    return AttackFunction(wide and 80 or 40, false)
end

function IsMobAlive(model)
    return isAlive(model)
end

function sizepart(mob)
    if not mob then return end
    local root = mob:FindFirstChild("HumanoidRootPart")
    local humanoid = mob:FindFirstChildOfClass("Humanoid")
    if root then
        root.CanCollide = false
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    if humanoid then
        humanoid.AutoRotate = false
    end
end

-- ============================================================================
-- 6. MOB DETECTION / BRING
-- ============================================================================

function DetectMob(nameOrNames)
    local _, _, playerRoot = getCharacter()
    if not playerRoot then return nil end

    local nearest, nearestDistance = nil, math.huge
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end

    for _, mob in ipairs(enemies:GetChildren()) do
        if isAlive(mob) and nameMatches(mob.Name, nameOrNames) then
            local root = mob:FindFirstChild("HumanoidRootPart")
            local distance = (root.Position - playerRoot.Position).Magnitude
            if distance < nearestDistance then
                nearest = mob
                nearestDistance = distance
            end
        end
    end
    return nearest
end

function CheckNameBoss(nameOrNames)
    local containers = {
        Workspace:FindFirstChild("Enemies"),
        ReplicatedStorage,
    }
    for _, container in ipairs(containers) do
        if container then
            for _, model in ipairs(container:GetChildren()) do
                if nameMatches(model.Name, nameOrNames) and isAlive(model) then
                    return model
                end
            end
        end
    end
    return nil
end

local function canOwnPart(part)
    if not part then return false end
    if isnetworkowner then
        local ok, owned = tryCall(isnetworkowner, part)
        if ok then return owned end
    end
    return true
end

function BringMob(targetMob)
    if Settings["Bring Mob"] ~= true or not targetMob or not isAlive(targetMob) then
        return false, 0
    end

    local targetRoot = targetMob:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false, 0 end
    local targetPos = targetRoot.Position
    if targetPos.X ~= targetPos.X or targetPos.Y ~= targetPos.Y or targetPos.Z ~= targetPos.Z
        or math.abs(targetPos.Y) >= 45000
    then
        Runtime.FeatureStatus.Bring = "Rejected invalid/high-Y target"
        return false, 0
    end

    tryCall(function()
        if sethiddenproperty then
            sethiddenproperty(LocalPlayer, "SimulationRadius", 5000)
        end
    end)

    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return false, 0 end

    local wantedName = cleanMobName(targetMob.Name)
    local candidates = {}
    for _, mob in ipairs(enemies:GetChildren()) do
        if isAlive(mob) and cleanMobName(mob.Name) == wantedName then
            local root = mob:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position
                if pos.X == pos.X and pos.Y == pos.Y and pos.Z == pos.Z
                    and math.abs(pos.Y) < 45000
                    and (pos - targetRoot.Position).Magnitude <= 350
                then
                    candidates[#candidates + 1] = mob
                end
            end
        end
    end

    -- Rebuild interpretation of the damaged count branch: cap the size of the
    -- cluster requested per bring pass. The original dump preserves the 2..6
    -- setting but not the complete branch that consumed values above 2.
    local bringCount = math.clamp(tonumber(Settings["Bring Mob Count"]) or 2, 2, 6)
    table.sort(candidates, function(a, b)
        local ar = a:FindFirstChild("HumanoidRootPart")
        local br = b:FindFirstChild("HumanoidRootPart")
        local ad = ar and (ar.Position - targetRoot.Position).Magnitude or math.huge
        local bd = br and (br.Position - targetRoot.Position).Magnitude or math.huge
        return ad < bd
    end)

    local moved = 0
    for _, mob in ipairs(candidates) do
        if moved >= bringCount then break end
        local root = mob:FindFirstChild("HumanoidRootPart")
        local humanoid = mob:FindFirstChildOfClass("Humanoid")
        if root and humanoid and canOwnPart(root) then
            sizepart(mob)
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            root.CFrame = targetRoot.CFrame
            moved += 1
        end
    end

    getgenv().DaBringMob = moved >= 2
    return getgenv().DaBringMob, moved
end

-- ============================================================================
-- 7. INVENTORY / FRUIT
-- ============================================================================

local function readInventory(force)
    local now = os.clock()
    if not force and type(Runtime.InventoryCache) == "table" and now - Runtime.InventoryCacheAt < 1 then
        return Runtime.InventoryCache
    end

    local result = {}
    local inventory = safeInvoke("getInventory")
    if type(inventory) == "table" then
        for _, item in pairs(inventory) do
            if type(item) == "table" then
                result[#result + 1] = item
            end
        end
        Runtime.InventoryCache = result
        Runtime.InventoryCacheAt = now
    elseif type(Runtime.InventoryCache) == "table" then
        return Runtime.InventoryCache
    end
    return result
end

function CheckItemInventory(itemName)
    for _, item in ipairs(readInventory()) do
        if item.Name == itemName or item.name == itemName then
            return item
        end
    end

    local character = LocalPlayer.Character
    return LocalPlayer.Backpack:FindFirstChild(itemName)
        or (character and character:FindFirstChild(itemName))
end

function CheckCountItem(itemName, needed)
    needed = tonumber(needed) or 1
    for _, item in ipairs(readInventory()) do
        local name = item.Name or item.name
        if name == itemName then
            local count = tonumber(item.Count or item.count or 1) or 1
            return count >= needed, count
        end
    end
    return false, 0
end

function DetectItemPlr(itemName)
    local character = LocalPlayer.Character
    return (character and character:FindFirstChild(itemName))
        or LocalPlayer.Backpack:FindFirstChild(itemName)
end

function GetPathFruit()
    for _, object in ipairs(Workspace:GetChildren()) do
        if object:IsA("Tool") and object.Name:find("Fruit") then
            return object
        end
    end
    return nil
end

local BannerClient = nil
local function getFruitGachaBoxName()
    if BannerClient == nil then
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        local module = controllers and controllers:FindFirstChild("BannerClient")
        if module then
            local ok, loaded = tryCall(require, module)
            if ok then BannerClient = loaded end
        end
    end

    if BannerClient and type(BannerClient.TryGetBannerItemIfActiveAsync) == "function" then
        local ok, item = tryCall(BannerClient.TryGetBannerItemIfActiveAsync)
        if ok and type(item) == "table" then
            if item.BoxName then return item.BoxName, item end
            return "DLCBoxData", nil
        end
    end
    return "DLCBoxData", nil
end

function RandomFruit()
    -- Economy arbitration callback is installed by the melee subsystem later in
    -- the file. It keeps a ready melee purchase from losing its Beli to gacha.
    if Settings["Auto Fully Fighting Style"] == true and Runtime.ShouldReserveForMelee then
        local ready, styleName, cost = Runtime.ShouldReserveForMelee()
        if ready then
            Runtime.FeatureStatus.RandomFruit = ("Waiting for melee: %s (%d Beli)"):format(styleName, cost)
            return false
        end
    end

    local boxName = getFruitGachaBoxName()

    -- Reconstructed from the current Banana dump:
    -- Cousin(Check, box) -> money, level, price; require Lv50 and enough money;
    -- Cousin(CheckTime, box) must be true; Cousin(box) performs the roll.
    local ok, money, level, price = safeCall("FruitGacha.Check", function()
        return CommF:InvokeServer("Cousin", "Check", boxName)
    end)
    if not ok then return false end

    money = tonumber(money) or 0
    level = tonumber(level) or 0
    price = tonumber(price) or math.huge
    Runtime.FeatureStatus.RandomFruit = ("Lv=%d Money=%d Price=%s"):format(level, money, tostring(price))

    if level < 50 or money < price then
        return false
    end

    local available = safeInvoke("Cousin", "CheckTime", boxName)
    if available ~= true then
        Runtime.FeatureStatus.RandomFruit = "Cooldown"
        return false
    end

    local rollCode, fruitData
    local rollOk = safeCall("FruitGacha.Roll", function()
        rollCode, fruitData = CommF:InvokeServer("Cousin", boxName)
    end)
    if not rollOk then return false end

    if rollCode == 1 then
        Runtime.InventoryCacheAt = 0
        Runtime.FeatureStatus.RandomFruit = "Rolled"
        return true, fruitData
    end

    Runtime.FeatureStatus.RandomFruit = "Roll rejected: " .. tostring(rollCode)
    return false
end

function StoreFruit()
    local stored = 0
    local function scan(container)
        if not container then return end
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:find("Fruit") and not tool:FindFirstChild("Ignored") then
                local baseName = tool.Name:gsub(" Fruit", "")
                local originalName = tool:GetAttribute("OriginalName") or (baseName .. "-" .. baseName)
                local ok = safeCall("StoreFruit:" .. tool.Name, function()
                    CommF:InvokeServer("StoreFruit", originalName, tool)
                end)
                if ok then
                    local ignored = Instance.new("IntValue")
                    ignored.Name = "Ignored"
                    ignored.Parent = tool
                    stored += 1
                    Runtime.InventoryCacheAt = 0
                    task.wait(0.5)
                end
            end
        end
    end
    scan(LocalPlayer.Character)
    scan(LocalPlayer.Backpack)
    return stored
end


-- ============================================================================
-- 8. QUEST SYSTEM / LEVEL FARM
-- ============================================================================

local QuestDefinitions = require(ReplicatedStorage:WaitForChild("Quests"))
local GuideModule = require(ReplicatedStorage:WaitForChild("GuideModule"))

local UselessQuests = {
    BartiloQuest = true,
    Trainees = true,
    MarineQuest = true,
    CitizenQuest = true,
}

local function bestQuestForLevel(level)
    local best = nil
    local bestLevel = -math.huge

    for questName, variants in pairs(QuestDefinitions) do
        if not UselessQuests[questName] then
            for questId, questData in pairs(variants) do
                local required = tonumber(questData.LevelReq) or 0
                if required <= level and required >= bestLevel then
                    for mobName, amount in pairs(questData.Task or {}) do
                        if (tonumber(amount) or 0) > 1 then
                            bestLevel = required
                            best = {
                                Name = mobName,
                                NameQuest = questName,
                                ID = questId,
                                Level = required,
                                Pos = questData.Position,
                            }
                        end
                    end
                end
            end
        end
    end
    return best
end

function GetNameDoubleQuest()
    local questData = GuideModule.Data and GuideModule.Data.QuestData
    if not questData or type(questData.Task) ~= "table" then
        return nil
    end
    for taskName in pairs(questData.Task) do
        return taskName
    end
    return nil
end


function DoubleQuest()
    local quest = bestQuestForLevel(LocalPlayer.Data.Level.Value) or {}
    local activeMob = GetNameDoubleQuest()
    if activeMob and Settings["Double Quest"] then
        quest.Name = activeMob
    end
    getgenv().NameMobQuest = quest.Name or ""
    getgenv().NameQuest = quest.NameQuest or ""
    getgenv().IDQuest = quest.ID or 0
    return quest
end

function CFrameQuest()
    local levelToQuest = {}
    local questPoints = {}

    for questName, variants in pairs(QuestDefinitions) do
        if questName ~= "MarineQuest" then
            for _, questData in pairs(variants) do
                levelToQuest[questData.LevelReq] = questName
            end
        end
    end

    local npcList = GuideModule.Data and GuideModule.Data.NPCList
    if type(npcList) == "table" then
        for npc, data in pairs(npcList) do
            local parentName = typeof(npc) == "Instance" and npc.Parent and npc.Parent.Name or ""
            if parentName ~= "Marine Leader" then
                for _, level in pairs(data.Levels or {}) do
                    local questName = levelToQuest[level] or data.InternalQuestName
                    if questName and not questPoints[questName] and data.Position then
                        local position = data.Position
                        questPoints[questName] = typeof(position) == "CFrame" and position or CFrame.new(position)
                    end
                end
            end
        end
    end

    questPoints.SkyExp1Quest = CFrame.new(-7857.28516, 5544.34033, -382.321503)
    getgenv().questpoint = questPoints
    return questPoints
end

CFrameQuest()

local function questVisible()
    local main = LocalPlayer.PlayerGui:FindFirstChild("Main")
    local quest = main and main:FindFirstChild("Quest")
    return quest and quest.Visible or false
end

local function currentQuestTitle()
    local main = LocalPlayer.PlayerGui:FindFirstChild("Main")
    local quest = main and main:FindFirstChild("Quest")
    local title = quest and quest:FindFirstChild("QuestTitle", true)
    return title and title.Text or ""
end

local function acceptQuest(quest)
    if not quest or not quest.NameQuest then return false end
    local point = getgenv().questpoint and getgenv().questpoint[quest.NameQuest]
    local _, humanoid, root = getCharacter()
    if not root or not humanoid then return false end

    if not point then
        CFrameQuest()
        point = getgenv().questpoint and getgenv().questpoint[quest.NameQuest]
    end
    if not point then return false end

    if (root.Position - point.Position).Magnitude > 8 then
        toTarget(point * CFrame.new(0, 4, 2))
        return false
    end

    if humanoid.Health > 0 then
        safeInvoke("StartQuest", tostring(quest.NameQuest), quest.ID)
        task.wait(0.5)
        return true
    end
    return false
end

function TakeQuestLevel()
    local quest = bestQuestForLevel(LocalPlayer.Data.Level.Value)
    if not quest then return false end
    return acceptQuest(quest)
end

function QuestBoneAndkatakuri(questName, questId)
    local quest = {
        NameQuest = questName,
        ID = questId,
    }
    return acceptQuest(quest)
end

local MaterialTargets = {
    ["Magma Ore"] = {
        [2753915549] = {"Military Soldier", "Military Spy"},
        [4442272183] = {"Magma Ninja", "Lava Pirate"},
    },
    ["Dragon Scale"] = {[7449423635] = {"Dragon Crew Warrior", "Dragon Crew Archer"}},
    ["Fish Tail"] = {
        [2753915549] = {"Fishman Warrior", "Fishman Commando"},
        [7449423635] = {"Fishman Raider", "Fishman Captain"},
    },
    ["Mystic Droplet"] = {[4442272183] = {"Water Fighter", "Sea Soldier"}},
    ["Scrap Metal"] = {
        [2753915549] = {"Pirate", "Brute"},
        [4442272183] = {"Mercenary", "Swan Pirate"},
        [7449423635] = {"Jungle Pirate", "Forest Pirate"},
    },
    ["Leather"] = {
        [2753915549] = {"Pirate", "Brute"},
        [4442272183] = {"Mercenary", "Swan Pirate"},
        [7449423635] = {"Jungle Pirate", "Forest Pirate"},
    },
    ["Radioactive Material"] = {[4442272183] = {"Factory Staff"}},
    ["Demonic Wisp"] = {[7449423635] = {"Demonic Soul"}},
    ["Vampire Fang"] = {[4442272183] = {"Vampire"}},
    ["Conjured Cocoa"] = {[7449423635] = {"Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief", "Candy Rebel"}},
    ["Gunpowder"] = {[7449423635] = {"Pistol Billionaire"}},
    ["Mini Tusk"] = {[7449423635] = {"Mythological Pirate"}},
}

local function materialMobNames(materialName)
    local byWorld = MaterialTargets[materialName]
    return byWorld and byWorld[game.PlaceId] or nil
end

local function DetectMobAura()
    local _, _, playerRoot = getCharacter()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not playerRoot or not enemies then return nil end
    local limit = math.max(0, tonumber(Settings["Distance Farm Aura"]) or 300)
    local nearest, nearestDistance
    nearestDistance = limit
    for _, mob in ipairs(enemies:GetChildren()) do
        if isAlive(mob) then
            local root = mob:FindFirstChild("HumanoidRootPart")
            local distance = root and (root.Position - playerRoot.Position).Magnitude or math.huge
            if distance < nearestDistance then
                nearest = mob
                nearestDistance = distance
            end
        end
    end
    return nearest
end

local function shouldUseHealthRetreat()
    if Settings["Teleport Y"] ~= true then
        Runtime.LowHealthTeleport = false
        return false
    end
    local _, humanoid = getCharacter()
    if not humanoid or humanoid.MaxHealth <= 0 then return false end
    local ratio = humanoid.Health / humanoid.MaxHealth
    local threshold = math.clamp(tonumber(Settings["% Health Player"]) or 40, 0, 100) / 100
    if ratio < threshold then
        Runtime.LowHealthTeleport = true
    elseif ratio > 0.80 then
        Runtime.LowHealthTeleport = false
    end
    return Runtime.LowHealthTeleport == true
end

local MasterySkillOrder = {"Z", "X", "C", "V", "F"}
local function useMasterySkill(tool, toolType)
    local selected = Settings["Select Skills " .. tostring(toolType)]
    for _, key in ipairs(MasterySkillOrder) do
        if type(selected) ~= "table" or selected[key] ~= false then
            local skillsGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
            skillsGui = skillsGui and skillsGui:FindFirstChild("Skills")
            local toolGui = skillsGui and skillsGui:FindFirstChild(tool.Name)
            local keyGui = toolGui and toolGui:FindFirstChild(key)
            local ready = keyGui == nil or not keyGui:FindFirstChild("Cooldown", true)
            if ready then
                safeCall("MasterySkill:" .. key, function()
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    task.wait(Settings["Use skill fast dont hold"] and 0.05 or 0.2)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end)
                return true
            end
        end
    end
    return false
end

function FarmMastery(target)
    if Settings["Farm Mastery"] ~= true or not target or not isAlive(target) then
        return false
    end
    local humanoid = target:FindFirstChildOfClass("Humanoid")
    local root = target:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root or humanoid.MaxHealth <= 0 then return false end
    getgenv().AimPos = root.CFrame

    local finishAt = math.clamp(tonumber(Settings["Health %"]) or 40, 0, 100) / 100
    if humanoid.Health / humanoid.MaxHealth > finishAt then
        UsedualFlock()
        ClickM1(target)
        return true
    end

    local method = Settings["Select Method Farm Mastery"] or "Blox Fruit"
    local weaponName = NameWeapon(method)
    local tool = weaponName and equiptool(weaponName)
    if not tool then
        Runtime.FeatureStatus.FarmMastery = "No " .. tostring(method) .. " equipped"
        return false
    end
    Runtime.FeatureStatus.FarmMastery = "Finishing with " .. tostring(method)
    local usedSkill = useMasterySkill(tool, method)
    if usedSkill then return true end
    if method == "Gun" then
        safeCall("MasteryGunM1", function() tool:Activate() end)
        return true
    end
    safeCall("MasteryToolActivate", function() tool:Activate() end)
    return true
end

local function moveAboveTarget(target)
    if not target or not isAlive(target) then return end
    local root = target:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local offset
    if Settings["Select Weapon"] == "Blox Fruit" then
        offset = CFrame.new(-7, tonumber(getgenv().YPosFruit) or 20, 0)
    else
        offset = CFrame.new(7, 20, 0)
    end
    toTarget(root.CFrame * offset)
end

local function attackTarget(target)
    if not target or not isAlive(target) then return false end
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    if shouldUseHealthRetreat() and targetRoot then
        local retreatHeight = math.max(50, tonumber(Settings["Distance Teleport Y"]) or 800)
        setAction("Recover Health", target.Name)
        toTarget(targetRoot.CFrame * CFrame.new(0, retreatHeight, 0))
        return true
    end

    sizepart(target)
    BringMob(target)
    if not FarmMastery(target) then
        UsedualFlock()
        ClickM1(target)
    end
    moveAboveTarget(target)
    return true
end

local StaticMobFallback = {
    -- Runtime fallback only when _WorldOrigin.EnemySpawns cannot expose a usable
    -- spawn. These two were added from the Sea-1 quest mapping because the
    -- first runtime test was Lv300 and otherwise remained at the quest NPC.
    ["Military Soldier"] = CFrame.new(-5314.72217, 51.9536018, 8501.80859),
    ["Military Spy"] = CFrame.new(-5787.99023, 120.864456, 8762.25293),
}

local function objectCFrame(object)
    if not object then return nil end
    if object:IsA("BasePart") then
        return object.CFrame
    end
    if object:IsA("Model") then
        return object:GetPivot()
    end
    return nil
end

local function ancestorMatches(instance, mobName, stopAt)
    local current = instance
    while current and current ~= stopAt do
        if nameMatches(current.Name, mobName) then
            return true
        end
        current = current.Parent
    end
    return false
end

local function findSpawnPart(mobName)
    local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
    local enemySpawns = worldOrigin and worldOrigin:FindFirstChild("EnemySpawns")
    local _, _, playerRoot = getCharacter()

    if enemySpawns then
        local bestObject, bestDistance = nil, math.huge

        -- Spawn layouts differ between updates: sometimes the named object is
        -- itself a BasePart/Model; sometimes a named Folder/Model owns generic
        -- child parts. Check both the object and its ancestry.
        for _, object in ipairs(enemySpawns:GetDescendants()) do
            local cf = objectCFrame(object)
            if cf and (
                nameMatches(object.Name, mobName)
                or ancestorMatches(object.Parent, mobName, enemySpawns.Parent)
            ) then
                local distance = playerRoot and (cf.Position - playerRoot.Position).Magnitude or 0
                if distance < bestDistance then
                    bestObject, bestDistance = object, distance
                end
            end
        end

        if bestObject then
            return bestObject, objectCFrame(bestObject)
        end
    end

    local normalized = cleanMobName(type(mobName) == "table" and mobName[1] or mobName)
    local fallback = StaticMobFallback[normalized]
    if fallback then
        return nil, fallback
    end
    return nil, nil
end

-- ============================================================================
-- SEA 1 SKIP LEVEL
-- Reconstructed from a public kaitun implementation that uses Sky Palace:
-- Lv9-70 -> Shanda, Lv71-150 -> Royal Squad, without normal quest routing.
-- This is intentionally limited to the recovered/proven range; normal level
-- quest farming resumes automatically after Lv150.
-- ============================================================================
local SKY_SKIP_PORTAL = Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047)
local SKY_SKIP_WAIT = CFrame.new(-7757, 5582, -481)
local SKY_SKIP_DATA = {
    {Min = 9, Max = 70, Mob = "Shanda"},
    {Min = 71, Max = 150, Mob = "Royal Squad"},
}

local function getSkipLevelData(level)
    if Settings["Skip Level"] ~= true or game.PlaceId ~= 2753915549 then
        return nil
    end
    for _, data in ipairs(SKY_SKIP_DATA) do
        if level >= data.Min and level <= data.Max then
            return data
        end
    end
    return nil
end

local function SkipLevelFarm()
    local levelValue = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")
    local level = levelValue and tonumber(levelValue.Value)
    if not level then return false end

    local data = getSkipLevelData(level)
    if not data then
        Runtime.FeatureStatus.SkipLevel = "inactive at Lv" .. tostring(level)
        return false
    end

    if questVisible() then
        safeInvoke("AbandonQuest")
    end

    local _, humanoid, root = getCharacter()
    if not root or not humanoid or humanoid.Health <= 0 then return true end

    Runtime.FeatureStatus.SkipLevel = ("Lv%d -> %s"):format(level, data.Mob)
    local target = DetectMob(data.Mob)
    if target then
        setAction("Skip Level", data.Mob)
        attackTarget(target)
        return true
    end

    -- If we are far from Upper Sky, use the game entrance first.
    if (root.Position - SKY_SKIP_WAIT.Position).Magnitude > 3000 then
        setAction("Skip Level Portal", data.Mob)
        safeInvoke("requestEntrance", SKY_SKIP_PORTAL)
        task.wait(0.5)
        return true
    end

    local _, spawnCFrame = findSpawnPart(data.Mob)
    setAction("Skip Level Wait", data.Mob)
    toTarget((spawnCFrame or SKY_SKIP_WAIT) * CFrame.new(0, 20, 0))
    return true
end

function FarmMethod()
    local method = Settings["Select Method Farm"] or "Level Farm"

    if method == "Level Farm" and SkipLevelFarm() then
        return true
    end

    if Settings["Farm Material"] == true then
        local material = Settings["Select Material"]
        local names = materialMobNames(material)
        if not names then
            Runtime.FeatureStatus.Material = "Unsupported in this sea: " .. tostring(material)
            setAction("Material unavailable", material)
            return false
        end
        Runtime.FeatureStatus.Material = "Farming " .. tostring(material)
        local target = DetectMob(names)
        if target then
            setAction("Farm Material", material)
            return attackTarget(target)
        end
        for _, name in ipairs(names) do
            local spawnPart, spawnCFrame = findSpawnPart(name)
            if spawnCFrame then
                setAction("Wait Material", material)
                toTarget(spawnCFrame * CFrame.new(0, 50, 0))
                return false
            end
        end
        return false
    end

    if method == "Aura Farm" then
        local auraTarget = DetectMobAura()
        if auraTarget then
            setAction("Aura Farm", auraTarget.Name)
            return attackTarget(auraTarget)
        end
        setAction("Aura Farm", "No mob in range")
        return false
    end

    local quest = DoubleQuest()
    local mobName = quest.Name
    local specialQuest = false

    if method == "Farm Katakuri" then
        if Settings["Ignore Attack Katakuri"] ~= true then
            local cakePrince = CheckNameBoss({"Cake Prince", "Cake Prince [Lv. 2300] [Raid Boss]"})
            if cakePrince then
                setAction("Farm Katakuri Boss", cakePrince.Name)
                return attackTarget(cakePrince)
            end
        end
        mobName = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}
        quest = {NameQuest = "CakeQuest2", ID = 2, Name = mobName}
        specialQuest = true
    elseif method == "Farm Bones" then
        mobName = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
        quest = {NameQuest = "HauntedQuest2", ID = 2, Name = mobName}
        specialQuest = true
    elseif method == "Farm Tyrant of the Skies" then
        mobName = {"Isle Champion", "Serpent Hunter", "Skull Slayer"}
        quest = {NameQuest = "TikiQuest3", ID = 1, Name = mobName}
        specialQuest = true
    end

    if not questVisible() then
        if specialQuest then
            if Settings["Auto Quest [Katakuri/Bone/Tyrant]"] then
                QuestBoneAndkatakuri(quest.NameQuest, quest.ID)
                return false
            end
        elseif method == "Level Farm" then
            TakeQuestLevel()
            return false
        end
    end

    local target = DetectMob(mobName)
    if target then
        if questVisible() and type(mobName) ~= "table" then
            -- Never validate against PlayerGui text: Roblox localizes the quest
            -- title (the test video shows Vietnamese "Linh Quân Đội"), while
            -- enemy model names remain English. GuideModule keeps the canonical
            -- quest task name and is localization-independent.
            local activeMob = GetNameDoubleQuest()
            if activeMob and not nameMatches(activeMob, target.Name) then
                Runtime.FeatureStatus.Quest = ("Mismatch: %s / %s"):format(
                    tostring(activeMob), tostring(target.Name)
                )
                safeInvoke("AbandonQuest")
                return false
            end
        end
        setAction("Farm", target.Name)
        return attackTarget(target)
    end

    local spawnPart
    if type(mobName) == "table" then
        for _, name in ipairs(mobName) do
            local foundObject, foundCFrame = findSpawnPart(name)
            if foundCFrame then
                spawnPart = {Object = foundObject, CFrame = foundCFrame}
                break
            end
        end
    else
        local foundObject, foundCFrame = findSpawnPart(mobName)
        if foundCFrame then
            spawnPart = {Object = foundObject, CFrame = foundCFrame}
        end
    end
    if spawnPart then
        setAction("Wait Mob", type(mobName) == "table" and table.concat(mobName, ", ") or mobName)
        toTarget(spawnPart.CFrame * CFrame.new(0, 50, 0))
    else
        Runtime.FeatureStatus.Farm = "No live mob/spawn found: " .. tostring(
            type(mobName) == "table" and table.concat(mobName, ", ") or mobName
        )
        setAction("Farm Search", Runtime.FeatureStatus.Farm)
    end
    return false
end

-- ============================================================================
-- 9. CHEST / BOSS
-- ============================================================================

function GetNearestChest()
    local nearest, nearestDistance = nil, math.huge
    for _, chest in ipairs(CollectionService:GetTagged("_ChestTagged")) do
        if chest:IsA("BasePart")
            and not chest:GetAttribute("IsDisabled")
            and not chest:FindFirstChild("Ignored")
        then
            local distance = LocalPlayer:DistanceFromCharacter(chest.Position)
            if distance < nearestDistance then
                nearest = chest
                nearestDistance = distance
            end
        end
    end
    return nearest
end

function AutoChest()
    local chest = GetNearestChest()
    if not chest then
        if Settings["Auto Chest Hop"] then
            HopServer()
        end
        return
    end
    setAction("Chest", chest.Name)
    toTarget(chest.CFrame, Settings["Use Method Teleport"] == true)
end

local BossNames = {
    "The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral",
    "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord",
    "Wysper", "Thunder God", "Cyborg", "Diamond", "Jeremy", "Fajita",
    "Don Swan", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper",
    "Stone", "Island Empress", "Kilo Admiral", "Captain Elephant",
    "Beautiful Pirate", "Cake Queen", "Longma", "Soul Reaper",
    "rip_indra True Form", "Cake Prince", "Dough King", "Tyrant of the Skies",
}

function TableBoss()
    local found = {}
    local seen = {}
    for _, container in ipairs({ReplicatedStorage, Workspace:FindFirstChild("Enemies")}) do
        if container then
            for _, model in ipairs(container:GetChildren()) do
                if table.find(BossNames, model.Name) and not seen[model.Name] then
                    seen[model.Name] = true
                    found[#found + 1] = model.Name
                end
            end
        end
    end
    return found
end

function AutoKillBoss()
    local selected = Settings["Kill All Boss"] and TableBoss() or Settings["Select Boss"]
    local boss = CheckNameBoss(selected)
    if not boss then
        if Settings["Hop Server Find Boss"] then HopServer() end
        return
    end
    setAction("Boss", boss.Name)
    attackTarget(boss)
end

-- ============================================================================
-- 10. RAID / DUNGEON
-- ============================================================================

function CheckInRaid()
    local locations = Workspace:FindFirstChild("_WorldOrigin")
    locations = locations and locations:FindFirstChild("Locations")
    if not locations then return false end

    local _, _, root = getCharacter()
    if not root then return false end
    for _, location in ipairs(locations:GetChildren()) do
        if location.Name:find("Island") and (location.Position - root.Position).Magnitude < 5000 then
            return true
        end
    end
    return false
end

function GetLastRaidIsland()
    local locations = Workspace:FindFirstChild("_WorldOrigin")
    locations = locations and locations:FindFirstChild("Locations")
    if not locations then return nil end

    local best, bestIndex = nil, -1
    for _, location in ipairs(locations:GetChildren()) do
        local index = tonumber(location.Name:match("Island (%d+)"))
        if index and index > bestIndex then
            best = location
            bestIndex = index
        end
    end
    return best
end

function DetectMobRaid()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local _, _, root = getCharacter()
    if not root then return nil end

    local nearest, distance = nil, math.huge
    for _, mob in ipairs(enemies:GetChildren()) do
        if isAlive(mob) then
            local mobRoot = mob:FindFirstChild("HumanoidRootPart")
            local d = (mobRoot.Position - root.Position).Magnitude
            if d < distance then
                nearest, distance = mob, d
            end
        end
    end
    return nearest
end

local function buyRaidChip(raidName)
    safeInvoke("RaidsNpc", "Check")
    task.wait(0.2)
    return safeInvoke("RaidsNpc", "Select", raidName or Settings["Select Raid"] or "Flame")
end

local function startRaid()
    local map = Workspace:FindFirstChild("Map")
    if not map then return false end

    local button = findDescendant(map, "RaidSummon2") or findDescendant(map, "RaidSummon")
    local click = button and button:FindFirstChildWhichIsA("ClickDetector", true)
    if click and fireclickdetector then
        fireclickdetector(click)
        return true
    end
    return false
end

function Multiraid(raidName)
    local main = LocalPlayer.PlayerGui:FindFirstChild("Main")
    local raidTimer = main and findDescendant(main, "RaidTimer")
    local active = raidTimer and raidTimer.Visible

    if active or CheckInRaid() then
        local mob = DetectMobRaid()
        if mob then
            setAction("Raid", mob.Name)
            attackTarget(mob)
        else
            local island = GetLastRaidIsland()
            if island then
                toTarget(island.CFrame * CFrame.new(0, 60, 0))
            end
        end
        return
    end

    if not DetectItemPlr("Special Microchip") then
        buyRaidChip(raidName)
    else
        startRaid()
    end
end

function DetectPadJoinDungeon(initiatorOnly)
    local map = Workspace:FindFirstChild("Map")
    local pads = map and map:FindFirstChild("Pads")
    if not pads then return nil end
    for _, pad in ipairs(pads:GetChildren()) do
        if (pad:GetAttribute("NumPlayersOnPad") or 0) == 0 then
            if not initiatorOnly or pad.Name:find("Initiator") then
                return pad
            end
        end
    end
    return nil
end

function DetectMobDungeon(folder)
    folder = folder or Workspace
    local _, _, playerRoot = getCharacter()
    if not playerRoot then return nil end

    local nearest, distance = nil, math.huge
    for _, mob in ipairs(folder:GetChildren()) do
        if mob.Name ~= "Blank Buddy" and isAlive(mob) then
            local d = (mob.HumanoidRootPart.Position - playerRoot.Position).Magnitude
            if d < distance then
                nearest, distance = mob, d
            end
        end
    end
    return nearest
end

-- ============================================================================
-- 11. BOAT / SEA EVENTS / LEVIATHAN
-- ============================================================================

local buyBoat

local function boatOwnerMatches(boat)
    local owner = boat:GetAttribute("Owner") or boat:GetAttribute("OwnerName")
    if owner == LocalPlayer.Name or owner == LocalPlayer.UserId or tostring(owner) == tostring(LocalPlayer.UserId) then
        return true
    end

    local ownerValue = boat:FindFirstChild("Owner")
    if ownerValue then
        if ownerValue:IsA("ObjectValue") and ownerValue.Value == LocalPlayer then
            return true
        end
        if ownerValue:IsA("StringValue") and ownerValue.Value == LocalPlayer.Name then
            return true
        end
        if ownerValue:IsA("IntValue") and ownerValue.Value == LocalPlayer.UserId then
            return true
        end
    end
    return false
end

local function findBoat()
    local boats = Workspace:FindFirstChild("Boats")
    if not boats then return nil end

    local _, _, playerRoot = getCharacter()
    local nearest, nearestDistance = nil, math.huge
    for _, boat in ipairs(boats:GetChildren()) do
        local seat = boat:FindFirstChildWhichIsA("VehicleSeat", true)
        if seat then
            if seat.Occupant and seat.Occupant.Parent == LocalPlayer.Character then
                return boat
            end
            if boatOwnerMatches(boat) then
                local distance = playerRoot and (seat.Position - playerRoot.Position).Magnitude or 0
                if distance < nearestDistance then
                    nearest, nearestDistance = boat, distance
                end
            end
        end
    end
    return nearest
end

local function cancelBoatTween()
    local tween = Runtime.BoatTween
    if tween then
        tryCall(function() tween:Pause() end)
        tryCall(function() tween:Cancel() end)
        tryCall(function() tween:Destroy() end)
    end
    Runtime.BoatTween = nil
    Runtime.BoatTweenTarget = nil
    getgenv().TweenBoat = nil
end

local function noclipBoat(boat)
    if not boat then return end
    for _, descendant in ipairs(boat:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end

local function ensureSeatedInBoat(boat)
    local character, humanoid, root = getCharacter()
    local seat = boat and boat:FindFirstChildWhichIsA("VehicleSeat", true)
    if not character or not humanoid or not root or not seat then
        return false, seat
    end
    if seat.Occupant == humanoid or humanoid.SeatPart == seat then
        Runtime.BoatMode = true
        return true, seat
    end

    Runtime.BoatMode = false
    if (root.Position - seat.Position).Magnitude > 8 then
        setAction("Board Boat", boat.Name)
        toTarget(seat.CFrame * CFrame.new(0, 3, 0))
        return false, seat
    end

    cancelTween()
    safeCall("Boat.Sit", function()
        root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
        seat:Sit(humanoid)
    end)
    task.wait(0.1)
    Runtime.BoatMode = humanoid.SeatPart == seat or seat.Occupant == humanoid
    return Runtime.BoatMode, seat
end

local function tweenBoatTo(boat, targetCFrame, speed)
    if not boat or typeof(targetCFrame) ~= "CFrame" then return false end
    local seated, seat = ensureSeatedInBoat(boat)
    if not seated or not seat then return false end

    noclipBoat(boat)
    local bodyVelocity = seat:FindFirstChildOfClass("BodyVelocity")
    if bodyVelocity then
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    end

    local distance = (seat.Position - targetCFrame.Position).Magnitude
    if distance <= 20 then
        cancelBoatTween()
        seat.CFrame = targetCFrame
        return true
    end

    local maxStep = math.max(500, tonumber(Settings["Sea Search Step"]) or 6500)
    if distance > maxStep then
        local direction = (targetCFrame.Position - seat.Position).Unit
        local nextPosition = seat.Position + direction * maxStep
        targetCFrame = CFrame.lookAt(nextPosition, nextPosition + direction)
        distance = maxStep
    end

    if Runtime.BoatTweenTarget
        and (Runtime.BoatTweenTarget.Position - targetCFrame.Position).Magnitude < 25
        and Runtime.BoatTween
    then
        return true
    end

    cancelBoatTween()
    local boatSpeed = math.max(50, tonumber(speed) or tonumber(Settings["Sea Search Speed"]) or 350)
    local tween = TweenService:Create(
        seat,
        TweenInfo.new(math.max(distance / boatSpeed, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        {CFrame = targetCFrame}
    )
    Runtime.BoatTween = tween
    Runtime.BoatTweenTarget = targetCFrame
    getgenv().TweenBoat = tween
    tween.Completed:Connect(function()
        if Runtime.BoatTween == tween then
            Runtime.BoatTween = nil
            Runtime.BoatTweenTarget = nil
            getgenv().TweenBoat = nil
        end
    end)
    tween:Play()
    return true
end

local function seaDangerLevel()
    local main = LocalPlayer.PlayerGui:FindFirstChild("Main")
    local compass = main and main:FindFirstChild("Compass")
    local frame = compass and compass:FindFirstChild("Frame")
    local danger = frame and frame:FindFirstChild("DangerLevel")
    if not danger or not danger.Visible then return 0 end
    local label = danger:FindFirstChildWhichIsA("TextLabel", true)
    return tonumber(label and label.Text) or 0
end

local SEA_SEARCH_FAR = CFrame.new(-118834.515625, 160, -78.9505844116211) * CFrame.new(0, 0, 99999999)
local SEA_SEARCH_HOME = CFrame.new(-32975.9921875, 160, 25963.7109375)

local function seaSearchTarget(boat)
    local seat = boat and boat:FindFirstChildWhichIsA("VehicleSeat", true)
    if not seat then return nil end

    local altitude = tonumber(Settings["Boat Search Altitude"]) or 160
    if seaDangerLevel() >= 1 then
        altitude = math.max(altitude, 500)
    end

    local far = CFrame.new(SEA_SEARCH_FAR.Position.X, altitude, SEA_SEARCH_FAR.Position.Z)
    local home = CFrame.new(SEA_SEARCH_HOME.Position.X, altitude, SEA_SEARCH_HOME.Position.Z)
    if Settings["Will Back When over 10km"] and (seat.Position - home.Position).Magnitude >= 10000 then
        Runtime.SeaReturning = true
    elseif Runtime.SeaReturning and (seat.Position - home.Position).Magnitude <= 4800 then
        Runtime.SeaReturning = false
    end
    return Runtime.SeaReturning and home or far
end

local function sailForSeaEvent(label)
    local boat = findBoat()
    if not boat then
        Runtime.FeatureStatus.SeaSearch = "Buying boat"
        buyBoat(Settings["Auto Buy Boat Beast Hunter"] and "Beast Hunter" or Settings["Select Boat"] or "PirateBrigade")
        return false
    end

    local seated = ensureSeatedInBoat(boat)
    if not seated then
        Runtime.FeatureStatus.SeaSearch = "Boarding " .. boat.Name
        return false
    end

    local target = seaSearchTarget(boat)
    if target then
        setAction(label or "Sea Search", "Sailing")
        Runtime.FeatureStatus.SeaSearch = "Sailing / danger " .. tostring(seaDangerLevel())
        return tweenBoatTo(boat, target, Settings["Sea Search Speed"])
    end
    return false
end

local function leaveBoatForCombat()
    cancelBoatTween()
    Runtime.BoatMode = false
    local _, humanoid = getCharacter()
    if humanoid and humanoid.Sit then
        humanoid.Sit = false
        humanoid.Jump = true
        task.wait()
    end
end

buyBoat = function(name)
    return safeInvoke("BuyBoat", name or Settings["Select Boat"] or "PirateBrigade")
end

local SeaEventNames = {
    "Sea Beast", "Terrorshark", "Shark", "Piranha", "Fish Crew Member",
    "Haunted Crew Member", "Pirate Brigade", "Pirate Grand Brigade",
}

function DetectSeaEvents()
    local seaBeasts = Workspace:FindFirstChild("SeaBeasts")
    if seaBeasts then
        for _, model in ipairs(seaBeasts:GetChildren()) do
            if model:FindFirstChild("Health") and model.Health.Value > 0 then
                return model
            end
        end
    end

    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, model in ipairs(enemies:GetChildren()) do
            for _, wanted in ipairs(SeaEventNames) do
                if model.Name:find(wanted, 1, true) and isAlive(model) then
                    return model
                end
            end
        end
    end
    return nil
end

local function aimAtModel(model, height)
    local root = model and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart)
    if not root then return nil end
    local target = CFrame.new(root.Position.X, root.Position.Y + (height or 25), root.Position.Z)
    getgenv().AimPos = target
    return target
end

function AutoSeabeast()
    local target = DetectSeaEvents()
    if not target then
        if Settings["Tween Until Have Sea Event"] ~= false then
            return sailForSeaEvent("Sea Event Search")
        end
        return false
    end

    leaveBoatForCombat()
    setAction("Sea Event", target.Name)
    local aim = aimAtModel(target, 30)
    if aim then
        toTarget(aim)
    end

    if Settings["Use Click M1 Fruit For Sea Event"] then
        useFruitM1(target)
    else
        UsedualFlock()
        ClickM1(target, true)
    end
    return true
end

function DetectLeviathan(container, includeArmored)
    if not container then return nil end

    for _, segment in ipairs(container:GetChildren()) do
        if segment.Name == "Leviathan Tail"
            and segment:GetAttribute("HealthEnabled")
            and segment:FindFirstChild("Health")
            and segment.Health.Value > 0
        then
            return segment
        end
    end

    for _, segment in ipairs(container:GetChildren()) do
        if segment.Name == "Leviathan"
            and segment:FindFirstChild("Health")
            and segment.Health.Value > 0
            and (includeArmored or not segment:GetAttribute("Armored"))
        then
            return segment
        end
    end
    return nil
end

local function findFrozenDimension()
    local locations = Workspace:FindFirstChild("_WorldOrigin")
    locations = locations and locations:FindFirstChild("Locations")
    return (Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Frozen Dimension"))
        or (locations and locations:FindFirstChild("Frozen Dimension"))
end

function AutoFindLeviathan()
    local frozen = findFrozenDimension()
    if frozen then
        cancelBoatTween()
        Runtime.BoatMode = false
        setAction("Leviathan", "Frozen Dimension")
        Runtime.FeatureStatus.Leviathan = "Frozen Dimension found"
        local pivot
        if frozen:IsA("Model") then pivot = frozen:GetPivot() end
        if frozen:IsA("BasePart") then pivot = frozen.CFrame end
        if pivot then
            leaveBoatForCombat()
            toTarget(pivot * CFrame.new(0, 50, 0))
        end
        return true
    end

    Runtime.FeatureStatus.Leviathan = "Searching"
    return sailForSeaEvent("Find Leviathan")
end

function AutoAttackLeviathan()
    local seaBeasts = Workspace:FindFirstChild("SeaBeasts")
    local leviathan = seaBeasts and DetectLeviathan(seaBeasts, Settings["Attack Multi Segments Leviathan"])
    if not leviathan then
        Runtime.FeatureStatus.LeviathanAttack = "Waiting for Leviathan segment"
        return false
    end

    leaveBoatForCombat()
    setAction("Attack Leviathan", leviathan.Name)
    Runtime.FeatureStatus.LeviathanAttack = "Attacking " .. leviathan.Name
    local targetPart = leviathan:FindFirstChild("HumanoidRootPart") or leviathan.PrimaryPart
    if targetPart then
        getgenv().AimPos = targetPart.CFrame
        toTarget(targetPart.CFrame * CFrame.new(0, 40, 0))
    end

    if Settings["Use Click M1 Fruit Leviathan"] then
        useFruitM1(leviathan)
    else
        UsedualFlock()
        AttackFunction(120, false)
    end
    return true
end

-- ============================================================================
-- 12. RACE V2 / V3 / V4
-- ============================================================================

function CheckRace(force)
    local now = os.clock()
    if not force and Runtime.RaceStageCache and (now - (Runtime.RaceStageCacheAt or 0)) < 3 then
        return Runtime.RaceStageCache
    end

    local character = LocalPlayer.Character
    local stage
    if character and character:FindFirstChild("RaceTransformed") then
        stage = "V4"
    else
        local wenlock = safeInvoke("Wenlocktoad", "1")
        local alchemist = safeInvoke("Alchemist", "1")
        if wenlock == -2 then
            stage = "V3"
        elseif alchemist == -2 then
            stage = "V2"
        else
            stage = "V1"
        end
    end

    Runtime.RaceStageCache = stage
    Runtime.RaceStageCacheAt = now
    return stage
end

local function findRaceFlowers()
    local result = {}
    for _, name in ipairs({"Flower1", "Flower2"}) do
        local flower = Workspace:FindFirstChild(name, true)
        if flower and flower:IsA("BasePart") then
            result[name] = flower
        end
    end
    return result
end

function UpgradeRaceV2AndV3()
    local race = CheckRace()
    if race == "V1" then
        local status = safeInvoke("Alchemist", "1")
        if status == 0 then
            safeInvoke("Alchemist", "2")
            Runtime.RaceStageCacheAt = 0
            return
        end

        local flowers = findRaceFlowers()
        if not DetectItemPlr("Flower 1") and flowers.Flower1 then
            toTarget(flowers.Flower1.CFrame)
            return
        end
        if not DetectItemPlr("Flower 2") and flowers.Flower2 then
            toTarget(flowers.Flower2.CFrame)
            return
        end
        if not DetectItemPlr("Flower 3") then
            local swanPirate = DetectMob("Swan Pirate")
            if swanPirate then attackTarget(swanPirate) end
            return
        end
        safeInvoke("Alchemist", "3")
        Runtime.RaceStageCacheAt = 0
        return
    end

    if race == "V2" then
        local response = safeInvoke("Wenlocktoad", "1")
        if response == 0 then
            safeInvoke("Wenlocktoad", "2")
            Runtime.RaceStageCacheAt = 0
        elseif response == 1 then
            -- Race-specific V3 quests are exposed through Wenlocktoad and the
            -- current quest UI. Keep normal farming active while the quest is live.
            if not questVisible() then
                safeInvoke("Wenlocktoad", "3")
            end
        end
        return
    end
end

function GetCyborg()
    local status = safeInvoke("CyborgTrainer", "Check")
    if status == 2 then
        notify("Cyborg already available")
        return true
    end

    if getSea() ~= 2 then
        safeInvoke("TravelDressrosa")
        return false
    end

    local core = CheckItemInventory("Core Brain")
    if core then
        safeInvoke("CyborgTrainer", "Buy")
        return true
    end

    local fist = DetectItemPlr("Fist of Darkness")
    if fist then
        local lab = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("CircleIsland")
        local order = lab and lab:FindFirstChild("OrderSummoner", true)
        local button = order and order:FindFirstChildWhichIsA("ClickDetector", true)
        if button and fireclickdetector then fireclickdetector(button) end
    end
    return false
end

function GetRaceGhoul()
    if getSea() ~= 2 then
        safeInvoke("TravelDressrosa")
        return false
    end
    local ectoplasmOk = CheckCountItem("Ectoplasm", 100)
    local torch = CheckItemInventory("Hellfire Torch")
    if ectoplasmOk and torch then
        safeInvoke("Ectoplasm", "BuyCheck", 4)
        safeInvoke("Ectoplasm", "Change", 4)
        return true
    end
    return false
end

function DetectGearUp()
    local clock = safeInvoke("TempleClock", "Check")
    if type(clock) ~= "table" then return nil end
    local gears = clock.Gears or clock.gears
    if type(gears) == "table" then
        for gearName, data in pairs(gears) do
            if type(data) == "table" and data.Owned and not data.Completed then
                return gearName
            end
        end
    end
    return nil
end

function ChooseGearV4()
    local gear = DetectGearUp()
    if not gear then return false end
    safeInvoke("TempleClock", "SpendPoint", gear, "Omega")
    safeInvoke("TempleClock", "SpendPoint", gear, "Alpha")
    return true
end

function BuyGearV4()
    local status = safeInvoke("UpgradeRace", "Check")
    if tostring(status):find("Can Buy Gear") then
        safeInvoke("UpgradeRace", "Buy")
        return true
    end
    return false
end

local function getBlueGear()
    local map = Workspace:FindFirstChild("Map")
    local mirage = map and map:FindFirstChild("MysticIsland")
    if not mirage then return nil end
    for _, part in ipairs(mirage:GetDescendants()) do
        if part:IsA("MeshPart") and part.MeshId == "rbxassetid://10153114969" then
            return part
        end
    end
    return nil
end

function PullLeverV4()
    if not CheckItemInventory("Valkyrie Helm") or not CheckItemInventory("Mirror Fractal") then
        return false
    end

    local door = safeInvoke("CheckTempleDoor")
    if door == true then
        return true
    end

    local progress = safeInvoke("RaceV4Progress", "Check")
    if type(progress) == "table" then
        local state = progress.State or progress.state
        if state == 0 then
            safeInvoke("RaceV4Progress", "Begin")
        elseif state == 1 then
            safeInvoke("RaceV4Progress", "Continue")
        elseif state == 2 then
            local blueGear = getBlueGear()
            if blueGear then
                toTarget(blueGear.CFrame)
                safeCall("RaceV4.BlueGearTouch", function()
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, blueGear, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, blueGear, 1)
                end)
            end
        end
    end
    return false
end

-- ============================================================================
-- 13. ITEM QUESTS: SABER / YAMA / TUSHITA / CDK / SOUL GUITAR
-- ============================================================================

local function doorsaber()
    local jungle = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Jungle")
    local final = jungle and jungle:FindFirstChild("Final")
    if not final then return false end
    for _, part in ipairs(final:GetChildren()) do
        if part:IsA("BasePart") and not part.CanCollide then
            return true
        end
    end
    return false
end

local function doorcup()
    local desert = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Desert")
    local burn = desert and desert:FindFirstChild("Burn")
    if not burn then return false end
    for _, part in ipairs(burn:GetChildren()) do
        if part:IsA("BasePart") and not part.CanCollide then
            return true
        end
    end
    return false
end

local function nextJunglePlate()
    local jungle = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Jungle")
    local plates = jungle and jungle:FindFirstChild("QuestPlates")
    if not plates then return nil end
    for _, model in ipairs(plates:GetChildren()) do
        local button = model:FindFirstChild("Button")
        if model:IsA("Model") and button and button:FindFirstChild("TouchInterest") then
            return model
        end
    end
    return nil
end

function SaberSword()
    if not LocalPlayer:FindFirstChild("Data") or LocalPlayer.Data.Level.Value < 200 then
        return false
    end

    if doorsaber() then
        local boss = CheckNameBoss("Saber Expert")
        if boss then attackTarget(boss) end
        return boss ~= nil
    end

    local jungle = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Jungle")
    local questDoor = jungle and findDescendant(jungle, "Door")
    if questDoor and questDoor:IsA("BasePart") and questDoor.CanCollide then
        local plate = nextJunglePlate()
        if plate and plate:FindFirstChild("Button") then
            toTarget(plate.Button.CFrame)
        end
        return false
    end

    if not doorcup() then
        local torch = DetectItemPlr("Torch")
        if not torch then
            local jungleTorch = jungle and jungle:FindFirstChild("Torch", true)
            if jungleTorch and jungleTorch:IsA("BasePart") then
                toTarget(jungleTorch.CFrame)
            end
            return false
        end

        equiptool("Torch")
        local burn = Workspace.Map.Desert:FindFirstChild("Burn")
        local fire = burn and burn:FindFirstChild("Fire", true)
        local handle = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Torch")
        handle = handle and handle:FindFirstChild("Handle")
        if fire and handle and firetouchinterest then
            firetouchinterest(handle, fire, 0)
            firetouchinterest(handle, fire, 1)
        end
        return false
    end

    local richStatus = safeInvoke("ProQuestProgress", "RichSon")
    if richStatus == 0 then
        local mobLeader = CheckNameBoss("Mob Leader")
        if mobLeader then attackTarget(mobLeader) end
        return false
    end

    if richStatus == 1 then
        if DetectItemPlr("Relic") then
            equiptool("Relic")
            toTarget(CFrame.new(-1404.07996, 29.8520069, 5.26677656))
            safeInvoke("ProQuestProgress", "RichSon")
        end
        return false
    end

    local cup = DetectItemPlr("Cup")
    if not cup then
        toTarget(CFrame.new(1112.46521, 4.92147732, 4364.55469))
        local desertCup = Workspace.Map.Desert:FindFirstChild("Cup")
        local _, _, root = getCharacter()
        if desertCup and root and firetouchinterest then
            firetouchinterest(desertCup, root, 0)
            firetouchinterest(desertCup, root, 1)
        end
        return false
    end

    equiptool("Cup")
    local cupTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Cup")
    local handle = cupTool and cupTool:FindFirstChild("Handle")
    if handle and handle:FindFirstChild("TouchInterest") then
        toTarget(CFrame.new(1395.77307, 37.4733238, -1324.34631))
    else
        toTarget(CFrame.new(1457.8768310547, 88.377502441406, -1390.6892089844))
        safeInvoke("ProQuestProgress", "SickMan")
    end
    return false
end

local function eliteProgress()
    local value = safeInvoke("EliteHunter", "Progress")
    return tonumber(value) or 0
end

local EliteNames = {
    "Diablo", "Deandre", "Urban",
}

local function detectElite()
    return CheckNameBoss(EliteNames)
end

function GetYama()
    if eliteProgress() < 30 then
        local elite = detectElite()
        if elite then
            if not questVisible() then
                safeInvoke("EliteHunter")
            end
            attackTarget(elite)
        else
            safeInvoke("EliteHunter")
        end
        return false
    end

    local map = Workspace:FindFirstChild("Map")
    local waterfall = map and map:FindFirstChild("Waterfall")
    local katana = waterfall and waterfall:FindFirstChild("SealedKatana")
    if not katana then
        toTarget(CFrame.new(5251.900390625, 17.18115234375, 453.6025390625))
        return false
    end

    local ghost = DetectMob("Ghost")
    if ghost then
        attackTarget(ghost)
        return false
    end

    local click = katana:FindFirstChildWhichIsA("ClickDetector", true)
    if click and fireclickdetector then
        fireclickdetector(click)
    else
        toTarget(katana:GetPivot())
    end
    return true
end

local function getTushitaHitbox()
    local map = Workspace:FindFirstChild("Map")
    local waterfall = map and map:FindFirstChild("Waterfall")
    local islandModel = waterfall and waterfall:FindFirstChild("IslandModel")
    local hitbox = islandModel and islandModel:FindFirstChild("Hitbox", true)
    if hitbox then return hitbox end

    if getnilinstances then
        for _, instance in ipairs(getnilinstances()) do
            if instance.Name == "Hitbox"
                and instance:IsA("BasePart")
                and (instance.Position - Vector3.new(5713.53759765625, 38.38311767578125, 255.2017059326172)).Magnitude < 1
            then
                return instance
            end
        end
    end
    return nil
end

local function nextTushitaTorch()
    local map = Workspace:FindFirstChild("Map")
    local turtle = map and map:FindFirstChild("Turtle")
    local torches = turtle and turtle:FindFirstChild("QuestTorches")
    if not torches then return nil end
    for index = 1, 5 do
        local torch = torches:FindFirstChild("Torch" .. index)
        local main = torch and findDescendant(torch, "Main")
        if torch and main and main:IsA("ParticleEmitter") and not main.Enabled then
            return torch, index
        end
    end
    return nil
end

function GetTushita()
    local progress = safeInvoke("TushitaProgress")
    if type(progress) == "table" and progress.OpenedDoor then
        local longma = CheckNameBoss("Longma")
        if longma then attackTarget(longma) end
        return longma == nil
    end

    local hitbox = getTushitaHitbox()
    if not hitbox then
        toTarget(CFrame.new(5677.541015625, 28.533447265625, 357.9483642578125))
        return false
    end

    if not DetectItemPlr("Holy Torch") then
        toTarget(hitbox.CFrame)
        return false
    end

    equiptool("Holy Torch")
    local torch, index = nextTushitaTorch()
    if torch then
        toTarget(torch:GetPivot())
        safeInvoke("TushitaProgress", "Torch", index)
        return false
    end
    return true
end

local SoulGuitarPipes = {
    Part1 = "Really black",
    Part2 = "Really black",
    Part3 = "Dusty Rose",
    Part4 = "Storm blue",
    Part5 = "Really black",
    Part6 = "Parsley green",
    Part7 = "Really black",
    Part8 = "Dusty Rose",
    Part9 = "Really black",
    Part10 = "Storm blue",
}

local function countLivingZombies()
    local count = 0
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in ipairs(enemies:GetChildren()) do
            if mob.Name == "Living Zombie" and isAlive(mob) then
                count += 1
            end
        end
    end
    return count
end

function GuitarPuzzleProgress()
    local progress = safeInvoke("GuitarPuzzleProgress", "Check")

    if not progress then
        local sky = game:GetService("Lighting"):FindFirstChild("Sky")
        local clockTime = game:GetService("Lighting").ClockTime
        local fullMoon = sky
            and sky.MoonTextureId == "http://www.roblox.com/asset/?id=9709149431"
            and (clockTime > 16 or clockTime < 5)
        if fullMoon then
            toTarget(CFrame.new(-8654.314453125, 140.9499053955078, 6167.5283203125))
            local gravestone = safeInvoke("gravestoneEvent", 2)
            if gravestone then safeInvoke("gravestoneEvent", 2, true) end
        end
        return false
    end

    if not progress.Swamp then
        toTarget(CFrame.new(-10171.7607421875, 158.62667846679688, 6008.0654296875))
        if countLivingZombies() > 0 then
            local zombie = DetectMob("Living Zombie")
            if zombie then attackTarget(zombie) end
        end
        return false
    end

    if not progress.Gravestones then
        toTarget(CFrame.new(-8761.4765625, 142.10487365722656, 6086.07861328125))
        local castle = Workspace.Map:FindFirstChild("Haunted Castle")
        if castle then
            for _, placardName in ipairs({"Placard1", "Placard2", "Placard3", "Placard4", "Placard5", "Placard6", "Placard7"}) do
                local placard = castle:FindFirstChild(placardName)
                local click = placard and placard:FindFirstChildWhichIsA("ClickDetector", true)
                if click and fireclickdetector then fireclickdetector(click) end
            end
        end
        return false
    end

    if not progress.Ghost then
        toTarget(CFrame.new(-9755.6591796875, 271.0661315917969, 6290.61474609375))
        safeInvoke("GuitarPuzzleProgress", "Ghost")
        return false
    end

    if not progress.Pipes then
        local castle = Workspace.Map:FindFirstChild("Haunted Castle")
        local lab = castle and castle:FindFirstChild("Lab Puzzle")
        local colorFloor = lab and lab:FindFirstChild("ColorFloor")
        local model = colorFloor and colorFloor:FindFirstChild("Model")
        if model then
            for partName, colorName in pairs(SoulGuitarPipes) do
                local part = model:FindFirstChild(partName)
                if part then
                    local click = part:FindFirstChildWhichIsA("ClickDetector", true)
                    local guard = 0
                    while part.BrickColor.Name ~= colorName and click and guard < 20 do
                        guard += 1
                        if fireclickdetector then fireclickdetector(click) end
                        task.wait(0.05)
                    end
                end
            end
        end
        return false
    end

    return true
end

function AutoSoulGuitar()
    if CheckItemInventory("Soul Guitar") then
        return true
    end

    local darkFragment = CheckCountItem("Dark Fragment", 1)
    local ectoplasm = CheckCountItem("Ectoplasm", 250)
    local bones = CheckCountItem("Bones", 500)

    if darkFragment and ectoplasm and bones then
        safeInvoke("soulGuitarBuy", true)
        safeInvoke("soulGuitarBuy")
        if getSea() == 3 then
            return GuitarPuzzleProgress()
        end
        safeInvoke("TravelZou")
        return false
    end

    if not ectoplasm then
        if getSea() ~= 2 then safeInvoke("TravelDressrosa") end
        local shipMob = DetectMob({"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"})
        if shipMob then attackTarget(shipMob) end
    elseif not bones then
        if getSea() ~= 3 then safeInvoke("TravelZou") end
        local boneMob = DetectMob({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"})
        if boneMob then attackTarget(boneMob) end
    end
    return false
end

local function swordMastery(name)
    local item = CheckItemInventory(name)
    if type(item) == "table" then
        return tonumber(item.Mastery or item.mastery or 0) or 0
    end
    local tool = DetectItemPlr(name)
    local level = tool and tool:FindFirstChild("Level")
    return level and level.Value or 0
end

function GetCDK()
    if CheckItemInventory("Cursed Dual Katana") then
        return true
    end

    if not CheckItemInventory("Tushita") then
        GetTushita()
        return false
    end
    if not CheckItemInventory("Yama") then
        GetYama()
        return false
    end
    if swordMastery("Tushita") < 350 or swordMastery("Yama") < 350 then
        notify("CDK requires Tushita/Yama mastery >= 350")
        return false
    end

    local progress = safeInvoke("CDKQuest", "Progress")
    if type(progress) ~= "table" then
        return false
    end

    local good = progress.Good
    local evil = progress.Evil

    if good == 4 and evil == 4 then
        local boss = CheckNameBoss("Cursed Skeleton Boss")
        if boss then
            attackTarget(boss)
        else
            toTarget(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125))
        end
        return false
    end

    -- Keep the server-side trial state moving. Individual trial mechanics are
    -- handled by the quest state and normal combat/movement loops.
    if good ~= 4 then
        safeInvoke("CDKQuest", "StartTrial", "Good")
    elseif evil ~= 4 then
        safeInvoke("CDKQuest", "StartTrial", "Evil")
    end
    return false
end

function autoCraftSharkAnchor()
    if CheckItemInventory("Shark Anchor") then
        return true
    end

    local monsterMagnet = CheckItemInventory("Monster Magnet")
    if monsterMagnet then
        local craft = Modules and Modules:FindFirstChild("Net") and Modules.Net:FindFirstChild("RF/Craft")
        if craft then safeRemoteInvoke("Craft.SharkAnchor", craft, "SharkAnchor") end
        return false
    end

    local craft = Modules and Modules:FindFirstChild("Net") and Modules.Net:FindFirstChild("RF/Craft")
    if not craft then return false end

    local terrorEyes = CheckCountItem("Terror Eyes", 1)
    local sharkTooth = CheckCountItem("Shark Tooth", 20)
    local electricWing = CheckCountItem("Electric Wing", 5)
    local foolsGold = CheckCountItem("Fool's Gold", 10)
    local mutantTooth = CheckCountItem("Mutant Tooth", 1)

    if terrorEyes and mutantTooth then
        safeRemoteInvoke("Craft.TerrorJaw", craft, "TerrorJaw")
    elseif sharkTooth and electricWing and foolsGold then
        safeRemoteInvoke("Craft.ToothNecklace", craft, "ToothNecklace")
    end
    return false
end

-- ============================================================================
-- 14. PREHISTORIC / DRAGON HUNTER / DRACO
-- ============================================================================

local function netRemoteFunction(name)
    if not Modules or not Modules:FindFirstChild("Net") then return nil end
    return Modules.Net:FindFirstChild(name)
end

function DetectPrehistoricIsland()
    local map = Workspace:FindFirstChild("Map")
    if map and map:FindFirstChild("PrehistoricIsland") then
        return map.PrehistoricIsland
    end
    local locations = Workspace:FindFirstChild("_WorldOrigin")
    locations = locations and locations:FindFirstChild("Locations")
    return locations and locations:FindFirstChild("Prehistoric Island")
end

function AutoFindPrehistoric()
    local island = DetectPrehistoricIsland()
    if island then
        cancelBoatTween()
        Runtime.BoatMode = false
        setAction("Prehistoric", "Island")
        Runtime.FeatureStatus.Prehistoric = "Island found"
        local cframe = island:IsA("Model") and island:GetPivot() or island.CFrame
        leaveBoatForCombat()
        toTarget(cframe * CFrame.new(0, 60, 0))
        return true
    end

    Runtime.FeatureStatus.Prehistoric = "Searching by boat"
    return sailForSeaEvent("Find Prehistoric")
end

function DetectDragonEggs()
    local island = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("PrehistoricIsland")
    local eggs = island and findDescendant(island, "SpawnedDragonEggs")
    if not eggs then return nil end
    for _, egg in ipairs(eggs:GetChildren()) do
        local molten = egg:FindFirstChild("Molten")
        if egg.Name == "DragonEgg" and molten and molten:FindFirstChildOfClass("ProximityPrompt") then
            return egg
        end
    end
    return nil
end

function QuestDojoTrainer()
    local remote = netRemoteFunction("RF/InteractDragonQuest")
    if not remote then return false end
    local ok, result = safeCall("DragonQuest.DojoTrainer", function()
        return remote:InvokeServer({
            NPC = "Dojo Trainer",
            Command = "RequestQuest",
        })
    end)
    return ok, result
end

local function dragonHunterRemote(...)
    local remote = netRemoteFunction("RF/DragonHunter")
    if not remote then return nil end
    return safeRemoteInvoke("DragonHunter", remote, ...)
end

function AutoDragonHunter()
    local quest = dragonHunterRemote("Check")
    if not quest then
        dragonHunterRemote("RequestQuest")
        return false
    end

    local mob = DetectMob({"Hydra Enforcer", "Hydra Enforcers", "Venomous Assailant", "Venomous Assailants"})
    if mob then
        setAction("Dragon Hunter", mob.Name)
        attackTarget(mob)
        return false
    end

    local trees = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Hydra")
    if trees then
        for _, object in ipairs(trees:GetDescendants()) do
            if object.Name == "Meshes/plant1_Icosphere" and not object:GetAttribute("AlreadyDestroyedClient") then
                local part = object:IsA("BasePart") and object or object:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    toTarget(part.CFrame)
                    break
                end
            end
        end
    end
    return false
end

function AutoCraftinMagnetVol()
    if CheckItemInventory("Volcanic Magnet") then
        return true
    end

    local scrap = CheckCountItem("Scrap Metal", 10)
    local blaze = CheckCountItem("Blaze Ember", 10)
    if scrap and blaze then
        local craft = netRemoteFunction("RF/Craft")
        if craft then
            safeRemoteInvoke("Craft.VolcanicMagnet", craft, "Volcanic Magnet")
        end
        return false
    end

    AutoDragonHunter()
    return false
end

local function interactDragonQuest(payload)
    local remote = netRemoteFunction("RF/InteractDragonQuest")
    if not remote then return nil end
    return safeRemoteInvoke("DragonQuest.Interact", remote, payload)
end

function AutoUpgradeRaceDraco()
    local raceName = LocalPlayer.Data:FindFirstChild("Race")
    raceName = raceName and raceName.Value or ""
    if raceName ~= "Draco" then
        return false
    end

    local status = interactDragonQuest({
        NPC = "Dragon Wizard",
        Command = "Check",
    })

    if type(status) ~= "table" then
        interactDragonQuest({
            NPC = "Dragon Wizard",
            Command = "Begin",
        })
        return false
    end

    if status.V2TurnInReady then
        interactDragonQuest({NPC = "Dragon Wizard", Command = "Complete", Quest = "V2"})
        return false
    end
    if status.V3TurnInReady then
        interactDragonQuest({NPC = "Dragon Wizard", Command = "Complete", Quest = "V3"})
        return false
    end

    if status.V2InProgress or status.V3InProgress then
        AutoDragonHunter()
        return false
    end

    interactDragonQuest({NPC = "Dragon Wizard", Command = "Speak"})
    return false
end

function FullyEventVolcano()
    local island = DetectPrehistoricIsland()
    if not island then
        if not CheckItemInventory("Volcanic Magnet") and not Settings["Ignore Craft Volcanic Magnet"] then
            AutoCraftinMagnetVol()
        else
            AutoFindPrehistoric()
        end
        return false
    end

    local mapIsland = Workspace.Map:FindFirstChild("PrehistoricIsland")
    if not mapIsland then
        return false
    end

    local trialRock = findDescendant(mapIsland, "TrialRock")
    if trialRock then
        local prompt = trialRock:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and fireproximityprompt then
            toTarget(trialRock:GetPivot())
            fireproximityprompt(prompt)
        end
    end

    local egg = DetectDragonEggs()
    if egg then
        local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and fireproximityprompt then
            toTarget(egg:GetPivot())
            fireproximityprompt(prompt)
        end
        return false
    end

    local golem = CheckNameBoss({"Lava Golem", "Volcano Golem"})
    if golem then
        local previousWeapon = Settings["Select Weapon"]
        Settings["Select Weapon"] = Settings["Select Weapon Kill Golem"] or previousWeapon
        attackTarget(golem)
        Settings["Select Weapon"] = previousWeapon
    end
    return false
end

-- ============================================================================
-- 15. ADDITIONAL SUBSYSTEMS
-- ============================================================================

-- --------------------------------------------------------------------------
-- World progression
-- --------------------------------------------------------------------------

function AutoNewWorld()
    if getSea() ~= 1 then
        return true
    end
    local level = LocalPlayer.Data and LocalPlayer.Data:FindFirstChild("Level")
    if not level or level.Value < 700 then
        return false
    end

    local progress = safeInvoke("DressrosaQuestProgress", "Dressrosa")
    if progress == 0 or progress == nil then
        safeInvoke("DressrosaQuestProgress", "Detective")
        local key = DetectItemPlr("Key")
        if key then equiptool("Key") end
        toTarget(CFrame.new(1347.7124, 37.3751602, -1325.6488))
        return false
    end

    local iceAdmiral = CheckNameBoss("Ice Admiral")
    if iceAdmiral then
        attackTarget(iceAdmiral)
        return false
    end

    safeInvoke("TravelDressrosa")
    return false
end

function AutoThirdWorld()
    if getSea() ~= 2 then
        return getSea() >= 3
    end
    local level = LocalPlayer.Data and LocalPlayer.Data:FindFirstChild("Level")
    if not level or level.Value < 1500 then
        return false
    end

    local progress = safeInvoke("ZQuestProgress", "Check")
    if progress == 0 then
        safeInvoke("ZQuestProgress", "Begin")
        return false
    end

    local donSwan = CheckNameBoss("Don Swan")
    if donSwan then
        attackTarget(donSwan)
        return false
    end

    local ripIndra = CheckNameBoss("rip_indra")
    if ripIndra then
        attackTarget(ripIndra)
        return false
    end

    safeInvoke("TravelZou")
    return false
end

-- --------------------------------------------------------------------------
-- Elite / pirate raid / factory / summonable bosses
-- --------------------------------------------------------------------------

local function DetectEliteHunter()
    return CheckNameBoss({"Diablo", "Deandre", "Urban"})
end

function AutoEliteHunter()
    local elite = DetectEliteHunter()
    if elite then
        if not questVisible() then
            safeInvoke("EliteHunter")
        end
        setAction("Elite", elite.Name)
        attackTarget(elite)
        return true
    end

    local response = safeInvoke("EliteHunter")
    if type(response) == "string" and response:find("come back") and Settings["Hop Server Elite Hunter"] then
        HopServer()
    end
    return false
end

function GetPirateRaid(replicated)
    local container = replicated and ReplicatedStorage or Workspace:FindFirstChild("Enemies")
    if not container then return nil end

    local castle = Vector3.new(-5543, 313, -2964)
    for _, mob in ipairs(container:GetChildren()) do
        if isAlive(mob)
            and mob.Name ~= "Oni2"
            and mob.Name ~= "rip_indra True Form"
            and not mob.Name:find("Boss")
            and not mob.Name:find("Friend")
            and not mob.Name:find("Wraith")
        then
            local root = mob:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - castle).Magnitude < 1000 then
                return mob
            end
        end
    end
    return nil
end

function AutoPirateRaid()
    local target = GetPirateRaid(false) or GetPirateRaid(true)
    if not target then
        return false
    end
    setAction("Pirate Raid", target.Name)
    attackTarget(target)
    return true
end

function AutoFactory()
    local core = CheckNameBoss("Core")
    if not core then
        return false
    end
    setAction("Factory", "Core")
    attackTarget(core)
    return true
end

local function summonDarkbeard()
    local fist = DetectItemPlr("Fist of Darkness")
    if not fist then return false end
    equiptool("Fist of Darkness")
    local map = Workspace:FindFirstChild("Map")
    local darkArena = map and map:FindFirstChild("DarkbeardArena", true)
    local altar = darkArena and darkArena:FindFirstChildWhichIsA("BasePart", true)
    if altar then toTarget(altar.CFrame) end
    return true
end

local function summonRipIndra()
    if not DetectItemPlr("God's Chalice") then return false end
    local colors = safeInvoke("getColors")
    if type(colors) == "table" then
        -- The three legendary colors are required. Equip them through the
        -- regular aura activation endpoint when available.
        local required = {"Pure Red", "Snow White", "Winter Sky"}
        for _, color in ipairs(required) do
            safeInvoke("activateColor", color)
        end
    end
    local castle = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Castle on the Sea")
    local altar = castle and castle:FindFirstChild("Indra", true)
    if altar and altar:IsA("BasePart") then
        equiptool("God's Chalice")
        toTarget(altar.CFrame)
    end
    return true
end

local function summonSoulReaper()
    if not DetectItemPlr("Hallow Essence") then return false end
    local map = Workspace:FindFirstChild("Map")
    local castle = map and map:FindFirstChild("Haunted Castle")
    local altar = castle and castle:FindFirstChild("Summoner", true)
    if altar and altar:IsA("BasePart") then
        equiptool("Hallow Essence")
        toTarget(altar.CFrame)
    end
    return true
end

-- --------------------------------------------------------------------------
-- Observation V2
-- --------------------------------------------------------------------------

local ObservationFruitPositions = {
    Pineapple = Vector3.new(-10754, 332, -9367),
    Apple = Vector3.new(-10990, 332, -10158),
    Banana = Vector3.new(-12137, 332, -10625),
}

local function collectObservationFruit(name)
    if DetectItemPlr(name) then return true end

    local object = Workspace:FindFirstChild(name)
    if object then
        local tool = object:IsA("Tool") and object or object:FindFirstChildOfClass("Tool")
        local handle = tool and tool:FindFirstChild("Handle")
        local _, _, root = getCharacter()
        if handle and root and firetouchinterest then
            firetouchinterest(root, handle, 0)
            firetouchinterest(root, handle, 1)
            return true
        end
    end

    local position = ObservationFruitPositions[name]
    if position then toTarget(CFrame.new(position)) end
    return false
end

function ObservationV2()
    local progress = safeInvoke("CitizenQuestProgress", "Citizen")

    if progress == 0 then
        local forestPirate = DetectMob("Forest Pirate")
        if questVisible() and currentQuestTitle():find("Forest Pirate") then
            if forestPirate then attackTarget(forestPirate) end
        else
            local giver = CFrame.new(-12441.5908203125, 331.4884948730469, -7676.197265625)
            local _, _, root = getCharacter()
            if root and (root.Position - giver.Position).Magnitude <= 10 then
                safeInvoke("StartQuest", "CitizenQuest", 1)
            else
                toTarget(giver)
            end
        end
        return false
    end

    if progress == 1 then
        local captain = CheckNameBoss("Captain Elephant")
        if questVisible() and currentQuestTitle():find("Captain Elephant") then
            if captain then attackTarget(captain) end
        else
            local giver = CFrame.new(-12441.5908203125, 331.4884948730469, -7676.197265625)
            local _, _, root = getCharacter()
            if root and (root.Position - giver.Position).Magnitude <= 10 then
                safeInvoke("StartQuest", "CitizenQuest", 1)
            else
                toTarget(giver)
            end
        end
        return false
    end

    if progress == 2 then
        toTarget(CFrame.new(-12513.8, 336.167, -9872.91))
        safeInvoke("CitizenQuestProgress", "Citizen")
        return false
    end

    if progress == 3 then
        local kenStatus = tostring(safeInvoke("KenTalk", "Status") or "0")
        local dodges = tonumber(kenStatus:gsub("%D", "")) or 0
        if dodges < 5000 then
            local marine = DetectMob("Marine Commodore")
            if marine then
                local targetRoot = marine:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    if game:GetService("Lighting"):FindFirstChild("Blur")
                        and game:GetService("Lighting").Blur.Enabled
                    then
                        toTarget(targetRoot.CFrame * CFrame.new(0, 0, 3))
                    else
                        toTarget(targetRoot.CFrame * CFrame.new(0, 0, 50))
                        turnOnObservation()
                    end
                end
            else
                local spawnPart = findSpawnPart("Marine Commodore")
                if spawnPart then toTarget(spawnPart.CFrame * CFrame.new(0, 60, 0)) end
            end
            return false
        end

        safeInvoke("KenTalk2", "Start")
        local beli = LocalPlayer.Data:FindFirstChild("Beli")
        if beli and beli.Value >= 5000000 then
            local allFruit = true
            for _, fruitName in ipairs({"Pineapple", "Apple", "Banana"}) do
                if not collectObservationFruit(fruitName) then
                    allFruit = false
                end
            end
            if allFruit then
                safeInvoke("CitizenQuestProgress", "Citizen")
                safeInvoke("KenTalk2", "Buy")
                return true
            end
        end
    end
    return false
end

-- --------------------------------------------------------------------------
-- Aura color / Rainbow Haki
-- --------------------------------------------------------------------------

local RainbowBosses = {
    "Stone",
    "Island Empress",
    "Kilo Admiral",
    "Captain Elephant",
    "Beautiful Pirate",
}

local function rainbowQuestBoss()
    local title = currentQuestTitle()
    for _, bossName in ipairs(RainbowBosses) do
        if title:find(bossName, 1, true) then
            return bossName
        end
    end
    return nil
end

function GetRainBowHaki()
    local status = safeInvoke("HornedMan")
    if status == 1 then
        return true
    end

    local bossName = rainbowQuestBoss()
    if bossName then
        local boss = CheckNameBoss(bossName)
        if boss then
            setAction("Rainbow Haki", boss.Name)
            attackTarget(boss)
        end
        return false
    end

    local npcs = Workspace:FindFirstChild("NPCs")
    local horned = npcs and npcs:FindFirstChild("Horned Man")
    if not horned then
        local replicatedNPCs = ReplicatedStorage:FindFirstChild("NPCs")
        horned = replicatedNPCs and replicatedNPCs:FindFirstChild("Horned Man")
    end
    local root = horned and horned:FindFirstChild("HumanoidRootPart")
    if root then
        local _, _, playerRoot = getCharacter()
        if playerRoot and (playerRoot.Position - root.Position).Magnitude <= 8 then
            safeInvoke("HornedMan", "Bet")
        else
            toTarget(root.CFrame)
        end
    end
    return false
end

local function equipAuraColor(storageName)
    local remote = netRemoteFunction("RF/FruitCustomizerRF")
    if remote then
        safeRemoteInvoke("AuraColor.Equip", remote, {
            StorageName = storageName,
            Type = "AuraSkin",
            Context = "Equip",
        })
    end
    safeInvoke("activateColor", storageName)
end

local function DetectButtons()
    local map = Workspace:FindFirstChild("Map")
    local castle = map and (map:FindFirstChild("Castle on the Sea") or map:FindFirstChild("Castle"))
    local circle = castle and castle:FindFirstChild("Circle", true)
    if not circle then return nil end
    for _, object in ipairs(circle:GetChildren()) do
        local part = object:IsA("BasePart") and object or object:FindFirstChild("Part")
        if part and part:IsA("BasePart") and part.BrickColor.Name ~= "Lime green" then
            return part
        end
    end
    return nil
end

function TouchPadHaki()
    local button = DetectButtons()
    if not button then return false end

    local color = button.BrickColor.Name
    if color == "Hot pink" then
        equipAuraColor("Winter Sky")
    elseif color == "Really red" then
        equipAuraColor("Pure Red")
    elseif color == "Oyster" then
        equipAuraColor("Snow White")
    else
        return false
    end

    toTarget(button.CFrame)
    return true
end

-- --------------------------------------------------------------------------
-- Berry collection
-- --------------------------------------------------------------------------

local function getBerryPrompt(bush)
    if not bush then return nil end
    return bush:FindFirstChildWhichIsA("ProximityPrompt", true)
end

function DetectBerry()
    local _, _, root = getCharacter()
    if not root then return nil end

    local nearest, distance = nil, math.huge
    for _, bush in ipairs(CollectionService:GetTagged("BerryBush")) do
        local pivot
        if bush:IsA("Model") then pivot = bush:GetPivot().Position end
        if bush:IsA("BasePart") then pivot = bush.Position end
        if pivot and getBerryPrompt(bush) then
            local d = (pivot - root.Position).Magnitude
            if d < distance then
                nearest, distance = bush, d
            end
        end
    end
    return nearest
end

function AutoCollectBerry()
    local bush = DetectBerry()
    if not bush then
        if Settings["Hop Find Berry"] then HopServer() end
        return false
    end

    local cframe = bush:IsA("Model") and bush:GetPivot() or bush.CFrame
    toTarget(cframe)
    local prompt = getBerryPrompt(bush)
    if prompt and fireproximityprompt then
        fireproximityprompt(prompt)
        return true
    end
    return false
end

-- --------------------------------------------------------------------------
-- Fruit teleport
-- --------------------------------------------------------------------------

function AutoTeleportFruit()
    local fruit = GetPathFruit()
    if fruit then
        local handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("BasePart")
        if handle then
            setAction("Fruit", fruit.Name)
            toTarget(handle.CFrame)
            return true
        end
    elseif Settings["Teleport To Fruit [ Hop Server ]"] then
        HopServer()
    end
    return false
end

-- --------------------------------------------------------------------------
-- Kitsune island
-- --------------------------------------------------------------------------

function DetectIslandKitsune()
    local map = Workspace:FindFirstChild("Map")
    local island = map and map:FindFirstChild("KitsuneIsland")
    if not island then return nil end
    local shrine = island:FindFirstChild("ShrineDialogPart", true)
    local prompt = shrine and shrine:FindFirstChildOfClass("ProximityPrompt")
    if prompt and prompt.Enabled then
        return island
    end
    return island
end

function AutoSpawnKitsune()
    local island = DetectIslandKitsune()
    if island then
        cancelBoatTween()
        Runtime.BoatMode = false
        Runtime.FeatureStatus.Kitsune = "Island found"
        local pivot = island:IsA("Model") and island:GetPivot() or island.CFrame
        leaveBoatForCombat()
        toTarget(pivot * CFrame.new(0, 40, 0))
        return true
    end

    Runtime.FeatureStatus.Kitsune = "Searching by boat"
    local sailing = sailForSeaEvent("Find Kitsune")
    if not sailing and Settings["Hop Server Kitsune Island"] and not findBoat() then
        HopServer()
    end
    return sailing
end

-- --------------------------------------------------------------------------
-- Mirage
-- --------------------------------------------------------------------------

local function findMirage()
    local map = Workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("MysticIsland")
end

function AutoFindMirage()
    local island = findMirage()
    if island then
        cancelBoatTween()
        Runtime.BoatMode = false
        Runtime.FeatureStatus.Mirage = "Island found"
        local pivot = island:GetPivot()
        leaveBoatForCombat()
        toTarget(pivot * CFrame.new(0, 100, 0))
        if Settings["Webhook Find Mirage"] and not Runtime.MirageWebhookSent then
            Runtime.MirageWebhookSent = true
            sendWebhook("Mirage found", "Mystic Island spawned in " .. game.JobId)
        end
        return true
    end

    Runtime.MirageWebhookSent = nil
    Runtime.FeatureStatus.Mirage = "Searching by boat"
    return sailForSeaEvent("Find Mirage")
end

-- --------------------------------------------------------------------------
-- Fishing runtime (reconstructed from FishReplicated contract)
-- --------------------------------------------------------------------------

local FishReplicated = ReplicatedStorage:FindFirstChild("FishReplicated")
local FishingRequest = FishReplicated and FishReplicated:FindFirstChild("FishingRequest")
local CraftRemote = Modules and Modules:FindFirstChild("Net") and Modules.Net:FindFirstChild("RF/Craft")
local GetWaterHeightAtLocation = nil
local FishingWaterBodyTag = nil

do
    local util = ReplicatedStorage:FindFirstChild("Util")
    local waterModule = util and util:FindFirstChild("GetWaterHeightAtLocation")
    if waterModule then
        local ok, loaded = tryCall(require, waterModule)
        if ok then GetWaterHeightAtLocation = loaded end
    end
    local fishingClient = FishReplicated and FishReplicated:FindFirstChild("FishingClient")
    local configModule = fishingClient and fishingClient:FindFirstChild("Config")
    if configModule then
        local ok, config = tryCall(require, configModule)
        if ok and type(config) == "table" then
            FishingWaterBodyTag = config.WATER_BODY_TAG
        end
    end
end

local function DetectRod()
    local character = LocalPlayer.Character
    if not character then return nil end
    local rodData = character:FindFirstChild("FishingRodData", true)
    if rodData then
        return rodData.Parent
    end
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("FishingRodData", true) then
            return tool
        end
    end
    return nil
end

local function ensureFishingBait()
    local data = LocalPlayer:FindFirstChild("Data")
    local fishingData = data and data:FindFirstChild("FishingData")
    if not fishingData then
        Runtime.FeatureStatus.Fishing = "FishingData unavailable"
        return false
    end
    local current = fishingData:GetAttribute("SelectedBait")
    if current and current ~= "None" then return true end

    local bait = Settings["Select Bait"] or "Basic Bait"
    if CheckItemInventory(bait) then
        safeInvoke("LoadItem", bait, {"Usables"})
        return true
    end
    if CraftRemote then
        safeRemoteInvoke("Fishing.CraftBait", CraftRemote, "Craft", bait, 1, {})
        return CheckItemInventory(bait) ~= nil
    end
    Runtime.FeatureStatus.Fishing = "No bait and RF/Craft unavailable"
    return false
end

local function calculateFishingCast(root, rod, charge)
    local maxDistance = tonumber(rod:GetAttribute("MaxLaunchDistance")) or 100
    local alpha = 0.5 + ((tonumber(charge) or 98) / 201)
    local waterHeight = root.Position.Y
    if type(GetWaterHeightAtLocation) == "function" then
        local ok, value = tryCall(GetWaterHeightAtLocation, root.Position)
        if ok and type(value) == "number" then waterHeight = value end
    end

    local character = LocalPlayer.Character
    local head = character and character:FindFirstChild("Head")
    local origin = head and head.Position or root.Position
    local direction = root.CFrame.LookVector * maxDistance * alpha
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character}

    local forwardHit = Workspace:Raycast(origin, direction, params)
    local horizontalPoint = forwardHit and forwardHit.Position or (origin + direction)
    local downHit = Workspace:Raycast(horizontalPoint + Vector3.new(0, 3, 0), Vector3.new(0, -500, 0), params)
    local groundY = downHit and downHit.Position.Y or waterHeight
    local target = Vector3.new(horizontalPoint.X, math.max(groundY, waterHeight), horizontalPoint.Z)

    local validWater = target.Y <= waterHeight + 0.05
    if downHit and FishingWaterBodyTag then
        validWater = CollectionService:HasTag(downHit.Instance, FishingWaterBodyTag) or validWater
    end
    return target, validWater
end

function AutoFishing()
    if not FishingRequest then
        Runtime.FeatureStatus.Fishing = "FishReplicated.FishingRequest unavailable"
        return false
    end
    if not ensureFishingBait() then return false end

    local character, _, root = getCharacter()
    local rod = DetectRod()
    if not character or not root then return false end
    if not rod then
        Runtime.FeatureStatus.Fishing = "Equip/load a fishing rod"
        return false
    end

    local state = rod:GetAttribute("ServerState")
    Runtime.FeatureStatus.Fishing = state or "Ready"
    if state == "Biting" then
        return true
    end
    if state ~= nil and state ~= "ReeledIn" then
        return true
    end

    local startedOk = safeCall("Fishing.StartCasting", function()
        return FishingRequest:InvokeServer("StartCasting")
    end)
    if not startedOk then return false end

    task.wait(0.7)
    local castPosition, valid = calculateFishingCast(root, rod, 98)
    local castOk = safeCall("Fishing.CastLineAtLocation", function()
        return FishingRequest:InvokeServer("CastLineAtLocation", castPosition, 98, valid)
    end)
    return castOk
end

-- --------------------------------------------------------------------------
-- Dungeon basic runtime
-- --------------------------------------------------------------------------

function AutoJoinDungeon()
    local pad = DetectPadJoinDungeon(Settings["Account Start Dungeon"] == true)
    if not pad then return false end
    local hitbox = pad:FindFirstChild("Hitbox") or pad:FindFirstChildWhichIsA("BasePart", true)
    if hitbox then
        toTarget(hitbox.CFrame * CFrame.new(0, -2, 0))
        return true
    end
    return false
end

function AutoAttackDungeon()
    local enemies = Workspace:FindFirstChild("Enemies")
    local target = enemies and DetectMobDungeon(enemies)
    if target then
        local previous = Settings["Select Weapon"]
        Settings["Select Weapon"] = Settings["Select Weapon Dungeon"] or previous
        attackTarget(target)
        Settings["Select Weapon"] = previous
        return true
    end
    return false
end

-- --------------------------------------------------------------------------
-- V4 trial basic mechanics
-- --------------------------------------------------------------------------

local function trialLocation(name)
    local origin = Workspace:FindFirstChild("_WorldOrigin")
    local locations = origin and origin:FindFirstChild("Locations")
    return locations and locations:FindFirstChild(name)
end

local function findTrialMob(locationName)
    local location = trialLocation(locationName)
    local enemies = Workspace:FindFirstChild("Enemies")
    if not location or not enemies then return nil end
    for _, mob in ipairs(enemies:GetChildren()) do
        if isAlive(mob) and (mob.HumanoidRootPart.Position - location.Position).Magnitude <= 1000 then
            return mob
        end
    end
    return nil
end

function AutoTrialV4()
    local raceValue = LocalPlayer.Data and LocalPlayer.Data:FindFirstChild("Race")
    local race = raceValue and raceValue.Value or ""

    if race == "Human" then
        local mob = findTrialMob("Trial of Strength")
        if mob then attackTarget(mob) end
    elseif race == "Ghoul" then
        local mob = findTrialMob("Trial of Carnage")
        if mob then attackTarget(mob) end
    elseif race == "Fishman" then
        local seaBeast = DetectSeaEvents()
        if seaBeast then AutoSeabeast() end
    elseif race == "Mink" then
        local endPart = findDescendant(Workspace, "EndPart")
        if endPart and endPart:IsA("BasePart") then toTarget(endPart.CFrame) end
    elseif race == "Skypiea" or race == "Angel" then
        local finish = findDescendant(Workspace, "Finish")
        if finish and finish:IsA("BasePart") then toTarget(finish.CFrame) end
    elseif race == "Cyborg" then
        local trial = trialLocation("Trial of the King")
        if trial then toTarget(trial.CFrame) end
    end

    if Settings["Auto Turn On V3 Near Door"] then
        turnOnRaceV3()
    end
    return true
end

-- --------------------------------------------------------------------------
-- TTK / legendary sword
-- --------------------------------------------------------------------------

local LegendarySwords = {"Shisui", "Saddi", "Wando"}

function AutoBuyLegendarySword()
    local result = safeInvoke("LegendarySwordDealer", "1")
    if result ~= nil then
        safeInvoke("LegendarySwordDealer", "2")
        safeInvoke("LegendarySwordDealer", "3")
    end
    return true
end

function AutoTTK()
    local owned = 0
    for _, sword in ipairs(LegendarySwords) do
        if CheckItemInventory(sword) then owned += 1 end
    end
    if owned < 3 then
        AutoBuyLegendarySword()
        if Settings["Hop Server [ Haki color or Legendary Sword]"] then HopServer() end
        return false
    end

    local response = safeInvoke("MysteriousMan", "2")
    if response ~= nil then
        safeInvoke("MysteriousMan", "1")
    end
    return CheckItemInventory("True Triple Katana") ~= nil
end

-- --------------------------------------------------------------------------
-- Fruit awakening / Law raid
-- --------------------------------------------------------------------------

function AutoAwakeFruit()
    local awakening = safeInvoke("Awakener", "Check")
    if awakening ~= nil then
        safeInvoke("Awakener", "Awaken")
        return true
    end
    return false
end

function AutoLawRaid()
    if not DetectItemPlr("Microchip") then
        safeInvoke("BlackbeardReward", "Microchip", "2")
        safeInvoke("BlackbeardReward", "Microchip", "1")
    end

    local map = Workspace:FindFirstChild("Map")
    local lab = map and map:FindFirstChild("CircleIsland")
    local button = lab and lab:FindFirstChild("OrderSummoner", true)
    local click = button and button:FindFirstChildWhichIsA("ClickDetector", true)
    if click and fireclickdetector then
        fireclickdetector(click)
    end

    local order = CheckNameBoss("Order")
    if order then attackTarget(order) end
    return order ~= nil
end

-- --------------------------------------------------------------------------
-- Local player / FPS
-- --------------------------------------------------------------------------

local function applyLocalPlayerSettings()
    local character, humanoid = getCharacter()
    if not character or not humanoid then return end

    if Settings["Change WalkSpeed"] then
        humanoid.WalkSpeed = tonumber(Settings["Input WalkSpeed"]) or 200
    end
    if Settings["Change JumpPower"] then
        humanoid.JumpPower = tonumber(Settings["Input JumpPower"]) or 200
    end
end

local function fpsBoost()
    if not Settings["Boost Fps"] then return end
    tryCall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("ParticleEmitter")
            or object:IsA("Trail")
            or object:IsA("Smoke")
            or object:IsA("Fire")
            or object:IsA("Sparkles")
        then
            object.Enabled = false
        end
    end
end

-- --------------------------------------------------------------------------
-- Simple ESP
-- --------------------------------------------------------------------------

local ESPObjects = {}

local function clearESP(key)
    local item = ESPObjects[key]
    if item then
        tryCall(function() item:Destroy() end)
        ESPObjects[key] = nil
    end
end

local function ensureESP(instance, text)
    if ESPObjects[instance] and ESPObjects[instance].Parent then
        ESPObjects[instance].TextLabel.Text = text
        return
    end

    local adorn = instance:IsA("BasePart") and instance or instance:FindFirstChildWhichIsA("BasePart", true)
    if not adorn then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BananaReadableESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(200, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = adorn
    billboard.Parent = adorn

    local label = Instance.new("TextLabel")
    label.Name = "TextLabel"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Text = text
    label.TextScaled = true
    label.Parent = billboard

    ESPObjects[instance] = billboard
end

function UpdateESP()
    local active = {}
    local function mark(instance, text)
        if instance then
            active[instance] = true
            ensureESP(instance, text)
        end
    end

    if Settings["ESP Fruit"] then
        for _, object in ipairs(Workspace:GetChildren()) do
            if object:IsA("Tool") and object.Name:find("Fruit") then
                mark(object, object.Name)
            end
        end
    end

    if Settings["ESP Player"] then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                mark(player.Character, player.Name)
            end
        end
    end

    if Settings["ESP Island"] then
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, island in ipairs(map:GetChildren()) do
                if island:IsA("Model") then
                    mark(island, island.Name)
                end
            end
        end
    end

    for instance in pairs(ESPObjects) do
        if not active[instance] or not instance.Parent then
            clearESP(instance)
        end
    end
end


-- --------------------------------------------------------------------------
-- Kaitun progression / stats / fighting styles
-- --------------------------------------------------------------------------

local FightingStylePurchaseRoutes = {
    {Name = "Black Leg", Buy = function() return safeInvoke("BuyBlackLeg") end},
    {Name = "Electro", Buy = function() return safeInvoke("BuyElectro") end},
    {Name = "Fishman Karate", Buy = function() return safeInvoke("BuyFishmanKarate") end},
    {Name = "Dragon Claw", Buy = function()
        safeInvoke("BlackbeardReward", "DragonClaw", "1")
        return safeInvoke("BlackbeardReward", "DragonClaw", "2")
    end},
    {Name = "Superhuman", Buy = function() return safeInvoke("BuySuperhuman") end},
    {Name = "Death Step", Buy = function()
        local check = safeInvoke("BuyDeathStep", true)
        if check == 1 then return safeInvoke("BuyDeathStep") end
        return check
    end},
    {Name = "Sharkman Karate", Buy = function()
        local check = safeInvoke("BuySharkmanKarate", true)
        if check == 1 or check == true then return safeInvoke("BuySharkmanKarate") end
        return check
    end},
    {Name = "Electric Claw", Buy = function()
        local check = safeInvoke("BuyElectricClaw", true)
        if check ~= 4 then return safeInvoke("BuyElectricClaw") end
        return check
    end},
    {Name = "Dragon Talon", Buy = function()
        local check = safeInvoke("BuyDragonTalon", true)
        if check == 1 or check == true then return safeInvoke("BuyDragonTalon") end
        return check
    end},
    {Name = "Godhuman", Buy = function() return safeInvoke("BuyGodhuman") end},
    {Name = "Sanguine Art", Buy = function()
        local check = safeInvoke("BuySanguineArt", true)
        if check == 1 or check == true then return safeInvoke("BuySanguineArt") end
        return check
    end},
}

local FightingStyleByName = {}
for _, style in ipairs(FightingStylePurchaseRoutes) do
    FightingStyleByName[style.Name] = style
end

local function meleeInventorySnapshot()
    local snapshot = {}
    for _, item in ipairs(readInventory()) do
        if type(item) == "table" then
            local name = item.Name or item.name
            local itemType = item.Type or item.type
            if name and (itemType == "Melee" or FightingStyleByName[name]) then
                snapshot[name] = tonumber(item.Mastery or item.mastery or item.Level or item.level) or 0
            end
        end
    end

    for _, container in ipairs({LocalPlayer.Character, LocalPlayer:FindFirstChild("Backpack")}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == "Melee" or FightingStyleByName[tool.Name]) then
                    local level = tool:FindFirstChild("Level")
                    snapshot[tool.Name] = math.max(snapshot[tool.Name] or 0, level and tonumber(level.Value) or 0)
                end
            end
        end
    end
    return snapshot
end

local function meleeMastery(name, snapshot)
    snapshot = snapshot or meleeInventorySnapshot()
    return tonumber(snapshot[name]) or 0
end

local function meleeOwned(name, snapshot)
    snapshot = snapshot or meleeInventorySnapshot()
    return snapshot[name] ~= nil
end

local function invokeMeleePurchase(style)
    if not style or type(style.Buy) ~= "function" then return nil end
    local ok, result = safeCall("Melee.Buy." .. style.Name, style.Buy)
    Runtime.InventoryCacheAt = 0
    Runtime.FeatureStatus.MeleePurchase = style.Name .. " -> " .. tostring(result)
    return ok and result or nil
end

local function ensureMeleeEquipped(name)
    if not name then return false end
    local character = LocalPlayer.Character
    local tool = (character and character:FindFirstChild(name)) or LocalPlayer.Backpack:FindFirstChild(name)
    if not tool then
        -- The original Banana 600-mastery loop re-invokes the style purchase
        -- remote when an owned style is not currently materialized as a Tool.
        invokeMeleePurchase(FightingStyleByName[name])
        task.wait(0.1)
        character = LocalPlayer.Character
        tool = (character and character:FindFirstChild(name)) or LocalPlayer.Backpack:FindFirstChild(name)
    end
    if tool then
        equiptool(name)
        return true
    end
    return false
end

local MeleeUnlockPlan = {
    -- Buy the four prerequisite styles first. Mastery is not trained until the
    -- account is in the sea where the next style can actually be obtained and
    -- has the required currency for that unlock.
    {
        Unlock = "Superhuman", MinSea = 2, Beli = 3000000, Fragments = 0,
        Requires = {
            {"Black Leg", 300},
            {"Electro", 300},
            {"Fishman Karate", 300},
            {"Dragon Claw", 300},
        },
    },
    {
        Unlock = "Death Step", MinSea = 2, Beli = 2500000, Fragments = 5000,
        Requires = {{"Black Leg", 400}},
    },
    {
        Unlock = "Sharkman Karate", MinSea = 2, Beli = 2500000, Fragments = 5000,
        Requires = {{"Fishman Karate", 400}},
    },
    {
        Unlock = "Electric Claw", MinSea = 3, Beli = 3000000, Fragments = 5000,
        Requires = {{"Electro", 400}},
    },
    {
        Unlock = "Dragon Talon", MinSea = 3, Beli = 3000000, Fragments = 5000,
        Requires = {{"Dragon Claw", 400}},
    },
    {
        Unlock = "Godhuman", MinSea = 3, Beli = 5000000, Fragments = 5000,
        Requires = {
            {"Superhuman", 400},
            {"Death Step", 400},
            {"Sharkman Karate", 400},
            {"Electric Claw", 400},
            {"Dragon Talon", 400},
        },
    },
}

local function currentBeli()
    local data = LocalPlayer:FindFirstChild("Data")
    local beli = data and data:FindFirstChild("Beli")
    return beli and tonumber(beli.Value) or 0
end

local function currentFragments()
    local data = LocalPlayer:FindFirstChild("Data")
    local fragments = data and (data:FindFirstChild("Fragments") or data:FindFirstChild("Fragment"))
    return fragments and tonumber(fragments.Value) or 0
end

local function unlockCurrencyReady(plan)
    if getSea() < (plan.MinSea or 1) then
        return false
    end
    if currentBeli() < (plan.Beli or 0) then
        return false
    end
    if currentFragments() < (plan.Fragments or 0) then
        return false
    end
    return true
end

local function chooseRequiredMeleeForUnlock(snapshot)
    snapshot = snapshot or meleeInventorySnapshot()

    for _, plan in ipairs(MeleeUnlockPlan) do
        if not meleeOwned(plan.Unlock, snapshot) and unlockCurrencyReady(plan) then
            local ownsAllRequirements = true
            for _, requirement in ipairs(plan.Requires) do
                if not meleeOwned(requirement[1], snapshot) then
                    ownsAllRequirements = false
                    break
                end
            end

            if ownsAllRequirements then
                for _, requirement in ipairs(plan.Requires) do
                    local styleName, neededMastery = requirement[1], requirement[2]
                    local mastery = meleeMastery(styleName, snapshot)
                    if mastery < neededMastery then
                        return styleName, neededMastery, plan.Unlock
                    end
                end
            end
        end
    end

    return nil, nil, nil
end

local function chooseMelee600Target(snapshot)
    snapshot = snapshot or meleeInventorySnapshot()
    local cap = tonumber(Settings["Melee Mastery Target"]) or 600
    for _, style in ipairs(FightingStylePurchaseRoutes) do
        if meleeOwned(style.Name, snapshot) and meleeMastery(style.Name, snapshot) < cap then
            return style.Name, cap
        end
    end
    return nil, cap
end

local function getStatPoints()
    local data = LocalPlayer:FindFirstChild("Data")
    if not data then return 0 end
    local points = data:FindFirstChild("Points") or data:FindFirstChild("Point")
    return points and tonumber(points.Value) or 0
end

local function getStatLevel(statName)
    local data = LocalPlayer:FindFirstChild("Data")
    local stats = data and data:FindFirstChild("Stats")
    local stat = stats and stats:FindFirstChild(statName)
    if stat then
        local level = stat:FindFirstChild("Level")
        if level then return tonumber(level.Value) or 0 end
        if stat:IsA("ValueBase") then return tonumber(stat.Value) or 0 end
    end
    local direct = data and data:FindFirstChild(statName)
    return direct and tonumber(direct.Value) or 0
end

function AutoStats()
    local points = getStatPoints()
    if points <= 0 then return false end

    local levelCap = tonumber(Workspace:GetAttribute("LEVEL_CAP")) or 2800
    local statCap = tonumber(Workspace:GetAttribute("STAT_CAP")) or levelCap
    local batch = math.min(points, tonumber(Settings["Stat Batch"]) or 100)

    local melee = getStatLevel("Melee")
    local defense = getStatLevel("Defense")
    local fruit = getStatLevel("Demon Fruit")
    local sword = getStatLevel("Sword")
    local gun = getStatLevel("Gun")

    local current = {
        ["Melee"] = melee,
        ["Defense"] = defense,
        ["Demon Fruit"] = fruit,
        ["Sword"] = sword,
        ["Gun"] = gun,
    }

    -- Explicit priority remains supported for custom builds. When omitted,
    -- preserve the kaitun's intended 70/30 Melee/Defense distribution instead
    -- of filling Melee to cap before Defense receives any points.
    local priority = Settings["Auto Stats Priority"]
    if type(priority) == "table" and #priority > 0 then
        for _, statName in ipairs(priority) do
            local value = current[statName] or 0
            if value < statCap and points > 0 then
                local add = math.min(batch, statCap - value, points)
                if add > 0 then
                    safeInvoke("AddPoint", statName, add)
                    return true
                end
            end
        end
        return false
    end

    local meleePercent = math.clamp(tonumber(Settings["Auto Stats Melee Percent"]) or 70, 0, 100)
    local defensePercent = math.clamp(tonumber(Settings["Auto Stats Defense Percent"]) or 30, 0, 100)
    local weightTotal = meleePercent + defensePercent
    if weightTotal <= 0 then
        meleePercent, defensePercent, weightTotal = 70, 30, 100
    end

    local combined = melee + defense
    local desiredMelee = (combined + points) * (meleePercent / weightTotal)
    local desiredDefense = (combined + points) * (defensePercent / weightTotal)
    local meleeDeficit = desiredMelee - melee
    local defenseDeficit = desiredDefense - defense

    local statName
    if melee >= statCap then
        statName = "Defense"
    elseif defense >= statCap then
        statName = "Melee"
    elseif meleeDeficit >= defenseDeficit then
        statName = "Melee"
    else
        statName = "Defense"
    end

    local value = current[statName] or 0
    local add = math.min(batch, statCap - value, points)
    if add > 0 then
        safeInvoke("AddPoint", statName, add)
        return true
    end
    return false
end

local ImmediateMeleePurchaseRules = {
    ["Black Leg"] = {MinSea = 1, Beli = 150000, Fragments = 0},
    ["Electro"] = {MinSea = 1, Beli = 500000, Fragments = 0},
    ["Fishman Karate"] = {MinSea = 1, Beli = 750000, Fragments = 0},
    ["Dragon Claw"] = {MinSea = 2, Beli = 0, Fragments = 1500},
}

local function purchaseRuleReady(rule)
    if not rule then return true end
    return getSea() >= (rule.MinSea or 1)
        and currentBeli() >= (rule.Beli or 0)
        and currentFragments() >= (rule.Fragments or 0)
end

local function requiredMasteriesMet(plan, snapshot)
    for _, requirement in ipairs(plan.Requires or {}) do
        if not meleeOwned(requirement[1], snapshot)
            or meleeMastery(requirement[1], snapshot) < requirement[2]
        then
            return false
        end
    end
    return true
end

local function immediateMeleePurchaseCandidate(snapshot)
    snapshot = snapshot or meleeInventorySnapshot()

    -- First Sea / basic purchases: reserve Beli only when the account can buy
    -- that style right now. Do not reserve money just to grind mastery later.
    for _, name in ipairs({"Black Leg", "Electro", "Fishman Karate", "Dragon Claw"}) do
        local rule = ImmediateMeleePurchaseRules[name]
        if not meleeOwned(name, snapshot) and purchaseRuleReady(rule) then
            return true, name, rule.Beli or 0
        end
    end

    -- Superhuman has no key/material gate. Once its four mastery requirements
    -- are already met and the currency is present, keep gacha from spending it.
    for _, plan in ipairs(MeleeUnlockPlan) do
        if plan.Unlock == "Superhuman"
            and not meleeOwned(plan.Unlock, snapshot)
            and unlockCurrencyReady(plan)
            and requiredMasteriesMet(plan, snapshot)
        then
            return true, plan.Unlock, plan.Beli or 0
        end
    end

    return false
end
Runtime.ShouldReserveForMelee = immediateMeleePurchaseCandidate

local function tryBuyEveryMissingMelee(snapshot)
    snapshot = snapshot or meleeInventorySnapshot()
    Runtime.MeleePurchaseAt = Runtime.MeleePurchaseAt or {}
    local attempted = false
    local now = os.clock()

    -- BUY-FIRST policy: every missing style gets its own cooldown. A failed
    -- advanced style never blocks another style that is already purchasable.
    for _, style in ipairs(FightingStylePurchaseRoutes) do
        if not meleeOwned(style.Name, snapshot) then
            local lastAttempt = Runtime.MeleePurchaseAt[style.Name] or 0
            if now - lastAttempt >= 2.0 then
                local basicRule = ImmediateMeleePurchaseRules[style.Name]
                if basicRule == nil or purchaseRuleReady(basicRule) then
                    Runtime.MeleePurchaseAt[style.Name] = now
                    invokeMeleePurchase(style)
                    attempted = true
                end
            end
        end
    end

    if attempted then
        Runtime.InventoryCacheAt = 0
    end
    return attempted
end

function AutoBuyFightingStyles()
    local snapshot = meleeInventorySnapshot()
    local attempted = tryBuyEveryMissingMelee(snapshot)

    -- Refresh after purchases. If something was buyable, it should now appear
    -- in inventory before deciding whether any mastery is actually required.
    if attempted then
        task.wait(0.05)
        snapshot = meleeInventorySnapshot()
    end

    local target, neededMastery, unlockName = chooseRequiredMeleeForUnlock(snapshot)
    if target then
        Runtime.RequiredMeleeTraining = {
            Style = target,
            Mastery = neededMastery,
            Unlock = unlockName,
        }
        Settings["Preferred Melee"] = target
        Settings["Select Weapon"] = "Melee"
        ensureMeleeEquipped(target)
        Runtime.FeatureStatus.MeleeProgression =
            ("Need %s %d/%d for %s"):format(
                target,
                meleeMastery(target, snapshot),
                neededMastery,
                unlockName
            )
        return true
    end

    Runtime.RequiredMeleeTraining = nil
    if Settings["Auto Farm Mastery 600 Melees"] ~= true then
        Settings["Preferred Melee"] = nil
    end

    Runtime.FeatureStatus.MeleeProgression =
        attempted and "Buying available melee; no mastery grind"
        or "Waiting for next melee requirement; no mastery grind"
    return attempted
end

function AutoFarmMeleeMastery600()
    -- Explicit 600-mastery mode remains available, but it never overrides a
    -- mastery requirement that the unlock manager is actively working on.
    if Runtime.RequiredMeleeTraining then
        return false
    end

    local snapshot = meleeInventorySnapshot()
    local target, cap = chooseMelee600Target(snapshot)
    if not target then
        Settings["Preferred Melee"] = nil
        Runtime.FeatureStatus.MeleeMastery600 = "All owned melee at target mastery"
        return false
    end

    Settings["Preferred Melee"] = target
    Settings["Select Weapon"] = "Melee"
    ensureMeleeEquipped(target)
    Runtime.FeatureStatus.MeleeMastery600 =
        ("Training %s %d/%d"):format(target, meleeMastery(target, snapshot), cap)
    return true
end

local function toolMastery(tool)
    if not tool then return 0 end
    local level = tool:FindFirstChild("Level")
    return level and tonumber(level.Value) or 0
end

local function findToolByType(toolType)
    local best, bestMastery = nil, math.huge
    for _, container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and tool.ToolTip == toolType then
                    local mastery = toolMastery(tool)
                    if mastery < bestMastery then
                        best, bestMastery = tool, mastery
                    end
                end
            end
        end
    end
    return best, bestMastery
end

function AutoFarmWeaponMastery(toolType)
    local tool, mastery = findToolByType(toolType)
    if not tool then return false end
    if mastery >= 600 then return true end
    Settings["Select Weapon"] = toolType
    equiptool(tool.Name)
    if not Settings["Start Farm"] then
        FarmMethod()
    end
    return false
end

-- --------------------------------------------------------------------------
-- Bone / event currencies
-- --------------------------------------------------------------------------

local BoneMobs = {
    "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy",
    "Possessed Mummy", "Evil Wraith", "Bone Wraith",
}

function AutoCollectBone()
    local mob = DetectMob(BoneMobs)
    if mob then
        setAction("Bones", mob.Name)
        attackTarget(mob)
        return true
    end

    local origin = Workspace:FindFirstChild("_WorldOrigin")
    local spawns = origin and origin:FindFirstChild("EnemySpawns")
    if spawns then
        for _, spawnPart in ipairs(spawns:GetChildren()) do
            if nameMatches(spawnPart.Name, BoneMobs) and spawnPart:IsA("BasePart") then
                toTarget(spawnPart.CFrame * CFrame.new(0, 35, 0))
                return false
            end
        end
    end
    return false
end

function AutoTradeBone()
    local bones = CheckCountItem("Bones", 50)
    if not bones then return false end
    local result = safeInvoke("Bones", "Buy", 1, 1)
    if result == nil then result = safeInvoke("Bones", "Buy", 1) end
    return result ~= nil
end

function AutoTradeAzureEmber()
    local wanted = tonumber(Settings["Values Azure Ember"]) or 10
    if not CheckCountItem("Azure Ember", wanted) then return false end
    local remote = netRemoteFunction("RF/KitsuneStatuePray")
    if remote then
        return safeRemoteInvoke("AzureEmber.Trade", remote) ~= nil
    end
    return safeInvoke("KitsuneStatuePray") ~= nil
end

-- --------------------------------------------------------------------------
-- Summon / attack raid bosses
-- --------------------------------------------------------------------------

local function attackNamedBoss(settingName, bossNames)
    if not Settings[settingName] then return false end
    local boss = CheckNameBoss(bossNames)
    if not boss then return false end
    setAction(settingName, boss.Name)
    attackTarget(boss)
    return true
end

function AutoSummonBosses()
    if Settings["Summon Darkbeard"] then summonDarkbeard() end
    if Settings["Auto Summon Rip Indra"] then summonRipIndra() end
    if Settings["Summon Soul Reaper"] then summonSoulReaper() end

    attackNamedBoss("Attack Darkbeard", {"Darkbeard", "Darkbeard [Lv. 1000] [Raid Boss]"})
    attackNamedBoss("Attack Rip Indra", {"rip_indra True Form", "rip_indra"})
    attackNamedBoss("Attack Soul Reaper", {"Soul Reaper"})
    attackNamedBoss("Attack Dough King", {"Dough King"})
    return true
end

-- --------------------------------------------------------------------------
-- Dark Dagger / Yoru Mini orchestration
-- --------------------------------------------------------------------------

local LegendaryAuraNames = {"Pure Red", "Snow White", "Winter Sky"}

local function missingLegendaryAuraColors()
    local colors = safeInvoke("getColors")
    if type(colors) ~= "table" then return LegendaryAuraNames end
    local missing = {}
    for _, wanted in ipairs(LegendaryAuraNames) do
        local unlocked = false
        for _, data in pairs(colors) do
            if type(data) == "table"
                and (data.HiddenName == wanted or data.Name == wanted)
                and data.Unlocked
            then
                unlocked = true
                break
            end
        end
        if not unlocked then table.insert(missing, wanted) end
    end
    return missing
end

function AutoYorumini()
    if CheckItemInventory("Dark Dagger") then
        return true
    end

    local indra = CheckNameBoss({"rip_indra True Form", "rip_indra"})
    if indra then
        setAction("Dark Dagger", indra.Name)
        attackTarget(indra)
        return false
    end

    if DetectItemPlr("God's Chalice") then
        local missing = missingLegendaryAuraColors()
        if #missing == 0 then
            summonRipIndra()
        else
            TouchPadHaki()
        end
        return false
    end

    local elite = DetectEliteHunter()
    if elite then
        AutoEliteHunter()
        return false
    end

    if AutoChest() then
        Runtime.YoruChestCount = (Runtime.YoruChestCount or 0) + 1
        return false
    end

    local hopAt = tonumber(Settings["Value Collect Chest to Hop"]) or 20
    if Settings["Auto Yoru Mini (Hop Server)"] and (Runtime.YoruChestCount or 0) >= hopAt then
        Runtime.YoruChestCount = 0
        HopServer()
    end
    return false
end

-- --------------------------------------------------------------------------
-- V4 / Draco full orchestration
-- --------------------------------------------------------------------------

function FullyDraco()
    local raceValue = LocalPlayer.Data and LocalPlayer.Data:FindFirstChild("Race")
    local race = raceValue and raceValue.Value or ""

    if race ~= "Draco" then
        -- Dragon Wizard progression first. It may unlock Draco or return quest
        -- state depending on current game version.
        AutoUpgradeRaceDraco()
        if Settings["Auto Quest Dragon Hunter"] then AutoDragonHunter() end
        if Settings["Auto Crafting Volcanic Magnet"] then AutoCraftinMagnetVol() end
        return false
    end

    if Settings["Auto Finish Train Draco Quest"] then
        QuestDojoTrainer()
    end

    if Settings["Auto Trial Draco"] or Settings["Fully Trial Draco"] then
        AutoTrialV4()
    end

    if Settings["Auto Choose Gears"] then ChooseGearV4() end
    if Settings["Auto Buy Gear Draco"] or Settings["Auto Buy Gear"] then BuyGearV4() end

    AutoUpgradeRaceDraco()
    return false
end

-- --------------------------------------------------------------------------
-- Haki colors / item shop helpers
-- --------------------------------------------------------------------------

function AutoBuyHakiColor()
    local result = safeInvoke("ColorsDealer", "1")
    if result ~= nil then return true end
    result = safeInvoke("ColorsDealer", "2")
    return result ~= nil
end

local BasicAbilityRoutes = {
    {"BuyHaki", "Geppo"}, {"BuyHaki", "Buso"}, {"BuyHaki", "Soru"},
    {"KenTalk", "Buy"},
}

function AutoBuyBasicProgression()
    local progressed = AutoBuyFightingStyles()
    if Settings["Auto Buy Basic Abilities"] == true then
        local reserve = Runtime.ShouldReserveForMelee and Runtime.ShouldReserveForMelee()
        if not reserve then
            for _, route in ipairs(BasicAbilityRoutes) do
                safeInvoke(table.unpack(route))
            end
        end
    end
    return progressed
end

-- --------------------------------------------------------------------------
-- Weapon upgrade runtime
-- --------------------------------------------------------------------------

local function findToolByName(name)
    local character = LocalPlayer.Character
    return (character and character:FindFirstChild(name)) or LocalPlayer.Backpack:FindFirstChild(name)
end

local function loadToolForUpgrade(name)
    local tool = findToolByName(name)
    if tool then return tool end
    safeInvoke("LoadItem", name)
    task.wait(0.2)
    return findToolByName(name)
end

local function getUpgradeInfo(tool)
    if not tool then return nil end
    local info = safeInvoke("UpgradeItem", "Check", tool)
    if type(info) ~= "table" then
        Runtime.FeatureStatus.WeaponUpgrade = "UpgradeItem Check unavailable"
        return nil
    end
    return info
end

local function firstMissingUpgradeMaterial(info)
    local required = info and info.Required
    if type(required) ~= "table" then return nil end
    for _, requirement in pairs(required) do
        if type(requirement) == "table" and requirement.Name then
            local amount = tonumber(requirement.Required or requirement.Count or 1) or 1
            if not CheckCountItem(requirement.Name, amount) then
                return requirement.Name, amount
            end
        end
    end
    return nil
end

local function upgradeInventoryTool(toolType)
    for _, item in ipairs(readInventory()) do
        if type(item) == "table" and item.Type == toolType and item.Upgraded ~= true and item.Name then
            local tool = loadToolForUpgrade(item.Name)
            if tool then
                local info = getUpgradeInfo(tool)
                if info then
                    local missing, amount = firstMissingUpgradeMaterial(info)
                    if missing then
                        Runtime.FeatureStatus.WeaponUpgrade = ("Need %s x%d"):format(missing, amount)
                        if materialMobNames(missing) then
                            Settings["Select Material"] = missing
                            Settings["Farm Material"] = true
                            Runtime.MaterialRequestedByUpgrade = true
                        end
                        return false
                    end

                    -- The dump preserves UpgradeItem/Check exactly; the action branch lost
                    -- its argument during decompilation. Use one deterministic counterpart
                    -- instead of probing multiple unrelated remotes.
                    local actionOk, result = safeCall("WeaponUpgrade.Action", function()
                        return CommF:InvokeServer("UpgradeItem", "Upgrade", tool)
                    end)
                    if actionOk then
                        Runtime.FeatureStatus.WeaponUpgrade = "Upgrade requested: " .. item.Name
                        if Runtime.MaterialRequestedByUpgrade then
                            Settings["Farm Material"] = false
                            Runtime.MaterialRequestedByUpgrade = nil
                        end
                        return true, result
                    end
                    Runtime.FeatureStatus.WeaponUpgrade = "Upgrade action rejected for " .. item.Name
                    return false
                end
            end
        end
    end
    Runtime.FeatureStatus.WeaponUpgrade = "No pending " .. tostring(toolType) .. " upgrade"
    return false
end

function AutoUpgradeWeapon(toolType)
    return upgradeInventoryTool(toolType)
end

-- --------------------------------------------------------------------------
-- Fruit shop sniper
-- --------------------------------------------------------------------------

function BuyBloxFruitSniper()
    local wanted = Settings["Fruit"] or Settings["Select Fruit"] or Settings["Blox Fruit Sniper"]
    if type(wanted) ~= "table" then return false end
    local fruits = safeInvoke("GetFruits")
    if type(fruits) ~= "table" then return false end

    for _, fruit in pairs(fruits) do
        if type(fruit) == "table" and fruit.Name and fruit.OnSale and wanted[fruit.Name] then
            local result = safeInvoke("PurchaseRawFruit", fruit.Name)
            if result ~= nil then return true end
        end
    end
    return false
end


-- ============================================================================
-- 15. SERVER HOP / REJOIN / WEBHOOK
-- ============================================================================

local visitedServers = {}

function HopServer()
    local ok, data = safeCall("ServerBrowser.List", function()
        return ReplicatedStorage.__ServerBrowser:InvokeServer(1)
    end)
    if not ok or type(data) ~= "table" then
        return false
    end

    for jobId, server in pairs(data) do
        local count = type(server) == "table" and server.Count or nil
        if jobId ~= game.JobId and not visitedServers[jobId] and (not count or count < 12) then
            visitedServers[jobId] = true
            safeCall("ServerBrowser.Teleport", function()
                ReplicatedStorage.__ServerBrowser:InvokeServer("teleport", jobId)
            end)
            return true
        end
    end
    return false
end

local function rejoinIfDisconnected()
    local coreGui = game:GetService("CoreGui")
    local promptGui = coreGui:FindFirstChild("RobloxPromptGui")
    local overlay = promptGui and promptGui:FindFirstChild("promptOverlay")
    if overlay and overlay:FindFirstChild("ErrorPrompt") then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end

sendWebhook = function(title, description)
    local url = Settings["Input Url Webhook"]
    if type(url) ~= "string" or url == "" then return false end
    local requestFunction = request or http_request or (syn and syn.request)
    if not requestFunction then return false end

    local payload = {
        username = "Banana Rebuild",
        embeds = {{
            title = tostring(title),
            description = tostring(description),
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }},
    }
    local ok = safeCall("Webhook", function()
        requestFunction({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload),
        })
    end)
    return ok
end

-- ============================================================================
-- 16. FEATURE SCHEDULER
-- ============================================================================

-- Active-task arbitration. Banana's original root CFG serialized many of
-- these actions; running every reconstructed loop concurrently causes movement
-- races (farm tween fighting Saber/Raid/Sea/quest tweens). Keep passive helpers
-- concurrent, but pause level farm while a higher-priority active task is
-- actually requested and unfinished.
local function currentRaceName()
    local data = LocalPlayer:FindFirstChild("Data")
    local race = data and data:FindFirstChild("Race")
    return race and tostring(race.Value) or ""
end

local function determinePriorityTask()
    if Settings["Priority Tasks Preempt Farm"] == false then
        return nil, nil
    end

    if Settings["Auto Sea Event"] or Settings["Auto Find Leviathan"] or Settings["Auto Attack Leviathan"] then
        return "Sea", "Sea event / Leviathan"
    end
    if Settings["Auto Find Prehistoric Island"] or Settings["Fully Event Prehistoric Island"] then
        return "Prehistoric", "Prehistoric event"
    end
    if Settings["Auto Spawn Kitsune Island"] or Settings["Auto Find Mirage"] then
        return "SeaSearch", "Kitsune / Mirage search"
    end
    if Settings["Auto Raid"] or Settings["Auto Multi Raid"] or Settings["Auto Attack Dungeon"] or Settings["Auto Join Dungeon"] then
        return "Raid", "Raid / Dungeon"
    end

    local level = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")
    level = level and tonumber(level.Value) or 0

    if Settings["Auto Saber"] and level >= 200 and not CheckItemInventory("Saber") then
        return "Saber", "Saber progression"
    end
    if Settings["Auto Yama"] and not CheckItemInventory("Yama") then
        return "Yama", "Yama progression"
    end
    if Settings["Auto Tushita"] and not CheckItemInventory("Tushita") then
        return "Tushita", "Tushita progression"
    end
    if Settings["Auto CDK"] and not CheckItemInventory("Cursed Dual Katana") then
        return "CDK", "CDK progression"
    end
    if Settings["Auto Soul Guitar"] and not CheckItemInventory("Soul Guitar") then
        return "SoulGuitar", "Soul Guitar progression"
    end
    if Settings["Auto Craft Item Shark Anchor"] and not CheckItemInventory("Shark Anchor") then
        return "SharkAnchor", "Shark Anchor progression"
    end

    if Settings["Auto Get Cyborg"] and currentRaceName() ~= "Cyborg" then
        return "Cyborg", "Cyborg progression"
    end
    if Settings["Auto Get Ghoul"] and currentRaceName() ~= "Ghoul" then
        return "Ghoul", "Ghoul progression"
    end
    if Settings["Auto New World"] and getSea() == 1 and level >= 700 then
        return "NewWorld", "Second Sea progression"
    end
    if Settings["Auto Third World"] and getSea() == 2 and level >= 1500 then
        return "ThirdWorld", "Third Sea progression"
    end
    -- V2 flower progression owns its own movement and may safely preempt farm.
    -- The race-specific V3 kill objectives are not fully recoverable from the
    -- damaged root CFG, so do not freeze level farm indefinitely at V2.
    if Settings["Auto Upgrade Race V2-V3"] and CheckRace() == "V1" then
        return "RaceV2", "Race V2 flower progression"
    end
    if Settings["Auto Pull Lever"] or Settings["Auto Trial"] then
        return "RaceV4", "Race V4 progression"
    end
    if Settings["Auto Upgrade Race V2-V3 Draco"]
        or Settings["Auto Quest Dragon Hunter"]
        or Settings["Auto Crafting Volcanic Magnet"]
    then
        return "Draco", "Draco / Dragon progression"
    end

    return nil, nil
end

runLoop("PriorityScan", 0.5, function()
    return Settings["Priority Tasks Preempt Farm"] ~= false
end, function()
    local taskName, reason = determinePriorityTask()
    Runtime.PriorityTask = taskName
    Runtime.PriorityReason = reason
end)

-- Optional test telemetry. Enable ["Debug Runtime"] to make the next F9
-- recording identify exactly which state the farm loop is stuck in.
runLoop("RuntimeDebug", 5, function()
    return Settings["Debug Runtime"] == true
end, function()
    warn(("[BananaRebuild/State] action=%s | target=%s | quest=%s | farm=%s | priority=%s"):format(
        tostring(Runtime.CurrentAction),
        tostring(Runtime.CurrentTarget),
        tostring(GetNameDoubleQuest()),
        tostring(Runtime.FeatureStatus.Farm),
        tostring(Runtime.PriorityTask or "none")
    ))
    if Settings["Auto Fully Fighting Style"] or Settings["Auto Farm Mastery 600 Melees"] then
        warn("[BananaRebuild/Melee] " .. tostring(Runtime.FeatureStatus.MeleeProgression or "waiting")
            .. " | 600=" .. tostring(Runtime.FeatureStatus.MeleeMastery600 or "off")
            .. " | buy=" .. tostring(Runtime.FeatureStatus.MeleePurchase or "none"))
    end
    if Settings["Random Devil Fruit"] or Settings["Get Fruits"] then
        warn("[BananaRebuild/Fruit] " .. tostring(Runtime.FeatureStatus.RandomFruit or "waiting"))
    end
end)


runLoop("Farm", 0.05, function()
    if Settings["Start Farm"] ~= true then return false end
    if Settings["Priority Tasks Preempt Farm"] ~= false and Runtime.PriorityTask then
        Runtime.FeatureStatus.Farm = "Paused by " .. tostring(Runtime.PriorityReason or Runtime.PriorityTask)
        return false
    end
    return true
end, FarmMethod)

runLoop("RandomFruit", 1, function()
    return Settings["Random Devil Fruit"] == true or Settings["Get Fruits"] == true
end, RandomFruit)

runLoop("StoreFruit", 2, function()
    return Settings["Auto Store Fruit"] == true
end, StoreFruit)

runLoop("Chest", 0.1, function()
    return Settings["Auto Chest"] == true
end, AutoChest)

runLoop("Boss", 0.05, function()
    return Settings["Kill Boss"] == true or Settings["Kill All Boss"] == true
end, AutoKillBoss)

runLoop("Raid", 0.05, function()
    return Settings["Auto Raid"] == true or Settings["Auto Multi Raid"] == true
end, function()
    Multiraid(Settings["Select Raid"])
end)

runLoop("SeaEvent", 0.05, function()
    return Settings["Auto Sea Event"] == true
end, AutoSeabeast)

runLoop("FindLeviathan", 0.25, function()
    return Settings["Auto Find Leviathan"] == true
end, AutoFindLeviathan)

runLoop("AttackLeviathan", 0.05, function()
    return Settings["Auto Attack Leviathan"] == true
end, AutoAttackLeviathan)

runLoop("RaceV2V3", 0.5, function()
    return Settings["Auto Upgrade Race V2-V3"] == true
end, UpgradeRaceV2AndV3)

runLoop("Cyborg", 1, function()
    return Settings["Auto Get Cyborg"] == true
end, GetCyborg)

runLoop("Ghoul", 1, function()
    return Settings["Auto Get Ghoul"] == true
end, GetRaceGhoul)

runLoop("PullLever", 0.5, function()
    return Settings["Auto Pull Lever"] == true
end, PullLeverV4)

runLoop("Saber", 0.1, function()
    return Settings["Auto Saber"] == true
end, SaberSword)

runLoop("Yama", 0.1, function()
    return Settings["Auto Yama"] == true
end, GetYama)

runLoop("Tushita", 0.1, function()
    return Settings["Auto Tushita"] == true
end, GetTushita)

runLoop("CDK", 0.2, function()
    return Settings["Auto CDK"] == true
end, GetCDK)

runLoop("SoulGuitar", 0.2, function()
    return Settings["Auto Soul Guitar"] == true
end, AutoSoulGuitar)

runLoop("SharkAnchor", 0.5, function()
    return Settings["Auto Craft Item Shark Anchor"] == true
end, autoCraftSharkAnchor)

runLoop("DragonHunter", 0.1, function()
    return Settings["Auto Quest Dragon Hunter"] == true
end, AutoDragonHunter)

runLoop("Dojo", 0.5, function()
    return Settings["Auto Quest Dojo Trainer"] == true
end, QuestDojoTrainer)

runLoop("Draco", 0.5, function()
    return Settings["Auto Upgrade Race V2-V3 Draco"] == true
end, AutoUpgradeRaceDraco)

runLoop("VolcanicMagnet", 0.5, function()
    return Settings["Auto Crafting Volcanic Magnet"] == true
end, AutoCraftinMagnetVol)

runLoop("FindPrehistoric", 0.25, function()
    return Settings["Auto Find Prehistoric Island"] == true
end, AutoFindPrehistoric)

runLoop("PrehistoricEvent", 0.05, function()
    return Settings["Fully Event Prehistoric Island"] == true
end, FullyEventVolcano)

runLoop("NewWorld", 0.5, function()
    return Settings["Auto New World"] == true
end, AutoNewWorld)

runLoop("ThirdWorld", 0.5, function()
    return Settings["Auto Third World"] == true
end, AutoThirdWorld)

runLoop("EliteHunter", 0.1, function()
    return Settings["Auto Elite Hunter"] == true
end, AutoEliteHunter)

runLoop("PirateRaid", 0.05, function()
    return Settings["Auto Pirate Raid"] == true
end, AutoPirateRaid)

runLoop("Factory", 0.05, function()
    return Settings["Auto Factory"] == true
end, AutoFactory)

runLoop("RainbowHaki", 0.2, function()
    return Settings["Auto Get Rainbow Haki"] == true
end, GetRainBowHaki)

runLoop("HakiPads", 0.15, function()
    return Settings["Auto Touch Pad Haki"] == true
end, TouchPadHaki)

runLoop("ObservationV2", 0.25, function()
    return Settings["Auto UP Observation V2"] == true
end, ObservationV2)

runLoop("Berry", 0.15, function()
    return Settings["Auto Collect Berry"] == true
end, AutoCollectBerry)

runLoop("FruitTeleport", 0.15, function()
    return Settings["Teleport To Fruit"] == true or Settings["Teleport To Fruit [ Hop Server ]"] == true
end, AutoTeleportFruit)

runLoop("Kitsune", 0.3, function()
    return Settings["Auto Spawn Kitsune Island"] == true
end, AutoSpawnKitsune)

runLoop("Mirage", 0.5, function()
    return Settings["Auto Find Mirage"] == true
end, AutoFindMirage)

runLoop("Fishing", 0.2, function()
    return Settings["Auto Fishing"] == true
end, AutoFishing)

runLoop("JoinDungeon", 0.25, function()
    return Settings["Auto Join Dungeon"] == true
end, AutoJoinDungeon)

runLoop("AttackDungeon", 0.05, function()
    return Settings["Auto Attack Dungeon"] == true
end, AutoAttackDungeon)

runLoop("TrialV4", 0.1, function()
    return Settings["Auto Trial"] == true
end, AutoTrialV4)

runLoop("TTK", 0.5, function()
    return Settings["Auto TTK"] == true
end, AutoTTK)

runLoop("LegendarySword", 2, function()
    return Settings["Auto Buy Legendary Sword"] == true
end, AutoBuyLegendarySword)

runLoop("AwakenFruit", 1, function()
    return Settings["Auto Awake Fruit"] == true
end, AutoAwakeFruit)

runLoop("LawRaid", 0.2, function()
    return Settings["Auto Buy Chip and Attack Law"] == true
end, AutoLawRaid)

runLoop("AutoStats", 0.25, function()
    return Settings["Auto Stats"] == true
end, AutoStats)

runLoop("BasicProgression", 0.5, function()
    return Settings["Auto Fully Fighting Style"] == true
end, AutoBuyBasicProgression)

runLoop("MeleeMastery", 0.5, function()
    return Settings["Auto Farm Mastery 600 Melees"] == true
end, AutoFarmMeleeMastery600)

runLoop("SwordMastery", 0.15, function()
    return Settings["Auto Farm Mastery 600 Sword In Inventory"] == true
end, function()
    AutoFarmWeaponMastery("Sword")
end)

runLoop("Bones", 0.05, function()
    return Settings["Auto Collect Bone"] == true
end, AutoCollectBone)

runLoop("TradeBones", 1, function()
    return Settings["Auto Trade Bone"] == true
end, AutoTradeBone)

runLoop("TradeAzureEmber", 1, function()
    return Settings["Auto Trade Azure Ember"] == true
end, AutoTradeAzureEmber)

runLoop("SummonBosses", 0.2, function()
    return Settings["Summon Darkbeard"] == true
        or Settings["Auto Summon Rip Indra"] == true
        or Settings["Summon Soul Reaper"] == true
        or Settings["Attack Darkbeard"] == true
        or Settings["Attack Rip Indra"] == true
        or Settings["Attack Soul Reaper"] == true
        or Settings["Attack Dough King"] == true
end, AutoSummonBosses)

runLoop("YoruMini", 0.1, function()
    return Settings["Auto Yoru Mini"] == true
end, AutoYorumini)

runLoop("FullyDraco", 0.25, function()
    return Settings["Fully Trial Draco"] == true
        or Settings["Auto Trial Draco"] == true
        or Settings["Auto Finish Train Draco Quest"] == true
end, FullyDraco)

runLoop("GearV4", 0.5, function()
    return Settings["Auto Choose Gears"] == true or Settings["Auto Buy Gear"] == true
end, function()
    if Settings["Auto Choose Gears"] then ChooseGearV4() end
    if Settings["Auto Buy Gear"] then BuyGearV4() end
end)

runLoop("HakiColorShop", 3, function()
    return Settings["Auto Buy Haki Color"] == true
end, AutoBuyHakiColor)

runLoop("UpgradeSword", 1, function()
    return Settings["Auto Upgrade Sword Inventory"] == true
end, function()
    AutoUpgradeWeapon("Sword")
end)

runLoop("UpgradeGun", 1, function()
    return Settings["Auto Upgrade Gun Inventory"] == true
end, function()
    AutoUpgradeWeapon("Gun")
end)

runLoop("FruitSniper", 1, function()
    return Settings["Buy Blox Fruit Sniper Shop"] == true
end, BuyBloxFruitSniper)

runLoop("LocalPlayer", 0.2, function()
    return Settings["Change WalkSpeed"] == true or Settings["Change JumpPower"] == true
end, applyLocalPlayerSettings)

runLoop("FPSBoost", 5, function()
    return Settings["Boost Fps"] == true
end, fpsBoost)

runLoop("ESP", 0.5, function()
    return Settings["ESP Fruit"] == true or Settings["ESP Player"] == true or Settings["ESP Island"] == true
end, UpdateESP)

runLoop("Reconnect", 1, function()
    return Settings["Auto rejoin Disconnect"] == true
end, rejoinIfDisconnected)

-- ============================================================================
-- 17. PUBLIC API / COMPATIBILITY EXPORTS
-- ============================================================================

Runtime.Settings = Settings
Runtime.CancelTween = cancelTween
Runtime.ToTarget = toTarget
Runtime.DetectMob = DetectMob
Runtime.BringMob = BringMob
Runtime.AttackAOE = AttackAOE
Runtime.Attack = AttackFunction
Runtime.Farm = FarmMethod
Runtime.FarmMastery = FarmMastery
Runtime.DetectMobAura = DetectMobAura
Runtime.HopServer = HopServer
Runtime.SendWebhook = sendWebhook
Runtime.FindBoat = findBoat
Runtime.SailSea = sailForSeaEvent
Runtime.CancelBoatTween = cancelBoatTween
Runtime.Stop = function()
    Runtime.Stopped = true
    cancelTween()
    cancelBoatTween()
    Runtime.BoatMode = nil
    Runtime.PriorityTask = nil
    Runtime.PriorityReason = nil
    setCharacterNoclip(false)
end

getgenv().toTarget = toTarget
getgenv().DetectMob = DetectMob
getgenv().BringMob = BringMob
getgenv().AttackAOE = AttackAOE
getgenv().AttackFunction = AttackFunction
getgenv().ClickM1 = ClickM1
getgenv().IsMobAlive = IsMobAlive
getgenv().NameWeapon = NameWeapon
getgenv().equiptool = equiptool
getgenv().FarmMethod = FarmMethod
getgenv().FarmMastery = FarmMastery
getgenv().DetectMobAura = DetectMobAura
getgenv().RandomFruit = RandomFruit
getgenv().StoreFruit = StoreFruit
getgenv().HopServer = HopServer

notify("Readable rebuild loaded: " .. Runtime.Version)
