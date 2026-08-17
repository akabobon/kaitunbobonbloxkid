-- =================================================================
--         BOBON HUB v18.8 BOOT-SAFE + MELEE/SWORD/TTK + GLASS NEON V2.2 | STABLE KAITUN BLOX FRUIT
--         Long-Run Stable | Single Movement Owner | ActionToken
--         Base: v18.7 FULL-BATCH CLUSTER + TEDDY SKIP | Version: v18.8
--
--  v18.8 BOOT / MELEE / SWORD AUDIT:
--  [B-1] Remove silent 10s CommF_ return: bootstrap HUD appears first and waits
--        for the live RemoteFunction instead of killing the entire kaitun.
--  [B-2] UI remains isolated by pcall; UI failure cannot terminate farm core.
--  [B-3] Auto Buy Melee drives the real fighting-style progression chain.
--  [B-4] Auto Buy Swords probes all normal BuyItem swords without first-item lock.
--  [B-5] Legendary Sword Dealer supports current Saishi/Shizu/Oroshi plus legacy
--        Saddi/Shisui/Wando aliases; TTK trains each prerequisite to 300 mastery.
--  [B-6] True Triple Katana purchase uses MysteriousMan only after all three
--        legendary swords + mastery + Beli gates are locally verified.
--  [B-7] Missing live boss-drop swords are opportunistically hunted in safe
--        progression windows; current Chef/Orbitus/rip_indra True Form aliases added.
--
--  v18.3 FARM MOVEMENT / QUEST GATHER FIXES:
--  [QG-1] Nearby regular quest mobs use one conservative short CFrame snap to
--         the hover anchor; long/medium travel still uses TravelManager physics.
--  [QG-2] Near snap is quest-only, Farm-owner-only, distance/cooldown limited,
--         never used for bosses/items/Sea/Katakuri or cross-region travel.
--  [QG-3] Bring requires a currently visible active quest and the canonical
--         ActiveQuestMob; stale/completed quest state releases the cluster.
--  [QG-4] BossManager never calls quest-bring; boss fights remain single-target.
--         v18.4 separately permits Cake/Cocoa fodder gather for Dough King prep.
--  [QG-5] UI is unchanged.
--
--  v18.4 DOUGH-GATHER FIX:
--  [DG-1] Normal level farm bring remains active-quest-only.
--  [DG-2] Dough King preparation may gather Cake Land kill mobs and Cocoa mobs.
--  [DG-3] Dough King itself, Elite hunters and all bosses are never gathered.
--  [DG-4] Bring still requires verified client network ownership.
--
--  v18.5 CONTEST / NO-SURRENDER FIXES:
--  [CF-1] Other-player damage on the same quest mob marks it contested but never clears it.
--  [CF-2] Contested targets use a faster bounded attack cadence and rotate unproven backends.
--  [CF-3] PvP/NPC damage to the player never pauses farm at low HP; only actual death waits respawn.
--  [CF-4] Hop Player Near is suppressed while actively fighting the current quest mob.
--  [CF-5] A contested live quest mob can be chased farther instead of being surrendered at 350 studs.
--
--  v18 AUDIT / ENDGAME FIXES:
--  [K-1] Max level 2800 no longer stays on Grand Devotee forever.
--  [K-2] Katakuri runs only at max level and never steals level-farm movement.
--  [K-3] CakePrinceSpawner(true) progress query + Cake Land kill loop.
--  [K-4] Sweet Chalice path: cocoa farming + live Sweet Crafter interaction.
--  [K-5] Katakuri combat uses ActionToken + TravelManager + verified attack.
--  [K-6] Katakuri bring only moves same-name mobs with verified ownership.
--  [K-7] Max level bypasses mandatory Submerged travel so endgame can run.
--  [K-8] External Configs adapter only maps implemented features.
--  [K-9] Team chooser respects configured Pirates/Marines.
--  [K-10] UI block preserved byte-for-byte from v17.0.
--
--  LIVE HOTFIX VERIFIED COMBAT + ATOMIC TRAVEL:
--  [C-1] Melee/sword attack adapter: live client helper -> tokenized Net ->
--        one real client click fallback. Never fire competing input paths.
--  [C-2] A backend is READY only after two independent verified HP decreases;
--        pcall/FireServer/input success is reported as PROBE, not damage.
--  [C-3] Combat hover is explicit for every owner (Farm/Boss/Items/Sea),
--        stays above the NPC and never faces 180 degrees away on arrival.
--  [C-4] Same-owner retarget replans all travel options atomically; stuck
--        timing no longer sleeps 0.5s inside the physics loop.
--  [C-5] Bring counts only network-owned mobs; local fallback is explicitly
--        forbidden because it creates client-only "dummy" mobs. Bring never
--        changes persistent Humanoid/collision state.
--  [C-6] Skip-level combat remains disabled until fast damage is verified.
--  [C-7] Quest bring refreshes SimulationRadius, verifies network ownership
--        before and after each move, and never attacks a locally-ghosted mob.
--  [C-8] Incoming NPC/player damage never changes the farm hover, target or
--        bring state; low HP, Stun and Busy do not pause the kaitun.
--
--  AUDIT FIXES v16.6-LIVE (L-1..L-7):
--  [L-1] HUD responsive bằng UIListLayout + UIScale, không chồng chữ
--         trên màn hình mobile; nền kính vẫn phủ toàn màn hình.
--  [L-2] Beli xanh, Fragments tím, Status đổi màu theo Mode.
--  [L-3] Combat ưu tiên đúng ReplicatedStorage.Modules.Net và payload
--         RegisterAttack/RegisterHit hiện hành; M1 truyền camera CFrame.
--  [L-4] Attack chỉ gửi khi đã equip Tool; lỗi VirtualUser không hủy
--         RegisterHit đã gửi.
--  [L-5] Bring mob xin SimulationRadius, giới hạn 250 studs, không anchor;
--         freeze vận tốc và chỉ dịch mob khi có quyền physics khả dụng.
--  [L-6] Sửa item window unreachable; Saber dùng ProQuestProgress,
--         Pole săn Thunder God thay cho remote BuyPoleV1 không tồn tại.
--  [L-7] Sửa gate tiến trình Sea2, Bartilo và Sea3 theo live flow.
--
--  AUDIT FIXES v16.5-GLASS (G-1..G-9):
--  [G-1]  OVERLAY KÍNH MỜ: nền Dim mờ xuyên cảnh (MenuDim, mặc định
--         0.45) + BlurEffect kính mờ (MenuBlur) thay cho [D-2] nền đen
--         100%. Right Ctrl ẩn/hiện toàn bộ overlay + blur.
--  [G-2]  Tự dọn blur cũ khi re-execute; blur tự gắn lại khi
--         CurrentCamera bị thay đổi (respawn/teleport).
--  [G-3]  RecoveryManager: Velocity/RotVelocity (deprecated) →
--         AssemblyLinearVelocity/AssemblyAngularVelocity.
--  [G-4]  FULL-GLASS: bỏ hẳn card/khung menu — chữ nổi trực tiếp trên
--         nền kính mờ TOÀN màn hình, text stroke đậm hơn để đọc rõ.
--  [G-5]  ATTACK FIX: Net remote resolver đa đường dẫn (Remotes.Modules.Net
--         / Modules.Net / tìm sâu theo tên "Net"). Bản cũ chỉ nhìn
--         RS.Modules.Net nên RegisterHit không bao giờ gửi được → bot
--         đứng im không đánh. Giờ gửi RegisterHit theo từng enemy
--         (part, {part}), giới hạn 12 mob gần nhất chống spam.
--  [G-6]  FARM/GATHER FIX: quest-match KHÔNG đọc được UI (nil sau update
--         đổi cấu trúc) → vẫn farm thay vì kẹt re-request quest vô hạn;
--         gom mob không còn phụ thuộc strict quest-match, anchor nới
--         bán kính tối thiểu 30 studs, GatherInterval 0.3 → 0.15.
--  [G-7]  FAST ATTACK THEO TÊN + BRING MOB: RegisterHit đánh MỌI mob
--         trùng tên quest đang sống, KHÔNG giới hạn khoảng cách (đứng
--         đâu cũng trúng). Gom = DỊCH CHUYỂN toàn bộ mob trùng tên về
--         cụm quanh mob neo (PivotTo + anchor cục bộ chống server kéo
--         về), chỉ chạy khi đã hover trên đầu mob neo; nhả anchor khi
--         đổi target/quest/chết (ReleaseCluster).
--  [G-8]  Remote gọi qua cloneref khi executor hỗ trợ (kiểu "Fast
--         Attack Unban" công khai) để bớt bị theo dõi remote trực tiếp.
--  [G-9]  ATTACK UNBLOCK: equip tool KHÔNG còn là cổng chặn attack
--         (RegisterHit không cần tool, M1 tay không vẫn damage); camera
--         quay THẲNG vào target trước khi M1 (game bắn theo hướng
--         camera, không phải hướng thân); RegisterHit đa định dạng
--         (part,{part}) / ({parts}) / (part); skip route cũng gom mob;
--         ActionLockTimeout 180 → 60s chống đứng im dài.
--
--  AUDIT FIXES v16.4-FIXED (D-1..D-5):
--  [D-1]  DODGE CONTROLLER (NÉ CHIÊU): monitor loop duy nhất dò quái
--         gần player đang tung chiêu (animation tấn công / lao nhanh
--         về phía player) → dịch ngang 1 phát né, có cooldown chống
--         spam, không né khi bay xa (giver/island), không phá Single
--         Movement Owner (chỉ CFrame offset 1 lần, hover kéo về sau).
--  [D-2]  NỀN ĐEN FULL MÀN HÌNH: Dim phủ kín màn hình, đục hoàn toàn
--         (BackgroundTransparency = 0, đen 100%) thay vì mờ 86%.
--  [D-3]  (gộp vào D-4) Skip level không hiệu quả → quay về farm quest.
--  [D-4]  SKIP KHÔNG HIỆU QUẢ → FARM QUEST: SkipRouteController theo
--         dõi level đầu route; cùng route quá SkipRouteFallbackTimeout
--         (90s) mà level không tăng → tắt hẳn skip route, main
--         controller chạy farm quest bình thường.
--  [D-5]  KHÔNG CHỜ BOSS: route boss (Bobby/Yeti/Vice Admiral/...) mà
--         boss không có mặt NGAY → return false, quay về farm quest
--         tức thời. Chỉ route mob giữ fallback chờ spawn (mob respawn
--         nhanh). BossManager vẫn săn boss khi boss xuất hiện.
--
--  AUDIT FIXES v16.0-FIXED:
--  [FIX-1]  BossManager undefined -> crash main pcall -> farm khong
--           bao gio chay -> them BossManager safe stub (return false)
--  [FIX-2]  Error handling: moi subsystem wrap pcall rieng + warn
--           "[BobonHub] Module Error: <error>", main van tiep tuc
--  [FIX-3]  Attack dung khoang cach XZ (FarmHeight 22 > AttackRange 20
--           -> bot khong bao gio attack duoc truoc day)
--  [FIX-4]  TravelManager: validate target moi tick (Parent / Humanoid
--           health / duoi bien) -> mob chet/destroy tu dong clear
--           target + dung travel, khong recovery nang ne neu chi la
--           target chet (u tien clear target va resume farm)
--  [FIX-5]  Request: validate instance target truoc khi travel
--  [FIX-6]  FarmTarget: clear ngay khi chet / destroy / o duoi bien /
--           qua xa -> ve q.MC tim mob moi
--  [FIX-7]  FindNearestMob: bo qua mob o duoi bien (Y < MinY-10)
--  [FIX-8]  GetFarmPosition: nhan Vector3, clamp Y >= MinY
--  [FIX-9]  Quest sai mob: tu re-request khi toi giver (truoc day ket
--           vinh vien), khong farm mob sai quest
--  [FIX-10] Chua co quest -> khong farm, di lay quest truoc
--  [FIX-11] Travel timeout khong reset khi dang hover farm -> bo
--           recovery vo ich moi 45s
--  [FIX-12] Auto-recovery khong trigger khi Dead/Respawning
--  [FIX-13] SEA-3 CHOCOLATE LAND FIX: QDB MC sai -> bot "bay ra bien"
--           - Chocolate Bar Battler MC (507,73,-12789) -> (583,77,-12463)
--           - Sweet Thief MC (-71,25,-12381) -> (165,76,-12601)
--           (toa do that tu script farm, verify spawn mob tai khu)
--           + Travel fallback: target farm chet/mat/timeout giua duong
--           -> bay ve khu farm (q.MC) thay vi break -> KHONG drop khoi
--           khong trung giua bien
--           + Anti-fall safety net: chi khi KHONG co travel chay, neu
--           Y < MinY -> day len. Travel dang chay -> loop bo qua.
--
--  AUDIT FIXES v16.1-FIXED (FIX-P1..P15):
--  [FIX-P1] LONG-DISTANCE TRAVEL / CRUISE MODE  (FIX TRIỆT ĐỂ lỗi
--           "Lv2453 -> Chocolate Island -> bay giua bien -> dung yen")
--           - Khoang cach > CruiseThreshold(500) -> cruise mode:
--             giu do cao an toan (CruiseAltitude=60), bay ngang on dinh,
--             chi approach target Y khi con gan (ApproachThreshold=120)
--           - Timeout DONG theo khoang cach: max(TravelTimeout,
--             distance/FlySpeed + margin), cap 300s. Khong dung cu'ng 45s
--           - Stuck detection rieng: short=StuckTimeout(8),
--             cruise=CruiseStuckTimeout(20), farm hover=HoverStuckTimeout(30)
--           - Anti-fall trong travel: VUA NANG LEN VUA BAY NGANG ve target
--             (khong ket vong lap "chi di len")
--           - Khong pha token/CurrentToken/MovementOwner/IsTraveling
--  [FIX-P2] Quest verification: QuestMatches() doc TextLabel + QuestModel,
--           fallback doc dinh descendant. Khong tu dong coi la hop le khi
--           khong doc duoc text.
--  [FIX-P3] Sau RequestQuest: verify lai HasQuest + quest dung q.M.
--           Retry co gioi han (QuestRetryLimit), khong spam remote,
--           khong farm khi chua co quest, backoff neu fail lien tuc.
--  [FIX-P4] Farm target sync: clear ngay khi chet/destroy/Parent nil/
--           Health<=0/HRP mat/duoi bien/qua xa/invalid -> tim mob moi,
--           khong de travel cu' bam target cu, khong recovery nang ne.
--  [FIX-P5] Attack: chi attack khi da equip melee (EquipMelee tra ve
--           bool) + target con song + khoang cach XZ trong AttackRange,
--           giu AttackDelay, khong spam.
--  [FIX-P6] Hitbox: chi resize khi size doi, CanCollide=false an toan,
--           Handle khong ton tai -> bo qua, khong loi.
--  [FIX-P7] AutoStats: giu batch limit, Points=0 -> khong lam gi,
--           loi remote khong anh huong Farm, khong tao ActionToken.
--  [FIX-P8] ItemProgression: thay "task.wait(2)" bang TravelAndWait()
--           (travel -> verify den noi -> check alive+token -> moi remote).
--  [FIX-P9] Sea progression: verify tung step, retry gioi han, chi
--           teleport sang sea moi khi progression hoan tat + con song.
--  [FIX-P10] Recovery: guaranteed reset (xpcall) -> KHONG BAO GIO ket
--           o Mode=Recovering. Khong trigger khi Dead/Respawning, khong
--           trigger khi chi mob chet/target mat/lag ngan.
--  [FIX-P11] Travel target validation: NaN/invalid position reject ca
--           Instance va CFrame/Vector3, clamp Y an toan.
--  [FIX-P12] QDB: cap nhat ten mob + quest + toa do dung cho Sea 1/2/3,
--           bao phu level 1-2800; khong dung lai bang QDB cu bi lech map.
--  [FIX-P13] Main Controller: giu priority Recovery > Sea > Items >
--           Boss > Quest > Farm. Khong tao loop movement khac.
--  [FIX-P14] Error isolation: moi subsystem pcall/xpcall rieng, loi
--           khong chet Main Controller.
--  [FIX-P15] Long-run stability: clean state sau mob chet/player chet/
--           respawn/quest xong/quest sai/travel fail/timeout/target
--           destroy. Khong leak thread/connection.
--
--  AUDIT FIXES v16.2-FIXED (A-1..A-10):
--  [A-1]  TeamController: AutoSelectTeam() — check Player.Team → chưa có
--         → chọn Pirates → verify → retry giới hạn, cooldown 5s,
--         KHÔNG spam remote. Chạy được mọi Sea.
--  [A-2]  EquipmentController: EquipMelee() — scan Character+Backpack,
--         đang cầm → không re-equip, retry cooldown (EquipCooldown),
--         verify tool trên tay, không spam EquipTool mỗi frame.
--  [A-3]  MovementManager: Acquire/Release/IsOwner — API Single Movement
--         Owner. Travel Request=Acquire, Stop/arrival=Release. Farm
--         không override khi TRAVEL giữ; travel xong → trả về Farm.
--  [A-4]  FarmPositionController: farm position PHÍA TRÊN mob (FarmHeight
--         adaptive theo size mob), gom mob: attack mob quest trong
--         MobGatherRadius quanh điểm farm để kéo aggro về cluster.
--  [A-5]  Farm state machine FState (1 loop duy nhất):
--         IDLE→CHECK_CHARACTER→CHECK_SEA→SELECT_TARGET→MOVE_TO_TARGET→
--         ATTACK→VERIFY_TARGET→NEXT_TARGET
--  [A-6]  Attack gating: alive + melee equip + target hợp lệ + Farm giữ
--         movement (owner Farm hoặc không travel) + AttackRange XZ.
--  [A-7]  FarmWatchdog merge vào watchdog DUY NHẤT: light fix trước
--         (travel không tiến → Stop + retry, lightFails đếm), Recovery
--         nặng chỉ khi light fix thất bại ≥3 lần.
--  [A-8]  DEBUG log: Settings.DEBUG=false (mặc định), DLog(tag,msg)
--         [TEAM] [EQUIP] [QUEST] [TARGET] [FARM] [MOVE] [TRAVEL]
--         [ATTACK] [RECOVERY] [STATE]. Tắt → không spam console.
--  [A-9]  Hover farm dùng FarmPositionController (đứng trên đầu mob,
--         không xuyên vào mob, không bay quá cao, clamp MinY).
--  [A-10] Không thêm loop mới: 1 Farm loop + 1 Travel loop + 1 Watchdog
--         + 1 Anti-fall net — mỗi chức năng đúng 1 loop điều khiển.
-- =================================================================


--  v16.7 CORE FIXED (non-UI audit):
--  [R-1] Preserve UI block unchanged.
--  [R-2] Team gate requires verified Pirates, not merely any non-nil team.
--  [R-3] PrepareCombatTarget never resizes enemy roots.
--  [R-4] Boss target participates in shared target cleanup/kill accounting.
--  [R-5] Implement FruitEnabled: Sea2/3 random fruit + backpack store, cooldown-safe.
--  [R-6] Kill counter ignores unrelated server NPC deaths.
--  [R-7] Fruit work never owns movement/ActionToken, so it cannot race farm/travel.


repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
-- Re-execution guard. Newer sessions invalidate every persistent loop from
-- the previous run and invoke its cleanup hook before creating new state.
local PreviousUnload = rawget(_G, "BobonUnload")
if type(PreviousUnload) == "function" then pcall(PreviousUnload) end
_G.BobonUnload = nil
_G.BobonSessionID = (_G.BobonSessionID or 0) + 1
local SessionID = _G.BobonSessionID
local function SessionAlive()
    return _G.BobonSessionID == SessionID
end
-- Không chờ Character/HRP/Data ở đây: lúc mới execute, ChooseTeam có thể
-- xuất hiện trước character. Chờ các object này ở từng controller để team
-- được chọn ngay lập tức thay vì kẹt vô hạn trong bootstrap.


print("[BobonHub v18.8 BOOT-SAFE + FULL PROGRESSION] Loading...")


-- ══════════════════════════════════════════════════════════════════
--                          SERVICES
-- ══════════════════════════════════════════════════════════════════
local Players      = game:GetService("Players")
local RS           = game:GetService("ReplicatedStorage")
local RunService   = game:GetService("RunService")
local VU           = game:GetService("VirtualUser")
local VIM          = game:GetService("VirtualInputManager")
local TS           = game:GetService("TweenService")
local TeleportSvc  = game:GetService("TeleportService")
local HttpService  = game:GetService("HttpService")
local CoreGui      = game:GetService("CoreGui")


local LP = Players.LocalPlayer
while not LP and SessionAlive() do
    task.wait(0.10)
    LP = Players.LocalPlayer
end
if not LP then error("[BobonHub] LocalPlayer unavailable") end

-- v18.8 BOOT-SAFE: the old build returned before UI/core when Remotes/CommF_
-- had not replicated within 10 seconds.  Show a tiny bootstrap HUD immediately
-- and keep resolving the authoritative RemoteFunction instead of silently dying.
local BootGui, BootLabel
pcall(function()
    local parent = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    -- PlayerGui is the broadest compatibility target. gethui/CoreGui are fallbacks
    -- for executors that intentionally isolate injected GUI from PlayerGui.
    if not parent and type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then parent = hui end
    end
    if not parent then
        local ok = pcall(function() return CoreGui.Name end)
        if ok then parent = CoreGui end
    end
    if parent then
        local old = parent:FindFirstChild("BobonBootUI")
        if old then old:Destroy() end
        BootGui = Instance.new("ScreenGui")
        BootGui.Name = "BobonBootUI"
        BootGui.ResetOnSpawn = false
        BootGui.DisplayOrder = 20000
        BootGui.Parent = parent
        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 330, 0, 56)
        card.Position = UDim2.new(0, 18, 0, 18)
        card.BackgroundColor3 = Color3.fromRGB(10, 18, 31)
        card.BackgroundTransparency = 0.08
        card.BorderSizePixel = 0
        card.Parent = BootGui
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = card
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(72, 223, 255)
        stroke.Transparency = 0.25
        stroke.Thickness = 1.2
        stroke.Parent = card
        BootLabel = Instance.new("TextLabel")
        BootLabel.BackgroundTransparency = 1
        BootLabel.Size = UDim2.new(1, -24, 1, 0)
        BootLabel.Position = UDim2.new(0, 12, 0, 0)
        BootLabel.Font = Enum.Font.GothamBold
        BootLabel.TextSize = 13
        BootLabel.TextColor3 = Color3.fromRGB(235, 248, 255)
        BootLabel.TextXAlignment = Enum.TextXAlignment.Left
        BootLabel.Text = "BOBON HUB  •  BOOTING..."
        BootLabel.Parent = card
    end
end)

local function SetBootText(value)
    pcall(function() if BootLabel then BootLabel.Text = tostring(value) end end)
end

local function ResolveCommF()
    local attempts = 0
    while SessionAlive() do
        local remotes = RS:FindFirstChild("Remotes")
        local remote = remotes and remotes:FindFirstChild("CommF_")
        if not remote then remote = RS:FindFirstChild("CommF_", true) end
        if remote and remote:IsA("RemoteFunction") then
            return remotes or remote.Parent, remote
        end
        attempts = attempts + 1
        if attempts % 20 == 0 then
            SetBootText("BOBON HUB  •  waiting for game remotes...")
            warn("[BobonHub] Waiting for ReplicatedStorage.Remotes.CommF_ ...")
        end
        task.wait(0.25)
    end
    return nil, nil
end

local Remotes, CommF_ = ResolveCommF()
if not CommF_ then error("[BobonHub] Session ended before CommF_ became ready") end
SetBootText("BOBON HUB  •  CORE READY")
task.delay(0.8, function() pcall(function() if BootGui then BootGui:Destroy() end end) end)


-- ══════════════════════════════════════════════════════════════════
--                   CONFIG
-- ══════════════════════════════════════════════════════════════════
_G.Settings = {
    -- [A-8] DEBUG log: true = in [TAG] log ra console (không spam khi false)
    DEBUG               = false,
    Team                = "Pirates",
    -- Safe hover for verified fast attack. Before fast damage is confirmed,
    -- the controller temporarily uses ClientHoverHeight for a genuine M1.
    FarmHeight          = 15,
    BossFarmHeight      = 24,
    -- Only the real-click fallback descends this low. Verified fast attack
    -- remains at FarmHeight/BossFarmHeight, safely outside ordinary NPC M1.
    ClientHoverHeight   = 5,
    FarmOffsetX         = 1.5,
    -- Retained for compatibility only; enemy roots are no longer resized.
    HitboxSize          = 0,
    FlySpeed            = 180,
    MinY                = 10,
    -- Submerged Island (Sea 3) dùng tọa độ âm dưới mặt biển.
    UnderwaterMinY      = -2300,
    CloseThreshold      = 35,
    FarmArrivalThreshold= 2.5,
    HoverConfirmRadius  = 5,
    -- [A-4] Farm position / gom mob config (điều chỉnh theo game physics)
    MobGatherRadius     = 50,
    TargetRefreshInterval = 0.2,
    PositionRefreshInterval = 0.1,
    -- [A-2] Cooldown retry equip melee (giây)
    EquipCooldown       = 0.5,
    -- [A-1] Cooldown giữa các lần chọn team (giây)
    TeamCooldown        = 5,
    -- [A-7] Watchdog: travel không tiến quá N giây → light fix
    WatchdogStuckThreshold = 25,
    -- Current FastAttack path accepts nearby enemies up to 100 studs.  A
    -- 20-stud gate made cluster farming stop attacking while hovering over
    -- the average position of several mobs, so keep the gate in sync.
    AttackRange         = 100,
    FastAttackRange     = 100,
    ClientAttackRange   = 8,
    FastAttackMaxTargets= 12,
    CombatProbeTimeout  = 1.2,
    CombatProbeAttempts = 3,
    CombatBackendRetry  = 12,
    CombatFastUpgradeInterval = 90,
    CombatVerifiedMissLimit = 8,
    CombatVerifiedRetry = 0.25,
    CombatLateGrace     = 0.35,
    CombatProofsRequired= 2,
    -- A previously verified backend is re-probed after a quiet period, but
    -- ordinary island travel must not invalidate it every few seconds.
    CombatVerificationTTL= 120,
    CombatBaselineQuiet = 0.25,
    CombatRepeatProofGap= 0.9,
    CombatCausalWindow  = 0.65,
    IgnoreIncomingDamage= true,
    IncomingDamageGrace = 2.0,
    -- v18.1: external hits/control effects must never cancel the current job.
    -- These values only affect controller policy; they do not mutate server Stun/Busy.
    ContinuityMode      = true,
    ExternalInterferenceGrace = 3.0,
    KeepTargetOnDamage  = true,
    KeepActionOnDamage  = true,
    KeepMovementOnDamage= true,
    -- v18.5: contested quest mobs stay sticky. Another player damaging the
    -- same mob or attacking this character never makes the kaitun give up.
    ContestQuestMobs    = true,
    ContestRadius       = 65,
    ContestGrace        = 3.0,
    ContestAttackDelay  = 0.045,
    ContestChaseDistance= 900,
    ContestSuppressPlayerHop = true,
    EquipSettle         = 0.35,
    StuckTimeout        = 8,
    HoverStuckTimeout   = 30,
    CruiseStuckTimeout  = 20,
    TargetLostTimeout   = 3,
    TravelTimeout       = 45,
    CruiseThreshold     = 500,
    CruiseAltitude      = 60,
    ApproachThreshold   = 120,
    TravelTimeoutMargin = 20,
    RandomFruitInterval = 120,
    RandomFruitSea2Cost = 100000,
    RandomFruitSea3Cost = 250000,
    FruitStoreInterval  = 8,
    AttackDelay         = 0.08,
    QuestDelay          = 1.5,
    QuestRetryLimit     = 3,
    QuestRetryBackoff   = 6,
    QuestAcceptGrace    = 6,
    RecoveryDelay       = 3,
    ActionLockTimeout   = 60,   -- [G-9] đứng im tối đa 60s thì token bị force-release
    BossEnabled         = true,
    FruitEnabled        = true,
    AutoStats           = true,
    AutoItems           = true,
    AutoRedeemCodes     = true,
    RedeemCodeDelay     = 0.45,
    -- Local-only bring-mob for nearby quest enemies; no extra movement loop.
    GatherMobs          = true,
    -- Sea 1 optimized skip route (Fountain, bosses, Upper Sky/Galley).
    -- Enabled only after the combat adapter confirms real fast damage.
    SkipLevelRoute      = true,
    -- Bring matching quest mobs only inside the current island/farm area.
    -- Simulation ownership is requested before movement to avoid ghost mobs.
    GatherMaxDistance   = 600,
    GatherSimulationRefresh = 0.20,
    GatherVerifiedTTL   = 1.25,
    -- v18.7 full-batch cluster: gather ALL matching mobs in the current farm
    -- area in one magnet pass. Attack target count stays separately bounded.
    ClusterRefresh      = 0.05,
    ClusterStackRadius  = 0.75,
    ClusterAcquireGrace = 1.25,
    ClusterAnchorMaxDrift = 18,
    ClusterGatherLimit  = 64,
    ClusterSimulationRadius = 1000,
    -- Core movement optimization: one short snap only for the active quest mob.
    -- This is intentionally not exposed in Configs; it is part of the farm core.
    NearQuestSnap        = true,
    NearQuestSnapDistance= 22,
    NearQuestSnapCooldown= 0.45,
    -- Optional item failure/timeout must not block level farming forever.
    ItemRetryCooldown   = 300,
    ServerHopCooldown   = 120,
    MaxFarmDistance     = 300,
    StatBatchLimit      = 100,
    -- [D-1/C-8] Chỉ né chiêu của NPC trong workspace.Enemies. Kỹ năng và
    -- sát thương từ người chơi không làm đổi target/hover/bring của kaitun.
    DodgeAttacks        = true,
    DodgeCooldown       = 1.5,
    DodgeDistance       = 12,
    DodgeHeight         = 4,
    DodgeRadius         = 15,
    -- [D-4] Skip level không hiệu quả: cùng route quá N giây mà level
    -- không tăng → tắt skip route, quay về farm quest bình thường.
    SkipRouteFallbackTimeout = 90,

    -- v17 progression: all are non-blocking. A missing server event/key never
    -- freezes the level farm; the controller retries only in safe quest windows.
    AutoAdvancedItems   = true,
    AutoFightingStyles  = true,
    AutoBuyMelee        = true,
    AutoBuySwords       = true,
    AutoTrueTripleKatana= true,
    SwordBuyProbe       = 12,
    LegendarySwordProbe = 8,
    TTKMasteryTarget    = 300,
    AutoRaceV2          = true,
    AutoCDK             = true,
    AutoSoulGuitar      = true,
    ProgressionRetry    = 45,
    InventoryCacheTTL   = 5,
    OptionalWorkTimeout = 150,

    AutoKatakuri        = true,
    KatakuriOnlyMax     = true,
    KatakuriPreferDough = true,
    KatakuriWorkTimeout = 90,
    KatakuriRetry       = 20,
    KatakuriCraftRetry  = 20,

    -- v18.2 compact config: every exposed key below has live logic.
    AutoSaber            = true,
    AutoSpawnRipIndra    = false,
    FPSBoostEnabled      = false,
    FPSCap               = 30,
    FPSHideGameUI        = false,
    FPSDisable3DRender   = false,
    FarmBossDrops        = false,
    BossDropsWhen2xExpired = false,
    FarmMasteryEnabled   = false,
    FarmMasteryWeapons   = {},
    FarmMasteryGuns      = {},
    FarmMasterySwords    = {},
    MasteryHealthPercent = 40,
    MasteryTarget        = 600,
    GetFruits            = true,
    HopEnabled           = false,
    HopFindFruit         = true,
    HopElite             = true,
    HopFindDarkbeard     = true,
    HopFindMirage        = true,
    HopFindMirrorFractal = true,
    HopFindSoulReaper    = true,
    HopFindTushita       = true,
    HopFindValkyrieHelm  = true,
    HopPlayerNear        = false,
    HopPlayerNearRadius  = 250,
    HopCheckInterval     = 8,
    HopRequestCooldown   = 25,
    LockFragment         = 0,
    RainbowHaki          = false,
    Shutdown             = false,
    SnipeFruit           = "",
    SwitchMelee          = true,
}


-- External config adapter — compact Hune-style surface.
-- Every key mapped here has real implementation in this file; no display-only toggles.
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local cfg = env and env.Configs
    if type(cfg) == "table" then
        local function bool(v, default) return type(v) == "boolean" and v or default end
        local function num(v, default) return type(v) == "number" and v or default end
        local function str(v, default) return type(v) == "string" and v or default end
        local function arr(v) return type(v) == "table" and v or {} end

        if cfg.Team == "Pirates" or cfg.Team == "Marines" then _G.Settings.Team = cfg.Team end
        _G.Settings.AutoSaber = bool(cfg["Auto Saber"], _G.Settings.AutoSaber)
        _G.Settings.AutoKatakuri = bool(cfg["Auto Spawn Dough King"], _G.Settings.AutoKatakuri)
        _G.Settings.KatakuriPreferDough = _G.Settings.AutoKatakuri
        _G.Settings.AutoSpawnRipIndra = bool(cfg["Auto Spawn rip_indra"], _G.Settings.AutoSpawnRipIndra)
        _G.Settings.AutoCDK = bool(cfg["Cursed Dual Katana"], _G.Settings.AutoCDK)
        _G.Settings.AutoSoulGuitar = bool(cfg["Skull Guitar"], _G.Settings.AutoSoulGuitar)
        _G.Settings.AutoRaceV2 = bool(cfg["Auto Race V2"], _G.Settings.AutoRaceV2)
        _G.Settings.AutoBuyMelee = bool(cfg["Auto Buy Melee"], _G.Settings.AutoBuyMelee)
        _G.Settings.AutoFightingStyles = _G.Settings.AutoBuyMelee
        _G.Settings.AutoBuySwords = bool(cfg["Auto Buy Swords"], _G.Settings.AutoBuySwords)
        _G.Settings.AutoTrueTripleKatana = bool(cfg["True Triple Katana"], _G.Settings.AutoTrueTripleKatana)
        _G.Settings.GetFruits = bool(cfg["Get Fruits"], _G.Settings.GetFruits)
        _G.Settings.FruitEnabled = _G.Settings.GetFruits
        _G.Settings.RainbowHaki = bool(cfg["Rainbow Haki"], _G.Settings.RainbowHaki)
        _G.Settings.Shutdown = bool(cfg["Shutdown"], _G.Settings.Shutdown)
        _G.Settings.SnipeFruit = str(cfg["Snipe Fruit"], _G.Settings.SnipeFruit)
        _G.Settings.SwitchMelee = bool(cfg["Switch Melee"], _G.Settings.SwitchMelee)
        _G.Settings.LockFragment = math.max(0, num(cfg["Lock Fragment"], _G.Settings.LockFragment))
        _G.Settings.HopPlayerNear = bool(cfg["Hop Player Near"], _G.Settings.HopPlayerNear)

        local fps = cfg["FPS Boost"]
        if type(fps) == "table" then
            _G.Settings.FPSBoostEnabled = bool(fps.Enable, _G.Settings.FPSBoostEnabled)
            _G.Settings.FPSCap = math.clamp(num(fps["FPS Cap"], _G.Settings.FPSCap), 1, 240)
            _G.Settings.FPSHideGameUI = bool(fps["Hide Game UI"], _G.Settings.FPSHideGameUI)
            _G.Settings.FPSDisable3DRender = bool(fps["Disable 3D Render"], _G.Settings.FPSDisable3DRender)
        end

        local boss = cfg["Farm Boss Drops"]
        if type(boss) == "table" then
            _G.Settings.FarmBossDrops = bool(boss.Enable, _G.Settings.FarmBossDrops)
            _G.Settings.BossDropsWhen2xExpired = bool(boss["When x2 Exp Expired"], _G.Settings.BossDropsWhen2xExpired)
        end

        local mastery = cfg["Farm Mastery"]
        if type(mastery) == "table" then
            _G.Settings.FarmMasteryEnabled = bool(mastery.Enable, _G.Settings.FarmMasteryEnabled)
            _G.Settings.FarmMasteryWeapons = arr(mastery["Farm Mastery Weapons"])
            _G.Settings.FarmMasteryGuns = arr(mastery["Guns To Farm"])
            _G.Settings.FarmMasterySwords = arr(mastery["Swords To Farm"])
            _G.Settings.MasteryHealthPercent = math.clamp(num(mastery["Mastery Health (%)"], _G.Settings.MasteryHealthPercent), 1, 100)
        end

        local hop = cfg.Hop
        if type(hop) == "table" then
            _G.Settings.HopEnabled = bool(hop.Enable, _G.Settings.HopEnabled)
            _G.Settings.HopFindFruit = bool(hop["Find Fruit"], _G.Settings.HopFindFruit)
            _G.Settings.HopElite = bool(hop["Hop Elite"], _G.Settings.HopElite)
            _G.Settings.HopFindDarkbeard = bool(hop["Hop Find Darkbeard"], _G.Settings.HopFindDarkbeard)
            _G.Settings.HopFindMirage = bool(hop["Hop Find Mirage"], _G.Settings.HopFindMirage)
            _G.Settings.HopFindMirrorFractal = bool(hop["Hop Find Mirror Fractal"], _G.Settings.HopFindMirrorFractal)
            _G.Settings.HopFindSoulReaper = bool(hop["Hop Find Soul Reaper"], _G.Settings.HopFindSoulReaper)
            _G.Settings.HopFindTushita = bool(hop["Hop Find Tushita"], _G.Settings.HopFindTushita)
            _G.Settings.HopFindValkyrieHelm = bool(hop["Hop Find Valkyrie Helm"], _G.Settings.HopFindValkyrieHelm)
        end
    end
end

-- ══════════════════════════════════════════════════════════════════
--              STATE MANAGER v7
--   ActionToken system chống race condition
--   State consistency checks
--   Centralized target/action management
-- ══════════════════════════════════════════════════════════════════
_G.BobonStatus = "Initializing..."
_G.BobonDiagnostics = {
    Tool = "wait",
    Net = "wait",
    Targets = 0,
    Packet = "wait",
    Bring = "wait",
    BringCandidates = 0,
    BringOwned = 0,
    BringMoved = 0,
}

-- Submerged is a bounded region, not every negative-Y point in Third Sea.
-- Full XYZ checks prevent an ordinary ocean fall from being misclassified as
-- a valid underwater island and disabling the anti-fall rescue forever.
local SUBMERGED_REGION = {
    MinX = 8400, MaxX = 12300,
    MinZ = 8000, MaxZ = 11500,
    MinY = _G.Settings.UnderwaterMinY or -2300,
    MaxY = -100,
}

local function IsFiniteNumber(value)
    return type(value) == "number" and value == value
        and value > -math.huge and value < math.huge
end

local function IsFiniteVector3(pos)
    return typeof(pos) == "Vector3"
        and IsFiniteNumber(pos.X)
        and IsFiniteNumber(pos.Y)
        and IsFiniteNumber(pos.Z)
end

local function IsSubmergedPosition(pos)
    if game.PlaceId ~= 7449423635 or not IsFiniteVector3(pos) then return false end
    local bounds = SUBMERGED_REGION
    return pos.X >= bounds.MinX and pos.X <= bounds.MaxX
        and pos.Z >= bounds.MinZ and pos.Z <= bounds.MaxZ
        and pos.Y >= bounds.MinY and pos.Y <= bounds.MaxY
end

local function IsAllowedWorldPosition(pos)
    return IsFiniteVector3(pos)
        and (pos.Y >= _G.Settings.MinY - 10 or IsSubmergedPosition(pos))
end


_G.State = {
    Mode             = "Idle",
    FState           = "IDLE",
    CurrentTarget    = nil,
    FarmTarget       = nil,
    KillCount        = 0,
    StartTime        = os.time(),
    LastRandomFruit  = 0,
    LastServerHop    = 0,
    LastQuestRequest = 0,
    LastQuestAccepted= 0,
    QuestRetries     = 0,
    -- Canonical workspace enemy name for the quest that is actually active.
    -- Quest UI may be localized, so gathering must not infer a mob name from
    -- the visible translated text on every frame.
    ActiveQuestMob   = nil,
    -- v18.6 persistent cluster state. Anchor is independent from FarmTarget.
    ClusterMode      = "OFF",
    ClusterAnchor    = nil,
    ClusterMobName   = nil,
    ClusterMobNames  = nil,
    ClusterPrimary   = nil,
    ClusterGeneration= 0,
    ClusterActivatedAt = 0,
    ClusterLastSeen  = 0,
    ClusterLastMoved = 0,
    IsTraveling      = false,
    IsRecovering     = false,
    ActionToken      = 0,
    ActiveActionToken= 0,
    ActionOwner      = nil,
    ActionStartTime  = 0,
    MovementOwner    = nil,
    TravelID         = 0,
    LastMoveTime     = os.time(),
    LastPosition     = nil,
    LastAttackTime   = 0,
    LastIncomingDamage = 0,
    LastTargetContested = 0,
    ContestedTarget  = nil,
    ContestedBy      = nil,
    ConsecutiveFails = 0,
    Sea              = 1,
}


function _G.State:SetMode(mode)
    self.Mode = mode
    _G.BobonStatus = mode
end


function _G.State:CanAct()
    return self.ActiveActionToken == 0
        and not self.IsRecovering
        and self.Mode ~= "Dead"
        and self.Mode ~= "Respawning"
        and self.Mode ~= "ServerHop"
end


function _G.State:CanRequestTravel()
    return not self.IsRecovering
        and self.Mode ~= "Dead"
        and self.Mode ~= "Respawning"
        and self.Mode ~= "ServerHop"
end


function _G.State:ClaimAction(owner)
    if self.ActiveActionToken ~= 0 then return 0 end
    self.ActionToken = self.ActionToken + 1
    self.ActiveActionToken = self.ActionToken
    self.ActionOwner = owner
    self.ActionStartTime = os.time()
    return self.ActiveActionToken
end


function _G.State:IsActionValid(myToken)
    return myToken > 0 and myToken == self.ActiveActionToken
end

function _G.State:TouchAction(myToken)
    if self:IsActionValid(myToken) then
        self.ActionStartTime = os.time()
        return true
    end
    return false
end


function _G.State:ReleaseAction(myToken)
    if myToken > 0 and myToken == self.ActiveActionToken then
        self.ActiveActionToken = 0
        self.ActionOwner = nil
        self.ActionStartTime = 0
    end
end


function _G.State:ForceReleaseAction(reason)
    self.ActiveActionToken = 0
    self.ActionOwner = nil
    self.ActionStartTime = 0
end


function _G.State:ClearTargets()
    self.CurrentTarget = nil
    self.FarmTarget = nil
    self.ContestedTarget = nil
    self.ContestedBy = nil
    self.LastTargetContested = 0
end


function _G.State:IsTargetValid(target)
    if not target then return false end
    if typeof(target) ~= "Instance" then return false end
    if not target.Parent then return false end
    local hum = target:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local root = target:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    -- [FIX-7] Reject target o duoi bien / vi tri bat thuong
    local ok, position = pcall(function() return root.Position end)
    if not ok or not IsAllowedWorldPosition(position) then return false end
    return true
end


-- State consistency watchdog (Fix #22)
task.spawn(function()
    while SessionAlive() and task.wait(5) do
        pcall(function()
            -- Fix state contradictions
            if _G.State.Mode == "Idle" and _G.State.IsTraveling and not _G.State.MovementOwner then
                _G.State.IsTraveling = false
            end
            if _G.State.Mode == "Dead" or _G.State.Mode == "Respawning" then
                if _G.State.IsTraveling then _G.State.IsTraveling = false end
                if _G.State.MovementOwner then _G.State.MovementOwner = nil end
            end
            -- Action timeout watchdog
            if _G.State.ActiveActionToken ~= 0 and _G.State.ActionStartTime > 0 then
                if os.time() - _G.State.ActionStartTime > _G.Settings.ActionLockTimeout then
                    warn("[Watchdog] Action timeout: " .. tostring(_G.State.ActionOwner))
                    _G.State:ForceReleaseAction("WatchdogTimeout")
                    _G.State:SetMode("Idle")
                end
            end
        end)
    end
end)


-- ══════════════════════════════════════════════════════════════════
--             UI — GLASS NEON HUD V2.2 BOOT-SAFE
--   Self-contained + protected: UI failure must NEVER stop kaitun core.
-- ══════════════════════════════════════════════════════════════════
do
    local okUI, uiErr = pcall(function()
        local UIS = game:GetService("UserInputService")
        local Lighting = game:GetService("Lighting")

        local function SafeDestroy(obj)
            pcall(function()
                if obj then obj:Destroy() end
            end)
        end

        local function ResolveUIParent()
            local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
            if pg then return pg end
            if type(gethui) == "function" then
                local ok, hui = pcall(gethui)
                if ok and hui then return hui end
            end
            local okCore = pcall(function() return CoreGui.Name end)
            if okCore then return CoreGui end
            return nil
        end

        local uiParent = ResolveUIParent()
        if not uiParent then error("No UI parent available") end

        SafeDestroy(uiParent:FindFirstChild("BobonHubUI"))
        pcall(function()
            SafeDestroy(Lighting:FindFirstChild("BobonHubBlur"))
            local cam = workspace.CurrentCamera
            if cam then SafeDestroy(cam:FindFirstChild("BobonHubBlur")) end
        end)

        local SG = Instance.new("ScreenGui")
        SG.Name = "BobonHubUI"
        SG.ResetOnSpawn = false
        SG.IgnoreGuiInset = true
        SG.DisplayOrder = 10000
        SG.Parent = uiParent

        local ACCENT_A = Color3.fromRGB(72,223,255)
        local ACCENT_B = Color3.fromRGB(139,92,246)
        local ACCENT_C = Color3.fromRGB(55,255,180)
        local TEXT_MAIN = Color3.fromRGB(244,249,255)
        local TEXT_MUTED = Color3.fromRGB(145,166,194)
        local PANEL_TOP = Color3.fromRGB(16,24,40)
        local PANEL_BOTTOM = Color3.fromRGB(7,12,24)
        local CARD_BG = Color3.fromRGB(17,29,48)

        local function Corner(obj, px)
            local x = Instance.new("UICorner")
            x.CornerRadius = UDim.new(0, px or 12)
            x.Parent = obj
            return x
        end

        local function Stroke(obj, color, transparency, thickness)
            local x = Instance.new("UIStroke")
            x.Color = color or ACCENT_A
            x.Transparency = transparency or 0.5
            x.Thickness = thickness or 1
            x.Parent = obj
            return x
        end

        local function Gradient(obj, c1, c2, rotation)
            local x = Instance.new("UIGradient")
            x.Color = ColorSequence.new(c1, c2)
            x.Rotation = rotation or 0
            x.Parent = obj
            return x
        end

        local function Text(parent, value, size, color, bold, align)
            local x = Instance.new("TextLabel")
            x.BackgroundTransparency = 1
            x.BorderSizePixel = 0
            x.Text = value or ""
            x.TextColor3 = color or TEXT_MAIN
            x.TextSize = size or 13
            x.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
            x.TextXAlignment = align or Enum.TextXAlignment.Left
            x.TextYAlignment = Enum.TextYAlignment.Center
            x.Parent = parent
            return x
        end

        local function Card(parent, pos, size)
            local x = Instance.new("Frame")
            x.Position = pos
            x.Size = size
            x.BackgroundColor3 = CARD_BG
            x.BackgroundTransparency = 0.26
            x.BorderSizePixel = 0
            x.Parent = parent
            Corner(x, 13)
            Stroke(x, Color3.fromRGB(110,175,220), 0.78, 1)
            Gradient(x, Color3.fromRGB(25,45,68), Color3.fromRGB(11,18,34), 90)
            return x
        end

        _G.Settings.MenuBlur = tonumber(_G.Settings.MenuBlur) or 7
        local Blur
        pcall(function()
            Blur = Instance.new("BlurEffect")
            Blur.Name = "BobonHubBlur"
            Blur.Size = 0
            Blur.Enabled = true
            Blur.Parent = Lighting
        end)

        local Panel = Instance.new("Frame")
        Panel.Name = "GlassNeonV21"
        Panel.AnchorPoint = Vector2.new(0,0.5)
        Panel.Position = UDim2.new(0,24,0.5,0)
        Panel.Size = UDim2.new(0,470,0,368)
        Panel.BackgroundColor3 = PANEL_TOP
        Panel.BackgroundTransparency = 0.10
        Panel.BorderSizePixel = 0
        Panel.ClipsDescendants = true
        Panel.Parent = SG
        Corner(Panel, 20)
        Gradient(Panel, PANEL_TOP, PANEL_BOTTOM, 115)
        local PanelStroke = Stroke(Panel, ACCENT_A, 0.24, 1.4)

        local PanelScale = Instance.new("UIScale")
        PanelScale.Scale = 0.96
        PanelScale.Parent = Panel

        local NeonLine = Instance.new("Frame")
        NeonLine.Position = UDim2.new(0,18,0,0)
        NeonLine.Size = UDim2.new(1,-36,0,2)
        NeonLine.BackgroundColor3 = ACCENT_A
        NeonLine.BorderSizePixel = 0
        NeonLine.Parent = Panel
        Corner(NeonLine, 2)
        local NeonGradient = Gradient(NeonLine, ACCENT_A, ACCENT_B, 0)

        local Header = Instance.new("Frame")
        Header.Position = UDim2.new(0,18,0,14)
        Header.Size = UDim2.new(1,-36,0,48)
        Header.BackgroundTransparency = 1
        Header.Active = true
        Header.Parent = Panel

        local Brand = Text(Header, "◈  BOBON HUB", 20, TEXT_MAIN, true)
        Brand.Position = UDim2.new(0,0,0,0)
        Brand.Size = UDim2.new(0.58,0,0,24)

        local Sub = Text(Header, "GLASS NEON V2.2  •  KAITUN", 10, ACCENT_A, true)
        Sub.Position = UDim2.new(0,27,0,24)
        Sub.Size = UDim2.new(0.60,0,0,18)

        local OnlineDot = Instance.new("Frame")
        OnlineDot.AnchorPoint = Vector2.new(1,0.5)
        OnlineDot.Position = UDim2.new(1,-63,0,16)
        OnlineDot.Size = UDim2.new(0,8,0,8)
        OnlineDot.BackgroundColor3 = ACCENT_C
        OnlineDot.BorderSizePixel = 0
        OnlineDot.Parent = Header
        Corner(OnlineDot, 8)
        local OnlineL = Text(Header, "ONLINE", 10, ACCENT_C, true, Enum.TextXAlignment.Right)
        OnlineL.AnchorPoint = Vector2.new(1,0)
        OnlineL.Position = UDim2.new(1,0,0,6)
        OnlineL.Size = UDim2.new(0,55,0,20)
        local Ver = Text(Header, "v18.8", 9, TEXT_MUTED, false, Enum.TextXAlignment.Right)
        Ver.AnchorPoint = Vector2.new(1,0)
        Ver.Position = UDim2.new(1,0,0,27)
        Ver.Size = UDim2.new(0,55,0,16)

        local LevelCard = Card(Panel, UDim2.new(0,18,0,70), UDim2.new(0.5,-22,0,58))
        local LevelCap = Text(LevelCard, "LEVEL", 9, TEXT_MUTED, true)
        LevelCap.Position = UDim2.new(0,14,0,7); LevelCap.Size = UDim2.new(1,-28,0,15)
        local LevelValue = Text(LevelCard, "1", 23, TEXT_MAIN, true)
        LevelValue.Position = UDim2.new(0,14,0,21); LevelValue.Size = UDim2.new(1,-28,0,30)

        local SeaCard = Card(Panel, UDim2.new(0.5,4,0,70), UDim2.new(0.5,-22,0,58))
        local SeaCap = Text(SeaCard, "WORLD", 9, TEXT_MUTED, true)
        SeaCap.Position = UDim2.new(0,14,0,7); SeaCap.Size = UDim2.new(1,-28,0,15)
        local SeaValue = Text(SeaCard, "SEA 1", 20, ACCENT_A, true)
        SeaValue.Position = UDim2.new(0,14,0,22); SeaValue.Size = UDim2.new(0.55,-14,0,28)
        local TeamL = Text(SeaCard, "PIRATES ✓", 10, ACCENT_C, true, Enum.TextXAlignment.Right)
        TeamL.Position = UDim2.new(0.52,0,0,24); TeamL.Size = UDim2.new(0.48,-14,0,24)

        local StatusCard = Card(Panel, UDim2.new(0,18,0,136), UDim2.new(1,-36,0,78))
        local StatusDot = Instance.new("Frame")
        StatusDot.Position = UDim2.new(0,14,0,17)
        StatusDot.Size = UDim2.new(0,9,0,9)
        StatusDot.BackgroundColor3 = ACCENT_C
        StatusDot.BorderSizePixel = 0
        StatusDot.Parent = StatusCard
        Corner(StatusDot, 9)
        local ModeL = Text(StatusCard, "FARMING", 10, ACCENT_C, true)
        ModeL.Position = UDim2.new(0,31,0,10); ModeL.Size = UDim2.new(0.45,0,0,20)
        local FlagL = Text(StatusCard, "READY", 9, ACCENT_A, true, Enum.TextXAlignment.Right)
        FlagL.Position = UDim2.new(0.52,0,0,10); FlagL.Size = UDim2.new(0.48,-14,0,20)
        local StatusL = Text(StatusCard, "Initializing...", 16, TEXT_MAIN, true)
        StatusL.Position = UDim2.new(0,14,0,31); StatusL.Size = UDim2.new(1,-28,0,27)
        local ClusterL = Text(StatusCard, "Cluster: waiting", 10, TEXT_MUTED, false)
        ClusterL.Position = UDim2.new(0,14,1,-20); ClusterL.Size = UDim2.new(1,-28,0,15)

        local BeliCard = Card(Panel, UDim2.new(0,18,0,222), UDim2.new(0.5,-22,0,54))
        local BeliCap = Text(BeliCard, "BELI", 9, TEXT_MUTED, true)
        BeliCap.Position = UDim2.new(0,12,0,7); BeliCap.Size = UDim2.new(1,-24,0,13)
        local BeliL = Text(BeliCard, "$ 0", 16, Color3.fromRGB(93,255,151), true)
        BeliL.Position = UDim2.new(0,12,0,21); BeliL.Size = UDim2.new(1,-24,0,25)

        local FragCard = Card(Panel, UDim2.new(0.5,4,0,222), UDim2.new(0.5,-22,0,54))
        local FragCap = Text(FragCard, "FRAGMENTS", 9, TEXT_MUTED, true)
        FragCap.Position = UDim2.new(0,12,0,7); FragCap.Size = UDim2.new(1,-24,0,13)
        local FragL = Text(FragCard, "◈ 0", 16, Color3.fromRGB(194,135,255), true)
        FragL.Position = UDim2.new(0,12,0,21); FragL.Size = UDim2.new(1,-24,0,25)

        local KillCard = Card(Panel, UDim2.new(0,18,0,284), UDim2.new(0.5,-22,0,48))
        local KillCap = Text(KillCard, "KILLS", 9, TEXT_MUTED, true)
        KillCap.Position = UDim2.new(0,12,0,5); KillCap.Size = UDim2.new(0.4,0,0,13)
        local KillL = Text(KillCard, "0", 15, Color3.fromRGB(255,119,145), true)
        KillL.Position = UDim2.new(0,12,0,18); KillL.Size = UDim2.new(1,-24,0,23)

        local TimeCard = Card(Panel, UDim2.new(0.5,4,0,284), UDim2.new(0.5,-22,0,48))
        local TimeCap = Text(TimeCard, "RUNTIME", 9, TEXT_MUTED, true)
        TimeCap.Position = UDim2.new(0,12,0,5); TimeCap.Size = UDim2.new(0.48,0,0,13)
        local TimeL = Text(TimeCard, "00:00:00", 15, TEXT_MAIN, true)
        TimeL.Position = UDim2.new(0,12,0,18); TimeL.Size = UDim2.new(1,-24,0,23)

        local Footer = Instance.new("Frame")
        Footer.Position = UDim2.new(0,18,1,-28)
        Footer.Size = UDim2.new(1,-36,0,18)
        Footer.BackgroundTransparency = 1
        Footer.Parent = Panel
        local CombatL = Text(Footer, "COMBAT  WAITING", 9, Color3.fromRGB(255,190,102), true)
        CombatL.Position = UDim2.new(0,0,0,0); CombatL.Size = UDim2.new(0.52,0,1,0)
        local BringL = Text(Footer, "BRING  WAITING", 9, TEXT_MUTED, true, Enum.TextXAlignment.Right)
        BringL.Position = UDim2.new(0.48,0,0,0); BringL.Size = UDim2.new(0.52,0,1,0)

        local Toggle = Instance.new("TextButton")
        Toggle.AnchorPoint = Vector2.new(0,0.5)
        Toggle.Position = UDim2.new(0,10,0.5,0)
        Toggle.Size = UDim2.new(0,36,0,36)
        Toggle.BackgroundColor3 = Color3.fromRGB(10,22,39)
        Toggle.BackgroundTransparency = 0.08
        Toggle.BorderSizePixel = 0
        Toggle.Text = "◈"
        Toggle.TextColor3 = ACCENT_A
        Toggle.TextSize = 17
        Toggle.Font = Enum.Font.GothamBold
        Toggle.AutoButtonColor = false
        Toggle.Parent = SG
        Corner(Toggle, 12)
        Stroke(Toggle, ACCENT_A, 0.20, 1.4)

        local function Fmt(n)
            local s = tostring(math.floor(tonumber(n) or 0))
            return s:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
        end

        local visible = true
        local busy = false
        local function SetVisible(v)
            if busy or v == visible then return end
            busy = true
            visible = v
            if v then
                Panel.Visible = true
                PanelScale.Scale = 0.95
                pcall(function() TS:Create(PanelScale, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Scale=1}):Play() end)
                pcall(function() if Blur then TS:Create(Blur, TweenInfo.new(0.25), {Size=_G.Settings.MenuBlur}):Play() end end)
                task.delay(0.28, function() busy = false end)
            else
                pcall(function() TS:Create(PanelScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Scale=0.95}):Play() end)
                pcall(function() if Blur then TS:Create(Blur, TweenInfo.new(0.18), {Size=0}):Play() end end)
                task.delay(0.20, function()
                    if not visible then Panel.Visible = false end
                    busy = false
                end)
            end
        end

        Toggle.MouseButton1Click:Connect(function() SetVisible(not visible) end)
        UIS.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == Enum.KeyCode.RightControl then
                SetVisible(not visible)
            end
        end)

        -- Header drag. All handler bodies are protected so executor quirks cannot kill core.
        do
            local dragging, dragStart, startPos, dragInput = false, nil, nil, nil
            Header.InputBegan:Connect(function(input)
                pcall(function()
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        dragStart = input.Position
                        startPos = Panel.Position
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then dragging = false end
                        end)
                    end
                end)
            end)
            Header.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input
                end
            end)
            UIS.InputChanged:Connect(function(input)
                pcall(function()
                    if dragging and input == dragInput and dragStart and startPos then
                        local delta = input.Position - dragStart
                        Panel.Position = UDim2.new(
                            startPos.X.Scale, startPos.X.Offset + delta.X,
                            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    end
                end)
            end)
        end

        -- Opening animation is optional; errors here are isolated.
        pcall(function()
            PanelScale.Scale = 0.94
            TS:Create(PanelScale, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Scale=1}):Play()
            if Blur then TS:Create(Blur, TweenInfo.new(0.35), {Size=_G.Settings.MenuBlur}):Play() end
        end)

        task.spawn(function()
            while SessionAlive() and SG.Parent do
                pcall(function()
                    local state = _G.State or {}
                    local diag = _G.BobonDiagnostics or {}
                    local elapsed = os.time() - (state.StartTime or os.time())
                    TimeL.Text = ("%02d:%02d:%02d"):format(
                        math.floor(elapsed/3600), math.floor(elapsed%3600/60), elapsed%60)

                    local d = LP:FindFirstChild("Data")
                    local lv = d and d:FindFirstChild("Level") and d.Level.Value or 1
                    local beli = d and d:FindFirstChild("Beli") and d.Beli.Value or 0
                    local frag = d and d:FindFirstChild("Fragments") and d.Fragments.Value or 0
                    LevelValue.Text = Fmt(lv)
                    SeaValue.Text = "SEA " .. tostring(state.Sea or 1)
                    TeamL.Text = string.upper(tostring(_G.Settings.Team or "Pirates")) .. " ✓"
                    BeliL.Text = "$ " .. Fmt(beli)
                    FragL.Text = "◈ " .. Fmt(frag)
                    KillL.Text = Fmt(state.KillCount or 0)

                    local mode = tostring(state.Mode or "Idle")
                    ModeL.Text = string.upper(mode)
                    StatusL.Text = tostring(_G.BobonStatus or "Idle")
                    if mode == "Farming" then StatusDot.BackgroundColor3 = ACCENT_C
                    elseif mode == "Recovering" or mode == "Dead" then StatusDot.BackgroundColor3 = Color3.fromRGB(255,92,115)
                    else StatusDot.BackgroundColor3 = ACCENT_A end

                    local clusterMode = tostring(state.ClusterMode or "OFF")
                    local candidates = tonumber(diag.BringCandidates) or 0
                    local owned = tonumber(diag.BringOwned) or 0
                    local moved = tonumber(diag.BringMoved) or 0
                    if clusterMode ~= "OFF" then
                        ClusterL.Text = ("Cluster %s  •  %d mobs  •  owned %d  •  moved %d")
                            :format(clusterMode, candidates, owned, moved)
                    else
                        ClusterL.Text = "Cluster OFF  •  waiting"
                    end

                    if state.FState == "SKIP_FARM" and (state.Sea or 1) == 1 then
                        FlagL.Text = lv <= 50 and "SKIP • FLOOR 1" or "SKIP • FLOOR 2"
                    elseif state.LastTargetContested and tick() - state.LastTargetContested <= (_G.Settings.ContestGrace or 3) then
                        FlagL.Text = "CONTESTED"
                    elseif clusterMode ~= "OFF" then
                        FlagL.Text = "CLUSTER ×" .. tostring(candidates)
                    else
                        FlagL.Text = "READY"
                    end

                    local packet = tostring(diag.Packet or "WAITING")
                    local ready = packet:find("CONFIRMED",1,true) ~= nil
                    CombatL.Text = ready and "COMBAT  READY" or ("COMBAT  " .. packet)
                    CombatL.TextColor3 = ready and ACCENT_C or Color3.fromRGB(255,190,102)
                    BringL.Text = moved > 0 and ("BRING  FULL BATCH ×" .. tostring(moved))
                        or ("BRING  " .. tostring(diag.Bring or "WAITING"))
                    BringL.TextColor3 = moved > 0 and ACCENT_A or TEXT_MUTED
                end)
                task.wait(0.35)
            end
        end)

        task.spawn(function()
            while SessionAlive() and SG.Parent do
                pcall(function()
                    NeonGradient.Rotation = (NeonGradient.Rotation + 12) % 360
                    OnlineDot.BackgroundTransparency = OnlineDot.BackgroundTransparency > 0.2 and 0 or 0.45
                    PanelStroke.Color = PanelStroke.Color == ACCENT_A and ACCENT_B or ACCENT_A
                end)
                task.wait(0.8)
            end
        end)
    end)

    if not okUI then
        warn("[BobonHub] UI Error: " .. tostring(uiErr))
        -- UI is optional. Core kaitun continues even when this executor rejects a GUI API.
    end
end

-- ══════════════════════════════════════════════════════════════════
--                       HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════════
local function Char() return LP.Character end
local function HRP() local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum() local c=Char(); return c and c:FindFirstChild("Humanoid") end
local function IsAlive() local h=Hum(); return h and h.Health > 0 end


local function Level()
    local d=LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Level") and d.Level.Value or 1
end


local function Beli()
    local d=LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Beli") and d.Beli.Value or 0
end


local function Points()
    local d=LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Points") and d.Points.Value or 0
end


local function GetSea()
    local id = game.PlaceId
    if id == 2753915549 then return 1 end
    if id == 4442272183 then return 2 end
    if id == 7449423635 then return 3 end
    return 1
end


local function HasItem(name)
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    return (backpack and backpack:FindFirstChild(name))
        or (Char() and Char():FindFirstChild(name))
end

local function Fragments()
    local d = LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Fragments") and d.Fragments.Value or 0
end

local function CanSpendFragments(cost)
    local reserve = math.max(0, tonumber(_G.Settings and _G.Settings.LockFragment or 0) or 0)
    return Fragments() - (tonumber(cost) or 0) >= reserve
end

local function FindOwnedTool(name)
    local c = Char()
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    return (c and c:FindFirstChild(name)) or (backpack and backpack:FindFirstChild(name))
end

local function ToolMastery(name)
    local tool = FindOwnedTool(name)
    local lv = tool and tool:FindFirstChild("Level")
    return lv and tonumber(lv.Value) or 0
end

local function EquipNamedTool(name)
    local c = Char()
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    local tool = FindOwnedTool(name)
    if not c or not hum or not tool then return false end
    if tool.Parent ~= c then
        pcall(function() hum:EquipTool(tool) end)
        task.wait(0.2)
    end
    return tool.Parent == c
end

-- Server inventory is authoritative for items/materials that are not currently
-- represented by a Tool. Cache it to avoid hammering CommF_ every controller tick.
local InventoryCache = { At = 0, Rows = {} }
local function GetInventoryRows(force)
    local now = tick()
    if not force and now - InventoryCache.At < (_G.Settings.InventoryCacheTTL or 5) then
        return InventoryCache.Rows
    end
    local rows = {}
    local ok, result = pcall(function() return CommF_:InvokeServer("getInventory") end)
    if ok and type(result) == "table" then rows = result end
    InventoryCache.At, InventoryCache.Rows = now, rows
    return rows
end

local function InventoryHas(name)
    if HasItem(name) then return true end
    local wanted = string.lower(tostring(name))
    for _, row in pairs(GetInventoryRows(false)) do
        if type(row) == "table" then
            local n = row.Name or row.name or row.Item or row.ItemName
            if n and string.lower(tostring(n)) == wanted then return true end
        end
    end
    return false
end

local function MaterialCount(name)
    local wanted = string.lower(tostring(name))
    local best = 0
    for _, row in pairs(GetInventoryRows(false)) do
        if type(row) == "table" then
            local n = row.Name or row.name or row.Item or row.ItemName
            if n and string.lower(tostring(n)) == wanted then
                local c = tonumber(row.Count or row.count or row.Amount or row.amount
                    or row.Quantity or row.quantity or row.Value or 1) or 0
                if c > best then best = c end
            end
        end
    end
    return best
end


local WeaponInventoryCache = { At = 0, Rows = {} }
local function EffectiveMastery(name)
    local live = ToolMastery(name)
    if live > 0 then return live end
    local now = tick()
    if now - WeaponInventoryCache.At >= (_G.Settings.InventoryCacheTTL or 5) then
        local rows = {}
        local ok, result = pcall(function() return CommF_:InvokeServer("getInventoryWeapons") end)
        if ok and type(result) == "table" then rows = result end
        WeaponInventoryCache.At, WeaponInventoryCache.Rows = now, rows
    end
    local wanted = string.lower(tostring(name))
    for _, row in pairs(WeaponInventoryCache.Rows) do
        if type(row) == "table" and row.Name and string.lower(tostring(row.Name)) == wanted then
            return tonumber(row.Mastery or row.Level or row.MasteryLevel or 0) or 0
        end
    end
    return 0
end

local function TryClickDetector(root)
    if not root then return false end
    local detector = root:IsA("ClickDetector") and root or root:FindFirstChildWhichIsA("ClickDetector", true)
    if not detector or type(fireclickdetector) ~= "function" then return false end
    return pcall(function() fireclickdetector(detector) end)
end


local function HasQuest()
    local ok, r = pcall(function()
        local main = LP:FindFirstChild("PlayerGui")
            and LP.PlayerGui:FindFirstChild("Main")
        local quest = main and main:FindFirstChild("Quest")
        -- nil means the quest UI is not ready/readable yet.  Do not let the
        -- main controller mistake that transient state for a safe item window.
        if not quest then return nil end
        local function IsDynamicQuestLabel(node)
            if not node:IsA("TextLabel") or not node.Visible then return false end
            local text = tostring(node.Text or "")
            local lower = string.lower(text)
            if text == "" or lower == "quest" or lower == "quest details"
                or lower == "objectives" or lower == "objective" then
                return false
            end
            local nodeName = string.lower(node.Name)
            -- Current UI uses QuestTitle.Title.  Older builds may expose a
            -- label named Task/Objective instead, so accept those explicitly.
            if nodeName:find("title", 1, true)
                or nodeName:find("task", 1, true)
                or nodeName:find("objective", 1, true) then
                return true
            end
            -- Last fallback: quest objectives normally contain a counter or
            -- an action verb; static panel labels do not.
            return lower:find("defeat", 1, true) ~= nil
                or lower:find("kill", 1, true) ~= nil
                or lower:find("collect", 1, true) ~= nil
                or lower:find("bounty", 1, true) ~= nil
                or lower:match("%d+%s*/%s*%d+") ~= nil
        end
        -- The wrapper is the authoritative active/inactive signal in the
        -- current UI.  A hidden wrapper means the previous quest is over.
        if quest:IsA("GuiObject") and not quest.Visible then return false end
        local container = quest:FindFirstChild("Container") or quest
        local title = container:FindFirstChild("QuestTitle", true)
        local titleText = title and title:FindFirstChild("Title", true)

        -- Completed objectives can leave the title text visible for a short
        -- time.  A visible x/y counter at x >= y is an immediate completion
        -- signal, so request the next quest on this same controller tick.
        for _, node in ipairs(container:GetDescendants()) do
            if node:IsA("TextLabel") and node.Visible then
                local labelText = tostring(node.Text or "")
                local labelLower = string.lower(labelText)
                if labelLower:find("quest completed", 1, true)
                    or labelLower:find("quest complete", 1, true)
                    or labelLower:find("completed", 1, true)
                    or labelLower:find("finished", 1, true) then
                    return false
                end
                local current, total = labelText:match("(%d+)%s*/%s*(%d+)")
                if current and total and tonumber(current) >= tonumber(total) then
                    return false
                end
            end
        end

        if titleText and titleText:IsA("TextLabel") then
            local text = tostring(titleText.Text or "")
            local lower = string.lower(text)
            if text ~= "" and lower ~= "quest" and lower ~= "quest details" then
                return true
            end
        end
        -- Fallback for builds that omit QuestTitle but expose visible labels.
        for _, node in ipairs(container:GetDescendants()) do
            if IsDynamicQuestLabel(node) then return true end
        end
        return false
    end)
    if not ok then return nil end
    return r
end


-- [FIX-P11] Kiểm tra Vector3 hợp lệ (reject NaN / vô hạn)
local function IsValidPos(p)
    return IsFiniteVector3(p)
end

-- Enemy models thường có hậu tố "[Lv. n]"; chuẩn hoá để FindNearestMob
-- vẫn tìm được mob ở mọi sea và không bị phụ thuộc tên hiển thị của server.
local function IsEnemyNamed(enemy, wanted)
    if not enemy or not wanted then return false end
    local function normalize(value)
        value = tostring(value):gsub("%s*%[%s*Lv%.%s*%d+%s*%]", "")
        -- Boss models are commonly named `Name [Lv. n] [Boss]` (or
        -- `[Raid Boss]`).  Keep the database names clean and strip those
        -- display-only tags before comparing.
        value = value:gsub("%s*%[%s*Raid%s+Boss%s*%]", "")
        value = value:gsub("%s*%[%s*Boss%s*%]", "")
        value = value:gsub("^%s+", ""):gsub("%s+$", "")
        return string.lower(value)
    end
    return normalize(enemy.Name) == normalize(wanted)
end


-- [A-8] DEBUG log: chỉ in khi _G.Settings.DEBUG = true, không spam console
local function DLog(tag, msg)
    if _G.Settings and _G.Settings.DEBUG then
        print("[" .. tag .. "] " .. msg)
    end
end

-- v18.1 CONTINUITY: damage/PvP/NPC control effects are transient external
-- interference, never a reason to abandon Farm/Boss/Item/Katakuri work.
local function HasControlInterference()
    local character = Char()
    if not character then return false end
    for _, flagName in ipairs({"Stun", "Busy"}) do
        local flag = character:FindFirstChild(flagName)
        if flag and ((flag:IsA("BoolValue") and flag.Value)
            or (flag:IsA("NumberValue") and flag.Value > 0)) then
            return true
        end
        local attr = character:GetAttribute(flagName)
        if attr == true or (type(attr) == "number" and attr > 0) then
            return true
        end
    end
    return false
end

local function HasRecentExternalInterference()
    if not (_G.Settings and _G.Settings.ContinuityMode) then return false end
    local grace = _G.Settings.ExternalInterferenceGrace or 3
    local damaged = tick() - (_G.State.LastIncomingDamage or 0) <= grace
    return damaged or HasControlInterference()
end


-- [FIX-P2] Đọc quest text với nhiều fallback (TextLabel chính + QuestModel)
-- Trả về text đọc được, hoặc nil nếu UI không đọc được.
local function GetQuestText()
    local ok, text = pcall(function()
        local main = LP:FindFirstChild("PlayerGui")
            and LP.PlayerGui:FindFirstChild("Main")
        local quest = main and main:FindFirstChild("Quest")
        if not quest then return nil end
        local container = quest:FindFirstChild("Container") or quest
        local title = container:FindFirstChild("QuestTitle", true)
        local titleText = title and title:FindFirstChild("Title", true)
        if titleText and titleText:IsA("TextLabel") then
            -- When the canonical title exists but is empty, the quest is
            -- genuinely closed; do not resurrect stale descendant labels.
            if titleText.Text == "" then return nil end
            -- Include the task/counter labels too.  Some UI revisions put
            -- only a generic quest name in QuestTitle and the mob name in
            -- QuestTask, so matching the title alone can reject a valid quest.
            local parts = {titleText.Text}
            for _, d in ipairs(container:GetDescendants()) do
                if d:IsA("TextLabel") and d ~= titleText and d.Text and d.Text ~= "" then
                    parts[#parts + 1] = d.Text
                end
            end
            return table.concat(parts, " ")
        end
        -- Đọc text thực tế từ UI; không dùng tên object QuestModel.
        local parts = {}
        for _, d in ipairs(container:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text and d.Text ~= "" then
                parts[#parts + 1] = d.Text
            end
        end
        if #parts == 0 then return nil end
        return table.concat(parts, " ")
    end)
    if not ok then return nil end
    return text
end


-- [FIX-P2] Kiểm tra quest hiện tại có đúng mob q.M hay không.
-- Trả về: true = khớp, false = sai mob, nil = không đọc được UI.
local function QuestMatches(mobName)
    if not mobName then return nil end
    -- Once this session accepted (or adopted) an active quest, this canonical
    -- name is authoritative. It also makes level-boundary changes explicit:
    -- an old active quest returns false for the next QDB entry and is replaced.
    local activeMob = _G.State and _G.State.ActiveQuestMob
    if activeMob then
        return string.lower(tostring(activeMob))
            == string.lower(tostring(mobName))
    end
    local text = GetQuestText()
    if not text then return nil end
    if string.find(string.lower(text), string.lower(mobName), 1, true) then
        return true
    end
    -- Roblox can render the objective through a localization table (for
    -- example Brute -> a Vietnamese name). An untranslated miss is therefore
    -- unknown, not proof that the player holds the wrong quest.
    return nil
end


-- [FIX-P3] Request quest tại giver với retry có giới hạn, không spam remote.
-- Trả về true = "đã xử lý (đừng farm)", false = "chưa tới giver".
local function HandleQuestAtGiver(q, atGiver)
    if not atGiver then return false end
    local now = tick()
    if now - _G.State.LastQuestRequest < _G.Settings.QuestDelay then
        _G.BobonStatus = "Quest: Waiting for confirmation " .. q.M
        return true
    end
    if _G.State.QuestRetries >= _G.Settings.QuestRetryLimit then
        -- Quá số lần retry → backoff, không spam remote, không farm
        _G.BobonStatus = "Quest: Failed, waiting to retry"
        if now - _G.State.LastQuestRequest >= (_G.Settings.QuestRetryBackoff or 6) then
            _G.State.QuestRetries = 0
        end
        return true
    end
    _G.State.LastQuestRequest = now
    _G.State.QuestRetries = _G.State.QuestRetries + 1
    DLog("QUEST", "StartQuest " .. q.Q .. " level " .. q.QL)
    -- Dọn quest cũ sai mob trước khi request quest mới; nếu không server sẽ
    -- giữ quest cũ và controller tưởng rằng StartQuest bị lỗi.
    local currentMatch = QuestMatches(q.M)
    if currentMatch == false then
        _G.State.ActiveQuestMob = nil
        pcall(function() CommF_:InvokeServer("AbandonQuest") end)
        task.wait(0.15)
    end
    local function VerifyQuestTitle()
        local deadline = tick() + 3
        repeat
            -- Verify both the title and the wrapper.  A completed quest can
            -- leave stale title text behind for a few frames; that must not
            -- be mistaken for a newly accepted quest.
            -- Quest title/UI can be rearranged between game updates.  The
            -- wrapper being active is authoritative; only an explicit mob
            -- mismatch rejects the quest.  `nil` means unreadable, not wrong.
            if HasQuest() == true and QuestMatches(q.M) ~= false then return true end
            task.wait(0.2)
        until tick() >= deadline
        return false
    end
    -- Remote chuẩn của Blox Fruits là StartQuest. RequestQuest chỉ còn là
    -- fallback cho các server/private build cũ.
    local okRQ = pcall(function()
        CommF_:InvokeServer("StartQuest", q.Q, q.QL)
    end)
    task.wait(0.35)
    local accepted = VerifyQuestTitle()
    if not accepted then
        local okFallback = pcall(function()
            CommF_:InvokeServer("RequestQuest", q.Q, q.QL)
        end)
        okRQ = okRQ or okFallback
        accepted = VerifyQuestTitle()
    end
    if okRQ and accepted then
        _G.State.QuestRetries = 0
        _G.State.LastQuestAccepted = tick()
        _G.State.ActiveQuestMob = q.M
        _G.BobonStatus = "Quest: Accepted " .. q.M
        DLog("QUEST", "Accepted: " .. q.M)
    else
        warn("[BobonHub] RequestQuest error (retry " .. _G.State.QuestRetries .. ")")
        _G.BobonStatus = "Quest: Error, retrying " .. q.M
        DLog("QUEST", "Remote error (retry " .. _G.State.QuestRetries .. ")")
    end
    return true
end

-- Redeem the current XP-boost starter codes once per execution.  Codes are
-- intentionally isolated from the farm/action token: an expired/rotated code
-- must never pause quest farming, and the server itself decides validity.
local CodeManager = {
    Redeemed = {},
    Codes = {
        "EASTEREXP", "StrawHatMaine", "TantaiGaming", "Bluxxy",
        "SUB2GAMERROBOT_EXP1", "StarcodeHEO", "LIGHTNINGABUSE",
        "Sub2CaptainMaui", "Sub2Fer999", "Enyu_is_Pro", "MagicBUS",
        "JCWK", "Axiore", "KittGaming", "Sub2Daigrock",
        "Sub2NoobMaster123", "Sub2OfficialNoobie", "TheGreatAce",
        -- Utility/reset starter codes are harmless to try alongside XP codes.
        "fudd10", "fudd10_V2", "Chandler", "BIGNEWS", "KITT_RESET",
        "Sub2UncleKizaru", "SUB2GAMERROBOT_RESET1",
    },
}

function CodeManager:Redeem(code)
    if self.Redeemed[code] or not code then return false end
    local ok, result = false, nil
    local redeem = Remotes and Remotes:FindFirstChild("Redeem")
    if redeem and redeem:IsA("RemoteFunction") then
        ok, result = pcall(function() return redeem:InvokeServer(code) end)
    else
        -- Compatibility fallback used by older/private builds.
        ok, result = pcall(function() return CommF_:InvokeServer("Redeem", code) end)
    end
    self.Redeemed[code] = true
    DLog("CODE", code .. " -> " .. tostring(result))
    return ok
end

function CodeManager:RedeemAll()
    if not _G.Settings.AutoRedeemCodes then return end
    for _, code in ipairs(self.Codes) do
        self:Redeem(code)
        task.wait(_G.Settings.RedeemCodeDelay or 0.45)
    end
end

task.spawn(function()
    task.wait(2)
    pcall(function() CodeManager:RedeemAll() end)
end)


-- Resolve the live Net folder. Combat backends are capability-detected and
-- must pass a health-delta probe before they are treated as working.
local NetFolderCache = nil
local NetWaitAttempted = false

local function ResolveNet()
    if NetFolderCache and NetFolderCache.Parent then return NetFolderCache end
    -- Current clients keep combat remotes in ReplicatedStorage.Modules.Net.
    -- Prefer that exact path; a recursive search under Remotes can select an
    -- unrelated object also named Net and make every FireServer silently fail.
    local modules = RS:FindFirstChild("Modules")
    if not modules and not NetWaitAttempted then
        NetWaitAttempted = true
        modules = RS:WaitForChild("Modules", 5)
    end
    local exactNet = modules and modules:FindFirstChild("Net")
    if exactNet then
        NetFolderCache = exactNet
        return exactNet
    end
    local roots = {}
    roots[#roots + 1] = RS
    if Remotes then roots[#roots + 1] = Remotes end
    for _, root in ipairs(roots) do
        local net = root:FindFirstChild("Net", true)
        if net then
            NetFolderCache = net
            return net
        end
    end
    return nil
end

local WeaponController
local ClientOwnsMob
local ClusterFarmController
local VerifiedGatherRoots = setmetatable({}, { __mode = "k" })
local GatherGeneration = 0

local function ToolCombatKind(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    if tool:FindFirstChild("LeftClickRemote") then return "Gun" end
    local ok, tip = pcall(function() return tostring(tool.ToolTip or "") end)
    tip = ok and string.lower(tip) or ""
    if tip:find("melee", 1, true) then return "Melee" end
    if tip:find("sword", 1, true) or tip:find("blade", 1, true) then return "Sword" end
    if tip:find("gun", 1, true) or tip:find("rifle", 1, true)
        or tip:find("bow", 1, true) then
        return "Gun"
    end
    -- Combat is the only starter style whose tooltip can be temporarily
    -- blank while its controller initializes.
    if tool.Name == "Combat" then return "Melee" end
    -- Once the catalog controller below is initialized, it also covers named
    -- melee styles/swords whose ToolTip is temporarily blank.
    if WeaponController and type(WeaponController.IsCombatTool) == "function"
        and WeaponController:IsCombatTool(tool) then
        return tool:FindFirstChild("LeftClickRemote") and "Gun" or "CloseCombat"
    end
    return nil
end

local function IsCombatToken(value)
    return type(value) == "string" and #value == 8
        and value:match("^%x+$") ~= nil
end

local function IsClientInputBackend(name)
    return name == "CLIENT-MOUSE" or name == "CLIENT-VIM"
        or name == "CLIENT-TOOL"
end

-- v18.5 CONTEST FARM: a quest target is sticky while another player is
-- actively near/tagging it. This only affects the current level-quest mob;
-- bosses and unrelated NPCs are never treated as contested farm targets.
local LastContestScanAt = 0
local LastContestScanModel = nil
local LastContestScanResult = false
local function MarkFarmTargetContested(model, player)
    if not (_G.Settings and _G.Settings.ContestQuestMobs) then return false end
    if not model or not _G.State or _G.State.FarmTarget ~= model then return false end
    local wanted = _G.State.ActiveQuestMob
    if not wanted or not IsEnemyNamed(model, wanted) then return false end
    _G.State.LastTargetContested = tick()
    _G.State.ContestedTarget = model
    _G.State.ContestedBy = player and player.Name or _G.State.ContestedBy
    return true
end

local function IsFarmTargetContested(model)
    if not (_G.Settings and _G.Settings.ContestQuestMobs) then return false end
    if not model or not _G.State or _G.State.FarmTarget ~= model then return false end
    if not _G.State:IsTargetValid(model) then return false end
    local wanted = _G.State.ActiveQuestMob
    if not wanted or not IsEnemyNamed(model, wanted) then return false end
    local now = tick()
    if _G.State.ContestedTarget == model
        and now - (_G.State.LastTargetContested or 0) <= (_G.Settings.ContestGrace or 3) then
        return true
    end
    if LastContestScanModel == model and now - LastContestScanAt < 0.25 then
        return LastContestScanResult
    end
    LastContestScanAt = now
    LastContestScanModel = model
    LastContestScanResult = false
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local otherRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local ok, distance = pcall(function()
                    return (root.Position - otherRoot.Position).Magnitude
                end)
                if ok and distance <= (_G.Settings.ContestRadius or 65) then
                    MarkFarmTargetContested(model, player)
                    LastContestScanResult = true
                    return true
                end
            end
        end
    end
    return false
end

-- Some NPC controllers attach a creator/last-hit marker. When it explicitly
-- names another player, that HP change cannot prove this controller worked.
local function DamageAttributedToOtherPlayer(model, humanoid)
    for _, scope in ipairs({ humanoid, model }) do
        if scope then
            for _, markerName in ipairs({ "creator", "Creator", "LastHitBy", "lastHitBy" }) do
                local marker = scope:FindFirstChild(markerName)
                if marker and marker:IsA("ObjectValue") and marker.Value then
                    local value = marker.Value
                    local player = value:IsA("Player") and value or nil
                    if not player and value:IsA("Model") then
                        player = Players:GetPlayerFromCharacter(value)
                    end
                    if player == LP then return false end
                    if player then
                        -- Creator tags can remain after an older attacker has
                        -- left. Treat the tag as current only while that
                        -- character is still near enough to affect this NPC.
                        local targetRoot = model and model:FindFirstChild("HumanoidRootPart")
                        local otherRoot = player.Character
                            and player.Character:FindFirstChild("HumanoidRootPart")
                        local okPositions, distance = pcall(function()
                            return (targetRoot.Position - otherRoot.Position).Magnitude
                        end)
                        if okPositions and distance <= 60 then
                            MarkFarmTargetContested(model, player)
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

local CombatController = {
    RegisterAttack = nil,
    RegisterHit = nil,
    GameGlobal = nil,
    NativeHelper = nil,
    HelperScanDone = 0,
    SessionToken = nil,
    SessionTokenSource = nil,
    FailedUntil = {},
    BackendProofs = {},
    BackendLastProof = {},
    VerifiedMisses = {},
    VerifiedBackend = nil,
    FastVerified = false,
    FastVerifiedAt = 0,
    NextFastUpgrade = 0,
    PendingBackend = nil,
    PendingTarget = nil,
    PendingHumanoid = nil,
    PendingSince = 0,
    PendingLastDispatch = 0,
    PendingSettleUntil = 0,
    PendingAttempts = 0,
    NextProbeAt = 0,
    LastConfirmedAt = 0,
    DesiredClientRange = false,
    WatchedModel = nil,
    WatchedHumanoid = nil,
    WatchedHealth = nil,
    WatchedStableSince = 0,
    HealthConnection = nil,
}

function CombatController:ResolveRemotes()
    if self.RegisterAttack and self.RegisterAttack.Parent
        and self.RegisterHit and self.RegisterHit.Parent then
        return true
    end
    local net = ResolveNet()
    self.RegisterAttack = net and net:FindFirstChild("RE/RegisterAttack") or nil
    self.RegisterHit = net and net:FindFirstChild("RE/RegisterHit") or nil
    return self.RegisterAttack ~= nil and self.RegisterHit ~= nil
end

function CombatController:GetGameGlobal()
    if type(self.GameGlobal) == "table" then return self.GameGlobal end
    if type(getrenv) == "function" then
        local ok, env = pcall(getrenv)
        if ok and type(env) == "table" and type(rawget(env, "_G")) == "table" then
            self.GameGlobal = rawget(env, "_G")
            return self.GameGlobal
        end
    end
    return nil
end

function CombatController:ResolveNativeHelper()
    if type(self.NativeHelper) == "function" then return self.NativeHelper end
    local gameGlobal = self:GetGameGlobal()
    local direct = gameGlobal and rawget(gameGlobal, "SendHitsToServer")
    if type(direct) == "function" then
        self.NativeHelper = direct
        return direct
    end
    if type(getsenv) ~= "function" then return nil end
    if tick() - (self.HelperScanDone or 0) < 5 then return nil end
    self.HelperScanDone = tick()
    for _, scope in ipairs({ LP:FindFirstChild("PlayerScripts"), Char() }) do
        if scope then
            for _, scriptObject in ipairs(scope:GetDescendants()) do
                if scriptObject:IsA("LocalScript") then
                    local ok, env = pcall(getsenv, scriptObject)
                    if ok and type(env) == "table" then
                        local helper = rawget(env, "SendHitsToServer")
                        local scopedGlobal = rawget(env, "_G")
                        if type(helper) ~= "function" and type(scopedGlobal) == "table" then
                            helper = rawget(scopedGlobal, "SendHitsToServer")
                        end
                        if type(helper) == "function" then
                            self.NativeHelper = helper
                            return helper
                        end
                    end
                end
            end
        end
    end
    return nil
end

function CombatController:ResolveSessionToken()
    if IsCombatToken(self.SessionToken) then return self.SessionToken end
    local gameGlobal = self:GetGameGlobal()
    local helper = gameGlobal and rawget(gameGlobal, "SendHitsToServer")
    local getUps = type(getupvalues) == "function" and getupvalues
        or (type(debug) == "table" and type(debug.getupvalues) == "function"
            and debug.getupvalues or nil)
    if type(helper) ~= "function" or type(getUps) ~= "function" then return nil end
    local ok, upvalues = pcall(getUps, helper)
    if not ok or type(upvalues) ~= "table" or upvalues[1] == nil then return nil end
    -- Runtime-derived adapter observed in current public clients. It is never
    -- trusted merely because it has the right shape; health delta is the gate.
    local candidate = tostring(LP.UserId):sub(2, 4)
        .. tostring(upvalues[1]):sub(11, 15)
    if IsCombatToken(candidate) then
        self.SessionToken = candidate
        self.SessionTokenSource = "runtime"
        return candidate
    end
    return nil
end

function CombatController:LegacyAllowed()
    local gameGlobal = self:GetGameGlobal()
    return gameGlobal and rawget(gameGlobal, "COMBAT_REMOTE_THREAD") == false
end

local function SelectEnemyHitPart(enemy)
    if not enemy then return nil end
    for _, name in ipairs({
        "LeftHand", "RightHand", "RightLowerLeg", "LeftLowerLeg",
        "Head", "HumanoidRootPart",
    }) do
        local part = enemy:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
    return nil
end

function CombatController:CollectTargets(preferred, mobName, maxRange)
    local me = HRP()
    local folder = workspace:FindFirstChild("Enemies")
    if not me or not folder then return {} end
    local results, seen = {}, {}
    local activeQuestMob = _G.State and _G.State.ActiveQuestMob
    local questGatherActive = _G.State.Mode == "Farming"
        and activeQuestMob ~= nil
        and mobName ~= nil
        and string.lower(tostring(activeQuestMob))
            == string.lower(tostring(mobName))
    local clusterGatherActive = ClusterFarmController
        and ClusterFarmController:IsAttackCluster(mobName) == true
    local now = tick()
    local function add(enemy)
        if not enemy or seen[enemy] then return end
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        local part = SelectEnemyHitPart(enemy)
        local okPosition, rootPosition = pcall(function() return root.Position end)
        if hum and hum.Health > 0 and root and root.Parent and part and part.Parent
            and okPosition and IsValidPos(rootPosition)
            and (rootPosition - me.Position).Magnitude <= maxRange then
            seen[enemy] = true
            results[#results + 1] = { Model=enemy, Humanoid=hum, Root=root, Part=part }
        end
    end
    add(preferred)
    if mobName then
        for _, enemy in ipairs(folder:GetChildren()) do
            if #results >= (_G.Settings.FastAttackMaxTargets or 12) then break end
            if IsEnemyNamed(enemy, mobName) then
                local allowExtra = true
                if (questGatherActive or clusterGatherActive) and enemy ~= preferred then
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    local verifiedAt = root and VerifiedGatherRoots[root]
                    allowExtra = verifiedAt ~= nil
                        and now - verifiedAt
                            <= (_G.Settings.GatherVerifiedTTL or 0.9)
                        and type(ClientOwnsMob) == "function"
                        and ClientOwnsMob(root) == true
                end
                if allowExtra then add(enemy) end
            end
        end
    end
    return results
end

function CombatController:ConfirmDamage(backend, delta)
    if not backend or delta <= 0 or self.PendingBackend ~= backend
        or self.PendingHumanoid ~= self.WatchedHumanoid
        or self.PendingTarget ~= self.WatchedModel then
        return
    end
    self.FailedUntil[backend] = nil
    self.VerifiedMisses[backend] = 0
    local now = tick()
    local priorProof = self.BackendLastProof[backend]
    local independentProof = not priorProof
        or priorProof.Target ~= self.WatchedModel
        or now - priorProof.Time >= (_G.Settings.CombatRepeatProofGap or 0.9)
    if independentProof then
        self.BackendProofs[backend] = (self.BackendProofs[backend] or 0) + 1
        self.BackendLastProof[backend] = {
            Target = self.WatchedModel,
            Time = now,
        }
    end
    self.VerifiedBackend = backend
    local isFastBackend = backend == "CLIENT-HELPER"
        or backend == "TOKEN-4" or backend == "LEGACY-2"
    self.FastVerified = isFastBackend
        and self.BackendProofs[backend]
            >= (_G.Settings.CombatProofsRequired or 2)
    self.FastVerifiedAt = now
    self.LastConfirmedAt = self.FastVerifiedAt
    self.DesiredClientRange = IsClientInputBackend(backend)
    if IsClientInputBackend(backend) and self.NextFastUpgrade <= 0 then
        self.NextFastUpgrade = tick()
            + (_G.Settings.CombatFastUpgradeInterval or 90)
    end
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.NextProbeAt = 0
    local diag = _G.BobonDiagnostics
    diag.Packet = "CONFIRMED"
    diag.Net = backend
    diag.LastHPDelta = delta
    DLog("ATTACK", backend .. " confirmed, HP delta=" .. tostring(delta))
end

function CombatController:WatchTarget(model, humanoid)
    if self.WatchedHumanoid == humanoid then return end
    if self.HealthConnection then self.HealthConnection:Disconnect() end
    self.HealthConnection = nil
    self.WatchedModel = model
    self.WatchedHumanoid = humanoid
    self.WatchedHealth = humanoid and humanoid.Health or nil
    self.WatchedStableSince = tick()
    self.DesiredClientRange = IsClientInputBackend(self.VerifiedBackend)
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.LastConfirmedAt = 0
    self.NextProbeAt = 0
    _G.BobonDiagnostics.LastHPDelta = 0
    _G.BobonDiagnostics.Targets = 0
    if not humanoid then return end
    self.HealthConnection = humanoid.HealthChanged:Connect(function(newHealth)
        if not SessionAlive() or self.WatchedHumanoid ~= humanoid then return end
        local oldHealth = self.WatchedHealth
        self.WatchedHealth = newHealth
        local now = tick()
        local withinProbe = self.PendingBackend ~= nil
            and self.PendingTarget == model
            and self.PendingHumanoid == humanoid
            and self.PendingAttempts > 0
            and now - self.PendingLastDispatch
                <= (_G.Settings.CombatCausalWindow or 0.65)
        -- A creator marker can update one frame behind a genuine local M1.
        -- For a real client-input click, the short causal window is stronger
        -- evidence than that stale marker; remote/helper probes stay strict.
        local attributedElsewhere = DamageAttributedToOtherPlayer(model, humanoid)
        if oldHealth and newHealth < oldHealth and attributedElsewhere then
            MarkFarmTargetContested(model, nil)
        end
        local clientCausalProof = IsClientInputBackend(self.PendingBackend)
        if oldHealth and newHealth < oldHealth and withinProbe
            and (clientCausalProof or not attributedElsewhere) then
            self:ConfirmDamage(self.PendingBackend, oldHealth - newHealth)
        end
        if oldHealth and newHealth ~= oldHealth then
            self.WatchedStableSince = now
        end
    end)
end

function CombatController:FailBackend(backend, reason)
    if not backend then return end
    self.FailedUntil[backend] = tick() + (_G.Settings.CombatBackendRetry or 12)
    if backend == "TOKEN-4" then self.SessionToken = nil end
    if backend == "CLIENT-HELPER" then
        self.NativeHelper = nil
        self.HelperScanDone = 0
    end
    if not IsClientInputBackend(backend) and backend ~= "GUN-REMOTE" then
        self.NextFastUpgrade = tick()
            + (_G.Settings.CombatFastUpgradeInterval or 90)
    end
    if self.VerifiedBackend == backend then
        self.VerifiedBackend = nil
        self.FastVerified = false
        self.DesiredClientRange = false
    end
    self.BackendProofs[backend] = nil
    self.BackendLastProof[backend] = nil
    self.VerifiedMisses[backend] = nil
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.NextProbeAt = tick() + 0.25
    _G.BobonDiagnostics.Packet = "FAILED:" .. tostring(reason or backend)
    DLog("ATTACK", backend .. " failed health probe: " .. tostring(reason))
end

-- Range, stun and equip transitions are not evidence that a backend is bad.
-- Cancel that probe without blacklisting it, then retry after the transient
-- physical condition has cleared.
function CombatController:AbortPending(reason)
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.NextProbeAt = tick() + 0.1
    _G.BobonDiagnostics.Packet = tostring(reason or "WAIT-PHYSICAL")
end

function CombatController:CheckPending(now)
    if not self.PendingBackend then return end
    local maxAttempts = _G.Settings.CombatProbeAttempts or 3
    local timeout = _G.Settings.CombatProbeTimeout or 1.2
    if self.PendingAttempts >= maxAttempts
        and now - self.PendingLastDispatch >= timeout then
        -- Incoming NPC/PvP damage can interrupt the visible animation or
        -- delay a server hit. Keep farming and retry without blacklisting a
        -- previously viable backend merely because the player was hit.
        if _G.Settings.IgnoreIncomingDamage
            and now - (_G.State.LastIncomingDamage or 0)
                <= (_G.Settings.IncomingDamageGrace or 2) then
            -- v18.1: do NOT abort/restart the attack probe when the player is hit.
            -- Preserve backend, target and action; keep dispatching against the
            -- same mob while the server resolves knockback/stun/damage effects.
            _G.BobonDiagnostics.Packet = "CONTINUE-INCOMING-DAMAGE"
            self.PendingSettleUntil = math.max(self.PendingSettleUntil or 0,
                now + (_G.Settings.CombatLateGrace or 0.35))
        end
        if self.PendingSettleUntil <= 0 then
            self.PendingSettleUntil = now + (_G.Settings.CombatLateGrace or 0.35)
            _G.BobonDiagnostics.Packet = "WAIT-LATE-DAMAGE"
        elseif now >= self.PendingSettleUntil then
            -- If another player is contesting the same quest mob, never use that
            -- mixed HP stream as a reason to abandon the target. A verified
            -- backend is retried immediately; an unverified backend is rotated
            -- quickly so the real client-input fallback can still secure damage.
            if IsFarmTargetContested(self.PendingTarget) then
                local contestBackend = self.PendingBackend
                local contestProven = self.VerifiedBackend == contestBackend
                    and (self.BackendProofs[contestBackend] or 0)
                        >= (_G.Settings.CombatProofsRequired or 2)
                if not contestProven and contestBackend then
                    self.FailedUntil[contestBackend] = now + 0.45
                end
                self:AbortPending(contestProven
                    and ("CONTEST-RETRY:" .. tostring(contestBackend))
                    or ("CONTEST-ROTATE:" .. tostring(contestBackend)))
                return
            end
            -- Continuous PvP/NPC interference is not evidence that the backend
            -- failed. Extend the probe window without changing target/job.
            if HasRecentExternalInterference() then
                self.PendingSettleUntil = now + (_G.Settings.CombatLateGrace or 0.35)
                _G.BobonDiagnostics.Packet = "CONTINUE-INTERFERENCE"
                return
            end
            local backend = self.PendingBackend
            local proven = self.VerifiedBackend == backend
                and (self.BackendProofs[backend] or 0)
                    >= (_G.Settings.CombatProofsRequired or 2)
            if proven then
                self.VerifiedMisses[backend] = (self.VerifiedMisses[backend] or 0) + 1
                if self.VerifiedMisses[backend]
                    < (_G.Settings.CombatVerifiedMissLimit or 8) then
                    self:AbortPending("RETRY-VERIFIED:" .. backend)
                    self.NextProbeAt = now + (_G.Settings.CombatVerifiedRetry or 0.25)
                    return
                end
            end
            self:FailBackend(backend, "NO-HP-DELTA")
        end
    end
end

function CombatController:BackendAvailable(name)
    if (self.FailedUntil[name] or 0) > tick() then return false end
    if name == "CLIENT-HELPER" then
        return self:ResolveRemotes() and type(self:ResolveNativeHelper()) == "function"
    elseif name == "TOKEN-4" then
        return self:ResolveRemotes() and IsCombatToken(self:ResolveSessionToken())
    elseif name == "LEGACY-2" then
        return self:ResolveRemotes() and self:LegacyAllowed()
    elseif name == "CLIENT-MOUSE" then
        return type(mouse1click) == "function"
    elseif name == "CLIENT-VIM" or name == "CLIENT-TOOL" then
        return true
    end
    return false
end

function CombatController:SelectBackend(now)
    if self.PendingBackend then
        if self.PendingAttempts >= (_G.Settings.CombatProbeAttempts or 3) then
            return nil
        end
        return self.PendingBackend
    end
    if now < self.NextProbeAt then return nil end
    if self.VerifiedBackend and self:BackendAvailable(self.VerifiedBackend) then
        if not IsClientInputBackend(self.VerifiedBackend) or now < self.NextFastUpgrade then
            return self.VerifiedBackend
        end
    end
    for _, name in ipairs({
        "CLIENT-HELPER", "TOKEN-4", "LEGACY-2",
        "CLIENT-MOUSE", "CLIENT-VIM", "CLIENT-TOOL",
    }) do
        if self:BackendAvailable(name) then return name end
    end
    return nil
end

function CombatController:IsFastReady()
    local ttl = _G.Settings.CombatVerificationTTL or 120
    return self.FastVerified and self.VerifiedBackend ~= nil
        and tick() - (self.FastVerifiedAt or 0) <= ttl
        and (self.FailedUntil[self.VerifiedBackend] or 0) <= tick()
end

function CombatController:IsDamageReady()
    local ttl = _G.Settings.CombatVerificationTTL or 120
    return self.VerifiedBackend ~= nil
        and (self.BackendProofs[self.VerifiedBackend] or 0)
            >= (_G.Settings.CombatProofsRequired or 2)
        and tick() - (self.FastVerifiedAt or 0) <= ttl
        and (self.FailedUntil[self.VerifiedBackend] or 0) <= tick()
end

function CombatController:WantsClientRange()
    return self.DesiredClientRange == true
end

function CombatController:DispatchClientClick(tool, targetRoot, backend)
    local camera = workspace.CurrentCamera
    local okTarget, targetPosition = pcall(function() return targetRoot.Position end)
    if not okTarget or not IsValidPos(targetPosition) then return false end
    if camera then
        pcall(function()
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPosition)
        end)
    end
    if backend == "CLIENT-MOUSE" and type(mouse1click) == "function" then
        return pcall(mouse1click)
    end
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local clickPos = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
    if backend == "CLIENT-VIM" then
        local ok = pcall(function()
            VIM:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, true, game, 0)
        end)
        if not ok then return false end
        task.delay(0.04, function()
            if not SessionAlive() then return end
            pcall(function()
                VIM:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, false, game, 0)
            end)
        end)
        return true
    end
    if backend == "CLIENT-TOOL" then
        local ok = pcall(function() tool:Activate() end)
        if ok then
            task.delay(0.05, function()
                if SessionAlive() and tool and tool.Parent then
                    pcall(function() tool:Deactivate() end)
                end
            end)
        end
        return ok
    end
    return false
end

function CombatController:Dispatch(backend, tool, entries, preferredRoot)
    if #entries == 0 then return false end
    if IsClientInputBackend(backend) then
        return self:DispatchClientClick(tool, preferredRoot, backend)
    elseif backend == "CLIENT-HELPER" then
        local helper = self:ResolveNativeHelper()
        local hitList = {}
        for _, entry in ipairs(entries) do
            hitList[#hitList + 1] = { entry.Model, entry.Part }
        end
        pcall(function() self.RegisterAttack:FireServer(0) end)
        local hitOk = pcall(function() helper(entries[1].Part, hitList) end)
        return hitOk
    elseif backend == "TOKEN-4" then
        local token = self:ResolveSessionToken()
        local hitOk = false
        for _, entry in ipairs(entries) do
            pcall(function() self.RegisterAttack:FireServer(0.5) end)
            local ok = pcall(function()
                self.RegisterHit:FireServer(entry.Part, {}, nil, token)
            end)
            hitOk = hitOk or ok
        end
        return hitOk
    elseif backend == "LEGACY-2" then
        local hitList = {}
        for _, entry in ipairs(entries) do
            hitList[#hitList + 1] = { entry.Model, entry.Part }
        end
        pcall(function() self.RegisterAttack:FireServer(0) end)
        local hitOk = pcall(function()
            self.RegisterHit:FireServer(entries[1].Part, hitList)
        end)
        return hitOk
    elseif backend == "GUN-REMOTE" then
        local remote = tool:FindFirstChild("LeftClickRemote")
        local playerRoot = HRP()
        if not remote or not playerRoot then return false end
        local playerPosition = playerRoot.Position
        local sent = false
        for _, entry in ipairs(entries) do
            local okRoot, enemyPosition = pcall(function() return entry.Root.Position end)
            local direction = okRoot and (enemyPosition - playerPosition) or nil
            if direction and direction.Magnitude > 0.01 then
                local ok = pcall(function() remote:FireServer(direction.Unit, 1) end)
                sent = sent or ok
            end
        end
        return sent
    end
    return false
end

function CombatController:Attack(tool, kind, preferredModel, preferredHum, preferredRoot, mobName)
    local now = tick()
    self:WatchTarget(preferredModel, preferredHum)

    -- Choose the desired physical range before dispatching. Fast/helper
    -- probes stay at safe hover; only an actual client-input backend asks the
    -- travel controller to descend into real melee/sword range.
    local candidateBackend = kind == "Gun" and "GUN-REMOTE"
        or self.PendingBackend or self:SelectBackend(now)
    self.DesiredClientRange = IsClientInputBackend(candidateBackend)
        or (not candidateBackend and IsClientInputBackend(self.VerifiedBackend))
    if not candidateBackend then
        _G.BobonDiagnostics.Packet = "WAIT-BACKEND"
        return false
    end
    local candidateInputBackend = IsClientInputBackend(candidateBackend)
    local candidateRange = candidateInputBackend
        and (_G.Settings.ClientAttackRange or 8)
        or (_G.Settings.FastAttackRange or 100)
    local me = HRP()
    local okPreferred, preferredPosition = pcall(function()
        return preferredRoot.Parent and preferredRoot.Position or nil
    end)
    if not me or not okPreferred or not IsValidPos(preferredPosition)
        or (preferredPosition - me.Position).Magnitude > candidateRange then
        if self.PendingBackend then self:AbortPending("APPROACHING") end
        _G.BobonDiagnostics.Packet = "APPROACHING"
        return false
    end
    if tool.Parent ~= Char() then
        self:AbortPending("WAIT-TOOL-READY")
        return false
    end
    if tool.Enabled == false and candidateInputBackend then
        -- Normal M1 cooldown often disables the Tool before its server damage
        -- arrives. Keep the pending causal probe alive so that delayed HP loss
        -- can confirm the click instead of making combat reset after one hit.
        _G.BobonDiagnostics.Packet = "WAIT-TOOL-COOLDOWN"
        return false
    end
    if WeaponController and type(WeaponController.IsReady) == "function"
        and not WeaponController:IsReady(tool, not candidateInputBackend) then
        self:AbortPending("WAIT-EQUIP-SETTLE")
        return false
    end
    -- Default kaitun policy ignores combat-control flags caused by incoming
    -- attacks. We do not mutate those game values; fast/helper dispatch and
    -- movement simply keep their current target while the server resolves it.
    if not _G.Settings.IgnoreIncomingDamage then
        local character = Char()
        for _, flagName in ipairs({ "Stun", "Busy" }) do
            local flag = character and character:FindFirstChild(flagName)
            if flag and ((flag:IsA("BoolValue") and flag.Value)
                or (flag:IsA("NumberValue") and flag.Value > 0)) then
                self:AbortPending("WAIT-" .. string.upper(flagName))
                return false
            end
            local attribute = character and character:GetAttribute(flagName)
            if attribute == true or (type(attribute) == "number" and attribute > 0) then
                self:AbortPending("WAIT-" .. string.upper(flagName))
                return false
            end
        end
    end

    -- Validate the streamed hit part before allowing an old pending probe to
    -- time out. A despawned limb/root is a target transition, not evidence
    -- that the combat backend failed.
    local candidateEntries = self:CollectTargets(preferredModel,
        candidateInputBackend and nil or mobName, candidateRange)
    if #candidateEntries == 0 then
        self:AbortPending("NO-TARGETS")
        return false
    end

    -- Before the first proof (or after TTL expiry), require a short quiet HP
    -- baseline. This makes ambient/DOT damage less likely to validate a bad
    -- backend. Existing in-flight probes are allowed to finish normally.
    if not self.PendingBackend and not self:IsDamageReady()
        and now - (self.WatchedStableSince or now)
            < (_G.Settings.CombatBaselineQuiet or 0.25) then
        _G.BobonDiagnostics.Packet = "WAIT-STABLE-HP"
        return false
    end

    -- Only expire a health probe while its target, tool and character are in
    -- a valid attacking state. Physical interruptions above abort, not fail.
    self:CheckPending(now)
    local backend = kind == "Gun" and "GUN-REMOTE" or self:SelectBackend(now)
    if not backend then
        self.DesiredClientRange = IsClientInputBackend(self.PendingBackend)
            or IsClientInputBackend(self.VerifiedBackend)
        _G.BobonDiagnostics.Packet = "WAIT-HP"
        return false
    end
    local inputBackend = IsClientInputBackend(backend)
    self.DesiredClientRange = inputBackend
    -- SelectBackend can change after CheckPending. Revalidate only the
    -- physical client-input path; verified remote/helper attacks do not need
    -- Tool.Enabled to remain true during an incoming hit animation.
    if backend ~= candidateBackend then
        if tool.Enabled == false and inputBackend then
            _G.BobonDiagnostics.Packet = "WAIT-TOOL-COOLDOWN"
            return false
        end
        if WeaponController and type(WeaponController.IsReady) == "function"
            and not WeaponController:IsReady(tool, not inputBackend) then
            self:AbortPending("WAIT-EQUIP-SETTLE")
            return false
        end
    end
    local range = inputBackend
        and (_G.Settings.ClientAttackRange or 8)
        or (_G.Settings.FastAttackRange or 100)
    if (preferredPosition - me.Position).Magnitude > range then
        if self.PendingBackend then self:AbortPending("APPROACHING") end
        _G.BobonDiagnostics.Packet = "APPROACHING"
        return false
    end
    local entries = backend == candidateBackend and candidateEntries
        or self:CollectTargets(preferredModel,
            inputBackend and nil or mobName, range)
    if #entries == 0 then
        self:AbortPending("NO-TARGETS")
        return false
    end
    local effectiveAttackDelay = _G.Settings.AttackDelay or 0.08
    if IsFarmTargetContested(preferredModel) then
        effectiveAttackDelay = math.min(effectiveAttackDelay,
            _G.Settings.ContestAttackDelay or 0.045)
        _G.BobonDiagnostics.Packet = "CONTEST-ATTACK"
    end
    if now - _G.State.LastAttackTime < effectiveAttackDelay then
        return false
    end
    _G.State.LastAttackTime = now
    if self.PendingBackend ~= backend then
        self.PendingBackend = backend
        self.PendingTarget = preferredModel
        self.PendingHumanoid = preferredHum
        self.PendingSince = now
        self.PendingLastDispatch = 0
        self.PendingSettleUntil = 0
        self.PendingAttempts = 0
    end
    -- Probe only the watched primary. Once that backend has produced real HP
    -- deltas, helper/remote backends may fan out to the matching cluster.
    local dispatchEntries = entries
    if self.VerifiedBackend ~= backend or not self:IsFastReady() then
        dispatchEntries = { entries[1] }
    end
    local attempted = self:Dispatch(backend, tool, dispatchEntries, preferredRoot)
    local diag = _G.BobonDiagnostics
    diag.Net = backend
    diag.Targets = #entries
    if attempted then
        self.PendingAttempts = self.PendingAttempts + 1
        self.PendingLastDispatch = now
        self.PendingSettleUntil = 0
        diag.Packet = "ATTEMPT:" .. backend
    else
        self:FailBackend(backend, "DISPATCH-ERROR")
        diag.Packet = "ERROR:" .. backend
    end
    return attempted
end

function CombatController:Cleanup()
    if self.HealthConnection then self.HealthConnection:Disconnect() end
    self.HealthConnection = nil
    self.WatchedHumanoid = nil
    self.WatchedModel = nil
    self.WatchedHealth = nil
    self.NativeHelper = nil
    self.HelperScanDone = 0
    self.SessionToken = nil
    self.SessionTokenSource = nil
    self.GameGlobal = nil
    self.VerifiedBackend = nil
    self.FastVerified = false
    self.FastVerifiedAt = 0
    self.LastConfirmedAt = 0
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.NextProbeAt = 0
    self.FailedUntil = {}
    self.BackendProofs = {}
    self.BackendLastProof = {}
    self.VerifiedMisses = {}
    self.NextFastUpgrade = 0
    self.DesiredClientRange = false
    self.WatchedStableSince = 0
end

local function Attack(preferredTarget, mobName)
    if not IsAlive() then return false end
    local c = Char()
    local tool = c and c:FindFirstChildOfClass("Tool")
    local kind = ToolCombatKind(tool)
    if not tool or not kind then
        _G.BobonDiagnostics.Tool = tool and ("INVALID:" .. tool.Name) or "NO-TOOL"
        _G.BobonDiagnostics.Packet = "BLOCKED-TOOL"
        return false
    end
    local targetRoot = preferredTarget and preferredTarget:IsA("BasePart")
        and preferredTarget
        or (preferredTarget and preferredTarget:FindFirstChild("HumanoidRootPart"))
    local targetModel = targetRoot and targetRoot:FindFirstAncestorOfClass("Model")
    local targetHum = targetModel and targetModel:FindFirstChildOfClass("Humanoid")
    if not targetRoot or not targetRoot.Parent or not targetHum or targetHum.Health <= 0 then
        _G.BobonDiagnostics.Packet = "INVALID-TARGET"
        return false
    end
    _G.BobonDiagnostics.Tool = tool.Name
    return CombatController:Attack(tool, kind, targetModel, targetHum, targetRoot, mobName)
end

local function PrepareCombatTarget(target)
    if not target then return false end
    local root = target:IsA("BasePart") and target or target:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart") or not root.Parent then return false end
    local ok, pos = pcall(function() return root.Position end)
    return ok and IsAllowedWorldPosition(pos)
end


local MeleeList = {
    "Godhuman","Superhuman","Death Step","Electric Claw",
    "Dragon Talon","Sharkman Karate","Dragon Claw",
    "Fishman Karate","Water Kung Fu","Dark Step","Black Leg",
    "Electric","Electro","Combat","Dragon Breath","Sanguine Art"
}


-- [A-2] EQUIPMENT CONTROLLER — melee equip có cooldown + verify
-- [FIX-P5] EquipMelee() trả về true nếu đã có melee trên tay
local EquipmentController = {}
EquipmentController.LastEquip = 0
EquipmentController.LastResult = "none"
EquipmentController.PendingName = nil

local function ToolCategoryText(tool)
    if not tool or not tool:IsA("Tool") then return "" end
    local values = {}
    local okTip, tip = pcall(function() return tool.ToolTip end)
    if okTip and type(tip) == "string" then values[#values + 1] = tip end
    for _, attributeName in ipairs({ "ToolType", "Type", "Category", "WeaponType" }) do
        local okAttribute, value = pcall(function()
            return tool:GetAttribute(attributeName)
        end)
        if okAttribute and type(value) == "string" then
            values[#values + 1] = value
        end
        local valueObject = tool:FindFirstChild(attributeName)
        if valueObject and valueObject:IsA("StringValue") then
            values[#values + 1] = valueObject.Value
        end
    end
    return string.lower(table.concat(values, " "))
end

local function IsMeleeTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    for _, name in ipairs(MeleeList) do
        if tool.Name == name then return true end
    end
    local category = ToolCategoryText(tool)
    return string.find(category, "melee", 1, true) ~= nil
        or string.find(category, "fighting style", 1, true) ~= nil
end


function EquipmentController:EquipMelee()
    local c = Char()
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if not c or not hum then
        self.LastResult = "noChar"
        return false
    end

    -- Verify pending equip trước khi thử equip lần tiếp theo.
    for _, tool in ipairs(c:GetChildren()) do
        if IsMeleeTool(tool) then
            self.PendingName = tool.Name
            self.LastResult = "holding"
            return true
        end
    end

    -- Cooldown chỉ chặn lệnh EquipTool mới; không chặn việc verify tool.
    local now = tick()
    if now - self.LastEquip < _G.Settings.EquipCooldown then
        self.LastResult = "cooldown"
        return false
    end
    self.LastEquip = now

    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not backpack then
        self.LastResult = "noBackpack"
        return false
    end
    for _, tool in ipairs(backpack:GetChildren()) do
        if IsMeleeTool(tool) then
            self.PendingName = tool.Name
            local ok = pcall(function() hum:EquipTool(tool) end)
            self.LastResult = ok and "equipping" or "equipError"
            DLog("EQUIP", "Equip request: " .. tool.Name)
            return false
        end
    end
    self.LastResult = "noMelee"
    DLog("EQUIP", "No melee in backpack")
    return false
end


function EquipmentController:GetLastResult()
    return self.LastResult
end


-- Wrapper giữ nguyên API cũ cho ItemProgression (Saber/Sea2/Sea3)
local function EquipMelee()
    return EquipmentController:EquipMelee()
end

-- Weapon fallback: Kaitun luôn ưu tiên melee, sau đó sword rồi gun.
-- Một số style trong Backpack không có ToolTip ổn định, vì vậy dùng cả
-- danh sách tên và nhóm ToolType/ToolTip để nhận diện mà không phụ thuộc UI.
local SwordList = {
    "Cutlass","Katana","Dual Katana","Triple Katana","Iron Mace",
    "Pipe","Dual-Headed Blade","Shark Saw","Soul Cane","Bisento",
    "Saber","Pole (1st Form)","Pole (2nd Form)","Jitte","Longsword",
    "Dragon Trident","Gravity Cane","Gravity Blade","Koko","Dark Blade",
    "True Triple Katana","Saishi","Shizu","Oroshi","Saddi","Shisui","Wando",
    "Flail",
    "Rengoku","Midnight Blade","Yama","Tushita","Buddy Sword",
    "Canvander","Twin Hooks","Spikey Trident","Cursed Dual Katana",
    "Dark Dagger","Hallow Scythe","Shark Anchor","Fox Lamp","Dragonheart",
}
local GunList = {
    "Slingshot","Musket","Flintlock","Refined Flintlock","Cannon",
    "Kabucha","Venom Bow","Acidum Rifle","Bizarre Rifle","Soul Guitar",
}

local function ToolNameIn(list, tool)
    if not tool or not tool:IsA("Tool") then return false end
    for _, name in ipairs(list) do
        if tool.Name == name then return true end
    end
    return false
end

local function IsSwordTool(tool)
    if ToolNameIn(SwordList, tool) then return true end
    local category = ToolCategoryText(tool)
    return string.find(category, "sword", 1, true) ~= nil
        or string.find(category, "blade", 1, true) ~= nil
end

local function IsGunTool(tool)
    if ToolNameIn(GunList, tool) then return true end
    local category = ToolCategoryText(tool)
    return string.find(category, "gun", 1, true) ~= nil
        or string.find(category, "rifle", 1, true) ~= nil
        or string.find(category, "bow", 1, true) ~= nil
end

local function MasteryConfiguredNames()
    local out, seen = {}, {}
    for _, list in ipairs({_G.Settings.FarmMasteryWeapons, _G.Settings.FarmMasterySwords, _G.Settings.FarmMasteryGuns}) do
        if type(list) == "table" then
            for _, name in pairs(list) do
                if type(name) == "string" and name ~= "" and not seen[name] then
                    seen[name] = true
                    out[#out + 1] = name
                end
            end
        end
    end
    return out
end

local function MasteryPreferredTool()
    if not _G.Settings.FarmMasteryEnabled then return nil end
    local target = _G.State and _G.State.FarmTarget
    local hum = target and target:FindFirstChildOfClass("Humanoid")
    if not hum or hum.MaxHealth <= 0 then return nil end
    local hpPct = (hum.Health / hum.MaxHealth) * 100
    if hpPct > (_G.Settings.MasteryHealthPercent or 40) then return nil end
    local targetMastery = _G.Settings.MasteryTarget or 600
    for _, name in ipairs(MasteryConfiguredNames()) do
        if FindOwnedTool(name) and EffectiveMastery(name) < targetMastery then return name end
    end
    return nil
end

WeaponController = {
    LastEquip = 0,
    LastResult = "none",
    HeldTool = nil,
    ReadyAt = 0,
}

function WeaponController:IsCombatTool(tool)
    return IsMeleeTool(tool) or IsSwordTool(tool) or IsGunTool(tool)
end

function WeaponController:IsReady(tool, ignoreEnabled)
    return tool ~= nil and tool.Parent == Char()
        and (ignoreEnabled or tool.Enabled ~= false)
        and self.HeldTool == tool and tick() >= (self.ReadyAt or 0)
end

function WeaponController:EquipPreferred()
    local c = Char()
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if not c or not hum then
        self.HeldTool = nil
        self.ReadyAt = 0
        self.LastResult = "noChar"
        return false
    end
    local now = tick()
    local preferredName = MasteryPreferredTool() or (_G.State and _G.State.PreferredCombatTool)
    local held = c:FindFirstChildOfClass("Tool")
    -- Mastery/style progression may request one exact tool. Switch Melee=true
    -- otherwise rejects a held sword/gun so the fallback really equips melee.
    if held and preferredName and held.Name ~= preferredName then
        pcall(function() hum:UnequipTools() end)
        held = nil
    elseif held and not preferredName and _G.Settings.SwitchMelee ~= false and not IsMeleeTool(held) then
        pcall(function() hum:UnequipTools() end)
        held = nil
    end
    if held and self:IsCombatTool(held) then
        if self.HeldTool ~= held then
            self.HeldTool = held
            self.ReadyAt = now + (_G.Settings.EquipSettle or 0.35)
        end
        self.LastResult = "holding:" .. held.Name
        _G.BobonDiagnostics.Tool = held.Name
        return self:IsReady(held)
    end
    self.HeldTool = nil
    self.ReadyAt = 0
    if now - self.LastEquip < 0.35 then
        self.LastResult = "cooldown"
        return false
    end
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not backpack then self.LastResult = "noBackpack"; return false end
    local candidate
    if preferredName then
        local preferred = backpack:FindFirstChild(preferredName)
        if preferred and self:IsCombatTool(preferred) then candidate = preferred end
    end
    -- Switch Melee=true keeps the normal kaitun fallback on melee.
    -- false keeps a valid held/preferred tool and otherwise favors sword/gun.
    local order = _G.Settings.SwitchMelee ~= false
        and {IsMeleeTool, IsSwordTool, IsGunTool}
        or {IsSwordTool, IsGunTool, IsMeleeTool}
    if not candidate then
        for _, predicate in ipairs(order) do
            for _, tool in ipairs(backpack:GetChildren()) do
                if predicate(tool) then candidate = tool; break end
            end
            if candidate then break end
        end
    end
    if not candidate then
        self.LastResult = "noCombatTool"
        _G.BobonDiagnostics.Tool = "NO-TOOL"
        return false
    end
    self.LastEquip = now
    local ok = pcall(function() hum:EquipTool(candidate) end)
    local equipped = ok and candidate.Parent == c
    if equipped then
        self.HeldTool = candidate
        self.ReadyAt = now + (_G.Settings.EquipSettle or 0.35)
    end
    self.LastResult = equipped and "settling:" .. candidate.Name
        or (ok and "equipping:" .. candidate.Name or "equipError")
    _G.BobonDiagnostics.Tool = equipped and candidate.Name or self.LastResult
    return false
end

local function EquipCombatTool()
    return WeaponController:EquipPreferred()
end


local function FindMob(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    local best,bd = nil,math.huge
    local hrp = HRP()
    for _,v in ipairs(folder:GetChildren()) do
        if IsEnemyNamed(v, name) and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0
            and v:FindFirstChild("HumanoidRootPart") then
            if hrp then
                local d=(v.HumanoidRootPart.Position-hrp.Position).Magnitude
                if d<bd then best,bd=v,d end
            else return v end
        end
    end
    return best
end


local function FindBoss(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    for _,v in ipairs(folder:GetChildren()) do
        if IsEnemyNamed(v, name) and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0
            and v:FindFirstChild("HumanoidRootPart") then return v end
    end
    return nil
end


local function FindNearestMob(mobName)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil, math.huge end
    local best,bd = nil,math.huge
    local hrp = HRP()
    if not hrp then return nil, math.huge end
    for _,v in ipairs(folder:GetChildren()) do
        if IsEnemyNamed(v, mobName) and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0
            and v:FindFirstChild("HumanoidRootPart") then
            local root = v.HumanoidRootPart
            local ok, pos = pcall(function() return root.Position end)
            if not ok then continue end
            -- [FIX-7] Bo qua mob o duoi bien / vi tri bat thuong
            if not IsAllowedWorldPosition(pos) then continue end
            local d = (pos - hrp.Position).Magnitude
            if d < bd then best,bd=v,d end
        end
    end
    return best, bd
end


-- Farm position với offset tương đối mob + clamp an toàn [FIX-8]
local function GetFarmPosition(mobPos)
    if not mobPos then return nil end
    if typeof(mobPos) == "Instance" then
        local ok, p = pcall(function()
            if mobPos:IsA("BasePart") then
                return mobPos.Position
            end
            return mobPos:GetPivot().Position
        end)
        if not ok then return nil end
        mobPos = p
    end
    if not IsValidPos(mobPos) then return nil end
    return Vector3.new(
        mobPos.X + _G.Settings.FarmOffsetX,
        math.max(mobPos.Y + _G.Settings.FarmHeight,
            IsSubmergedPosition(mobPos) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY),
        mobPos.Z
    )
end


-- ══════════════════════════════════════════════════════════════════
--   [A-1] TEAM CONTROLLER — AutoSelectTeam()
--   CHECK TEAM → TEAM NIL? → SELECT TEAM → WAIT → VERIFY TEAM
--   Check Player.Team, chưa có → chọn Pirates, verify lại sau 3s,
--   retry giới hạn (MaxRetries), cooldown TeamCooldown(5s) giữa các
--   lần gửi → KHÔNG spam remote. Chạy được ở mọi Sea.
-- ══════════════════════════════════════════════════════════════════
local TeamController = {}
TeamController.LastCheck = 0
TeamController.Retries = 0
TeamController.MaxRetries = 6
TeamController.RetryWindow = 30

local function ClickTeamChoice()
    local gui = LP:FindFirstChild("PlayerGui")
    if not gui then return false end
    local choose = gui:FindFirstChild("ChooseTeam", true)
    -- UIController của bản game mới xử lý chọn team qua closure thay vì
    -- GuiButton.Activate. Dùng API executor nếu có, nhưng luôn bọc pcall để
    -- bản chạy không có getgc vẫn tiếp tục bằng remote/button fallback.
    local controller = gui:FindFirstChild("UIController", true)
    if choose and choose.Visible and controller
        and type(getgc) == "function"
        and type(getconstants) == "function" and type(getfenv) == "function" then
        local ok = pcall(function()
            for _, fn in ipairs(getgc(true)) do
                if type(fn) == "function" and getfenv(fn).script == controller then
                    local constants = getconstants(fn)
                    if type(constants) == "table" and #constants == 1
                        and constants[1] == (_G.Settings.Team or "Pirates") then
                        fn(_G.Settings.Team or "Pirates")
                        return
                    end
                end
            end
        end)
        if ok and LP.Team then return true end
    end
    local desired = _G.Settings.Team or "Pirates"
    local teamNode = choose and choose:FindFirstChild(desired, true)
    local button = teamNode and (teamNode:IsA("GuiButton") and teamNode
        or teamNode:FindFirstChildWhichIsA("GuiButton", true))
    -- Một số bản UI đổi Name của button nhưng vẫn giữ Text="Pirates".
    if not button then
        for _, node in ipairs(gui:GetDescendants()) do
            if node:IsA("GuiButton") then
                local ok, txt = pcall(function() return node.Text end)
                if ok and type(txt) == "string"
                    and string.lower(txt):find(string.lower(desired), 1, true) then
                    button = node
                    break
                end
            end
        end
    end
    if not button then return false end
    local ok = pcall(function() button.Visible = true; button:Activate() end)
    return ok
end


-- Trả về true khi player ĐÃ có team. Chưa có → gửi lệnh chọn (có
-- cooldown), chưa verify xong → false (main loop gọi lại, không chặn farm).
function TeamController:AutoSelectTeam()
    if LP.Team and LP.Team.Name == (_G.Settings.Team or "Pirates") then
        self.Retries = 0
        return true
    end
    local now = tick()
    if now - self.LastCheck < _G.Settings.TeamCooldown then return false end
    if now - self.LastCheck > self.RetryWindow then self.Retries = 0 end
    if self.Retries >= self.MaxRetries then
        return false
    end
    self.LastCheck = now
    self.Retries = self.Retries + 1
    DLog("TEAM", "No team → selecting " .. tostring(_G.Settings.Team or "Pirates") .. " (retry " .. self.Retries .. ")")
    -- Ưu tiên nút UI khi ChooseTeam đang mở; một số server không nhận
    -- SetTeam cho tới khi client Activate button trước.
    ClickTeamChoice()
    local ok, result = pcall(function()
        return CommF_:InvokeServer("SetTeam", _G.Settings.Team or "Pirates")
    end)
    if not ok then
        warn("[BobonHub] SetTeam error: " .. tostring(result))
    end
    if not LP.Team then ClickTeamChoice() end
    -- VERIFY TEAM, không spam thêm remote.
    task.delay(0.75, function()
        if LP.Team then
            self.Retries = 0
            DLog("TEAM", "Verified team: " .. LP.Team.Name)
        end
    end)
    return LP.Team ~= nil and LP.Team.Name == "Pirates"
end


-- ══════════════════════════════════════════════════════════════════
--   [A-3] MOVEMENT MANAGER — Single Movement Owner API
--   Chỉ MỘT owner điều khiển movement tại một thời điểm:
--   TRAVEL | FARM | RECOVERY
--   Travel Request → Acquire(owner); Stop/arrival → Release(owner).
--   Farm không override khi TRAVEL đang giữ; travel xong → Farm tiếp.
-- ══════════════════════════════════════════════════════════════════
local MovementManager = {}


function MovementManager:Acquire(owner)
    if _G.State.MovementOwner and _G.State.MovementOwner ~= owner then
        return false
    end
    _G.State.MovementOwner = owner
    return true
end


function MovementManager:Release(owner)
    if not owner or _G.State.MovementOwner == owner then
        _G.State.MovementOwner = nil
    end
end


function MovementManager:IsOwner(owner)
    return _G.State.MovementOwner == owner
end


-- ══════════════════════════════════════════════════════════════════
--   [A-4] FARM POSITION CONTROLLER
--   Farm position: X/Z gần tâm mob, Y phía TRÊN mob (FarmHeight,
--   adaptive theo size mob — mob to thì cao hơn). Không xuyên vào mob,
--   không bay quá cao, clamp MinY (không xuống dưới map).
--   Gom mob: mob quest trong MobGatherRadius quanh điểm farm được
--   đưa về một cluster cục bộ quanh target; mob ở xa không bị chạm tới.
-- ══════════════════════════════════════════════════════════════════
local TravelManager
local FarmPositionController = {
    LastGather = 0,
    LastSimulationTry = 0,
    SimulationReady = false,
}


function FarmPositionController:GetFarmPos(mob, requestedHeight)
    if not mob then return nil end
    local root = mob:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local ok, pos = pcall(function() return root.Position end)
    if not ok or not IsValidPos(pos) then return nil end
    local hoverHeight = requestedHeight or _G.Settings.FarmHeight
    return Vector3.new(
        pos.X + _G.Settings.FarmOffsetX,
        math.max(pos.Y + hoverHeight,
            IsSubmergedPosition(pos) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY),
        pos.Z
    )
end

-- Tâm cụm mob: giữ vị trí ở giữa nhóm thay vì bám một mob đơn lẻ.
-- Cách này hoạt động giống nhau ở cả ba sea và không teleport mob.
function FarmPositionController:GetClusterFarmPos(primary)
    if not primary then return nil end
    local root = primary:FindFirstChild("HumanoidRootPart")
    if not root then return self:GetFarmPos(primary) end
    local ok, origin = pcall(function() return root.Position end)
    if not ok or not IsValidPos(origin) then return self:GetFarmPos(primary) end

    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return self:GetFarmPos(primary) end
    local center = Vector3.zero
    local count = 0
    local wantedName = primary.Name:gsub("%s*%[%s*Lv%.%s*%d+%s*%]$", "")
    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChild("Humanoid")
        local mobRoot = mob:FindFirstChild("HumanoidRootPart")
        if IsEnemyNamed(mob, wantedName) and hum and hum.Health > 0 and mobRoot then
            local valid, pos = pcall(function() return mobRoot.Position end)
            if valid and IsValidPos(pos)
                and IsAllowedWorldPosition(pos)
                and (pos - origin).Magnitude <= _G.Settings.MobGatherRadius then
                center = center + pos
                count = count + 1
            end
        end
    end
    if count == 0 then return self:GetFarmPos(primary) end
    local avg = center / count
    return Vector3.new(
        avg.X + _G.Settings.FarmOffsetX,
        math.max(avg.Y + _G.Settings.FarmHeight,
            IsSubmergedPosition(avg) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY),
        avg.Z
    )
end


-- Gom mob: trả về true nếu có mob quest khác trong MobGatherRadius
-- quanh điểm farm (tín hiệu để attack kéo cluster về một khu vực)
function FarmPositionController:HasNearbyMobs(mobName, center)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder or not center then return false end
    for _, v in ipairs(folder:GetChildren()) do
        if IsEnemyNamed(v, mobName) and v:FindFirstChild("Humanoid")
            and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local p = v.HumanoidRootPart.Position
            if IsAllowedWorldPosition(p)
                and (p - center).Magnitude <= _G.Settings.MobGatherRadius then
                return true
            end
        end
    end
    return false
end

-- Bring writes only an owned assembly's CFrame/current velocities. It never
-- leaves Humanoid, collision or anchored properties to restore. Releasing is
-- therefore a logical stop plus a diagnostic reset; the server keeps control
-- of every assembly that is not currently client-owned.
function FarmPositionController:ReleaseCluster()
    GatherGeneration = GatherGeneration + 1
    VerifiedGatherRoots = setmetatable({}, { __mode = "k" })
    if _G.State then
        _G.State.ClusterMode = "OFF"
        _G.State.ClusterAnchor = nil
        _G.State.ClusterMobName = nil
        _G.State.ClusterMobNames = nil
        _G.State.ClusterPrimary = nil
        _G.State.ClusterGeneration = (_G.State.ClusterGeneration or 0) + 1
        _G.State.ClusterActivatedAt = 0
        _G.State.ClusterLastSeen = 0
        _G.State.ClusterLastMoved = 0
    end
    _G.BobonDiagnostics.Bring = "OFF"
    _G.BobonDiagnostics.BringCandidates = 0
    _G.BobonDiagnostics.BringOwned = 0
    _G.BobonDiagnostics.BringMoved = 0
end

local function ExpandSimulationRadius()
    local now = tick()
    -- Public bring implementations refresh this continuously. Do it from the
    -- existing farm tick at a bounded rate so the executor/server cannot reset
    -- the radius and silently turn later moves into client-only ghosts.
    if now - (FarmPositionController.LastSimulationTry or 0)
        < (_G.Settings.GatherSimulationRefresh or 0.75) then
        return FarmPositionController.SimulationReady == true
    end
    FarmPositionController.LastSimulationTry = now
    local requested = false
    -- Keep the request inside the local farm envelope. Success here is never
    -- treated as ownership proof; every NPC is checked independently below.
    local radius = math.clamp(
        _G.Settings.ClusterSimulationRadius
            or ((_G.Settings.GatherMaxDistance or 600) + 150),
        250, 2000)

    if type(setscriptable) == "function" then
        local ok = pcall(function()
            setscriptable(LP, "SimulationRadius", true)
            LP.SimulationRadius = radius
        end)
        requested = requested or ok
    end
    if type(sethiddenproperty) == "function" then
        local ok = pcall(function()
            sethiddenproperty(LP, "SimulationRadius", radius)
            pcall(function()
                sethiddenproperty(LP, "MaximumSimulationRadius", radius)
            end)
        end)
        requested = requested or ok
    end
    if type(setsimulationradius) == "function" then
        local ok = pcall(function() setsimulationradius(radius, radius) end)
        requested = requested or ok
    end
    FarmPositionController.SimulationReady = requested
    return requested
end

ClientOwnsMob = function(root)
    -- true is the only state allowed to move. false means server/other-client
    -- ownership; nil means this executor cannot prove ownership. Treating nil
    -- as true was the exact source of the visible but invulnerable dummy mob.
    if type(isnetworkowner) == "function" then
        local ok, owned = pcall(isnetworkowner, root)
        if ok then return owned == true end
    end
    -- Some environments expose the Roblox method even when the convenience
    -- global is absent. It is normally server-restricted, hence the pcall.
    local ok, owner = pcall(function() return root:GetNetworkOwner() end)
    if ok then return owner == LP end
    return nil
end

-- ══════════════════════════════════════════════════════════════════
--   v18.7 FULL-BATCH PERSISTENT CLUSTER FARM CONTROLLER
--   Player movement remains owned exclusively by TravelManager.
--   This controller only repositions network-owned NPC assemblies.
--   The farm anchor survives individual mob deaths, so the player does not
--   chase a new NPC every time the primary target disappears.
-- ══════════════════════════════════════════════════════════════════
ClusterFarmController = {
    LastTick = 0,
    LastReason = "OFF",
}

local function NormalizeClusterNames(names)
    if type(names) == "string" then return {names} end
    local out = {}
    if type(names) == "table" then
        for _, name in ipairs(names) do
            if type(name) == "string" and name ~= "" then out[#out + 1] = name end
        end
    end
    return out
end

function ClusterFarmController:IsName(name)
    if type(name) ~= "string" then return false end
    local names = _G.State and _G.State.ClusterMobNames
    if type(names) ~= "table" then return false end
    for _, wanted in ipairs(names) do
        if string.lower(wanted) == string.lower(name) then return true end
    end
    return false
end

function ClusterFarmController:IsModelAllowed(model)
    local names = _G.State and _G.State.ClusterMobNames
    if type(names) ~= "table" or not model then return false end
    for _, wanted in ipairs(names) do
        if IsEnemyNamed(model, wanted) then return true end
    end
    return false
end

function ClusterFarmController:IsAttackCluster(mobName)
    if not _G.State or _G.State.ClusterMode == "OFF" then return false end
    return self:IsName(tostring(mobName or ""))
end

function ClusterFarmController:PolicyValid()
    local state = _G.State
    if not state or state.ClusterMode == "OFF" or not state.ClusterAnchor then return false end
    if state.ClusterMode == "QUEST" then
        if state.Mode ~= "Farming" then return false end
        if state.ActiveActionToken ~= 0 then return false end
        if not state.ActiveQuestMob or not self:IsName(state.ActiveQuestMob) then return false end
        -- nil can happen while the quest UI rebuilds; only an explicit false closes it.
        if HasQuest() == false then return false end
        return true
    elseif state.ClusterMode == "SKIP" then
        return state.Mode == "Farming" and state.FState == "SKIP_FARM"
            and GetSea() == 1 and Level() >= 10 and Level() <= 70
    end
    return false
end

function ClusterFarmController:Activate(mode, names, anchorCF, owner)
    if not _G.Settings.GatherMobs then return false end
    local list = NormalizeClusterNames(names)
    if #list == 0 or (typeof(anchorCF) ~= "CFrame" and typeof(anchorCF) ~= "Vector3") then return false end
    local cf = typeof(anchorCF) == "Vector3" and CFrame.new(anchorCF) or anchorCF
    if not IsValidPos(cf.Position) or not IsAllowedWorldPosition(cf.Position) then return false end
    local state = _G.State
    local changed = state.ClusterMode ~= mode or state.ClusterMobName ~= list[1]
        or not state.ClusterAnchor
        or (state.ClusterAnchor.Position - cf.Position).Magnitude > (_G.Settings.ClusterAnchorMaxDrift or 18)
    if changed then
        GatherGeneration = GatherGeneration + 1
        VerifiedGatherRoots = setmetatable({}, { __mode = "k" })
        state.ClusterGeneration = (state.ClusterGeneration or 0) + 1
        state.ClusterActivatedAt = tick()
        state.ClusterPrimary = nil
        DLog("CLUSTER", "Activate " .. tostring(mode) .. " / " .. tostring(list[1]))
    end
    state.ClusterMode = mode
    state.ClusterAnchor = CFrame.new(cf.Position)
    state.ClusterMobNames = list
    state.ClusterMobName = list[1]
    state.ClusterOwner = owner or "Farm"
    return true
end

function ClusterFarmController:GetHoverCFrame(height)
    local anchor = _G.State and _G.State.ClusterAnchor
    if not anchor then return nil end
    local p = anchor.Position
    local h = height or _G.Settings.FarmHeight or 15
    local y = math.max(p.Y + h,
        IsSubmergedPosition(p) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY)
    return CFrame.new(p.X + (_G.Settings.FarmOffsetX or 0), y, p.Z)
end

function ClusterFarmController:IsVerified(model)
    if not model or not self:IsModelAllowed(model) then return false end
    local root = model:FindFirstChild("HumanoidRootPart")
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false end
    local at = VerifiedGatherRoots[root]
    return at ~= nil and tick() - at <= (_G.Settings.GatherVerifiedTTL or 0.9)
        and ClientOwnsMob(root) == true
end

function ClusterFarmController:SelectPrimary()
    local state = _G.State
    local folder = workspace:FindFirstChild("Enemies")
    local anchor = state and state.ClusterAnchor
    if not folder or not anchor then return nil end
    if state.ClusterPrimary and state.ClusterPrimary.Parent
        and state.ClusterPrimary:FindFirstChildOfClass("Humanoid")
        and state.ClusterPrimary:FindFirstChildOfClass("Humanoid").Health > 0
        and self:IsModelAllowed(state.ClusterPrimary)
        and self:IsVerified(state.ClusterPrimary) then
        return state.ClusterPrimary
    end
    local best, bestDist
    for _, mob in ipairs(folder:GetChildren()) do
        if self:IsModelAllowed(mob) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root and self:IsVerified(mob) then
                local d = (root.Position - anchor.Position).Magnitude
                if not bestDist or d < bestDist then best, bestDist = mob, d end
            end
        end
    end
    state.ClusterPrimary = best
    return best
end

function ClusterFarmController:Tick()
    if not self:PolicyValid() then
        if _G.State and _G.State.ClusterMode ~= "OFF" then
            FarmPositionController:ReleaseCluster()
        end
        return 0
    end
    local now = tick()
    if now - (self.LastTick or 0) < (_G.Settings.ClusterRefresh or 0.08) then return 0 end
    self.LastTick = now

    local state = _G.State
    local anchorCF = state.ClusterAnchor
    local anchor = anchorCF.Position
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return 0 end
    ExpandSimulationRadius()

    -- Expire stale attack entries, but keep the anchor itself alive.
    local ttl = _G.Settings.GatherVerifiedTTL or 0.9
    for root, at in pairs(VerifiedGatherRoots) do
        if not root.Parent or now - at > ttl then VerifiedGatherRoots[root] = nil end
    end

    local candidates = {}
    -- v18.7: "bãi đang farm" is the stable cluster-anchor envelope, not merely
    -- the few mobs closest to the current primary. This keeps every matching
    -- quest/skip mob in the same spawn field eligible for the same batch pull.
    local maxDistance = math.clamp(_G.Settings.GatherMaxDistance or 600, 100, 1200)
    for _, mob in ipairs(folder:GetChildren()) do
        if self:IsModelAllowed(mob) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root and root.Parent and not root.Anchored then
                local ok, pos = pcall(function() return root.Position end)
                if ok and IsValidPos(pos) and IsAllowedWorldPosition(pos)
                    and IsSubmergedPosition(pos) == IsSubmergedPosition(anchor)
                    and (pos - anchor).Magnitude <= maxDistance then
                    candidates[#candidates + 1] = {
                        Model=mob, Humanoid=hum, Root=root, Position=pos
                    }
                end
            end
        end
    end

    state.ClusterLastSeen = #candidates > 0 and now or (state.ClusterLastSeen or 0)
    table.sort(candidates, function(a,b)
        return (a.Position - anchor).Magnitude < (b.Position - anchor).Magnitude
    end)

    local moved, owned, unknown = 0, 0, false
    -- IMPORTANT: gathering is no longer capped by FastAttackMaxTargets.
    -- Magnet every matching mob we can really own; attack remains separately
    -- capped so a large spawn field does not become one oversized remote packet.
    local limit = math.min(#candidates, math.max(1, _G.Settings.ClusterGatherLimit or 64))
    local stackRadius = math.max(0, _G.Settings.ClusterStackRadius or 0.75)
    local generation = GatherGeneration
    for i = 1, limit do
        if generation ~= GatherGeneration then return 0 end
        local entry = candidates[i]
        local owns = ClientOwnsMob(entry.Root)
        if owns == true then
            owned = owned + 1
            -- Tight deterministic stack: all owned mobs land in one attack pocket.
            -- A tiny spiral keeps Roblox physics from ejecting perfectly-overlapped
            -- root assemblies while remaining visually one pile.
            local angle = (i - 1) * 2.3999632297
            local radius = stackRadius == 0 and 0
                or math.min(stackRadius, 0.08 + (i - 1) * 0.035)
            local destination = anchor
                + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
            local okMove = pcall(function()
                local rot = entry.Root.CFrame.Rotation
                entry.Root.AssemblyLinearVelocity = Vector3.zero
                entry.Root.AssemblyAngularVelocity = Vector3.zero
                entry.Root.CFrame = CFrame.new(destination) * rot
            end)
            if okMove then
                VerifiedGatherRoots[entry.Root] = now
                moved = moved + 1
                if not state.ClusterPrimary or not self:IsVerified(state.ClusterPrimary) then
                    state.ClusterPrimary = entry.Model
                end
            else
                VerifiedGatherRoots[entry.Root] = nil
            end
        elseif owns == nil then
            unknown = true
            VerifiedGatherRoots[entry.Root] = nil
        else
            VerifiedGatherRoots[entry.Root] = nil
        end
    end

    if moved > 0 then state.ClusterLastMoved = now end
    local primary = self:SelectPrimary()
    state.ClusterPrimary = primary
    _G.BobonDiagnostics.BringCandidates = #candidates
    _G.BobonDiagnostics.BringOwned = owned
    _G.BobonDiagnostics.BringMoved = moved
    _G.BobonDiagnostics.Bring = moved > 0 and ("CLUSTER-" .. state.ClusterMode)
        or (#candidates == 0 and "CLUSTER-WAIT-SPAWN")
        or (unknown and "NO-OWNERSHIP-API")
        or "WAIT-OWNERSHIP"
    return moved
end

-- Compatibility wrapper for old callers. Quest mode now persists at the
-- current state anchor instead of using the primary mob as the cluster center.
function FarmPositionController:GatherMobCluster(mobName, primary)
    if not _G.State.ClusterAnchor then
        local root = primary and primary:FindFirstChild("HumanoidRootPart")
        if not root then return 0 end
        ClusterFarmController:Activate("QUEST", {mobName}, CFrame.new(root.Position), "Farm")
    end
    return ClusterFarmController:Tick()
end

-- NPC magnet loop only. It never writes MovementOwner and never moves player.
task.spawn(function()
    while SessionAlive() and task.wait(_G.Settings.ClusterRefresh or 0.08) do
        local ok, err = pcall(function() ClusterFarmController:Tick() end)
        if not ok and _G.Settings.Debug then warn("[BobonHub] Cluster Error: " .. tostring(err)) end
    end
end)


-- ══════════════════════════════════════════════════════════════════
--    TRAVEL MANAGER v7 (FIXED)
--   Single movement owner DUY NHẤT
--   Persistent coroutine + token cancellation
--   Noclip restore original CanCollide state
--   Anti-fall lift (không teleport loop)
--   FarmHeight offset applied trong target resolution
--   Stuck detection riêng cho hover vs transit
--   [FIX-4] Validate target mỗi tick: Parent / Humanoid health / dưới biển
--   [FIX-5] Validate instance target ngay tại Request()
--   [FIX-11] Farm hover reset travel timeout khi đã tới → không recovery vô ích
-- ══════════════════════════════════════════════════════════════════
TravelManager = {}
TravelManager.ActiveThread = nil
TravelManager.CurrentToken = 0
TravelManager.TargetRef = nil
TravelManager.CurrentOptions = nil
TravelManager.AtCombatAnchor = false
TravelManager.AtCombatTarget = nil
TravelManager.DodgeOffset = Vector3.zero
TravelManager.DodgeUntil = 0
TravelManager.LastNearQuestSnap = 0
TravelManager.NoclipConn = nil
TravelManager.PhysicsBV = nil
TravelManager.PhysicsBG = nil
TravelManager.OriginalCollision = {}
TravelManager.LastEntranceRequest = 0

-- Dùng entrance remote cho các đảo cách nhau quá xa; nếu không, BodyVelocity
-- phải bay xuyên toàn map và dễ lệch/đứng giữa biển ở các điểm chuyển sea.
function TravelManager:MaybeRequestEntrance(targetPos)
    if not IsValidPos(targetPos) then return end
    local now = tick()
    if now - self.LastEntranceRequest < 5 then return end
    local entrance
    if targetPos.X > 50000 then
        entrance = Vector3.new(61163.85, 11.68, 1819.78) -- Upper Sky/Fishman
    elseif targetPos.Z > 30000 then
        entrance = Vector3.new(923.21, 126.98, 32852.83) -- Cursed Ship
    elseif targetPos.Y > 5000 and targetPos.X < -7000 then
        entrance = Vector3.new(-7894.62, 5547.14, -380.29) -- Skylands
    elseif targetPos.Y > 700 and targetPos.X < -4000 and targetPos.Z < -1500 then
        entrance = Vector3.new(-4607.82, 872.54, -1667.56) -- Upper Sky
    elseif targetPos.X > 5000 and targetPos.Z < -5000 then
        entrance = Vector3.new(-6508.56, 5000.03, -132.84) -- Ice Castle
    end
    if not entrance then return end
    local ok, err = pcall(function()
        CommF_:InvokeServer("requestEntrance", entrance)
    end)
    self.LastEntranceRequest = now
    if not ok then
        DLog("TRAVEL", "requestEntrance failed: " .. tostring(err))
    end
end


function TravelManager:CleanupPhysics(char)
    if self.PhysicsBV and self.PhysicsBV.Parent then self.PhysicsBV:Destroy() end
    if self.PhysicsBG and self.PhysicsBG.Parent then self.PhysicsBG:Destroy() end
    self.PhysicsBV = nil
    self.PhysicsBG = nil
    -- Never delete arbitrary movers created by the game, a weapon or another
    -- controller. Bobon owns only the two references above.
end


function TravelManager:EnableNoclip(char)
    if self.NoclipConn then self.NoclipConn:Disconnect() end
    self.OriginalCollision = {}
    if char then
        for _,part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                self.OriginalCollision[part] = part.CanCollide
            end
        end
    end
    self.NoclipConn = RunService.Stepped:Connect(function()
        if not SessionAlive() then return end
        if char and char:FindFirstChild("Humanoid") then
            for _,part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end


function TravelManager:DisableNoclip()
    if self.NoclipConn then
        self.NoclipConn:Disconnect()
        self.NoclipConn = nil
    end
    for part, canCollide in pairs(self.OriginalCollision) do
        if part and part.Parent then
            pcall(function() part.CanCollide = canCollide end)
        end
    end
    self.OriginalCollision = {}
end


function TravelManager:Stop(reason)
    self.CurrentToken = self.CurrentToken + 1
    self.ActiveThread = nil
    self.TargetRef = nil
    self.CurrentOptions = nil
    self.AtCombatAnchor = false
    self.AtCombatTarget = nil
    self.DodgeOffset = Vector3.zero
    self.DodgeUntil = 0
    _G.State.IsTraveling = false
    -- [A-3] Release movement owner qua MovementManager API
    MovementManager:Release()
    self:CleanupPhysics(Char())
    self:DisableNoclip()
end

function TravelManager:IsAtCombatAnchor(target)
    return self.AtCombatAnchor and (not target or self.AtCombatTarget == target)
end

function TravelManager:ApplyDodgeOffset(offset, duration)
    if typeof(offset) ~= "Vector3" or not self.AtCombatAnchor
        or not self.CurrentOptions or not self.CurrentOptions.combatHover then
        return false
    end
    self.DodgeOffset = offset
    self.DodgeUntil = tick() + (duration or 0.25)
    return true
end

local function SameTravelOptions(a, b)
    if not a or not b then return false end
    return a.arrivalThreshold == b.arrivalThreshold
        and a.speed == b.speed
        and a.fallback == b.fallback
        and a.combatHover == b.combatHover
        and a.persistent == b.persistent
        and a.hoverHeight == b.hoverHeight
end


function TravelManager:Request(targetCF, owner, options)
    options = options or {}
    owner = owner or "Unknown"


    if not _G.State:CanRequestTravel() then
        return false, "CannotTravel:" .. _G.State.Mode
    end


    -- [FIX-5] Validate instance target tại Request(): mob chết/destroy/
    -- dưới biển → reject ngay, không khởi tạo travel tới target rác
    local targetType = typeof(targetCF)
    if targetType ~= "Instance" and targetType ~= "CFrame" and targetType ~= "Vector3" then
        return false, "InvalidTarget"
    end

    local targetModel = nil
    local targetHumanoid = nil
    local targetPosition = nil
    if targetType == "Instance" then
        if not targetCF.Parent then return false, "InvalidTarget" end
        targetModel = targetCF:IsA("Model") and targetCF
            or targetCF:FindFirstAncestorOfClass("Model")
        targetHumanoid = targetModel and targetModel:FindFirstChildOfClass("Humanoid")
        if targetHumanoid and targetHumanoid.Health <= 0 then return false, "InvalidTarget" end
        local okPos, pos = pcall(function()
            if targetCF:IsA("BasePart") then return targetCF.Position end
            if targetCF:IsA("Model") then return targetCF:GetPivot().Position end
            return nil
        end)
        if not okPos or (pos and not IsValidPos(pos)) then return false, "InvalidTarget" end
        if pos and not IsAllowedWorldPosition(pos) then return false, "InvalidTarget" end
        targetPosition = pos
    elseif targetType == "CFrame" or targetType == "Vector3" then
        -- [FIX-P11] Reject NaN/invalid position ngay tại Request()
        local pos = typeof(targetCF) == "CFrame" and targetCF.Position or targetCF
        if not IsValidPos(pos) then return false, "InvalidTarget" end
        targetPosition = pos
    end

    local enemyFolder = workspace:FindFirstChild("Enemies")
    local inferredCombat = targetModel and targetHumanoid
        and enemyFolder and targetModel.Parent == enemyFolder
    local normalizedOptions = {
        combatHover = options.combatHover == true
            or (options.combatHover ~= false and inferredCombat == true),
        hoverHeight = options.hoverHeight,
        fallback = options.fallback,
        speed = options.speed or _G.Settings.FlySpeed,
        persistent = options.persistent == true
            or (options.persistent ~= false and owner == "Farm"
                and targetType ~= "Instance"),
    }
    normalizedOptions.arrivalThreshold = options.arrivalThreshold
        or (normalizedOptions.combatHover and _G.Settings.FarmArrivalThreshold)
        or _G.Settings.CloseThreshold


    -- A different owner must never invalidate the active travel token.
    if _G.State.IsTraveling and _G.State.MovementOwner ~= owner then
        return false, "MovementBusy"
    end

    -- Same owner may reuse a thread only when the complete goal is unchanged.
    -- Retargeting q.MC -> enemy must also replace threshold/fallback/cruise;
    -- keeping the old 35-stud goal was the permanent APPROACHING bug.
    local needsRetarget = false
    if _G.State.IsTraveling and _G.State.MovementOwner == owner and self.ActiveThread then
        if self.TargetRef == targetCF
            and SameTravelOptions(self.CurrentOptions, normalizedOptions) then
            return true, self.CurrentToken
        end
        needsRetarget = true
    end


    -- [FIX-P1] Detect long-distance travel → cruise mode + timeout động
    local startPos = HRP() and HRP().Position
    local startDist = nil
    local startSubmerged = startPos and IsSubmergedPosition(startPos) or false
    local targetSubmerged = targetPosition and IsSubmergedPosition(targetPosition) or false
    -- Submerged entry/exit is handled by its verified access controller.
    -- Reject a cross-boundary body flight before any ordinary entrance remote
    -- can yield or alter the currently safe travel goal.
    if targetSubmerged and not startSubmerged then
        return false, "AwaitingSubmergedEntrance"
    elseif startSubmerged and not targetSubmerged then
        return false, "SubmergedExitRequired"
    end

    if startPos and IsValidPos(startPos) then
        local tpos = targetPosition
        if tpos and IsValidPos(tpos) then
            startDist = (startPos - tpos).Magnitude
            if owner == "Farm" and startDist > 10000 then
                self:MaybeRequestEntrance(tpos)
                local refreshed = HRP()
                if refreshed and IsValidPos(refreshed.Position) then
                    startPos = refreshed.Position
                    startDist = (startPos - tpos).Magnitude
                end
            end
        end
    end

    -- Validation above may yield while an entrance remote responds. Keep the
    -- old safe travel alive until the replacement goal is fully accepted.
    if needsRetarget then self:Stop("AtomicRetarget") end


    -- Acquire before invalidating any token. This prevents a failed request
    -- from killing the currently active owner and leaving State stuck.
    if not MovementManager:Acquire(owner) then
        return false, "MovementBusy"
    end

    -- New travel: invalidate old via token
    self.CurrentToken = self.CurrentToken + 1
    local myToken = self.CurrentToken


    self:CleanupPhysics(Char())
    self:DisableNoclip()


    _G.State.IsTraveling = true
    _G.State.LastMoveTime = os.time()
    _G.State.LastPosition = HRP() and HRP().Position or nil
    self.TargetRef = targetCF
    self.CurrentOptions = normalizedOptions
    self.AtCombatAnchor = false
    self.AtCombatTarget = nil
    DLog("TRAVEL", "Request by " .. owner .. ", dist="
        .. (startDist and string.format("%.0f", startDist) or "?"))


    self.ActiveThread = task.spawn(function()
        -- Travel runs in its own coroutine; isolate unexpected physics/API
        -- errors so IsTraveling can never remain stuck forever.
        local char = Char()
        local threadOk, threadErr = xpcall(function()
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            self:CleanupPhysics(char)
            _G.State.IsTraveling = false
            _G.State.MovementOwner = nil
            return
        end
        local root = char.HumanoidRootPart


        self:CleanupPhysics(char)
        self:EnableNoclip(char)


        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.zero
        self.PhysicsBV = bv


        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.D = 100; bg.P = 10000
        self.PhysicsBG = bg


        local lastPos = root.Position
        local stuckTimer = 0
        local targetLostTimer = 0
        local travelStart = os.time()
        local travelOptions = self.CurrentOptions or normalizedOptions
        local arrivalThresh = travelOptions.arrivalThreshold
        local flySpeed = travelOptions.speed
        local isCombatHover = travelOptions.combatHover == true
        local isPersistent = travelOptions.persistent == true
        local fallback = travelOptions.fallback

        -- [FIX-P1] Long-distance/cruise mode + timeout động theo khoảng cách
        local longTravel = startDist ~= nil
            and startDist > _G.Settings.CruiseThreshold
            and not (startSubmerged and targetSubmerged)
        local cruiseLogged = false
        local travelTimeout = _G.Settings.TravelTimeout
        local lastStepTime = tick()
        if longTravel and startDist then
            travelTimeout = math.max(_G.Settings.TravelTimeout,
                startDist / flySpeed + _G.Settings.TravelTimeoutMargin)
            travelTimeout = math.min(travelTimeout, 300)
        end

        -- [FIX-13] Khi target farm chết/mất giữa đường bay → về khu farm (fallback)
        -- Thay vì break (drop khỏi không trung) → đổi TargetRef sang CFrame an toàn
        local function HandleFarmInvalid(reason)
            _G.State:ClearTargets()
            if fallback then
                self.TargetRef = fallback
                fallback = nil
                isCombatHover = false
                isPersistent = true
                arrivalThresh = _G.Settings.CloseThreshold
                self.AtCombatAnchor = false
                self.AtCombatTarget = nil
                travelStart = os.time()
                stuckTimer = 0
                _G.BobonStatus = "Farm: " .. reason .. ", returning to farm area"
                return true
            end
            return false
        end


        while SessionAlive() and self.CurrentToken == myToken
            and char and char.Parent
            and IsAlive() do

            local stepNow = tick()
            local stepDt = math.clamp(stepNow - lastStepTime, 0, 0.1)
            lastStepTime = stepNow
            if _G.State.ActiveActionToken ~= 0
                and _G.State.ActionOwner == owner then
                _G.State:TouchAction(_G.State.ActiveActionToken)
            end


            -- Travel timeout (động theo khoảng cách khi long travel) [FIX-P1]
            if os.time() - travelStart > travelTimeout then
                -- Farm timeout → về khu farm (fallback), không recover giữa biển [FIX-13]
                if isCombatHover and HandleFarmInvalid("Timeout") then
                    continue
                end
                warn("[Travel] Timeout by " .. owner)
                DLog("TRAVEL", "Timeout by " .. owner)
                _G.State.IsRecovering = true
                break
            end


            -- Resolve target position + validate mỗi tick [FIX-4]
            local targetPos
            local combatLookPos = nil
            local targetType = typeof(self.TargetRef)
            if targetType == "Instance" then
                if not self.TargetRef.Parent then
                    -- Mob biến mất: farm → về khu farm (fallback), không drop giữa không trung [FIX-13]
                    if isCombatHover then
                        if HandleFarmInvalid("Target lost") then
                            continue
                        end
                        break
                    end
                    targetLostTimer = targetLostTimer + task.wait(0.2)
                    if targetLostTimer >= _G.Settings.TargetLostTimeout then
                        _G.State.IsRecovering = true
                        break
                    end
                    continue
                end
                local liveModel = self.TargetRef:IsA("Model") and self.TargetRef
                    or self.TargetRef:FindFirstAncestorOfClass("Model")
                local hum = liveModel and liveModel:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then
                    -- Mob chết: farm → về khu farm (fallback) để tiếp tục [FIX-13]
                    if isCombatHover then
                        if HandleFarmInvalid("Target defeated") then
                            continue
                        end
                        break
                    end
                    break
                end
                local okP, p = pcall(function()
                    if self.TargetRef:IsA("BasePart") then
                        return self.TargetRef.Position
                    end
                    return self.TargetRef:GetPivot().Position
                end)
                -- [FIX-P11] Reject NaN/invalid position
                if not okP or not IsValidPos(p) then
                    if isCombatHover then
                        if HandleFarmInvalid("Invalid target") then
                            continue
                        end
                        break
                    end
                    break
                end
                targetLostTimer = 0
                if isCombatHover then
                    -- Always anchor on the selected mob first.  Other quest
                    -- mobs are gathered only after the player arrives above it.
                    local model = self.TargetRef:IsA("Model") and self.TargetRef
                        or self.TargetRef:FindFirstAncestorOfClass("Model")
                    local hoverHeight = travelOptions.hoverHeight
                    if not hoverHeight then
                        if CombatController:IsFastReady()
                            or not CombatController:WantsClientRange() then
                            hoverHeight = owner == "Farm"
                                and (_G.Settings.FarmHeight or 15)
                                or (_G.Settings.BossFarmHeight or 24)
                        else
                            hoverHeight = _G.Settings.ClientHoverHeight or 5
                        end
                    end
                    -- Never change hover height because player health fell.
                    -- PvP damage is ignored; NPC skills are handled only by
                    -- DodgeController without releasing this combat target.
                    combatLookPos = p
                    targetPos = FarmPositionController:GetFarmPos(model, hoverHeight)
                    if tick() < self.DodgeUntil then
                        targetPos = targetPos and (targetPos + self.DodgeOffset) or nil
                    else
                        self.DodgeOffset = Vector3.zero
                    end
                    if not targetPos then
                        targetPos = GetFarmPosition(p)
                    end
                    if not targetPos then
                        if HandleFarmInvalid("Position unavailable") then
                            continue
                        end
                        break
                    end
                else
                    targetPos = p
                end
                -- Reject target dưới biển
                if not IsAllowedWorldPosition(targetPos) then
                    warn("[Travel] Reject target dưới biển (Y=" .. string.format("%.1f", targetPos.Y) .. ")")
                    if isCombatHover then
                        if HandleFarmInvalid("Target below sea level") then
                            continue
                        end
                        break
                    end
                    break
                end
            elseif targetType == "CFrame" then
                targetPos = self.TargetRef.Position
            elseif targetType == "Vector3" then
                targetPos = self.TargetRef
            else
                break
            end


            if not targetPos or not IsValidPos(targetPos) then break end


            -- Anti-fall clamp target Y (chỉ cho target cố định CFrame/Vector3)
            if targetPos.Y < _G.Settings.MinY and not IsSubmergedPosition(targetPos) then
                if targetPos.Y <= -100 then break end
                targetPos = Vector3.new(targetPos.X, _G.Settings.MinY, targetPos.Z)
            end


            local currentPos = root.Position
            if not IsValidPos(currentPos) then currentPos = lastPos end
            local dist = (currentPos - targetPos).Magnitude


            -- [FIX-P1] CRUISE MODE: bay xa qua biển → giữ độ cao an toàn,
            -- chỉ approach target Y thật khi đã gần đảo
            if longTravel and dist > _G.Settings.ApproachThreshold then
                if not cruiseLogged then
                    cruiseLogged = true
                    DLog("TRAVEL", "Cruise mode active → " .. tostring(targetPos))
                end
                local cruiseY = math.max(targetPos.Y, _G.Settings.CruiseAltitude)
                if currentPos.Y < cruiseY - 1 then
                    -- còn thấp → lên độ cao cruise
                    targetPos = Vector3.new(targetPos.X, cruiseY, targetPos.Z)
                elseif currentPos.Y > cruiseY + _G.Settings.CruiseAltitude then
                    -- quá cao → hạ xuống từ từ (không dive thẳng)
                    targetPos = Vector3.new(targetPos.X, math.max(currentPos.Y - 2, cruiseY), targetPos.Z)
                else
                    -- đã ở độ cao cruise → bay ngang ổn định
                    targetPos = Vector3.new(targetPos.X, currentPos.Y, targetPos.Z)
                end
                dist = (currentPos - targetPos).Magnitude
            end


            -- [FIX-P1] Anti-fall trong travel: VỪA nâng lên VỪA bay ngang về
            -- target (không kẹt vòng lặp "chỉ đi lên")
            if currentPos.Y < _G.Settings.MinY
                and not IsSubmergedPosition(currentPos) then
                local liftOffset = targetPos - currentPos
                local liftDir = liftOffset.Magnitude > 0.1 and liftOffset.Unit or Vector3.new(0, 0, 0)
                bv.Velocity = Vector3.new(liftDir.X * flySpeed, 60, liftDir.Z * flySpeed)
                local liftFace = combatLookPos or targetPos
                local liftFlat = Vector3.new(liftFace.X, currentPos.Y, liftFace.Z)
                if (liftFlat - currentPos).Magnitude > 0.05 then
                    bg.CFrame = CFrame.lookAt(currentPos, liftFlat)
                end
                task.wait(0.03)
                continue
            end


            -- v18.3 QUEST-ONLY NEAR SNAP. This is a conservative movement
            -- shortcut, not an anti-kick/anti-cheat bypass: only the regular Farm
            -- owner, a currently active canonical quest mob, and a short distance
            -- are eligible. Boss/item/Sea/Katakuri owners always use normal travel.
            if isCombatHover and owner == "Farm" and _G.Settings.NearQuestSnap
                and dist > arrivalThresh
                and dist <= (_G.Settings.NearQuestSnapDistance or 22)
                and stepNow - (self.LastNearQuestSnap or 0)
                    >= (_G.Settings.NearQuestSnapCooldown or 0.45) then
                local snapModel = self.TargetRef and typeof(self.TargetRef) == "Instance"
                    and (self.TargetRef:IsA("Model") and self.TargetRef
                        or self.TargetRef:FindFirstAncestorOfClass("Model")) or nil
                local activeQuestMob = _G.State.ActiveQuestMob
                if HasQuest() == true and activeQuestMob and snapModel
                    and _G.State.FarmTarget == snapModel
                    and IsEnemyNamed(snapModel, activeQuestMob) then
                    local look = combatLookPos or targetPos
                    local flatLook = Vector3.new(look.X, targetPos.Y, look.Z)
                    local snapCF = (flatLook - targetPos).Magnitude > 0.05
                        and CFrame.lookAt(targetPos, flatLook)
                        or (CFrame.new(targetPos) * root.CFrame.Rotation)
                    local okSnap = pcall(function()
                        root.CFrame = snapCF
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                        bg.CFrame = snapCF
                    end)
                    if okSnap then
                        self.LastNearQuestSnap = stepNow
                        self.AtCombatAnchor = true
                        self.AtCombatTarget = self.TargetRef
                        _G.State.LastMoveTime = os.time()
                        _G.State.LastPosition = targetPos
                        lastPos = targetPos
                        travelStart = os.time()
                        stuckTimer = 0
                        task.wait(0.03)
                        continue
                    end
                end
            end

            -- Arrival detection
            if dist <= arrivalThresh then
                bv.Velocity = Vector3.zero
                if not isCombatHover then
                    self.AtCombatAnchor = false
                    self.AtCombatTarget = nil
                    if not isPersistent then break end
                    root.CFrame = CFrame.new(targetPos) * root.CFrame.Rotation
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    travelStart = os.time()
                    stuckTimer = 0
                    _G.State.LastMoveTime = os.time()
                    task.wait(0.03)
                    continue
                end
                local look = combatLookPos or targetPos
                local flatLook = Vector3.new(look.X, targetPos.Y, look.Z)
                local anchorCF
                if (flatLook - targetPos).Magnitude > 0.05 then
                    anchorCF = CFrame.lookAt(targetPos, flatLook)
                else
                    anchorCF = CFrame.new(targetPos) * root.CFrame.Rotation
                end
                root.CFrame = anchorCF
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                bg.CFrame = anchorCF
                self.AtCombatAnchor = true
                self.AtCombatTarget = self.TargetRef
                -- [FIX-11] Hover hợp lệ = activity, reset travel timeout
                travelStart = os.time()
                stuckTimer = 0
                _G.State.LastMoveTime = os.time()
                task.wait(0.03)
                continue
            end


            -- Movement with deceleration
            self.AtCombatAnchor = false
            self.AtCombatTarget = nil
            local direction = (targetPos - currentPos).Unit
            local speed = flySpeed
            if dist < 60 then speed = speed * math.max(dist / 60, 0.15) end


            bv.Velocity = direction * speed
            local face = combatLookPos or targetPos
            local flatFace = Vector3.new(face.X, currentPos.Y, face.Z)
            if (flatFace - currentPos).Magnitude > 0.05 then
                bg.CFrame = CFrame.lookAt(currentPos, flatFace)
            end


            -- Stuck detection (riêng cho từng mode) [FIX-P1]
            local moveDelta = (currentPos - lastPos).Magnitude
            if moveDelta < 1 then
                stuckTimer = stuckTimer + stepDt
                local stuckLimit = _G.Settings.StuckTimeout
                if isCombatHover then
                    stuckLimit = _G.Settings.HoverStuckTimeout
                elseif longTravel then
                    stuckLimit = _G.Settings.CruiseStuckTimeout
                end
                if stuckTimer >= stuckLimit then
                    _G.State.IsRecovering = true
                    warn("[Travel] Stuck by " .. owner)
                    DLog("TRAVEL", "Stuck by " .. owner)
                    break
                end
            else
                stuckTimer = 0
                _G.State.LastMoveTime = os.time()
                _G.State.LastPosition = currentPos
            end


            lastPos = currentPos
            task.wait(0.03)
            end
        end, debug.traceback)
        if not threadOk then
            warn("[BobonHub] Module Error: TravelManager: " .. tostring(threadErr))
            if self.CurrentToken == myToken then
                _G.State.IsRecovering = true
            end
        end


        -- Thread exited: only cleanup if still active token
        if self.CurrentToken == myToken then
            pcall(function()
                self:CleanupPhysics(char)
                self:DisableNoclip()
            end)
            _G.State.IsTraveling = false
            _G.State.MovementOwner = nil
            self.ActiveThread = nil
            self.TargetRef = nil
            self.CurrentOptions = nil
            self.AtCombatAnchor = false
            self.AtCombatTarget = nil
            self.DodgeOffset = Vector3.zero
            self.DodgeUntil = 0
        end
    end)


    return true, myToken
end


-- Haki is enabled once for each character lifetime.  Re-sending `Buso`
-- repeatedly can act like a toggle on some builds, so never run it from a
-- heartbeat/watchdog; reset and re-enable only after CharacterAdded.
local HakiController = {
    Character = nil,
    Enabled = false,
}

function HakiController:Reset()
    self.Character = nil
    self.Enabled = false
end

function HakiController:EnableForCharacter()
    local character = Char()
    if not character or not IsAlive() then return false end
    if self.Character == character and self.Enabled then return true end
    self.Character = character
    self.Enabled = false
    local okBuso = pcall(function() CommF_:InvokeServer("Buso", true) end)
    pcall(function() CommF_:InvokeServer("Ken", true) end)
    self.Enabled = okBuso
    return okBuso
end


-- Observe player HP without creating another polling loop. Damage only marks
-- a short retry grace for combat verification; it never changes farm mode,
-- movement ownership, hover height, target, bring state or action token.
local PlayerDamageConnection = nil
local PlayerDamageCharacter = nil

local function BindPlayerDamage(character, humanoid)
    if PlayerDamageConnection then
        PlayerDamageConnection:Disconnect()
        PlayerDamageConnection = nil
    end
    PlayerDamageCharacter = character
    if not character or not humanoid then return end
    local lastHealth = humanoid.Health
    PlayerDamageConnection = humanoid.HealthChanged:Connect(function(newHealth)
        if not SessionAlive() or PlayerDamageCharacter ~= character then return end
        if newHealth < lastHealth then
            _G.State.LastIncomingDamage = tick()
            if _G.Settings.ContinuityMode then
                -- Damage/knockback must not look like a travel stall. Keep the
                -- existing ActionToken, MovementOwner, target and Mode intact.
                _G.State.LastMoveTime = os.time()
                _G.State.ConsecutiveFails = 0
                DLog("CONTINUITY", "incoming damage ignored; current job preserved")
            end
        end
        lastHealth = newHealth
    end)
end

local function QueuePlayerDamageBind(character)
    PlayerDamageCharacter = character
    if not character then
        BindPlayerDamage(nil, nil)
        return
    end
    task.spawn(function()
        local humanoid = character:WaitForChild("Humanoid", 10)
        if SessionAlive() and PlayerDamageCharacter == character then
            BindPlayerDamage(character, humanoid)
        end
    end)
end

QueuePlayerDamageBind(Char())


-- Death/Respawn handlers
LP.CharacterRemoving:Connect(function()
    if not SessionAlive() then return end
    BindPlayerDamage(nil, nil)
    HakiController:Reset()
    CombatController:Cleanup()
    FarmPositionController:ReleaseCluster()
    TravelManager:Stop("CharacterRemoving")
    _G.State:SetMode("Dead")
    _G.State:ClearTargets()
    _G.State:ForceReleaseAction("Death")
end)


LP.CharacterAdded:Connect(function(char)
    if not SessionAlive() then return end
    QueuePlayerDamageBind(char)
    task.spawn(function()
        _G.State:SetMode("Respawning")
        TravelManager:Stop("Respawn")


        local hrp = char:WaitForChild("HumanoidRootPart", 10)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hrp or not hum then return end


        pcall(function() LP:WaitForChild("Data", 10) end)

        task.wait(0.5)
        HakiController:EnableForCharacter()


        _G.State.IsTraveling = false
        _G.State.IsRecovering = false
        _G.State.MovementOwner = nil
        _G.State:ForceReleaseAction("Respawn")
        _G.State:ClearTargets()
        _G.State.LastIncomingDamage = 0
        _G.State.ConsecutiveFails = 0
        _G.State.Sea = GetSea()


        task.wait(2)
        _G.State:SetMode("Idle")
    end)
end)


-- [FIX-P8/P9] Travel + verify tới nơi trước khi gọi remote.
-- Thay cho "task.wait(2)" giả định thành công. Check alive + token
-- mỗi bước; nếu chưa tới thì chờ travel tới (TravelManager tự bay).
-- Trả về true khi đã tới + còn sống + token còn hợp lệ.
local function TravelAndWait(owner, token, cf, opts)
    opts = opts or {}
    if not _G.State:IsActionValid(token) then return false end
    if not IsAlive() then return false end
    local ok = TravelManager:Request(cf, owner, opts)
    if not ok then return false end
    local function ResolvePosition(target)
        local targetType = typeof(target)
        if targetType == "CFrame" then return target.Position end
        if targetType == "Vector3" then return target end
        if targetType == "Instance" then
            local success, position = pcall(function()
                if target:IsA("BasePart") then return target.Position end
                if target:IsA("Model") then return target:GetPivot().Position end
            end)
            if success then return position end
        end
        return nil
    end
    local destination = ResolvePosition(cf)
    if not IsValidPos(destination) then return false end
    local hrp = HRP()
    local thresh = opts.arrivalThreshold or _G.Settings.CloseThreshold
    local timeout = os.time() + (opts.timeout or 60)
    local arrived = false
    while _G.State:IsActionValid(token) and IsAlive() and os.time() < timeout do
        hrp = HRP()
        if hrp and (hrp.Position - destination).Magnitude <= thresh then
            arrived = true
            break
        end
        task.wait(0.5)
    end
    if not arrived then return false end
    task.wait(opts.settle or 1)
    return _G.State:IsActionValid(token) and IsAlive()
end
-- ══════════════════════════════════════════════════════════════════
--         [FIX-13] ANTI-FALL SAFETY NET (chỉ khi KHÔNG có travel)
--   Background loop an toàn: KHÔNG điều khiển movement bình thường.
--   Chỉ kích hoạt khi character rơi dưới MinY (sắp chết đuối) MÀ
--   không có travel nào đang chạy → đẩy lên đến khi > MinY.
--   Khi travel hoạt động → loop này bỏ qua hoàn toàn (travel tự xử lý).
--   Ngăn hoàn toàn việc "rớt xuống biển" trong khoảng trống recovery/tick.
-- ══════════════════════════════════════════════════════════════════
task.spawn(function()
    while SessionAlive() and task.wait(0.1) do
        pcall(function()
            if not IsAlive() then return end
            if _G.State.IsTraveling then return end
            local root = HRP()
            if not root then return end
            if root.Position.Y < _G.Settings.MinY
                and not IsSubmergedPosition(root.Position) then
                root.AssemblyLinearVelocity = Vector3.new(
                    root.AssemblyLinearVelocity.X, 45, root.AssemblyLinearVelocity.Z)
            end
        end)
    end
end)
-- ══════════════════════════════════════════════════════════════════
--         [D-1] DODGE CONTROLLER — NÉ CHIÊU KHI QUÁI TẤN CÔNG
--   Một monitor loop DUY NHẤT, chỉ DÒ chiêu (không điều khiển movement
--   liên tục nên không phá Single Movement Owner). Khi phát hiện quái
--   gần player đang tung chiêu (animation tấn công đang phát / tốc độ
--   lao nhanh về phía player) → dịch ngang 1 phát (CFrame offset) né,
--   rồi để TravelManager hover kéo về điểm farm như thường.
--   Có cooldown chống spam; không hoạt động khi bay xa (giver/island)
--   hay khi recovery/dead/respawn.
-- ══════════════════════════════════════════════════════════════════
local DodgeController = {
    LastDodge = 0,
}

local DODGE_ATTACK_KEYWORDS = {
    "attack","combo","kick","punch","slash","swing","hit",
    "strike","beat","smash","bite","claw","fist","spin","haki",
}

local function DodgeAnimIsAttack(track)
    local ok, name = pcall(function() return track.Name end)
    if not ok or type(name) ~= "string" then return false end
    local lower = string.lower(name)
    for _, kw in ipairs(DODGE_ATTACK_KEYWORDS) do
        if string.find(lower, kw, 1, true) then return true end
    end
    return false
end

local function DodgeEnemyIsAttacking(enemy, me)
    local hum = enemy:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local okTracks, tracks = pcall(function() return hum:GetPlayingAnimationTracks() end)
    if okTracks and tracks then
        for _, track in ipairs(tracks) do
            if track.IsPlaying and DodgeAnimIsAttack(track) then
                return true
            end
        end
    end
    local root = enemy:FindFirstChild("HumanoidRootPart")
    if root and me then
        local okVel, vel = pcall(function() return root.AssemblyLinearVelocity end)
        if okVel and type(vel) == "Vector3" then
            local toMe = me.Position - root.Position
            local dist = toMe.Magnitude
            if dist > 0.5 and dist <= (_G.Settings.DodgeRadius or 15) then
                local closing = toMe.Unit:Dot(vel)
                if closing > 35 then return true end
            end
        end
    end
    return false
end

function DodgeController:TryDodge()
    if not _G.Settings.DodgeAttacks then return false end
    if not IsAlive() then return false end
    if _G.State.Mode == "Recovering" or _G.State.Mode == "Dead"
        or _G.State.Mode == "Respawning" or _G.State.Mode == "ServerHop" then
        return false
    end
    local now = tick()
    if now - self.LastDodge < (_G.Settings.DodgeCooldown or 1.5) then return false end
    -- Không né khi đang bay xa tới giver/island (target là CFrame xa):
    -- dodge chỉ dành cho lúc đứng farm gần mob (target Instance/CFrame gần).
    if _G.State.IsTraveling then
        local ref = TravelManager.TargetRef
        if typeof(ref) == "CFrame" or typeof(ref) == "Vector3" then
            local me = HRP()
            local targetPos = typeof(ref) == "CFrame" and ref.Position or ref
            if not me or (me.Position - targetPos).Magnitude > 60 then
                return false
            end
        end
    end
    local me = HRP()
    if not me then return false end
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return false end
    local danger = nil
    local dangerRoot = nil
    for _, enemy in ipairs(folder:GetChildren()) do
        -- Hard boundary: never classify another player's character as a
        -- dodge source, even if a future game update reparents it here.
        if Players:GetPlayerFromCharacter(enemy) then continue end
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local p = root.Position
        if IsValidPos(p) and (p - me.Position).Magnitude <= (_G.Settings.DodgeRadius or 15)
            and DodgeEnemyIsAttacking(enemy, me) then
            danger, dangerRoot = enemy, root
            break
        end
    end
    if not danger or not dangerRoot then return false end
    -- Né: dịch ngang vuông góc với hướng quái → player + nhấc nhẹ lên,
    -- giữ rotation; hover của TravelManager sẽ kéo về điểm farm sau đó.
    local dir = (dangerRoot.Position - me.Position).Unit
    local side = Vector3.new(-dir.Z, 0, dir.X)
    local dodgeOffset = side * (_G.Settings.DodgeDistance or 12)
        + Vector3.new(0, _G.Settings.DodgeHeight or 4, 0)
    if not TravelManager:ApplyDodgeOffset(dodgeOffset, 0.25) then return false end
    self.LastDodge = now
    DLog("DODGE", "Né chiêu " .. tostring(danger.Name))
    -- Do not overwrite the current job/status; this is only a one-shot offset.
    return true
end

-- [D-1] Monitor loop duy nhất cho dodge (0.1s — phản xạ nhanh hơn farm
-- tick). Chỉ dò + dịch 1 phát, không điều khiển movement liên tục.
task.spawn(function()
    while SessionAlive() and task.wait(0.1) do
        pcall(function() DodgeController:TryDodge() end)
    end
end)
-- ══════════════════════════════════════════════════════════════════
--         RECOVERY MANAGER v7 (Fix #2,#6)
--   State machine: STOP → CLEANUP → RESET → WAIT → CHECK → IDLE
--   KHÔNG tạo movement coroutine trong recovery
--   Sau recovery → Idle → Main Controller tự resume
--   Nếu character không xuất hiện → reset sạch, không kẹt vĩnh viễn
-- ══════════════════════════════════════════════════════════════════
local RecoveryManager = {}


function RecoveryManager:Handle(reason)
    if _G.State.Mode == "Recovering" then return end
    _G.State:SetMode("Recovering")
    _G.BobonStatus = "Recovery: " .. reason
    DLog("RECOVERY", "Handle: " .. reason)


    -- STEP 1: Stop all movement immediately
    TravelManager:Stop("Recovery")
    FarmPositionController:ReleaseCluster()


    -- STEP 2: Force release any active action token
    _G.State:ForceReleaseAction("Recovery:" .. reason)


    task.spawn(function()
        -- [FIX-P10] xpcall toàn bộ → dù lỗi vẫn guaranteed reset về Idle.
        -- Không bao giờ kẹt ở Mode=Recovering (nguyên nhân "đứng yên giữa biển")
        local success, noChar = xpcall(function()
            -- STEP 3: Wait for stability
            task.wait(_G.Settings.RecoveryDelay)


            -- STEP 4: Check character alive với timeout
            local retries = 0
            while not IsAlive() and retries < 15 do
                task.wait(1)
                retries = retries + 1
            end


            -- Nếu character không xuất hiện sau timeout → báo fail, vẫn reset
            if not IsAlive() then
                _G.BobonStatus = "Recovery: Failed - no character"
                _G.State.ConsecutiveFails = _G.State.ConsecutiveFails + 1
                return true
            end


            -- STEP 5: Reset HRP velocity chống residual momentum
            -- [G-3] Dùng Assembly* thay Velocity/RotVelocity đã deprecated.
            pcall(function()
                local hrp = HRP()
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
            return false
        end, debug.traceback)
        if not success then
            warn("[BobonHub] Module Error: RecoveryManager: " .. tostring(noChar))
            noChar = nil
        end


        -- STEP 6: Full state reset (GUARANTEED)
        _G.State:ClearTargets()
        _G.State.MovementOwner = nil
        _G.State.IsTraveling = false
        _G.State.IsRecovering = false
        _G.State:ForceReleaseAction("RecoveryComplete")
        if not noChar then
            _G.State.ConsecutiveFails = 0
        end
        _G.State.Sea = GetSea()


        -- STEP 7: Return to Idle — Main Controller tự resume
        _G.BobonStatus = "Recovery: Complete"
        _G.State:SetMode("Idle")
    end)
end


-- [A-7] FARMWATCHDOG — watchdog DUY NHẤT cho recovery + farm
-- Light fix TRƯỚC (travel không tiến → Stop + để main loop retry,
-- đếm lightFails), chỉ Recovery nặng khi light fix không giải quyết
-- được sau ≥3 lần. Không trigger khi Dead/Respawning (respawn tự xử lý).
task.spawn(function()
    local lightFails = 0
    while SessionAlive() and task.wait(5) do
        pcall(function()
            -- Trigger recovery nặng từ TravelManager (stuck/timeout/crash)
            if _G.State.IsRecovering
                and _G.State.Mode ~= "Recovering"
                and _G.State.Mode ~= "Dead"
                and _G.State.Mode ~= "Respawning" then
                RecoveryManager:Handle("StuckOrTimeout")
                return
            end
            -- Chỉ watchdog light khi đang Farm + còn sống
            if _G.State.Mode ~= "Farming" then return end
            if not IsAlive() then return end
            -- v18.1: PvP/NPC hits, knockback, Stun/Busy and screen-side combat
            -- effects are transient. Never Stop/Recover because of them; the
            -- active movement/action continues and naturally resumes.
            if HasRecentExternalInterference() then
                lightFails = 0
                _G.State.LastMoveTime = os.time()
                return
            end
            -- LIGHT 1: travel đang chạy nhưng không tiến → Stop, để main
            -- loop request lại (không recovery nặng ngay)
            if _G.State.IsTraveling and _G.State.MovementOwner then
                if os.time() - _G.State.LastMoveTime > _G.Settings.WatchdogStuckThreshold then
                    lightFails = lightFails + 1
                    DLog("RECOVERY", "Travel stalled (" .. lightFails .. " times) → stop + retry")
                    _G.BobonStatus = "Watchdog: Travel stalled, retrying"
                    TravelManager:Stop("WatchdogStuck")
                    if lightFails >= 3 then
                        lightFails = 0
                        RecoveryManager:Handle("WatchdogStuck")
                    end
                end
            end
            -- LIGHT 2: verify one shared melee/sword/gun controller. Never
            -- steal an equipped sword by running a separate melee watchdog.
            if EquipCombatTool() then
                DLog("RECOVERY", "Light fix: combat tool verified")
            end
            -- LIGHT 3: target chết/mất → main loop tự clear + chọn mới
            -- (không cần làm gì thêm ở đây, tránh duplicate logic)
        end)
    end
end)


-- ══════════════════════════════════════════════════════════════════
--          QUEST DATABASE v18 (SEA 1/2/3 COORDINATES)
-- ══════════════════════════════════════════════════════════════════
local MAX_LEVEL = 2800
local QDB = {
    {Min=1,Max=9,Q="BanditQuest1",M="Bandit",QL=1,QC=CFrame.new(1059.37,15.45,1550.42),MC=CFrame.new(1045.96,27.00,1560.82)},
    {Min=10,Max=14,Q="JungleQuest",M="Monkey",QL=1,QC=CFrame.new(-1598.09,35.55,153.38),MC=CFrame.new(-1448.52,67.85,11.47)},
    {Min=15,Max=29,Q="JungleQuest",M="Gorilla",QL=2,QC=CFrame.new(-1598.09,35.55,153.38),MC=CFrame.new(-1129.88,40.46,-525.42)},
    {Min=30,Max=39,Q="BuggyQuest1",M="Pirate",QL=1,QC=CFrame.new(-1141.07,4.10,3831.55),MC=CFrame.new(-1103.51,13.75,3896.09)},
    {Min=40,Max=59,Q="BuggyQuest1",M="Brute",QL=2,QC=CFrame.new(-1141.07,4.10,3831.55),MC=CFrame.new(-1140.08,14.81,4322.92)},
    {Min=60,Max=74,Q="DesertQuest",M="Desert Bandit",QL=1,QC=CFrame.new(894.49,5.14,4392.43),MC=CFrame.new(924.80,6.45,4481.59)},
    {Min=75,Max=89,Q="DesertQuest",M="Desert Officer",QL=2,QC=CFrame.new(894.49,5.14,4392.43),MC=CFrame.new(1608.28,8.61,4371.01)},
    {Min=90,Max=99,Q="SnowQuest",M="Snow Bandit",QL=1,QC=CFrame.new(1389.74,88.15,-1298.91),MC=CFrame.new(1354.35,87.27,-1393.95)},
    {Min=100,Max=119,Q="SnowQuest",M="Snowman",QL=2,QC=CFrame.new(1389.74,88.15,-1298.91),MC=CFrame.new(1201.64,144.58,-1550.07)},
    {Min=120,Max=149,Q="MarineQuest2",M="Chief Petty Officer",QL=1,QC=CFrame.new(-5039.59,27.35,4324.68),MC=CFrame.new(-4881.23,22.65,4273.75)},
    {Min=150,Max=174,Q="SkyQuest",M="Sky Bandit",QL=1,QC=CFrame.new(-4839.53,716.37,-2619.44),MC=CFrame.new(-4953.21,295.74,-2899.23)},
    {Min=175,Max=189,Q="SkyQuest",M="Dark Master",QL=2,QC=CFrame.new(-4839.53,716.37,-2619.44),MC=CFrame.new(-5259.84,391.40,-2229.04)},
    {Min=190,Max=209,Q="PrisonerQuest",M="Prisoner",QL=1,QC=CFrame.new(5308.93,1.66,475.12),MC=CFrame.new(5098.97,-0.32,474.24)},
    {Min=210,Max=249,Q="PrisonerQuest",M="Dangerous Prisoner",QL=2,QC=CFrame.new(5308.93,1.66,475.12),MC=CFrame.new(5654.56,15.63,866.30)},
    {Min=250,Max=274,Q="ColosseumQuest",M="Toga Warrior",QL=1,QC=CFrame.new(-1580.05,6.35,-2986.48),MC=CFrame.new(-1820.21,51.68,-2740.67)},
    {Min=275,Max=299,Q="ColosseumQuest",M="Gladiator",QL=2,QC=CFrame.new(-1580.05,6.35,-2986.48),MC=CFrame.new(-1292.84,56.38,-3339.03)},
    {Min=300,Max=324,Q="MagmaQuest",M="Military Soldier",QL=1,QC=CFrame.new(-5313.37,10.95,8515.29),MC=CFrame.new(-5411.16,11.08,8454.29)},
    {Min=325,Max=374,Q="MagmaQuest",M="Military Spy",QL=2,QC=CFrame.new(-5313.37,10.95,8515.29),MC=CFrame.new(-5802.87,86.26,8828.86)},
    {Min=375,Max=399,Q="FishmanQuest",M="Fishman Warrior",QL=1,QC=CFrame.new(61122.65,18.50,1569.40),MC=CFrame.new(60878.30,18.48,1543.76)},
    {Min=400,Max=449,Q="FishmanQuest",M="Fishman Commando",QL=2,QC=CFrame.new(61122.65,18.50,1569.40),MC=CFrame.new(61922.63,18.48,1493.93)},
    {Min=450,Max=474,Q="SkyExp1Quest",M="God's Guard",QL=1,QC=CFrame.new(-4721.89,843.87,-1949.97),MC=CFrame.new(-4710.04,845.28,-1927.31)},
    {Min=475,Max=524,Q="SkyExp1Quest",M="Shanda",QL=2,QC=CFrame.new(-7859.10,5544.19,-381.48),MC=CFrame.new(-7678.49,5566.40,-497.22)},
    {Min=525,Max=549,Q="SkyExp2Quest",M="Royal Squad",QL=1,QC=CFrame.new(-7906.82,5634.66,-1411.99),MC=CFrame.new(-7624.25,5658.13,-1467.35)},
    {Min=550,Max=624,Q="SkyExp2Quest",M="Royal Soldier",QL=2,QC=CFrame.new(-7906.82,5634.66,-1411.99),MC=CFrame.new(-7836.75,5645.66,-1790.62)},
    {Min=625,Max=649,Q="FountainQuest",M="Galley Pirate",QL=1,QC=CFrame.new(5259.82,37.35,4050.03),MC=CFrame.new(5551.02,78.90,3930.41)},
    {Min=650,Max=699,Q="FountainQuest",M="Galley Captain",QL=2,QC=CFrame.new(5259.82,37.35,4050.03),MC=CFrame.new(5441.95,42.50,4950.09)},

    {Min=700,Max=724,Q="Area1Quest",M="Raider",QL=1,QC=CFrame.new(-429.54,71.77,1836.18),MC=CFrame.new(-728.33,52.78,2345.77)},
    {Min=725,Max=774,Q="Area1Quest",M="Mercenary",QL=2,QC=CFrame.new(-429.54,71.77,1836.18),MC=CFrame.new(-1004.32,80.16,1424.62)},
    {Min=775,Max=799,Q="Area2Quest",M="Swan Pirate",QL=1,QC=CFrame.new(638.44,71.77,918.28),MC=CFrame.new(1068.66,137.61,1322.11)},
    {Min=800,Max=874,Q="Area2Quest",M="Factory Staff",QL=2,QC=CFrame.new(632.70,73.11,918.67),MC=CFrame.new(73.08,81.86,-27.47)},
    {Min=875,Max=899,Q="MarineQuest3",M="Marine Lieutenant",QL=1,QC=CFrame.new(-2440.80,71.71,-3216.07),MC=CFrame.new(-2821.37,75.90,-3070.09)},
    {Min=900,Max=949,Q="MarineQuest3",M="Marine Captain",QL=2,QC=CFrame.new(-2440.80,71.71,-3216.07),MC=CFrame.new(-1861.23,80.18,-3254.70)},
    {Min=950,Max=974,Q="ZombieQuest",M="Zombie",QL=1,QC=CFrame.new(-5497.06,47.59,-795.24),MC=CFrame.new(-5657.78,78.97,-928.69)},
    {Min=975,Max=999,Q="ZombieQuest",M="Vampire",QL=2,QC=CFrame.new(-5497.06,47.59,-795.24),MC=CFrame.new(-6037.67,32.18,-1340.66)},
    {Min=1000,Max=1049,Q="SnowMountainQuest",M="Snow Trooper",QL=1,QC=CFrame.new(609.86,400.12,-5372.26),MC=CFrame.new(549.15,427.39,-5563.70)},
    {Min=1050,Max=1099,Q="SnowMountainQuest",M="Winter Warrior",QL=2,QC=CFrame.new(609.86,400.12,-5372.26),MC=CFrame.new(1142.75,475.64,-5199.42)},
    {Min=1100,Max=1124,Q="IceSideQuest",M="Lab Subordinate",QL=1,QC=CFrame.new(-6064.07,15.24,-4902.98),MC=CFrame.new(-5707.47,15.95,-4513.39)},
    {Min=1125,Max=1174,Q="IceSideQuest",M="Horned Warrior",QL=2,QC=CFrame.new(-6064.07,15.24,-4902.98),MC=CFrame.new(-6341.37,15.95,-5723.16)},
    {Min=1175,Max=1199,Q="FireSideQuest",M="Magma Ninja",QL=1,QC=CFrame.new(-5428.03,15.06,-5299.43),MC=CFrame.new(-5449.67,76.66,-5808.20)},
    {Min=1200,Max=1249,Q="FireSideQuest",M="Lava Pirate",QL=2,QC=CFrame.new(-5428.03,15.06,-5299.43),MC=CFrame.new(-5213.33,49.74,-4701.45)},
    {Min=1250,Max=1274,Q="ShipQuest1",M="Ship Deckhand",QL=1,QC=CFrame.new(1037.80,125.09,32911.60),MC=CFrame.new(1212.01,150.79,33059.25)},
    {Min=1275,Max=1299,Q="ShipQuest1",M="Ship Engineer",QL=2,QC=CFrame.new(1037.80,125.09,32911.60),MC=CFrame.new(919.48,43.54,32779.97)},
    {Min=1300,Max=1324,Q="ShipQuest2",M="Ship Steward",QL=1,QC=CFrame.new(968.81,125.09,33244.13),MC=CFrame.new(919.44,129.56,33436.04)},
    {Min=1325,Max=1349,Q="ShipQuest2",M="Ship Officer",QL=2,QC=CFrame.new(968.81,125.09,33244.13),MC=CFrame.new(1036.02,181.44,33315.73)},
    {Min=1350,Max=1374,Q="FrostQuest",M="Arctic Warrior",QL=1,QC=CFrame.new(5667.66,26.80,-6486.09),MC=CFrame.new(5966.25,62.97,-6179.38)},
    {Min=1375,Max=1424,Q="FrostQuest",M="Snow Lurker",QL=2,QC=CFrame.new(5667.66,26.80,-6486.09),MC=CFrame.new(5407.07,69.19,-6880.88)},
    {Min=1425,Max=1449,Q="ForgottenQuest",M="Sea Soldier",QL=1,QC=CFrame.new(-3054.44,235.54,-10142.82),MC=CFrame.new(-3028.22,64.67,-9775.43)},
    {Min=1450,Max=1499,Q="ForgottenQuest",M="Water Fighter",QL=2,QC=CFrame.new(-3054.44,235.54,-10142.82),MC=CFrame.new(-3352.90,285.02,-10534.84)},

    {Min=1500,Max=1524,Q="PiratePortQuest",M="Pirate Millionaire",QL=1,QC=CFrame.new(-450.10,107.68,5950.73),MC=CFrame.new(-246.00,47.31,5584.10)},
    {Min=1525,Max=1574,Q="PiratePortQuest",M="Pistol Billionaire",QL=2,QC=CFrame.new(-450.10,107.68,5950.73),MC=CFrame.new(-54.81,83.77,5947.84)},
    {Min=1575,Max=1599,Q="DragonCrewQuest",M="Dragon Crew Warrior",QL=1,QC=CFrame.new(6750.49,127.45,-711.03),MC=CFrame.new(6709.76,52.34,-1139.03)},
    {Min=1600,Max=1624,Q="DragonCrewQuest",M="Dragon Crew Archer",QL=2,QC=CFrame.new(6750.49,127.45,-711.03),MC=CFrame.new(6668.76,481.38,329.12)},
    {Min=1625,Max=1649,Q="VenomCrewQuest",M="Hydra Enforcer",QL=1,QC=CFrame.new(5206.40,1004.10,748.35),MC=CFrame.new(4547.12,1003.10,334.19)},
    {Min=1650,Max=1699,Q="VenomCrewQuest",M="Venomous Assailant",QL=2,QC=CFrame.new(5206.40,1004.10,748.35),MC=CFrame.new(4674.93,1134.83,996.31)},
    {Min=1700,Max=1724,Q="MarineTreeIsland",M="Marine Commodore",QL=1,QC=CFrame.new(2481.09,74.27,-6779.64),MC=CFrame.new(2577.25,75.61,-7739.87)},
    {Min=1725,Max=1774,Q="MarineTreeIsland",M="Marine Rear Admiral",QL=2,QC=CFrame.new(2481.09,74.27,-6779.64),MC=CFrame.new(3761.81,123.91,-6823.52)},
    {Min=1775,Max=1799,Q="DeepForestIsland3",M="Fishman Raider",QL=1,QC=CFrame.new(-10581.66,330.87,-8761.19),MC=CFrame.new(-10407.53,331.76,-8368.52)},
    {Min=1800,Max=1824,Q="DeepForestIsland3",M="Fishman Captain",QL=2,QC=CFrame.new(-10581.66,330.87,-8761.19),MC=CFrame.new(-10994.70,352.38,-9002.11)},
    {Min=1825,Max=1849,Q="DeepForestIsland",M="Forest Pirate",QL=1,QC=CFrame.new(-13234.04,331.49,-7625.40),MC=CFrame.new(-13274.48,332.38,-7769.58)},
    {Min=1850,Max=1899,Q="DeepForestIsland",M="Mythological Pirate",QL=2,QC=CFrame.new(-13234.04,331.49,-7625.40),MC=CFrame.new(-13680.61,501.08,-6991.19)},
    {Min=1900,Max=1924,Q="DeepForestIsland2",M="Jungle Pirate",QL=1,QC=CFrame.new(-12680.38,389.97,-9902.02),MC=CFrame.new(-12256.16,331.74,-10485.84)},
    {Min=1925,Max=1974,Q="DeepForestIsland2",M="Musketeer Pirate",QL=2,QC=CFrame.new(-12680.38,389.97,-9902.02),MC=CFrame.new(-13457.90,391.55,-9859.18)},
    {Min=1975,Max=1999,Q="HauntedQuest1",M="Reborn Skeleton",QL=1,QC=CFrame.new(-9479.22,141.22,5566.09),MC=CFrame.new(-8763.72,165.72,6159.86)},
    {Min=2000,Max=2024,Q="HauntedQuest1",M="Living Zombie",QL=2,QC=CFrame.new(-9479.22,141.22,5566.09),MC=CFrame.new(-10144.13,138.63,5838.09)},
    {Min=2025,Max=2049,Q="HauntedQuest2",M="Demonic Soul",QL=1,QC=CFrame.new(-9516.99,172.02,6078.47),MC=CFrame.new(-9505.87,172.10,6158.99)},
    -- The in-game typo is intentionally `Posessed Mummy` (one s).
    {Min=2050,Max=2074,Q="HauntedQuest2",M="Posessed Mummy",QL=2,QC=CFrame.new(-9516.99,172.02,6078.47),MC=CFrame.new(-9582.02,6.25,6205.48)},
    {Min=2075,Max=2099,Q="NutsIslandQuest",M="Peanut Scout",QL=1,QC=CFrame.new(-2104.39,38.10,-10194.22),MC=CFrame.new(-2143.24,47.72,-10029.99)},
    {Min=2100,Max=2124,Q="NutsIslandQuest",M="Peanut President",QL=2,QC=CFrame.new(-2104.39,38.10,-10194.22),MC=CFrame.new(-1859.35,38.10,-10422.43)},
    {Min=2125,Max=2149,Q="IceCreamIslandQuest",M="Ice Cream Chef",QL=1,QC=CFrame.new(-820.65,65.82,-10965.80),MC=CFrame.new(-872.25,65.82,-10919.96)},
    {Min=2150,Max=2199,Q="IceCreamIslandQuest",M="Ice Cream Commander",QL=2,QC=CFrame.new(-820.65,65.82,-10965.80),MC=CFrame.new(-558.06,112.05,-11290.77)},
    {Min=2200,Max=2224,Q="CakeQuest1",M="Cookie Crafter",QL=1,QC=CFrame.new(-2021.32,37.80,-12028.73),MC=CFrame.new(-2374.14,37.80,-12125.31)},
    {Min=2225,Max=2249,Q="CakeQuest1",M="Cake Guard",QL=2,QC=CFrame.new(-2021.32,37.80,-12028.73),MC=CFrame.new(-1598.31,43.77,-12244.58)},
    {Min=2250,Max=2274,Q="CakeQuest2",M="Baking Staff",QL=1,QC=CFrame.new(-1927.92,37.80,-12842.54),MC=CFrame.new(-1887.81,77.62,-12998.35)},
    {Min=2275,Max=2299,Q="CakeQuest2",M="Head Baker",QL=2,QC=CFrame.new(-1927.92,37.80,-12842.54),MC=CFrame.new(-2216.19,82.88,-12869.29)},
    {Min=2300,Max=2324,Q="ChocQuest1",M="Cocoa Warrior",QL=1,QC=CFrame.new(233.23,29.88,-12201.23),MC=CFrame.new(-21.55,80.57,-12352.39)},
    {Min=2325,Max=2349,Q="ChocQuest1",M="Chocolate Bar Battler",QL=2,QC=CFrame.new(233.23,29.88,-12201.23),MC=CFrame.new(582.59,77.19,-12463.16)},
    {Min=2350,Max=2374,Q="ChocQuest2",M="Sweet Thief",QL=1,QC=CFrame.new(150.51,30.69,-12774.50),MC=CFrame.new(165.19,76.06,-12600.84)},
    {Min=2375,Max=2399,Q="ChocQuest2",M="Candy Rebel",QL=2,QC=CFrame.new(150.51,30.69,-12774.50),MC=CFrame.new(134.87,77.25,-12876.55)},
    {Min=2400,Max=2424,Q="CandyQuest1",M="Candy Pirate",QL=1,QC=CFrame.new(-1150.04,20.38,-14446.33),MC=CFrame.new(-1310.50,26.02,-14562.40)},
    {Min=2425,Max=2449,Q="CandyQuest1",M="Snow Demon",QL=2,QC=CFrame.new(-1150.04,20.38,-14446.33),MC=CFrame.new(-880.20,71.25,-14538.61)},
    {Min=2450,Max=2474,Q="TikiQuest1",M="Isle Outlaw",QL=1,QC=CFrame.new(-16547.75,61.14,-173.41),MC=CFrame.new(-16442.81,116.14,-264.46)},
    {Min=2475,Max=2499,Q="TikiQuest1",M="Island Boy",QL=2,QC=CFrame.new(-16547.75,61.14,-173.41),MC=CFrame.new(-16901.26,84.07,-192.89)},
    {Min=2500,Max=2524,Q="TikiQuest2",M="Sun-kissed Warrior",QL=1,QC=CFrame.new(-16539.078,55.686,1051.574),MC=CFrame.new(-16321.292,92.102,1111.195)},
    {Min=2525,Max=2549,Q="TikiQuest2",M="Isle Champion",QL=2,QC=CFrame.new(-16539.08,55.69,1051.57),MC=CFrame.new(-16641.68,235.78,1031.28)},
    {Min=2550,Max=2574,Q="TikiQuest3",M="Serpent Hunter",QL=1,QC=CFrame.new(-16665.19,104.60,1579.69),MC=CFrame.new(-16521.06,106.09,1488.78)},
    {Min=2575,Max=2599,Q="TikiQuest3",M="Skull Slayer",QL=2,QC=CFrame.new(-16665.19,104.60,1579.69),MC=CFrame.new(-16855.04,122.46,1478.15)},
    -- Update 27.0+ Submerged Island (tọa độ âm là chủ ý, không clamp lên mặt biển).
    {Min=2600,Max=2624,Q="SubmergedQuest1",M="Reef Bandit",QL=1,QC=CFrame.new(10778.875,-2087.724,9265.184),MC=CFrame.new(11019.132,-2146.068,9342.392)},
    {Min=2625,Max=2649,Q="SubmergedQuest1",M="Coral Pirate",QL=2,QC=CFrame.new(10778.875,-2087.724,9265.184),MC=CFrame.new(10808.601,-2030.361,9364.233)},
    {Min=2650,Max=2674,Q="SubmergedQuest2",M="Sea Chanter",QL=1,QC=CFrame.new(10880.686,-2086.200,10032.624),MC=CFrame.new(10671.272,-2057.592,10047.258)},
    {Min=2675,Max=2699,Q="SubmergedQuest2",M="Ocean Prophet",QL=2,QC=CFrame.new(10880.686,-2086.200,10032.624),MC=CFrame.new(11008.520,-2007.728,10223.079)},
    {Min=2700,Max=2724,Q="SubmergedQuest3",M="High Disciple",QL=1,QC=CFrame.new(9640.088,-1992.445,9613.652),MC=CFrame.new(9750.416,-1966.939,9753.360)},
    {Min=2725,Max=2800,Q="SubmergedQuest3",M="Grand Devotee",QL=2,QC=CFrame.new(9640.088,-1992.445,9613.652),MC=CFrame.new(9611.705,-1993.471,9882.688)},
}

-- Resolve an already-open quest after re-execution. Prefer an exact canonical
-- enemy name found in the source quest text; if Roblox only exposes translated
-- text, the main controller safely falls back to the current level's QDB entry.
local function ResolveQuestMobFromText()
    local text = GetQuestText()
    if not text then return nil end
    local lowerText = string.lower(text)
    local bestMatch = nil
    for _, entry in ipairs(QDB) do
        if string.find(lowerText, string.lower(entry.M), 1, true) then
            -- Prefer the longest match so `Galley Pirate` is not mistaken for
            -- the earlier generic `Pirate` entry (same for Bandit/Snow Bandit).
            if not bestMatch or #entry.M > #bestMatch then
                bestMatch = entry.M
            end
        end
    end
    return bestMatch
end

local SubmergedAccessController = {
    Confirmed = false,
    PendingUntil = 0,
    NextTry = 0,
    Failures = 0,
    LastResult = "idle",
}

function SubmergedAccessController:IsInside()
    local root = HRP()
    local inside = GetSea() == 3 and root
        and IsSubmergedPosition(root.Position) or false
    if inside then
        self.Confirmed = true
        self.PendingUntil = 0
        self.NextTry = 0
        self.Failures = 0
        self.LastResult = "inside"
    end
    return inside == true
end

function SubmergedAccessController:Fail(reason, now)
    self.PendingUntil = 0
    self.Failures = self.Failures + 1
    self.NextTry = now
        + math.min(15 * (2 ^ math.min(self.Failures - 1, 3)), 120)
    self.LastResult = reason
    _G.BobonStatus = "Sea: Submerged unavailable - farming Tiki"
    return "fallback"
end

function SubmergedAccessController:Tick(canAttempt)
    if GetSea() ~= 3 or Level() < 2600 then return "not-needed" end
    if self:IsInside() then return "inside" end
    local now = tick()
    if self.PendingUntil > 0 then
        if now < self.PendingUntil then return "pending" end
        return self:Fail("not-entered", now)
    end
    if not canAttempt or now < self.NextTry then return "fallback" end
    local net = ResolveNet()
    local speak = net and net:FindFirstChild("RF/SubmarineWorkerSpeak")
    if not speak or not speak:IsA("RemoteFunction") then
        return self:Fail("remote-missing", now)
    end
    local ok, result = pcall(function()
        return speak:InvokeServer("TravelToSubmergedIsland")
    end)
    if not ok then
        return self:Fail("invoke-error", now)
    end
    if self:IsInside() then return "inside" end
    self.PendingUntil = now + 4
    self.LastResult = "pending:" .. tostring(result)
    return "pending"
end

local TikiFallbackQuest = nil
for _, entry in ipairs(QDB) do
    if entry.M == "Skull Slayer" then
        TikiFallbackQuest = entry
        break
    end
end

local function GetQ()
    local lv = Level()
    local sea = GetSea()
    -- 2800 is already max; do not keep accepting Grand Devotee forever.
    if lv >= MAX_LEVEL then return nil end
    -- At a sea boundary the normal level table already points into the next
    -- world. Prove combat on the highest valid local quest before starting a
    -- mandatory boss/progression action; this avoids using a boss as a lethal
    -- first-click probe.
    if not CombatController:IsDamageReady() then
        local bootstrapMob = sea == 1 and lv >= 700 and "Galley Captain"
            or (sea == 2 and lv >= 1500 and "Water Fighter")
        if bootstrapMob then
            for _, entry in ipairs(QDB) do
                if entry.M == bootstrapMob then return entry end
            end
        end
    end
    -- Access is gated by Tyrant/Tiki progression. Until the entrance really
    -- moves the character underwater, keep farming a valid Tiki quest instead
    -- of flying blindly toward negative-Y coordinates.
    if GetSea() == 3 and lv >= 2600 and not SubmergedAccessController:IsInside() then
        return TikiFallbackQuest
    end
    for _, q in ipairs(QDB) do
        if lv >= q.Min and lv <= q.Max then return q end
    end
    return nil
end


-- Sea 1 fast-route controller.  This is deliberately called from the main
-- controller instead of creating another movement loop.  The route follows
-- the commonly used skip path: Fountain/Galley early, then live bosses, then
-- Upper Sky/Galley before the normal Sea 2 progression gate at level 700.
-- A live instance is always preferred; fallback coordinates only keep the
-- player over a safe island while a boss or mob is respawning.
local SkipRouteController = {
    Enabled = true,
    CurrentKey = nil,
    -- [D-4] Theo dõi hiệu quả của route: level tại lúc chọn route + thời
    -- điểm bắt đầu. Level không tăng trong SkipRouteFallbackTimeout giây
    -- → coi skip không hiệu quả → tắt hẳn, farm quest bình thường.
    RouteStartTime = nil,
    RouteStartLevel = nil,
}

local SkipRouteDB = {
    -- Reconstructed from the supplied Teddy showcase video:
    -- Floor 1: Sky Bandit [Lv. 150] from player Lv10-50.
    -- Floor 2: God's Guard [Lv. 450] from player Lv51-70.
    {Key="TeddyFloor1", Min=10, Max=50, Kind="Mob", Display="Sky Bandit [Lv. 150]", Names={"Sky Bandit"}, Fallback=CFrame.new(-4953.21,295.74,-2899.23)},
    {Key="TeddyFloor2", Min=51, Max=70, Kind="Mob", Display="God's Guard [Lv. 450]", Names={"God's Guard"}, Fallback=CFrame.new(-4710.04,845.28,-1927.31)},
}

function SkipRouteController:GetRoute()
    if not self.Enabled or _G.Settings.SkipLevelRoute == false or GetSea() ~= 1 then return nil end
    local lv = Level()
    for _, route in ipairs(SkipRouteDB) do
        if lv >= route.Min and lv <= route.Max then return route end
    end
    return nil
end

function SkipRouteController:Reset(reason)
    if self.CurrentKey then
        DLog("SKIP", "Route ended: " .. tostring(self.CurrentKey) .. " (" .. tostring(reason or "reset") .. ")")
        if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
            TravelManager:Stop("SkipRouteReset")
        end
        FarmPositionController:ReleaseCluster()
        _G.State:ClearTargets()
        self.CurrentKey = nil
    end
end

function SkipRouteController:FindTarget(route)
    if route.Kind == "Mob" then
        for _, name in ipairs(route.Names) do
            local mob = FindNearestMob(name)
            if mob then return mob, name end
        end
    else
        for _, name in ipairs(route.Names) do
            local boss = FindBoss(name)
            if boss then return boss, name end
        end
    end
    return nil, nil
end

function SkipRouteController:Run()
    -- Teddy-style early skip needs the verified fast backend; if damage cannot
    -- be proven, normal quest farming remains the fallback instead of stalling.
    if not CombatController:IsFastReady() then
        self:Reset("fast attack not health-verified")
        return false
    end
    local route = self:GetRoute()
    if not route then
        self:Reset("outside Teddy early-skip range")
        return false
    end

    if self.CurrentKey ~= route.Key then
        self:Reset("floor transition")
        self.CurrentKey = route.Key
        self.RouteStartTime = os.time()
        self.RouteStartLevel = Level()
        DLog("SKIP", "Teddy route selected: " .. route.Key)
    elseif Level() > (self.RouteStartLevel or 0) then
        -- Progress resets the watchdog without rebuilding the cluster anchor.
        self.RouteStartLevel = Level()
        self.RouteStartTime = os.time()
    end

    if self.RouteStartTime and os.time() - self.RouteStartTime
        > (_G.Settings.SkipRouteFallbackTimeout or 90) then
        self:Reset("skip made no level progress")
        DLog("SKIP", "Teddy skip stalled → normal quest fallback")
        return false
    end

    -- The showcase farms these floors without carrying the normal low-level
    -- quest. Abandon once when necessary; failure is harmless and the next
    -- main tick can still fall back to normal quest progression.
    if HasQuest() == true then
        pcall(function() CommF_:InvokeServer("AbandonQuest") end)
        _G.State.ActiveQuestMob = nil
    end

    _G.State:SetMode("Farming")
    _G.State.FState = "SKIP_FARM"
    _G.BobonStatus = "Level Farming | Skip Mode | "
        .. (route.Key == "TeddyFloor1" and "Floor 1" or "Floor 2")

    ClusterFarmController:Activate("SKIP", route.Names, route.Fallback, "Farm")
    ClusterFarmController:Tick()

    local hoverHeight = (CombatController:IsFastReady()
        or not CombatController:WantsClientRange())
        and (_G.Settings.FarmHeight or 15)
        or (_G.Settings.ClientHoverHeight or 5)
    local hoverCF = ClusterFarmController:GetHoverCFrame(hoverHeight)
    if hoverCF and _G.State:CanRequestTravel() then
        TravelManager:Request(hoverCF, "Farm", {
            arrivalThreshold = _G.Settings.FarmArrivalThreshold,
            fallback = route.Fallback,
            combatHover = true,
            persistent = true,
        })
    end

    local target = ClusterFarmController:SelectPrimary()
    if not target then
        -- While ownership is being acquired, keep the anchor stable. If the
        -- executor cannot own any NPC after the grace window, briefly chase the
        -- nearest skip mob to acquire ownership without destroying the anchor.
        if tick() - (_G.State.ClusterActivatedAt or 0)
            > (_G.Settings.ClusterAcquireGrace or 1.75) then
            local nearest, nearestName = self:FindTarget(route)
            if nearest and nearest:FindFirstChild("HumanoidRootPart") then
                _G.State.FarmTarget = nearest
                _G.State.CurrentTarget = nearest
                PrepareCombatTarget(nearest)
                if _G.State:CanRequestTravel() and (_G.State.ClusterLastMoved or 0) == 0 then
                    TravelManager:Request(nearest.HumanoidRootPart, "Farm", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        fallback = hoverCF or route.Fallback,
                        combatHover = true,
                    })
                end
            end
        end
        return true
    end

    _G.State.FarmTarget = target
    _G.State.CurrentTarget = target
    PrepareCombatTarget(target)
    local root = target:FindFirstChild("HumanoidRootPart")
    local me = HRP()
    if root and me then
        local flat = (Vector3.new(me.Position.X,0,me.Position.Z)
            - Vector3.new(root.Position.X,0,root.Position.Z)).Magnitude
        if flat <= _G.Settings.AttackRange
            and TravelManager:IsAtCombatAnchor() then
            EquipCombatTool()
            Attack(target, route.Names[1])
        end
    end
    return true
end


-- ══════════════════════════════════════════════════════════════════
--          FIGHTING STYLE PROGRESSION v17 — FARM-COOPERATIVE
--   Trains required styles through the normal quest farm by selecting exactly
--   one preferred combat tool. Purchase probes are throttled and own no movement.
-- ══════════════════════════════════════════════════════════════════
local FightingStyleController = {
    LastProbe = 0,
    LastStatus = "idle",
    SanguineKnownOwned = false,
}

local function InvokeStyle(remote, ...)
    local args = {...}
    local ok, result = pcall(function()
        return CommF_:InvokeServer(remote, table.unpack(args))
    end)
    return ok, result
end

function FightingStyleController:SetPreferred(name, reason)
    _G.State.PreferredCombatTool = name
    self.LastStatus = reason or name or "none"
    DLog("STYLE", "Preferred=" .. tostring(name) .. " | " .. tostring(self.LastStatus))
end

function FightingStyleController:Tick()
    if not _G.Settings.AutoFightingStyles or not _G.Settings.AutoBuyMelee or not IsAlive() then
        _G.State.PreferredCombatTool = nil
        return false
    end
    -- Never change equipment while a puzzle/boss/sea subsystem owns an action.
    if _G.State.ActiveActionToken ~= 0 then return false end
    if FindOwnedTool("Sanguine Art") then self.SanguineKnownOwned = true end

    local function aliasList(value)
        return type(value) == "table" and value or {value}
    end

    local function ownedAlias(value)
        for _, name in ipairs(aliasList(value)) do
            if FindOwnedTool(name) then return true, name end
        end
        return false, nil
    end

    local function aliasMastery(value)
        local best, bestName = 0, nil
        for _, name in ipairs(aliasList(value)) do
            local m = EffectiveMastery(name)
            if m > best or not bestName then best, bestName = m, name end
        end
        return best, bestName
    end

    local function train(value, target)
        local owned, liveName = ownedAlias(value)
        if not owned then return false end
        local mastery = aliasMastery(value)
        if mastery < target then
            self:SetPreferred(liveName, ("Mastery %s %d/%d"):format(liveName, mastery, target))
            return true
        end
        return false
    end

    -- Current public names are listed first; legacy/internal names remain aliases
    -- because some server builds/executors still expose the older Tool names.
    local phase1 = {
        {names={"Dark Step","Black Leg"}, target=300, remote="BuyBlackLeg"},
        {names={"Electric","Electro"}, target=300, remote="BuyElectro"},
        {names={"Water Kung Fu","Fishman Karate"}, target=300, remote="BuyFishmanKarate"},
        {names={"Dragon Breath","Dragon Claw"}, target=300, remote="DragonClaw"},
    }

    -- Phase 1: prerequisites for Superhuman.
    for _, row in ipairs(phase1) do
        if train(row.names, row.target) then return true end
        local owned = ownedAlias(row.names)
        if not owned and tick() - self.LastProbe >= 15 then
            self.LastProbe = tick()
            if row.remote == "DragonClaw" then
                if CanSpendFragments(1500) then
                    pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","1") end)
                    pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end)
                end
            else
                InvokeStyle(row.remote)
            end
            return false
        end
    end

    if not FindOwnedTool("Superhuman") and tick() - self.LastProbe >= 15 then
        self.LastProbe = tick()
        InvokeStyle("BuySuperhuman")
        return false
    end
    if train("Superhuman", 400) then return true end

    -- Phase 2: V2 styles required for Godhuman.
    local advanced = {
        {base={"Dark Step","Black Leg"}, baseM=400, baseRemote="BuyBlackLeg", name="Death Step", remote="BuyDeathStep"},
        {base={"Water Kung Fu","Fishman Karate"}, baseM=400, baseRemote="BuyFishmanKarate", name="Sharkman Karate", remote="BuySharkmanKarate"},
        {base={"Electric","Electro"}, baseM=400, baseRemote="BuyElectro", name="Electric Claw", remote="BuyElectricClaw"},
        {base={"Dragon Breath","Dragon Claw"}, baseM=400, baseRemote="DragonClaw", name="Dragon Talon", remote="BuyDragonTalon"},
    }
    for _, row in ipairs(advanced) do
        if not FindOwnedTool(row.name) then
            -- After Superhuman the four base styles are normally no longer live
            -- in Backpack. Re-equip an already purchased base style before asking
            -- normal quest farm to raise it from 300 -> 400.
            local baseMastery = aliasMastery(row.base)
            if baseMastery < row.baseM then
                if train(row.base, row.baseM) then return true end
                if tick() - self.LastProbe >= 15 then
                    self.LastProbe = tick()
                    if row.baseRemote == "DragonClaw" then
                        if CanSpendFragments(1500) then
                            pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","1") end)
                            pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end)
                        end
                    else
                        InvokeStyle(row.baseRemote)
                    end
                end
                return false
            end
            if tick() - self.LastProbe >= 15 and CanSpendFragments(5000) then
                self.LastProbe = tick()
                if row.name == "Sharkman Karate" then
                    InvokeStyle(row.remote, true)
                    InvokeStyle(row.remote)
                elseif row.name == "Electric Claw" then
                    local ok, state = InvokeStyle(row.remote, true)
                    if ok and state == 4 then InvokeStyle(row.remote, "Start") else InvokeStyle(row.remote) end
                else
                    InvokeStyle(row.remote)
                end
            end
            return false
        end
        if train(row.name, 400) then return true end
    end

    if not FindOwnedTool("Godhuman") then
        if tick() - self.LastProbe >= 20 and CanSpendFragments(5000) then
            self.LastProbe = tick()
            InvokeStyle("BuyGodhuman", true)
            InvokeStyle("BuyGodhuman")
        end
        return false
    end

    -- Godhuman is the stable default after the mastery chain is complete.
    self:SetPreferred("Godhuman", "Godhuman ready")

    -- Sanguine is an optional end-game purchase. The server validates Heart,
    -- materials, money and fragments; a failed probe changes no movement/state.
    if GetSea() == 3 and not self.SanguineKnownOwned and not FindOwnedTool("Sanguine Art")
        and Level() >= 2400 and tick() - self.LastProbe >= 30 and CanSpendFragments(5000) then
        self.LastProbe = tick()
        InvokeStyle("BuySanguineArt", true)
        InvokeStyle("BuySanguineArt")
    end
    -- Godhuman/Sanguine purchase probes do not need to monopolize the combat
    -- preference. Return false so sword mastery can train during normal farm.
    return false
end

-- ══════════════════════════════════════════════════════════════════
--   v18.8 SWORD PROGRESSION — BUY ALL + TRUE TRIPLE KATANA
--   Direct shop purchases are server-validated. Legendary dealer and TTK
--   remotes follow current public implementations; no fake inventory state.
-- ══════════════════════════════════════════════════════════════════
local SwordProgressionController = {
    LastShopProbe = 0,
    LastLegendaryProbe = 0,
    LastTTKProbe = 0,
    LastStatus = "idle",
}

local DirectBuySwords = {
    "Cutlass", "Katana", "Dual Katana", "Iron Mace", "Triple Katana",
    "Pipe", "Dual-Headed Blade", "Soul Cane", "Bisento",
}

local LegendarySwordAliases = {
    {"Saishi", "Saddi"},
    {"Shizu", "Shisui"},
    {"Oroshi", "Wando"},
}

local function InventoryHasAny(names)
    for _, name in ipairs(names) do
        if InventoryHas(name) then return true, name end
    end
    return false, nil
end

local function LiveOwnedAlias(names)
    for _, name in ipairs(names) do
        local tool = FindOwnedTool(name)
        if tool then return tool, name end
    end
    return nil, nil
end

local function AliasMastery(names)
    local best, bestName = 0, names[1]
    for _, name in ipairs(names) do
        local m = EffectiveMastery(name)
        if m > best then best, bestName = m, name end
    end
    return best, bestName
end

function SwordProgressionController:InvalidateInventory()
    InventoryCache.At = 0
    WeaponInventoryCache.At = 0
end

function SwordProgressionController:TryDirectShop()
    if not _G.Settings.AutoBuySwords then return false end
    if tick() - self.LastShopProbe < (_G.Settings.SwordBuyProbe or 12) then return false end
    self.LastShopProbe = tick()
    -- Probe every still-missing ordinary shop sword in one bounded pass.
    -- This avoids getting stuck forever on the first unavailable item. The
    -- server remains authoritative for price, sea/NPC entitlement and ownership.
    local attempted = false
    for _, name in ipairs(DirectBuySwords) do
        if not InventoryHas(name) then
            attempted = true
            pcall(function() CommF_:InvokeServer("BuyItem", name) end)
        end
    end
    if attempted then
        self:InvalidateInventory()
        self.LastStatus = "Ordinary sword shop pass"
        DLog("SWORD", self.LastStatus)
    end
    return attempted
end

function SwordProgressionController:TryLegendaryDealer()
    if not _G.Settings.AutoBuySwords or GetSea() ~= 2 or Level() < 850 then return false end
    local missing = false
    for _, aliases in ipairs(LegendarySwordAliases) do
        if not InventoryHasAny(aliases) then missing = true break end
    end
    if not missing or Beli() < 2000000 then return false end
    if tick() - self.LastLegendaryProbe < (_G.Settings.LegendarySwordProbe or 8) then return false end
    self.LastLegendaryProbe = tick()
    -- The dealer sells exactly one of the three per spawn. Public current
    -- implementations probe choices 1/2/3; the server accepts only the live one.
    pcall(function() CommF_:InvokeServer("LegendarySwordDealer", "1") end)
    pcall(function() CommF_:InvokeServer("LegendarySwordDealer", "2") end)
    pcall(function() CommF_:InvokeServer("LegendarySwordDealer", "3") end)
    self:InvalidateInventory()
    self.LastStatus = "Legendary Sword Dealer probe"
    DLog("SWORD", self.LastStatus)
    return true
end

function SwordProgressionController:TrainTTKPrerequisite()
    if not _G.Settings.AutoBuySwords or not _G.Settings.AutoTrueTripleKatana then return false end
    local target = _G.Settings.TTKMasteryTarget or 300
    for _, aliases in ipairs(LegendarySwordAliases) do
        local owned = InventoryHasAny(aliases)
        if owned then
            local mastery, masteryName = AliasMastery(aliases)
            if mastery < target then
                local tool, liveName = LiveOwnedAlias(aliases)
                local equipName = liveName or masteryName
                if tool and equipName then
                    _G.State.PreferredCombatTool = equipName
                    self.LastStatus = ("TTK mastery %s %d/%d"):format(equipName, mastery, target)
                    DLog("SWORD", self.LastStatus)
                    return true
                end
            end
        end
    end
    return false
end

function SwordProgressionController:TryTrueTripleKatana()
    if not _G.Settings.AutoBuySwords or not _G.Settings.AutoTrueTripleKatana then return false end
    if InventoryHas("True Triple Katana") then return false end
    if GetSea() ~= 2 or Level() < 850 or Beli() < 2000000 then return false end
    local target = _G.Settings.TTKMasteryTarget or 300
    for _, aliases in ipairs(LegendarySwordAliases) do
        local owned = InventoryHasAny(aliases)
        local mastery = AliasMastery(aliases)
        if not owned or mastery < target then return false end
    end
    if tick() - self.LastTTKProbe < 8 then return false end
    self.LastTTKProbe = tick()
    -- Mysterious Man purchase flow: check/claim then buy. Server validates
    -- possession + 300 mastery on all three swords + 2,000,000 Beli.
    pcall(function() CommF_:InvokeServer("MysteriousMan", "1") end)
    pcall(function() CommF_:InvokeServer("MysteriousMan", "2") end)
    self:InvalidateInventory()
    self.LastStatus = "True Triple Katana purchase probe"
    DLog("SWORD", self.LastStatus)
    return true
end

function SwordProgressionController:Tick()
    if not _G.Settings.AutoBuySwords or not IsAlive() then return false end
    if _G.State.ActiveActionToken ~= 0 then return false end

    -- Cheap ordinary purchases first, then dealer acquisition, then mastery.
    -- Training never owns movement: normal quest/cluster farm supplies the kills.
    self:TryDirectShop()
    self:TryLegendaryDealer()
    if self:TrainTTKPrerequisite() then return true end
    self:TryTrueTripleKatana()
    return false
end

task.spawn(function()
    while SessionAlive() and task.wait(3) do
        if _G.State.ActiveActionToken == 0 then
            local meleeTraining = false
            if _G.Settings.AutoFightingStyles and _G.Settings.AutoBuyMelee then
                local ok, result = pcall(function() return FightingStyleController:Tick() end)
                meleeTraining = ok and result == true
            end
            if not meleeTraining and _G.Settings.AutoBuySwords then
                pcall(function() SwordProgressionController:Tick() end)
            end
        end
    end
end)

-- ══════════════════════════════════════════════════════════════════
--     AUTO ITEMS + SEA PROGRESSION v16.1 (GIỮ NGUYÊN + FIX-P8/P9)
--   ActionToken system: ClaimAction → IsActionValid → ReleaseAction
--   Mọi subsystem check token trước MỌI operation
--   ReleaseAction LUÔN được gọi trong finally block (xpcall)
--   Death/Recovery invalidate token → subsystem tự dừng
-- ══════════════════════════════════════════════════════════════════
local ItemProgression = {}
ItemProgression.NextOptional = {
    Saber = 0, PoleV1 = 0, Rengoku = 0, MidnightBlade = 0,
    Kabucha = 0, AcidumRifle = 0, Yama = 0, Tushita = 0, CDK = 0,
    SoulGuitar = 0, RaceV2 = 0, Style = 0,
}

function ItemProgression:OptionalReady(name)
    return tick() >= (self.NextOptional[name] or 0)
end

function ItemProgression:DelayOptional(name)
    self.NextOptional[name] = tick() + (_G.Settings.ItemRetryCooldown or 300)
end

-- Catalog item progression. Những mục có puzzle/điều kiện server phức tạp
-- được đánh dấu Manual để controller không gọi remote đoán mò làm mất tài nguyên.
-- BossDrop sẽ tự được BossManager săn khi boss xuất hiện trong Enemies.
local ItemCatalog = {
    {Name="Saber",Sea=1,MinLevel=200,Method="Puzzle+Boss",Auto="CheckSaber"},
    {Name="Pole (1st Form)",Sea=1,MinLevel=150,Method="Thunder God drop/purchase",Auto="CheckPoleV1"},
    {Name="Rengoku",Sea=2,MinLevel=1100,Method="Hidden Key + Awakened Ice Admiral",Auto="CheckRengoku"},
    {Name="Midnight Blade",Sea=2,MinLevel=1000,Method="100 Ectoplasm",Auto="CheckMidnightBlade"},
    {Name="Buddy Sword",Sea=3,MinLevel=2000,Method="Cake Queen drop",Auto="BossDrop"},
    {Name="Yama",Sea=3,MinLevel=1500,Method="30 Elite/Player Hunter quests",Auto="CheckYama"},
    {Name="Tushita",Sea=3,MinLevel=2000,Method="rip_indra + Holy Torch puzzle + Longma",Auto="CheckTushita"},
    {Name="Cursed Dual Katana",Sea=3,MinLevel=2200,Method="Yama/Tushita 350 + scroll trials",Auto="CheckCDK"},
    {Name="Kabucha",Sea=2,MinLevel=700,Method="1,500 fragments",Auto="CheckKabucha"},
    {Name="Acidum Rifle",Sea=2,MinLevel=700,Method="Factory Core drop",Auto="CheckAcidumRifle"},
    {Name="Soul Guitar",Sea=3,MinLevel=2300,Method="Full Moon puzzle + materials",Auto="CheckSoulGuitar"},
    {Name="True Triple Katana",Sea=2,MinLevel=850,Method="Saishi/Shizu/Oroshi 300 mastery + 2M",Auto="SwordProgression"},
    {Name="Godhuman",Sea=3,MinLevel=1500,Method="style mastery + materials",Auto="FightingStyles"},
    {Name="Sanguine Art",Sea=3,MinLevel=2400,Method="Leviathan Heart + materials",Auto="FightingStyles"},
}

function ItemProgression:GetMissingCatalog()
    local missing = {}
    for _, item in ipairs(ItemCatalog) do
        if Level() >= item.MinLevel and not InventoryHas(item.Name) then
            missing[#missing + 1] = item
        end
    end
    return missing
end

local function PrepareClaimedAction(owner)
    -- ClaimAction protects logical work; movement ownership is independent.
    -- Hand it over explicitly so a persistent Farm hover cannot make every
    -- Saber/Sea/Bartilo request fail with MovementBusy.
    if _G.State.IsTraveling then
        TravelManager:Stop(tostring(owner) .. "Priority")
    end
    FarmPositionController:ReleaseCluster()
    _G.State:ClearTargets()
    CombatController:WatchTarget(nil, nil)
end


function ItemProgression:CheckSaber()
    if not _G.Settings.AutoItems or not _G.Settings.AutoSaber then return false end
    if InventoryHas("Saber") or Level() < 200 or GetSea() ~= 1 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("Saber") then return false end
    local myToken = _G.State:ClaimAction("Saber")
    if myToken == 0 then return false end
    PrepareClaimedAction("Saber")
    self:DelayOptional("Saber")
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Item: Saber Sword"


    task.spawn(function()
        local ok, err = xpcall(function()
            local function EquipNamed(name)
                local c = Char()
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                local backpack = LP:FindFirstChildOfClass("Backpack")
                local tool = (c and c:FindFirstChild(name))
                    or (backpack and backpack:FindFirstChild(name))
                if not tool or not hum then return false end
                if tool.Parent ~= c then pcall(function() hum:EquipTool(tool) end) end
                task.wait(0.2)
                return c and c:FindFirstChild(name) ~= nil
            end

            -- Current Saber flow: Jungle plates -> Torch/Burn -> Cup/SickMan
            -- -> RichSon/Mob Leader -> Relic -> Saber Expert.
            local map = workspace:FindFirstChild("Map")
            local jungle = map and map:FindFirstChild("Jungle")
            local plates = jungle and jungle:FindFirstChild("QuestPlates")
            local plateDoor = plates and plates:FindFirstChild("Door")
            if plateDoor and plateDoor.Transparency == 0 then
                for i = 1, 5 do
                    local plate = plates:FindFirstChild("Plate" .. i)
                    local button = plate and plate:FindFirstChild("Button")
                    if button and _G.State:IsActionValid(myToken) then
                        TravelAndWait("Saber", myToken, button.CFrame, {
                            timeout = 60, arrivalThreshold = 5, settle = 0.35,
                        })
                    end
                end
            end

            if not _G.State:IsActionValid(myToken) then return end
            if not HasItem("Torch") then
                TravelAndWait("Saber", myToken, CFrame.new(-1610,11,164), {
                    timeout = 90, arrivalThreshold = 6, settle = 1,
                })
            end
            if HasItem("Torch") and EquipNamed("Torch") then
                TravelAndWait("Saber", myToken, CFrame.new(1114,5,4350), {
                    timeout = 90, arrivalThreshold = 7, settle = 1,
                })
            end

            if not _G.State:IsActionValid(myToken) then return end
            local sickProgress
            pcall(function()
                sickProgress = CommF_:InvokeServer("ProQuestProgress", "SickMan")
            end)
            if sickProgress ~= 0 then
                pcall(function() CommF_:InvokeServer("ProQuestProgress", "GetCup") end)
                if EquipNamed("Cup") then
                    local cup = Char() and Char():FindFirstChild("Cup")
                    if cup then
                        pcall(function()
                            CommF_:InvokeServer("ProQuestProgress", "FillCup", cup)
                        end)
                    end
                end
                pcall(function() CommF_:InvokeServer("ProQuestProgress", "SickMan") end)
            end

            if not _G.State:IsActionValid(myToken) then return end
            local richProgress
            pcall(function()
                richProgress = CommF_:InvokeServer("ProQuestProgress", "RichSon")
            end)
            if richProgress == 0 then
                local boss = FindBoss("Mob Leader")
                if not boss then
                    _G.BobonStatus = "Item: Waiting for Mob Leader"
                    return
                end
                local deadline = tick() + 120
                while boss and _G.State:IsActionValid(myToken) and IsAlive()
                    and tick() < deadline do
                    local bh = boss:FindFirstChildOfClass("Humanoid")
                    local br = boss:FindFirstChild("HumanoidRootPart")
                    if not bh or bh.Health <= 0 or not br then break end
                    PrepareCombatTarget(boss)
                    EquipCombatTool()
                    TravelManager:Request(br, "Saber", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        combatHover = true,
                    })
                    if TravelManager:IsAtCombatAnchor(br) then
                        Attack(boss, "Mob Leader")
                    end
                    task.wait(0.12)
                end
                pcall(function() CommF_:InvokeServer("ProQuestProgress", "RichSon") end)
            end

            pcall(function()
                richProgress = CommF_:InvokeServer("ProQuestProgress", "RichSon")
            end)
            if richProgress == 1 or HasItem("Relic") then
                pcall(function() CommF_:InvokeServer("ProQuestProgress", "RichSon") end)
                EquipNamed("Relic")
                if TravelAndWait("Saber", myToken, CFrame.new(-1405,30,4), {
                    timeout=90, arrivalThreshold=8, settle=0.5,
                }) then
                    pcall(function()
                        CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
                    end)
                end
            end

            local saberBoss = FindBoss("Saber Expert")
            if not saberBoss then
                _G.BobonStatus = "Item: Waiting for Saber Expert"
                return
            end
            local timeout = os.time() + 180
            while _G.State:IsActionValid(myToken) and not InventoryHas("Saber")
                and os.time() < timeout and IsAlive() do
                local boss = saberBoss
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss.Humanoid.Health > 0 then
                    PrepareCombatTarget(boss)
                    EquipCombatTool()
                    TravelManager:Request(boss.HumanoidRootPart, "Saber", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        combatHover = true,
                    })
                    if TravelManager:IsAtCombatAnchor(boss.HumanoidRootPart) then
                        Attack(boss, "Saber Expert")
                    end
                else
                    break
                end
                task.wait(0.1)
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Saber: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Saber" then
            TravelManager:Stop("SaberComplete")
        end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "GettingItem" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:CheckPoleV1()
    if not _G.Settings.AutoItems then return false end
    if InventoryHas("Pole (1st Form)") or Level() < 575 or GetSea() ~= 1 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("PoleV1") then return false end
    local boss = FindBoss("Thunder God")
    if not boss then
        self:DelayOptional("PoleV1")
        return false
    end
    local myToken = _G.State:ClaimAction("PoleV1")
    if myToken == 0 then return false end
    PrepareClaimedAction("PoleV1")
    self:DelayOptional("PoleV1")
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Item: Pole v1"


    task.spawn(function()
        local ok, err = xpcall(function()
            local deadline = tick() + 180
            while _G.State:IsActionValid(myToken) and IsAlive()
                and tick() < deadline and not InventoryHas("Pole (1st Form)") do
                local hum = boss and boss:FindFirstChildOfClass("Humanoid")
                local root = boss and boss:FindFirstChild("HumanoidRootPart")
                if not boss or not boss.Parent or not hum or hum.Health <= 0 or not root then
                    break
                end
                PrepareCombatTarget(boss)
                EquipCombatTool()
                TravelManager:Request(root, "PoleV1", {
                    arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                    combatHover = true,
                })
                if TravelManager:IsAtCombatAnchor(root) then
                    Attack(boss, "Thunder God")
                end
                task.wait(0.12)
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: PoleV1: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "PoleV1" then
            TravelManager:Stop("PoleV1Complete")
        end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "GettingItem" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:CheckSecondSea()
    if GetSea() >= 2 or Level() < 700 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("Sea2") then return false end
    local myToken = _G.State:ClaimAction("Sea2")
    if myToken == 0 then return false end
    PrepareClaimedAction("Sea2")
    self.NextOptional.Sea2 = tick() + 10
    _G.State:SetMode("UnlockingSea")
    _G.BobonStatus = "Sea: Unlock 2nd Sea"


    task.spawn(function()
        local ok, err = xpcall(function()
            if not _G.State:IsActionValid(myToken) then return end
            -- Correct Sea 2 gate: Military Detective gives the Key, the key
            -- opens the Ice cave, then Ice Admiral unlocks TravelDressrosa.
            if TravelAndWait("Sea2", myToken, CFrame.new(4851.87,5.65,718.47), {
                timeout=90, arrivalThreshold=8,
            }) then
                pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Detective") end)
            end
            local key = HasItem("Key")
            if key then
                local c, hum = Char(), Hum()
                if key.Parent ~= c and hum then pcall(function() hum:EquipTool(key) end) end
            end
            if not TravelAndWait("Sea2", myToken, CFrame.new(1347.71,37.38,-1325.65), {
                timeout=90, arrivalThreshold=8, settle=1,
            }) then
                return
            end
            task.wait(1.5)

            local boss = FindBoss("Ice Admiral")
            local deadline = tick() + 180
            while boss and _G.State:IsActionValid(myToken) and IsAlive()
                and tick() < deadline do
                local bh = boss:FindFirstChildOfClass("Humanoid")
                local br = boss:FindFirstChild("HumanoidRootPart")
                if not bh or bh.Health <= 0 or not br then break end
                PrepareCombatTarget(boss)
                EquipCombatTool()
                TravelManager:Request(br, "Sea2", {
                    arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                    combatHover = true,
                })
                if TravelManager:IsAtCombatAnchor(br) then
                    Attack(boss, "Ice Admiral")
                end
                task.wait(0.12)
            end

            if _G.State:IsActionValid(myToken) and IsAlive() then
                local traveled = false
                pcall(function()
                    CommF_:InvokeServer("TravelDressrosa")
                    traveled = true
                end)
                if traveled then _G.State.LastServerHop = os.time() end
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Sea2: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Sea2" then
            TravelManager:Stop("Sea2Complete")
        end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "UnlockingSea" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:CheckBartilo()
    if GetSea() ~= 2 or Level() < 800 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("Bartilo") then return false end
    local progress
    local okProgress = pcall(function()
        progress = CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
    end)
    if not okProgress or type(progress) ~= "number" or progress >= 3 then return false end

    local myToken = _G.State:ClaimAction("Bartilo")
    if myToken == 0 then return false end
    PrepareClaimedAction("Bartilo")
    self.NextOptional.Bartilo = tick() + 10
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Progression: Bartilo " .. tostring(progress)

    task.spawn(function()
        local ok, err = xpcall(function()
            if progress == 0 then
                if TravelAndWait("Bartilo", myToken, CFrame.new(-456.29,73.02,299.90), {
                    timeout=90, arrivalThreshold=10, settle=0.6,
                }) then
                    pcall(function() CommF_:InvokeServer("StartQuest", "BartiloQuest", 1) end)
                end
                local deadline = tick() + 600
                while _G.State:IsActionValid(myToken) and IsAlive() and tick() < deadline do
                    local current
                    pcall(function()
                        current = CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
                    end)
                    if type(current) == "number" and current ~= 0 then break end
                    local mob = FindMob("Swan Pirate")
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        PrepareCombatTarget(mob)
                        EquipCombatTool()
                        TravelManager:Request(mob.HumanoidRootPart, "Bartilo", {
                            arrivalThreshold=_G.Settings.FarmArrivalThreshold,
                            combatHover=true,
                        })
                        if TravelManager:IsAtCombatAnchor(mob.HumanoidRootPart) then
                            Attack(mob, "Swan Pirate")
                        end
                    else
                        TravelManager:Request(CFrame.new(932.62,156.11,1180.27), "Bartilo")
                        task.wait(1)
                    end
                    task.wait(0.12)
                end
            elseif progress == 1 then
                local boss = FindBoss("Jeremy")
                if not boss then
                    _G.BobonStatus = "Progression: Waiting for Jeremy"
                    return
                end
                local deadline = tick() + 180
                while _G.State:IsActionValid(myToken) and IsAlive() and tick() < deadline do
                    local bh = boss:FindFirstChildOfClass("Humanoid")
                    local br = boss:FindFirstChild("HumanoidRootPart")
                    if not bh or bh.Health <= 0 or not br then break end
                    PrepareCombatTarget(boss)
                    EquipCombatTool()
                    TravelManager:Request(br, "Bartilo", {
                        arrivalThreshold=_G.Settings.FarmArrivalThreshold,
                        combatHover=true,
                    })
                    if TravelManager:IsAtCombatAnchor(br) then
                        Attack(boss, "Jeremy")
                    end
                    task.wait(0.12)
                end
            elseif progress == 2 then
                local maze = {
                    CFrame.new(-1850.49,13.18,1750.90), CFrame.new(-1858.87,19.38,1712.02),
                    CFrame.new(-1803.94,16.58,1750.90), CFrame.new(-1858.56,16.86,1724.80),
                    CFrame.new(-1869.54,15.99,1681.01), CFrame.new(-1800.10,16.50,1684.52),
                    CFrame.new(-1819.26,14.80,1717.91), CFrame.new(-1813.52,14.86,1724.80),
                }
                for _, cf in ipairs(maze) do
                    if not TravelAndWait("Bartilo", myToken, cf, {
                        timeout=30, arrivalThreshold=6, settle=0.25,
                    }) then break end
                end
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Bartilo: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Bartilo" then
            TravelManager:Stop("BartiloComplete")
        end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "GettingItem" then _G.State:SetMode("Idle") end
    end)
    return true
end


function ItemProgression:CheckThirdSea()
    if GetSea() ~= 2 or Level() < 1500 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("Sea3") then return false end
    local myToken = _G.State:ClaimAction("Sea3")
    if myToken == 0 then return false end
    PrepareClaimedAction("Sea3")
    self.NextOptional.Sea3 = tick() + 10
    _G.State:SetMode("UnlockingSea")
    _G.BobonStatus = "Sea: Unlock 3rd Sea"


    task.spawn(function()
        local ok, err = xpcall(function()
            if not _G.State:IsActionValid(myToken) then return end
            local progress
            pcall(function()
                progress = CommF_:InvokeServer("ZQuestProgress", "General")
            end)
            if progress ~= 0 then
                local donSwan = FindBoss("Don Swan")
                if donSwan then
                    local deadline = tick() + 180
                    while _G.State:IsActionValid(myToken) and IsAlive()
                        and tick() < deadline do
                        local bh = donSwan:FindFirstChildOfClass("Humanoid")
                        local br = donSwan:FindFirstChild("HumanoidRootPart")
                        if not bh or bh.Health <= 0 or not br then break end
                        PrepareCombatTarget(donSwan)
                        EquipCombatTool()
                        TravelManager:Request(br, "Sea3", {
                            arrivalThreshold=_G.Settings.FarmArrivalThreshold,
                            combatHover=true,
                        })
                        if TravelManager:IsAtCombatAnchor(br) then
                            Attack(donSwan, "Don Swan")
                        end
                        task.wait(0.12)
                    end
                    pcall(function()
                        progress = CommF_:InvokeServer("ZQuestProgress", "General")
                    end)
                end
            end
            if progress == 0 then
                if not TravelAndWait("Sea3", myToken, CFrame.new(-1926.32,12.82,1738.31), {
                    timeout=90, arrivalThreshold=10, settle=1.5,
                }) then
                    return
                end
                pcall(function() CommF_:InvokeServer("ZQuestProgress", "Begin") end)
                task.wait(1.5)

                local boss = FindBoss("rip_indra")
                if not boss then
                    _G.BobonStatus = "Sea: Waiting for rip_indra quest boss"
                    return
                end
                local deadline = tick() + 240
                while _G.State:IsActionValid(myToken) and IsAlive()
                    and tick() < deadline do
                    local bh = boss:FindFirstChildOfClass("Humanoid")
                    local br = boss:FindFirstChild("HumanoidRootPart")
                    if not bh or bh.Health <= 0 or not br then break end
                    PrepareCombatTarget(boss)
                    EquipCombatTool()
                    TravelManager:Request(br, "Sea3", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        combatHover = true,
                    })
                    if TravelManager:IsAtCombatAnchor(br) then
                        Attack(boss, "rip_indra")
                    end
                    task.wait(0.12)
                end
            end

            if _G.State:IsActionValid(myToken) and IsAlive() then
                local traveled = false
                pcall(function()
                    CommF_:InvokeServer("TravelZou")
                    traveled = true
                end)
                if traveled then _G.State.LastServerHop = os.time() end
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Sea3: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Sea3" then
            TravelManager:Stop("Sea3Complete")
        end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "UnlockingSea" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end



-- v17 helpers for optional progression. Every routine is bounded and returns
-- control to quest farming if a server-side prerequisite is absent.
local function FightNamedForAction(name, owner, token, timeout)
    local deadline = tick() + (timeout or 120)
    while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
        local mob = FindBoss(name) or FindMob(name)
        if not mob then return false end
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 or not root then return true end
        PrepareCombatTarget(mob)
        EquipCombatTool()
        TravelManager:Request(root, owner, {
            arrivalThreshold = _G.Settings.FarmArrivalThreshold,
            combatHover = true,
        })
        if TravelManager:IsAtCombatAnchor(root) then Attack(mob, name) end
        task.wait(0.12)
    end
    return true
end

local function StartOptionalAction(self, key, owner, status, body)
    if not self:OptionalReady(key) or not _G.State:CanAct() then return false end
    local token = _G.State:ClaimAction(owner)
    if token == 0 then return false end
    PrepareClaimedAction(owner)
    self.NextOptional[key] = tick() + (_G.Settings.ProgressionRetry or 45)
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = status
    task.spawn(function()
        local ok, err = xpcall(function() body(token) end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: " .. owner .. ": " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == owner then
            TravelManager:Stop(owner .. "Complete")
        end
        _G.State:ReleaseAction(token)
        if _G.State.Mode == "GettingItem" then _G.State:SetMode("Idle") end
    end)
    return true
end

function ItemProgression:CheckKabucha()
    if not _G.Settings.AutoAdvancedItems or GetSea() < 2 or Level() < 700
        or InventoryHas("Kabucha") or not CanSpendFragments(1500) then return false end
    if not self:OptionalReady("Kabucha") then return false end
    self.NextOptional.Kabucha = tick() + (_G.Settings.ProgressionRetry or 45)
    pcall(function() CommF_:InvokeServer("BlackbeardReward","Slingshot","1") end)
    pcall(function() CommF_:InvokeServer("BlackbeardReward","Slingshot","2") end)
    return false
end

function ItemProgression:CheckRengoku()
    if not _G.Settings.AutoAdvancedItems or GetSea() ~= 2 or Level() < 1100
        or InventoryHas("Rengoku") then return false end
    local key = FindOwnedTool("Hidden Key")
    if not key then return false end -- BossManager hunts Awakened Ice Admiral.
    return StartOptionalAction(self, "Rengoku", "Rengoku", "Item: Opening Rengoku chest", function(token)
        EquipNamedTool("Hidden Key")
        TravelAndWait("Rengoku", token, CFrame.new(5518.01,60.56,-6828.81), {
            timeout=90, arrivalThreshold=7, settle=1.2,
        })
        -- The door/chest normally consumes Hidden Key by touch; click any nearby
        -- detector as a compatibility fallback without guessing a remote.
        local map = workspace:FindFirstChild("Map")
        local castle = map and (map:FindFirstChild("IceCastle") or map:FindFirstChild("Ice Castle"))
        if castle then TryClickDetector(castle) end
    end)
end

function ItemProgression:CheckMidnightBlade()
    if not _G.Settings.AutoAdvancedItems or GetSea() ~= 2 or Level() < 1000
        or InventoryHas("Midnight Blade") then return false end
    local ecto = MaterialCount("Ectoplasm")
    if ecto >= 100 then
        if self:OptionalReady("MidnightBlade") then
            self.NextOptional.MidnightBlade = tick() + (_G.Settings.ProgressionRetry or 45)
            pcall(function() CommF_:InvokeServer("Ectoplasm","Buy",3) end)
        end
        return false
    end
    if not CombatController:IsDamageReady() then return false end
    return StartOptionalAction(self, "MidnightBlade", "MidnightBlade",
        "Item: Farming Ectoplasm " .. tostring(ecto) .. "/100", function(token)
        local stopAt = tick() + math.min(_G.Settings.OptionalWorkTimeout or 150, 90)
        while _G.State:IsActionValid(token) and tick() < stopAt
            and MaterialCount("Ectoplasm") < 100 do
            local mob
            for _, n in ipairs({"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Cursed Captain"}) do
                mob = FindMob(n) or FindBoss(n)
                if mob then break end
            end
            if mob then
                FightNamedForAction(mob.Name, "MidnightBlade", token, 25)
                InventoryCache.At = 0
            else
                pcall(function()
                    CommF_:InvokeServer("requestEntrance", Vector3.new(923.21,126.98,32852.83))
                end)
                task.wait(2)
            end
        end
        InventoryCache.At = 0
        if MaterialCount("Ectoplasm") >= 100 then
            pcall(function() CommF_:InvokeServer("Ectoplasm","Buy",3) end)
        end
    end)
end

function ItemProgression:CheckYama()
    if not _G.Settings.AutoAdvancedItems or GetSea() ~= 3 or Level() < 1500
        or InventoryHas("Yama") then return false end
    local progress
    pcall(function() progress = CommF_:InvokeServer("EliteHunter","Progress") end)
    progress = tonumber(progress) or 0
    if progress >= 30 then
        return StartOptionalAction(self, "Yama", "Yama", "Item: Pulling Yama", function(token)
            local map = workspace:FindFirstChild("Map")
            local waterfall = map and map:FindFirstChild("Waterfall")
            local sealed = waterfall and waterfall:FindFirstChild("SealedKatana")
            local handle = sealed and sealed:FindFirstChild("Handle")
            if handle then
                TravelAndWait("Yama", token, handle.CFrame, {
                    timeout=90, arrivalThreshold=6, settle=0.5,
                })
                for _ = 1, 5 do
                    if InventoryHas("Yama") or not _G.State:IsActionValid(token) then break end
                    TryClickDetector(handle)
                    task.wait(0.5)
                end
            end
        end)
    end
    if not CombatController:IsDamageReady() then return false end
    return StartOptionalAction(self, "Yama", "Yama", "Item: Elite Hunter " .. progress .. "/30", function(token)
        pcall(function() CommF_:InvokeServer("EliteHunter") end)
        task.wait(0.5)
        local elite
        for _, n in ipairs({"Diablo","Deandre","Urban"}) do
            elite = FindBoss(n) or FindMob(n)
            if elite then break end
        end
        if elite then FightNamedForAction(elite.Name, "Yama", token, 120) end
    end)
end

function ItemProgression:CheckTushita()
    if not _G.Settings.AutoAdvancedItems or GetSea() ~= 3 or Level() < 2000
        or InventoryHas("Tushita") then return false end
    if not CombatController:IsDamageReady() then return false end

    local torch = FindOwnedTool("Holy Torch")
    if torch then
        return StartOptionalAction(self, "Tushita", "Tushita", "Item: Tushita Holy Torch", function(token)
            EquipNamedTool("Holy Torch")
            local map = workspace:FindFirstChild("Map")
            local turtle = map and map:FindFirstChild("Turtle")
            local torches = turtle and turtle:FindFirstChild("QuestTorches")
            if torches then
                for i = 1, 5 do
                    local t = torches:FindFirstChild("Torch" .. i)
                    if t and _G.State:IsActionValid(token) then
                        local lit = false
                        pcall(function()
                            local main = t:FindFirstChild("Particles", true)
                            local light = main and main:FindFirstChild("Main")
                            lit = light and light.Enabled == true
                        end)
                        if not lit then
                            TravelAndWait("Tushita", token, t.CFrame, {
                                timeout=60, arrivalThreshold=4, settle=0.8,
                            })
                        end
                    end
                end
            end
            local longma = FindBoss("Longma")
            if longma then FightNamedForAction("Longma", "Tushita", token, 180) end
        end)
    end

    local indra = FindBoss("rip_indra") or FindBoss("rip_indra True Form")
    if indra then
        return StartOptionalAction(self, "Tushita", "Tushita", "Item: Entering Tushita room", function(token)
            local map = workspace:FindFirstChild("Map")
            local waterfall = map and map:FindFirstChild("Waterfall")
            local room = waterfall and waterfall:FindFirstChild("SecretRoom")
            local hitbox = room and room:FindFirstChild("Hitbox", true)
            if hitbox and hitbox:IsA("BasePart") then
                TravelAndWait("Tushita", token, hitbox.CFrame, {
                    timeout=90, arrivalThreshold=5, settle=1,
                })
            else
                TravelAndWait("Tushita", token, CFrame.new(5152,142,912), {
                    timeout=90, arrivalThreshold=8, settle=1,
                })
            end
        end)
    end
    -- No rip_indra/Holy Torch in this server: do not steal movement from leveling.
    return false
end

function ItemProgression:CheckCDK()
    if not _G.Settings.AutoCDK or GetSea() ~= 3 or Level() < 2200
        or InventoryHas("Cursed Dual Katana") then return false end
    if not InventoryHas("Yama") or not InventoryHas("Tushita")
        or EffectiveMastery("Yama") < 350 or EffectiveMastery("Tushita") < 350 then
        return false
    end
    if not self:OptionalReady("CDK") then return false end
    self.NextOptional.CDK = tick() + (_G.Settings.ProgressionRetry or 45)
    local fragments = MaterialCount("Alucard Fragment")
    -- Starting a trial is safe/idempotent. Trial-specific kills/travel are left
    -- to the normal farm unless a live final boss can be verified.
    if fragments < 3 then
        pcall(function() CommF_:InvokeServer("CDKQuest","Progress","Evil") end)
        pcall(function() CommF_:InvokeServer("CDKQuest","StartTrial","Evil") end)
    elseif fragments < 6 then
        pcall(function() CommF_:InvokeServer("CDKQuest","Progress","Good") end)
        pcall(function() CommF_:InvokeServer("CDKQuest","StartTrial","Good") end)
    else
        pcall(function() CommF_:InvokeServer("CDKQuest","OpenDoor") end)
        local boss = FindBoss("Cursed Skeleton Boss")
        if boss and CombatController:IsDamageReady() then
            return StartOptionalAction(self, "CDK", "CDK", "Item: Cursed Dual Katana final", function(token)
                pcall(function() CommF_:InvokeServer("CDKQuest","StartTrial","Boss") end)
                FightNamedForAction("Cursed Skeleton Boss", "CDK", token, 240)
            end)
        end
    end
    return false
end

function ItemProgression:CheckAcidumRifle()
    if GetSea() ~= 2 or Level() < 700 or InventoryHas("Acidum Rifle") then return false end
    if not self:OptionalReady("AcidumRifle") then return false end

    -- Acidum Rifle is a live Factory Core drop. Never camp or steal movement
    -- while the Factory is closed; only act when a real Core is present.
    local core = FindMob("Core") or FindBoss("Core")
    if not core or not _G.State:IsTargetValid(core) then return false end
    if not CombatController:IsDamageReady() then return false end

    self.NextOptional.AcidumRifle = tick() + (_G.Settings.ProgressionRetry or 45)
    return StartOptionalAction(self, "AcidumRifle", "Factory", "Item: Factory Core / Acidum Rifle", function(token)
        FightNamedForAction("Core", "Factory", token, math.min(_G.Settings.OptionalWorkTimeout or 150, 280))
    end)
end

function ItemProgression:CheckSoulGuitar()
    if not _G.Settings.AutoSoulGuitar or GetSea() ~= 3 or Level() < 2300
        or InventoryHas("Soul Guitar") then return false end
    if not self:OptionalReady("SoulGuitar") then return false end
    self.NextOptional.SoulGuitar = tick() + (_G.Settings.ProgressionRetry or 45)

    -- Once the Skeleton Machine is available, this server-side call validates
    -- the material bill and performs the purchase. It is harmless when gated.
    local npcs = workspace:FindFirstChild("NPCs")
    if npcs and npcs:FindFirstChild("Skeleton Machine") then
        if CanSpendFragments(5000) then pcall(function() CommF_:InvokeServer("soulGuitarBuy", true) end) end
        return false
    end

    local progress
    pcall(function() progress = CommF_:InvokeServer("GuitarPuzzleProgress","Check") end)
    if type(progress) ~= "table" then
        -- Puzzle has not been initialized (normally requires the correct Full Moon
        -- gravestone interaction). Do not invent client state or spam clicks.
        return false
    end

    if progress.Swamp == false then
        -- This stage requires six Living Zombies to die together. The generic
        -- single-target farm must not fake completion; wait for a verified group.
        _G.BobonStatus = "Item: Soul Guitar - Swamp stage"
        return false
    elseif progress.Gravestones == false then
        local map = workspace:FindFirstChild("Map")
        local castle = map and map:FindFirstChild("Haunted Castle")
        if not castle then return false end
        local order = {
            {"Placard7","Left"},{"Placard6","Left"},{"Placard5","Left"},
            {"Placard4","Right"},{"Placard3","Left"},{"Placard2","Right"},{"Placard1","Right"},
        }
        for _, row in ipairs(order) do
            local placard = castle:FindFirstChild(row[1])
            local side = placard and placard:FindFirstChild(row[2])
            if side then TryClickDetector(side) end
            task.wait(0.08)
        end
        return false
    elseif progress.Ghost == false then
        pcall(function() CommF_:InvokeServer("GuitarPuzzleProgress","Ghost") end)
        pcall(function() CommF_:InvokeServer("GuitarPuzzleProgress","Ghost",true) end)
        return false
    elseif progress.Trophies == false then
        _G.BobonStatus = "Item: Soul Guitar - Trophy stage"
        return false
    elseif progress.Pipes == false then
        _G.BobonStatus = "Item: Soul Guitar - Pipe stage"
        return false
    end

    -- All puzzle flags completed: ask the Skeleton Machine purchase endpoint.
    if CanSpendFragments(5000) then pcall(function() CommF_:InvokeServer("soulGuitarBuy", true) end) end
    return false
end

function ItemProgression:CheckRaceV2()
    if not _G.Settings.AutoRaceV2 or GetSea() ~= 2 or Level() < 850 then return false end
    local data = LP:FindFirstChild("Data")
    local race = data and data:FindFirstChild("Race")
    if not race or race:FindFirstChild("Evolved") then return false end
    local state
    pcall(function() state = CommF_:InvokeServer("Alchemist","1") end)
    if state == -2 then return false end
    return StartOptionalAction(self, "RaceV2", "RaceV2", "Race: Upgrading V2", function(token)
        if state == 0 then
            if TravelAndWait("RaceV2", token, CFrame.new(-2779.84,72.97,-3574.02), {
                timeout=90, arrivalThreshold=6, settle=0.8,
            }) then
                pcall(function() CommF_:InvokeServer("Alchemist","2") end)
            end
            return
        end
        if state == 1 then
            local flower1, flower2 = workspace:FindFirstChild("Flower1"), workspace:FindFirstChild("Flower2")
            if not FindOwnedTool("Flower 1") and flower1 and flower1:IsA("BasePart") then
                TravelAndWait("RaceV2", token, flower1.CFrame, {timeout=90,arrivalThreshold=3,settle=1})
                return
            end
            if not FindOwnedTool("Flower 2") and flower2 and flower2:IsA("BasePart") then
                TravelAndWait("RaceV2", token, flower2.CFrame, {timeout=90,arrivalThreshold=3,settle=1})
                return
            end
            if not FindOwnedTool("Flower 3") and CombatController:IsDamageReady() then
                local swan = FindMob("Swan Pirate")
                if swan then FightNamedForAction("Swan Pirate","RaceV2",token,90) end
                return
            end
            if FindOwnedTool("Flower 1") and FindOwnedTool("Flower 2") and FindOwnedTool("Flower 3") then
                if TravelAndWait("RaceV2", token, CFrame.new(-2779.84,72.97,-3574.02), {
                    timeout=90, arrivalThreshold=6, settle=0.8,
                }) then
                    pcall(function() CommF_:InvokeServer("Alchemist","3") end)
                end
            end
        end
    end)
end

-- Progression is deliberately a *farm-window* operation.  A valid quest is
-- never interrupted by an optional item or boss; Sea 2/3 and item checks run
-- only after the current quest is finished (or before the first quest).
-- `allowSea` also accepts a wrong quest so the level-700/1500 sea gate cannot
-- accidentally send the player to a next-sea quest before unlocking it.
function ItemProgression:RunChecks(allowSea, allowOptional)
    if not allowSea or not _G.State:CanAct() then return false end
    -- Mandatory world gates first.
    if self:CheckSecondSea() then return true end
    if self:CheckBartilo() then return true end
    if self:CheckThirdSea() then return true end
    if not allowOptional then return false end

    -- Cheap/non-blocking progression before long item hunts.
    if self:CheckRaceV2() then return true end
    local meleeBusy = false
    pcall(function() meleeBusy = FightingStyleController:Tick() == true end)
    if not meleeBusy then pcall(function() SwordProgressionController:Tick() end) end
    if self:CheckKabucha() then return true end

    -- Weapons and puzzles. Every routine is bounded; missing spawn/event simply
    -- returns false so BossManager/QuestFarm can continue.
    if self:CheckSaber() then return true end
    if self:CheckPoleV1() then return true end
    if self:CheckRengoku() then return true end
    if self:CheckMidnightBlade() then return true end
    if self:CheckAcidumRifle() then return true end
    if self:CheckYama() then return true end
    if self:CheckTushita() then return true end
    if self:CheckCDK() then return true end
    if self:CheckSoulGuitar() then return true end
    return false
end
-- ══════════════════════════════════════════════════════════════════
--              BOSSMANAGER v16.4 — DATA-DRIVEN
--   Boss không dùng tọa độ cứng để tránh bay ra biển khi map thay đổi.
--   Bộ điều khiển chỉ nhận boss đang thật sự tồn tại trong workspace.Enemies,
--   lọc theo Sea/level, rồi dùng cùng TravelManager + ActionToken với Farm.
--   Vì vậy boss chết/despawn giữa đường sẽ tự nhả movement và quay lại farm.
-- ══════════════════════════════════════════════════════════════════
local BossManager = {
    Active = false,
    ActiveName = nil,
    LastKill = 0,
    LastScan = 0,
}

-- Tên được chuẩn hoá bởi IsEnemyNamed() nên vẫn khớp hậu tố [Lv. ...].
-- MinLevel chỉ là ngưỡng an toàn; việc boss có spawn hay không luôn kiểm tra
-- bằng instance sống trong Enemies trước khi di chuyển.
local BossDatabase = {
    -- Sea 1
    {N="Gorilla King",Sea=1,MinLevel=20}, {N="Chef",Sea=1,MinLevel=55}, {N="Bobby",Sea=1,MinLevel=55},
    {N="The Saw",Sea=1,MinLevel=100}, {N="Mob Leader",Sea=1,MinLevel=120},
    {N="Vice Admiral",Sea=1,MinLevel=130}, {N="Saber Expert",Sea=1,MinLevel=200},
    {N="Warden",Sea=1,MinLevel=220}, {N="Chief Warden",Sea=1,MinLevel=230},
    {N="Magma Admiral",Sea=1,MinLevel=350}, {N="Fishman Lord",Sea=1,MinLevel=425},
    {N="Wysper",Sea=1,MinLevel=500}, {N="Thunder God",Sea=1,MinLevel=575},
    {N="Cyborg",Sea=1,MinLevel=675}, {N="Ice Admiral",Sea=1,MinLevel=700},
    {N="Greybeard",Sea=1,MinLevel=750},
    -- Sea 2
    {N="Diamond",Sea=2,MinLevel=750}, {N="Jeremy",Sea=2,MinLevel=850},
    {N="Orbitus",Sea=2,MinLevel=925}, {N="Fajita",Sea=2,MinLevel=925}, {N="Don Swan",Sea=2,MinLevel=1000},
    {N="Smoke Admiral",Sea=2,MinLevel=1150},
    {N="Awakened Ice Admiral",Sea=2,MinLevel=1400},
    {N="Tide Keeper",Sea=2,MinLevel=1475}, {N="Darkbeard",Sea=2,MinLevel=1000},
    {N="Order",Sea=2,MinLevel=1250}, {N="Cursed Captain",Sea=2,MinLevel=1325},
    -- Sea 3
    {N="Stone",Sea=3,MinLevel=1550}, {N="Island Empress",Sea=3,MinLevel=1675},
    {N="Kilo Admiral",Sea=3,MinLevel=1750}, {N="Captain Elephant",Sea=3,MinLevel=1875},
    {N="Beautiful Pirate",Sea=3,MinLevel=1950},
    {N="Longma",Sea=3,MinLevel=2000},
    {N="Cursed Skeleton Boss",Sea=3,MinLevel=2050}, {N="Cake Queen",Sea=3,MinLevel=2175},
    {N="Soul Reaper",Sea=3,MinLevel=2000}, {N="Cake Prince",Sea=3,MinLevel=2200},
    {N="Dough King",Sea=3,MinLevel=2300},
    {N="Tyrant of the Skies",Sea=3,MinLevel=2600},
    {N="rip_indra True Form",Sea=3,MinLevel=1500}, {N="rip_indra",Sea=3,MinLevel=1500},
    {N="Diablo",Sea=3,MinLevel=1500}, {N="Deandre",Sea=3,MinLevel=1500}, {N="Urban",Sea=3,MinLevel=1500},
}

-- Optional boss work must advance the kaitun instead of interrupting every
-- completed quest for unrelated bosses. Level-skip bosses are handled by the
-- dedicated SkipRouteController; this manager targets missing useful drops.
local BossDropItems = {
    -- Sea 1 sword drops
    ["The Saw"] = {"Shark Saw"},
    ["Chief Warden"] = {"Wardens Sword"},
    ["Fishman Lord"] = {"Trident"},
    ["Thunder God"] = {"Pole (1st Form)"},

    -- Sea 2 sword drops. Keep legacy aliases where Update renames changed names.
    ["Diamond"] = {"Longsword"},
    ["Orbitus"] = {"Gravity Blade", "Gravity Cane"},
    ["Fajita"] = {"Gravity Blade", "Gravity Cane"},
    ["Smoke Admiral"] = {"Flail", "Jitte"},
    ["Awakened Ice Admiral"] = {"Rengoku"},
    ["Tide Keeper"] = {"Dragon Trident"},
    ["Order"] = {"Koko"},

    -- Sea 3 sword drops
    ["Captain Elephant"] = {"Twin Hooks"},
    ["Beautiful Pirate"] = {"Canvander"},
    ["Cake Queen"] = {"Buddy Sword"},
    ["Soul Reaper"] = {"Hallow Scythe"},
    ["Cake Prince"] = {"Spikey Trident"},
    ["Dough King"] = {"Spikey Trident"},
    ["rip_indra True Form"] = {"Dark Dagger"},
    ["rip_indra"] = {"Dark Dagger"},
}

local function BossDropMissing(spec)
    if type(spec) == "string" then return not InventoryHas(spec) end
    if type(spec) == "table" then
        for _, name in ipairs(spec) do
            if InventoryHas(name) then return false end
        end
        return #spec > 0
    end
    return false
end

local function HasActive2xExp()
    local data = LP:FindFirstChild("Data")
    if not data then return false end
    for _, obj in ipairs(data:GetDescendants()) do
        local n = string.lower(tostring(obj.Name or ""))
        if n:find("exp",1,true) and (n:find("boost",1,true) or n:find("2x",1,true) or n:find("double",1,true)) then
            if (obj:IsA("NumberValue") or obj:IsA("IntValue")) and tonumber(obj.Value) and obj.Value > 0 then return true end
            if obj:IsA("BoolValue") and obj.Value then return true end
        end
    end
    for _, attr in ipairs({"ExpBoost","XPBoost","DoubleExp","2xExp"}) do
        local v = data:GetAttribute(attr)
        if v == true or (type(v)=="number" and v > 0) then return true end
    end
    return false
end

function BossManager:FindLiveBoss()
    local folder = workspace:FindFirstChild("Enemies")
    local root = HRP()
    if not folder or not root then return nil end
    local sea, level = GetSea(), Level()
    local best, bestDist, bestEntry = nil, math.huge, nil
    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local mobRoot = mob:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and mobRoot then
            for _, entry in ipairs(BossDatabase) do
                local wantedItem = BossDropItems[entry.N]
                local wantedSwordDrop = _G.Settings.AutoBuySwords == true
                    and BossDropMissing(wantedItem)
                local progressionBoss = entry.N == "Tyrant of the Skies"
                    and level >= 2600 and not SubmergedAccessController.Confirmed
                local styleKeyBoss = _G.Settings.AutoFightingStyles and (
                    (entry.N == "Awakened Ice Admiral" and not InventoryHas("Death Step")
                        and math.max(EffectiveMastery("Dark Step"), EffectiveMastery("Black Leg")) >= 400)
                    or (entry.N == "Tide Keeper" and not InventoryHas("Sharkman Karate")
                        and math.max(EffectiveMastery("Water Kung Fu"), EffectiveMastery("Fishman Karate")) >= 400)
                )
                local farmDrops = _G.Settings.FarmBossDrops
                    and (not _G.Settings.BossDropsWhen2xExpired or not HasActive2xExp())
                local hopTarget = false
                if _G.Settings.HopEnabled then
                    hopTarget = (_G.Settings.HopElite and (entry.N == "Diablo" or entry.N == "Deandre" or entry.N == "Urban"))
                        or (_G.Settings.HopFindDarkbeard and entry.N == "Darkbeard")
                        or (_G.Settings.HopFindSoulReaper and entry.N == "Soul Reaper")
                        or (_G.Settings.HopFindMirrorFractal and entry.N == "Dough King" and not InventoryHas("Mirror Fractal"))
                        or (_G.Settings.HopFindTushita and (entry.N == "rip_indra" or entry.N == "rip_indra True Form") and not InventoryHas("Tushita"))
                        or (_G.Settings.HopFindValkyrieHelm and (entry.N == "rip_indra" or entry.N == "rip_indra True Form") and not InventoryHas("Valkyrie Helm"))
                end
                if (wantedSwordDrop or progressionBoss or styleKeyBoss or farmDrops or hopTarget)
                    and entry.Sea == sea and level >= entry.MinLevel
                    and IsEnemyNamed(mob, entry.N) then
                    local p = mobRoot.Position
                    if IsValidPos(p) and IsAllowedWorldPosition(p) then
                        local d = (p - root.Position).Magnitude
                        if d < bestDist then
                            best, bestDist, bestEntry = mob, d, entry
                        end
                    end
                    break
                end
            end
        end
    end
    return best, bestEntry
end

function BossManager:_Finish(token, reason)
    if TravelManager and _G.State.IsTraveling and _G.State.MovementOwner == "Boss" then
        TravelManager:Stop("Boss:" .. tostring(reason))
    end
    if _G.State.CurrentTarget and (not _G.State.CurrentTarget.Parent
        or self.ActiveName == nil or IsEnemyNamed(_G.State.CurrentTarget, self.ActiveName)) then
        _G.State.CurrentTarget = nil
    end
    _G.State:ReleaseAction(token)
    self.Active = false
    self.ActiveName = nil
    if _G.State.Mode == "Bossing" then _G.State:SetMode("Idle") end
end

function BossManager:_RunBoss(boss, entry, token)
    local ok, err = xpcall(function()
        self.ActiveName = entry.N
        _G.State.CurrentTarget = boss
        _G.State:SetMode("Bossing")
        _G.BobonStatus = "Boss: " .. entry.N
        local deadline = tick() + 180
        while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
            local hum = boss and boss:FindFirstChildOfClass("Humanoid")
            local targetRoot = boss and boss:FindFirstChild("HumanoidRootPart")
            if not boss or not boss.Parent or not hum or hum.Health <= 0 or not targetRoot then
                self.LastKill = tick()
                break
            end
            local okTargetPos, liveTargetPos = pcall(function()
                return targetRoot.Position
            end)
            if not okTargetPos or not IsAllowedWorldPosition(liveTargetPos) then
                break
            end
            PrepareCombatTarget(targetRoot)
            TravelManager:Request(targetRoot, "Boss", {
                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                fallback = nil,
                combatHover = true,
            })
            local me = HRP()
            if me then
                local a = Vector3.new(me.Position.X, 0, me.Position.Z)
                local b = Vector3.new(targetRoot.Position.X, 0, targetRoot.Position.Z)
                if (a - b).Magnitude <= _G.Settings.AttackRange
                    and TravelManager:IsAtCombatAnchor(targetRoot) then
                    EquipCombatTool()
                    Attack(boss)
                end
            end
            task.wait(0.12)
        end
    end, debug.traceback)
    if not ok then warn("[BobonHub] Module Error: Boss " .. tostring(err)) end
    self:_Finish(token, ok and "complete" or "error")
end

function BossManager:TryFightBoss()
    if not _G.Settings.BossEnabled or self.Active or not _G.State:CanAct() then return false end
    if not CombatController:IsDamageReady() then return false end
    local boss, entry = self:FindLiveBoss()
    if not boss or not entry then return false end
    local token = _G.State:ClaimAction("Boss")
    if token == 0 then return false end
    PrepareClaimedAction("Boss")
    self.Active = true
    task.spawn(function() self:_RunBoss(boss, entry, token) end)
    return true
end



-- ══════════════════════════════════════════════════════════════════
--              KATAKURI CONTROLLER v18 — MAX LEVEL ONLY
-- ══════════════════════════════════════════════════════════════════
local KatakuriController = {
    NextTry = 0,
    LastProgress = nil,
    LastProgressAt = 0,
    CraftNextTry = 0,
}

local CAKE_MOBS = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}
local COCOA_MOBS = {"Cocoa Warrior", "Chocolate Bar Battler"}

local function FindAnyNamed(names)
    local root, folder = HRP(), workspace:FindFirstChild("Enemies")
    if not root or not folder then return nil end
    local best, bestDist = nil, math.huge
    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local mr = mob:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and mr then
            for _, wanted in ipairs(names) do
                if IsEnemyNamed(mob, wanted) then
                    local d = (root.Position - mr.Position).Magnitude
                    if d < bestDist then best, bestDist = mob, d end
                    break
                end
            end
        end
    end
    return best
end

local function FindNpcLike(needles)
    for _, root in ipairs({workspace:FindFirstChild("NPCs"), workspace:FindFirstChild("Map")}) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                local lower = string.lower(tostring(obj.Name or ""))
                for _, needle in ipairs(needles) do
                    if string.find(lower, string.lower(needle), 1, true) then
                        local model = obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
                        if model then return model end
                    end
                end
            end
        end
    end
    return nil
end

local function TryPrompt(root)
    if not root then return false end
    local prompt = root:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not prompt or type(fireproximityprompt) ~= "function" then return false end
    return pcall(function() fireproximityprompt(prompt) end)
end

function KatakuriController:IsEligible()
    if not _G.Settings.AutoKatakuri or GetSea() ~= 3 then return false end
    if _G.Settings.KatakuriOnlyMax ~= false and Level() < MAX_LEVEL then return false end
    return Level() >= MAX_LEVEL
end

function KatakuriController:GetRemaining(force)
    local now = tick()
    if not force and self.LastProgress ~= nil and now - self.LastProgressAt < 2 then
        return self.LastProgress
    end
    local result
    local ok = pcall(function() result = CommF_:InvokeServer("CakePrinceSpawner", true) end)
    if not ok then return nil end
    local n
    if type(result) == "number" then
        n = result
    else
        for digits in tostring(result or ""):gmatch("%d+") do n = tonumber(digits) or n end
    end
    self.LastProgress, self.LastProgressAt = n, now
    return n
end

function KatakuriController:StartAction(status, body)
    if not self:IsEligible() or not _G.State:CanAct() or tick() < self.NextTry then return false end
    local token = _G.State:ClaimAction("Katakuri")
    if token == 0 then return false end
    PrepareClaimedAction("Katakuri")
    self.NextTry = tick() + (_G.Settings.KatakuriRetry or 20)
    _G.State:SetMode("Bossing")
    _G.BobonStatus = status
    task.spawn(function()
        local ok, err = xpcall(function() body(token) end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Katakuri: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Katakuri" then
            TravelManager:Stop("KatakuriComplete")
        end
        FarmPositionController:ReleaseCluster()
        _G.State:ClearTargets()
        CombatController:WatchTarget(nil, nil)
        _G.State:ReleaseAction(token)
        if _G.State.Mode == "Bossing" then _G.State:SetMode("Idle") end
    end)
    return true
end

function KatakuriController:GatherSameMob(primary)
    -- v18.4: normal leveling bring remains quest-only, but Dough King summon
    -- preparation is allowed to cluster Cake Land / Cocoa fodder. Bosses and
    -- Elite hunters are deliberately excluded. Only network-owned NPC roots
    -- are moved, so this cannot create client-only ghost/dummy enemies.
    if not _G.Settings.GatherMobs or not primary or not _G.State:IsTargetValid(primary) then return 0 end
    if _G.State.MovementOwner ~= "Katakuri" then return 0 end

    local primaryRoot = primary:FindFirstChild("HumanoidRootPart")
    local folder = workspace:FindFirstChild("Enemies")
    if not primaryRoot or not folder or not TravelManager:IsAtCombatAnchor(primaryRoot) then return 0 end

    local function InList(model, list)
        for _, wanted in ipairs(list) do
            if IsEnemyNamed(model, wanted) then return true end
        end
        return false
    end

    local group
    if InList(primary, CAKE_MOBS) then
        group = CAKE_MOBS
    elseif InList(primary, COCOA_MOBS) then
        group = COCOA_MOBS
    else
        -- Dough King, Elite bosses and every other progression target stay
        -- single-target and are never brought.
        return 0
    end

    ExpandSimulationRadius()
    local moved, index = 0, 0
    local maxDistance = math.clamp(_G.Settings.GatherMaxDistance or 600, 100, 1200)
    local spacing = math.min(math.max(_G.Settings.ClusterStackRadius or 0.75, 0.20), 1.00)
    local anchor = primaryRoot.Position

    for _, mob in ipairs(folder:GetChildren()) do
        if mob ~= primary and InList(mob, group) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root and root.Parent and not root.Anchored then
                local okPos, mobPos = pcall(function() return root.Position end)
                if okPos and IsValidPos(mobPos) and IsAllowedWorldPosition(mobPos)
                    and (mobPos - anchor).Magnitude <= maxDistance
                    and ClientOwnsMob(root) == true then
                    index = index + 1
                    local angle = index * 2.3999632297
                    local radius = math.min(spacing, 0.18 + index * 0.10)
                    local destination = anchor + Vector3.new(
                        math.cos(angle) * radius,
                        0,
                        math.sin(angle) * radius
                    )
                    pcall(function()
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                        root.CFrame = CFrame.new(destination, anchor)
                    end)
                    moved = moved + 1
                end
            end
        end
    end
    return moved
end

function KatakuriController:FightModel(model, token, timeout)
    local deadline = tick() + (timeout or 90)
    while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
        if not _G.State:IsTargetValid(model) then return true end
        local hum = model:FindFirstChildOfClass("Humanoid")
        local root = model:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 or not root then return true end
        PrepareCombatTarget(model)
        EquipCombatTool()
        TravelManager:Request(root, "Katakuri", {arrivalThreshold=_G.Settings.FarmArrivalThreshold, combatHover=true})
        if TravelManager:IsAtCombatAnchor(root) then
            -- Only Cake/Cocoa fodder is gathered; GatherSameMob returns 0 for
            -- Dough King, Elite hunters and every boss target.
            self:GatherSameMob(model)
            Attack(model, model.Name)
        end
        task.wait(0.12)
    end
    return true
end

function KatakuriController:FarmNamed(names, token, seconds, materialName, wantedCount)
    local deadline = tick() + (seconds or 60)
    while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
        if materialName then
            InventoryCache.At = 0
            if MaterialCount(materialName) >= (wantedCount or 1) then return true end
        end
        local mob = FindAnyNamed(names)
        if mob then
            self:FightModel(mob, token, 30)
            InventoryCache.At = 0
            self.LastProgressAt = 0
        else
            TravelManager:Request(CFrame.new(-2021, 38, -12029), "Katakuri", {arrivalThreshold=30})
            task.wait(1)
        end
    end
    return false
end

function KatakuriController:TryCraftSweetChalice(token)
    if FindOwnedTool("Sweet Chalice") then return true end
    if not FindOwnedTool("God's Chalice") or MaterialCount("Conjured Cocoa") < 10 then return false end
    if tick() < self.CraftNextTry then return false end
    self.CraftNextTry = tick() + (_G.Settings.KatakuriCraftRetry or 20)
    _G.BobonStatus = "Katakuri: Crafting Sweet Chalice"
    local npc = FindNpcLike({"Sweet Crafter", "SweetCrafter"})
    if npc then
        local part = npc.PrimaryPart or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart", true)
        if part then
            TravelAndWait("Katakuri", token, part.CFrame, {timeout=60,arrivalThreshold=7,settle=0.8})
        end
        TryPrompt(npc)
        TryClickDetector(npc)
        task.wait(1)
    end
    -- Guarded compatibility fallback: it is attempted only with the exact
    -- prerequisites, and failure is isolated by pcall.
    if not FindOwnedTool("Sweet Chalice") then
        pcall(function() CommF_:InvokeServer("SweetChaliceNpc") end)
        task.wait(0.8)
    end
    InventoryCache.At = 0
    return FindOwnedTool("Sweet Chalice") ~= nil
end

function KatakuriController:TryRun()
    if not self:IsEligible() or not _G.State:CanAct() then return false end
    local live = FindBoss("Dough King")
    if live then
        return self:StartAction("Katakuri: " .. live.Name, function(token)
            self:FightModel(live, token, math.min(_G.Settings.OptionalWorkTimeout or 150, 300))
        end)
    end

    local sweet = FindOwnedTool("Sweet Chalice")
    local gods = FindOwnedTool("God's Chalice")
    InventoryCache.At = 0
    local cocoa = MaterialCount("Conjured Cocoa")
    if _G.Settings.KatakuriPreferDough and not sweet and gods then
        if cocoa < 10 then
            return self:StartAction("Katakuri: Cocoa " .. tostring(cocoa) .. "/10", function(token)
                self:FarmNamed(COCOA_MOBS, token, math.min(_G.Settings.KatakuriWorkTimeout or 90, 90), "Conjured Cocoa", 10)
            end)
        end
        return self:StartAction("Katakuri: Sweet Chalice", function(token)
            self:TryCraftSweetChalice(token)
        end)
    end

    if not sweet and not gods then
        local elite = FindAnyNamed({"Diablo", "Deandre", "Urban"})
        if elite then
            return self:StartAction("Katakuri: Farming Elite for God's Chalice", function(token)
                self:FightModel(elite, token, 180)
            end)
        end
    end

    local remaining = self:GetRemaining(false)
    if remaining ~= nil and remaining <= 0 then
        if sweet then EquipNamedTool("Sweet Chalice") end
        if not sweet then return false end
        return self:StartAction("Katakuri: Summoning Dough King", function(token)
            pcall(function() CommF_:InvokeServer("CakePrinceSpawner") end)
            task.wait(1.5)
            self.LastProgressAt = 0
            local spawned = FindBoss("Dough King")
            if spawned then self:FightModel(spawned, token, 300) end
        end)
    end

    local label = remaining and tostring(remaining) or "?"
    return self:StartAction("Katakuri: Cake mobs remaining " .. label, function(token)
        self:FarmNamed(CAKE_MOBS, token, math.min(_G.Settings.KatakuriWorkTimeout or 90, 90))
        self.LastProgressAt = 0
    end)
end

-- ══════════════════════════════════════════════════════════════════
--              FRUIT MANAGER v16.7 — RANDOM + SAFE STORE
--   FruitEnabled existed in config but had no implementation in v16.6.
--   This manager never owns movement and never interrupts quest/combat.
--   Sea 2/3 beli gates prevent pointless Cousin spam; storing is best-effort.
-- ══════════════════════════════════════════════════════════════════
local FruitManager = {
    LastStore = 0,
    Busy = false,
}

local FruitIdFallback = {
    ["Rocket"]="Rocket-Rocket", ["Spin"]="Spin-Spin", ["Blade"]="Blade-Blade",
    ["Chop"]="Chop-Chop", ["Spring"]="Spring-Spring", ["Bomb"]="Bomb-Bomb",
    ["Smoke"]="Smoke-Smoke", ["Spike"]="Spike-Spike", ["Flame"]="Flame-Flame",
    ["Falcon"]="Falcon-Falcon", ["Ice"]="Ice-Ice", ["Sand"]="Sand-Sand",
    ["Dark"]="Dark-Dark", ["Ghost"]="Ghost-Ghost", ["Diamond"]="Diamond-Diamond",
    ["Light"]="Light-Light", ["Rubber"]="Rubber-Rubber", ["Barrier"]="Barrier-Barrier",
    ["Creation"]="Creation-Creation", ["Magma"]="Magma-Magma", ["Quake"]="Quake-Quake",
    ["Buddha"]="Buddha-Buddha", ["Human-Human: Buddha"]="Human-Human: Buddha",
    ["Love"]="Love-Love", ["Spider"]="Spider-Spider", ["String"]="String-String",
    ["Sound"]="Sound-Sound", ["Phoenix"]="Phoenix-Phoenix",
    ["Bird: Phoenix"]="Bird-Bird: Phoenix", ["Portal"]="Portal-Portal",
    ["Door"]="Door-Door", ["Rumble"]="Rumble-Rumble", ["Pain"]="Pain-Pain",
    ["Paw"]="Paw-Paw", ["Blizzard"]="Blizzard-Blizzard", ["Gravity"]="Gravity-Gravity",
    ["Mammoth"]="Mammoth-Mammoth", ["T-Rex"]="T-Rex-T-Rex", ["Dough"]="Dough-Dough",
    ["Shadow"]="Shadow-Shadow", ["Venom"]="Venom-Venom", ["Control"]="Control-Control",
    ["Spirit"]="Spirit-Spirit", ["Soul"]="Soul-Soul", ["Gas"]="Gas-Gas",
    ["Leopard"]="Leopard-Leopard", ["Yeti"]="Yeti-Yeti", ["Kitsune"]="Kitsune-Kitsune",
    ["Dragon"]="Dragon-Dragon",
}
local function FruitOriginalName(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    local original
    pcall(function() original = tool:GetAttribute("OriginalName") end)
    if type(original) == "string" and original ~= "" then return original end
    local name = tostring(tool.Name or "")
    if name == "" then return nil end
    name = name:gsub("%s+[Ff]ruit$", ""):gsub("%-[Ff]ruit$", "")
    -- Already canonical IDs should pass through untouched.
    if name:find("%-") and not FruitIdFallback[name] then return name end
    return FruitIdFallback[name] or (name .. "-" .. name)
end

local function LooksLikeFruitTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local original
    pcall(function() original = tool:GetAttribute("OriginalName") end)
    if type(original) == "string" and original ~= "" then return true end
    local n = string.lower(tostring(tool.Name or ""))
    return n:find("fruit", 1, true) ~= nil
end

function FruitManager:StoreBackpackFruits()
    if not _G.Settings.FruitEnabled then return false end
    local now = tick()
    if now - self.LastStore < (_G.Settings.FruitStoreInterval or 8) then return false end
    self.LastStore = now
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not backpack then return false end
    local storedAny = false
    for _, tool in ipairs(backpack:GetChildren()) do
        if LooksLikeFruitTool(tool) then
            local fruitName = FruitOriginalName(tool)
            if fruitName then
                local ok = pcall(function()
                    CommF_:InvokeServer("StoreFruit", fruitName, tool)
                end)
                storedAny = storedAny or ok
                task.wait(0.12)
            end
        end
    end
    return storedAny
end

function FruitManager:TryRandomFruit()
    if not _G.Settings.GetFruits or not _G.Settings.FruitEnabled or self.Busy or not IsAlive() then return false end
    local sea = GetSea()
    if sea < 2 then return false end
    local now = tick()
    if now - (_G.State.LastRandomFruit or 0) < (_G.Settings.RandomFruitInterval or 120) then
        return false
    end
    local required = sea >= 3 and (_G.Settings.RandomFruitSea3Cost or 250000)
        or (_G.Settings.RandomFruitSea2Cost or 100000)
    if Beli() < required then return false end

    self.Busy = true
    -- Mark the attempt before invoking so an error cannot turn into a remote-spam loop.
    _G.State.LastRandomFruit = now
    local ok, result = pcall(function()
        return CommF_:InvokeServer("Cousin", "Buy")
    end)
    if not ok then
        DLog("FRUIT", "Random fruit request failed: " .. tostring(result))
    else
        DLog("FRUIT", "Random fruit request sent")
    end
    task.wait(0.25)
    pcall(function() self:StoreBackpackFruits() end)
    self.Busy = false
    return ok
end

-- Fruit is a background economy action only: no CFrame, no MovementOwner,
-- no ActionToken. That keeps it from racing Farm/Boss/Sea progression.
task.spawn(function()
    while SessionAlive() and task.wait(2) do
        if _G.Settings.GetFruits and _G.Settings.FruitEnabled then
            pcall(function()
                FruitManager:StoreBackpackFruits()
                FruitManager:TryRandomFruit()
            end)
        end
    end
end)



-- ══════════════════════════════════════════════════════════════════
--      v18.2 COMPACT-CONFIG MANAGERS — ALL EXPOSED KEYS ARE LIVE
-- ══════════════════════════════════════════════════════════════════

local function FindLiveNamed(names)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    for _, mob in ipairs(folder:GetChildren()) do
        for _, name in ipairs(names) do
            if IsEnemyNamed(mob, name) then
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local root = mob:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then return mob end
            end
        end
    end
end

local RainbowHakiController = { NextTry = 0 }
local RAINBOW_BOSSES = {"Stone","Island Empress","Kilo Admiral","Captain Elephant","Beautiful Pirate"}
function RainbowHakiController:TryRun()
    if not _G.Settings.RainbowHaki or GetSea() ~= 3 or Level() < MAX_LEVEL
        or not _G.State:CanAct() or tick() < self.NextTry then return false end
    self.NextTry = tick() + 8
    pcall(function() CommF_:InvokeServer("HornedMan", "Bet") end)
    local qtext = string.lower(tostring(GetQuestText() or ""))
    local wanted
    for _, name in ipairs(RAINBOW_BOSSES) do
        if qtext:find(string.lower(name),1,true) then wanted = name; break end
    end
    local boss = wanted and FindBoss(wanted) or FindLiveNamed(RAINBOW_BOSSES)
    if not boss then return false end
    local token = _G.State:ClaimAction("RainbowHaki")
    if token == 0 then return false end
    PrepareClaimedAction("RainbowHaki")
    task.spawn(function()
        local ok, err = xpcall(function()
            _G.State:SetMode("Bossing")
            _G.BobonStatus = "Rainbow Haki: " .. boss.Name
            local deadline = tick() + 240
            while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline and _G.State:IsTargetValid(boss) do
                local root = boss:FindFirstChild("HumanoidRootPart")
                if not root then break end
                TravelManager:Request(root, "RainbowHaki", {arrivalThreshold=_G.Settings.FarmArrivalThreshold,combatHover=true})
                if TravelManager:IsAtCombatAnchor(root) then EquipCombatTool(); Attack(boss, boss.Name) end
                task.wait(0.12)
            end
            pcall(function() CommF_:InvokeServer("HornedMan", "Bet") end)
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: RainbowHaki: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "RainbowHaki" then TravelManager:Stop("RainbowHakiComplete") end
        _G.State:ReleaseAction(token)
        if _G.State.Mode == "Bossing" then _G.State:SetMode("Idle") end
    end)
    return true
end

local IndraController = { NextTry = 0 }
local INDRA_COLORS = {
    {"Winter Sky", CFrame.new(-5420.16602,1084.9657,-2666.8208)},
    {"Pure Red",   CFrame.new(-5414.41357,309.865753,-2212.45776)},
    {"Snow White", CFrame.new(-4971.47559,331.565765,-3720.02954)},
}
function IndraController:TryRun()
    if not _G.Settings.AutoSpawnRipIndra or GetSea() ~= 3 or Level() < MAX_LEVEL
        or not _G.State:CanAct() or tick() < self.NextTry then return false end
    local live = FindBoss("rip_indra") or FindBoss("rip_indra True Form")
    if live then
        local token = _G.State:ClaimAction("Indra")
        if token == 0 then return false end
        PrepareClaimedAction("Indra")
        task.spawn(function()
            local ok, err = xpcall(function()
                _G.State:SetMode("Bossing")
                local deadline=tick()+300
                while _G.State:IsActionValid(token) and IsAlive() and tick()<deadline and _G.State:IsTargetValid(live) do
                    local root=live:FindFirstChild("HumanoidRootPart"); if not root then break end
                    TravelManager:Request(root,"Indra",{arrivalThreshold=_G.Settings.FarmArrivalThreshold,combatHover=true})
                    if TravelManager:IsAtCombatAnchor(root) then EquipCombatTool(); Attack(live,"rip_indra") end
                    task.wait(0.12)
                end
            end, debug.traceback)
            if not ok then warn("[BobonHub] Module Error: IndraFight: "..tostring(err)) end
            if _G.State.IsTraveling and _G.State.MovementOwner == "Indra" then TravelManager:Stop("IndraComplete") end
            _G.State:ReleaseAction(token)
            if _G.State.Mode == "Bossing" then _G.State:SetMode("Idle") end
        end)
        return true
    end
    if not FindOwnedTool("God's Chalice") then return false end
    self.NextTry = tick() + 60
    local token = _G.State:ClaimAction("Indra")
    if token == 0 then return false end
    PrepareClaimedAction("Indra")
    task.spawn(function()
        local ok, err = xpcall(function()
            _G.State:SetMode("Bossing")
            _G.BobonStatus = "rip_indra: Activating colors"
            for _, row in ipairs(INDRA_COLORS) do
                if not _G.State:IsActionValid(token) or not IsAlive() then return end
                pcall(function() CommF_:InvokeServer("activateColor", row[1]) end)
                TravelAndWait("Indra", token, row[2], {timeout=80,arrivalThreshold=8,settle=0.4})
            end
            if not EquipNamedTool("God's Chalice") then return end
            _G.BobonStatus = "rip_indra: Placing God's Chalice"
            TravelAndWait("Indra", token, CFrame.new(-5560.27,313.92,-2663.90), {timeout=80,arrivalThreshold=6,settle=1})
            task.wait(1.5)
            local spawned = FindBoss("rip_indra") or FindBoss("rip_indra True Form")
            if spawned then
                local deadline=tick()+300
                while _G.State:IsActionValid(token) and IsAlive() and tick()<deadline and _G.State:IsTargetValid(spawned) do
                    local root=spawned:FindFirstChild("HumanoidRootPart"); if not root then break end
                    TravelManager:Request(root,"Indra",{arrivalThreshold=_G.Settings.FarmArrivalThreshold,combatHover=true})
                    if TravelManager:IsAtCombatAnchor(root) then EquipCombatTool(); Attack(spawned,"rip_indra") end
                    task.wait(0.12)
                end
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Indra: "..tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Indra" then TravelManager:Stop("IndraComplete") end
        _G.State:ReleaseAction(token)
        if _G.State.Mode == "Bossing" then _G.State:SetMode("Idle") end
    end)
    return true
end

local FruitSniper = { LastTry = 0 }
function FruitSniper:Tick()
    local wanted = tostring(_G.Settings.SnipeFruit or "")
    if wanted == "" or tick() - self.LastTry < 5 or not IsAlive() then return false end
    self.LastTry = tick()
    pcall(function() CommF_:InvokeServer("GetFruits") end)
    local ok = pcall(function() CommF_:InvokeServer("PurchaseRawFruit", wanted, false) end)
    if ok then pcall(function() FruitManager:StoreBackpackFruits() end) end
    return ok
end
task.spawn(function() while SessionAlive() and task.wait(2) do pcall(function() FruitSniper:Tick() end) end end)

local function ApplyFPSBoost()
    if not _G.Settings.FPSBoostEnabled then return end
    pcall(function() if type(setfpscap)=="function" then setfpscap(_G.Settings.FPSCap or 30) end end)
    pcall(function() RunService:Set3dRenderingEnabled(not _G.Settings.FPSDisable3DRender) end)
    if _G.Settings.FPSHideGameUI then
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        if pg then for _, gui in ipairs(pg:GetChildren()) do if gui:IsA("ScreenGui") then pcall(function() gui.Enabled=false end) end end end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            pcall(function() obj.Enabled=false end)
        end
    end
end
task.defer(ApplyFPSBoost)

local HopManager = { LastHop = 0, Visited = {} }
local function FindDroppedFruit()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and string.find(string.lower(obj.Name), "fruit", 1, true) then return obj end
    end
end
local function CollectDroppedFruit(tool)
    if not tool or not tool.Parent then return false end
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    local me = HRP()
    if handle and me and type(firetouchinterest) == "function" then
        local ok = pcall(function()
            firetouchinterest(me, handle, 0)
            firetouchinterest(me, handle, 1)
        end)
        if ok then return true end
    end
    return false
end
local function MiragePresent()
    local map=workspace:FindFirstChild("Map")
    if not map then return false end
    for _, obj in ipairs(map:GetDescendants()) do
        local n=string.lower(obj.Name)
        if n:find("mirage",1,true) or n:find("mysticisland",1,true) or n:find("mystic island",1,true) then return true end
    end
    return false
end
function HopManager:FindServer()
    local cursor=""
    for _=1,4 do
        local url=("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s"):format(game.PlaceId,
            cursor~="" and ("&cursor="..HttpService:UrlEncode(cursor)) or "")
        local ok, body=pcall(function() return game:HttpGet(url) end)
        if not ok then return nil end
        local okj, data=pcall(function() return HttpService:JSONDecode(body) end)
        if not okj or type(data)~="table" then return nil end
        for _, row in ipairs(data.data or {}) do
            local id=tostring(row.id or "")
            if id~="" and id~=game.JobId and not self.Visited[id]
                and tonumber(row.playing or 0) < tonumber(row.maxPlayers or 12) then
                self.Visited[id]=true
                return id
            end
        end
        cursor=tostring(data.nextPageCursor or "")
        if cursor=="" then break end
    end
end
function HopManager:Request(reason)
    if tick()-self.LastHop < (_G.Settings.HopRequestCooldown or 25) then return false end
    self.LastHop=tick()
    local id=self:FindServer(); if not id then return false end
    _G.BobonStatus="Server Hop: "..tostring(reason)
    _G.State:SetMode("ServerHop")
    pcall(function() TravelManager:Stop("ServerHop") end)
    local ok=pcall(function() TeleportSvc:TeleportToPlaceInstance(game.PlaceId,id,LP) end)
    if not ok then _G.State:SetMode("Idle") end
    return ok
end
function HopManager:ShouldHop()
    local activeQuestFight = _G.Settings.ContestSuppressPlayerHop
        and _G.State.Mode == "Farming"
        and _G.State.ActiveActionToken == 0
        and _G.State.FarmTarget ~= nil
        and _G.State:IsTargetValid(_G.State.FarmTarget)
        and _G.State.ActiveQuestMob ~= nil
        and IsEnemyNamed(_G.State.FarmTarget, _G.State.ActiveQuestMob)
    -- "Hop Player Near" must not surrender a mob we are already farming.
    -- The option still works while idle/travelling outside an active quest fight.
    if _G.Settings.HopPlayerNear and not activeQuestFight then
        local me=HRP()
        if me then
            for _, p in ipairs(Players:GetPlayers()) do
                local pr=p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if pr and (pr.Position-me.Position).Magnitude <= (_G.Settings.HopPlayerNearRadius or 250) then return "player-near" end
            end
        end
    end
    if not _G.Settings.HopEnabled then return nil end
    local missing = {}
    local requested = 0

    if _G.Settings.HopFindFruit then
        requested = requested + 1
        local fruit = FindDroppedFruit()
        if fruit then CollectDroppedFruit(fruit); return nil end
        missing[#missing+1] = "fruit"
    end
    if GetSea()==3 and _G.Settings.HopElite then
        requested = requested + 1
        if FindLiveNamed({"Diablo","Deandre","Urban"}) then return nil end
        missing[#missing+1] = "elite"
    end
    if GetSea()==2 and _G.Settings.HopFindDarkbeard then
        requested = requested + 1
        if FindBoss("Darkbeard") then return nil end
        missing[#missing+1] = "darkbeard"
    end
    if GetSea()==3 and _G.Settings.HopFindMirage then
        requested = requested + 1
        if MiragePresent() then return nil end
        missing[#missing+1] = "mirage"
    end
    if GetSea()==3 and _G.Settings.HopFindMirrorFractal and not InventoryHas("Mirror Fractal") then
        requested = requested + 1
        if FindBoss("Dough King") then return nil end
        missing[#missing+1] = "mirror"
    end
    if GetSea()==3 and _G.Settings.HopFindSoulReaper then
        requested = requested + 1
        if FindBoss("Soul Reaper") then return nil end
        missing[#missing+1] = "reaper"
    end
    if GetSea()==3 and _G.Settings.HopFindTushita and not InventoryHas("Tushita") then
        requested = requested + 1
        if FindOwnedTool("Holy Torch") or FindBoss("rip_indra") or FindBoss("rip_indra True Form") then return nil end
        missing[#missing+1] = "tushita"
    end
    if GetSea()==3 and _G.Settings.HopFindValkyrieHelm and not InventoryHas("Valkyrie Helm") then
        requested = requested + 1
        if FindBoss("rip_indra") or FindBoss("rip_indra True Form") then return nil end
        missing[#missing+1] = "valkyrie"
    end
    if requested > 0 and #missing == requested then return "find:" .. table.concat(missing, ",") end
end
task.spawn(function()
    while SessionAlive() and task.wait(_G.Settings.HopCheckInterval or 8) do
        if _G.State.Mode~="Dead" and _G.State.Mode~="Respawning" and _G.State.Mode~="ServerHop" then
            local reason; pcall(function() reason=HopManager:ShouldHop() end)
            if reason then pcall(function() HopManager:Request(reason) end) end
        end
    end
end)

if _G.Settings.Shutdown then task.defer(function() task.wait(1); pcall(function() LP:Kick("BobonHub Shutdown=true") end) end) end

-- ══════════════════════════════════════════════════════════════════
--    MAIN CONTROLLER v16.2 FIXED — SINGLE LOOP
--
--   Priority: Recovery > Team > Valid Quest+Farm > Sea gate > Items > Boss
--   CHỈ gọi TravelManager:Request(), KHÔNG tự ghi MovementOwner
--   [FIX-2] Mỗi subsystem wrap pcall riêng + warn Module Error,
--           lỗi 1 module không chặn Quest/Farm
--   [FIX-9] Quest sai mob → tự re-request khi tới giver
--   [FIX-10] Chưa có quest → không farm, đi nhận quest trước
--   [FIX-3] Attack dùng khoảng cách XZ (hover trên đầu mob)
--   [FIX-6] FarmTarget invalid/qua xa/dưới biển → clear + về q.MC
--   [A-5] Farm state machine FState chạy trong loop DUY NHẤT này
-- ══════════════════════════════════════════════════════════════════
local lastAttackLog = 0
task.spawn(function()
    while SessionAlive() and task.wait(0.15) do
        -- Skip nếu subsystem đang giữ ActionToken
        if _G.State.ActiveActionToken ~= 0 then continue end
        if _G.State.Mode == "Recovering" or _G.State.Mode == "Dead"
            or _G.State.Mode == "Respawning" or _G.State.Mode == "ServerHop" then
            continue
        end
        if not IsAlive() then continue end


        local okMain, mainErr = pcall(function()
            _G.State.Sea = GetSea()

            -- Repair a stale travel flag before quest/farm logic.  A travel
            -- coroutine can finish between ticks; never let that leave the
            -- farm loop believing movement is still owned forever.
            if _G.State.IsTraveling and not TravelManager.ActiveThread then
                TravelManager:Stop("StaleTravel")
            elseif _G.State.IsTraveling and not _G.State.MovementOwner then
                TravelManager:Stop("MissingMovementOwner")
            end

            -- Team phải được xác nhận trước mọi remote/item/boss; nếu chưa có
            -- team thì không được bắt đầu một travel dang dở.
            if not TeamController:AutoSelectTeam() then
                _G.BobonStatus = "Team: Confirming " .. tostring(_G.Settings.Team or "Pirates")
                return
            end


            -- FARM-FIRST GATE: inspect the current level/quest before any
            -- optional progression.  A valid quest always wins, so item and
            -- boss routines cannot pull the player away mid-farm.
            local lv = Level()
            local questState = HasQuest() -- true / false / nil (UI not ready)
            if GetSea() == 3 and lv >= 2600 and lv < MAX_LEVEL
                and not SubmergedAccessController:IsInside() then
                local canAttemptEntrance = SubmergedAccessController.Confirmed
                    or questState == false
                local willInvokeEntrance = canAttemptEntrance
                    and SubmergedAccessController.PendingUntil <= 0
                    and tick() >= SubmergedAccessController.NextTry
                if willInvokeEntrance then
                    if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                        TravelManager:Stop("SubmergedEntranceStart")
                    end
                    FarmPositionController:ReleaseCluster()
                    _G.State:ClearTargets()
                end
                local accessState = SubmergedAccessController:Tick(canAttemptEntrance)
                if accessState == "pending" then
                    if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                        TravelManager:Stop("SubmergedEntrancePending")
                    end
                    FarmPositionController:ReleaseCluster()
                    _G.State:ClearTargets()
                    _G.BobonStatus = "Sea: Verifying Submerged entrance"
                    return
                end
            end
            local q = GetQ()


            if not q then
                FarmPositionController:ReleaseCluster()
                _G.State.ActiveQuestMob = nil
                _G.State:ClearTargets()
                if _G.State.IsTraveling
                    and _G.State.MovementOwner == "Farm" then
                    TravelManager:Stop("NoQuest")
                end
                -- At max level there is no next quest to create an item window.
                -- Continue end-game progression instead of becoming permanently Idle.
                local okEnd, endResult = pcall(function()
                    return ItemProgression:RunChecks(true, true)
                end)
                if okEnd and endResult then return end
                local okKata, kataResult = pcall(function()
                    return KatakuriController:TryRun()
                end)
                if not okKata then
                    warn("[BobonHub] Module Error: KatakuriController: " .. tostring(kataResult))
                elseif kataResult then
                    return
                end
                local okBossEnd, bossEnd = pcall(function()
                    return BossManager:TryFightBoss()
                end)
                if okBossEnd and bossEnd then return end
                local meleeBusy = false
                pcall(function() meleeBusy = FightingStyleController:Tick() == true end)
                if not meleeBusy then pcall(function() SwordProgressionController:Tick() end) end
                _G.State:SetMode("Idle")
                _G.BobonStatus = "Max Level: Progression waiting"
                return
            end

            -- Keep one canonical mob name for the quest wrapper that is
            -- currently active. On re-execution, adopt it only when the UI
            -- contains an exact QDB mob name. A localized/unreadable wrapper
            -- is still safe to farm by level, but bring stays disabled until
            -- this session accepts the next quest and knows its exact mob.
            if questState == false then
                FarmPositionController:ReleaseCluster()
                _G.State.ActiveQuestMob = nil
            elseif questState == true then
                local resolvedMob = ResolveQuestMobFromText()
                if resolvedMob then
                    local cachedMob = _G.State.ActiveQuestMob
                    if cachedMob and string.lower(tostring(cachedMob))
                        ~= string.lower(tostring(resolvedMob)) then
                        FarmPositionController:ReleaseCluster()
                        _G.State:ClearTargets()
                        if _G.State.IsTraveling
                            and _G.State.MovementOwner == "Farm" then
                            TravelManager:Stop("QuestIdentityChanged")
                        end
                        DLog("QUEST", "Active quest changed: "
                            .. tostring(cachedMob) .. " -> " .. resolvedMob)
                    end
                    _G.State.ActiveQuestMob = resolvedMob
                    if not cachedMob then
                        DLog("QUEST", "Adopted active quest mob: " .. resolvedMob)
                    end
                elseif not _G.State.ActiveQuestMob then
                    FarmPositionController:ReleaseCluster()
                    _G.BobonDiagnostics.Bring = "QUEST-UNKNOWN"
                    DLog("QUEST", "Active quest name unreadable; bring disabled")
                end
            end


            -- Fast Sea 1 route runs before the normal quest gate.  It keeps
            -- the level-skip behavior deterministic and still uses the same
            -- TravelManager, target validation, attack gate and watchdog.
            -- Never let the fast skip route interrupt an accepted quest. It
            -- previously activated right after the first verified hits, which
            -- looked exactly like "attacks briefly, then stops/leaves".
            local earlySkipLevel = GetSea() == 1 and Level() >= 10 and Level() <= 70
            if earlySkipLevel and SkipRouteController:Run() then
                return
            elseif not earlySkipLevel then
                SkipRouteController:Reset("outside early skip range")
            end


            -- ═══ QUEST HANDLING (FIX-P2/P3) ═══
            local questMatch = QuestMatches(q.M)
            -- [G-6] Farm khi wrapper quest đang mở VÀ match KHÔNG bị xác
            -- nhận là SAI (nil = UI đổi cấu trúc sau update, đọc không ra
            -- title). Bản cũ đòi match == true nên nil khiến bot kẹt
            -- re-request quest vô hạn → không farm, không gom, không đánh.
            local hasQuest = questState == true and questMatch ~= false
            -- Right after StartQuest, some UI builds briefly hide/rebuild the
            -- Quest wrapper. Do not cancel the accepted quest and fly back to
            -- the giver during that short transition.
            if not hasQuest and questMatch ~= false
                and _G.State.LastQuestAccepted > 0
                and tick() - _G.State.LastQuestAccepted
                    <= (_G.Settings.QuestAcceptGrace or 6) then
                hasQuest = true
            end
            local questOk = hasQuest
            local questMobName = _G.State.ActiveQuestMob or q.M

            -- Quest-first invariant: quest vừa hết, bị mất, sai mob, hoặc UI
            -- không còn xác nhận được đều phải quay lại giver ngay trong tick
            -- này.  Dừng target/travel cũ trước để không bay tiếp tới mob cũ.
            if not hasQuest then
                local okSea, seaResult = pcall(function()
                    -- Sea gates vẫn là bắt buộc ở level 700/1500; optional
                    -- item/boss tuyệt đối không được chen vào giữa quest.
                    return ItemProgression:RunChecks(true, false)
                end)
                if not okSea then
                    warn("[BobonHub] Module Error: ItemProgression: " .. tostring(seaResult))
                elseif seaResult then
                    return
                end

                -- A confirmed closed quest is the only safe window for
                -- optional kaitun items/boss drops. The old placement was
                -- below this return path, so Saber/Pole/BossManager were
                -- logically unreachable and never ran at all.
                -- The wrapper is authoritative here. A completed quest can
                -- leave stale title text behind, so questMatch may still be
                -- true even though there is no active quest.
                local safeItemWindow = questState == false
                if safeItemWindow then
                    local okIndra, indraResult = pcall(function() return IndraController:TryRun() end)
                    if okIndra and indraResult then return end
                    local okRainbow, rainbowResult = pcall(function() return RainbowHakiController:TryRun() end)
                    if okRainbow and rainbowResult then return end
                    local okItems, itemResult = pcall(function()
                        return ItemProgression:RunChecks(true, true)
                    end)
                    if not okItems then
                        warn("[BobonHub] Module Error: ItemProgression: " .. tostring(itemResult))
                    elseif itemResult then
                        return
                    end

                    local okBoss, bossResult = pcall(function()
                        return BossManager:TryFightBoss()
                    end)
                    if not okBoss then
                        warn("[BobonHub] Module Error: BossManager: " .. tostring(bossResult))
                    elseif bossResult then
                        return
                    end
                end

                FarmPositionController:ReleaseCluster()
                _G.State:ClearTargets()
                -- Request(q.QC) below atomically replans a stale Farm goal.
                -- Do not destroy/recreate BodyMovers every 0.15 seconds.
                _G.State:SetMode("GettingQuest")
                _G.BobonStatus = "Quest: Refreshing " .. q.M
                DLog("QUEST", "Quest missing/complete/wrong → refresh " .. q.M)
                local hrp = HRP()
                local atGiver = hrp and (hrp.Position - q.QC.Position).Magnitude <= _G.Settings.CloseThreshold
                if HandleQuestAtGiver(q, atGiver) then
                    return
                end
                TravelManager:Request(q.QC, "Farm")
                return
            end

            -- QUEST + FARM (primary progression from level 1 to max)

            if hasQuest and questOk ~= false then
                -- Quest hợp lệ (true) hoặc nil = UI không đọc được nhưng vừa
                -- request gần đây → cho farm trong khoảng grace ngắn
                if questOk == nil then
                    local gNow = tick()
                    if gNow - _G.State.LastQuestRequest >= _G.Settings.QuestDelay then
                        -- Không đọc được UI lâu → về giver verify lại, KHÔNG farm
                        _G.State:SetMode("GettingQuest")
                        _G.BobonStatus = "Quest: Verifying " .. q.M
                        local atGiver = HRP() and (HRP().Position - q.QC.Position).Magnitude <= _G.Settings.CloseThreshold
                        if HandleQuestAtGiver(q, atGiver) then
                            return
                        else
                            TravelManager:Request(q.QC, "Farm")
                            return
                        end
                    end
                end
                _G.State.QuestRetries = 0
            else
                -- [FIX-10] Chưa có quest hoặc [FIX-9] quest sai mob:
                -- CHỈ đi lấy/đổi quest, KHÔNG farm
                _G.State:SetMode("GettingQuest")
                DLog("QUEST", "Missing or wrong quest → going to giver for " .. q.M)
                local hrp = HRP()
                local atGiver = hrp and (hrp.Position - q.QC.Position).Magnitude <= _G.Settings.CloseThreshold
                if HandleQuestAtGiver(q, atGiver) then
                    return
                else
                    _G.BobonStatus = "Quest: Traveling to " .. q.M
                    TravelManager:Request(q.QC, "Farm")
                    return
                end
            end


            -- ═══ FARM CONTROLLER — state machine (1 loop duy nhất) [A-5] ═══
            -- FState: IDLE→CHECK_CHARACTER→CHECK_SEA→SELECT_TARGET→
            -- MOVE_TO_TARGET→ATTACK→VERIFY_TARGET→NEXT_TARGET
            _G.State:SetMode("Farming")

            -- CHECK_CHARACTER
            _G.State.FState = "CHECK_CHARACTER"
            DLog("FARM", "State = CHECK_CHARACTER")
            if not IsAlive() then return end

            -- CHECK_SEA + TEAM (cooldown, không spam, không chặn farm lâu)
            _G.State.FState = "CHECK_SEA"
            DLog("FARM", "State = CHECK_SEA")
            _G.State.Sea = GetSea()
            if not TeamController:AutoSelectTeam() then
                _G.BobonStatus = "Team: Selecting Pirates"
                return
            end

            -- v18.7 QUEST CLUSTER: q.MC is the stable spawn-area anchor.
            -- A mob death no longer destroys the cluster or forces player travel.
            ClusterFarmController:Activate("QUEST", {questMobName}, q.MC, "Farm")
            ClusterFarmController:Tick()

            local anchorHeight = (CombatController:IsFastReady()
                or not CombatController:WantsClientRange())
                and (_G.Settings.FarmHeight or 15)
                or (_G.Settings.ClientHoverHeight or 5)
            local hoverCF = ClusterFarmController:GetHoverCFrame(anchorHeight)

            -- VERIFY/PROMOTE: first prefer a verified mob already stacked at the
            -- persistent anchor. Killing the old primary simply promotes another.
            _G.State.FState = "VERIFY_TARGET"
            local contested = _G.State:IsTargetValid(_G.State.FarmTarget)
                and IsEnemyNamed(_G.State.FarmTarget, questMobName)
                and IsFarmTargetContested(_G.State.FarmTarget)
            if not contested then
                local promoted = ClusterFarmController:SelectPrimary()
                if promoted then
                    _G.State.FarmTarget = promoted
                    _G.State.CurrentTarget = promoted
                    _G.State.ClusterPrimary = promoted
                elseif not _G.State:IsTargetValid(_G.State.FarmTarget)
                    or not IsEnemyNamed(_G.State.FarmTarget, questMobName) then
                    _G.State.FarmTarget = nil
                    _G.State.CurrentTarget = nil
                end
            end

            local target = _G.State.FarmTarget
            local targetRoot = target and target:FindFirstChild("HumanoidRootPart")
            local hrp = HRP()

            -- Keep player parked above the stable anchor whenever a clustered
            -- target exists. This is the fast path observed in the showcase.
            local verifiedClusterTarget = target and ClusterFarmController:IsVerified(target)
            if hoverCF and verifiedClusterTarget and not contested then
                _G.State.FState = "MOVE_TO_CLUSTER"
                if _G.State:CanRequestTravel() then
                    TravelManager:Request(hoverCF, "Farm", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        fallback = q.MC,
                        combatHover = true,
                        persistent = true,
                    })
                end
            elseif target and targetRoot and hrp then
                -- Contest/fallback path: never surrender a live quest mob another
                -- player is attacking. Chase it while preserving the cluster anchor.
                local targetPos = targetRoot.Position
                local dist = (hrp.Position - targetPos).Magnitude
                local normalTooFar = dist > _G.Settings.MaxFarmDistance + 50
                local contestTooFar = dist > (_G.Settings.ContestChaseDistance or 900)
                if not IsAllowedWorldPosition(targetPos)
                    or (normalTooFar and (not contested or contestTooFar)) then
                    _G.State.FarmTarget = nil
                    _G.State.CurrentTarget = nil
                else
                    PrepareCombatTarget(target)
                    _G.State.FState = contested and "CONTEST_TARGET" or "ACQUIRE_TARGET"
                    if _G.State:CanRequestTravel() then
                        TravelManager:Request(targetRoot, "Farm", {
                            arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                            fallback = hoverCF or q.MC,
                            combatHover = true,
                        })
                    end
                end
            else
                -- Give the anchor a short ownership-acquisition window before
                -- chasing a spawn. The anchor itself is never released here.
                if hoverCF and _G.State:CanRequestTravel() then
                    TravelManager:Request(hoverCF, "Farm", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        fallback = q.MC,
                        combatHover = true,
                        persistent = true,
                    })
                end
                if tick() - (_G.State.ClusterActivatedAt or 0)
                    > (_G.Settings.ClusterAcquireGrace or 1.75) then
                    local mob, dist = FindNearestMob(questMobName)
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        _G.State.FarmTarget = mob
                        _G.State.CurrentTarget = mob
                        PrepareCombatTarget(mob)
                        if (_G.State.ClusterLastMoved or 0) == 0
                            and dist <= _G.Settings.MaxFarmDistance
                            and _G.State:CanRequestTravel() then
                            TravelManager:Request(mob.HumanoidRootPart, "Farm", {
                                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                                fallback = hoverCF or q.MC,
                                combatHover = true,
                            })
                        end
                    end
                end
            end

            -- ATTACK: verified cluster roots are stacked inside one XZ pocket.
            -- Primary death does not reset backend verification or cluster anchor.
            target = _G.State.FarmTarget
            targetRoot = target and target:FindFirstChild("HumanoidRootPart")
            hrp = HRP()
            if target and targetRoot and hrp and _G.State:IsTargetValid(target) then
                PrepareCombatTarget(target)
                local flatDist = (Vector3.new(hrp.Position.X,0,hrp.Position.Z)
                    - Vector3.new(targetRoot.Position.X,0,targetRoot.Position.Z)).Magnitude
                local farmHolds = not _G.State.IsTraveling or _G.State.MovementOwner == "Farm"
                if flatDist <= _G.Settings.AttackRange and farmHolds
                    and TravelManager:IsAtCombatAnchor() then
                    _G.State.FState = "ATTACK_CLUSTER"
                    EquipCombatTool()
                    Attack(target, questMobName)
                    if os.time() - lastAttackLog >= 5 then
                        lastAttackLog = os.time()
                        DLog("ATTACK", "Cluster target: " .. target.Name)
                    end
                end
            else
                _G.BobonStatus = "Farm: Waiting for " .. questMobName .. " spawn"
            end
        end)
        if not okMain then
            FarmPositionController:ReleaseCluster()
            _G.State:ClearTargets()
            if _G.State.IsTraveling
                and _G.State.MovementOwner == "Farm" then
                TravelManager:Stop("MainControllerError")
            end
            warn("[BobonHub] Module Error: MainController: " .. tostring(mainErr))
        end
    end
end)
-- ══════════════════════════════════════════════════════════════════
--              TEAM + HAKI INIT (Fix #14 / [A-1] TeamController)
-- ══════════════════════════════════════════════════════════════════
task.spawn(function()
    -- Chạy ngay sau bootstrap; không đợi character vì ChooseTeam thường
    -- được tạo trước HumanoidRootPart.
    for _ = 1, 30 do
        if TeamController:AutoSelectTeam() then break end
        task.wait(0.25)
    end
    if LP.Team then
        _G.BobonStatus = "Team: " .. LP.Team.Name .. " ✓"
        DLog("TEAM", "Verified team: " .. LP.Team.Name)
    end
    task.wait(0.5)
    if HakiController:EnableForCharacter() then
        _G.BobonStatus = "Haki: ON ✓"
    else
        _G.BobonStatus = "Haki: Waiting for character"
    end
    task.wait(0.5)
    _G.State:SetMode("Idle")
end)

-- ══════════════════════════════════════════════════════════════════
--              BACKGROUND SYSTEMS (Fix #15,#16,#17,#18)
--   TUYỆT ĐỐI KHÔNG background loop nào điều khiển movement
--   Remote calls có cooldown/batch limit, không spam
--   pcall wrap mọi remote, lỗi không ảnh hưởng main loop
-- ══════════════════════════════════════════════════════════════════


-- Anti-AFK (Fix #16)
LP.Idled:Connect(function()
    if not SessionAlive() then return end
    pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
end)


-- Do not mutate Tool.Handle. Enlarging every melee/sword handle to 50 studs
-- and hiding it can invalidate the live Tool controller and was shared by all
-- weapons, which is why Combat, other melee styles and swords failed alike.
-- Enemy-side target preparation already supplies the local acquisition box.


-- Auto Stats batch limit (Fix #15 / FIX-P7)
-- Giữ batch limit, Points=0 → không làm gì, lỗi remote không ảnh hưởng
-- Farm. KHÔNG tạo ActionToken cho background stat.
task.spawn(function()
    while SessionAlive() and task.wait(3) do
        if not _G.Settings.AutoStats then continue end
        pcall(function()
            local d = LP:FindFirstChild("Data")
            if not d then return end
            local pts = d:FindFirstChild("Points") and d.Points.Value or 0
            if pts <= 0 then return end
            local batch = math.min(pts, _G.Settings.StatBatchLimit)
            local meleeAdd = math.floor(batch * 0.7)
            local defAdd = batch - meleeAdd
            if meleeAdd > 0 then CommF_:InvokeServer("AddPoint","Melee",meleeAdd) end
            if defAdd > 0 then CommF_:InvokeServer("AddPoint","Defense",defAdd) end
        end)
    end
end)


-- Kill Counter (Fix #18)
local function HookMob(mob)
    if not mob then return end
    local h = mob:FindFirstChild("Humanoid")
    if h and not h:GetAttribute("BHooked") then
        h:SetAttribute("BHooked", true)
        h.Died:Connect(function()
            if not SessionAlive() then return end
            -- Count only a mob this kaitun was actively tracking. The old hook
            -- incremented for every NPC death in workspace.Enemies, including
            -- kills made by other players elsewhere in the server.
            if _G.State.FarmTarget == mob or _G.State.CurrentTarget == mob then
                _G.State.KillCount = _G.State.KillCount + 1
            end
        end)
    end
end


task.spawn(function()
    local function Watch()
        local f = workspace:FindFirstChild("Enemies")
        if not f then return end
        for _, mob in ipairs(f:GetChildren()) do HookMob(mob) end
        f.ChildAdded:Connect(function(mob)
            if not SessionAlive() then return end
            task.wait(0.1)
            if SessionAlive() then HookMob(mob) end
        end)
    end
    Watch()
    if not workspace:FindFirstChild("Enemies") then
        workspace.ChildAdded:Connect(function(c)
            if not SessionAlive() then return end
            if c.Name == "Enemies" then task.wait(0.3); Watch() end
        end)
    end
end)
-- ══════════════════════════════════════════════════════════════════
--                   FINAL INITIALIZATION
-- ══════════════════════════════════════════════════════════════════
_G.State.Sea = GetSea()
_G.State.StartTime = os.time()

-- Future executions call this hook before replacing the session. It releases
-- physics/movement and destroys the old overlay instead of leaving duplicate
-- farm controllers alive in the same Roblox process.
_G.BobonUnload = function()
    if not SessionAlive() then return end
    _G.BobonSessionID = SessionID + 1
    pcall(function() TravelManager:Stop("Reexecute") end)
    pcall(function() CombatController:Cleanup() end)
    pcall(function() if FruitManager then FruitManager.Busy = false end end)
    pcall(function() FarmPositionController:ReleaseCluster() end)
    pcall(function() BindPlayerDamage(nil, nil) end)
    pcall(function() if SG and SG.Parent then SG:Destroy() end end)
end


print("[BobonHub v18.7 FULL-BATCH CLUSTER + TEDDY SKIP] Full Script Loaded Successfully!")
print("[BobonHub v18.7 FULL-BATCH CLUSTER + TEDDY SKIP] Architecture: Persistent Travel | ActionToken | Single Owner")
print("[BobonHub v18.7 FULL-BATCH CLUSTER + TEDDY SKIP] Core: TravelManager(v7+P1) | StateManager(v7) | RecoveryManager(v7+P10)")
print("[BobonHub v18.7 FULL-BATCH CLUSTER + TEDDY SKIP] Modules: QuestFarm | Health-Verified Combat | Ownership Bring | FruitManager | Responsive Glass HUD")
print("[BobonHub v18.7 FULL-BATCH CLUSTER + TEDDY SKIP] Progression: Farm 1-2800 | Sea2/3 | Saber/Pole/Rengoku/Yama/Tushita/CDK | RaceV2 | Styles | Soul Guitar | Katakuri/Dough King | Continuity")
print("[BobonHub v18.7 FULL-BATCH CLUSTER + TEDDY SKIP] Data: Sea1/2/3 QDB 1-2800 | Submerged | Boss/item catalog")
print("[BobonHub v18.7 FULL-BATCH CLUSTER + TEDDY SKIP] Sea: " .. _G.State.Sea .. " | Level: " .. Level())
