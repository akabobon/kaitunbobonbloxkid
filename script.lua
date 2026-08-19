-- =================================================================
--         BOBON HUB v22.20 SKILL-EFFECT-ONLY DODGE | TEDDY v22.17 LOCKED
--         Base: v22.19.1 EXEC-SAFE QUEST-FIRST
--  [D220-1] Dodge NEVER triggers from raw damage, stun/busy, root velocity, or animation alone.
--  [D220-2] Cast animation only arms source correlation; movement starts only after a real
--           slash/projectile/beam/blast effect emitted by the active NPC is observed.
--  [D220-3] Effect must belong to the active target and overlap the player or travel toward the player.
--  [D220-4] Dodge is one short sidestep pulse. No repeated dodge movement can fight Teddy bring/acquire.
--  [D220-5] Teddy bring blocks are byte-identical to v22.19.1.
-- =================================================================
-- =================================================================
--         BOBON HUB v22.19.1 EXEC-SAFE QUEST-FIRST | TEDDY v22.17 LOCKED
--         Base: v22.17; NO new top-level locals (Luau chunk local-pressure safe)
--  [Q191-1] Quest completion/hidden wrapper stops farm immediately.
--  [Q191-2] Quest accept/rebuild grace applies only to unreadable UI, never confirmed closed UI.
--  [Q191-3] Quest giver travel uses <= QuestInteractDistance and persistent=false.
--  [Q191-4] No optional detour between quest completion and the next StartQuest.
--  [Q191-5] SharedTeddyRestack / TeddySequenceFarmTick / SharedFarmTick are untouched.
-- =================================================================
-- =================================================================
--         BOBON HUB v22.17 TEDDY SEQUENCE REBASE | STABLE-ANCHOR ACQUIRE
--         Deep rebase from v22.16 after side-by-side Roblox(22) vs Teddy reference.
--  [TS17-1] Teddy sequence is now explicit: SCAN -> ACQUIRE -> REAL HP TAG -> SNAP -> VERIFY -> KILL.
--  [TS17-2] The pile is FIXED at the farm-field anchor; it never follows the player during acquire.
--  [TS17-3] Already stacked mobs stay pinned while Farm flies to the next unstacked mob.
--  [TS17-4] A mob is not accepted into the pile merely because CFrame assignment returned; one-write persistence is verified.
--  [TS17-5] While acquiring the next mob, fast attack stays live and verified pile members remain eligible for fanout.
--  [TS17-6] Normal quest farm and early Skip Lv10-70 use the same Teddy sequence engine.
-- =================================================================
-- =================================================================
--         BOBON HUB v22.16 | TEDDY HP-PROOF ACQUIRE STACK + UI ALIGN
--         One Brain | Single Movement Owner | ActionToken | Combat-First Farm
--         Base: v22.15 TEDDY HP-TAG STACK | Version: v22.16
--
--
--
--
--  v22.16 HP-PROOF -> CLOSE ACQUIRE -> HARD STACK + UI ALIGN:
--  [TH16-1] After REAL HP loss, Farm closes to that exact mob before pull.
--  [TH16-2] Ownership API false/unknown no longer vetoes the pull attempt; only
--           real position persistence may promote a mob to STACKED.
--  [TH16-3] STACKED mobs use a moving under-foot BodyPosition hold at a short fixed depth;
--           pile depth is independent of travel hover. Server snap-back revokes STACKED.
--  [TH16-4] Teddy hold restores Humanoid/part state on release/route change.
--  [UI16-1] Rebalanced header/stat/runtime/checker geometry and removed stat gaps.
--  [UI16-2] Status Checker labels are forced to canonical English every refresh.
--  [UI16-3] Left toggle is a true circular mascot button; inner logo is circular.
--
--  v22.15 TEDDY HP-TAG -> STACK (REFERENCE USER FLOW):
--  [TH15-1] Fly to ONE live mob at a time and keep attacking that exact model until
--           a causal REAL Humanoid HP decrease is observed. No HP loss = no bring.
--  [TH15-2] After HP proof, enter PULL phase for that exact mob. Only then may its
--           root be moved into the moving under-foot pile.
--  [TH15-3] A mob is marked STACKED only after its root physically remains inside
--           the under-foot pile radius for a short persistence window. Visual-only
--           snap-back never counts as success.
--  [TH15-4] Already STACKED mobs are restacked under the player while the player
--           flies to the next unproven mob: hit -> real HP loss -> pull -> next.
--  [TH15-5] New respawns automatically re-enter the HIT phase. Skip Lv10-70 and
--           normal leveling share the exact same HP-tag Teddy engine.
--
--  v22.14 TEDDY AIR-SWEEP (REFERENCE Screen_Recording_20260818_004315_Roblox):
--  [TA-1] Stop parking above one fixed q.MC pile. The reference keeps flying around the live spawn field.
--  [TA-2] Attack stays active while Farm-owned travel is moving; no descend / wait-for-pile phase.
--  [TA-3] Every tick snapshots ALL matching live mobs and rotates the air sweep through live roots.
--  [TA-4] Physical bring is opportunistic only after the player is near / owns physics; never freezes Humanoid.
--  [TA-5] Movable mobs are pulled to a moving under-foot pile; explicit server-owned roots are never ghost-pinned.
--  [TA-6] Multi-target remote fanout admits fresh Teddy-air roots inside the true current attack range.
--  [TA-7] Skip Lv10-70 uses this exact same continuous Teddy air-sweep engine.
--
--  v22.13 TEDDY FULL-BATCH BRING (VIDEO Roblox(21) + old Teddy behavior):
--  [T23-1] Normal level farm + Sea1 skip no longer center the pile on the current
--          victim. One fixed field anchor survives target death exactly like the
--          earlier Teddy-style Bobon farm.
--  [T23-2] Snapshot ALL matching live mobs in the active field BEFORE moving any;
--          then restack the complete batch to the exact same anchor in one pass.
--  [T23-3] Heartbeat keeps the latest whole batch pinned to that anchor while a
--          0.03s rescan adds new respawns. No BodyPosition, ChangeState(14),
--          WalkSpeed=0, ownership gate, probe wave, or per-mob queue.
--  [T23-4] Primary is only the representative damage target. Switching/dying primary
--          never relocates or releases the pile.
--  [T23-5] Shared fan-out accepts only roots that the Teddy batch actually restacked
--          at the live anchor recently; no visual-only proximity admission.
--  [T23-6] SharedPrimaryNoDamage release loop is disabled for Teddy mode so a single
--          bad victim cannot tear down the whole pile every few seconds.
--
--  v22.12 CLASSIC BN BRING REBASE (replaces v22.11.1 direct magnet):
--  [V22.11.1-1] Built from the last execute-safe v22.10 base. No new top-level local
--                controller is added, avoiding a possible Luau chunk/local-register compile limit.
--  [V22.11.1-2] Early Skip Lv10-70 uses a compact same-frame direct magnet stored on
--                SkipRouteController instead of the strict HP-proof ACQUIRE/KILL bring.
--  [V22.11.1-3] Secondaries are repeatedly CFramed onto ONE real primary after requesting
--                simulation radius; no PlatformStand/Sit freeze and no BodyPosition objects.
--  [V22.11.1-4] Combat fan-out accepts only same-frame magnet-marked skip mobs, bypassing
--                the old isnetworkowner false/unknown gate that caused 1/6 -> 2/6 -> 0/6.
--  [V22.11.1-5] Normal quest/item/raid bring remains unchanged. Magnet failure is pcall-contained
--                so it cannot stop the whole kaitun/UI from loading.
--
--  v22.10 VIDEO 18/19 REVIEW FIXES:
--  [V22.10-1] Early skip is now ACQUIRE-FIRST / KILL-SECOND. It no longer attacks one
--              Sky Bandit/God's Guard while the rest of the floor is still being gathered.
--  [V22.10-2] Skip uses a longer dedicated acquire window and longer kill slice, reducing
--              the 3/6 -> 2/6 phase flicker seen in the supplied recordings.
--  [V22.10-3] Skip status now distinguishes Gathering pile vs Attacking pile using live
--              verified/total counts instead of the misleading "Gathering + attacking" text.
--  [V22.10-4] Intro moving-logo object is destroyed after landing and the intro container
--              is destroyed after fade, preventing a stale duplicate overlay.
--  [V22.10-5] Stats strip has an opaque backing plate so no bright game gaps show between cards.
--              Status Checker labels remain English.
--
--  v22.9 COMPACT UI + EARLY SKIP RESTORED:
--  [V22.9-1] Compacts/centers the four live stat cards, reduces internal whitespace,
--             makes cards/runtime nearly opaque so bright Roblox panels do not show through seams.
--  [V22.9-2] Normalizes localized empty-fruit text (including "Không có") to English "NONE".
--  [V22.9-3] Restores Sea 1 Lv10-70 skip startup without waiting for FastReady.
--             Normal verified combat bootstraps the route; fast combat takes over once HP-proven.
--  [V22.9-4] Skip still uses ClusterFarmController/Bring Mobs and keeps the existing no-progress fallback.
--
--  v22.8 APPROVED CAT UI + REAL STATUS:
--  [V22.8-1] Replaces Ember HUD with the approved dark-glass/cyan BobonHub layout.
--             Intro, header and left toggle use one embedded mascot asset, so the logo is identical.
--  [V22.8-2] Intro uses a rounded glass frame, per-letter BOBONHUB reveal, typed KAITUN SYSTEM,
--             slower loader, and one-shot mascot merge into the header icon; no permanent halo/ring.
--  [V22.8-3] Status Farm and Status Item are derived from live _G.State/_G.BobonStatus.
--             Item status does not invent completion; idle fallback reports the first actually missing item.
--  [V22.8-4] Status Checker reads Backpack/Character plus server getInventory/getInventoryWeapons.
--             Red=missing, yellow=currently active, green=verified owned. Pull Lever turns green only
--             when an explicit live Data/attribute lever flag is observable; no guessed completion.
--  [V22.8-5] Level/Beli/Fragments/Fruit/runtime are live account values; changes pulse/transition.
--             Main farm/combat/progression/economy logic from v22.7 is unchanged.
--
--  v22.7 PUBLIC-SOURCE SAFE MERGE:
--  [V22.7-1] Adds a clean-room target-aware MasteryAimController inspired by public
--             RedZ mastery targeting. No global __namecall/hookmetamethod is installed.
--  [V22.7-2] Aim state exposes both Vector3 AimbotPos and CFrame AimPos compatibility
--             while optionally moving the virtual mouse only when the target is on-screen.
--  [V22.7-3] Quest interaction uses a tight dedicated radius instead of the general
--             CloseThreshold, reducing StartQuest calls from too far away.
--  [V22.7-4] Existing Bobon Haki, FruitFinder, tool selection, bring, travel and scheduler
--             remain authoritative because they are already stricter than the public source.
--  [V22.7-5] No RedZ global hooks, chest loops, movement loops or UI code are copied.
--
--  v22.6 KAITUN INTEGRATION:
--  [V22.6-1] Shared secondary fan-out rejects explicit server-owned roots immediately and
--             clears stale HP/probe authority when ownership flips false.
--  [V22.6-2] Shared primary no-damage watchdog: real target HP must move during a sustained
--             attack window; otherwise release visual bring, rotate the stale backend and retry.
--  [V22.6-3] RaceAbilityController reuses the existing passive Haki loop to activate V3/V4
--             without creating a movement worker or fighting the Priority Scheduler.
--  [V22.6-4] MasterySkillController adds bounded Z/X/C/V/F skill rotation only while Bobon is
--             intentionally training a preferred/mastery tool; normal level melee stays unchanged.
--  [V22.6-5] Low-health safety is a separate kaitun option from raw-damage ignore/dodge.
--             MaterialPrep, Haki/Observation, progression, economy and v22.5 HP-proof waves remain intact.
--
--  v22.5 BRING HP-PROOF WAVE FIX:
--  [V22.5-1] Owned secondary mobs are hard-snapped only once when their mover is created;
--             later ticks update BodyPosition only, avoiding 30+ client CFrame rewrites/sec.
--  [V22.5-2] Unknown-owner secondary mobs are admitted in small probe waves. A one-shot visual
--             pull may be attacked briefly, but it is NOT held as a real stack until its own HP drops.
--  [V22.5-3] Exact aggregate HP proof promotes that exact secondary root to SHARED-HP-PROVEN.
--             No HP delta / server snap-back releases the mover and starts a short retry cooldown.
--  [V22.5-4] Shared fan-out attacks only PRIMARY / network-owned / HP-proven / active-probe mobs.
--             A visual pile alone can no longer make a ghost/statue mob a permanent attack target.
--  [V22.5-5] Keeps v22.4 Submerged target, Electric Claw, and acquireSweep fixes unchanged.
--
--  v22.4 CORE STABILITY FIXES:
--  [V22.4-1] SharedSelectTarget now accepts valid Submerged Island mobs instead of
--             rejecting every negative-Y quest victim after verified submarine entry.
--  [V22.4-2] Sea 3 Electric Claw purchase uses electroM consistently; removes the
--             nil >= 400 runtime error that aborted PurchaseTick before later styles.
--  [V22.4-3] TravelManager preserves acquireSweep in normalized options so field/acquire
--             sweeps keep their intended low hover profile and same-owner retarget semantics.
--  [V22.4-4] Existing gacha-first economy ordering, combat-first Shared farm, safe soft-bring,
--             quest/progression scheduler, damage-continuity dodge, and Submerged access remain intact.
--
--  v22.2 MULTI-FRUIT SNIPE:
--  [S22.2-1] External ["Snipe Fruit"] accepts either one string or an ordered list.
--  [S22.2-2] Priority order is preserved; the sniper checks live GetFruits stock when available.
--  [S22.2-3] Purchase success is verified by Beli/tool change before stopping the list, avoiding
--             a pcall-success false positive that previously prevented fallback to the next fruit.
--
--
--  v22.1 SAFE SOFT-BRING / STATUE ROOT FIX:
--  [B22.1-1] Removes Humanoid ChangeState(14)=PlatformStanding from normal quest bring.
--            Bring must never turn a live NPC into a locally frozen statue.
--  [B22.1-2] Removes WalkSpeed=0 and descendant CanTouch/CanQuery suppression from SharedBring.
--            The authoritative target remains a normal live server Humanoid throughout combat.
--  [B22.1-3] Secondary mobs use ownership-aware SOFT bring. Known-owned roots may be moved/held;
--            explicit server-owned roots stay at their real position and remain valid combat targets.
--  [B22.1-4] Unknown ownership gets one non-freezing persistence probe. Snap-back blocks further
--            visual magnet attempts briefly instead of repeatedly creating ghost/statue mobs.
--  [B22.1-5] BringMoved now counts only actually soft-moved/verified roots, not every candidate.
--            Combat remains authoritative when BringMoved=0; target handoff never waits for magnet.
--  [B22.1-6] Primary target is always restored/released from any old mover before attacking.
--
--  v22.0 GOAL-DRIVEN CORE REBUILD (6-PART REFERENCE STUDY):
--  [V22-1] Farm ACTION and long-term OBJECTIVE are separate state. Level farm may train melee/mastery
--          at the same time instead of spawning a second mastery movement worker.
--  [V22-2] Bring is an optimization, never a combat gate. The live quest target remains authoritative;
--          nearby same-name mobs may be pulled toward it, but a failed magnet cannot stop damage.
--  [V22-3] Reference farm uses fast target handoff: hover above the live target, attack immediately,
--          switch to the next live quest victim as soon as the current one dies. No fixed-pile dependency.
--  [V22-4] Optional detours are atomic: claim -> act -> verify -> release -> short farm-resume grace.
--          Hard gates still win; optional tasks cannot ping-pong every scheduler tick.
--  [V22-5] Near-world-fruit pickup is bounded and local only. It cannot chase a fruit across the sea.
--  [V22-6] Elite/Factory/Raid/item work may become scheduler intents when useful; none owns a permanent loop.
--  [V22-7] Bobon HUD keeps its own glass/fire identity and now shows ACTION + OBJECTIVE rather than
--          copying the reference hub's Status Farm / Status Item presentation.
--  [V22-8] Existing Saber/Sea/Bartilo/TTK/CDK/Skull Guitar/Raid/Factory/melee progression is retained.
--
--
--  v21.43 ROBLOX(16) SHARED COMBAT STARVATION ROOT FIX:
--  [C43-1] Video evidence separates gather from combat: shared BN reports 7 grouped/verified
--          victims while the quest stays 1/8 and HUD remains WAIT-FAST-REMOTE.
--  [C43-2] Shared-source fixed-pile farm now participates in aggregate HP proof. Damage on any
--          dispatched same-name pile victim can validate the backend; proof is not primary-only.
--  [C43-3] Net resolver supports both direct RE/RegisterAttack children and the shared-source
--          require(Modules.Net):RemoteEvent(...) API used by the public Skid source.
--  [C43-4] Adds SKID-DIRECT-4: fresh RegisterAttack + 4-argument RegisterHit for every shared
--          pile victim using the source-shared payload shape, still promoted only by real HP loss.
--  [C43-5] SKID-DIRECT-4 has a short bounded retry so remote-only air farm does not remain starved
--          after the older helper/token/legacy shapes are rejected. No client M1 dip is introduced.
--  [C43-6] Existing pending-probe state machine is otherwise unchanged; this patch does not alter
--          Travel, fixed-pile placement, quest lease, scheduler priorities, or progression movement.
--  [C43-7] HUD reports SHARED PILE while SharedSourceFarmMode owns ordinary quest farming.
--
--  v21.42 FARM STABILITY REBASE (ROBLOX 14/15 ROOT FIX):
--  [S42-1] Active quest farm is protected from optional FruitFinder/Elite utility preemption.
--  [S42-2] Fruit Finder defaults OFF, uses strict fruit identification, short range, and safe-window only.
--  [S42-3] Shared pile no longer drops/restores mobs because of failure blacklist by default.
--  [S42-4] Bring failure bookkeeping resets on SharedRelease so short optional actions cannot poison later waves.
--  [S42-5] Smart farm-stuck auto release/hop defaults OFF; base Travel watchdog remains authoritative.
--  [S42-6] Elite wake and MasteryTool utility default OFF; permanent progression controllers remain intact.
--  [S42-7] Restored v21.38 entrance resolver to avoid utility-era route changes.
--  [S42-8] Keeps v21.41 Main + Main (minimal) quest parser without allowing hidden UI to flip farm goals.
--
--  v21.41 ROBLOX(14) QUEST-UI / TRAVEL PING-PONG FIX:
--  [Q41-1] Quest detection reads both PlayerGui.Main and PlayerGui["Main (minimal)"], recursively.
--  [Q41-2] A hidden/minimized Quest wrapper is no longer treated as completion while live title/objective text remains.
--  [Q41-3] Completion scans mounted labels even while hidden and requires explicit completion text or x/y >= total.
--  [Q41-4] Stops Farm goal from flipping QuestGiver <-> mob pile when mobile/minimal quest UI collapses or flickers.
--
--  v21.39 SKID-UTILITY INTEGRATION:
--  [U39-1] World Fruit Finder is event/scheduler-driven: detect dropped fruit, claim one action,
--          travel/touch/store, then resume farm. No independent movement loop is added.
--  [U39-2] Shared BN now tracks persistence failures per mob. Repeated snap-back marks that mob
--          temporarily IgnoreGrab; farm keeps attacking the real target instead of magnet-looping forever.
--  [U39-3] Entrance routing is distance-aware and uses the shared source's known public requestEntrance
--          zones only when a long trip actually benefits; no near-target portal spam.
--  [U39-4] MasteryTool pulse reuses PreferredCombatTool for CDK Yama/Tushita mastery plus existing TTK/style
--          training; no second equip/farm worker is created.
--  [U39-5] Elite spawn observer only wakes the Priority Scheduler. If Yama still needs Elite progress,
--          the existing verified ItemProgression:CheckYama() claims and fights it immediately.
--  [U39-6] Smart farm-stuck watchdog observes position + quest text + target HP. It first clears/retries
--          shared farm; repeated verified no-progress requests a targeted server hop.
--
--  v21.40 FIXED SHARED PILE:
--  [PILE40-1] Shared farm keeps ONE fixed pile CFrame for the active quest mob/wave. Target death never moves the pile.
--  [PILE40-2] Every matching live mob in the active field is pulled to that fixed pile, not only mobs near the player.
--  [PILE40-3] Player hover is anchored above the fixed pile; FarmTarget is only a representative combat victim.
--  [PILE40-4] Empty respawn gaps keep the pile alive briefly so the next wave is pulled into the same spot.
--  [PILE40-5] Bring-failure blacklist no longer changes the pile; failed mobs retry with a softer backoff while the rest stay stacked.
--
--  v21.38 SHARED-SOURCE FARM REBASE:
--  [SF38-1] Normal quest farm bypasses Bobon ACQUIRE/STACK/KILL and follows the shared source loop:
--           keep one live quest target -> BN-style bring -> hover +25 -> attack until that target dies.
--  [SF38-2] BN-style gather uses SimulationRadius + BodyPosition(P=3000,D=100,MaxForce=1e6),
--           Humanoid ChangeState(14), WalkSpeed=0 and local collision suppression.
--  [SF38-3] Shared source caps BN near 3 mobs; Bobon intentionally removes that cap so every matching
--           live quest mob inside SharedBringRange may join the same target-centered pile.
--  [SF38-4] No network-owner gate, damage lease, acquire phase, fixed-pile centroid, or cluster phase
--           is used for ordinary level farm while SharedSourceFarmMode=true. Raid/item clusters remain intact.
--  [SF38-5] Shared bring has explicit cleanup/restoration on quest/target-mode changes so BodyPosition
--           and locally modified Humanoid/part properties do not leak into unrelated mobs.
--  [SF38-6] Shared farm fast-attack may fan fresh swings across all same-name nearby mobs without
--           requiring Bobon cluster verification, matching the shared source multi-target attack rhythm.
--
--
--  v21.37 ROOT-CAUSE REWORK (VIDEO Roblox(13)):
--  [ROOT37-1] Cluster phase/target state now has ONE active writer. Removed the 30ms background Tick
--             and ChildAdded phase reset that could flip KILL back to ACQUIRE behind MainController.
--  [ROOT37-2] Heartbeat may only re-stack ALREADY VERIFIED roots; it cannot start ownership proofs,
--             select targets, revoke mobs, or mutate ACQUIRE/STACK/KILL phase.
--  [ROOT37-3] Failed direct melee purchase probes no longer extend EconomyPause and cancel Farm travel.
--             Unverified purchases use a bounded retry backoff instead of retrying before the old pause ends.
--  [ROOT37-4] ACQUIRE uses a hard wave epoch. Streaming/ChildAdded cannot restart the 4s budget forever;
--             KILL fallback must get a real attack window before another acquisition sweep.
--  [ROOT37-5] One bad PERSIST victim no longer resets the whole wave instantly; it is revoked locally and
--             the normal KILL slice finishes before the controller schedules another acquisition pass.
--  [ROOT37-6] TravelManager enforces action preemption: Farm cannot request movement while a progression
--             ActionToken is active, and a claimed non-Farm action may atomically stop stale Farm travel.
--
--  v21.36 VIDEO 1000007837 ROOT-CAUSE FIX:
--  [V36-1] ACQUIRE no longer resets its budget every time another streamed mob appears.
--          New mobs reopen ACQUIRE only from KILL; an active ACQUIRE keeps its hard deadline.
--  [V36-2] Fixed pile anchor is a REAL live mob position (medoid), never an empty geometric
--          centroid such as the middle of the Marine Fortress fountain/pool seen in the video.
--  [V36-3] Executor ownership=false is no longer an absolute dead-end after physical touch.
--          One write + no-rewrite persistence proof is allowed; server snap-back fails immediately.
--  [V36-4] PERSIST roots are guarded by real HP liveness. A visual-only statue is restored,
--          blocked from immediate re-pull, and farm falls back to the real server position.
--  [V36-5] If zero mobs can be stacked, KILL gets a longer real-position fallback slice so quest
--          progress cannot remain frozen while the player only circles the field.
--  [V36-6] Real HP loss on an unstacked touched victim feeds the SAME persistence proof used by ACQUIRE;
--          the orphan DAMAGE-TRIAL path from 21.23/21.34 is removed from the live decision path.
--
--  v21.35 PRIORITY / PROGRESSION HARDENING:
--  [P35-1] ONE Priority Scheduler owns permanent movement work: hard gates -> ready melee/key ->
--           required boss -> live Factory -> Fragment Raid -> optional progression -> Level Farm.
--           MainController no longer independently starts Factory/Raid/ItemProgression.
--  [P35-2] Sea transition cleanup clears stale travel, quest/cluster targets, spawn memory,
--           fragment demand and inventory caches before the new sea can farm.
--  [P35-3] Progression watchdog releases a claimed action only when status is stale AND there is
--           no live target/movement, preventing silent permanent stalls without killing real fights.
--  [TTK35-1] Legendary Sword Dealer probing verifies inventory after each choice, tracks missing
--             Saddi/Shisui/Wando and only targeted-hops after repeated no-progress probes.
--  [TTK35-2] HUD/status exposes the missing TTK sword/mastery instead of generic progression text.
--  [K35-1] Cake/Dough progress remembers the last real counter change so stale progress is visible
--           and bounded retries do not masquerade as forward progress.
--  [ST35-1] Removed the old 3-second melee/sword worker and old ProgressionWatcher. Passive melee
--           training + TTK checks now run from the same scheduler; Economy/Gacha remains serial.
--  [ST35-2] Existing RemoteResolver/Stats/Economy remain single-owner; no ad-source duplicate loops,
--           HRP CommF_ paths, WindUI/loadstring, destructive popup sweeps or 3-mob BN are imported.
--  [EC35-1] TTK dealer/Mysterious Man Beli transactions now use the SAME economy mutex as
--           Gacha/Melee, preventing simultaneous Beli spends at exact purchase thresholds.
--
--  v21.34 ALL-IN REWORK:
--  [F34-1] Quest farm is phase-driven: ACQUIRE -> STACK -> KILL. New wave mobs reopen ACQUIRE.
--  [F34-2] One pile is FIXED for the active quest/wave; it no longer follows the player during acquisition.
--  [F34-3] Unknown ownership fallback uses short physical persistence proof, then real HP liveness revokes ghost/statue mobs.
--  [F34-4] Cluster combat uses fresh independent swings for every eligible victim; no attack while ACQUIRE is active.
--  [F34-4b] Real multi-mob piles prefer simple direct per-victim fanout first; HP proof rotates backend on failure.
--  [F34-5] Raid regular mobs use the same physical acquisition/fixed-pile path. Bosses remain single-target.
--  [R34-1] Fragment demand can preempt an active level quest immediately through the existing RaidController.
--  [R34-2] Raid chip acquisition reserves/uses one cheap physical fruit, supports stored-fruit fallback, then Beli fallback.
--  [R34-3] Sea-2 raid start has a bounded Lab color-puzzle fallback (Red, Blue, Green, Blue).
--  [FR34-1] Fruit store keeps one cheap Raid reserve only while a real Fragment shortage exists.
--  [UI34-1] Gacha popup/camera cleanup is event-driven and only active around a real gacha attempt; no destructive 0.1s sweep.
--  [ST34-1] Existing single Stats/Economy/RemoteResolver/TTK/Yama/Cake/Factory controllers are retained; no duplicate loops added.
--  [P34-1] Required boss/key/item spawns preempt level farm; targeted progression hop can run while generic Hop is OFF.
--  [P34-2] Removed the duplicate melee-unlock watcher; one full ProgressionWatcher owns permanent progression.
--
--  v21.33 VIDEO Roblox(12) FIXES:
--  [F33-1] Blind circular patrol removed; farm follows exact _WorldOrigin.EnemySpawns.
--  [F33-2] Live quest positions are remembered and reused between respawns.
--  [F33-3] Quest candidate radius uses the full active-field search radius.
--  [D33-1] Farm hover raised and real HP loss arms an exact-target emergency dodge.
--  [E33-1] Gacha remains first, but known rejection no longer stalls melee for 4s.
--  [E33-2] First-time melee unlock quests preempt level farm when prerequisites exist.
--
--  v21.33 ACTIVE FARM / ECONOMY FIX:
--  [AF-1] Quest scanning no longer reuses the authority-only radius when authority mode is OFF.
--         Current quest mobs get a wider live-search field instead of disappearing from LastBatch.
--  [AF-2] Empty wave / stale anchor no longer means stand still: visit live matching mob roots first,
--         then patrol compact spawn-field points until a new wave is streamed.
--  [AF-3] One-pile anchor follows the player during the sweep; acquired mobs are restacked underfoot.
--  [EC-1] Gacha gets FIRST refusal every economy cycle. If it can roll, it spends before melee.
--         A cooldown/insufficient-money rejection immediately falls through to melee in the same cycle.
--  [EC-2] EVERY fighting-style purchase branch pauses ordinary Farm before the purchase/verification.
--         V1, Dragon Breath, Superhuman, V2 styles, Godhuman and Sanguine all use the same rule.
--  [EC-3] Ready fighting-style unlock quests/keys preempt ordinary farm instead of waiting for a farm window.
--
--  v21.33 STABILITY AUDIT (VIDEO Roblox(10)):
--  [SI-1] Sticky mandatory progression intent: Saber/Sea gates cannot fall back to level
--         farm for a few frames between retries. This removes Farm <-> progression ping-pong.
--  [SI-2] Quest UI close is debounced/leased before optional boss/item work may start.
--         A one-frame Quest wrapper disappearance can no longer launch a boss and redirect travel.
--  [SI-3] BossManager may start below max level only after a confirmed stable quest-closed window.
--  [SI-4] SetMode no longer overwrites the detailed status text every 0.15s; HUD renders the
--         authoritative owner/FState instead of stale background notices.
--  [D30-1] Dodge locks to the ACTIVE combat target only. Nearby unrelated NPCs no longer trigger it.
--  [D30-2] Removed generic Action-priority animation detection and broad elemental-effect matching;
--          dodge requires named attack/cast evidence, a real charge, target hitbox, or a high-confidence
--          spawned hazard near both player and the active target.
--  [D30-3] Threat must persist across multiple samples; one evade direction is frozen per cast.
--          No 0.16s left/right replanning loop, so the player does not zig-zag across the island.
--  [D30-4] Evade distance/speed/TTL are bounded. After a continuously safe window the exact old
--          target is resumed without releasing ActionToken, quest, cluster, or MovementOwner.
--
--  v21.24.3 STARTUP ROOT-CAUSE FIX:
--  [BOOT-1] v21.23 added two long-lived top-level locals (damage lease + move trial).
--           This source was already close to Luau's per-function local/register limits;
--           v21.24/24.1/24.2 inherited those extra top-level slots and could fail before
--           the first print/UI. The two tables now live on _G and consume ZERO main-chunk locals.
--  [BOOT-2] Immediate progression is NOT injected into the huge MainController closure.
--           A small independent watcher calls the existing ItemProgression controller; once
--           an action claims ActionToken, the existing main loop naturally pauses next tick.
--  [BOOT-3] Top-level `local` declaration count is restored to the v21.22 baseline.
--
--  v21.24.3 MINIMAL PRIORITY / BOOT-SAFE FIX:
--  [MP-1] Rebased directly on v21.23 (last known booting build). No new controller/function block.
--  [MP-2] Existing ItemProgression:RunChecks(true,true) now runs before level quest/farm.
--         An eligible progression action claims ActionToken and PrepareClaimedAction stops Farm travel.
--  [MP-3] Saber can claim immediately at Lv.200 even if combat backend has not been pre-verified.
--  [MP-4] Saber retry reduced from the generic 300s optional cooldown to 5s.
--  [MP-5] Sea2/Bartilo/Sea3/Pole/Tushita/Factory-item entry gates no longer depend on a pre-verified damage backend.
--  [MP-6] Bartilo level gate corrected to 850.
--  [MP-7] Cluster/combat/travel implementation remains the v21.23 code path.
--
--  v21.23 ALL-MOB / PERSISTENT PILE FIX:
--  [AP-1] Fixes the real v21.22 omission bug: candidate membership is now decided from
--         each mob's ORIGINAL spawn position, not its current underfoot position. Already
--         gathered mobs therefore stay in LastBatch while the player sweeps farther away.
--  [AP-2] Quest field radius is widened and the sweep retries much more aggressively, so
--         the controller keeps working until every live same-name mob in the active camp
--         is either stacked or temporarily on a short retry cooldown.
--  [AP-3] Executor environments with no usable isnetworkowner API no longer deadlock at
--         'damage works / gather never happens'. A mob that takes REAL HP damage while the
--         player is physically close may start a one-shot movement trial. The root is NOT
--         continuously rewritten during the trial; only a position that persists across
--         several Heartbeats becomes a short DAMAGE-LEASE stack authority.
--  [AP-4] A DAMAGE-LEASE is refreshed only by fresh real HP damage. If the server snaps the
--         NPC away from the pile, the lease is revoked immediately and the mob returns to
--         the acquisition sweep instead of becoming a permanent client-side statue.
--  [AP-5] Network-owner=true remains the strongest path and is unchanged. No anti-cheat or
--         kick bypass is added; TravelManager still remains the single movement owner.
--
--  v21.23 ALL-MOB PERSISTENT PILE GATHER:
--  [P1] Every NETWORK-OWNED same-name quest mob is pinned to ONE exact pile point.
--       ClusterStackRadius stays 0; there is no ring/spread around the player.
--  [P2] During the ownership sweep the pile anchor follows the player's X/Z, so all
--       already-acquired mobs travel directly UNDERFOOT while Farm visits the next group.
--  [P3] The acquire target uses a low 8-stud hover and tight arrival threshold. As soon
--       as ownership transfers, Heartbeat merges that mob into the same moving pile.
--  [P4] After the last unowned mob is acquired, the moving pile follows the player back
--       to the persistent farm hover, then settles exactly below the player's stable X/Z.
--  [P5] Combat remains active during the sweep: the live acquire target plus already-owned
--       pile members stay eligible for attacks while movement continues.
--  [P6] NO-GHOST rule is preserved: a root with ClientOwnsMob(root) ~= true is NEVER
--       CFramed/frozen/pinned, so v21.18/v21.19 statue mobs are not reintroduced.
--
--
--
--  v21.21 ROOT FIX: REAL OWNERSHIP ONLY / NO CLIENT-ONLY STATUES:
--  [RO-1] Normal QUEST and SKIP never CFrame an NPC whose network ownership is not
--         positively proven. Unknown/false ownership stays at the real server position.
--  [RO-2] Removed the v21.18/v21.19 visual-probe/visual-magnet path that could leave a
--         Sky Bandit/Snowman standing under the player with no usable HP bar.
--  [RO-3] "STACKED" now means exactly: ClientOwnsMob(root)==true AND the owned assembly
--         was moved to the shared anchor. Damage proof alone cannot promote movement.
--  [RO-4] QUEST physical acquisition is restored as a bounded high-speed ownership sweep.
--         The player approaches one real unowned mob; every same-name assembly that becomes
--         client-owned during that pass is pulled at once, so one pass can acquire a group.
--  [RO-5] Acquisition stops at a wider proximity threshold and keeps attacking while moving;
--         it does not fake movement when the executor has no ownership API.
--  [RO-6] If ownership cannot be obtained, the bot farms the real NPC instead of leaving a
--         client-side statue. Reliability is preferred over cosmetic remote magnet.
--  [RO-7] No Humanoid WalkSpeed/JumpPower/Animator/PlatformStand mutation is added.
--         TravelManager, Haki and progression remain otherwise unchanged.
--
--  v21.19 ROOT-CAUSE FIX (Roblox(9).mp4):
--  [SR-1] v21.18 deadlocked because it moved ONE unknown-owner mob locally to the
--         anchor, then tried to prove HP at that fake client position. The server can
--         still keep the NPC at its original position, so CLIENT-HELPER pcall succeeds
--         while quest/HP remains unchanged (`found 4 / proven 0 / stacked 0`).
--  [SR-2] Server-shadow positions are now captured BEFORE any visual magnet write and
--         are used for attack-range eligibility. A local CFrame can never widen range.
--  [SR-3] Normal QUEST attack no longer waits for one authority probe. Every same-name
--         mob whose server-shadow position is inside the real 100-stud field is included
--         in the SAME combat cycle immediately.
--  [SR-4] Visual magnet is restored for the whole field, but it is presentation only
--         until OWNED or real per-Humanoid HP delta proves authority. `visual` and
--         `proven/stacked` are intentionally separate diagnostics.
--  [SR-5] Air-farm QUEST prefers the canonical direct RegisterAttack + RegisterHit
--         batch path first. The stale COMBAT_REMOTE_THREAD flag no longer blocks this
--         HP-verified path; if it truly causes no damage, normal backend failure rotates.
--  [SR-6] Canonical batch is built only from server-shadow-in-range victims, fixing the
--         v21.15 false batch where visually stacked ghosts were outside server range.
--  [SR-7] CLIENT-HELPER/TOKEN fallback remains, but a globally proven helper cannot
--         monopolize a new zero-damage field forever because LEGACY-2 gets first probe.
--  [SR-8] Global primary-only no-damage recovery is disabled while shadow multi-target
--         combat is active; exact aggregate HP snapshots remain the source of truth.
--  [SR-9] Normal QUEST never resumes the old per-mob ownership tour. SKIP keeps its
--         dedicated physical acquisition route. No anti-cheat/kick bypass is added.
-- [SR-10] If one real 100-stud combat circle cannot cover the whole spawn, a greedy
--         field-coverage planner moves between a small number of shared centers. It
--         prioritizes mobs without recent HP proof and never chases mob-by-mob.
-- [SR-11] Direct LEGACY combat starts with the canonical one-swing multi-target batch.
--         Exact per-Humanoid HP proof identifies misses; only missed victims then receive
--         fresh independent swings. This self-adapts instead of hard-coding one payload.
--
--  v21.18 ROOT-CAUSE / AUTHORITY CLUSTER FIX (Roblox(8).mp4):
--  [AC-1] The old `stacked` counter was false-positive on executors with no
--         ownership API: a locally written NPC CFrame could remain visible for
--         several Heartbeats, then be marked verified even though the server still
--         kept that NPC at its original position. This exactly explains
--         `owned 0 / stacked 3` while only one NPC can actually take damage.
--  [AC-2] VerifiedGatherRoots is now AUTHORITATIVE ONLY:
--         network-owned roots are trusted after the real move; unknown/server-owned
--         roots are never promoted merely because a local CFrame stayed visible.
--  [AC-3] Unknown/server-owned roots are tested ONE AT A TIME at the shared
--         anchor while the player stays parked there. A temporary local CFrame is
--         only a PROBE; it is never counted as stacked until that exact Humanoid
--         produces a causal real HP decrease.
--  [AC-4] A failed probe is restored/released and cooldowned instead of remaining as
--         a statue. A successful damage-proven root is pinned with a short TTL; if
--         real damage stops, its authority is revoked and it must prove itself again.
--  [AC-5] Quest anchor now uses a minimax/central live-spawn center rather than the
--         nearest single NPC, minimizing the farthest real mob distance to the
--         player's ~100-stud valid combat field.
--  [AC-6] Cluster combat no longer relies on one RegisterAttack being reused for a
--         multi-target batch. Every verified/probe target gets its own registered
--         single-target swing, spaced by a tiny bounded gap, matching the current
--         public tokenized DoHit shape that is known to work on one real NPC.
--  [AC-7] Normal QUEST mode no longer flies a per-mob ownership tour. SKIP keeps its
--         physical acquisition path. HUD separates OWNED / PROVEN / STACKED /
--         TESTING / UNKNOWN so a client-only visual pull cannot masquerade as success.
--  [AC-8] Exact per-model HP deltas refresh authority for every damaged cluster
--         member. Aggregate proof no longer falsely promotes the watched primary when
--         some other mob was the one that actually lost HP.
--  [AC-9] No anti-cheat/kick bypass is added. If the server refuses both ownership
--         and real damage for a staged mob, the script reports/retries that truth
--         instead of fabricating a working stack.
--
--  v21.17 FULL-CONTEXT CLUSTER VICTIM FIX (v21.16 still damaged one mob):
--  [CTX-1] Root cause in v21.16: only dispatchEntries rotated. preferredModel /
--          preferredHumanoid / preferredRoot and WatchTarget stayed bound to the old
--          primary, so helpers/server-side combat state could keep resolving one NPC.
--  [CTX-2] Cluster rotation now promotes the rotated victim into the ENTIRE combat
--          context before WatchTarget/backend verification/dispatch. The player still
--          stays over the same cluster anchor; only the combat victim changes.
--  [CTX-3] Each victim is held until it actually loses HP (or a short bounded hold
--          expires), preventing a new victim every 0.08s from resetting HP proof.
--  [CTX-4] Dispatch is single-victim while context rotation is active. That means the
--          remote first part, hit list, pending target and HP watcher all name the same mob.
--  [CTX-5] Remote magnet / RestackBatch / ClusterFarmController movement is unchanged.
--  v21.16 CLUSTER ROUND-ROBIN DAMAGE FIX (v21.15 still damaged only one mob):
--  [RR-1] Keep v21.13/v21.14 remote magnet and v21.15 target collection unchanged.
--  [RR-2] The current server/executor session is evidently consuming only one victim
--         from a registered melee swing even when a multi-entry RegisterHit list is sent.
--         Stop relying on fake-looking batch success as the only cluster path.
--  [RR-3] When 2+ verified stacked mobs are eligible, dispatch ONE real target per normal
--         attack tick and rotate the victim 1->2->3->... at the existing AttackDelay.
--         This keeps remote traffic bounded while every stacked mob receives damage.
--  [RR-4] Rotation is tied to ClusterGeneration and skips dead/despawned entries automatically.
--  [RR-5] Aggregate HP verification still validates the active backend from whichever rotated
--         mob actually loses HP; kill accounting records every rotated victim.
--  [RR-6] No gather/magnet/anchor/movement/Haki/UI/progression code is changed.
--
--  v21.15 TRUE CLUSTER MULTI-HIT FIX (video Roblox(7).mp4):
--  [MH-1] Preserve v21.13/v21.14 remote magnet byte-for-byte: STACK xN positioning
--         is not changed by this patch.
--  [MH-2] Cluster melee dispatch now prefers the canonical ONE-SWING / ONE-BATCH
--         RegisterAttack + RegisterHit(BasePart, {{Model,Head},...}) shape.
--         The previous TOKEN-4 loop consumed one registered swing across several
--         separate RegisterHit calls, which could leave only the first mob damaged.
--  [MH-3] TOKEN-4 keeps its single-target token path, but when 2+ verified cluster
--         targets are present it uses the same batched hit-list shape first.
--  [MH-4] Native helper fan-out now also receives Head-based batch entries, matching
--         the live RegisterHit target layout instead of mixed limb-first parts.
--  [MH-5] While a real 2+ stack is active, LEGACY-2 batch is preferred over a
--         previously verified TOKEN-4 single-target route. If batch HP proof fails,
--         the existing verifier/failure cooldown rotates normally.
--  [MH-6] No movement, gather, anchor, Haki, UI, quest or progression behavior changed.
--
--  v21.14 COMBAT STALL FIX (video Roblox(6).mp4):
--  [CS-1] Preserve v21.13 remote magnet: the video proves found 3/4, owned 0,
--         stacked 3/4, so gather itself is already working.
--  [CS-2] Fix long COMBAT WAIT-FAST-REMOTE stalls after several successful kills.
--         A previously HP-verified remote backend no longer stops dispatching after
--         exactly CombatProbeAttempts while waiting on one primary mob's HP.
--  [CS-3] Cluster remote probes now verify against aggregate HP of the exact
--         dispatched stacked batch. Damage on any non-contested stacked mob can
--         confirm the backend; verification is no longer primary-only.
--  [CS-4] Proven TOKEN-4 backends are not blacklisted for 60 seconds on one
--         transient miss. Proven backends use a short retry; unproven bad tokens
--         keep the long rejection window.
--  [CS-5] A proven airborne remote backend may dispatch continuously for a bounded
--         silent window. If the batch truly takes no damage, it is rotated after
--         that timeout; no infinite blind remote spam is introduced.
--  [CS-6] Movement, fast-descend, Haki hold, UI, progression and cluster positioning
--         are otherwise unchanged from v21.13.
--  [CS-7] Kill counter now counts recently dispatched stacked mobs, not only the
--         promoted FarmTarget. This fixes KILLS staying 0 while cluster rewards appear.
--
--  v21.13 FULL FARM REVIEW / REMOTE MAGNET RESTORE:
--  [RM-1] Reviewed v21.5 -> v21.12. The mandatory per-mob fly came from v21.6:
--         ownership false OR unknown was queued for physical acquisition, and unknown
--         roots were only test-moved after the player reached touch radius.
--  [RM-2] Remote-pull-first: every same-name mob in the active field is attempted at
--         the shared anchor immediately after SimulationRadius expansion. No near-player
--         gate is required for the remote test. Position persistence still proves the
--         move before the mob becomes a verified multi-hit target.
--  [RM-3] Physical acquisition is now FALLBACK ONLY when zero mobs have been remotely
--         verified after a grace window. Once any verified stack exists, Farm stays on
--         the anchor instead of flying to every remaining mob.
--  [RM-4] Removed the v21.9/v21.10 anti-backstep restack delay; it fixed a rare jerk by
--         waiting near each acquire target, which directly conflicts with remote magnet.
--  [RM-5] Attack/CollectTargets stays v21.8: verified same-name roots at one anchor are
--         attacked as a group. Fast descent is TravelManager-only. Armament Haki is
--         silently held ON with state-check/cooldown and never writes Status.
--
--  v21.8 FAST MOVEMENT TUNING:
--  [FM-1] Global travel speed raised moderately; skip Floor 1/2 uses a faster
--         dedicated speed so ownership sweeps do not crawl between mobs.
--  [FM-2] Near-target deceleration shortened and given a minimum approach speed;
--         arrival threshold is wider so the bot settles quickly instead of easing
--         for a long time during the final descent.
--  [FM-3] No anti-kick/anti-cheat bypass is added. Existing validation, movement
--         ownership, fallback and recovery logic are preserved.
--
--  v21.7 EARLY SKIP FLOOR 1/2 SWEEP FIX:
--  [SF-1] Fixed the shared Floor 1 / Floor 2 deadlock where SKIP first requested
--         the persistent hover anchor, then immediately requested a live mob; the
--         next main tick retargeted back to the anchor before ownership could transfer.
--  [SF-2] SKIP now uses the same canonical ClusterAcquireTarget sweep as quest farm.
--         While one unverified Sky Bandit/God's Guard is being acquired, the hover
--         request is suppressed for that tick so TravelManager can actually reach it.
--  [SF-3] The acquire target is attacked as soon as it enters FastAttackRange.
--         Already verified stacked mobs remain eligible as extra multi-hit targets.
--  [SF-4] Unknown-owner executors use the v21.6 position-proof path after physical
--         approach; explicit server-owned roots wait for real ownership transfer.
--  [SF-5] One implementation fixes both TeddyFloor1 (Lv10-50) and TeddyFloor2
--         (Lv51-70); no UI/progression/boss/sea behavior was removed.
--
--  v21.6 VIDEO-STYLE SWEEP + TRUE GROUP GATHER:
--  [VS-1] Unknown network-owner executors no longer disable gather completely.
--         Farm visits the real quest mob, performs one bounded move, then proves
--         that the root remains at the shared anchor before marking it verified.
--  [VS-2] Ownership acquisition now sweeps false OR unknown roots; verified roots
--         are still the only extra targets accepted by cluster multi-hit.
--  [VS-3] New quest clusters seed their anchor from a live same-name mob near the
--         canonical spawn so the player and batch gather around the real camp.
--  [VS-4] Local quest snap/acquire timings are tightened to match the supplied
--         video: rapid mob-to-mob collection while attacks continue in transit.
--  [VS-5] No boss/item/sea movement policy changed; Single Movement Owner remains.
--
--  v21.5 HYBRID GATHER + ATTACK FIX:
--  [HF-1] Quest farm no longer waits for the whole ownership sweep to finish.
--         A real same-name acquire target is attacked as soon as it enters the
--         verified 100-stud remote range while TravelManager keeps approaching.
--  [HF-2] Acquisition travel owns the current tick and cannot be overwritten by
--         an immediate return-to-anchor request. The cluster is still restacked
--         continuously by the existing Heartbeat controller.
--  [HF-3] NearQuestSnap accepts the canonical ClusterAcquireTarget, shortening
--         the final approach without broadening it to bosses or unrelated mobs.
--  [HF-4] Preferred acquire targets remain exact active-quest names. Nearby Yeti,
--         bosses and other enemies can never replace the Snowman/quest target.
--  [HF-5] Stable-anchor attacks and aggregate HP watchdog remain unchanged; the
--         hybrid approach path relies on CombatController's real HP verification.
--
--  v21.4 TRUE ALL-MOB SWEEP FIX:
--  [AM-1] Added a bounded ownership-acquisition sweep. Before attacking, Farm
--         briefly visits each unverified same-name mob in the current spawn;
--         Heartbeat then stacks it as soon as real client ownership is proven.
--  [AM-2] Quest candidate radius is now spawn-local instead of the old 3000-stud
--         island-wide scan, preventing travel to a different camp with the same mob.
--  [AM-3] Acquisition has per-mob timeout/retry cooldown. A server-owned mob can
--         never trap the farm in an endless retarget loop or create a fake local mob.
--  [AM-4] Verified targets must still be physically resident at the cluster anchor.
--         A server-snapped-back root is revoked before multi-hit collection.
--  [AM-5] No-damage verification observes the whole verified batch, not only the
--         promoted primary, so real group damage is not mistaken for a failed hit.
--
--  v21.3 GLOBAL MOB CORE FIX:
--  [GM-1] Normal quest farming is now explicitly mob-agnostic. Every QDB mob
--         uses the same dynamic questMobName -> acquire -> cluster -> attack path;
--         there are no Snowman/name-specific combat fixes.
--  [GM-2] Quest cluster anchor self-heals globally: if QDB MC is stale/far from
--         the live matching spawn, the first live quest mob seeds the anchor.
--         Once seeded, the anchor stays persistent across deaths/respawns.
--  [GM-3] Global quest chase distance uses the existing GatherMaxDistance instead
--         of the old 350-stud hard stop, so a stale farm coordinate cannot make
--         one mob/level work while another stalls just outside MaxFarmDistance.
--  [GM-4] Global no-damage watchdog is integrated into the SINGLE main loop. If
--         any quest mob takes no HP damage while the bot is at a combat anchor,
--         its local cluster verification is revoked and Farm travel is replanned
--         against the real live mob. No extra movement coroutine is created.
--  [GM-5] Cluster multi-hit remains dynamic: only the current quest mob name is
--         collected, every verified same-name mob is included up to the existing
--         cluster cap, and primary death promotes another same-name mob.
--
--  v21.2 VIDEO FARM HOTFIX:
--  [VF-1] Combat legacy RegisterAttack/RegisterHit probe is no longer disabled
--         just because COMBAT_REMOTE_THREAD is absent. Missing flag now means
--         "probe and verify by real HP delta", not "never attack".
--  [VF-2] TOKEN-4 discovery now checks runtime/env/getgc upvalues/constants,
--         rejects tokens that fail HP verification, and retries later.
--  [VF-3] Cluster stacking marks a mob verified ONLY when client network
--         ownership is proven. Local-only ghost CFrame writes no longer count.
--  [VF-4] If no mob can be server-owned at the static quest anchor, moved stays
--         zero so the existing fallback chases a real live quest mob first.
--         Once ownership is acquired, the full batch can stack normally.
--  [VF-5] Keeps Teddy-style 22-stud air farm; no forced dip/M1 fallback added.
--
--
--  v21.1 STARTUP HOTFIX:
--  [S-1] Fixed Luau compile failure: v21.0 exceeded the main-chunk local-variable limit.
--  [S-2] CDK and Skull Guitar helper locals now live in narrow scopes; behavior is preserved.
--  [S-3] No farm/progression/config feature was removed by this startup fix.
--
--
--  v21.0 DEEP RESEARCH / ENDGAME COMPLETION AUDIT:
--  [V21-1] Added sea-aware material preparation for Godhuman/Sanguine/Skull Guitar:
--          Magma Ore, Fish Tail, Mystic Droplet, Ectoplasm, Vampire Fang,
--          Dragon Scale, Bones and Demonic Wisp use the same airborne ITEM cluster.
--  [V21-2] Full-melee prerequisite controller handles Library Key/Death Step,
--          Water Key/Sharkman Karate and Fire Essence/Dragon Talon bone rolls.
--  [V21-3] CDK is state-driven: Docks Legend, Sense of Duty, Soulless/Heaven,
--          Pain and Suffering, Haze of Misery, Fear the Reaper/Hell and final boss.
--  [V21-4] Skull Guitar now has bounded Full-Moon init, six-Zombie same-batch Swamp,
--          fixed gravestones, Ghost, randomized trophy orientation and pipe-color solve.
--  [V21-5] TOKEN-4 sends one RegisterAttack per cluster batch, then all RegisterHit
--          entries, reducing per-target attack spam and enabling same-cycle group kills.
--  [V21-6] Live Darkbeard becomes progression work while Dark Fragments are actually
--          needed for Skull Guitar/Sanguine; hopping still obeys external Hop config.
--  [V21-7] Factory, Pole V1, Kabucha, Rengoku, Midnight Blade, Acidum Rifle,
--          Dragon Trident and Gravity Blade remain retained useful kaitun progression.
--  [V21-8] Sanguine auto-prefarms everything possible, but Leviathan Heart remains a
--          genuine multiplayer sea-event dependency; no fake completion is recorded.
--
--  v20.0 RESEARCH / COMPLETION AUDIT:
--  [R-1] Restored kaitun acquisition queue for Pole V1, Kabucha, Rengoku,
--        Midnight Blade and Acidum Rifle; these are bounded and never random shop sweeps.
--  [R-2] Factory Core is now a live Sea-2 EVENT priority. If Core exists, normal
--        quest hover is released, Factory gets one ActionToken, Core is fought, then
--        the previous level-farm naturally resumes. Factory is fought even if Acidum
--        Rifle is already owned because the event itself is valuable.
--  [R-3] BossManager treats live Thunder God / Awakened Ice Admiral as useful
--        progression bosses while Pole V1 / Rengoku are missing. No blind camping.
--  [R-4] Re-enabled existing Ectoplasm farmer for Midnight Blade and Fragment demand
--        fallback for Kabucha through Smart Fragment Raid.
--  [R-5] External config surface stays compact: Factory and the five useful item
--        goals above are core kaitun behavior and do not add decorative toggles.
--  [R-6] Runtime labels updated to v20.0. Live Roblox/executor behavior still depends
--        on current remotes/network ownership; no client-only success is fabricated.
--
--  v19.4 FINAL AUDIT / FIRE UI:
--  [F-1] Ember/Fire HUD: fixed fullscreen, centered, smoke-grey translucent surfaces,
--        orange/red/gold accents, no draggable window and no side bars.
--  [F-2] Corrected stale v19.0/v19.1 runtime version labels/logs to v19.4.
--  [F-3] v19.4 temporarily removed several useful item detours; v20.0 restores
--        them as bounded kaitun progression plus live Factory priority.
--  [F-4] Cursed Dual Katana=false now also disables automatic Yama/Tushita work.
--  [F-5] Skull Guitar current-name alias added while preserving legacy Soul Guitar
--        remote/inventory compatibility.
--  [F-6] Auto Stats is cap-aware when live stat values can be resolved: Melee then
--        Defense to level cap; legacy 70/30 remains only as a safe fallback.
--  [F-7] BossManager no longer hunts unrelated sword drops just because core TTK
--        progression is enabled; explicit Farm Boss Drops still works independently.
--  [F-8] Remaining complex CDK scroll trials and Skull Guitar Swamp/Trophy/Pipe
--        stages are intentionally not faked; status remains truthful until dedicated
--        verified stage logic is implemented.
--  [F-9] Re-execute cleanup now owns/disconnects fullscreen UI input connections and
--        destroys the exact UI root instead of referencing an out-of-scope local SG.
--
--  v19.0 UI / CLUSTER / PROGRESSION AUDIT:
--  [N-1] Boot remains non-fatal: wait for live CommF_ instead of returning early.
--  [N-2] HUD is full-screen and fixed; information panel is centered and non-draggable.
--  [N-3] Removed the old style-name subtitle; UI now identifies only Bobon Hub/Kaitun.
--  [N-4] Cluster magnet scans every matching mob in the active farm field each pass,
--        has no gather-count cap, and sends every movable mob to the exact same anchor.
--  [N-5] Simulation-radius request is aggressive and refreshed quickly; executors with
--        no ownership-query API may still attempt the move instead of skipping every mob.
--  [N-6] Sword progression is no longer completionist: no ordinary shop sweep and no
--        unrelated boss-drop collection. Keep only kaitun/progression swords + TTK chain.
--  [N-7] Full fighting-style progression remains core and runs before sword mastery.
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
--  AUDIT FIXES v16.5 UI (G-1..G-9):
--  [G-1]  OVERLAY KÍNH MỜ: nền Dim mờ xuyên cảnh (MenuDim, mặc định
--         0.45) + BlurEffect kính mờ (MenuBlur) thay cho [D-2] nền đen
--         100%. Right Ctrl ẩn/hiện toàn bộ overlay + blur.
--  [G-2]  Tự dọn blur cũ khi re-execute; blur tự gắn lại khi
--         CurrentCamera bị thay đổi (respawn/teleport).
--  [G-3]  RecoveryManager: Velocity/RotVelocity (deprecated) →
--         AssemblyLinearVelocity/AssemblyAngularVelocity.
--  [G-4]  FULLSCREEN-UI: bỏ hẳn card/khung menu — chữ nổi trực tiếp trên
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



--  v22.12 CLASSIC BN BRING REBASE:
--  [BN12-1] Replaces the v22.5 HP-proof / ownership-probe SharedBring path with
--           a single classic BN-style physics hold: SimulationRadius + BodyPosition
--           + ChangeState(14) + WalkSpeed=0 + collision suppression.
--  [BN12-2] One real primary remains the combat anchor. Secondary mobs are held at
--           that anchor; no separate ACQUIRE/STACK controller is allowed to fight it.
--  [BN12-3] Secondary fan-out is admitted only after the root physically remains
--           inside the pile radius for a short stable window. No fake visual count.
--  [BN12-4] Early Skip Lv10-70 uses the exact same SharedBring engine as normal
--           quest farming; the old Skip DirectMagnet path is no longer called.
--  [BN12-5] All temporary WalkSpeed/AutoRotate/collision/BodyPosition state is
--           restored through SharedRelease/SharedRestoreOne when the farm changes.

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


print("[BobonHub v22.4 CORE STABILITY] Loading...")


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

-- v19.0 BOOT-SAFE: the old build returned before UI/core when Remotes/CommF_
-- had not replicated within 10 seconds. Show a full-screen bootstrap HUD immediately
-- and keep resolving the authoritative RemoteFunction instead of silently dying.
local BootGui, BootLabel
pcall(function()
    local parent = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
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
        BootGui.IgnoreGuiInset = true
        BootGui.DisplayOrder = 20000
        BootGui.Parent = parent

        local backdrop = Instance.new("Frame")
        backdrop.Size = UDim2.fromScale(1,1)
        backdrop.Position = UDim2.fromScale(0,0)
        backdrop.BackgroundColor3 = Color3.fromRGB(5,9,17)
        backdrop.BackgroundTransparency = 1
        backdrop.BorderSizePixel = 0
        backdrop.Parent = BootGui

        local card = Instance.new("Frame")
        card.AnchorPoint = Vector2.new(0.5,0.5)
        card.Size = UDim2.new(0, 520, 0, 120)
        card.Position = UDim2.fromScale(0.5,0.5)
        card.BackgroundColor3 = Color3.fromRGB(8,13,24)
        card.BackgroundTransparency = 0.46
        card.BorderSizePixel = 0
        card.Parent = backdrop

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0,16)
        corner.Parent = card

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(83,218,255)
        stroke.Transparency = 0.62
        stroke.Thickness = 1.2
        stroke.Parent = card

        BootLabel = Instance.new("TextLabel")
        BootLabel.BackgroundTransparency = 1
        BootLabel.Size = UDim2.new(1,-30,1,-30)
        BootLabel.Position = UDim2.new(0,15,0,15)
        BootLabel.Font = Enum.Font.GothamBold
        BootLabel.TextSize = 16
        BootLabel.TextColor3 = Color3.fromRGB(246,249,255)
        BootLabel.TextXAlignment = Enum.TextXAlignment.Center
        BootLabel.TextYAlignment = Enum.TextYAlignment.Center
        BootLabel.TextWrapped = true
        BootLabel.Text = "BOBON HUB\nBOOTING KAITUN..."
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
    -- v19.3 Teddy-style air farm: player never descends into ordinary M1 range.
    -- Quest/skip/raid farming stays parked above the persistent cluster while
    -- helper/token/legacy fast-hit backends damage the whole stacked batch.
    FarmHeight          = 28,
    BossFarmHeight      = 32,
    -- Compatibility value only. Air-farm code never intentionally requests a
    -- lower client-click height; keeping it equal prevents accidental dipping.
    ClientHoverHeight   = 22,
    ClientDipHold       = 0,
    ClientRetreatDelay  = 0,
    EmergencyHoverHeight = 22,
    EmergencyHealthPercent = 35,
    EmergencyResumePercent = 60,
    EmergencyMinHold    = 0,
    RemoteOnlyFarmCombat = true,
    RemoteProbeAllCluster = true,
    SharedSkidDirectFallback = true,
    SharedSkidDirectRetry = 0.45,
    SharedSkidDirectMaxTargets = 32,
    SharedSkidDirectGap = 0.03,
    FarmOffsetX         = 1.5,
    -- Retained for compatibility only; enemy roots are no longer resized.
    HitboxSize          = 0,
    FlySpeed            = 240,
    SkipTravelSpeed      = 320,
    NearMoveDecelDistance= 18,
    NearMoveMinSpeed     = 110,
    -- v21.13: accelerate only the final vertical combat-hover descent.
    FastDescendEnabled   = true,
    FastDescendRadius    = 70,
    FastDescendMinGap    = 7,
    FastDescendSpeed     = 380,
    FastDescendHorizontalFactor = 0.82,
    MinY                = 10,
    -- Submerged Island (Sea 3) dùng tọa độ âm dưới mặt biển.
    UnderwaterMinY      = -2300,
    CloseThreshold      = 35,
    FarmArrivalThreshold= 5.5,
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
    FastAttackMaxTargets= 64,
    CombatProbeTimeout  = 0.9,
    CombatProbeAttempts = 3,
    CombatBackendRetry  = 4,
    CombatFastUpgradeInterval = 90,
    CombatVerifiedMissLimit = 8,
    CombatVerifiedRetry = 0.25,
    -- v21.14: once a remote backend has real HP proof, keep dispatching through
    -- primary-only misses while a stacked batch is active. Aggregate HP proof below
    -- confirms damage on any dispatched mob; a bounded silent timeout still rotates it.
    CombatVerifiedContinuousWindow = 2.60,
    CombatVerifiedBackendRetry = 0.85,
    CombatClusterAggregateProof = true,
    CombatClusterAggregateProofDelay = 0.12,
    CombatClusterAggregateLateDelay = 0.30,
    -- v21.15 batch payload remains available for compatibility, but v21.17 uses
    -- reliable one-target-per-swing rotation when a verified 2+ stack is present.
    ClusterPreferBatchHit = true,
    ClusterBatchMinTargets = 2,
    ClusterReliableRoundRobin = true,
    ClusterRoundRobinMinTargets = 2,
    ClusterContextVictimHold = 0.32,
    -- v21.18 authority-first cluster.
    ClusterAuthorityEnabled = false,
    ClusterAuthorityWarmup = 0.45,
    ClusterAuthorityProbeRange = 100,
    -- A damage-proven unknown-owner root stays eligible long enough for a complete
    -- 3-4 mob independent-swing cycle. It is revoked if real HP stops changing.
    ClusterAuthorityDamageTTL = 2.80,
    ClusterAuthorityProbeCooldown = 0.18,
    ClusterAuthorityProbeWindow = 1.60,
    ClusterAuthorityProbeMissCooldown = 1.60,
    ClusterAuthorityMaxProbeAttempts = 3,
    ClusterAuthorityHardMissCooldown = 5.0,
    ClusterAuthorityFieldRadius = 1800,
    ClusterQuestPhysicalFallback = true,
    ClusterSkipPhysicalFallback = true,
    ClusterStrictOwnership = true,
    -- v21.19 dual-coordinate cluster: server-shadow range drives DAMAGE, while
    -- local CFrame pinning is only the visual magnet. Never use the visual write
    -- to decide whether a server hit is plausible.
    ClusterShadowCombatEnabled = false,
    ClusterShadowVisualMagnet = false,
    ClusterShadowAttackRange = 100,
    ClusterShadowRangeSlack = 0,
    ClusterShadowVisualRefresh = 0.05,
    ClusterShadowMaxTargets = 12,
    ClusterShadowPreferLegacy = true,
    -- If one 100-stud circle cannot cover the whole spawn, move between a tiny
    -- number of FIELD coverage centers (never chase mob-by-mob). A center is held
    -- briefly, then stale/not-yet-damaged server-shadow targets get priority.
    ClusterShadowCoverageEnabled = true,
    ClusterShadowCoverageHold = 0.70,
    ClusterShadowCoverageFresh = 0.55,
    ClusterShadowCoverageSafety = 2.0,
    -- Current live public combat examples register a fresh attack before each
    -- tokenized single-target hit. Do the same for every proven stack member
    -- instead of relying on one batch swing being consumed for multiple victims.
    ClusterIndependentSwingFanout = true,
    -- Source-ad inspired but HP-verified: prefer the simple per-victim direct
    -- RegisterAttack/RegisterHit fanout before token/helper backends for a real pile.
    ClusterPreferLegacyFanout = true,
    ClusterIndependentSwingGap = 0.016,
    ClusterIndependentSwingMaxTargets = 12,
    CombatLateGrace     = 0.35,
    CombatProofsRequired= 2,
    -- A previously verified backend is re-probed after a quiet period, but
    -- ordinary island travel must not invalidate it every few seconds.
    CombatVerificationTTL= 120,
    CombatBaselineQuiet = 0.10,
    CombatRepeatProofGap= 0.9,
    CombatCausalWindow  = 0.65,
    IgnoreIncomingDamage= true,
    IncomingDamageGrace = 2.0,
    -- v22.3: raw HP loss is informational only. PvP hits and ordinary NPC contact
    -- must not change hover/target/action or manufacture a skill-dodge.
    IgnoreRawDamageEffects = true,
    -- v22.6 separate low-health safety. It raises hover/blocks unsafe client-M1 fallback
    -- but preserves target/action continuity and never creates a movement owner of its own.
    EmergencySafetyEnabled = true,
    -- Passive race abilities: cooldown-gated and movement-free.
    AutoRaceV3Ability     = true,
    AutoRaceV4Ability     = true,
    RaceAbilityCheckInterval = 0.35,
    RaceV3RetryCooldown   = 4.0,
    RaceV4RetryCooldown   = 4.0,
    -- Skill rotation is used only for deliberate mastery/preferred-tool training.
    MasterySkillRotationEnabled = true,
    MasterySkillRange     = 75,
    MasterySkillCooldown  = 1.15,
    MasterySkillKeyHold   = 0.045,
    -- v22.7 clean-room target aim. No global namecall hook or unknown remote signature.
    MasteryAimAdapterEnabled = true,
    MasteryAimMouseEnabled   = true,
    MasteryAimLeadSeconds    = 0.035,
    MasteryAimMaxVelocity    = 120,
    -- StartQuest is much less tolerant than ordinary travel/farm proximity.
    QuestInteractDistance    = 8,
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
    -- v21.27: Blox Fruit Gacha is available from Lv50 in every sea.
    -- The server owns the real level-scaled price/cooldown; do not hard-code Sea2/3 prices.
    RandomFruitInterval = 2,       -- rejected attempt fallback; unified economy worker retries conservatively
    RandomFruitSuccessCooldown = 7200, -- confirmed roll: respect the server cooldown
    RandomFruitMinLevel = 50,
    RandomFruitResultWait = 1.50,
    RandomFruitRejectRetry = 12,
    RandomFruitUnknownRetry = 4,
    RandomFruitMoneyRetry = 0.50,
    RandomFruitAttemptMinGap = 0.75,
    RandomFruitCooldownRejectDelay = 30,
    MeleePurchaseInterval = 0.35,
    EconomyTick          = 0.25,
    EconomyMeleePriorityHold = 0.00, -- compatibility only; v21.33 is Gacha-first
    EconomyPauseDuration = 2.10,
    EconomyGachaFirst = true,
    FruitStoreInterval  = 8,
    AttackDelay         = 0.08,
    QuestDelay          = 1.5,
    QuestRetryLimit     = 3,
    QuestRetryBackoff   = 6,
    QuestAcceptGrace    = 1.25,
    RecoveryDelay       = 3,
    ActionLockTimeout   = 240,  -- v21.27 progression puzzles refresh token; 4m hard safety only
    BossEnabled         = true,
    FruitEnabled        = true,
    AutoStats           = true,
    AutoItems           = true,
    AutoRedeemCodes     = true,
    RedeemCodeDelay     = 0.45,
    -- Local-only bring-mob for nearby quest enemies; no extra movement loop.
    GatherMobs          = true,
    SharedSourceFarmMode = true,
    ReferenceCoreMode    = true, -- v22: combat-first target handoff inspired by the studied kaitun behavior
    BringIsOptimization  = true, -- never require a successful magnet before attacking
    SafeSoftBring         = true, -- v22.1: never PlatformStand/freeze live quest mobs
    SoftBringRequireProof = true, -- unknown ownership must persist before a BodyPosition hold is allowed
    SoftBringProofDelay   = 0.18,
    SharedProbeWaveSize    = 3,
    SharedProbeLaunchInterval = 0.15,
    SharedProbeAttackWindow = 0.45,
    SharedProbeTimeout     = 0.75,
    SharedHPProofTTL       = 1.25,
    SharedHPProofMissGrace = 0.85,
    -- v22.6: primary target must produce real HP progress while an attack window is active.
    SharedPrimaryNoDamageTimeout = 3.0,
    SharedPrimaryRecoveryCooldown = 1.0,
    SoftBringVerifiedTTL  = 2.5,
    SoftBringRetryDelay   = 1.5,
    AdaptiveBringToTarget= true, -- pull other quest mobs toward the current live victim
    SharedBringRange     = 350,
    SharedBringFieldRange = 1200, -- active field only; avoids cross-island physics work
    SharedBringMaxMobs   = 0, -- 0 = all matching mobs in the active field
    SharedBringInterval  = 0.03,
    SharedFarmHeight     = 25,
    -- v22.14: moving Teddy air-sweep replaces the old fixed q.MC pile.
    SharedTeddyMode      = true,
    TeddyAirSweepMode    = false,
    TeddySequenceMode    = true,
    TeddySequenceAcquireHover = 12,
    TeddySequenceAcquireRadius = 38,
    TeddySequenceTagTimeout = 3.25,
    TeddySequencePullTimeout = 1.20,
    TeddySequenceStableDelay = 0.18,
    TeddySequenceVerifyRadius = 13,
    TeddySequenceRetryDelay = 0.28,
    TeddySequencePileHover = 24,
    TeddySequenceAttackRange = 120,
    TeddyAirHoverHeight  = 28,
    TeddyAirTagHoverHeight = 16,
    TeddyAirAcquireHeight = 4,
    TeddyAirSweepSpeed   = 430,
    TeddyAirSweepHold    = 0.55,
    TeddyAirAcquireRadius = 22,
    TeddyAirFieldRange   = 1800,
    TeddyAirVerifyTTL    = 0.80,
    TeddyAirPileYOffset  = 0,
    TeddyAirPileDepth = 8, -- moving pile stays close under the player, independent of travel hover height
    TeddyAirPullUnknownNear = true,
    TeddyAirRequireOwnerForPull = false,
    TeddyAirUseBodyPosition = true,
    TeddyAirHoldP = 7000,
    TeddyAirHoldD = 240,
    TeddyAirHoldMaxForce = 1000000000,
    TeddyAirStackLeash = 42,
    -- v22.15: exact per-mob HIT -> HP PROOF -> PULL -> STACK loop.
    TeddyAirFocusTimeout  = 4.25,
    TeddyAirPullTimeout   = 3.25,
    TeddyAirPullVerifyRadius = 15,
    TeddyAirPullStableDelay  = 0.14,
    TeddyAirCausalDamageWindow = 1.00,
    TeddyAirRetryDelay    = 0.35,
    SharedTeddyScanInterval = 0.03,
    SharedTeddyVerifyTTL = 0.35,
    SharedTeddyVerifyRadius = 12,
    SharedTeddyMaxDistance = 3000,
    SharedFixedPile      = false,
    SharedPileEmptyHold  = 2.0,
    SharedBringP         = 3000,
    SharedBringD         = 100,
    SharedClassicStableDelay = 0.14,
    SharedClassicVerifyRadius = 14,
    SharedClassicHardSnapDistance = 22,
    SharedClassicState14 = true,
    SharedBringMaxForce  = 1000000,
    SharedAttackMaxTargets = 32,
    SharedBringFailureLimit = 50, -- diagnostic only while blacklist is disabled
    SharedBringProofDelay = 0.16,
    SharedBringSnapDistance = 55,
    SharedBringIgnoreSeconds = 0.5,
    SharedBringBlacklistEnabled = false,
    QuestFarmIsolation = true, -- protects against duplicate workers; scheduler may still start bounded atomic detours
    AtomicResumeGrace = 2.5,
    OptionalDetourMinFarmSeconds = 2.0,
    FruitFinderPreemptQuest = true,
    FruitFinderFailedRetry = 90,
    EliteWakeEnabled = true,
    EliteWakePreemptQuest = true,
    MasteryToolSchedulerEnabled = true,
    FruitFinderEnabled = true,
    FruitFinderScanInterval = 0.85,
    FruitFinderTimeout = 5.0,
    FruitFinderMaxDistance = 450, -- v22: atomic local snatch only; never cross-sea chase
    BerryPickupEnabled = true,
    BerryPickupMaxDistance = 550,
    BerryPickupTimeout = 5.0,
    BerryFailedRetry = 90,
    AutoCastleRaidEvent = true,
    CastleRaidMinLevel = 1500,
    CastleRaidTimeout = 90,
    SmartFarmStuckEnabled = false, -- base Travel watchdog stays authoritative
    SmartFarmStuckTimeout = 40,
    SmartFarmStuckRetryLimit = 3,
    SmartFarmStuckHop = false,
    EntranceShortcutMinDistance = 3000,
    -- Sea 1 optimized skip route (Fountain, bosses, Upper Sky/Galley).
    -- Enabled only after the combat adapter confirms real fast damage.
    SkipLevelRoute      = true,
    -- v22.11.1 execute-safe early-skip direct magnet.
    SkipDirectMagnetEnabled = false,
    SkipDirectMagnetRange = 700,
    SkipDirectMagnetFieldRange = 1300,
    SkipDirectMagnetInterval = 0.03,
    SkipDirectMagnetVerifyRadius = 55,
    SkipDirectMagnetPinnedTTL = 0.18,
    -- Bring matching quest mobs only inside the current island/farm area.
    -- Simulation ownership is requested before movement to avoid ghost mobs.
    GatherMaxDistance   = 3000,
    GatherSimulationRefresh = 0.03,
    GatherVerifiedTTL   = 3.50,
    -- v19.0 all-mob cluster: gather ALL matching mobs in the current farm
    -- area in one magnet pass. Attack target count stays separately bounded.
    ClusterRefresh      = 0.010,
    ClusterStackRadius  = 0,
    ClusterAcquireGrace = 0.35,
    -- A quest uses only its current spawn field. GatherMaxDistance remains the
    -- emergency chase limit for stale QDB coordinates, not the magnet radius.
    ClusterQuestRadius  = 1800,
    ClusterQuestSearchRadius = 3000,
    -- v21.33: no blind ring. Follow exact game spawn markers + learned live positions.
    ClusterFieldPatrolEnabled = true,
    ClusterFieldPatrolRadius = 0,
    ClusterFieldPatrolOuterRadius = 0,
    ClusterFieldPatrolHold = 0.55,
    ClusterFieldPatrolArrival = 18,
    ClusterFieldPatrolSpeed = 400,
    ClusterFieldPatrolHeight = 24,
    ClusterSpawnMemoryLimit = 24,
    ClusterSpawnMemoryMerge = 18,
    ClusterSpawnMarkerRefresh = 2.0,

    ClusterAcquireSweep = true,
    ClusterAcquireTimeout = 0.75,
    ClusterAcquireMaxTimeout = 1.80,
    ClusterAcquireSettle = 0.20,
    ClusterAcquireRetry = 0.06,
    ClusterAcquireMaxAttempts = 3,
    ClusterAcquireCycleRetry = 0.75,
    ClusterAcquireArrivalThreshold = 8.0,
    ClusterAcquireTravelSpeed = 420,
    ClusterAcquireHoverHeight = 6,
    ClusterAcquireGroupRadius = 240,
    ClusterOwnershipSettle = 0.18,
    ClusterAcquirePreferCoverage = true,
    -- v21.23: fallback ONLY for environments where ownership cannot be queried.
    -- It requires real HP damage at the mob's real position + close physical approach,
    -- then a one-shot movement persistence test before the mob may join the pile.
    ClusterDamageLeaseEnabled = false,
    ClusterDamageLeaseAcquireRadius = 28,
    ClusterDamageLeaseProofWindow = 0.28,
    ClusterDamageLeaseProofChecks = 5,
    ClusterDamageLeaseProofRadius = 7,
    ClusterDamageLeaseSnapRejectRadius = 18,
    ClusterDamageLeaseTTL = 2.50,
    -- v21.22: a single exact pile stays horizontally under the player during sweep.
    ClusterOnePileUnderfoot = true,
    ClusterPileFollowDuringSweep = false,
    ClusterPileSettleRadius = 12,
    ClusterPileUseAcquireGroundY = false,
    -- v21.34 fixed-pile phase farm. Gather first, then kill the stack.
    ClusterFixedPile = true,
    ClusterFixedAnchorRelocateDistance = 650,
    ClusterAcquireBeforeAttack = true,
    ClusterAcquirePhaseBudget = 4.0,
    ClusterKillPhaseSlice = 1.15,
    -- v22.10: early-skip gets a longer gather window and a longer stable kill slice.
    SkipAcquirePhaseBudget = 5.50,
    SkipKillPhaseSlice = 2.20,
    ClusterAcquireTouchRadius = 95,
    -- v21.36: allow one proximity persistence probe even when an executor
    -- keeps reporting isnetworkowner=false. Snap-back + HP liveness still decide truth.
    ClusterProbeExplicitFalseOwner = true,
    ClusterFalseOwnerProofCooldown = 2.50,
    ClusterUnstackedKillSlice = 3.25,
    ClusterUnknownPersistenceProof = true,
    ClusterUnknownPersistenceTime = 0.18,
    ClusterUnknownPersistenceChecks = 2,
    ClusterUnknownPersistenceRadius = 8,
    ClusterUnknownPersistenceRejectRadius = 22,
    ClusterPersistNoDamageTimeout = 1.35,
    ClusterPersistReacquireCooldown = 0.55,
    ClusterWaveNewMobPreempt = true,
    ClusterAnchorVerifyRadius = 9,
    ClusterAnchorMaxDrift = 18,
    ClusterSimulationRadius = 10000,
    ClusterAttackMaxTargets = 64,
    -- v21.6: executor-safe fallback when isnetworkowner/GetNetworkOwner is unavailable.
    -- A root is moved only after Farm physically approaches it, then it must remain
    -- at the anchor for several Heartbeats before it becomes a verified attack target.
    ClusterUnknownOwnerFallback = true,
    ClusterOwnershipTouchRadius = 85, -- compatibility only; remote pull no longer requires touch
    ClusterUnknownProofTime = 0.28,
    ClusterUnknownProofChecks = 3,
    -- v21.13 remote-magnet-first policy.
    ClusterRemotePullFirst = true,
    ClusterRemotePullRetry = 0.12,
    ClusterRemotePullProofTime = 0.18,
    ClusterRemotePullProofChecks = 2,
    ClusterRemotePullGrace = 1.20,
    ClusterPhysicalAcquireFallback = true,
    ClusterUnknownPhysicalFallbackDelay = 3.00,
    -- v19.0 smart fragment raid (core-only; not exposed in external Configs).
    AutoFragmentRaid     = true,
    RaidPreferredNames   = {"Flame","Dark","Ice","Sand","Smoke"},
    RaidGatherRadius     = 700,
    RaidTravelSpeed      = 300,
    RaidHoverHeight      = 22,
    RaidFastAttackMaxTargets = 32,
    RaidRunTimeout       = 900,
    RaidNoChipRetry      = 20,
    RaidFragmentDemandTTL= 120,
    RaidCheapFruitMaxPrice = 650000,
    RaidReserveCheapFruit = true,
    RaidLabFallback = true,
    RaidLabMaxClicksPerButton = 8,
    RaidStartConfirmTimeout = 12,
    RaidStartRetry = 2.0,
    FruitPopupGuard = true,
    -- v21.35 one scheduler / progression hardening.
    PrioritySchedulerInterval = 0.20,
    PriorityPassiveInterval = 1.25,
    PriorityStatusStallTimeout = 75,
    SeaTransitionCleanup = true,
    LegendarySwordHopFailures = 3,
    KatakuriProgressStallTimeout = 120,
    -- Core movement optimization: one short snap only for the active quest mob.
    -- This is intentionally not exposed in Configs; it is part of the farm core.
    NearQuestSnap        = true,
    NearQuestSnapDistance= 70,
    NearQuestSnapCooldown= 0.08,
    -- Optional item failure/timeout must not block level farming forever.
    ItemRetryCooldown   = 15,
    ServerHopCooldown   = 120,
    MaxFarmDistance     = 300,
    StatBatchLimit      = 100,
    -- [D-1/C-8] Chỉ né chiêu của NPC trong workspace.Enemies. Kỹ năng và
    -- sát thương từ người chơi không làm đổi target/hover/bring của kaitun.
    DodgeAttacks        = true,
    -- v22.3: only real NPC skill evidence may trigger dodge. Raw HP loss never does.
    DodgeOnRawDamage    = false,
    DodgeKeepAttacking  = true,
    DodgeSideStepOnly   = true,
    -- Target-lock side-step: same TravelManager owner, same target, same combat stream.
    DodgeCooldown       = 0.28,
    DodgeDistance       = 18,
    DodgeHeight         = 0,
    DodgeRadius         = 46,
    DodgeEmergencySpeed = 380,
    DodgeMinHold        = 0.12,
    DodgeSafeConfirm    = 0.12,
    DodgeMaxHold        = 0.68,
    DodgeDamageFallbackHold = 0, -- ignored: raw damage never triggers dodge
    DodgeReplanInterval = 999,   -- one sidestep only
    DodgeMonitorInterval= 0.04,
    DodgeHazardTTL      = 0.85,
    DodgeHazardMargin   = 5,
    DodgeHazardTrackRadius = 82,
    DodgeConfirmSamples = 2,
    DodgeGlobalHazardRadius = 34,
    DodgeTargetHazardRadius = 90,
    DodgeEffectSourceRadius = 34,
    DodgeCastArmTTL     = 0.50,
    DodgeSkillPulseTTL  = 0.44,
    DodgeIncomingRadius = 38,
    DodgeIncomingLookahead = 0.58,
    DodgeIncomingMinSpeed = 7,
    DodgeIncomingDot    = 0.22,
    QuestUILease        = 0.65,
    QuestCloseConfirm   = 0.20,
    -- [D-4] Skip level không hiệu quả: cùng route quá N giây mà level
    -- không tăng → tắt skip route, quay về farm quest bình thường.
    SkipRouteFallbackTimeout = 90,

    -- v17 progression: all are non-blocking. A missing server event/key never
    -- freezes the level farm; the controller retries only in safe quest windows.
    AutoAdvancedItems   = true,
    -- Live Sea-2 Factory is core kaitun work: event appearance can preempt a normal
    -- quest, but never another claimed progression action. Not exposed in Configs.
    AutoFactoryEvent    = true,
    FactoryMinLevel     = 700,
    FactoryFightTimeout = 300,
    FactoryRetry        = 2.0,
    -- v20.1: low-risk ability purchases seen in mature kaitun configs.
    -- Server validates level/money/ownership; probes are throttled and never own movement.
    AutoCoreAbilities   = true,
    CoreAbilityRetry    = 45,
    -- Silent always-on Armament watcher. Remote itself is state/cooldown gated.
    ArmamentWatchInterval = 0.15,
    ArmamentRetryCooldown = 0.45,
    ArmamentConfirmGrace  = 0.80,
    -- Core kaitun progression: always enabled internally; intentionally NOT exposed in Configs.
    AutoFightingStyles  = true,
    AutoBuyMelee        = true,
    AutoBuySwords       = true, -- TTK/progression swords only; no completionist shop sweep
    AutoTrueTripleKatana= true,
    LegendarySwordProbe = 8,
    TTKMasteryTarget    = 300,
    AutoRaceV2          = true,
    AutoCDK             = true,
    AutoSoulGuitar      = true,
    ProgressionRetry    = 8,
    InventoryCacheTTL   = 5,
    OptionalWorkTimeout = 150,
    -- v21 researched material / puzzle controllers. Core-only; no extra config keys.
    MaterialFarmTimeout = 240,
    MaterialRetry       = 12,
    MaterialInventoryRefresh = 1.5,
    DeathKingRollRetry  = 2.0,
    DeathKingReserveRolls = 10,
    CDKTrialTimeout     = 600,
    CDKDimensionRadius  = 1200,
    SkullSwampTimeout   = 240,
    SkullPuzzleTimeout  = 180,

    AutoKatakuri        = true,
    KatakuriOnlyMax     = false,
    KatakuriMinLevel     = 1500, -- v22: pre-farm Dough King/Mirror Fractal once Third Sea is reached
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
    -- Hard progression may server-hop even when generic Hop is disabled.
    -- This is intentionally limited to a missing required boss/key/item spawn.
    HopRequiredProgression = true,
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
    SnipeFruit           = {},
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
        _G.Settings.GetFruits = bool(cfg["Get Fruits"], _G.Settings.GetFruits)
        _G.Settings.FruitEnabled = _G.Settings.GetFruits
        _G.Settings.RainbowHaki = bool(cfg["Rainbow Haki"], _G.Settings.RainbowHaki)
        _G.Settings.Shutdown = bool(cfg["Shutdown"], _G.Settings.Shutdown)
        do
            local snipe = cfg["Snipe Fruit"]
            if type(snipe) == "string" then
                _G.Settings.SnipeFruit = snipe ~= "" and {snipe} or {}
            elseif type(snipe) == "table" then
                local out = {}
                for _, name in ipairs(snipe) do
                    if type(name) == "string" and name ~= "" then out[#out + 1] = name end
                end
                _G.Settings.SnipeFruit = out
            end
        end
        _G.Settings.SwitchMelee = bool(cfg["Switch Melee"], _G.Settings.SwitchMelee)
        _G.Settings.LockFragment = math.max(0, num(cfg["Lock Fragment"], _G.Settings.LockFragment))
        _G.Settings.HopPlayerNear = bool(cfg["Hop Player Near"], _G.Settings.HopPlayerNear)

        local core = cfg["Farm Core"]
        if type(core) == "table" then
            _G.Settings.ReferenceCoreMode = bool(core["Reference Mode"], _G.Settings.ReferenceCoreMode)
            _G.Settings.GatherMobs = bool(core["Bring Mobs"], _G.Settings.GatherMobs)
            _G.Settings.BringIsOptimization = bool(core["Bring Is Optimization"], _G.Settings.BringIsOptimization)
            _G.Settings.SafeSoftBring = bool(core["Safe Bring"], _G.Settings.SafeSoftBring)
            _G.Settings.SharedFarmHeight = math.clamp(num(core["Farm Height"], _G.Settings.SharedFarmHeight), 8, 60)
            _G.Settings.FruitFinderEnabled = bool(core["Atomic Fruit Pickup"], _G.Settings.FruitFinderEnabled)
            _G.Settings.BerryPickupEnabled = bool(core["Atomic Berry Pickup"], _G.Settings.BerryPickupEnabled)
            _G.Settings.EliteWakeEnabled = bool(core["Elite Observer"], _G.Settings.EliteWakeEnabled)
            _G.Settings.AutoCastleRaidEvent = bool(core["Castle Raid Event"], _G.Settings.AutoCastleRaidEvent)
            _G.Settings.KatakuriOnlyMax = not bool(core["Early Dough King"], not _G.Settings.KatakuriOnlyMax)
            _G.Settings.SmartFarmStuckEnabled = bool(core["Smart Stuck Hop"], _G.Settings.SmartFarmStuckEnabled)
            _G.Settings.IgnoreRawDamageEffects = bool(core["Ignore Raw Damage"], _G.Settings.IgnoreRawDamageEffects)
            -- v22.6: these are independent policies; changing Ignore Raw Damage no longer
            -- silently flips emergency hover or manufactures a raw-damage dodge.
            _G.Settings.EmergencySafetyEnabled = bool(core["Low Health Safety"], _G.Settings.EmergencySafetyEnabled)
            _G.Settings.DodgeKeepAttacking = bool(core["Dodge While Attacking"], _G.Settings.DodgeKeepAttacking)
            _G.Settings.DodgeSideStepOnly = bool(core["Side Step Dodge"], _G.Settings.DodgeSideStepOnly)
            _G.Settings.DodgeOnRawDamage = bool(core["Raw Damage Dodge"], _G.Settings.DodgeOnRawDamage)
        end

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
            _G.Settings.MasterySkillRotationEnabled = bool(mastery["Use Skills"], _G.Settings.MasterySkillRotationEnabled)
            _G.Settings.MasterySkillRange = math.clamp(num(mastery["Skill Range"], _G.Settings.MasterySkillRange), 8, 100)
            _G.Settings.MasterySkillCooldown = math.clamp(num(mastery["Skill Cooldown"], _G.Settings.MasterySkillCooldown), 0.25, 5)
            _G.Settings.MasteryAimAdapterEnabled = bool(mastery["Target Aim"], _G.Settings.MasteryAimAdapterEnabled)
            _G.Settings.MasteryAimMouseEnabled = bool(mastery["Mouse Aim"], _G.Settings.MasteryAimMouseEnabled)
        end

        local hop = cfg.Hop
        if type(hop) == "table" then
            _G.Settings.HopEnabled = bool(hop.Enable, _G.Settings.HopEnabled)
            _G.Settings.HopRequiredProgression = bool(hop["Hop Required Progression"], _G.Settings.HopRequiredProgression)
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
_G.BobonStatus = "Initializing Kaitun..."
_G.BobonDiagnostics = {
    Tool = "wait",
    Net = "wait",
    Targets = 0,
    Packet = "wait",
    Bring = "wait",
    BringCandidates = 0,
    BringOwned = 0,
    BringDamageProven = 0,
    BringUnknown = 0,
    BringServerOwned = 0,
    BringProbe = 0,
    BringMoved = 0,
    BringFailed = 0,
    BringBlacklisted = 0,
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
    if (game.PlaceId ~= 7449423635 and game.PlaceId ~= 100117331123089)
        or not IsFiniteVector3(pos) then return false end
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
    FragmentDemandGoal = 0,
    FragmentDemandCost = 0,
    FragmentDemandReason = nil,
    FragmentDemandPriority = 0,
    FragmentDemandAt = 0,
    RaidLastGain = 0,
    RaidLastStart = 0,
    RaidLastFinish = 0,
    -- Intentional-death CDK trial marker. Unlike an ActionToken it survives respawn.
    CDKResumeStage = nil,
    -- Canonical workspace enemy name for the quest that is actually active.
    -- Quest UI may be localized, so gathering must not infer a mob name from
    -- the visible translated text on every frame.
    ActiveQuestMob   = nil,
    -- v18.6 persistent cluster state. Anchor is independent from FarmTarget.
    ClusterMode      = "OFF",
    ClusterAnchor    = nil,
    ClusterPileAnchor= nil,
    ClusterMobName   = nil,
    ClusterMobNames  = nil,
    ClusterPrimary   = nil,
    ClusterGeneration= 0,
    ClusterActivatedAt = 0,
    ClusterLastSeen  = 0,
    ClusterLastMoved = 0,
    ClusterAcquireTarget = nil,
    ClusterAcquireStartedAt = 0,
    ClusterAcquireDeadline = 0,
    ClusterAcquireCompleted = 0,
    ClusterFixedAnchor = nil,
    ClusterPhase = "ACQUIRE",
    ClusterPhaseStartedAt = 0,
    ClusterWaveStartedAt = 0,
    ClusterLastCandidateCount = 0,
    ClusterPhaseVerified = 0,
    ClusterPhaseTotal = 0,
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
    DodgeActive       = false,
    DodgeThreatName   = nil,
    QuestLastSeenAt   = 0,
    QuestClosedSince  = 0,
    QuestClosedStable = false,
    ProgressionLock   = nil,
    WorkIntent        = "LEVEL_FARM",
    -- v21.35 scheduler/sea-transition diagnostics live on State to avoid extra
    -- competing controller globals and to keep HUD/debug state authoritative.
    LastKnownSea      = 0,
    SeaTransitionAt   = 0,
    PriorityStage     = "BOOT",
    PriorityDetail    = "",
    PriorityHint      = "",
    ActionText        = "Initializing",
    ObjectiveText     = "Reach Max Level",
    ObjectiveProgress= "",
    ResumeFarmUntil   = 0,
    LastAtomicOwner   = nil,
    LastAtomicEndAt   = 0,
    FarmLeaseSince    = 0,
    PriorityLastPassiveAt = 0,
    PriorityWatchOwner = nil,
    PriorityWatchStatus = nil,
    PriorityWatchAt   = 0,
    EconomyPauseUntil = 0,
    EconomyPauseReason= nil,
    FarmSafetyUntil   = 0,
    FarmSafetyActive  = false,
    LastTargetContested = 0,
    ContestedTarget  = nil,
    ContestedBy      = nil,
    ConsecutiveFails = 0,
    Sea              = 1,
}

-- v21.33 SINGLE ECONOMY OWNER.  Melee and Gacha are both Beli spenders; running
-- them in independent workers created a race where Gacha could spend the exact
-- 150k/500k/750k threshold before the style buyer, or a style/core purchase
-- could be mistaken for Gacha success merely because Beli dropped.
_G.BobonEconomy = {
    Busy = false,
    Owner = nil,
    Wake = true,
    MeleeBlockFruitUntil = 0,
    LastMeleeAttempt = 0,
    LastGachaAttempt = 0,
}
function _G.BobonEconomy:Notice(text, ttl)
    if not _G.BobonDiagnostics then return end
    _G.BobonDiagnostics.Economy = tostring(text or "ECON")
    _G.BobonDiagnostics.EconomyUntil = tick() + (ttl or 2.5)
end

function _G.BobonEconomy:PauseFarm(reason, duration)
    local state = _G.State
    if not state then return end
    local hold = math.max(0.35, tonumber(duration) or (_G.Settings.EconomyPauseDuration or 2.10))
    state.EconomyPauseUntil = math.max(tonumber(state.EconomyPauseUntil) or 0, tick() + hold)
    state.EconomyPauseReason = tostring(reason or "ECONOMY")
    -- TravelManager is a later local; the main controller owns the actual Stop on
    -- the next tick. Keeping this helper state-only also preserves single movement ownership.
    self:Notice(state.EconomyPauseReason, hold)
end

function _G.BobonEconomy:TryBegin(owner)
    if self.Busy then return false end
    self.Busy = true
    self.Owner = tostring(owner or "ECONOMY")
    return true
end

function _G.BobonEconomy:End(owner)
    if owner == nil or self.Owner == tostring(owner) then
        self.Busy = false
        self.Owner = nil
        return true
    end
    return false
end

function _G.State:SetMode(mode)
    -- v21.33: Mode is state, not a status message.  The old assignment below made
    -- every 0.15s farm tick overwrite detailed Saber/Boss/Farm text and created
    -- misleading HUD flicker even when the movement owner had not changed.
    self.Mode = mode
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
        local finishedOwner = self.ActionOwner
        self.ActiveActionToken = 0
        self.ActionOwner = nil
        self.ActionStartTime = 0
        self.LastAtomicOwner = finishedOwner
        self.LastAtomicEndAt = tick()
        -- v22 atomic resume grace: after a bounded detour finishes, give the level-farm
        -- loop a short uncontested window to reacquire its quest/target before another
        -- optional intent may claim movement. Hard progression gates ignore this grace.
        if finishedOwner and tostring(finishedOwner) ~= "Farm" then
            self.ResumeFarmUntil = tick() + math.max(0.5, tonumber(_G.Settings.AtomicResumeGrace) or 2.5)
        end
    end
end


function _G.State:ForceReleaseAction(reason)
    local finishedOwner = self.ActionOwner
    self.ActiveActionToken = 0
    self.ActionOwner = nil
    self.ActionStartTime = 0
    self.LastAtomicOwner = finishedOwner or reason
    self.LastAtomicEndAt = tick()
    self.ResumeFarmUntil = tick() + math.max(0.5, tonumber(_G.Settings.AtomicResumeGrace) or 2.5)
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


local BobonUIRoot = nil
local BobonUIConnections = {}

-- ══════════════════════════════════════════════════════════════════
--       UI — BOBONHUB CAT GLASS HUD v6.1 | ENGLISH REAL ACCOUNT STATUS
--   Approved layout: unified mascot logo, framed intro, letter reveal,
--   slow panel load, live Status Farm/Status Item and real item checker.
-- ══════════════════════════════════════════════════════════════════
do
    local okUI, uiErr = pcall(function()
        local UIS = game:GetService("UserInputService")

        local CYAN       = Color3.fromRGB(83, 218, 255)
        local CYAN_SOFT  = Color3.fromRGB(177, 218, 234)
        local CORAL      = Color3.fromRGB(255, 153, 138)
        local GREEN      = Color3.fromRGB(100, 245, 140)
        local YELLOW     = Color3.fromRGB(255, 206, 92)
        local RED        = Color3.fromRGB(255, 104, 96)
        local WHITE      = Color3.fromRGB(246, 249, 255)
        local DARK       = Color3.fromRGB(5, 9, 17)
        local DARK_CARD  = Color3.fromRGB(8, 13, 24)
        local MUTED      = Color3.fromRGB(167, 190, 205)

        local function SafeDestroy(obj)
            pcall(function() if obj then obj:Destroy() end end)
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

        -- One embedded image is used for INTRO + HEADER + TOGGLE so the mascot
        -- can never silently change between stages. Custom-asset APIs are executor
        -- capabilities; if unavailable the exact same B fallback is used everywhere.
        local LOGO_B64 = "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAQDAwMDAgQDAwMEBAQFBgoGBgUFBgwICQcKDgwPDg4MDQ0PERYTDxAVEQ0NExoTFRcYGRkZDxIbHRsYHRYYGRj/2wBDAQQEBAYFBgsGBgsYEA0QGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBj/wAARCACAAIADASIAAhEBAxEB/8QAHQAAAQQDAQEAAAAAAAAAAAAAAAEGBwgCAwUJBP/EAD0QAAEDAwMCBAMDCwMFAQAAAAECAwQFBhEABxIhMQgTQVEUImEycYEVFyMzQlJicoKRoRYkQxg1g5LB0f/EABoBAAIDAQEAAAAAAAAAAAAAAAAEAgMFAQb/xAAyEQABAwMCAwUHBAMAAAAAAAABAAIDBBEhEjFBUWEFE3GBkRQiobHB0fAjUuHxBjLS/9oADAMBAAIRAxEAPwCkGcaTRo0wq0aNGlxoQk0aXGk0IRpfXShBPYZ1ujwpUpWI0dx4+zSSs/410AnZcLgNytGToOuxT7VuKq1VumU+izpEx3PBhDKuRAGSeoGAB1JPQeut9esu57YZZfrdHkRGHyQ0/wDK404R3CXEEpJHqM51Pun2vbCq9pi1BmoXPC+VwNGdB76PXVauRnR30Y0mhCX00vp01jpR20ISaNGjGhCyGnfQ6DRI9rKum7HZqYCnzEhwoJQl+c8lIUsBawUttoSpPJZB6rSACScNJsAuJH11O9l2XTr13h2+sestqdo8C2V1ibHSop8xTvmSCCR+8THSfoManqbHG6V3BLyMfPNHTRmxebeX92HmmCmLtnVmylC7lt1w9npAaqkcfz+UG3Uj6hKvu1inay4X5jDkJynzqQ8lTia7GkhUBDaBla3Hv+LiOpSsBQ7cSSAXLvTtSdtq43WKKhaaFJc4KbBJ+EcPbie/BWDjPYgj20wKU5JmPSmvPcRBUUCUw2tSW5i0nkgOpB4r4nrkjOTqNNWRVDA+30Vlf2VVUEph12I55FuYOD6k8sJ5QzbVFZQLbpcOpLx/3+vRy4lw+8WCSAE+y3sk/up7a+xy77mdR5X+tLlCh/wwpIgMoHvwYSkD7hpg1C7o7UpaGGlSlg4U4VcU5+nvopl1w3XksSmFRys/rCrkkk+/tq72h2wNkqKCLd41Hmcn+PKw6J3TarcNTo0ilTrwuqTCkAJdjv1Rx1tYBBwUr5ZGQDgn01zaLKft1U+myocer0KptoRIp7rioYLiFBSHELbBCHRggL4kEKUkjrr7B21qkMh6Mtsj7QwPofQ/3xqPeOvqvlWGli0FmmwPLHnjj1WDtk0i4XOFlTZSakQVf6fqwQiWsDqfh3E/o5OPZPFf8J18EXbS53YCahUI8eiQF/ZmVuSiA2v+XzSFL/pB19qmm5UNHmo5JOFgA4KVd8pI6pIPqOuuBUGa9OutDLhm1uqT3AiPIfWp6Q8on7KlqJII/AY66kZI7anNVbaeoDtEb7g8xc+GCL/PxXSkbfS1U2VMolwW9cHwbRfksUmd5rzTaftOeWpKVKQPVSQQO5wOumepJBxqaantfcu0dMtDcupVlqS4a2xFkRG28JaStJUQF5+dKkJdQrIGc+2ozvSkt0HcGt0Vno1Cnvxm/wCVDikp/wAAaqZJHPH3sW17Jl8NRSVBpqne1x9j6j16LgaXOjvoxqKtSaNGjQhbWv1qfv1aXZYp/wCqltR6Bzb2MWvwjxwcf+qtVYQrisEe+rC7V1tunb5bRV95wJjVSmyLXkLPYOJU60gH8Ho51yoaX0sjRy/Pmo00gi7Rp5HbXt9fopK8TFwGjbZqiTLRkVamVBC4zs9p8ITDcPVvkniT1ICgegynHrqpSR+T7RLSDxdKAkq/jWQCf8/41MXiurcSp7hwbYhzp65UBkLnNGSTHYUrqlAa7eZj5lKPXBSPTUELjs4LkgqeV3KnCVE/hrM7Jj7unBtk5Xov8lqTPWube4bjh+b80rFvsvFSfi3ElKuIPFJ5fUde2vmqNFVCnGMmSl0eUXeRTx6Zxj11sSzFUQDCKAexKMan3wteHeHvZuHOdr7Mxm1KUwRMeiulpTz6xhplC+uCOriunQBIP2hrSJCwLKPaW4XKNEU4cqLKCT/SNfWSB66s1vR4KUWLtdWLv2xu+4Zy6Uz8UqjVFLUguMpP6TgtKUnKUZUBg5449tUzZuapoGH47ElBH2m/kP3j01IPBXC0p2R8CG1/KNcyoTpVNntVGCrjKguImMK9loPIfgQCD9+sIVyUt9KWHHFRXAAkIfHH/PbWmor8yQ8f2SnAPuMa6QHCxQ0lpBG6tF4jqoxXPDdakiKBitV+A9HSPZUdxXT7vMSNVl3SdQ/vNdTiCCk1aUAR9HVD/wCamOvVNNWpvh7sx9Y8qFTG7ingnPFpCQQVf+OKs/1ar1VZzlSrUqoPH9JJeW+vPutRUf8AJ0v2dF3NJp5k/D+1f2zU+1dqGTk0fG3/ACviGl1jpRq9UJNGjQNCFkAc9NP6IZX5hp8551UM0msRptIlKOC5KV8rrDfqVcA26cdE+UM45DPO25pFJrl6Jp1VZdkrXHdMKGh8RxMlBOWmFOYPALIKcjrkpGRnI7sW091N22F1ag2XNqMGjrMFulUVkFFJ9Sj4cKLiSogkrUCVkHKiR0vbZjC48cLPmLpphE3GkhxPnw8bWPCyZU+o1KtVydXazKVKqVQkLlyn1DBccWoqUcDt1PYdBr51KCRyUoAe51KNH8OW+dbmJjxtsLgig936kyITSB7qW6UgDVq9l/A9Y8eMmsbqVSHdlRGCKRTpShCi/wA6kkLdV9/FPpg99J3A2Wnk5KqdsfsvWt8b8/IVHq1Op0OPhydMkPILjTfqWmM83VfcOI6clDsfVjbvb22Nr9vYNm2nC+Hp8RJJUs8nH3D1W64r9paj1J+4DAAAjar+E3Z9yVEq9nUZyx7igOB+BWredUy6w4OxKFEocT6FKh1BIz11j4ot0dxdodn4ly2NQ4tR/wB0GKlOfjqfEFopOHPKSpPQqATyJwnIz3Gok3RaynRQCklKhkHoQdebfiv8MadtqnL3DsxURNqTHiuRTlvIbcp7qj1DSVEeY0SchKcqR2wUgETx4SPEFunvVXa7FuugwnKHAjBbdcjRFRf9wVACOU81JWePJWU4KcdftDT/ALq8MVj7kbmTLx3Tn1a7CVcKdSnZC4sKnMYGEIQ0oFSiclSyr5iewxoGCjdeTbrTMlrCglQ9CNaG31wk/DvuOBg9Atvrxz7pPQ/hg69GN0/ATYlWpLlQ2ledtisNjKIMl9yRBk/wqKuS2z7KBIHqn11Sa9tmtz7HmuwLrsOuQ+KikPtxVPsLx6odbCkKH4/21MFcIWyypiqi7VzVrjjipyKI1QqLNlK8uMlscUKZW5jDKiyny0leEkrVlQ76ZVao1UoVakUysQn4cxhXF1h9PFST37exHUHsR1GRr4XadcFvoRNkUyfEjPqLaXJMZaGnsDJT8wAV07jT/tasMX5CjWLVwVyC0tujSl/M5BdShS0scj1XGXxKeJ/VqIKcDILcZbI0RbHgs2fXTyOqN2nfmLcR04keJHIx7pdKcdCOxGdY6oWgjRo0aEL66e8hioMuOBakJWkqCFcVEA5IB9D7H01ZK0odxXP4x4ku0r/gbeSpsFEqk1lhh19VbjezyVL4vPgJIcSvGVNq6EjJrIDjUk7fSk3IhmzKq+/GYZW5UafWGFcXqI82guLkIORlvDeVoyM8QpOFAZYi/UYYuazqsdzI2qOQ0EHwNs+VvTrZeq12UOhy9o2mtyKMi/Uw0IecZYpPnqmvD5UqbjJKhk8u2eIySSACQzdtbGgRryZuFrYCzdvYzKVmO628yaoSRgFTcdvy2xg9R5qiNQ5tnG3w3F8PUO/Nw9xLtp1G8kClUWx2ERqnWSVcEPOukEoLh7AcU4+dRSMnXSi1nxA7EW3Iu7cdynXPZPnBxdJqddTKrtOYByeEnymm5Sk9VFvrnjhJ9dZ5uNlrNsd09vFw9ctmbZwN5rFnPwrhtSQlClD52X4UlaG3mnmj0cRyDKvdJTkEd9Ul3E8Ze9e6VmyLOWik0eFNaLExFDiuB6U2RhSFKUtZSkjoQnGRkE4JGvTiqQbZ3Z2ckQS+mdb9y0spS+3+2y83lK057EBQUPYjVLdpbCpNjPVbbuvUxiNd1FkLTMTx4mcyVEsy2z3W2tOPXCSCCAdLVdT7PHr03Wh2VQNrp+5c/T9egUCbOeKTdTYmjOWzTYsCo0ZTinkUusMLT8OtRypTaklKkgnqQcjOTgEnV2/Cvc9772KqW91/T1M+W69RaNRoPJqDHZ/RreeCCSXHFLARzUTgIIHfpEO8tpUO4bei2ZTKO3ULurbyY1Fgp6ueZkcnye6G205UpfROBg5zq39g2pb2ymwVMtxU1pilW9TiuXOd+VJKQXH31e2VFavxxopKr2mPXpspdrdnNoJ+5a/Vj08U094rVo9UrUerVnaGpX3AQyESF0usKRKj4J+xEU42lzoc5SrkfY4127GgUGBs7LlbNwVxlvhao8K4n5zaGZKflLbyHip1nBGFJSB2z176hqq3v4g90qLFunZ6znLdsxx5S0VJyVGVWqnHz+sjsyMtM8sZAWeShjBAxri7jXV4hLB2DlX1bN7rvK3nWi3MTcdFTBq1BXz4KW4hoBLqW1cgpKk9Dg/Mnrpltzus1+kf6qr+7tO3T3C8R9WpO810wo0ukwXJrj1PImQadGA5JShCFDhyykAH51KUjPcHTHj1a0bLjyFWcipVCsvMrjis1JCGBFStJSsx2EFXFZSSnmtRIBOAD111Nw571umZaEeXInSpTyJ9arkhWXay+pIcQsH0YAXyQO5KuZ64CYzKiTrRNoBpA97mseNprf1XE92dhzHM8c8r2tuNwlVj06DSeug6PXSy00mjS40mhCUafVmo/Jtk3dcElRQwaW5SGcD53ZMr5UNo/pS4pXslJ9xpjDT9qCzF2cs9to4bkVWpyXv4nm2mEN5+oSokfzHV8ONTuQ/hJVvvBkX7jb0yfgLL078Md70W8vDVbCKY6wmTSoTVMmxG1DMd5pAQUkexxkH1BB08bs2023u2eqtXtaVGrbrcYxw7VmBISw1kk+WF5DZOeqkgE9MnoMeRVkbhXntxcIrdlXBLpMsgJcLRBQ8kdkuIOUrH3jp6Y099xvFlvhfFmuW7VLliRIMhBZfFMiCM4+kggpUvJIB9QnGfu0mW5T91Z/w075RrQsc2XWqJcP8ApWNVZsegXD8I5JhuRRIUENl5APDj1AKxjBHUY1YO9LQ2j3VjQ3LxpDEt+LlUSZzcjSY/Lv5b7RStIPcgKwfbTa8Pi7FvDYmgT7R4Rqe3DQx8FHVxMVaUjm2fULSvlnOc5B/aB1Ia7JPBQRPIUCeJUjIUPr7HQQ3YroJGQm5Zdi7ObVrl1G1aZHjzpCMSai+87MlOIHXip95SlBPTPHIHTtqBvEp4grcu2x/zc2u5VHqZVKnEgVyuRYq/hYsRT6Q6gyCOHJXRPyk9OWT6as3Eskh/M+UlbWPstZBP4nUceIL829H2YuulXTMS5mhPzRTXlk+Y0haGgU+yvOdZCTkHkRjsdcAaMBdJJyU+bC2h2229lGoWBQEURL7AZdbhyHfKkJHZTjZUUrWMdFkcupGcE653iGuWjWv4aLxlVpTSm5VLfgssLIzIdeQW0NgepJUOn/5rzx238Y29lk2fHoLU+lVmJHQGWXKrHU682lIAA5pUnkAOxVk/XTK3K3g3C3Zqzc69q+5MSwSqPDaQGo7BPqhsdM/U5P110NyokrnX0kS7bs6ssK82O9QY8QvHv50fLTqFexSQkfVJSfXTH0+VkP7FS+YHGPc2WPp5sTLoH0y22dMY6bmNyHcwkKH3WGP9pI+3wRoxox00uqU6sdGl0mhCyGnza649zWdKsSTMZhzlSU1CjSZCwhtMoJ4LYWo9EpdRxAUegWhGcAkhijWaVFJ6asjfpOdlRUQ962wNiMg8j+fBbqj8fR6tIpdYpsmFOjr4PRnkFDjah6KSeo1zC6ZsxAc+VAPROn9F3Cnu01imXLTKVc8JhIbZbrDBdcZQP2W30lLqE/QLwPbSu2XbtyOCbYdbjQZSzyNArkhLK0K/dZlKw26n2Cyhf399dMOrMZv81SKt0eKhtuoyPuPPHVWn8A1lzJ8+5buTcVYpkdh9mI1FhPhLEpYSVuea2pJSvCVNgHAI64Or/AEJAJyfU6oX4O9wPzUip2FuVR6hbbU+YJcGpTo6hFcWpCUKbLwBQD8iSk5wQSM5xm+DEmPKjofjPtvNLGUuNqCkqHuCO+lpGuachOxSskF2EEdEr5fEVwxktqeCT5aXFFKSrHTJAJAz9Dryu8YNK3DgeIWQdwq5HqTlQp7LsMwG1sxWY4Ur9A2hSifkXkkqOVFXLpnA9T5EqNEjqfkvoZbSCVLWcADXm94uq3O3h3kp7O39BqNaiUaK6w9U2GCIpcWsHiHlYQQkIGVcsZUQD00Rsc44F1yWZkYu9wA64VQY0kxHFII5oJ9NdamMVO4KuxR6DTpM2oyVcGWGU8lKPqfoB6k9AOpIA06I9n2ta6vjL3rEarzEdU0GiSPMBV7SJafkQn3S2VqPbKe+tc+/qgqkP0eg0+mW5THxwejUdjyS+n9111RU44PopWPppkQhuZDbpx/PyySNW6XFO2/U4H3Plg81su9+DR7fpljUuazORTluyZ82Ork3JnO8Q4W1ftNoShDaVftcVKHRQ0y/XSqUVHJ0moyP1G6Yp4e6Zpvc8TzJyUujRo1BXLHS6ANLoQsRpc6X66T10IRnWaVqHY9NYaXQiy7lIu+5qCMUWv1OnJ/diyltJP3hJAP9tO6Fv5u9T2Q1E3ArbaB0CQ6CB/cajTOl1a2eRosClZKKnkOp7AT4BSTN373dqDZRK3Bri0kYID4T0/ADTOq91XDXlZrVbqNRx2EuSt0D7gokDXG66XQZ5HYJRHRQRm7GAHoAlUtR7nWProJ0D21VdNI0Dvo9dLoQjRo0aEL/2Q=="
        local function DecodeBase64(data)
            local tries = {
                function()
                    if crypt and crypt.base64 and type(crypt.base64.decode) == "function" then
                        return crypt.base64.decode(data)
                    end
                end,
                function()
                    if syn and syn.crypt and syn.crypt.base64 and type(syn.crypt.base64.decode) == "function" then
                        return syn.crypt.base64.decode(data)
                    end
                end,
                function()
                    if base64 and type(base64.decode) == "function" then return base64.decode(data) end
                end,
                function()
                    if type(base64_decode) == "function" then return base64_decode(data) end
                end,
            }
            for _, fn in ipairs(tries) do
                local ok, result = pcall(fn)
                if ok and type(result) == "string" and #result > 100 then return result end
            end
            return nil
        end

        local function ResolveLogoAsset()
            local env = (type(getgenv) == "function" and getgenv()) or _G
            if type(env.BobonLogoAsset) == "string" and env.BobonLogoAsset ~= "" then
                return env.BobonLogoAsset
            end
            local assetFn = type(getcustomasset) == "function" and getcustomasset
                or (type(getsynasset) == "function" and getsynasset or nil)
            if not assetFn or type(writefile) ~= "function" then return "" end
            local bytes = DecodeBase64(LOGO_B64)
            if not bytes then return "" end
            local fileName = "BobonHub_Mascot_v6.jpg"
            local okWrite = pcall(function() writefile(fileName, bytes) end)
            if not okWrite then return "" end
            local okAsset, result = pcall(assetFn, fileName)
            if okAsset and type(result) == "string" then
                env.BobonLogoAsset = result
                return result
            end
            return ""
        end

        local LogoAsset = ResolveLogoAsset()

        local function Corner(obj, px)
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, px or 14)
            c.Parent = obj
            return c
        end

        local function Stroke(obj, color, transparency, thickness)
            local s = Instance.new("UIStroke")
            s.Color = color or CYAN
            s.Transparency = transparency == nil and 0.42 or transparency
            s.Thickness = thickness or 1.2
            s.Parent = obj
            return s
        end

        local function SetModernFont(label, heavy)
            pcall(function()
                label.FontFace = Font.new(
                    "rbxasset://fonts/families/GothamSSm.json",
                    heavy and Enum.FontWeight.Heavy or Enum.FontWeight.Medium,
                    Enum.FontStyle.Normal
                )
            end)
            label.Font = heavy and Enum.Font.GothamBlack or Enum.Font.Gotham
        end

        local function Text(parent, value, size, color, heavy, align)
            local x = Instance.new("TextLabel")
            x.BackgroundTransparency = 1
            x.BorderSizePixel = 0
            x.Text = value or ""
            x.TextColor3 = color or WHITE
            x.TextSize = size or 14
            x.TextXAlignment = align or Enum.TextXAlignment.Left
            x.TextYAlignment = Enum.TextYAlignment.Center
            x.TextTruncate = Enum.TextTruncate.AtEnd
            x.RichText = false
            x.Parent = parent
            SetModernFont(x, heavy == true)
            return x
        end

        local function MakeLogo(parent, size, pos, z)
            local holder = Instance.new("Frame")
            holder.BackgroundColor3 = DARK
            holder.BackgroundTransparency = 0.04
            holder.BorderSizePixel = 0
            holder.Size = size
            holder.Position = pos
            holder.ZIndex = z or 3
            holder.ClipsDescendants = true
            holder.Parent = parent
            Corner(holder, math.max(14, math.floor((size.X.Offset > 0 and size.X.Offset or 70) * 0.22)))
            Stroke(holder, CYAN, 0.30, 1.6)

            if LogoAsset ~= "" then
                local im = Instance.new("ImageLabel")
                im.Name = "Mascot"
                im.BackgroundTransparency = 1
                im.Size = UDim2.fromScale(1,1)
                im.Image = LogoAsset
                im.ScaleType = Enum.ScaleType.Crop
                im.ZIndex = holder.ZIndex + 1
                im.Parent = holder
            else
                local fallback = Text(holder, "B", 32, CYAN, true, Enum.TextXAlignment.Center)
                fallback.Size = UDim2.fromScale(1,1)
                fallback.ZIndex = holder.ZIndex + 1
            end
            return holder
        end

        local function Card(parent, name, pos, size)
            local x = Instance.new("Frame")
            x.Name = name
            x.Position = pos
            x.Size = size
            x.BackgroundColor3 = DARK_CARD
            x.BackgroundTransparency = 0.16
            x.BorderSizePixel = 0
            x.Parent = parent
            Corner(x, 16)
            Stroke(x, CYAN, 0.50, 1.15)
            return x
        end

        local SG = Instance.new("ScreenGui")
        BobonUIRoot = SG
        SG.Name = "BobonHubUI"
        SG.ResetOnSpawn = false
        SG.IgnoreGuiInset = true
        SG.DisplayOrder = 10000
        SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        SG.Parent = uiParent

        -- Main HUD is transparent around the actual cards so Roblox/game UI remains visible.
        local HUD = Instance.new("Frame")
        HUD.Name = "HUD"
        HUD.Size = UDim2.fromScale(1,1)
        HUD.BackgroundTransparency = 1
        HUD.Parent = SG
        HUD.Visible = false

        local Top = Card(HUD, "TopBar", UDim2.new(0.075,0,0.028,0), UDim2.new(0.85,0,0,112))
        Top.AnchorPoint = Vector2.new(0,0)

        local TopLogo = MakeLogo(Top, UDim2.new(0,72,0,72), UDim2.new(0,14,0.5,-36), 5)
        TopLogo.Visible = false
        local Brand = Text(Top, "BOBON", 30, WHITE, true)
        Brand.Position = UDim2.new(0,100,0,14)
        Brand.Size = UDim2.new(0,132,0,34)
        local BrandAccent = Text(Top, "HUB", 30, CYAN, true)
        BrandAccent.Position = UDim2.new(0,208,0,14)
        BrandAccent.Size = UDim2.new(0,72,0,34)

        local Divider = Instance.new("Frame")
        Divider.Position = UDim2.new(0,318,0,15)
        Divider.Size = UDim2.new(0,1,1,-30)
        Divider.BackgroundColor3 = CYAN
        Divider.BackgroundTransparency = 0.68
        Divider.BorderSizePixel = 0
        Divider.Parent = Top

        local FarmCap = Text(Top, "STATUS FARM", 11, CYAN_SOFT, true)
        FarmCap.Position = UDim2.new(0,340,0,13)
        FarmCap.Size = UDim2.new(0,130,0,18)
        local StatusFarm = Text(Top, "Initializing Kaitun...", 17, WHITE, true)
        StatusFarm.Position = UDim2.new(0,340,0,31)
        StatusFarm.Size = UDim2.new(1,-360,0,27)

        local ItemCap = Text(Top, "STATUS ITEM", 11, CORAL, true)
        ItemCap.Position = UDim2.new(0,340,0,62)
        ItemCap.Size = UDim2.new(0,130,0,18)
        local StatusItem = Text(Top, "Scanning Inventory...", 16, CORAL, true)
        StatusItem.Position = UDim2.new(0,340,0,80)
        StatusItem.Size = UDim2.new(1,-360,0,24)

        local StatsRow = Instance.new("Frame")
        StatsRow.Name = "StatsRow"
        -- v22.9: compact, centered stat strip.  The old row left visible game/UI
        -- gaps between translucent cards on wide screens.
        StatsRow.Position = UDim2.new(0.14,0,0.205,0)
        StatsRow.Size = UDim2.new(0.72,0,0,74)
        -- v22.10: one dark backing plate removes the bright game seams between
        -- the four rounded cards without adding fake whitespace.
        StatsRow.BackgroundColor3 = DARK_CARD
        StatsRow.BackgroundTransparency = 1
        StatsRow.BorderSizePixel = 0
        StatsRow.Parent = HUD
        Corner(StatsRow, 16)

        local function StatCard(name, order, title)
            local w = 0.2485
            local gap = 0.002
            local x = (order-1)*(w+gap)
            local c = Card(StatsRow, name, UDim2.new(x,0,0,0), UDim2.new(w,0,1,0))
            -- Nearly opaque cards prevent bright Roblox panels showing through
            -- the tiny seams and looking like white empty bars.
            c.BackgroundTransparency = 0.04
            local cap = Text(c, title, 10, CYAN_SOFT, true, Enum.TextXAlignment.Center)
            cap.Position = UDim2.new(0,6,0,7)
            cap.Size = UDim2.new(1,-12,0,16)
            local val = Text(c, "-", 21, WHITE, true, Enum.TextXAlignment.Center)
            val.Position = UDim2.new(0,6,0,25)
            val.Size = UDim2.new(1,-12,0,30)
            local scale = Instance.new("UIScale")
            scale.Scale = 1
            scale.Parent = c
            return c, val, scale
        end

        local LevelCard, LevelL, LevelScale = StatCard("Level",1,"LEVEL")
        local BeliCard, BeliL, BeliScale = StatCard("Beli",2,"BELI")
        local FragCard, FragL, FragScale = StatCard("Fragments",3,"FRAGMENTS")
        local FruitCard, FruitL, FruitScale = StatCard("Fruit",4,"FRUIT")

        local Runtime = Card(HUD, "Runtime", UDim2.new(0.41,0,0.314,0), UDim2.new(0.18,0,0,32))
        Runtime.BackgroundTransparency = 0.04
        local RuntimeL = Text(Runtime, "TIME  00:00:00", 12, CYAN_SOFT, true, Enum.TextXAlignment.Center)
        RuntimeL.Size = UDim2.fromScale(1,1)

        local Checker = Card(HUD, "StatusChecker", UDim2.new(0.715,0,0.405,0), UDim2.new(0.255,0,0,286))
        local CheckerTitle = Text(Checker, "STATUS CHECKER", 17, CYAN, true)
        CheckerTitle.Position = UDim2.new(0,18,0,10)
        CheckerTitle.Size = UDim2.new(1,-36,0,28)
        local CheckerLine = Instance.new("Frame")
        CheckerLine.Position = UDim2.new(0,18,0,43)
        CheckerLine.Size = UDim2.new(1,-36,0,1)
        CheckerLine.BackgroundColor3 = CYAN
        CheckerLine.BackgroundTransparency = 0.72
        CheckerLine.BorderSizePixel = 0
        CheckerLine.Parent = Checker

        local TrackedItems = {
            {Label="Saber", Names={"Saber"}},
            {Label="Pole V1", Names={"Pole (1st Form)","Pole V1"}},
            {Label="Kabucha", Names={"Kabucha"}},
            {Label="Rengoku", Names={"Rengoku"}},
            {Label="Midnight Blade", Names={"Midnight Blade"}},
            {Label="TTK", Names={"True Triple Katana"}},
            {Label="Yama", Names={"Yama"}},
            {Label="Tushita", Names={"Tushita"}},
            {Label="CDK", Names={"Cursed Dual Katana"}},
            {Label="Soul Guitar", Names={"Skull Guitar","Soul Guitar"}},
            {Label="Godhuman", Names={"Godhuman"}},
            {Label="Mirror Fractal", Names={"Mirror Fractal"}},
            {Label="Valkyrie Helm", Names={"Valkyrie Helm"}},
            {Label="Pull Lever", Special="lever"},
        }

        local CheckerRows = {}
        local function BuildCheckerRow(row, index)
            local col = index <= 7 and 0 or 1
            local inCol = col == 0 and index or (index-7)
            local x = col == 0 and 0.055 or 0.535
            local y = 0.18 + (inCol-1)*0.108
            local dot = Instance.new("Frame")
            dot.Size = UDim2.new(0,12,0,12)
            dot.Position = UDim2.new(x,0,y,2)
            dot.BackgroundColor3 = RED
            dot.BorderSizePixel = 0
            dot.Parent = Checker
            Corner(dot, 12)
            local label = Text(Checker, row.Label, 12, WHITE, false)
            label.Position = UDim2.new(x,20,y,-2)
            label.Size = UDim2.new(0.43,-22,0,20)
            CheckerRows[index] = {Dot=dot, Label=label, State="missing"}
        end
        for i,row in ipairs(TrackedItems) do BuildCheckerRow(row,i) end

        local Toggle = Instance.new("TextButton")
        Toggle.Name = "BobonToggle"
        Toggle.AnchorPoint = Vector2.new(0,0.5)
        Toggle.Position = UDim2.new(0,18,0.56,0)
        Toggle.Size = UDim2.new(0,74,0,74)
        Toggle.BackgroundColor3 = DARK
        Toggle.BackgroundTransparency = 0.04
        Toggle.BorderSizePixel = 0
        Toggle.Text = ""
        Toggle.AutoButtonColor = false
        Toggle.ZIndex = 100
        Toggle.Parent = SG
        Toggle.Visible = false
        Corner(Toggle, 37)
        local ToggleStroke = Stroke(Toggle, CYAN, 0.16, 2)
        local ToggleAspect = Instance.new("UIAspectRatioConstraint")
        ToggleAspect.AspectRatio = 1
        ToggleAspect.Parent = Toggle
        local ToggleLogo = MakeLogo(Toggle, UDim2.new(0,50,0,50), UDim2.new(0.5,-25,0.5,-25), 101)
        ToggleLogo.BackgroundTransparency = 1
        local ToggleLogoCorner = ToggleLogo:FindFirstChildOfClass("UICorner")
        if ToggleLogoCorner then ToggleLogoCorner.CornerRadius = UDim.new(1,0) end
        local Chevron = Text(Toggle, "›", 24, CYAN, true, Enum.TextXAlignment.Center)
        Chevron.Position = UDim2.new(1,-18,0.5,-16)
        Chevron.Size = UDim2.new(0,16,0,32)
        Chevron.ZIndex = 104
        Chevron.Visible = false

        -- Intro overlay. No circular halo remains after the animation: only this
        -- rounded glass frame surrounds the mascot, then the frame fades away.
        local Intro = Instance.new("Frame")
        Intro.Name = "Intro"
        Intro.Size = UDim2.fromScale(1,1)
        Intro.BackgroundColor3 = Color3.new(0,0,0)
        Intro.BackgroundTransparency = 0
        Intro.ZIndex = 200
        Intro.Parent = SG

        local IntroFrame = Instance.new("Frame")
        IntroFrame.AnchorPoint = Vector2.new(0.5,0.5)
        IntroFrame.Position = UDim2.fromScale(0.5,0.39)
        IntroFrame.Size = UDim2.new(0,330,0,265)
        IntroFrame.BackgroundColor3 = DARK
        IntroFrame.BackgroundTransparency = 1
        IntroFrame.BorderSizePixel = 0
        IntroFrame.ZIndex = 201
        IntroFrame.Parent = Intro
        Corner(IntroFrame, 30)
        local IntroStroke = Stroke(IntroFrame, CYAN, 1, 2.2)

        local IntroLogo = MakeLogo(Intro, UDim2.new(0,220,0,220), UDim2.new(0.5,-110,0.39,-110), 205)
        IntroLogo.BackgroundTransparency = 1
        local IntroLogoStroke = IntroLogo:FindFirstChildOfClass("UIStroke")
        if IntroLogoStroke then IntroLogoStroke.Transparency = 1 end
        IntroLogo.Visible = false

        local WordRow = Instance.new("Frame")
        WordRow.AnchorPoint = Vector2.new(0.5,0)
        WordRow.Position = UDim2.new(0.5,0,0.59,0)
        WordRow.Size = UDim2.new(0,520,0,70)
        WordRow.BackgroundTransparency = 1
        WordRow.ZIndex = 205
        WordRow.Parent = Intro
        local WordLayout = Instance.new("UIListLayout")
        WordLayout.FillDirection = Enum.FillDirection.Horizontal
        WordLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        WordLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        WordLayout.Padding = UDim.new(0,1)
        WordLayout.Parent = WordRow

        local Letters = {}
        local word = "BOBONHUB"
        for i=1,#word do
            local ch = word:sub(i,i)
            local l = Text(WordRow, ch, 47, i <= 5 and WHITE or CYAN, true, Enum.TextXAlignment.Center)
            l.Size = UDim2.new(0,46,1,0)
            l.TextTransparency = 1
            l.Position = UDim2.new(0,0,0,14)
            l.ZIndex = 206
            Letters[i] = l
        end

        local IntroSub = Text(Intro, "", 18, CYAN_SOFT, true, Enum.TextXAlignment.Center)
        IntroSub.AnchorPoint = Vector2.new(0.5,0)
        IntroSub.Position = UDim2.new(0.5,0,0.70,0)
        IntroSub.Size = UDim2.new(0,420,0,28)
        IntroSub.ZIndex = 206

        local LoadBack = Instance.new("Frame")
        LoadBack.AnchorPoint = Vector2.new(0.5,0)
        LoadBack.Position = UDim2.new(0.5,0,0.765,0)
        LoadBack.Size = UDim2.new(0,360,0,10)
        LoadBack.BackgroundColor3 = Color3.fromRGB(15,24,38)
        LoadBack.BorderSizePixel = 0
        LoadBack.ZIndex = 206
        LoadBack.Parent = Intro
        Corner(LoadBack, 6)
        local LoadFill = Instance.new("Frame")
        LoadFill.Size = UDim2.new(0,0,1,0)
        LoadFill.BackgroundColor3 = CYAN
        LoadFill.BorderSizePixel = 0
        LoadFill.ZIndex = 207
        LoadFill.Parent = LoadBack
        Corner(LoadFill, 6)

        -- Direct live inventory cache for the HUD. It is intentionally independent
        -- of the later progression helper locals so the UI cannot alter core logic.
        local HUDInv = {At=0, Rows={}}
        local function DirectHasTool(name)
            local char = LP.Character
            local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
            local wanted = string.lower(tostring(name))
            for _,root in ipairs({char,bp}) do
                if root then
                    for _,obj in ipairs(root:GetChildren()) do
                        if string.lower(tostring(obj.Name)) == wanted then return true end
                    end
                end
            end
            return false
        end

        local function HUDInventoryRows(force)
            local now = tick()
            if not force and now - HUDInv.At < 5 then return HUDInv.Rows end
            local rows = {}
            local function merge(result)
                if type(result) ~= "table" then return end
                for _,row in pairs(result) do rows[#rows+1] = row end
            end
            pcall(function() merge(CommF_:InvokeServer("getInventory")) end)
            pcall(function() merge(CommF_:InvokeServer("getInventoryWeapons")) end)
            HUDInv.At = now
            HUDInv.Rows = rows
            return rows
        end

        local function HUDInventoryHas(name)
            if DirectHasTool(name) then return true end
            local wanted = string.lower(tostring(name))
            for _,row in pairs(HUDInventoryRows(false)) do
                if type(row) == "table" then
                    local n = row.Name or row.name or row.Item or row.ItemName
                    if n and string.lower(tostring(n)) == wanted then return true end
                end
            end
            return false
        end

        local LeverCache = {At=0, Value=false}
        local function ExplicitLeverState()
            local now = tick()
            if now - LeverCache.At < 3 then return LeverCache.Value end
            local data = LP:FindFirstChild("Data")
            local roots = {data, LP}
            for _,root in ipairs(roots) do
                if root then
                    for _,obj in ipairs(root:GetDescendants()) do
                        local low = string.lower(tostring(obj.Name or ""))
                        if low:find("lever",1,true) then
                            if obj:IsA("BoolValue") and obj.Value == true then LeverCache.At=now; LeverCache.Value=true; return true end
                            if (obj:IsA("IntValue") or obj:IsA("NumberValue")) and tonumber(obj.Value) and obj.Value > 0 then LeverCache.At=now; LeverCache.Value=true; return true end
                        end
                        local attrs = obj:GetAttributes()
                        for key,value in pairs(attrs) do
                            local k = string.lower(tostring(key))
                            if k:find("lever",1,true) and (value == true or (type(value)=="number" and value > 0)) then
                                LeverCache.At=now; LeverCache.Value=true; return true
                            end
                        end
                    end
                end
            end
            LeverCache.At=now; LeverCache.Value=false
            return false
        end

        local function OwnsTracked(row)
            if row.Special == "lever" then return ExplicitLeverState() end
            for _,name in ipairs(row.Names or {}) do
                if HUDInventoryHas(name) then return true end
            end
            return false
        end

        local function CurrentFruit()
            local d = LP:FindFirstChild("Data")
            if d then
                for _,name in ipairs({"DevilFruit","Fruit","DemonFruit"}) do
                    local v = d:FindFirstChild(name)
                    if v then
                        local ok,val = pcall(function() return v.Value end)
                        if ok and val ~= nil and tostring(val) ~= "" then
                            local text = tostring(val)
                            local low = string.lower(text)
                            if low == "none" or low == "nil" or low == "n/a"
                                or low == "no fruit" or low:find("không", 1, true)
                                or low:find("khong", 1, true) then
                                return "NONE"
                            end
                            return text
                        end
                    end
                end
            end
            return "NONE"
        end

        local ItemKeywords = {
            "saber","pole","kabucha","rengoku","midnight","triple katana","ttk",
            "yama","tushita","cursed dual","cdk","soul guitar","skull guitar","godhuman",
            "mirror fractal","valkyrie","lever","melee:","item:","material","fighting style",
            "bartilo","sea 2","sea 3","progression:"
        }

        local function LooksItemStatus(s)
            local low = string.lower(tostring(s or ""))
            for _,k in ipairs(ItemKeywords) do
                if low:find(k,1,true) then return true end
            end
            return false
        end

        local function IsTrackedActive(row, rawStatus, owner)
            local hay = string.lower(tostring(rawStatus or "") .. " " .. tostring(owner or ""))
            if row.Special == "lever" then return hay:find("lever",1,true) ~= nil end
            if hay:find(string.lower(row.Label),1,true) then return true end
            for _,name in ipairs(row.Names or {}) do
                if hay:find(string.lower(name),1,true) then return true end
            end
            return false
        end

        local function DeriveStatuses(ownedMap)
            local state = _G.State or {}
            local raw = tostring(_G.BobonStatus or "Idle")
            local mode = tostring(state.Mode or "Idle")
            local owner = tostring(state.ActionOwner or "")

            local farm
            local rawLow = string.lower(raw)
            local skipLive = tostring(state.FState or "") == "SKIP_FARM"
                or rawLow:find("skip:",1,true) == 1
                or rawLow:find("skip mode",1,true) ~= nil
            if state.DodgeActive then
                farm = "Dodging • " .. tostring(state.DodgeThreatName or state.ActiveQuestMob or "target")
            elseif skipLive then
                -- v22.10: video 18 showed the HUD saying "Farming Bandit" while the
                -- character was physically killing Sky Bandit. Skip state must win over
                -- any stale ActiveQuestMob left by the normal quest selector.
                farm = raw
            elseif mode == "Recovering" or rawLow:find("recovery",1,true) or rawLow:find("recovering",1,true) then
                farm = raw
            elseif LooksItemStatus(raw) or LooksItemStatus(owner) then
                if mode == "Farming" and state.ActiveQuestMob then
                    farm = "Farming " .. tostring(state.ActiveQuestMob)
                elseif state.ActiveActionToken ~= 0 and owner ~= "" then
                    farm = "Paused • " .. owner
                else
                    farm = string.upper(mode)
                end
            elseif mode == "Farming" and state.ActiveQuestMob then
                local fs = tostring(state.FState or "")
                if fs:find("QUEST",1,true) then
                    farm = "Taking Quest • " .. tostring(state.ActiveQuestMob)
                elseif fs:find("MOVE",1,true) or fs:find("ACQUIRE",1,true) then
                    farm = "Moving To " .. tostring(state.ActiveQuestMob)
                else
                    farm = "Farming " .. tostring(state.ActiveQuestMob)
                end
            else
                farm = raw ~= "" and raw or mode
            end

            local item
            if LooksItemStatus(raw) and (state.ActiveActionToken ~= 0 or LooksItemStatus(owner)) then
                item = raw
            elseif LooksItemStatus(owner) and owner ~= "" then
                item = owner
            else
                local missing
                for i,row in ipairs(TrackedItems) do
                    if ownedMap[i] == false then missing = row.Label break end
                end
                item = missing and ("Missing Item • " .. missing) or "All Required Items Completed ✓"
            end
            return farm, item
        end

        local function Fmt(n)
            local st = tostring(math.floor(tonumber(n) or 0))
            return st:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
        end

        local LastText = setmetatable({}, {__mode="k"})
        local TextToken = setmetatable({}, {__mode="k"})
        local function AnimateText(label, value, color)
            value = tostring(value or "")
            if LastText[label] == value then
                if color then label.TextColor3 = color end
                return
            end
            LastText[label] = value
            local token = (TextToken[label] or 0) + 1
            TextToken[label] = token
            pcall(function()
                TS:Create(label, TweenInfo.new(0.10, Enum.EasingStyle.Quad), {TextTransparency=1}):Play()
            end)
            task.delay(0.11, function()
                if not label.Parent or TextToken[label] ~= token then return end
                label.Text = value
                if color then label.TextColor3 = color end
                label.Position = label.Position + UDim2.new(0,0,0,4)
                label.TextTransparency = 1
                pcall(function()
                    TS:Create(label, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        TextTransparency=0,
                        Position=label.Position-UDim2.new(0,0,0,4)
                    }):Play()
                end)
            end)
        end

        local function Pulse(scale)
            pcall(function()
                TS:Create(scale, TweenInfo.new(0.10, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale=1.08}):Play()
                task.delay(0.11, function()
                    if scale.Parent then TS:Create(scale, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Scale=1}):Play() end
                end)
            end)
        end

        local lastLv,lastBeli,lastFrag,lastFruit
        local visible = true
        local busy = false
        local MainObjects = {Top,StatsRow,Runtime,Checker}

        local function SetVisible(v)
            if busy or v == visible then return end
            busy = true
            visible = v
            Chevron.Text = v and "‹" or "›"
            if v then
                for _,obj in ipairs(MainObjects) do
                    obj.Visible = true
                end
                HUD.Visible = true
                for i,obj in ipairs(MainObjects) do
                    local old = obj.Position
                    obj.Position = old + UDim2.new(0,0,0,8)
                    obj.BackgroundTransparency = math.min(1, obj.BackgroundTransparency + 0.25)
                    task.delay((i-1)*0.04, function()
                        if obj.Parent then
                            pcall(function() TS:Create(obj, TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position=old, BackgroundTransparency=(obj==StatsRow and 1 or (obj==Runtime and 0.04 or 0.16))}):Play() end)
                        end
                    end)
                end
                task.delay(0.30, function() busy=false end)
            else
                for _,obj in ipairs(MainObjects) do
                    pcall(function() TS:Create(obj, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundTransparency=0.92}):Play() end)
                end
                task.delay(0.18,function()
                    if not visible then for _,obj in ipairs(MainObjects) do obj.Visible=false end end
                    busy=false
                end)
            end
        end

        BobonUIConnections[#BobonUIConnections+1] = Toggle.MouseButton1Click:Connect(function()
            SetVisible(not visible)
            pcall(function()
                TS:Create(Toggle, TweenInfo.new(0.08, Enum.EasingStyle.Back), {Size=UDim2.new(0,80,0,80)}):Play()
                task.delay(0.09,function()
                    if Toggle.Parent then TS:Create(Toggle, TweenInfo.new(0.13, Enum.EasingStyle.Quad), {Size=UDim2.new(0,74,0,74)}):Play() end
                end)
            end)
        end)
        BobonUIConnections[#BobonUIConnections+1] = UIS.InputBegan:Connect(function(input,processed)
            if not processed and input.KeyCode == Enum.KeyCode.RightControl then SetVisible(not visible) end
        end)

        -- Slow approved load sequence: frame -> mascot -> letters -> loader -> mascot
        -- merges into the header; panels appear one-by-one. No looping ring effect.
        task.spawn(function()
            pcall(function()
                HUD.Visible = false
                Toggle.Visible = false
                IntroFrame.Size = UDim2.new(0,270,0,215)
                TS:Create(IntroFrame, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size=UDim2.new(0,330,0,265), BackgroundTransparency=0.08
                }):Play()
                TS:Create(IntroStroke, TweenInfo.new(0.55), {Transparency=0.08}):Play()
                task.wait(0.48)

                IntroLogo.Visible = true
                IntroLogo.Size = UDim2.new(0,176,0,176)
                IntroLogo.Position = UDim2.new(0.5,-88,0.39,-88)
                TS:Create(IntroLogo, TweenInfo.new(0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size=UDim2.new(0,220,0,220), Position=UDim2.new(0.5,-110,0.39,-110)
                }):Play()
                task.wait(0.55)

                for i,l in ipairs(Letters) do
                    task.delay((i-1)*0.075,function()
                        if not l.Parent then return end
                        l.TextTransparency=1
                        l.Position=UDim2.new(0,0,0,14)
                        TS:Create(l,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                            TextTransparency=0,Position=UDim2.new(0,0,0,0)
                        }):Play()
                    end)
                end
                task.wait(0.70)

                local phrase="KAITUN SYSTEM"
                for i=1,#phrase do
                    IntroSub.Text=phrase:sub(1,i)
                    task.wait(0.045)
                end
                TS:Create(LoadFill,TweenInfo.new(1.00,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0)}):Play()
                task.wait(1.05)

                HUD.Visible=true
                Toggle.Visible=true
                for _,obj in ipairs(MainObjects) do obj.Visible=false end
                Top.Visible=true
                Top.BackgroundTransparency=1
                local topPos=Top.Position
                Top.Position=topPos-UDim2.new(0,0,0,14)
                TS:Create(Top,TweenInfo.new(0.55,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=topPos,BackgroundTransparency=0.16}):Play()

                -- mascot merges into the exact same image slot in the header
                local introAbs=IntroLogo.AbsolutePosition
                local introSize=IntroLogo.AbsoluteSize
                IntroLogo.Parent=SG
                IntroLogo.Position=UDim2.fromOffset(introAbs.X,introAbs.Y)
                IntroLogo.Size=UDim2.fromOffset(introSize.X,introSize.Y)
                IntroLogo.ZIndex=250
                IntroFrame.Visible=false
                WordRow.Visible=false
                IntroSub.Visible=false
                LoadBack.Visible=false
                local targetPos=UDim2.new(0.075,14,0.035,17)
                TS:Create(IntroLogo,TweenInfo.new(0.85,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
                    Position=targetPos,Size=UDim2.new(0,72,0,72)
                }):Play()
                task.wait(0.82)
                -- v22.10: destroy the travelling copy after it lands. Keeping a
                -- hidden duplicate alive caused some executors to leave a stale
                -- image object over the status text.
                if IntroLogo and IntroLogo.Parent then IntroLogo:Destroy() end
                TopLogo.Visible=true

                Intro.BackgroundTransparency=0
                TS:Create(Intro,TweenInfo.new(0.38,Enum.EasingStyle.Quad),{BackgroundTransparency=1}):Play()
                task.wait(0.18)

                local sequence={StatsRow,Runtime,Checker}
                for _,obj in ipairs(sequence) do
                    obj.Visible=true
                    local p=obj.Position
                    obj.Position=p+UDim2.new(0,0,0,16)
                    if obj:IsA("Frame") then obj.BackgroundTransparency=1 end
                    TS:Create(obj,TweenInfo.new(0.45,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{
                        Position=p,BackgroundTransparency=obj==StatsRow and 0.04 or 0.16
                    }):Play()
                    task.wait(0.22)
                end
                -- v22.10: remove the finished intro tree completely.
                if Intro and Intro.Parent then Intro:Destroy() end
            end)
        end)

        task.spawn(function()
            local ownedMap={}
            while SessionAlive() and SG.Parent do
                pcall(function()
                    local state=_G.State or {}
                    local data=LP:FindFirstChild("Data")
                    local lv=data and data:FindFirstChild("Level") and data.Level.Value or 1
                    local beli=data and data:FindFirstChild("Beli") and data.Beli.Value or 0
                    local frag=data and data:FindFirstChild("Fragments") and data.Fragments.Value or 0
                    local fruit=CurrentFruit()
                    local elapsed=os.time()-(state.StartTime or os.time())
                    RuntimeL.Text=("TIME  %02d:%02d:%02d"):format(math.floor(elapsed/3600),math.floor(elapsed%3600/60),elapsed%60)

                    if lastLv~=lv then LevelL.Text=Fmt(lv); Pulse(LevelScale); lastLv=lv end
                    if lastBeli~=beli then BeliL.Text="$ "..Fmt(beli); Pulse(BeliScale); lastBeli=beli end
                    if lastFrag~=frag then FragL.Text=Fmt(frag); Pulse(FragScale); lastFrag=frag end
                    if lastFruit~=fruit then FruitL.Text=fruit; Pulse(FruitScale); lastFruit=fruit end

                    HUDInventoryRows(false)
                    local raw=tostring(_G.BobonStatus or "")
                    local owner=tostring(state.ActionOwner or "")
                    for i,row in ipairs(TrackedItems) do
                        local ui=CheckerRows[i]
                        if ui and ui.Label and ui.Label.Text ~= row.Label then
                            ui.Label.Text = row.Label -- force canonical English labels
                        end
                        local owned=OwnsTracked(row)
                        ownedMap[i]=owned
                        local active=not owned and IsTrackedActive(row,raw,owner)
                        local targetColor=owned and GREEN or (active and YELLOW or RED)
                        local targetState=owned and "owned" or (active and "active" or "missing")
                        if ui and ui.State~=targetState then
                            ui.State=targetState
                            pcall(function()
                                TS:Create(ui.Dot,TweenInfo.new(0.20,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                                    BackgroundColor3=targetColor,Size=UDim2.new(0,16,0,16)
                                }):Play()
                                task.delay(0.21,function()
                                    if ui.Dot.Parent then TS:Create(ui.Dot,TweenInfo.new(0.16),{Size=UDim2.new(0,12,0,12)}):Play() end
                                end)
                            end)
                        elseif ui then
                            ui.Dot.BackgroundColor3=targetColor
                        end
                    end

                    local farmText,itemText=DeriveStatuses(ownedMap)
                    local mode=tostring(state.Mode or "Idle")
                    AnimateText(StatusFarm,farmText,(mode=="Recovering" or mode=="Dead") and RED or WHITE)
                    AnimateText(StatusItem,itemText,itemText:find("✓",1,true) and GREEN or CORAL)
                end)
                task.wait(0.25)
            end
        end)
    end)
    if not okUI then warn("[BobonHub] UI Error: " .. tostring(uiErr)) end
end


-- ══════════════════════════════════════════════════════════════════
--                       HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════════
local function Char() return LP.Character end
local function HRP() local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum() local c=Char(); return c and c:FindFirstChild("Humanoid") end
local function IsAlive() local h=Hum(); return h and h.Health > 0 end

local function FarmSafetyActive()
    local state = _G.State
    if not state then return false end
    -- v22.3: the requested kaitun policy is continuity-first. Low HP from PvP or
    -- ordinary contact is not allowed to alter combat range/hover or pause attacks.
    if _G.Settings and _G.Settings.EmergencySafetyEnabled == false then
        state.FarmSafetyActive = false
        state.FarmSafetyUntil = 0
        return false
    end
    local h = Hum()
    if not h or h.Health <= 0 or h.MaxHealth <= 0 then return false end
    local pct = (h.Health / h.MaxHealth) * 100
    local now = tick()
    if state.FarmSafetyActive then
        if pct >= (_G.Settings.EmergencyResumePercent or 82)
            and now >= (state.FarmSafetyUntil or 0) then
            state.FarmSafetyActive = false
        end
    elseif pct <= (_G.Settings.EmergencyHealthPercent or 55) then
        state.FarmSafetyActive = true
        state.FarmSafetyUntil = now + (_G.Settings.EmergencyMinHold or 2.5)
    end
    return state.FarmSafetyActive == true
end


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
    -- v21.34: accept both classic and alternate live place ids seen in the
    -- comparison source. Never carry a stale world flag across teleport/re-execute.
    if id == 2753915549 or id == 85211729168715 then return 1 end
    if id == 4442272183 or id == 79091703265657 then return 2 end
    if id == 7449423635 or id == 100117331123089 then return 3 end
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

local function RegisterFragmentDemand(cost, reason, priority)
    cost = math.max(0, tonumber(cost) or 0)
    if cost <= 0 or not _G.State then return end
    local reserve = math.max(0, tonumber(_G.Settings and _G.Settings.LockFragment or 0) or 0)
    local goal = cost + reserve
    if Fragments() >= goal then return end
    local now = tick()
    local stale = now - (_G.State.FragmentDemandAt or 0) > (_G.Settings.RaidFragmentDemandTTL or 120)
    local p = tonumber(priority) or 25
    local selectedReason = reason or "Progression"
    local currentReason = _G.State.FragmentDemandReason
    if stale or p > (_G.State.FragmentDemandPriority or 0)
        or (p == (_G.State.FragmentDemandPriority or 0) and goal > (_G.State.FragmentDemandGoal or 0))
        or (p == (_G.State.FragmentDemandPriority or 0) and currentReason == selectedReason) then
        _G.State.FragmentDemandGoal = goal
        _G.State.FragmentDemandCost = cost
        _G.State.FragmentDemandReason = selectedReason
        _G.State.FragmentDemandPriority = p
        _G.State.FragmentDemandAt = now
    end
end

local function CanSpendFragments(cost, reason, priority)
    local reserve = math.max(0, tonumber(_G.Settings and _G.Settings.LockFragment or 0) or 0)
    local required = (tonumber(cost) or 0) + reserve
    local ok = Fragments() >= required
    if not ok then
        RegisterFragmentDemand(cost, reason, priority)
    elseif _G.State and reason and _G.State.FragmentDemandReason == reason then
        _G.State.FragmentDemandGoal = 0
        _G.State.FragmentDemandCost = 0
        _G.State.FragmentDemandReason = nil
        _G.State.FragmentDemandPriority = 0
        _G.State.FragmentDemandAt = 0
    end
    return ok
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
        local pgui = LP:FindFirstChild("PlayerGui")
        local main = pgui and pgui:FindFirstChild("Main")
        local minimal = pgui and pgui:FindFirstChild("Main (minimal)")
        local quest = (main and main:FindFirstChild("Quest", true))
            or (minimal and minimal:FindFirstChild("Quest", true))
        if not quest then return nil end

        -- Nested helper: does NOT consume another top-level Luau local.
        local function Rendered(node)
            if not node then return false end
            local cur = node
            while cur and cur ~= pgui do
                if cur:IsA("GuiObject") and cur.Visible == false then return false end
                if cur:IsA("LayerCollector") and cur.Enabled == false then return false end
                cur = cur.Parent
            end
            return true
        end

        -- A just-accepted quest may rebuild its wrapper briefly. Treat that tiny
        -- transition as unreadable (nil), not as active and not as completed.
        if not Rendered(quest) then
            if _G.State and (_G.State.LastQuestAccepted or 0) > 0
                and tick() - (_G.State.LastQuestAccepted or 0)
                    <= math.min(_G.Settings.QuestAcceptGrace or 1.25, 1.25) then
                return nil
            end
            return false
        end

        local container = quest:FindFirstChild("Container") or quest
        local sawObjective = false
        for _, node in ipairs(container:GetDescendants()) do
            if node:IsA("TextLabel") and Rendered(node) then
                local text = tostring(node.Text or "")
                local lower = string.lower(text)
                if lower:find("quest completed", 1, true)
                    or lower:find("quest complete", 1, true)
                    or lower:find("completed", 1, true)
                    or lower:find("finished", 1, true) then
                    return false
                end
                local current, total = text:match("(%d+)%s*/%s*(%d+)")
                current, total = tonumber(current), tonumber(total)
                if current and total and total > 0 then
                    if current >= total then return false end
                    sawObjective = true
                end
                if text ~= "" then
                    local nn = string.lower(tostring(node.Name or ""))
                    if nn:find("title", 1, true)
                        or nn:find("task", 1, true)
                        or nn:find("objective", 1, true)
                        or lower:find("defeat", 1, true)
                        or lower:find("kill", 1, true)
                        or lower:find("collect", 1, true) then
                        sawObjective = true
                    end
                end
            end
        end
        if sawObjective then return true end
        return nil
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

local function IsRaidBossModel(enemy)
    if not enemy then return false end
    local n = string.lower(tostring(enemy.Name or ""))
    return n:find("[raid boss]", 1, true) ~= nil
        or n:find(" raid boss", 1, true) ~= nil
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
        local pgui = LP:FindFirstChild("PlayerGui")
        local main = pgui and pgui:FindFirstChild("Main")
        local minimal = pgui and pgui:FindFirstChild("Main (minimal)")
        local quest = (main and main:FindFirstChild("Quest", true))
            or (minimal and minimal:FindFirstChild("Quest", true))
        if not quest then return nil end
        local function Rendered(node)
            local cur = node
            while cur and cur ~= pgui do
                if cur:IsA("GuiObject") and cur.Visible == false then return false end
                if cur:IsA("LayerCollector") and cur.Enabled == false then return false end
                cur = cur.Parent
            end
            return true
        end
        if not Rendered(quest) then return nil end
        local container = quest:FindFirstChild("Container") or quest
        local parts = {}
        for _, d in ipairs(container:GetDescendants()) do
            if d:IsA("TextLabel") and Rendered(d) then
                local value = tostring(d.Text or "")
                if value ~= "" then parts[#parts + 1] = value end
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
    local state = HasQuest()
    if state == false then return false end
    local text = GetQuestText()
    if text and string.find(string.lower(text), string.lower(mobName), 1, true) then
        return true
    end
    if state == true then
        local activeMob = _G.State and _G.State.ActiveQuestMob
        if activeMob then
            return string.lower(tostring(activeMob)) == string.lower(tostring(mobName))
        end
    end
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
local DamageProvenGatherRoots = setmetatable({}, { __mode = "k" })
local GatherAuthorityClass = setmetatable({}, { __mode = "k" })
local GatherProbeCandidates = setmetatable({}, { __mode = "k" })
local GatherProbeFailedUntil = setmetatable({}, { __mode = "k" })
local GatherProbeAttempts = setmetatable({}, { __mode = "k" })
-- Server-shadow positions are captured before a local magnet write. They are never
-- overwritten by the visual anchor and therefore remain usable for real range gating.
local GatherOriginalPositions = setmetatable({}, { __mode = "k" })
local GatherVisualPinnedAt = setmetatable({}, { __mode = "k" })
-- v21.23 unknown-owner fallback. These tables never grant permanent authority;
-- leases are short, damage-backed and revoked on server snap-back.
_G.BobonGatherDamageLeaseUntil = setmetatable({}, { __mode = "k" })
_G.BobonGatherMoveTrial = setmetatable({}, { __mode = "k" })
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

-- Teddy-style farm policy: level/skip/raid combat must remain airborne.
-- Client mouse/tool fallbacks require physical weapon range, so they are never
-- selected while a persistent farm cluster is active. Boss/item controllers
-- outside farming may still use the old client fallback if no fast backend exists.
local function IsAirFarmCombat()
    local state = _G.State
    if not state or not (_G.Settings and _G.Settings.RemoteOnlyFarmCombat) then return false end
    return state.ClusterMode ~= nil and state.ClusterMode ~= "OFF"
        or state.Mode == "Farming" or state.Mode == "Raiding"
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
    NetModuleAPI = nil,
    GameGlobal = nil,
    NativeHelper = nil,
    HelperScanDone = 0,
    SessionToken = nil,
    SessionTokenSource = nil,
    TokenScanAt = 0,
    RejectedTokens = {},
    FailedUntil = {},
    BackendProofs = {},
    BackendLastProof = {},
    VerifiedMisses = {},
    -- Weak-key dispatch ledger for cluster kill accounting. It never owns movement
    -- and automatically forgets destroyed NPC models.
    RecentTargets = setmetatable({}, { __mode = "k" }),
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
    ClientRetreatUntil = 0,
    WatchedModel = nil,
    WatchedHumanoid = nil,
    WatchedHealth = nil,
    WatchedStableSince = 0,
    HealthConnection = nil,
    -- v21.16: deterministic victim rotation for server builds that consume only
    -- one NPC from each registered melee swing even when a batch list is supplied.
    ClusterRoundRobinCursor = 0,
    ClusterRoundRobinGeneration = -1,
    -- v21.17: unlike the old payload-only rotation, this victim owns the full
    -- combat context (watcher + pending target + remote first part) for a short burst.
    ClusterContextVictim = nil,
    ClusterContextGeneration = -1,
    ClusterContextCursor = 0,
    ClusterContextSelectedAt = 0,
    ClusterContextStartHealth = nil,
    ClusterContextIndex = 0,
    ClusterContextCount = 0,
}

function CombatController:ResolveRemotes()
    if self.RegisterAttack and self.RegisterAttack.Parent
        and self.RegisterHit and self.RegisterHit.Parent then
        return true
    end

    local net = ResolveNet()
    local attack = net and net:FindFirstChild("RE/RegisterAttack") or nil
    local hit = net and net:FindFirstChild("RE/RegisterHit") or nil

    -- v21.43: the shared/public source does not assume RE/* are exposed as
    -- direct children.  It requires Modules.Net and asks the module for the
    -- live RemoteEvent object. Support both shapes instead of deadlocking the
    -- combat selector when the direct children are absent on a client build.
    if (not attack or not hit) and net and net:IsA("ModuleScript") then
        local api = self.NetModuleAPI
        if type(api) ~= "table" then
            local okRequire, resolved = pcall(require, net)
            if okRequire and type(resolved) == "table" then
                api = resolved
                self.NetModuleAPI = resolved
            end
        end
        if type(api) == "table" and type(api.RemoteEvent) == "function" then
            if not attack then
                local okAttack, remote = pcall(function()
                    return api:RemoteEvent("RegisterAttack")
                end)
                if okAttack then attack = remote end
            end
            if not hit then
                local okHit, remote = pcall(function()
                    return api:RemoteEvent("RegisterHit", true)
                end)
                if okHit then hit = remote end
            end
        end
    end

    self.RegisterAttack = attack
    self.RegisterHit = hit
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
    local now = tick()
    local function accept(value, source)
        if not IsCombatToken(value) then return nil end
        local rejectedUntil = self.RejectedTokens and self.RejectedTokens[value] or 0
        if rejectedUntil and rejectedUntil > now then return nil end
        self.SessionToken = value
        self.SessionTokenSource = source or "runtime-scan"
        return value
    end

    local cached = accept(self.SessionToken, self.SessionTokenSource or "cache")
    if cached then return cached end

    -- Fast paths: several public/current clients cache the live token in an
    -- executor env or game-global table after the legitimate combat thread starts.
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local gameGlobal = self:GetGameGlobal()
    for _, scope in ipairs({env, _G, gameGlobal}) do
        if type(scope) == "table" then
            for _, key in ipairs({
                "_lastToken", "lastToken", "LastToken", "CombatToken",
                "combatToken", "AttackToken", "attackToken",
            }) do
                local token = accept(rawget(scope, key), "env:" .. key)
                if token then return token end
            end
        end
    end

    -- Keep the old SendHitsToServer derivation as a cheap compatibility path.
    local helper = gameGlobal and rawget(gameGlobal, "SendHitsToServer")
    local getUps = type(getupvalues) == "function" and getupvalues
        or (type(debug) == "table" and type(debug.getupvalues) == "function"
            and debug.getupvalues or nil)
    if type(helper) == "function" and type(getUps) == "function" then
        local ok, upvalues = pcall(getUps, helper)
        if ok and type(upvalues) == "table" then
            for _, value in pairs(upvalues) do
                local token = accept(value, "SendHitsToServer-upvalue")
                if token then return token end
            end
            if upvalues[1] ~= nil then
                local candidate = tostring(LP.UserId):sub(2, 4)
                    .. tostring(upvalues[1]):sub(11, 15)
                local token = accept(candidate, "legacy-derived")
                if token then return token end
            end
        end
    end

    -- getgc is expensive on mobile executors, so scan at most once every 2s
    -- and cap the number of inspected objects. Every candidate is still gated
    -- by the existing HP-delta verification before becoming trusted.
    if now - (self.TokenScanAt or 0) < 5 then return nil end
    self.TokenScanAt = now

    local getGC = type(getgc) == "function" and getgc or nil
    local getConstants = type(getconstants) == "function" and getconstants
        or (type(debug) == "table" and type(debug.getconstants) == "function"
            and debug.getconstants or nil)
    if not getGC then return nil end

    local okGC, objects = pcall(getGC, true)
    if not okGC or type(objects) ~= "table" then return nil end

    local inspected = 0
    for _, object in pairs(objects) do
        inspected = inspected + 1
        if inspected > 800 then break end

        if type(object) == "function" then
            if getUps then
                local okUp, values = pcall(getUps, object)
                if okUp and type(values) == "table" then
                    for _, value in pairs(values) do
                        local token = accept(value, "getgc-upvalue")
                        if token then return token end
                    end
                end
            end
            if getConstants then
                local okConst, values = pcall(getConstants, object)
                if okConst and type(values) == "table" then
                    for _, value in pairs(values) do
                        local token = accept(value, "getgc-constant")
                        if token then return token end
                    end
                end
            end
        elseif type(object) == "table" then
            -- Only inspect token-looking keys in arbitrary tables to avoid
            -- treating unrelated 8-char hex strings as combat tokens.
            for key, value in pairs(object) do
                if type(key) == "string" and string.find(string.lower(key), "token", 1, true) then
                    local token = accept(value, "getgc-table:" .. key)
                    if token then return token end
                end
            end
        end
    end
    return nil
end

function CombatController:LegacyAllowed()
    if not self:ResolveRemotes() then return false end
    -- v21.19: the current public fast-attack shape talks to these two remotes
    -- directly. COMBAT_REMOTE_THREAD being true does not prove that direct
    -- RegisterAttack/RegisterHit is invalid. Shadow QUEST probes it and trusts
    -- only a real HP delta; outside that mode preserve the older conservative gate.
    if ClusterFarmController and ClusterFarmController:IsShadowCombatActive() then
        return true
    end
    if _G.Settings.ClusterPreferLegacyFanout ~= false
        and IsAirFarmCombat() and _G.State and (_G.State.ClusterMode ~= "OFF"
            or (_G.Settings.SharedSourceFarmMode ~= false
                and (_G.State.FState == "SHARED_ATTACK" or _G.State.FState == "SHARED_BRING_FARM")))
        and _G.Settings.ClusterIndependentSwingFanout == true then
        -- Shared-source farm deliberately allows the same direct RegisterHit path.
        -- HP proof still decides whether the backend remains trusted.
        return true
    end
    local gameGlobal = self:GetGameGlobal()
    local flag = gameGlobal and rawget(gameGlobal, "COMBAT_REMOTE_THREAD")
    return flag ~= true
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
        and activeQuestMob ~= nil and mobName ~= nil
        and string.lower(tostring(activeQuestMob)) == string.lower(tostring(mobName))
    local clusterGatherActive = ClusterFarmController
        and ClusterFarmController:IsAttackCluster(mobName) == true
    local sharedFarmActive = _G.Settings.SharedSourceFarmMode ~= false
        and _G.State and _G.State.Mode == "Farming"
        and (_G.State.FState == "SHARED_ATTACK" or _G.State.FState == "SHARED_BRING_FARM")
    -- v22.11.1: early skip uses a same-frame direct-magnet mark instead of
    -- ClusterFarmController ownership/proof admission. Kept inside this function
    -- so no extra top-level local is allocated in the giant Luau chunk.
    local skipPinned = _G.BobonSkipMagnetPinnedModels
    local skipMagnetActive = _G.State and _G.State.Mode == "Farming"
        and _G.State.ClusterMode == "SKIP" and type(skipPinned) == "table"
    local shadowQuest = questGatherActive and not sharedFarmActive and ClusterFarmController
        and ClusterFarmController:IsShadowCombatActive()

    local function add(enemy, shadowRange)
        if not enemy or seen[enemy] then return end
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        local part = SelectEnemyHitPart(enemy)
        if not hum or hum.Health <= 0 or not root or not root.Parent
            or not part or not part.Parent then
            return
        end

        local rangeOK = false
        local gatePosition = nil
        if shadowRange and ClusterFarmController then
            gatePosition = ClusterFarmController:GetServerShadowPosition(enemy)
            if gatePosition then
                local range = tonumber(maxRange)
                    or tonumber(_G.Settings.ClusterShadowAttackRange)
                    or tonumber(_G.Settings.FastAttackRange) or 100
                range = range + (tonumber(_G.Settings.ClusterShadowRangeSlack) or 0)
                rangeOK = (gatePosition - me.Position).Magnitude <= range
            end
        else
            local okPosition, rootPosition = pcall(function() return root.Position end)
            if okPosition and IsValidPos(rootPosition) then
                gatePosition = rootPosition
                rangeOK = (rootPosition - me.Position).Magnitude <= maxRange
            end
        end

        if rangeOK then
            seen[enemy] = true
            results[#results + 1] = {
                Model=enemy, Humanoid=hum, Root=root, Part=part,
                ShadowPosition=shadowRange and gatePosition or nil,
            }
        end
    end

    if preferred then
        add(preferred, shadowQuest)
    end

    local raidClusterActive = _G.State and _G.State.Mode == "Raiding"
        and _G.State.ClusterMode == "RAID" and ClusterFarmController ~= nil
    if raidClusterActive then
        local cap = _G.Settings.RaidFastAttackMaxTargets
            or _G.Settings.FastAttackMaxTargets or 12
        for _, enemy in ipairs(folder:GetChildren()) do
            if #results >= cap then break end
            if enemy ~= preferred and not IsRaidBossModel(enemy)
                and (ClusterFarmController:IsVerified(enemy)
                    or ClusterFarmController:IsProbeCandidate(enemy)) then
                add(enemy, false)
            end
        end
    elseif _G.State and _G.State.ClusterMode == "ITEM"
        and _G.State.Mode == "GettingItem" and ClusterFarmController then
        local cap = _G.Settings.ClusterAttackMaxTargets
            or _G.Settings.FastAttackMaxTargets or 64
        for _, enemy in ipairs(folder:GetChildren()) do
            if #results >= cap then break end
            if enemy ~= preferred and ClusterFarmController:IsModelAllowed(enemy)
                and (ClusterFarmController:IsVerified(enemy)
                    or ClusterFarmController:IsProbeCandidate(enemy)) then
                add(enemy, false)
            end
        end
    elseif mobName then
        local cap = shadowQuest
            and (tonumber(_G.Settings.ClusterShadowMaxTargets) or 12)
            or ((questGatherActive or clusterGatherActive)
                and (_G.Settings.ClusterAttackMaxTargets or 32)
                or (_G.Settings.FastAttackMaxTargets or 32))
        for _, enemy in ipairs(folder:GetChildren()) do
            if #results >= cap then break end
            if IsEnemyNamed(enemy, mobName) then
                if shadowQuest then
                    -- Key v21.19 rule: attack eligibility comes from the server-shadow
                    -- position captured before magnet writes, NOT root.Position after pin.
                    add(enemy, true)
                else
                    local allowExtra = true
                    if skipMagnetActive and enemy ~= preferred then
                        -- Same-frame direct magnet: bypass false/unknown ownership reports.
                        -- TTL is intentionally short; every usable secondary must be refreshed
                        -- by SkipRouteController:DirectMagnet continuously.
                        allowExtra = (skipPinned[enemy] or 0) > tick()
                    elseif sharedFarmActive and enemy ~= preferred then
                        -- v22.5 no-ghost rule: visual proximity is not authority. Secondary
                        -- fan-out requires real network ownership, causal HP proof, or a
                        -- short active probe launched by SharedBring.
                        allowExtra = ClusterFarmController
                            and ClusterFarmController:IsSharedAttackEligible(enemy, preferred)
                    elseif (questGatherActive or clusterGatherActive) and enemy ~= preferred then
                        local verified = ClusterFarmController
                            and ClusterFarmController:IsVerified(enemy)
                        local probe = ClusterFarmController
                            and ClusterFarmController:IsProbeCandidate(enemy)
                        allowExtra = verified or probe
                    end
                    if allowExtra then add(enemy, false) end
                end
            end
        end
    end
    return results
end

function CombatController:SnapshotClusterHealth(entries)
    local snapshot = {}
    for _, entry in ipairs(entries or {}) do
        local model = entry.Model
        local hum = model and model:FindFirstChildOfClass("Humanoid")
        if model and hum then
            snapshot[#snapshot + 1] = {
                Model = model,
                Humanoid = hum,
                Health = math.max(0, tonumber(hum.Health) or 0),
            }
        end
    end
    return snapshot
end

function CombatController:ClusterHealthDelta(snapshot, applyProof)
    local delta, changed = 0, 0
    for _, row in ipairs(snapshot or {}) do
        local model, hum = row.Model, row.Humanoid
        local before = tonumber(row.Health) or 0
        local after = 0
        if hum and hum.Parent and model and model.Parent then
            after = math.max(0, tonumber(hum.Health) or 0)
        end
        if after < before - 0.01 then
            -- Never use a clearly-attributed nearby player's damage to validate
            -- our remote backend. A destroyed/dead mob otherwise counts as 0 HP.
            if not DamageAttributedToOtherPlayer(model, hum) then
                local oneDelta = before - after
                delta = delta + oneDelta
                changed = changed + 1
                if applyProof and ClusterFarmController and model and model.Parent
                    and hum and hum.Health > 0
                    and ClusterFarmController:IsModelAllowed(model) then
                    pcall(function()
                        ClusterFarmController:ConfirmDamageProof(model)
                    end)
                end
            end
        end
    end
    return delta, changed
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
    if IsClientInputBackend(backend) then
        local clustered = _G.State and _G.State.ClusterMode ~= "OFF"
            and (tonumber(_G.BobonDiagnostics and _G.BobonDiagnostics.BringCandidates) or 0) >= 2
        self.NextFastUpgrade = tick() + (clustered and 2.0
            or (_G.Settings.CombatFastUpgradeInterval or 90))
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
            if ClusterFarmController and model and model.Parent
                and ClusterFarmController:IsModelAllowed(model)
                and humanoid and humanoid.Health > 0 then
                pcall(function() ClusterFarmController:ConfirmDamageProof(model) end)
            end
            self:ConfirmDamage(self.PendingBackend, oldHealth - newHealth)
        end
        if oldHealth and newHealth ~= oldHealth then
            self.WatchedStableSince = now
        end
    end)
end

function CombatController:FailBackend(backend, reason)
    if not backend then return end
    local proofs = self.BackendProofs[backend] or 0
    local wasProven = self.VerifiedBackend == backend
        and proofs >= (_G.Settings.CombatProofsRequired or 2)
    local retryFor = wasProven
        and (_G.Settings.CombatVerifiedBackendRetry or 0.85)
        or (_G.Settings.CombatBackendRetry or 12)
    if backend == "SKID-DIRECT-4" and not wasProven then
        retryFor = math.max(0.20, tonumber(_G.Settings.SharedSkidDirectRetry) or 0.45)
    end
    self.FailedUntil[backend] = tick() + retryFor
    if backend == "TOKEN-4" then
        if IsCombatToken(self.SessionToken) then
            self.RejectedTokens = self.RejectedTokens or {}
            -- A token that already produced verified HP damage should not disappear
            -- for a full minute because one stacked primary missed.
            self.RejectedTokens[self.SessionToken] = tick() + (wasProven and 2.0 or 60)
        end
        self.SessionToken = nil
        self.SessionTokenSource = nil
    end
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

    -- v21.14: a remote backend with real HP proof must not enter the old
    -- "3 packets -> WAIT-FAST-REMOTE" cycle while fighting a stacked air-farm batch.
    -- ConfirmDamage (primary or aggregate batch proof) clears pending immediately
    -- on real damage. A bounded silent window still rotates a truly dead backend.
    local pendingProofs = self.BackendProofs[self.PendingBackend] or 0
    local provenAirRemote = IsAirFarmCombat()
        and not IsClientInputBackend(self.PendingBackend)
        and self.VerifiedBackend == self.PendingBackend
        and pendingProofs >= (_G.Settings.CombatProofsRequired or 2)
    if provenAirRemote then
        local silentFor = now - (self.PendingSince or now)
        if silentFor >= (_G.Settings.CombatVerifiedContinuousWindow or 2.60) then
            self:FailBackend(self.PendingBackend, "VERIFIED-BATCH-NO-HP")
        end
        return
    end

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
            if ClusterFarmController and self.PendingTarget
                and ClusterFarmController:IsProbeCandidate(self.PendingTarget)
                and not ClusterFarmController:IsVerified(self.PendingTarget) then
                pcall(function() ClusterFarmController:RejectDamageProbe(self.PendingTarget) end)
                self:AbortPending("AUTHORITY-PROBE-MISS")
            else
                self:FailBackend(backend, "NO-HP-DELTA")
            end
        end
    end
end

function CombatController:BuildSharedDirectToken()
    -- Match the public shared-source fallback first.  It combines three user-id
    -- digits with five characters from the current coroutine string.  If this
    -- executor formats coroutine.running() differently, fall back to the live
    -- token resolver already used by TOKEN-4.
    local uid = tostring(LP and LP.UserId or "")
    local co = tostring(coroutine.running())
    local token = uid:sub(2, 4) .. co:sub(11, 15)
    if IsCombatToken(token) then return token end
    return self:ResolveSessionToken()
end

function CombatController:BackendAvailable(name)
    if (self.FailedUntil[name] or 0) > tick() then return false end
    if name == "CLIENT-HELPER" then
        return self:ResolveRemotes() and type(self:ResolveNativeHelper()) == "function"
    elseif name == "TOKEN-4" then
        return self:ResolveRemotes() and IsCombatToken(self:ResolveSessionToken())
    elseif name == "SKID-DIRECT-4" then
        return _G.Settings.SharedSkidDirectFallback ~= false
            and self:ResolveRemotes()
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
    local airFarm = IsAirFarmCombat()
    local shadowQuest = airFarm and ClusterFarmController
        and ClusterFarmController:IsShadowCombatActive()
    local stackedCount = tonumber(_G.BobonDiagnostics
        and _G.BobonDiagnostics.BringMoved) or 0
    local sharedFarm = airFarm and _G.Settings.SharedSourceFarmMode ~= false
        and _G.State and (_G.State.FState == "SHARED_ATTACK" or _G.State.FState == "SHARED_BRING_FARM")
    local sharedMulti = sharedFarm and stackedCount >= 2
    local clusterMulti = airFarm
        and _G.State and (_G.State.ClusterMode ~= "OFF" or sharedMulti)
        and stackedCount >= 2

    if self.PendingBackend then
        -- A stale helper pending from the previous target/field must not block the
        -- direct shadow-batch probe. This was visible in Roblox(9): helper -> wait ->
        -- helper while quest stayed 0/7.
        if shadowQuest and _G.Settings.ClusterShadowPreferLegacy ~= false
            and self.PendingBackend ~= "LEGACY-2"
            and self:BackendAvailable("LEGACY-2") then
            self:AbortPending("SHADOW-DIRECT-UPGRADE")
        else
            local pendingProofs = self.BackendProofs[self.PendingBackend] or 0
            local provenAirRemote = airFarm
                and not IsClientInputBackend(self.PendingBackend)
                and self.VerifiedBackend == self.PendingBackend
                and pendingProofs >= (_G.Settings.CombatProofsRequired or 2)
            if self.PendingAttempts >= (_G.Settings.CombatProbeAttempts or 3)
                and not provenAirRemote then
                return nil
            end
            if airFarm and IsClientInputBackend(self.PendingBackend) then
                self:AbortPending("AIR-FARM-REMOTE-ONLY")
            else
                return self.PendingBackend
            end
        end
    end
    if now < self.NextProbeAt then return nil end

    -- v21.19: do NOT let a globally-proven CLIENT-HELPER monopolize a new field.
    -- Roblox(9).mp4 showed repeated AIR-ATTACK:CLIENT-HELPER with zero quest/HP.
    -- Probe the canonical direct remote first for shadow-qualified targets.
    if shadowQuest and _G.Settings.ClusterShadowPreferLegacy ~= false
        and self:BackendAvailable("LEGACY-2") then
        return "LEGACY-2"
    end

    -- v21.43: ordinary shared-source quest farm probes the source-compatible
    -- direct 4-argument hit shape first. Real HP proof still decides trust.
    if sharedFarm and self:BackendAvailable("SKID-DIRECT-4") then
        return "SKID-DIRECT-4"
    end

    if self.VerifiedBackend and self:BackendAvailable(self.VerifiedBackend) then
        if not (airFarm and IsClientInputBackend(self.VerifiedBackend)) then
            return self.VerifiedBackend
        end
    end

    if airFarm then
        local order = shadowQuest
            and {"LEGACY-2", "TOKEN-4", "CLIENT-HELPER"}
            or (clusterMulti
                and (_G.Settings.ClusterPreferLegacyFanout ~= false
                    and {"SKID-DIRECT-4", "LEGACY-2", "TOKEN-4", "CLIENT-HELPER"}
                    or {"SKID-DIRECT-4", "TOKEN-4", "CLIENT-HELPER", "LEGACY-2"})
                or {"SKID-DIRECT-4", "CLIENT-HELPER", "TOKEN-4", "LEGACY-2"})
        for _, name in ipairs(order) do
            if self:BackendAvailable(name) then return name end
        end
        return nil
    end

    for _, name in ipairs({
        "CLIENT-HELPER", "SKID-DIRECT-4", "TOKEN-4", "LEGACY-2",
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
    if IsAirFarmCombat() then return false end
    if FarmSafetyActive() then return false end
    if tick() < (self.ClientRetreatUntil or 0) then return false end
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

    local sharedIndependent = IsAirFarmCombat()
        and _G.Settings.SharedSourceFarmMode ~= false
        and _G.State and (_G.State.FState == "SHARED_ATTACK" or _G.State.FState == "SHARED_BRING_FARM")
        and #entries >= 2
    local clusterIndependent = IsAirFarmCombat()
        and _G.Settings.ClusterIndependentSwingFanout == true
        and _G.State and (_G.State.ClusterMode ~= "OFF" or sharedIndependent)
        and #entries >= 2
    local maxFanout = math.max(2, math.floor(tonumber(sharedIndependent
        and _G.Settings.SharedAttackMaxTargets
        or _G.Settings.ClusterIndependentSwingMaxTargets) or 8))
    local gap = math.max(0,
        tonumber(_G.Settings.ClusterIndependentSwingGap) or 0.022)

    if IsClientInputBackend(backend) then
        if IsAirFarmCombat() then return false end
        local ok = self:DispatchClientClick(tool, preferredRoot, backend)
        if ok then
            self.DesiredClientRange = false
            self.ClientRetreatUntil = tick() + (_G.Settings.ClientRetreatDelay or 0.55)
        end
        return ok

    elseif backend == "CLIENT-HELPER" then
        local helper = self:ResolveNativeHelper()
        if type(helper) ~= "function" then return false end

        if clusterIndependent then
            local anyOk = false
            local limit = math.min(#entries, maxFanout)
            for i = 1, limit do
                local entry = entries[i]
                local part = entry.Model:FindFirstChild("Head") or entry.Part
                if part and part:IsA("BasePart") then
                    pcall(function() self.RegisterAttack:FireServer(0) end)
                    local ok = pcall(function()
                        helper(part, {{entry.Model, part}})
                    end)
                    anyOk = anyOk or ok
                    if gap > 0 and i < limit then task.wait(gap) end
                end
            end
            return anyOk
        end

        local hitList, basePart = {}, nil
        for _, entry in ipairs(entries) do
            local part = entry.Model:FindFirstChild("Head") or entry.Part
            if part and part:IsA("BasePart") then
                hitList[#hitList + 1] = {entry.Model, part}
                basePart = basePart or part
            end
        end
        if not basePart or #hitList == 0 then return false end
        pcall(function() self.RegisterAttack:FireServer(0) end)
        return pcall(function() helper(basePart, hitList) end)

    elseif backend == "TOKEN-4" then
        local token = self:ResolveSessionToken()
        if not IsCombatToken(token) then return false end

        if clusterIndependent then
            -- Fresh RegisterAttack for EVERY victim. Current public 2026 examples
            -- use this exact single-target token shape; one registered swing is not
            -- reused across several NPCs.
            local anyOk = false
            local limit = math.min(#entries, maxFanout)
            for i = 1, limit do
                local entry = entries[i]
                local part = entry.Part
                if part and part:IsA("BasePart") then
                    pcall(function() self.RegisterAttack:FireServer(0.5) end)
                    local ok = pcall(function()
                        self.RegisterHit:FireServer(part, {}, nil, token)
                    end)
                    anyOk = anyOk or ok
                    if gap > 0 and i < limit then task.wait(gap) end
                end
            end
            return anyOk
        end

        pcall(function() self.RegisterAttack:FireServer(0.5) end)
        return pcall(function()
            self.RegisterHit:FireServer(entries[1].Part, {}, nil, token)
        end)

    elseif backend == "SKID-DIRECT-4" then
        if not self:ResolveRemotes() then return false end
        local token = self:BuildSharedDirectToken()
        if not IsCombatToken(token) then return false end

        -- Exact shared-source rhythm: every victim receives a fresh registered
        -- attack followed by RegisterHit(part, {{model, part}, part}, nil, token).
        -- Do not batch several victims under one swing; the live source repeats
        -- RegisterAttack for each nearby NPC.
        local anyOk = false
        local limit = math.min(#entries,
            math.max(1, math.floor(tonumber(_G.Settings.SharedSkidDirectMaxTargets)
                or tonumber(_G.Settings.SharedAttackMaxTargets) or 32)))
        local gap = math.max(0, tonumber(_G.Settings.SharedSkidDirectGap) or 0.03)
        for i = 1, limit do
            local entry = entries[i]
            local part = entry.Model and (entry.Model:FindFirstChild("Head") or entry.Part)
            if part and part:IsA("BasePart") then
                pcall(function() self.RegisterAttack:FireServer(0.125) end)
                local ok = pcall(function()
                    self.RegisterHit:FireServer(part, {
                        {entry.Model, part},
                        part,
                    }, nil, token)
                end)
                anyOk = anyOk or ok
                if gap > 0 and i < limit then task.wait(gap) end
            end
        end
        return anyOk

    elseif backend == "LEGACY-2" then
        local shadowQuest = ClusterFarmController
            and ClusterFarmController:IsShadowCombatActive()
        if shadowQuest then
            -- v21.19 adaptive TRUE multi-damage:
            -- Start with the canonical current public shape: ONE RegisterAttack and
            -- ONE RegisterHit containing every server-shadow-in-range {Model,Head}.
            -- Exact per-Humanoid HP snapshots then reveal which victims the server
            -- actually accepted. If only a subset takes damage, subsequent ticks give
            -- ONLY the unproven victims fresh independent swings until each is proven.
            local limit = math.min(#entries,
                math.max(1, math.floor(tonumber(_G.Settings.ClusterShadowMaxTargets) or 12)))
            local unproven = {}
            for i = 1, limit do
                local entry = entries[i]
                if not (ClusterFarmController
                    and ClusterFarmController:IsDamageProven(entry.Model)) then
                    unproven[#unproven + 1] = entry
                end
            end

            local function sendCanonicalBatch()
                local hitList, basePart = {}, nil
                for i = 1, limit do
                    local entry = entries[i]
                    local part = entry.Model:FindFirstChild("Head") or entry.Part
                    if part and part:IsA("BasePart") then
                        hitList[#hitList + 1] = {entry.Model, part}
                        basePart = basePart or part
                    end
                end
                if not basePart or #hitList == 0 then return false end
                pcall(function() self.RegisterAttack:FireServer(0) end)
                return pcall(function()
                    self.RegisterHit:FireServer(basePart, hitList)
                end)
            end

            -- First contact: use the exact one-swing batch layout.  This avoids
            -- replacing a known-good public shape with speculative per-target spam.
            if #unproven == limit and limit >= 2 then
                return sendCanonicalBatch()
            end

            -- Partial proof means the batch is genuinely reaching the server but one
            -- or more victims were ignored. Retry only those victims with a fresh swing.
            if #unproven > 0 then
                local anyOk = false
                local oneGap = math.max(0.01,
                    tonumber(_G.Settings.ClusterIndependentSwingGap) or 0.022)
                for i, entry in ipairs(unproven) do
                    local part = entry.Model:FindFirstChild("Head") or entry.Part
                    if part and part:IsA("BasePart") then
                        pcall(function() self.RegisterAttack:FireServer(0) end)
                        local ok = pcall(function()
                            self.RegisterHit:FireServer(part, {{entry.Model, part}})
                        end)
                        anyOk = anyOk or ok
                        if oneGap > 0 and i < #unproven then task.wait(oneGap) end
                    end
                end
                return anyOk
            end

            -- All current victims proved real damage recently: efficient batch mode.
            return sendCanonicalBatch()
        end

        if clusterIndependent then
            local anyOk = false
            local limit = math.min(#entries, maxFanout)
            for i = 1, limit do
                local entry = entries[i]
                local part = entry.Model:FindFirstChild("Head") or entry.Part
                if part and part:IsA("BasePart") then
                    pcall(function() self.RegisterAttack:FireServer(0) end)
                    local ok = pcall(function()
                        self.RegisterHit:FireServer(part, {{entry.Model, part}})
                    end)
                    anyOk = anyOk or ok
                    if gap > 0 and i < limit then task.wait(gap) end
                end
            end
            return anyOk
        end

        local hitList, basePart = {}, nil
        for _, entry in ipairs(entries) do
            local part = entry.Model:FindFirstChild("Head") or entry.Part
            if part and part:IsA("BasePart") then
                hitList[#hitList + 1] = {entry.Model, part}
                basePart = basePart or part
            end
        end
        if not basePart or #hitList == 0 then return false end
        pcall(function() self.RegisterAttack:FireServer(0) end)
        return pcall(function()
            self.RegisterHit:FireServer(basePart, hitList)
        end)

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

    -- v21.17 FULL-CONTEXT ROTATION. v21.16 changed only dispatchEntries, leaving
    -- WatchTarget/PendingTarget/preferredRoot on the same primary. Some live helper
    -- implementations resolve their victim from that surrounding combat context, so
    -- changing only the payload can still damage the same NPC forever.
    local contextRoundRobinActive = false
    local contextRoundRobinIndex, contextRoundRobinCount = 0, 0
    if IsAirFarmCombat() and _G.State and _G.State.ClusterMode ~= "OFF"
        and mobName and _G.Settings.ClusterReliableRoundRobin ~= false
        and _G.Settings.ClusterIndependentSwingFanout ~= true then
        local prelim = self:CollectTargets(preferredModel, mobName,
            _G.Settings.FastAttackRange or _G.Settings.AttackRange or 100)
        local minTargets = _G.Settings.ClusterRoundRobinMinTargets or 2
        if #prelim >= minTargets then
            local generation = tonumber(_G.State.ClusterGeneration) or 0
            if self.ClusterContextGeneration ~= generation then
                self.ClusterContextGeneration = generation
                self.ClusterContextCursor = 0
                self.ClusterContextVictim = nil
                self.ClusterContextSelectedAt = 0
                self.ClusterContextStartHealth = nil
            end

            local victimStillValid = false
            if self.ClusterContextVictim and self.ClusterContextVictim.Parent then
                local vh = self.ClusterContextVictim:FindFirstChildOfClass("Humanoid")
                local vr = self.ClusterContextVictim:FindFirstChild("HumanoidRootPart")
                victimStillValid = vh and vh.Health > 0 and vr and vr.Parent
                    and ClusterFarmController
                    and ClusterFarmController:IsAttackEligible(self.ClusterContextVictim)
            end

            local observedDamage = false
            if victimStillValid and self.ClusterContextStartHealth ~= nil then
                local vh = self.ClusterContextVictim:FindFirstChildOfClass("Humanoid")
                observedDamage = vh and vh.Health < self.ClusterContextStartHealth - 0.01
            end
            local hold = math.max(0.12, tonumber(_G.Settings.ClusterContextVictimHold) or 0.32)
            local holdExpired = victimStillValid and now - (self.ClusterContextSelectedAt or 0) >= hold

            if not victimStillValid or observedDamage or holdExpired then
                -- Find the next live verified model in the freshly collected list.
                local start = self.ClusterContextCursor
                local chosenIndex = nil
                for step = 1, #prelim do
                    local idx = ((start + step - 1) % #prelim) + 1
                    local row = prelim[idx]
                    if row and row.Model and row.Humanoid and row.Humanoid.Health > 0
                        and row.Root and row.Root.Parent then
                        chosenIndex = idx
                        break
                    end
                end
                if chosenIndex then
                    self.ClusterContextCursor = chosenIndex
                    local row = prelim[chosenIndex]
                    self.ClusterContextVictim = row.Model
                    self.ClusterContextSelectedAt = now
                    self.ClusterContextStartHealth = row.Humanoid.Health
                end
            end

            -- Re-resolve the current victim from prelim so the payload and context use
            -- the exact currently streamed instances for this frame.
            local selectedRow, selectedIndex
            for i, row in ipairs(prelim) do
                if row.Model == self.ClusterContextVictim then
                    selectedRow, selectedIndex = row, i
                    break
                end
            end
            if not selectedRow then
                selectedIndex = 1
                selectedRow = prelim[1]
                self.ClusterContextVictim = selectedRow.Model
                self.ClusterContextCursor = selectedIndex
                self.ClusterContextSelectedAt = now
                self.ClusterContextStartHealth = selectedRow.Humanoid.Health
            end

            if selectedRow then
                preferredModel = selectedRow.Model
                preferredHum = selectedRow.Humanoid
                preferredRoot = selectedRow.Root
                contextRoundRobinActive = true
                contextRoundRobinIndex = selectedIndex or 1
                contextRoundRobinCount = #prelim
                self.ClusterContextIndex = contextRoundRobinIndex
                self.ClusterContextCount = contextRoundRobinCount
            end
        else
            self.ClusterContextVictim = nil
            self.ClusterContextStartHealth = nil
            self.ClusterContextIndex = 0
            self.ClusterContextCount = #prelim
        end
    end

    self:WatchTarget(preferredModel, preferredHum)

    -- Choose the desired physical range before dispatching. Fast/helper
    -- probes stay at safe hover; only an actual client-input backend asks the
    -- travel controller to descend into real melee/sword range.
    local airFarm = IsAirFarmCombat()
    local candidateBackend = kind == "Gun" and "GUN-REMOTE"
        or self.PendingBackend or self:SelectBackend(now)
    if airFarm and IsClientInputBackend(candidateBackend) then
        candidateBackend = self:SelectBackend(now)
    end
    self.DesiredClientRange = (not airFarm) and (IsClientInputBackend(candidateBackend)
        or (not candidateBackend and IsClientInputBackend(self.VerifiedBackend))) or false
    if not candidateBackend then
        _G.BobonDiagnostics.Packet = airFarm and "WAIT-FAST-REMOTE" or "WAIT-BACKEND"
        return false
    end
    local candidateInputBackend = IsClientInputBackend(candidateBackend)
    if candidateInputBackend and FarmSafetyActive() then
        self.DesiredClientRange = false
        if self.PendingBackend and IsClientInputBackend(self.PendingBackend) then
            self:AbortPending("SAFE-HOVER")
        end
        _G.BobonDiagnostics.Packet = "SAFE-HOVER"
        return false
    end
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
        self.DesiredClientRange = false
        _G.BobonDiagnostics.Packet = airFarm and "WAIT-FAST-REMOTE" or "WAIT-HP"
        return false
    end
    local inputBackend = IsClientInputBackend(backend)
    if airFarm and inputBackend then
        self:AbortPending("AIR-FARM-REMOTE-ONLY")
        self.DesiredClientRange = false
        _G.BobonDiagnostics.Packet = "WAIT-FAST-REMOTE"
        return false
    end
    self.DesiredClientRange = (not airFarm) and inputBackend or false
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
    -- v21.16 RELIABLE CLUSTER DAMAGE:
    -- The server session shown by the user accepts the stacked positioning but consumes
    -- only one victim from a nominal multi-entry melee swing. Instead of repeatedly
    -- feeding the same preferred mob, rotate one real registered swing across every
    -- verified stacked entry at the existing attack cadence. This is deliberately
    -- bounded to one victim per AttackDelay tick; no extra attack loop/thread is created.
    local dispatchEntries = entries
    local sharedFarmFanout = _G.Settings.SharedSourceFarmMode ~= false
        and _G.State and _G.State.Mode == "Farming"
        and (_G.State.FState == "SHARED_ATTACK" or _G.State.FState == "SHARED_BRING_FARM")
    local clusterFanout = _G.State
        and (_G.State.ClusterMode ~= "OFF" or sharedFarmFanout)
        and not IsClientInputBackend(backend)

    -- v21.17: if a full-context victim was selected above, entries[1] is that victim
    -- because CollectTargets always inserts preferred first. Do NOT rotate the payload
    -- a second time here; watcher/pending/first-part/hit-list must all name one model.
    local roundRobinActive = false
    if contextRoundRobinActive then
        dispatchEntries = { entries[1] }
    else
        roundRobinActive = clusterFanout
            and _G.Settings.ClusterReliableRoundRobin ~= false
            and _G.Settings.ClusterIndependentSwingFanout ~= true
            and #entries >= (_G.Settings.ClusterRoundRobinMinTargets or 2)
        if roundRobinActive then
            local generation = tonumber(_G.State and _G.State.ClusterGeneration) or 0
            if self.ClusterRoundRobinGeneration ~= generation then
                self.ClusterRoundRobinGeneration = generation
                self.ClusterRoundRobinCursor = 0
            end
            self.ClusterRoundRobinCursor = (self.ClusterRoundRobinCursor % #entries) + 1
            dispatchEntries = { entries[self.ClusterRoundRobinCursor] }
        elseif not (clusterFanout and (_G.Settings.RemoteProbeAllCluster ~= false))
            and (self.VerifiedBackend ~= backend or not self:IsFastReady()) then
            dispatchEntries = { entries[1] }
        end
    end
    local aggregateSnapshot = nil
    if clusterFanout and _G.Settings.CombatClusterAggregateProof ~= false
        and not IsClientInputBackend(backend) then
        -- Snapshot BEFORE dispatch so immediate server damage is still measurable.
        aggregateSnapshot = self:SnapshotClusterHealth(dispatchEntries)
    end
    local attempted = self:Dispatch(backend, tool, dispatchEntries, preferredRoot)
    local diag = _G.BobonDiagnostics
    diag.Net = backend
    diag.Targets = #entries
    if attempted then
        self.PendingAttempts = self.PendingAttempts + 1
        self.PendingLastDispatch = now
        self.PendingSettleUntil = 0
        for _, dispatchedEntry in ipairs(dispatchEntries) do
            if dispatchedEntry.Model then
                self.RecentTargets[dispatchedEntry.Model] = now
                if ClusterFarmController
                    and ClusterFarmController:IsProbeCandidate(dispatchedEntry.Model)
                    and _G.State
                    and _G.State.ClusterAuthorityProbeTarget == dispatchedEntry.Model
                    and (tonumber(_G.State.ClusterAuthorityProbeFirstAttackAt) or 0) <= 0 then
                    _G.State.ClusterAuthorityProbeFirstAttackAt = now
                end
            end
        end

        -- v21.14 aggregate causal proof. A cluster remote dispatch fans out to
        -- multiple verified targets, so the promoted primary is not guaranteed
        -- to be the mob whose HP changes first.
        if aggregateSnapshot then
            local snapshot = aggregateSnapshot
            local proofBackend = backend
            local proofTarget = preferredModel
            local function checkAggregateProof()
                if not SessionAlive() then return end
                -- Always apply exact per-model HP proof, even if the first victim's
                -- HealthChanged already cleared PendingBackend. Otherwise target #2/#3
                -- can really take damage yet never become authority-verified.
                local delta, changed = self:ClusterHealthDelta(snapshot, true)
                if changed and changed > 0 then
                    _G.BobonDiagnostics.ClusterDamaged = changed
                end
                if delta > 0 and self.PendingBackend == proofBackend
                    and self.PendingTarget == proofTarget then
                    self:ConfirmDamage(proofBackend, delta)
                end
            end
            task.delay(_G.Settings.CombatClusterAggregateProofDelay or 0.12,
                checkAggregateProof)
            task.delay(_G.Settings.CombatClusterAggregateLateDelay or 0.30,
                checkAggregateProof)
        end

        if contextRoundRobinActive then
            diag.Packet = ("AIR-CTX-RR:%s %d/%d"):format(
                tostring(backend), contextRoundRobinIndex, contextRoundRobinCount)
        elseif roundRobinActive then
            diag.Packet = ("AIR-RR:%s %d/%d"):format(
                tostring(backend), self.ClusterRoundRobinCursor, #entries)
        else
            local batchSuffix = (#dispatchEntries > 1)
                and (" x" .. tostring(#dispatchEntries)) or ""
            diag.Packet = (IsAirFarmCombat() and not IsClientInputBackend(backend))
                and ("AIR-ATTACK:" .. backend .. batchSuffix)
                or ("ATTEMPT:" .. backend .. batchSuffix)
        end
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
    self.NetModuleAPI = nil
    self.SessionToken = nil
    self.SessionTokenSource = nil
    self.TokenScanAt = 0
    self.RejectedTokens = {}
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
    self.RecentTargets = setmetatable({}, { __mode = "k" })
    self.NextFastUpgrade = 0
    self.DesiredClientRange = false
    self.WatchedStableSince = 0
    self.ClusterRoundRobinCursor = 0
    self.ClusterRoundRobinGeneration = -1
    self.ClusterContextVictim = nil
    self.ClusterContextGeneration = -1
    self.ClusterContextCursor = 0
    self.ClusterContextSelectedAt = 0
    self.ClusterContextStartHealth = nil
    self.ClusterContextIndex = 0
    self.ClusterContextCount = 0
end

local MasterySkillController

local function Attack(preferredTarget, mobName)
    if not IsAlive() then return false end
    -- v22.3: evade and attack are concurrent. Dodge only offsets TravelManager;
    -- it never suppresses remote/fanout dispatch against the locked target.
    local attackingWhileDodge = _G.State and _G.State.DodgeActive
        and _G.Settings.DodgeKeepAttacking ~= false
    if _G.State and _G.State.DodgeActive and not attackingWhileDodge then
        _G.BobonDiagnostics.Packet = "DODGE-HOLD"
        return false
    elseif attackingWhileDodge then
        _G.BobonDiagnostics.Packet = "DODGE+ATTACK"
    end
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
    local attempted = CombatController:Attack(tool, kind, targetModel, targetHum, targetRoot, mobName)
    if attempted and MasterySkillController then
        pcall(function() MasterySkillController:Tick(targetModel, tool) end)
    end
    return attempted
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
    "Kabucha","Venom Bow","Acidum Rifle","Bizarre Rifle","Skull Guitar","Soul Guitar",
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

-- v22.7 clean-room mastery target aim. Public RedZ uses a target vector plus a
-- global namecall hook; Bobon deliberately avoids the hook because it can rewrite
-- unrelated RemoteEvents. Instead we publish compatible aim state and, when safe,
-- move the virtual mouse to the target's on-screen projection before the skill key.
MasteryAimController = { LastTarget = nil, LastPosition = nil }

function MasteryAimController:Resolve(root)
    if _G.Settings.MasteryAimAdapterEnabled == false or not root or not root.Parent then return nil end
    local ok, pos, velocity = pcall(function()
        return root.Position, root.AssemblyLinearVelocity
    end)
    if not ok or not IsAllowedWorldPosition(pos) then return nil end
    local lead = math.max(0, math.min(0.12, tonumber(_G.Settings.MasteryAimLeadSeconds) or 0.035))
    local maxVelocity = math.max(0, tonumber(_G.Settings.MasteryAimMaxVelocity) or 120)
    if typeof(velocity) == "Vector3" and velocity.Magnitude > 0 and lead > 0 then
        if velocity.Magnitude > maxVelocity and maxVelocity > 0 then
            velocity = velocity.Unit * maxVelocity
        end
        pos = pos + velocity * lead
    end
    return pos
end

function MasteryAimController:Apply(target, root)
    local pos = self:Resolve(root)
    if not pos then return false end
    self.LastTarget = target
    self.LastPosition = pos

    -- Compatibility only; these values do not hook or rewrite arbitrary remotes.
    local env = (type(getgenv) == "function" and getgenv()) or _G
    pcall(function()
        env.AimbotPos = pos
        env.AimPos = CFrame.new(pos)
        _G.BobonAimPosition = pos
    end)

    if _G.Settings.MasteryAimMouseEnabled ~= false and VIM and workspace.CurrentCamera then
        local okView, point, visible = pcall(function()
            return workspace.CurrentCamera:WorldToViewportPoint(pos)
        end)
        if okView and point and visible and point.Z > 0 then
            pcall(function()
                VIM:SendMouseMoveEvent(point.X, point.Y, game)
            end)
        end
    end
    return true
end

-- v22.6/v22.7 bounded mastery skill rotation. It never owns movement and does not replace
-- melee fast-attack. Skills are only added when Bobon deliberately selected a mastery/
-- progression tool, preventing ordinary 1->max farming from spamming every key.
MasterySkillController = {
    LastCast = {},
    Cursor = {},
}

local MasterySkillMap = {
    Melee = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C},
    Sword = {Enum.KeyCode.Z, Enum.KeyCode.X},
    Gun = {Enum.KeyCode.Z, Enum.KeyCode.X},
    ["Blox Fruit"] = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V, Enum.KeyCode.F},
}

function MasterySkillController:ToolKind(tool)
    local kind = ToolCombatKind(tool)
    if kind then return kind end
    local tip = ""
    pcall(function() tip = string.lower(tostring(tool.ToolTip or "")) end)
    if tip:find("blox fruit", 1, true) or tip == "fruit" then return "Blox Fruit" end
    return nil
end

function MasterySkillController:ShouldRun(tool)
    if _G.Settings.MasterySkillRotationEnabled == false or not tool or tool.Parent ~= Char() then return false end
    local state = _G.State
    if not state or (state.Mode ~= "Farming" and state.Mode ~= "Bossing" and state.Mode ~= "GettingItem") then return false end
    local desired = MasteryPreferredTool()
    if not desired and type(state.PreferredCombatTool) == "string" and state.PreferredCombatTool ~= "" then
        desired = state.PreferredCombatTool
    end
    -- Only cast skills for the exact tool Bobon deliberately selected for mastery/progression.
    -- This keeps normal level-farm melee M1 behavior unchanged.
    return type(desired) == "string" and desired ~= "" and tool.Name == desired
end

function MasterySkillController:Tick(target, tool)
    if not self:ShouldRun(tool) or not target or not _G.State:IsTargetValid(target) then return false end
    local root = target:FindFirstChild("HumanoidRootPart")
    local me = HRP()
    if not root or not me then return false end
    local okPos, pos = pcall(function() return root.Position end)
    if not okPos or not IsAllowedWorldPosition(pos) then return false end
    if (pos - me.Position).Magnitude > (tonumber(_G.Settings.MasterySkillRange) or 75) then return false end

    local kind = self:ToolKind(tool)
    local keys = kind and MasterySkillMap[kind]
    if not keys or #keys == 0 then return false end

    -- v22.7 target-aware aim before each mastery skill. This is bounded to the
    -- current verified target and never changes movement/attack ownership.
    pcall(function() MasteryAimController:Apply(target, root) end)

    local name = tostring(tool.Name)
    local cursor = (tonumber(self.Cursor[name]) or 0) + 1
    if cursor > #keys then cursor = 1 end
    local key = keys[cursor]
    local stampKey = name .. ":" .. tostring(key.Value)
    local now = tick()
    local cooldown = math.max(0.25, tonumber(_G.Settings.MasterySkillCooldown) or 1.15)
    if now - (tonumber(self.LastCast[stampKey]) or 0) < cooldown then
        -- Move to another key next attack instead of hammering one cooldown.
        self.Cursor[name] = cursor
        return false
    end

    self.Cursor[name] = cursor
    self.LastCast[stampKey] = now
    local hold = math.max(0.02, math.min(0.20, tonumber(_G.Settings.MasterySkillKeyHold) or 0.045))
    pcall(function()
        VIM:SendKeyEvent(true, key, false, game)
        task.delay(hold, function()
            if SessionAlive() then pcall(function() VIM:SendKeyEvent(false, key, false, game) end) end
        end)
    end)
    return true
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
    if ClusterFarmController and ClusterFarmController.SharedMobName then
        pcall(function() ClusterFarmController:SharedRelease("ReleaseCluster") end)
    end
    -- If a not-yet-proven remote probe is visually staged at the anchor, undo
    -- only that temporary write before dropping the bookkeeping tables.
    local releaseState = _G.State
    local probeModel = releaseState and releaseState.ClusterAuthorityProbeTarget
    local probeRoot = probeModel and probeModel:FindFirstChild("HumanoidRootPart")
    local probeOriginal = probeRoot and GatherOriginalPositions[probeRoot]
    if probeRoot and probeRoot.Parent and probeOriginal and IsValidPos(probeOriginal)
        and not VerifiedGatherRoots[probeRoot] then
        pcall(function()
            local rot = probeRoot.CFrame.Rotation
            probeRoot.CFrame = CFrame.new(probeOriginal) * rot
        end)
    end

    GatherGeneration = GatherGeneration + 1
    VerifiedGatherRoots = setmetatable({}, { __mode = "k" })
    DamageProvenGatherRoots = setmetatable({}, { __mode = "k" })
    GatherAuthorityClass = setmetatable({}, { __mode = "k" })
    GatherProbeCandidates = setmetatable({}, { __mode = "k" })
    GatherProbeFailedUntil = setmetatable({}, { __mode = "k" })
    GatherProbeAttempts = setmetatable({}, { __mode = "k" })
    GatherOriginalPositions = setmetatable({}, { __mode = "k" })
    GatherVisualPinnedAt = setmetatable({}, { __mode = "k" })
    _G.BobonGatherDamageLeaseUntil = setmetatable({}, { __mode = "k" })
    _G.BobonGatherMoveTrial = setmetatable({}, { __mode = "k" })
    if ClusterFarmController then
        ClusterFarmController.LastBatch = {}
        ClusterFarmController.AcquireBlockedUntil = setmetatable({}, { __mode = "k" })
        ClusterFarmController.AcquireAttempts = setmetatable({}, { __mode = "k" })
        ClusterFarmController.PositionProof = setmetatable({}, { __mode = "k" })
        ClusterFarmController.RemotePullRetryAt = setmetatable({}, { __mode = "k" })
        ClusterFarmController.UnknownProof = setmetatable({}, { __mode = "k" })
        ClusterFarmController.VictimWatch = setmetatable({}, { __mode = "k" })
    end
    if _G.State then
        _G.State.ClusterMode = "OFF"
        _G.State.ClusterAnchor = nil
        _G.State.ClusterPileAnchor = nil
        _G.State.ClusterMobName = nil
        _G.State.ClusterMobNames = nil
        _G.State.ClusterPrimary = nil
        _G.State.ClusterGeneration = (_G.State.ClusterGeneration or 0) + 1
        _G.State.ClusterActivatedAt = 0
        _G.State.ClusterLastSeen = 0
        _G.State.ClusterLastMoved = 0
        _G.State.ClusterAcquireTarget = nil
        _G.State.ClusterAcquireStartedAt = 0
        _G.State.ClusterAcquireDeadline = 0
        _G.State.ClusterAcquireCompleted = 0
        _G.State.ClusterFixedAnchor = nil
        _G.State.ClusterPhase = "ACQUIRE"
        _G.State.ClusterPhaseStartedAt = 0
        _G.State.ClusterWaveStartedAt = 0
        _G.State.ClusterLastCandidateCount = 0
        _G.State.ClusterPhaseVerified = 0
        _G.State.ClusterPhaseTotal = 0
        _G.State.ClusterAuthorityProbeTarget = nil
        _G.State.ClusterAuthorityProbeStartedAt = 0
        _G.State.ClusterAuthorityProbeFirstAttackAt = 0
        _G.State.ClusterShadowCoverageCF = nil
        _G.State.ClusterShadowCoverageGround = nil
        _G.State.ClusterShadowCoverageSelectedAt = 0
        _G.State.ClusterShadowCoverageReachable = 0
        _G.State.ClusterShadowCoverageTotal = 0
        _G.State.ClusterShadowVisualAnchor = nil
    end
    _G.BobonDiagnostics.Bring = "OFF"
    _G.BobonDiagnostics.BringCandidates = 0
    _G.BobonDiagnostics.BringOwned = 0
    _G.BobonDiagnostics.BringDamageProven = 0
    _G.BobonDiagnostics.BringUnknown = 0
    _G.BobonDiagnostics.BringServerOwned = 0
    _G.BobonDiagnostics.BringProbe = 0
    _G.BobonDiagnostics.BringReachable = 0
    _G.BobonDiagnostics.BringVisual = 0
    _G.BobonDiagnostics.BringMoved = 0
end

local function ExpandSimulationRadius()
    local now = tick()
    if now - (FarmPositionController.LastSimulationTry or 0)
        < (_G.Settings.GatherSimulationRefresh or 0.08) then
        return FarmPositionController.SimulationReady == true
    end
    FarmPositionController.LastSimulationTry = now

    local requested = false
    local finiteRadius = math.max(
        tonumber(_G.Settings.ClusterSimulationRadius)
            or ((_G.Settings.GatherMaxDistance or 2000) + 1000),
        2500
    )

    -- Aggressive request: ask for the whole current farm field in one refresh.
    -- Every write remains protected because executor support differs.
    if type(setscriptable) == "function" then
        local ok = pcall(function()
            setscriptable(LP, "SimulationRadius", true)
            LP.SimulationRadius = finiteRadius
        end)
        requested = requested or ok
    end

    if type(sethiddenproperty) == "function" then
        local ok = pcall(function()
            sethiddenproperty(LP, "SimulationRadius", math.huge)
            pcall(function()
                sethiddenproperty(LP, "MaximumSimulationRadius", math.huge)
            end)
        end)
        if not ok then
            ok = pcall(function()
                sethiddenproperty(LP, "SimulationRadius", finiteRadius)
                pcall(function()
                    sethiddenproperty(LP, "MaximumSimulationRadius", finiteRadius)
                end)
            end)
        end
        requested = requested or ok
    end

    if type(setsimulationradius) == "function" then
        local ok = pcall(function()
            setsimulationradius(math.huge, math.huge)
        end)
        if not ok then
            ok = pcall(function() setsimulationradius(finiteRadius, finiteRadius) end)
        end
        requested = requested or ok
    end

    FarmPositionController.SimulationReady = requested
    return requested
end

ClientOwnsMob = function(root)
    -- true is the ONLY state allowed to move an NPC in v21.21.
    -- Try common executor aliases, but never invent/fallback to true.
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local ownerFn = nil
    for _, name in ipairs({
        "isnetworkowner", "is_network_owner", "isnetowner", "is_net_owner",
    }) do
        local candidate = type(env) == "table" and rawget(env, name) or nil
        if type(candidate) == "function" then ownerFn = candidate; break end
    end
    if not ownerFn and type(isnetworkowner) == "function" then
        ownerFn = isnetworkowner
    end
    if ownerFn then
        local ok, owned = pcall(ownerFn, root)
        if ok then
            _G.BobonDiagnostics.OwnerAPI = "EXECUTOR"
            return owned == true
        end
    end

    -- Roblox's GetNetworkOwner is normally server-only. If this environment exposes
    -- it, use the answer; otherwise return nil and keep the NPC at its real position.
    local ok, owner = pcall(function() return root:GetNetworkOwner() end)
    if ok and owner ~= nil then
        _G.BobonDiagnostics.OwnerAPI = "ENGINE"
        return owner == LP
    end
    -- Some executors expose the method but return nil on the client. Treat that as
    -- UNKNOWN, not an explicit server-owned=false result, so the physical sweep can
    -- use the damage-backed persistence fallback below.
    _G.BobonDiagnostics.OwnerAPI = ok and "ENGINE-NIL" or "NONE"
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
    LastBatch = {},
    LastBatchAt = 0,
    AcquireBlockedUntil = setmetatable({}, { __mode = "k" }),
    AcquireAttempts = setmetatable({}, { __mode = "k" }),
    -- v21.6: used only when the executor cannot report network ownership.
    -- Pending roots are moved once, then observed without rewriting until the
    -- server has had time to snap them back. Only roots that stay at the anchor
    -- become verified group targets.
    PositionProof = setmetatable({}, { __mode = "k" }),
    -- v21.13: bounded remote-pull retries; weak keys avoid retaining dead NPC roots.
    RemotePullRetryAt = setmetatable({}, { __mode = "k" }),
    UnknownProof = setmetatable({}, { __mode = "k" }),
    VictimWatch = setmetatable({}, { __mode = "k" }),
    PatrolIndex = 1,
    PatrolLastSwitch = 0,
    PatrolLastPoint = nil,
    SpawnMemory = {},
    SpawnMarkerCache = {},
    SpawnMarkerCacheAt = {},
    SpawnRouteIndex = {},
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
    local state = _G.State
    if not state or not model then return false end
    if state.ClusterMode == "RAID" then
        if IsRaidBossModel(model) then return false end
        local hum = model:FindFirstChildOfClass("Humanoid")
        local root = model:FindFirstChild("HumanoidRootPart")
        local anchor = state.ClusterAnchor
        if not hum or hum.Health <= 0 or not root or not anchor then return false end
        local ok, pos = pcall(function() return root.Position end)
        return ok and IsValidPos(pos) and IsAllowedWorldPosition(pos)
            and (pos - anchor.Position).Magnitude <= (_G.Settings.RaidGatherRadius or 700)
    end
    local names = state.ClusterMobNames
    if type(names) ~= "table" then return false end
    for _, wanted in ipairs(names) do
        if IsEnemyNamed(model, wanted) then return true end
    end
    return false
end

function ClusterFarmController:IsAttackCluster(mobName)
    if not _G.State or _G.State.ClusterMode == "OFF" then return false end
    if _G.State.ClusterMode == "RAID" then return _G.State.Mode == "Raiding" end
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
    elseif state.ClusterMode == "RAID" then
        return state.Mode == "Raiding" and state.ActiveActionToken ~= 0
            and state.ActionOwner == "Raid"
    elseif state.ClusterMode == "ITEM" then
        return state.Mode == "GettingItem" and state.ActiveActionToken ~= 0
            and state.ActionOwner == state.ClusterOwner
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
    local sameIdentity = state.ClusterMode == mode
        and state.ClusterMobName == list[1] and state.ClusterAnchor ~= nil
    local drift = state.ClusterAnchor and (state.ClusterAnchor.Position - cf.Position).Magnitude or math.huge
    local changed = not sameIdentity

    -- QUEST keeps one pile for the whole active quest. Only relocate a same-name
    -- quest when the old field has been empty long enough AND the new anchor is
    -- clearly another island/field. RAID/SKIP/ITEM may move their anchor normally.
    if sameIdentity then
        if mode == "QUEST" and _G.Settings.ClusterFixedPile ~= false then
            local stale = tick() - (state.ClusterLastSeen or 0) > 1.50
            if drift > (_G.Settings.ClusterFixedAnchorRelocateDistance or 650) and stale then
                changed = true
            end
        elseif drift > (_G.Settings.ClusterAnchorMaxDrift or 18) then
            changed = true
        end
    end

    if changed then
        GatherGeneration = GatherGeneration + 1
        VerifiedGatherRoots = setmetatable({}, { __mode = "k" })
        DamageProvenGatherRoots = setmetatable({}, { __mode = "k" })
        GatherAuthorityClass = setmetatable({}, { __mode = "k" })
        GatherProbeCandidates = setmetatable({}, { __mode = "k" })
        GatherProbeFailedUntil = setmetatable({}, { __mode = "k" })
        GatherProbeAttempts = setmetatable({}, { __mode = "k" })
        GatherOriginalPositions = setmetatable({}, { __mode = "k" })
        GatherVisualPinnedAt = setmetatable({}, { __mode = "k" })
        _G.BobonGatherDamageLeaseUntil = setmetatable({}, { __mode = "k" })
        _G.BobonGatherMoveTrial = setmetatable({}, { __mode = "k" })
        self.AcquireBlockedUntil = setmetatable({}, { __mode = "k" })
        self.AcquireAttempts = setmetatable({}, { __mode = "k" })
        self.PositionProof = setmetatable({}, { __mode = "k" })
        self.RemotePullRetryAt = setmetatable({}, { __mode = "k" })
        self.UnknownProof = setmetatable({}, { __mode = "k" })
        self.VictimWatch = setmetatable({}, { __mode = "k" })
        self.PatrolIndex = 1
        self.PatrolLastSwitch = 0
        self.PatrolLastPoint = nil
        if self.SpawnRouteIndex then
            self.SpawnRouteIndex[string.lower(tostring(list[1] or ""))] = 1
        end
        state.ClusterGeneration = (state.ClusterGeneration or 0) + 1
        state.ClusterActivatedAt = tick()
        state.ClusterPrimary = nil
        state.ClusterAcquireTarget = nil
        state.ClusterAcquireStartedAt = 0
        state.ClusterAcquireDeadline = 0
        state.ClusterAcquireCompleted = 0
        state.ClusterFixedAnchor = CFrame.new(cf.Position)
        state.ClusterPhase = "ACQUIRE"
        state.ClusterPhaseStartedAt = tick()
        state.ClusterWaveStartedAt = tick()
        state.ClusterLastCandidateCount = 0
        state.ClusterPhaseVerified = 0
        state.ClusterPhaseTotal = 0
        state.ClusterPileAnchor = nil
        state.ClusterAuthorityProbeTarget = nil
        state.ClusterAuthorityProbeStartedAt = 0
        state.ClusterAuthorityProbeFirstAttackAt = 0
        state.ClusterShadowCoverageCF = nil
        state.ClusterShadowCoverageGround = nil
        state.ClusterShadowCoverageSelectedAt = 0
        state.ClusterShadowCoverageReachable = 0
        state.ClusterShadowCoverageTotal = 0
        state.ClusterShadowVisualAnchor = nil
        DLog("CLUSTER", "Activate " .. tostring(mode) .. " / " .. tostring(list[1]))
    end

    state.ClusterMode = mode
    if changed or _G.Settings.ClusterFixedPile == false or not state.ClusterAnchor then
        state.ClusterAnchor = CFrame.new(cf.Position)
    end
    if not state.ClusterFixedAnchor then state.ClusterFixedAnchor = CFrame.new(state.ClusterAnchor.Position) end
    state.ClusterMobNames = list
    state.ClusterMobName = list[1]
    state.ClusterOwner = owner or "Farm"
    return true
end

function ClusterFarmController:GetPileAnchorPosition()
    local state = _G.State
    local baseCF = state and (state.ClusterFixedAnchor or state.ClusterAnchor)
    if not baseCF then return nil end
    local base = baseCF.Position

    -- v21.34: the pile is fixed for the active QUEST/wave. Player acquisition
    -- travel no longer drags already gathered NPCs around the field.
    local stable = Vector3.new(base.X + (_G.Settings.FarmOffsetX or 0), base.Y, base.Z)
    state.ClusterPileAnchor = CFrame.new(stable)
    return stable
end

function ClusterFarmController:GetHoverCFrame(height)
    local anchor = _G.State and (_G.State.ClusterFixedAnchor or _G.State.ClusterAnchor)
    if not anchor then return nil end
    local p = anchor.Position
    local h = height or _G.Settings.FarmHeight or 15
    if FarmSafetyActive() then
        h = math.max(h, _G.Settings.EmergencyHoverHeight or 28)
    end
    local y = math.max(p.Y + h,
        IsSubmergedPosition(p) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY)
    return CFrame.new(p.X + (_G.Settings.FarmOffsetX or 0), y, p.Z)
end

function ClusterFarmController:IsDamageProven(model)
    if not model or not self:IsModelAllowed(model) then return false end
    local root = model:FindFirstChild("HumanoidRootPart")
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false end
    local at = DamageProvenGatherRoots[root]
    if not at then return false end
    if tick() - at > (_G.Settings.ClusterAuthorityDamageTTL or 1.50) then
        DamageProvenGatherRoots[root] = nil
        if GatherAuthorityClass[root] == "DAMAGE"
            or GatherAuthorityClass[root] == "DAMAGE-LEASE" then
            GatherAuthorityClass[root] = nil
            _G.BobonGatherDamageLeaseUntil[root] = nil
            _G.BobonGatherMoveTrial[root] = nil
            VerifiedGatherRoots[root] = nil
        end
        return false
    end
    return true
end

function ClusterFarmController:IsVerified(model)
    if not model or not self:IsModelAllowed(model) then return false end
    local root = model:FindFirstChild("HumanoidRootPart")
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false end

    local authority = GatherAuthorityClass[root]
    if authority == "OWNED" then
        if ClientOwnsMob(root) ~= true then
            GatherAuthorityClass[root] = nil
            VerifiedGatherRoots[root] = nil
            return false
        end
    elseif authority == "PERSIST" then
        -- v21.36: a proximity persistence proof can stay valid even if an
        -- executor owner API keeps returning false. Position + HP liveness
        -- become authoritative after the one-write/no-rewrite proof.
        if ClientOwnsMob(root) == false
            and _G.Settings.ClusterProbeExplicitFalseOwner ~= true then
            GatherAuthorityClass[root] = nil
            VerifiedGatherRoots[root] = nil
            self.PositionProof[root] = nil
            return false
        end
    elseif authority == "DAMAGE-LEASE" then
        if (_G.BobonGatherDamageLeaseUntil[root] or 0) <= tick()
            or not self:IsDamageProven(model) then
            GatherAuthorityClass[root] = nil
            _G.BobonGatherDamageLeaseUntil[root] = nil
            VerifiedGatherRoots[root] = nil
            return false
        end
    else
        return false
    end

    local at = VerifiedGatherRoots[root]
    if at == nil or tick() - at > (_G.Settings.GatherVerifiedTTL or 2.5) then
        return false
    end
    local pilePos = self:GetPileAnchorPosition()
    local ok, pos = pcall(function() return root.Position end)
    if not pilePos or not ok or not IsValidPos(pos)
        or (pos - pilePos).Magnitude > (_G.Settings.ClusterAnchorVerifyRadius or 9) then
        VerifiedGatherRoots[root] = nil
        GatherAuthorityClass[root] = nil
        return false
    end
    return true
end

function ClusterFarmController:IsProbeCandidate(model)
    -- v21.19 normal QUEST no longer serializes the whole field through one
    -- fake-position HP probe. SKIP/ITEM/RAID may still use the legacy probe path.
    if self:IsShadowCombatActive() then return false end
    if _G.Settings.ClusterAuthorityEnabled == false then return false end
    if not model or not self:IsModelAllowed(model) or self:IsVerified(model) then return false end
    local root = model:FindFirstChild("HumanoidRootPart")
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false end
    if (GatherProbeFailedUntil[root] or 0) > tick() then return false end
    return GatherProbeCandidates[root] == true
end

function ClusterFarmController:IsShadowCombatActive()
    local state = _G.State
    return _G.Settings.ClusterShadowCombatEnabled ~= false
        and state ~= nil and state.Mode == "Farming"
        and state.ClusterMode == "QUEST"
        and state.ActiveQuestMob ~= nil
end

function ClusterFarmController:GetServerShadowPosition(model)
    if not model then return nil end
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local shadow = GatherOriginalPositions[root]
    if shadow and IsValidPos(shadow) then return shadow end
    local ok, pos = pcall(function() return root.Position end)
    if ok and IsValidPos(pos) then
        GatherOriginalPositions[root] = pos
        return pos
    end
    return nil
end

function ClusterFarmController:IsShadowAttackEligible(model, maxRange)
    if not self:IsShadowCombatActive() or not model or not self:IsModelAllowed(model) then
        return false
    end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")
    local me = HRP()
    if not hum or hum.Health <= 0 or not root or not root.Parent or not me then return false end
    local shadow = self:GetServerShadowPosition(model)
    if not shadow then return false end
    local range = tonumber(maxRange)
        or tonumber(_G.Settings.ClusterShadowAttackRange)
        or tonumber(_G.Settings.FastAttackRange)
        or 100
    range = range + (tonumber(_G.Settings.ClusterShadowRangeSlack) or 0)
    return (shadow - me.Position).Magnitude <= range
end

function ClusterFarmController:GetShadowReachableCount(maxRange)
    if not self:IsShadowCombatActive() then return 0 end
    local count = 0
    for _, entry in ipairs(self.LastBatch or {}) do
        if entry.Model and self:IsShadowAttackEligible(entry.Model, maxRange) then
            count = count + 1
        end
    end
    return count
end

-- v21.19 FIELD-COVERAGE PLANNER.  If every real/server-shadow spawn point fits
-- inside one 100-stud combat circle this returns the stable cluster center. If the
-- field is wider, it chooses a center covering the most stale/unproven mobs and
-- changes centers only after a short hold.  This is field-level movement, not a
-- per-NPC ownership tour.
function ClusterFarmController:GetShadowCoverageHoverCFrame(height)
    if not self:IsShadowCombatActive() or _G.Settings.ClusterShadowCoverageEnabled == false then
        return self:GetHoverCFrame(height)
    end
    local state = _G.State
    local baseAnchor = state and state.ClusterAnchor
    if not state or not baseAnchor then return self:GetHoverCFrame(height) end

    local rows = {}
    for _, entry in ipairs(self.LastBatch or {}) do
        local model, root, hum = entry.Model, entry.Root, entry.Humanoid
        if model and model.Parent and root and root.Parent and hum and hum.Health > 0
            and self:IsModelAllowed(model) then
            local shadow = self:GetServerShadowPosition(model)
            if shadow and IsValidPos(shadow) then
                rows[#rows + 1] = {Model=model, Root=root, Position=shadow}
            end
        end
    end
    if #rows == 0 then return self:GetHoverCFrame(height) end

    local h = height or _G.Settings.FarmHeight or 22
    if FarmSafetyActive() then h = math.max(h, _G.Settings.EmergencyHoverHeight or 28) end
    local offsetX = _G.Settings.FarmOffsetX or 0
    local range = tonumber(_G.Settings.ClusterShadowAttackRange)
        or tonumber(_G.Settings.FastAttackRange) or 100
    range = math.max(20, range - math.max(0, tonumber(_G.Settings.ClusterShadowCoverageSafety) or 2))
    local freshWindow = math.max(0.15, tonumber(_G.Settings.ClusterShadowCoverageFresh) or 0.55)
    local now = tick()

    local candidates, seen = {}, {}
    local function addGround(p)
        if not p or not IsValidPos(p) then return end
        local key = string.format("%.1f:%.1f:%.1f", p.X, p.Y, p.Z)
        if seen[key] then return end
        seen[key] = true
        candidates[#candidates + 1] = p
    end

    addGround(baseAnchor.Position)
    local sum = Vector3.zero
    local minX, maxX = math.huge, -math.huge
    local minY, maxY = math.huge, -math.huge
    local minZ, maxZ = math.huge, -math.huge
    for _, row in ipairs(rows) do
        local p = row.Position
        sum = sum + p
        minX, maxX = math.min(minX,p.X), math.max(maxX,p.X)
        minY, maxY = math.min(minY,p.Y), math.max(maxY,p.Y)
        minZ, maxZ = math.min(minZ,p.Z), math.max(maxZ,p.Z)
        addGround(p)
    end
    addGround(sum / #rows)
    addGround(Vector3.new((minX+maxX)*0.5, (minY+maxY)*0.5, (minZ+maxZ)*0.5))
    -- Pair midpoints are cheap for normal 3-8 mob quest fields and often produce
    -- a better two-zone cover than parking directly on either NPC.
    local pairLimit = math.min(#rows, 12)
    for i = 1, pairLimit do
        for j = i + 1, pairLimit do
            addGround((rows[i].Position + rows[j].Position) * 0.5)
        end
    end

    local function hoverFromGround(g)
        local y = math.max(g.Y + h,
            IsSubmergedPosition(g) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY)
        return Vector3.new(g.X + offsetX, y, g.Z)
    end

    local function evaluate(g)
        local hover = hoverFromGround(g)
        local reachable, stale, totalDist, maxDist = 0, 0, 0, 0
        for _, row in ipairs(rows) do
            local d = (row.Position - hover).Magnitude
            if d <= range then
                reachable = reachable + 1
                totalDist = totalDist + d
                maxDist = math.max(maxDist, d)
                local proofAt = DamageProvenGatherRoots[row.Root]
                if not proofAt or now - proofAt > freshWindow then stale = stale + 1 end
            end
        end
        local avg = reachable > 0 and totalDist / reachable or math.huge
        return reachable, stale, avg, maxDist, hover
    end

    -- Hold the current FIELD center briefly while it is still useful. This prevents
    -- 0.15s main-loop oscillation between two equally-good coverage circles.
    local currentGround = state.ClusterShadowCoverageGround
    local selectedAt = tonumber(state.ClusterShadowCoverageSelectedAt) or 0
    local hold = math.max(0.25, tonumber(_G.Settings.ClusterShadowCoverageHold) or 0.70)
    if currentGround and IsValidPos(currentGround) and now - selectedAt < hold then
        local r, st, _, _, hover = evaluate(currentGround)
        if r > 0 and (st > 0 or r == #rows) then
            state.ClusterShadowCoverageReachable = r
            state.ClusterShadowCoverageTotal = #rows
            state.ClusterShadowCoverageCF = CFrame.new(hover)
            state.ClusterShadowVisualAnchor = Vector3.new(currentGround.X, currentGround.Y, currentGround.Z)
            return state.ClusterShadowCoverageCF
        end
    end

    local bestGround, bestHover
    local bestStale, bestReach, bestAvg, bestMax = -1, -1, math.huge, math.huge
    for _, g in ipairs(candidates) do
        local reach, stale, avg, maxDist, hover = evaluate(g)
        if stale > bestStale
            or (stale == bestStale and reach > bestReach)
            or (stale == bestStale and reach == bestReach and avg < bestAvg - 0.01)
            or (stale == bestStale and reach == bestReach
                and math.abs(avg-bestAvg) <= 0.01 and maxDist < bestMax) then
            bestGround, bestHover = g, hover
            bestStale, bestReach, bestAvg, bestMax = stale, reach, avg, maxDist
        end
    end

    if bestGround and bestHover then
        local changed = not currentGround or (currentGround - bestGround).Magnitude > 2.0
        if changed then state.ClusterShadowCoverageSelectedAt = now end
        state.ClusterShadowCoverageGround = bestGround
        state.ClusterShadowCoverageCF = CFrame.new(bestHover)
        state.ClusterShadowCoverageReachable = bestReach
        state.ClusterShadowCoverageTotal = #rows
        state.ClusterShadowVisualAnchor = bestGround
        return state.ClusterShadowCoverageCF
    end
    return self:GetHoverCFrame(height)
end

function ClusterFarmController:IsAttackEligible(model)
    return self:IsVerified(model) or self:IsProbeCandidate(model)
        or self:IsShadowAttackEligible(model)
end

function ClusterFarmController:ConfirmDamageProof(model)
    if not model or not self:IsModelAllowed(model) then return false end
    local root = model:FindFirstChild("HumanoidRootPart")
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false end

    local now = tick()
    DamageProvenGatherRoots[root] = now
    -- v22.5 Shared farm also consumes exact per-model aggregate HP proof. This is
    -- intentionally separate from legacy ClusterMode authority so ReferenceCoreMode
    -- can stay combat-first without trusting a purely visual CFrame persistence test.
    if _G.Settings.SharedSourceFarmMode ~= false and _G.State
        and _G.State.Mode == "Farming"
        and (_G.State.FState == "SHARED_ATTACK" or _G.State.FState == "SHARED_BRING_FARM") then
        self.SharedHPProvenUntil = self.SharedHPProvenUntil or setmetatable({}, {__mode="k"})
        self.SharedHPProvenAt = self.SharedHPProvenAt or setmetatable({}, {__mode="k"})
        self.SharedProbeState = self.SharedProbeState or setmetatable({}, {__mode="k"})
        self.SharedHPProvenAt[root] = now
        self.SharedHPProvenUntil[root] = now + math.max(0.35, tonumber(_G.Settings.SharedHPProofTTL) or 1.25)
        self.SharedProbeState[root] = nil
    end
    GatherProbeCandidates[root] = nil
    GatherProbeFailedUntil[root] = nil
    GatherProbeAttempts[root] = 0

    local state = _G.State
    if state and state.ClusterAuthorityProbeTarget == model then
        state.ClusterAuthorityProbeTarget = nil
        state.ClusterAuthorityProbeStartedAt = 0
        state.ClusterAuthorityProbeFirstAttackAt = 0
    end

    if GatherAuthorityClass[root] == "DAMAGE-LEASE"
        and (_G.BobonGatherDamageLeaseUntil[root] or 0) > now then
        _G.BobonGatherDamageLeaseUntil[root] = now
            + (tonumber(_G.Settings.ClusterDamageLeaseTTL) or 1.80)
        VerifiedGatherRoots[root] = now
    end

    local own = ClientOwnsMob(root)
    if own == true then
        local pile = self:GetPileAnchorPosition()
            or (state and state.ClusterAnchor and state.ClusterAnchor.Position)
        if pile then
            local ok = pcall(function()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.CFrame = CFrame.new(pile)
            end)
            if ok then
                GatherAuthorityClass[root] = "OWNED"
                _G.BobonGatherDamageLeaseUntil[root] = nil
                _G.BobonGatherMoveTrial[root] = nil
                VerifiedGatherRoots[root] = now
                return true
            end
        end
        return true
    end

    -- v21.36 damage-first recovery. The HP delta happened at the mob's real
    -- replicated position, so the victim is definitely server-live. Try the SAME
    -- one-write/no-rewrite persistence proof used by ACQUIRE instead of the old
    -- orphan DAMAGE-TRIAL table (which v21.34 RestackBatch no longer consumed).
    if (own == nil
            or (own == false and _G.Settings.ClusterProbeExplicitFalseOwner == true))
        and _G.Settings.ClusterDamageLeaseEnabled ~= false
        and state and (state.ClusterMode == "QUEST" or state.ClusterMode == "SKIP") then
        local me = HRP()
        local okPos, pos = pcall(function() return root.Position end)
        local acquireRadius = tonumber(_G.Settings.ClusterDamageLeaseAcquireRadius) or 18
        if me and okPos and IsValidPos(pos)
            and (pos - me.Position).Magnitude <= acquireRadius then
            local pile = self:GetPileAnchorPosition()
                or (state.ClusterAnchor and state.ClusterAnchor.Position)
            if pile and not self.UnknownProof[root] then
                local okMove = pcall(function()
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.CFrame = CFrame.new(pile)
                end)
                if okMove then
                    self.UnknownProof[root] = {
                        Anchor = pile,
                        StartedAt = now,
                        Checks = 0,
                        Original = GatherOriginalPositions[root] or pos,
                        DamageBacked = true,
                    }
                    _G.BobonGatherMoveTrial[root] = nil
                    GatherAuthorityClass[root] = nil
                    VerifiedGatherRoots[root] = nil
                end
            end
        end
    end
    return true
end

function ClusterFarmController:RejectDamageProbe(model)
    if not model then return end
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    GatherProbeCandidates[root] = nil
    GatherProbeAttempts[root] = (GatherProbeAttempts[root] or 0) + 1
    GatherProbeFailedUntil[root] = tick()
        + (tonumber(_G.Settings.ClusterAuthorityProbeMissCooldown) or 1.60)

    -- v21.21 never staged an unowned NPC, so there is nothing to "restore".
    -- Writing an old cached CFrame here would itself recreate the ghost/statue bug.
    local state = _G.State
    if state and state.ClusterAuthorityProbeTarget == model then
        state.ClusterAuthorityProbeTarget = nil
        state.ClusterAuthorityProbeStartedAt = 0
        state.ClusterAuthorityProbeFirstAttackAt = 0
    end
end

function ClusterFarmController:GetProbeCount()
    local n = 0
    for _, entry in ipairs(self.LastBatch or {}) do
        if entry.Model and self:IsProbeCandidate(entry.Model) then n = n + 1 end
    end
    return n
end

function ClusterFarmController:GetVerifiedCount()
    local count = 0
    for _, entry in ipairs(self.LastBatch or {}) do
        if entry.Model and self:IsVerified(entry.Model) then count = count + 1 end
    end
    return count
end

-- Visit each provably server-owned quest mob once so Roblox can transfer its
-- physics ownership to this client. RestackBatch performs the actual move only
-- after ClientOwnsMob becomes true. Unknown ownership is never treated as safe.
function ClusterFarmController:GetAcquireTarget()
    local state = _G.State
    local mode = state and state.ClusterMode
    local supported = mode == "QUEST" or mode == "SKIP" or mode == "RAID"
    if not state or not supported or _G.Settings.ClusterAcquireSweep == false
        or not self:PolicyValid() then
        if state then
            state.ClusterAcquireTarget = nil
            state.ClusterAcquireStartedAt = 0
            state.ClusterAcquireDeadline = 0
        end
        return nil
    end

    if _G.Settings.ClusterAcquireBeforeAttack ~= false and state.ClusterPhase == "KILL" then
        state.ClusterAcquireTarget = nil
        state.ClusterAcquireStartedAt = 0
        state.ClusterAcquireDeadline = 0
        return nil
    end
    if mode == "QUEST" and _G.Settings.ClusterQuestPhysicalFallback ~= true then return nil end
    if mode == "SKIP" and _G.Settings.ClusterSkipPhysicalFallback == false then return nil end

    local now = tick()
    local current = state.ClusterAcquireTarget
    if current and current.Parent and self:IsModelAllowed(current)
        and not self:IsVerified(current) then
        if now <= (state.ClusterAcquireDeadline or 0) then return current end
        local attempts = (self.AcquireAttempts[current] or 0) + 1
        self.AcquireAttempts[current] = attempts
        local retryAfter = attempts >= (_G.Settings.ClusterAcquireMaxAttempts or 3)
            and (_G.Settings.ClusterAcquireCycleRetry or 0.75)
            or (_G.Settings.ClusterAcquireRetry or 0.06)
        self.AcquireBlockedUntil[current] = now + retryAfter
    elseif current and self:IsVerified(current) then
        self.AcquireAttempts[current] = nil
        state.ClusterAcquireCompleted = (state.ClusterAcquireCompleted or 0) + 1
    end
    state.ClusterAcquireTarget = nil
    state.ClusterAcquireStartedAt = 0
    state.ClusterAcquireDeadline = 0

    local me = HRP()
    local acquirePool = {}
    for _, entry in ipairs(self.LastBatch or {}) do
        local model, root = entry.Model, entry.Root
        if model and root and root.Parent and self:IsModelAllowed(model)
            and not self:IsVerified(model)
            and (self.AcquireBlockedUntil[model] or 0) <= now
            and ClientOwnsMob(root) ~= true then
            local ok, livePos = pcall(function() return root.Position end)
            local pos = entry.Position or GatherOriginalPositions[root] or (ok and livePos or nil)
            if pos and IsValidPos(pos) then
                acquirePool[#acquirePool + 1] = {
                    Model=model, Root=root, Position=pos,
                    PlayerDistance=me and (pos-me.Position).Magnitude or 0,
                }
            end
        end
    end

    local best, bestDist, bestCoverage = nil, nil, -1
    local groupRadius = math.max(25, tonumber(_G.Settings.ClusterAcquireGroupRadius) or 240)
    for _, row in ipairs(acquirePool) do
        local coverage = 1
        if _G.Settings.ClusterAcquirePreferCoverage ~= false then
            coverage = 0
            for _, other in ipairs(acquirePool) do
                if (other.Position-row.Position).Magnitude <= groupRadius then coverage = coverage + 1 end
            end
        end
        if coverage > bestCoverage or (coverage == bestCoverage
            and (bestDist == nil or row.PlayerDistance < bestDist)) then
            best, bestDist, bestCoverage = row.Model, row.PlayerDistance, coverage
        end
    end

    if best then
        state.ClusterAcquireTarget = best
        state.ClusterAcquireStartedAt = now
        local eta = (bestDist or 0) / math.max(1,
            _G.Settings.ClusterAcquireTravelSpeed or _G.Settings.FlySpeed or 180)
        state.ClusterAcquireDeadline = now + math.clamp(
            eta + (_G.Settings.ClusterAcquireSettle or 0.20),
            _G.Settings.ClusterAcquireTimeout or 0.75,
            _G.Settings.ClusterAcquireMaxTimeout or 1.80)
    end
    return best
end

-- v21.34 explicit farm phases. A new live mob reopens ACQUIRE. We gather for a
-- bounded budget so one permanently server-owned NPC cannot freeze the whole kaitun.
function ClusterFarmController:UpdatePhase()
    local state = _G.State
    if not state or not self:PolicyValid() then return "OFF",0,0 end
    local now = tick()
    local total, verified = 0, 0
    for _, entry in ipairs(self.LastBatch or {}) do
        local model = entry.Model
        local hum = model and model:FindFirstChildOfClass("Humanoid")
        if model and hum and hum.Health > 0 and self:IsModelAllowed(model) then
            total = total + 1
            if self:IsVerified(model) then verified = verified + 1 end
        end
    end

    local previous = tonumber(state.ClusterLastCandidateCount) or 0
    if _G.Settings.ClusterWaveNewMobPreempt ~= false and total > previous then
        -- v21.36: streaming another mob must NOT restart an ACQUIRE that
        -- is already running. That reset caused the video-7837 infinite circle.
        if state.ClusterPhase == "KILL" then
            state.ClusterPhase = "ACQUIRE"
            state.ClusterPhaseStartedAt = now
            state.ClusterWaveStartedAt = now
        elseif state.ClusterPhaseStartedAt == nil or state.ClusterPhaseStartedAt <= 0 then
            state.ClusterPhaseStartedAt = now
            state.ClusterWaveStartedAt = now
        end
    end
    state.ClusterLastCandidateCount = total
    state.ClusterPhaseVerified = verified
    state.ClusterPhaseTotal = total

    if total <= 0 then
        state.ClusterPhase = "ACQUIRE"
        state.ClusterPhaseStartedAt = state.ClusterPhaseStartedAt > 0 and state.ClusterPhaseStartedAt or now
        return state.ClusterPhase, verified, total
    end

    if verified >= total then
        if state.ClusterPhase ~= "KILL" then
            state.ClusterPhase = "KILL"
            state.ClusterPhaseStartedAt = now
        end
    elseif state.ClusterPhase ~= "ACQUIRE" and state.ClusterPhase ~= "KILL" then
        state.ClusterPhase = "ACQUIRE"
        state.ClusterPhaseStartedAt = now
    elseif state.ClusterPhase == "ACQUIRE" then
        local acquireEpoch = tonumber(state.ClusterWaveStartedAt) or 0
        if acquireEpoch <= 0 then
            acquireEpoch = tonumber(state.ClusterPhaseStartedAt) or now
            state.ClusterWaveStartedAt = acquireEpoch
        end
        local acquireBudget = state.ClusterMode == "SKIP"
            and (_G.Settings.SkipAcquirePhaseBudget or 5.50)
            or (_G.Settings.ClusterAcquirePhaseBudget or 4.0)
        if now - acquireEpoch >= acquireBudget then
            state.ClusterPhase = "KILL"
            state.ClusterPhaseStartedAt = now
        end
    elseif state.ClusterPhase == "KILL" then
        local killSlice
        if verified <= 0 then
            killSlice = _G.Settings.ClusterUnstackedKillSlice or 3.25
        elseif state.ClusterMode == "SKIP" then
            killSlice = _G.Settings.SkipKillPhaseSlice or 2.20
        else
            killSlice = _G.Settings.ClusterKillPhaseSlice or 1.15
        end
        if verified < total and now - (state.ClusterPhaseStartedAt or now)
            >= killSlice then
            state.ClusterPhase = "ACQUIRE"
            state.ClusterPhaseStartedAt = now
            state.ClusterWaveStartedAt = now
        end
    end
    return state.ClusterPhase, verified, total
end

-- PERSIST is only an executor fallback. If the visual stack survives but that exact
-- Humanoid never loses real HP while we are parked over the pile, revoke the local
-- pin, restore its original position, and reacquire instead of leaving a statue.
function ClusterFarmController:AuditVictimLiveness()
    local state = _G.State
    if not state or state.ClusterPhase ~= "KILL" or not self:PolicyValid() then return 0 end
    if not TravelManager or not TravelManager:IsAtCombatAnchor() then return 0 end
    local now, revoked = tick(), 0
    local timeout = math.max(0.6, tonumber(_G.Settings.ClusterPersistNoDamageTimeout) or 1.35)

    for _, entry in ipairs(self.LastBatch or {}) do
        local model, root, hum = entry.Model, entry.Root, entry.Humanoid
        if model and root and hum and hum.Health > 0 and self:IsVerified(model) then
            local watch = self.VictimWatch[model]
            if not watch then
                watch = {Health=hum.Health, LastDamage=now, SeenAt=now}
                self.VictimWatch[model] = watch
            else
                local current = tonumber(hum.Health) or 0
                if current < (tonumber(watch.Health) or current) - 0.01 then
                    watch.LastDamage = now
                    pcall(function() self:ConfirmDamageProof(model) end)
                elseif current > (tonumber(watch.Health) or current) + 0.01 then
                    watch.LastDamage = now
                end
                watch.Health = current
            end

            if GatherAuthorityClass[root] == "PERSIST"
                and now - math.max(watch.LastDamage or now, watch.SeenAt or now) >= timeout then
                VerifiedGatherRoots[root] = nil
                DamageProvenGatherRoots[root] = nil
                GatherAuthorityClass[root] = nil
                self.UnknownProof[root] = nil
                self.PositionProof[root] = nil
                self.VictimWatch[model] = nil
                self.AcquireBlockedUntil[model] = now + math.max(
                    _G.Settings.ClusterPersistReacquireCooldown or 0.55,
                    _G.Settings.ClusterFalseOwnerProofCooldown or 2.50)
                local original = GatherOriginalPositions[root]
                if original and IsValidPos(original) then
                    pcall(function()
                        local rot = root.CFrame.Rotation
                        root.CFrame = CFrame.new(original) * rot
                    end)
                end
                -- v21.37: revoke only this ghost. Do NOT reset the entire wave
                -- here; UpdatePhase will schedule the next ACQUIRE after the current
                -- KILL slice, allowing healthy victims to keep taking damage.
                if state.ClusterPrimary == model then state.ClusterPrimary = nil end
                if state.FarmTarget == model then state.FarmTarget = nil end
                if state.CurrentTarget == model then state.CurrentTarget = nil end
                revoked = revoked + 1
            end
        end
    end
    return revoked
end

-- v21.33 ACTIVE FIELD SWEEP. No verified target no longer means park forever.
-- Prefer a real live quest root; if none is currently streamed, patrol a compact
-- ring around the active quest field until the next wave becomes visible.
function ClusterFarmController:RememberSpawnPoint(mobName, pos)
    if type(mobName) ~= "string" or typeof(pos) ~= "Vector3" or not IsAllowedWorldPosition(pos) then return end
    local key = string.lower(mobName)
    self.SpawnMemory = self.SpawnMemory or {}
    local list = self.SpawnMemory[key]
    if type(list) ~= "table" then list = {}; self.SpawnMemory[key] = list end
    local merge = math.max(6, tonumber(_G.Settings.ClusterSpawnMemoryMerge) or 18)
    for _, oldPos in ipairs(list) do
        if typeof(oldPos) == "Vector3" and (oldPos - pos).Magnitude <= merge then return end
    end
    list[#list + 1] = pos
    local limit = math.max(4, math.floor(tonumber(_G.Settings.ClusterSpawnMemoryLimit) or 24))
    while #list > limit do table.remove(list, 1) end
end

function ClusterFarmController:GetSpawnSweepPoints(fallbackCF)
    local state = _G.State
    if not state or state.ClusterMode ~= "QUEST" then return {} end
    local mobName = tostring(state.ClusterMobName or "")
    if mobName == "" then return {} end
    local key = string.lower(mobName)
    local now = tick()
    self.SpawnMarkerCache = self.SpawnMarkerCache or {}
    self.SpawnMarkerCacheAt = self.SpawnMarkerCacheAt or {}
    local points = self.SpawnMarkerCache[key]
    if type(points) ~= "table"
        or now - (tonumber(self.SpawnMarkerCacheAt[key]) or 0)
            >= (_G.Settings.ClusterSpawnMarkerRefresh or 2.0) then
        points = {}
        local origin = workspace:FindFirstChild("_WorldOrigin")
        local spawns = origin and origin:FindFirstChild("EnemySpawns")
        if spawns then
            for _, marker in ipairs(spawns:GetChildren()) do
                local markerName = string.lower(tostring(marker.Name or ""))
                if string.find(markerName, key, 1, true) then
                    local pos
                    if marker:IsA("BasePart") then
                        pos = marker.Position
                    elseif marker:IsA("Model") then
                        local part = marker:FindFirstChild("HumanoidRootPart")
                            or marker.PrimaryPart
                            or marker:FindFirstChildWhichIsA("BasePart", true)
                        if part then pos = part.Position else pcall(function() pos = marker:GetPivot().Position end) end
                    end
                    if typeof(pos) == "Vector3" and IsAllowedWorldPosition(pos) then
                        local duplicate = false
                        for _, existing in ipairs(points) do
                            if (existing - pos).Magnitude <= (_G.Settings.ClusterSpawnMemoryMerge or 18) then
                                duplicate = true
                                break
                            end
                        end
                        if not duplicate then
                            points[#points + 1] = pos
                            self:RememberSpawnPoint(mobName, pos)
                        end
                    end
                end
            end
        end
        self.SpawnMarkerCache[key] = points
        self.SpawnMarkerCacheAt[key] = now
    end
    if #points == 0 then
        local memory = self.SpawnMemory and self.SpawnMemory[key]
        if type(memory) == "table" then
            for _, pos in ipairs(memory) do
                if typeof(pos) == "Vector3" and IsAllowedWorldPosition(pos) then points[#points + 1] = pos end
            end
        end
    end
    if #points == 0 and fallbackCF then
        local p = typeof(fallbackCF) == "CFrame" and fallbackCF.Position or fallbackCF
        if typeof(p) == "Vector3" and IsAllowedWorldPosition(p) then points[1] = p end
    end
    return points
end

function ClusterFarmController:GetFieldSweepGoal(fallbackCF)
    local state = _G.State
    if not state or state.ClusterMode ~= "QUEST"
        or _G.Settings.ClusterFieldPatrolEnabled == false or not self:PolicyValid() then
        return nil, nil
    end
    local me = HRP()
    local folder = workspace:FindFirstChild("Enemies")
    local anchorCF = state.ClusterAnchor or fallbackCF
    if not anchorCF then return nil, nil end
    local anchor = typeof(anchorCF) == "CFrame" and anchorCF.Position or anchorCF
    local searchRadius = math.max(300, tonumber(_G.Settings.ClusterQuestSearchRadius) or 3000)

    local bestRoot, bestDist
    if folder then
        for _, mob in ipairs(folder:GetChildren()) do
            if self:IsModelAllowed(mob) and not self:IsVerified(mob) then
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local root = mob:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root and root.Parent then
                    local ok, pos = pcall(function() return root.Position end)
                    if ok and IsAllowedWorldPosition(pos) and (pos - anchor).Magnitude <= searchRadius then
                        self:RememberSpawnPoint(tostring(state.ClusterMobName or mob.Name), pos)
                        local d = me and (pos - me.Position).Magnitude or 0
                        if not bestDist or d < bestDist then bestRoot, bestDist = root, d end
                    end
                end
            end
        end
    end
    if bestRoot then
        _G.BobonDiagnostics.Bring = "LIVE-SPAWN-SWEEP"
        return bestRoot, "LIVE"
    end

    local points = self:GetSpawnSweepPoints(fallbackCF)
    if #points == 0 then return nil, nil end
    local key = string.lower(tostring(state.ClusterMobName or ""))
    self.SpawnRouteIndex = self.SpawnRouteIndex or {}
    local idx = math.clamp(math.floor(tonumber(self.SpawnRouteIndex[key]) or 1), 1, #points)
    local now = tick()
    local height = math.max(12, tonumber(_G.Settings.ClusterFieldPatrolHeight) or 24)
    local raw = points[idx]
    local goal = Vector3.new(raw.X, math.max(raw.Y + height, _G.Settings.MinY + 2), raw.Z)
    local flatDist = me and (Vector3.new(me.Position.X,0,me.Position.Z)
        - Vector3.new(goal.X,0,goal.Z)).Magnitude or math.huge
    local arrived = flatDist <= (_G.Settings.ClusterFieldPatrolArrival or 18)
    if arrived then
        if self.PatrolLastSwitch == 0 then self.PatrolLastSwitch = now end
        if now - self.PatrolLastSwitch >= (_G.Settings.ClusterFieldPatrolHold or 0.55) then
            idx = idx % #points + 1
            self.SpawnRouteIndex[key] = idx
            self.PatrolLastSwitch = now
            raw = points[idx]
            goal = Vector3.new(raw.X, math.max(raw.Y + height, _G.Settings.MinY + 2), raw.Z)
        end
    else
        self.PatrolLastSwitch = now
    end
    self.PatrolLastPoint = goal
    _G.BobonDiagnostics.Bring = ("SPAWN-MARKER %d/%d"):format(idx, #points)
    return CFrame.new(goal), "SPAWN"
end

function ClusterFarmController:SelectPrimary()
    local state = _G.State
    local folder = workspace:FindFirstChild("Enemies")
    local pilePos = self:GetPileAnchorPosition()
    if not folder or not pilePos then return nil end
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
                local d = (root.Position - pilePos).Magnitude
                if not bestDist or d < bestDist then best, bestDist = mob, d end
            end
        end
    end
    state.ClusterPrimary = best
    return best
end

function ClusterFarmController:SelectFallbackRealTarget()
    local me = HRP()
    local best, bestDist
    for _, entry in ipairs(self.LastBatch or {}) do
        local model, hum, root = entry.Model, entry.Humanoid, entry.Root
        if model and model.Parent and hum and hum.Health > 0 and root and root.Parent
            and self:IsModelAllowed(model) and not self:IsVerified(model) then
            local ok, pos = pcall(function() return root.Position end)
            if ok and IsValidPos(pos) then
                local d = me and (pos-me.Position).Magnitude or 0
                if not bestDist or d < bestDist then best, bestDist = model, d end
            end
        end
    end
    return best
end

function ClusterFarmController:SelectProbePrimary()
    local me = HRP()

    if self:IsShadowCombatActive() then
        local best, bestDist
        for _, entry in ipairs(self.LastBatch or {}) do
            local model, hum, root = entry.Model, entry.Humanoid, entry.Root
            if model and hum and hum.Health > 0 and root and root.Parent
                and self:IsShadowAttackEligible(model) then
                local shadow = self:GetServerShadowPosition(model)
                if shadow then
                    local d = me and (shadow - me.Position).Magnitude or 0
                    if not bestDist or d < bestDist then
                        best, bestDist = model, d
                    end
                end
            end
        end
        return best
    end

    if _G.Settings.ClusterAuthorityEnabled == false then return nil end
    local best, bestDist
    for _, entry in ipairs(self.LastBatch or {}) do
        local model, hum, root = entry.Model, entry.Humanoid, entry.Root
        if model and hum and hum.Health > 0 and root and root.Parent
            and self:IsProbeCandidate(model) then
            local ok, pos = pcall(function() return root.Position end)
            if ok and IsValidPos(pos) then
                local d = me and (pos - me.Position).Magnitude or 0
                if not bestDist or d < bestDist then best, bestDist = model, d end
            end
        end
    end
    return best
end

function ClusterFarmController:RestackBatch()
    if not self:PolicyValid() then return 0 end
    local state = _G.State
    local anchorCF = state and (state.ClusterFixedAnchor or state.ClusterAnchor)
    if not anchorCF then return 0 end

    local anchor = self:GetPileAnchorPosition() or anchorCF.Position
    local now = tick()
    local kept, verifiedCount = {}, 0
    local me = HRP()

    local proofTime = math.max(0.08, tonumber(_G.Settings.ClusterUnknownPersistenceTime) or 0.18)
    local proofChecks = math.max(2, math.floor(tonumber(_G.Settings.ClusterUnknownPersistenceChecks) or 2))
    local proofRadius = tonumber(_G.Settings.ClusterUnknownPersistenceRadius) or 8
    local rejectRadius = tonumber(_G.Settings.ClusterUnknownPersistenceRejectRadius) or 22
    local touchRadius = tonumber(_G.Settings.ClusterAcquireTouchRadius) or 95

    local function writeRoot(root)
        return pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = CFrame.new(anchor)
        end)
    end

    local function revoke(model, root, restore)
        VerifiedGatherRoots[root] = nil
        DamageProvenGatherRoots[root] = nil
        GatherAuthorityClass[root] = nil
        self.PositionProof[root] = nil
        self.UnknownProof[root] = nil
        if restore then
            local original = GatherOriginalPositions[root]
            if original and IsValidPos(original) then
                pcall(function()
                    local rot = root.CFrame.Rotation
                    root.CFrame = CFrame.new(original) * rot
                end)
            end
        end
        if model then
            self.AcquireBlockedUntil[model] = now + math.max(
                _G.Settings.ClusterPersistReacquireCooldown or 0.55,
                _G.Settings.ClusterFalseOwnerProofCooldown or 2.50)
        end
    end

    for _, entry in ipairs(self.LastBatch or {}) do
        local model = entry.Model
        local root = model and model:FindFirstChild("HumanoidRootPart")
        local hum = model and model:FindFirstChildOfClass("Humanoid")
        if model and model.Parent and root and root.Parent and hum and hum.Health > 0
            and self:IsModelAllowed(model) then
            kept[#kept + 1] = {
                Model=model, Humanoid=hum, Root=root,
                Position=entry.Position or GatherOriginalPositions[root],
            }

            local okPos, rootPos = pcall(function() return root.Position end)
            if okPos and IsValidPos(rootPos) and not GatherOriginalPositions[root] then
                GatherOriginalPositions[root] = rootPos
            end

            local own = ClientOwnsMob(root)
            local authority = GatherAuthorityClass[root]

            if own == true then
                if writeRoot(root) then
                    GatherAuthorityClass[root] = "OWNED"
                    VerifiedGatherRoots[root] = now
                    self.PositionProof[root] = nil
                    self.UnknownProof[root] = nil
                    _G.BobonGatherDamageLeaseUntil[root] = nil
                    _G.BobonGatherMoveTrial[root] = nil
                    verifiedCount = verifiedCount + 1
                end

            elseif authority == "PERSIST"
                and (own ~= false or _G.Settings.ClusterProbeExplicitFalseOwner == true) then
                if writeRoot(root) then
                    VerifiedGatherRoots[root] = now
                    verifiedCount = verifiedCount + 1
                else
                    revoke(model, root, false)
                end

            elseif (own == nil
                    or (own == false and _G.Settings.ClusterProbeExplicitFalseOwner == true))
                and _G.Settings.ClusterUnknownPersistenceProof ~= false then
                local proof = self.UnknownProof[root]
                if proof then
                    -- Do not rewrite while proving persistence. A server-owned assembly
                    -- must be allowed to snap back; a local ghost then fails this test.
                    local okTrial, trialPos = pcall(function() return root.Position end)
                    if okTrial and IsValidPos(trialPos) then
                        local dist = (trialPos - proof.Anchor).Magnitude
                        if dist <= proofRadius then
                            proof.Checks = (proof.Checks or 0) + 1
                            if now - (proof.StartedAt or now) >= proofTime
                                and proof.Checks >= proofChecks then
                                self.UnknownProof[root] = nil
                                self.PositionProof[root] = nil
                                GatherAuthorityClass[root] = "PERSIST"
                                VerifiedGatherRoots[root] = now
                                if writeRoot(root) then verifiedCount = verifiedCount + 1 end
                            end
                        elseif dist >= rejectRadius
                            or now - (proof.StartedAt or now) > proofTime + 0.35 then
                            revoke(model, root, false)
                        end
                    else
                        revoke(model, root, false)
                    end
                else
                    local isAcquire = state.ClusterAcquireTarget == model
                    local near = me and okPos and IsValidPos(rootPos)
                        and (rootPos - me.Position).Magnitude <= touchRadius
                    if isAcquire and near then
                        if writeRoot(root) then
                            self.UnknownProof[root] = {
                                Anchor=anchor, StartedAt=now, Checks=0,
                                Original=GatherOriginalPositions[root],
                            }
                        end
                    end
                end

            else
                -- Explicit server ownership: never leave a client-only pin/statue.
                if authority == "PERSIST" or self.UnknownProof[root] then
                    revoke(model, root, true)
                else
                    VerifiedGatherRoots[root] = nil
                    GatherAuthorityClass[root] = nil
                end
            end
        end
    end

    state.ClusterAuthorityProbeTarget = nil
    state.ClusterAuthorityProbeStartedAt = 0
    state.ClusterAuthorityProbeFirstAttackAt = 0
    state.ClusterShadowVisualAnchor = nil
    _G.BobonDiagnostics.BringVisual = 0

    self.LastBatch = kept
    if verifiedCount > 0 then state.ClusterLastMoved = now end
    return verifiedCount
end

function ClusterFarmController:Tick()
    if not self:PolicyValid() then
        self.LastBatch = {}
        if _G.State and _G.State.ClusterMode ~= "OFF" then
            FarmPositionController:ReleaseCluster()
        end
        return 0
    end

    local now = tick()
    if now - (self.LastTick or 0) < (_G.Settings.ClusterRefresh or 0.015) then
        return self:RestackBatch()
    end
    self.LastTick = now

    local state = _G.State
    local anchorCF = state.ClusterAnchor
    local anchor = anchorCF.Position
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return 0 end
    ExpandSimulationRadius()

    local ttl = _G.Settings.GatherVerifiedTTL or 2.5
    for root, at in pairs(VerifiedGatherRoots) do
        if not root.Parent or now - at > ttl then
            VerifiedGatherRoots[root] = nil
            if GatherAuthorityClass[root] == "OWNED" then GatherAuthorityClass[root] = nil end
        end
    end

    local candidates = {}
    local questFieldRadius = math.max(
        tonumber(_G.Settings.ClusterAuthorityFieldRadius) or 0,
        tonumber(_G.Settings.ClusterQuestRadius) or 0,
        tonumber(_G.Settings.ClusterQuestSearchRadius) or 0,
        180)
    local maxDistance = state.ClusterMode == "RAID"
        and math.max(100, tonumber(_G.Settings.RaidGatherRadius) or 700)
        or (state.ClusterMode == "QUEST"
            and questFieldRadius
            or math.max(100, tonumber(_G.Settings.GatherMaxDistance) or 3000))

    for _, mob in ipairs(folder:GetChildren()) do
        if self:IsModelAllowed(mob) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root and root.Parent and not root.Anchored then
                local okPos, pos = pcall(function() return root.Position end)
                if okPos and IsValidPos(pos) then
                    if not GatherOriginalPositions[root] then
                        GatherOriginalPositions[root] = pos
                    end
                    local fieldPos = GatherOriginalPositions[root] or pos
                    if state.ClusterMode == "QUEST" and state.ClusterMobName then
                        self:RememberSpawnPoint(tostring(state.ClusterMobName), fieldPos)
                    end
                    -- v21.23: field membership uses the immutable pre-magnet position.
                    -- A pile being towed hundreds of studs during the sweep must NEVER
                    -- disappear from LastBatch just because its current CFrame moved.
                    if IsAllowedWorldPosition(fieldPos)
                        and IsSubmergedPosition(fieldPos) == IsSubmergedPosition(anchor)
                        and (fieldPos - anchor).Magnitude <= maxDistance then
                        candidates[#candidates + 1] = {
                            Model=mob, Humanoid=hum, Root=root,
                            Position=fieldPos
                        }
                    end
                end
            end
        end
    end

    self.LastBatch = candidates
    self.LastBatchAt = now
    state.ClusterLastSeen = #candidates > 0 and now or (state.ClusterLastSeen or 0)

    local owned, unknown, other = 0, 0, 0
    for _, entry in ipairs(candidates) do
        local own = ClientOwnsMob(entry.Root)
        if own == true then owned = owned + 1
        elseif own == nil then unknown = unknown + 1
        else other = other + 1 end
    end

    local stacked = self:RestackBatch()
    local proven, probes, reachable = 0, 0, 0
    for _, entry in ipairs(candidates) do
        if entry.Model and self:IsDamageProven(entry.Model) then proven = proven + 1 end
        if entry.Model and self:IsProbeCandidate(entry.Model) then probes = probes + 1 end
        if entry.Model and self:IsShadowAttackEligible(entry.Model) then reachable = reachable + 1 end
    end

    local primary = self:SelectPrimary()
    state.ClusterPrimary = primary
    state.ClusterAcquireCompleted = stacked
    _G.BobonDiagnostics.BringCandidates = #candidates
    _G.BobonDiagnostics.BringOwned = owned
    _G.BobonDiagnostics.BringDamageProven = proven
    _G.BobonDiagnostics.BringUnknown = unknown
    _G.BobonDiagnostics.BringServerOwned = other
    _G.BobonDiagnostics.BringProbe = probes
    _G.BobonDiagnostics.BringReachable = reachable
    _G.BobonDiagnostics.BringMoved = stacked
    local phase, phaseVerified, phaseTotal = self:UpdatePhase()
    local revokedGhosts = self:AuditVictimLiveness()
    if revokedGhosts > 0 then
        _G.BobonDiagnostics.Bring = "REACQUIRE-GHOST"
    elseif stacked > 0 then
        _G.BobonDiagnostics.Bring = tostring(phase) .. " " .. tostring(phaseVerified) .. "/" .. tostring(phaseTotal)
    elseif #candidates == 0 then
        _G.BobonDiagnostics.Bring = "WAIT-SPAWN"
    elseif unknown > 0 then
        _G.BobonDiagnostics.Bring = "SWEEP-NO-OWNER-API"
    elseif other > 0 then
        _G.BobonDiagnostics.Bring = "OWNERSHIP-SWEEP"
    else
        _G.BobonDiagnostics.Bring = "OWNERSHIP-SWEEP"
    end
    return stacked
end

-- v21.37 HEARTBEAT-SAFE RESTACK. This function is deliberately read/hold-only:
-- it never discovers candidates, starts persistence proofs, changes phase, selects
-- targets, or revokes the whole cluster. Main/active Raid controller owns state.
function ClusterFarmController:RestackVerifiedOnly()
    if not self:PolicyValid() then return 0 end
    local state = _G.State
    local anchor = self:GetPileAnchorPosition()
    if not state or not anchor then return 0 end
    local now, count = tick(), 0
    for _, entry in ipairs(self.LastBatch or {}) do
        local model, root, hum = entry.Model, entry.Root, entry.Humanoid
        if model and model.Parent and root and root.Parent and hum and hum.Health > 0
            and self:IsModelAllowed(model) then
            local authority = GatherAuthorityClass[root]
            local at = VerifiedGatherRoots[root]
            if at and now - at <= (_G.Settings.GatherVerifiedTTL or 2.5)
                and (authority == "OWNED" or authority == "PERSIST"
                    or authority == "DAMAGE-LEASE") then
                local stillValid = true
                if authority == "OWNED" and ClientOwnsMob(root) ~= true then
                    stillValid = false
                    VerifiedGatherRoots[root] = nil
                    GatherAuthorityClass[root] = nil
                end
                if stillValid then
                    local ok = pcall(function()
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                        root.CFrame = CFrame.new(anchor)
                    end)
                    if ok then count = count + 1 end
                end
            end
        end
    end
    return count
end

-- Compatibility wrapper for old callers. Quest mode now persists at the
-- current state anchor instead of using the primary mob as the cluster center.
-- ══════════════════════════════════════════════════════════════════
-- v21.38 SHARED-SOURCE QUEST FARM / BN-STYLE BRING
-- Behavior basis: kaiv2 shared source BN() + unified quest loop.
-- Normal quest farm intentionally does NOT use ClusterPhase/ownership proofs.
-- ══════════════════════════════════════════════════════════════════
function ClusterFarmController:SharedRelease(reason)
    local restore = self.SharedRestore
    if type(restore) == "table" then
        for inst, old in pairs(restore) do
            if inst and inst.Parent and type(old) == "table" then
                pcall(function()
                    if old.Kind == "Humanoid" then
                        if old.WalkSpeed ~= nil then inst.WalkSpeed = old.WalkSpeed end
                        if old.AutoRotate ~= nil then inst.AutoRotate = old.AutoRotate end
                    elseif old.Kind == "Part" and inst:IsA("BasePart") then
                        if old.CanCollide ~= nil then inst.CanCollide = old.CanCollide end
                        if old.CanTouch ~= nil then inst.CanTouch = old.CanTouch end
                        if old.CanQuery ~= nil then inst.CanQuery = old.CanQuery end
                    end
                end)
            end
        end
    end
    local folder = workspace:FindFirstChild("Enemies")
    if folder then
        for _, mob in ipairs(folder:GetChildren()) do
            local root = mob:FindFirstChild("HumanoidRootPart")
            local bp = root and root:FindFirstChild("BobonSharedEnemyFlyPosition")
            if bp then pcall(function() bp:Destroy() end) end
            local teddyHold = root and root:FindFirstChild("BobonTeddyStackHold")
            if teddyHold then pcall(function() teddyHold:Destroy() end) end
            pcall(function()
                mob:SetAttribute("BobonBringExpectedAt", nil)
                mob:SetAttribute("BobonBringExpectedPos", nil)
                mob:SetAttribute("BobonBringIgnoreUntil", nil)
                mob:SetAttribute("BobonBringFailureCount", nil)
                mob:SetAttribute("FailureCount", nil) -- cleanup legacy v21.39 attribute only
            end)
        end
    end
    self.SharedRestore = setmetatable({}, {__mode="k"})
    self.SharedSoftProof = setmetatable({}, {__mode="k"})
    self.SharedSoftBlockedUntil = setmetatable({}, {__mode="k"})
    self.SharedSoftVerifiedUntil = setmetatable({}, {__mode="k"})
    self.SharedHPProvenUntil = setmetatable({}, {__mode="k"})
    self.SharedHPProvenAt = setmetatable({}, {__mode="k"})
    self.SharedProbeState = setmetatable({}, {__mode="k"})
    self.SharedClassicStableAt = setmetatable({}, {__mode="k"})
    self.SharedClassicCurrentPile = nil
    self.SharedTeddyBatch = {}
    self.SharedTeddyVerified = setmetatable({}, {__mode="k"})
    self.SharedTeddyLastScanAt = 0
    self.SharedTeddyActive = false
    self.SharedTeddyPendingAt = setmetatable({}, {__mode="k"})
    self.SharedTeddyQualified = setmetatable({}, {__mode="k"})
    self.SharedTeddyRetryAfter = setmetatable({}, {__mode="k"})
    self.SharedTeddyAcquireModel = nil
    self.SharedTeddyAcquireRoot = nil
    self.SharedTeddyAcquireStartedAt = 0
    self.SharedTeddyAcquireLastHealth = nil
    self.SharedTeddyAcquireTaggedAt = 0
    self.SharedNextProbeWaveAt = 0
    self.SharedPrimaryWatchTarget = nil
    self.SharedPrimaryWatchHealth = nil
    self.SharedPrimaryLastDamageAt = 0
    self.SharedPrimaryWatchStartedAt = 0
    self.SharedPrimaryRecoveryUntil = 0
    self.SharedMobName = nil
    self.SharedAnchorModel = nil
    self.SharedPileCFrame = nil
    self.SharedPileStartedAt = 0
    self.SharedEmptySince = 0
    self.SharedLastBringAt = 0
    self.SharedBringCount = 0
    self.TeddyAirTagged = setmetatable({}, {__mode="k"})
    self.TeddyAirStacked = setmetatable({}, {__mode="k"})
    self.TeddyAirStackStableAt = setmetatable({}, {__mode="k"})
    self.TeddyAirRetryAfter = setmetatable({}, {__mode="k"})
    self.TeddyAirVerified = setmetatable({}, {__mode="k"})
    self.TeddyAirVisited = setmetatable({}, {__mode="k"})
    self.TeddyAirFocusModel = nil
    self.TeddyAirFocusPhase = nil
    self.TeddyAirFocusStartedAt = 0
    self.TeddyAirFocusLastHealth = nil
    self.TeddyAirFocusRoot = nil
    self.TeddyAirMobName = nil
    if _G.State then
        _G.State.ClusterMode = "OFF"
        _G.State.ClusterPrimary = nil
        _G.State.ClusterAcquireTarget = nil
    end
    if _G.BobonDiagnostics then
        _G.BobonDiagnostics.Bring = "SHARED-OFF"
        _G.BobonDiagnostics.BringCandidates = 0
        _G.BobonDiagnostics.BringMoved = 0
        _G.BobonDiagnostics.BringFailed = 0
        _G.BobonDiagnostics.BringBlacklisted = 0
    end
    if reason then DLog("SHARED-FARM", "Release: " .. tostring(reason)) end
end

function ClusterFarmController:SharedRemember(inst, kind)
    if not inst then return end
    self.SharedRestore = self.SharedRestore or setmetatable({}, {__mode="k"})
    if self.SharedRestore[inst] then return end
    if kind == "Humanoid" then
        self.SharedRestore[inst] = {
            Kind="Humanoid",
            WalkSpeed=inst.WalkSpeed,
            AutoRotate=inst.AutoRotate,
        }
    elseif kind == "Part" and inst:IsA("BasePart") then
        self.SharedRestore[inst] = {
            Kind="Part",
            CanCollide=inst.CanCollide,
            CanTouch=inst.CanTouch,
            CanQuery=inst.CanQuery,
        }
    end
end

function ClusterFarmController:SharedRestoreOne(mob)
    if not mob then return end
    local restore = self.SharedRestore
    local hum = mob:FindFirstChildOfClass("Humanoid")
    if hum and type(restore) == "table" and restore[hum] then
        local old = restore[hum]
        pcall(function()
            if old.WalkSpeed ~= nil then hum.WalkSpeed = old.WalkSpeed end
            if old.AutoRotate ~= nil then hum.AutoRotate = old.AutoRotate end
        end)
        restore[hum] = nil
    end
    for _, part in ipairs(mob:GetDescendants()) do
        if part:IsA("BasePart") and type(restore) == "table" and restore[part] then
            local old = restore[part]
            pcall(function()
                if old.CanCollide ~= nil then part.CanCollide = old.CanCollide end
                if old.CanTouch ~= nil then part.CanTouch = old.CanTouch end
                if old.CanQuery ~= nil then part.CanQuery = old.CanQuery end
            end)
            restore[part] = nil
        end
    end
    local root = mob:FindFirstChild("HumanoidRootPart")
    local bp = root and root:FindFirstChild("BobonSharedEnemyFlyPosition")
    if bp then pcall(function() bp:Destroy() end) end
end

function ClusterFarmController:SharedSelectTarget(mobName)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    local pilePos = self.SharedPileCFrame and self.SharedPileCFrame.Position or nil
    local current = _G.State and _G.State.FarmTarget
    if current and current.Parent and IsEnemyNamed(current, mobName) then
        local hum = current:FindFirstChildOfClass("Humanoid")
        local root = current:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and root and root.Parent and IsAllowedWorldPosition(root.Position) then
            return current
        end
    end

    -- v21.40: choose the live mob nearest the fixed pile. This keeps FarmTarget a
    -- representative victim only; killing it never relocates the pile.
    local best, bestDist = nil, math.huge
    for _, mob in ipairs(folder:GetChildren()) do
        if IsEnemyNamed(mob, mobName) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root and root.Parent
                and IsAllowedWorldPosition(root.Position) then
                local dist = pilePos and (root.Position - pilePos).Magnitude or 0
                if not best or dist < bestDist then
                    best, bestDist = mob, dist
                end
            end
        end
    end
    return best
end

function ClusterFarmController:SharedEnsurePile(mobName, target, fallbackCF)
    if self.SharedMobName and string.lower(self.SharedMobName) ~= string.lower(mobName) then
        self:SharedRelease("QuestMobChanged")
    end
    self.SharedMobName = mobName
    local root = target and target:FindFirstChild("HumanoidRootPart")

    -- v22.13 TEDDY: one field anchor survives every primary death.  Prefer the
    -- canonical quest/skip field center (fallbackCF) just like the old Teddy farm.
    -- The live target is only a representative victim and never owns the pile.
    if _G.Settings.SharedTeddyMode ~= false then
        if self.SharedPileCFrame and IsValidPos(self.SharedPileCFrame.Position) then
            return self.SharedPileCFrame
        end
        local chosen = nil
        if fallbackCF and typeof(fallbackCF) == "CFrame" and IsValidPos(fallbackCF.Position) then
            chosen = CFrame.new(fallbackCF.Position)
        elseif fallbackCF and typeof(fallbackCF) == "Vector3" and IsValidPos(fallbackCF) then
            chosen = CFrame.new(fallbackCF)
        elseif root and root.Parent and IsValidPos(root.Position) then
            chosen = CFrame.new(root.Position)
        end
        if chosen then
            self.SharedPileCFrame = chosen
            self.SharedPileStartedAt = tick()
            self.SharedTeddyActive = true
        end
        return self.SharedPileCFrame
    end

    if _G.Settings.ReferenceCoreMode == true or _G.Settings.SharedFixedPile == false then
        self.SharedPileCFrame = nil
        self.SharedPileStartedAt = 0
        return root and root.CFrame or fallbackCF
    end

    if self.SharedPileCFrame then return self.SharedPileCFrame end
    if root and root.Parent and IsValidPos(root.Position) then
        self.SharedPileCFrame = CFrame.new(root.Position)
    elseif fallbackCF then
        self.SharedPileCFrame = CFrame.new(fallbackCF.Position)
    end
    self.SharedPileStartedAt = tick()
    return self.SharedPileCFrame
end

function ClusterFarmController:SharedTeddyRestack(forceScan)
    -- v22.17 Teddy sequence:
    --   * fixed field anchor
    --   * whole-spawn snapshot
    --   * ONLY HP-tagged + physically acquired roots are snapped
    --   * one-write persistence verification before they become attack-eligible
    --   * verified roots are then held at the same anchor on Heartbeat
    if _G.Settings.SharedTeddyMode == false then return 0, 0 end
    if not self.SharedTeddyActive or not self.SharedPileCFrame or not self.SharedMobName then
        return 0, 0
    end
    if not _G.State or _G.State.Mode ~= "Farming" or _G.State.ActiveActionToken ~= 0 then
        return 0, 0
    end

    local folder = workspace:FindFirstChild("Enemies")
    local me = HRP()
    if not folder or not me then return 0, 0 end

    local now = tick()
    local anchor = self.SharedPileCFrame.Position
    local maxDistance = math.max(150,
        tonumber(_G.Settings.SharedTeddyMaxDistance)
        or tonumber(_G.Settings.GatherMaxDistance) or 3000)
    local scanEvery = math.max(0.02,
        tonumber(_G.Settings.SharedTeddyScanInterval) or 0.03)
    local verifyRadius = math.max(6,
        tonumber(_G.Settings.TeddySequenceVerifyRadius)
        or tonumber(_G.Settings.SharedTeddyVerifyRadius) or 13)
    local stableDelay = math.max(0.10,
        tonumber(_G.Settings.TeddySequenceStableDelay) or 0.18)
    local acquireRadius = math.max(16,
        tonumber(_G.Settings.TeddySequenceAcquireRadius) or 38)
    local pullTimeout = math.max(0.55,
        tonumber(_G.Settings.TeddySequencePullTimeout) or 1.20)
    local retryDelay = math.max(0.15,
        tonumber(_G.Settings.TeddySequenceRetryDelay) or 0.28)

    pcall(function() ExpandSimulationRadius() end)

    self.SharedTeddyBatch = self.SharedTeddyBatch or {}
    self.SharedTeddyVerified = self.SharedTeddyVerified or setmetatable({}, {__mode="k"})
    self.SharedTeddyPendingAt = self.SharedTeddyPendingAt or setmetatable({}, {__mode="k"})
    self.SharedTeddyQualified = self.SharedTeddyQualified or setmetatable({}, {__mode="k"})
    self.SharedTeddyRetryAfter = self.SharedTeddyRetryAfter or setmetatable({}, {__mode="k"})

    -- Snapshot the full active field before moving anything.
    if forceScan == true or now - (self.SharedTeddyLastScanAt or 0) >= scanEvery then
        self.SharedTeddyLastScanAt = now
        local snapshot = {}
        for _, mob in ipairs(folder:GetChildren()) do
            if IsEnemyNamed(mob, self.SharedMobName) then
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local root = mob:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root and root.Parent and not root.Anchored then
                    local okPos, pos = pcall(function() return root.Position end)
                    if okPos and IsValidPos(pos) and IsAllowedWorldPosition(pos)
                        and IsSubmergedPosition(pos) == IsSubmergedPosition(anchor)
                        and (pos - anchor).Magnitude <= maxDistance then
                        snapshot[#snapshot + 1] = {
                            Model = mob,
                            Humanoid = hum,
                            Root = root,
                            Position = pos,
                        }
                    end
                end
            end
        end
        self.SharedTeddyBatch = snapshot
    end

    local kept, verifiedCount = {}, 0
    local acquireModel = self.SharedTeddyAcquireModel
    local acquireRoot = acquireModel and acquireModel:FindFirstChild("HumanoidRootPart") or nil

    local function singleSnap(root)
        return pcall(function()
            local rot = root.CFrame.Rotation
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = CFrame.new(anchor) * rot
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    for _, entry in ipairs(self.SharedTeddyBatch) do
        local mob, hum, root = entry.Model, entry.Humanoid, entry.Root
        if mob and mob.Parent and hum and hum.Health > 0 and root and root.Parent
            and not root.Anchored and IsEnemyNamed(mob, self.SharedMobName) then

            kept[#kept + 1] = entry
            local okPos, pos = pcall(function() return root.Position end)
            if okPos and IsValidPos(pos) then
                local atAnchor = (pos - anchor).Magnitude <= verifyRadius
                local verifiedAt = self.SharedTeddyVerified[root]
                local pendingAt = self.SharedTeddyPendingAt[root]

                if verifiedAt then
                    -- Already accepted: keep it pinned. If the server yanks it far away,
                    -- revoke it and reacquire instead of leaving a visual ghost in the pile.
                    if (pos - anchor).Magnitude > verifyRadius * 3.0 then
                        self.SharedTeddyVerified[root] = nil
                        self.SharedTeddyPendingAt[root] = nil
                        self.SharedTeddyQualified[root] = nil
                        self.SharedTeddyRetryAfter[root] = now + retryDelay
                    else
                        singleSnap(root)
                        self.SharedTeddyVerified[root] = now
                        verifiedCount = verifiedCount + 1
                    end

                elseif pendingAt then
                    -- IMPORTANT: do NOT rewrite during the persistence window.
                    -- A real Teddy-style stack must survive server correction after one write.
                    if atAnchor and now - pendingAt >= stableDelay then
                        self.SharedTeddyVerified[root] = now
                        self.SharedTeddyPendingAt[root] = nil
                        verifiedCount = verifiedCount + 1
                    elseif not atAnchor and now - pendingAt >= stableDelay then
                        self.SharedTeddyPendingAt[root] = nil
                        if now - pendingAt >= pullTimeout then
                            self.SharedTeddyQualified[root] = nil
                            self.SharedTeddyRetryAfter[root] = now + retryDelay
                        end
                    elseif now - pendingAt >= pullTimeout then
                        self.SharedTeddyPendingAt[root] = nil
                        self.SharedTeddyQualified[root] = nil
                        self.SharedTeddyRetryAfter[root] = now + retryDelay
                    end

                else
                    -- A fresh mob is allowed to move only after the acquire phase caused
                    -- real HP loss AND Farm is physically close enough (or owns the root).
                    local qualified = self.SharedTeddyQualified[root]
                    local closeToPlayer = (pos - me.Position).Magnitude <= acquireRadius
                    local owns = ClientOwnsMob(root)
                    local isAcquire = acquireRoot == root
                    if qualified and now >= (tonumber(self.SharedTeddyRetryAfter[root]) or 0)
                        and (owns == true or (isAcquire and closeToPlayer)) then
                        if singleSnap(root) then
                            self.SharedTeddyPendingAt[root] = now
                        end
                    end
                end
            end
        end
    end

    self.SharedTeddyBatch = kept
    self.SharedBringCount = verifiedCount
    self.SharedClassicCurrentPile = anchor

    if _G.BobonDiagnostics then
        _G.BobonDiagnostics.Bring = ("TEDDY-SEQ %d/%d"):format(verifiedCount, #kept)
        _G.BobonDiagnostics.BringCandidates = #kept
        _G.BobonDiagnostics.BringMoved = verifiedCount
        _G.BobonDiagnostics.BringFailed = math.max(0, #kept - verifiedCount)
    end
    return verifiedCount, #kept
end

function ClusterFarmController:TeddySequenceFarmTick(mobName, fallbackCF, statusPrefix)
    if _G.Settings.SharedSourceFarmMode == false then return false end
    if type(mobName) ~= "string" or mobName == "" then return false end
    if not _G.State or _G.State.Mode ~= "Farming" or _G.State.ActiveActionToken ~= 0 then return false end

    local prefix = tostring(statusPrefix or "Farm")
    self:SharedEnsurePile(mobName, nil, fallbackCF)
    if not self.SharedPileCFrame then return false end
    self.SharedTeddyActive = true

    local verified, total = self:SharedTeddyRestack(true)
    local batch = self.SharedTeddyBatch or {}
    local me = HRP()
    if not me then return true end

    if total <= 0 then
        self.SharedTeddyAcquireModel = nil
        self.SharedTeddyAcquireRoot = nil
        self.SharedTeddyAcquireLastHealth = nil
        self.SharedTeddyAcquireStartedAt = 0
        _G.State.FarmTarget = nil
        _G.State.CurrentTarget = nil
        _G.State.FState = "SHARED_BRING_FARM"
        _G.State.ActionText = "Waiting Mob • " .. mobName
        if fallbackCF and _G.State:CanRequestTravel() then
            local baseCF = typeof(fallbackCF) == "CFrame" and fallbackCF or CFrame.new(fallbackCF)
            TravelManager:Request(baseCF * CFrame.new(0,
                tonumber(_G.Settings.TeddySequencePileHover) or 24, 0), "Farm", {
                arrivalThreshold = _G.Settings.ClusterFieldPatrolArrival or 18,
                fallback = fallbackCF,
                combatHover = true,
                persistent = false,
                speed = _G.Settings.TeddyAirSweepSpeed or _G.Settings.FlySpeed or 430,
            })
        end
        _G.BobonStatus = prefix .. ": Teddy • waiting " .. mobName
        return true
    end

    self.SharedTeddyRetryAfter = self.SharedTeddyRetryAfter or setmetatable({}, {__mode="k"})
    self.SharedTeddyQualified = self.SharedTeddyQualified or setmetatable({}, {__mode="k"})
    self.SharedTeddyVerified = self.SharedTeddyVerified or setmetatable({}, {__mode="k"})

    local now = tick()
    local acquire = self.SharedTeddyAcquireModel
    local acquireHum = acquire and acquire:FindFirstChildOfClass("Humanoid")
    local acquireRoot = acquire and acquire:FindFirstChild("HumanoidRootPart")

    local function isLiveEntry(model)
        if not model or not model.Parent then return false end
        local h = model:FindFirstChildOfClass("Humanoid")
        local r = model:FindFirstChild("HumanoidRootPart")
        return h and h.Health > 0 and r and r.Parent and IsEnemyNamed(model, mobName)
    end

    if not isLiveEntry(acquire) or (acquireRoot and self.SharedTeddyVerified[acquireRoot]) then
        self.SharedTeddyAcquireModel = nil
        self.SharedTeddyAcquireRoot = nil
        self.SharedTeddyAcquireStartedAt = 0
        self.SharedTeddyAcquireLastHealth = nil
        self.SharedTeddyAcquireTaggedAt = 0
        acquire, acquireHum, acquireRoot = nil, nil, nil
    end

    -- Pick one real, unstacked mob and keep it until it either joins the pile or dies.
    if not acquire then
        local best, bestDist = nil, math.huge
        for _, entry in ipairs(batch) do
            local root = entry.Root
            if root and root.Parent and not self.SharedTeddyVerified[root]
                and not self.SharedTeddyPendingAt[root]
                and now >= (tonumber(self.SharedTeddyRetryAfter[root]) or 0) then
                local okPos, pos = pcall(function() return root.Position end)
                if okPos and IsValidPos(pos) then
                    local dist = (pos - me.Position).Magnitude
                    if dist < bestDist then
                        best, bestDist = entry.Model, dist
                    end
                end
            end
        end
        if best then
            acquire = best
            acquireHum = best:FindFirstChildOfClass("Humanoid")
            acquireRoot = best:FindFirstChild("HumanoidRootPart")
            self.SharedTeddyAcquireModel = best
            self.SharedTeddyAcquireRoot = acquireRoot
            self.SharedTeddyAcquireStartedAt = now
            self.SharedTeddyAcquireLastHealth = acquireHum and acquireHum.Health or nil
            self.SharedTeddyAcquireTaggedAt = 0
        end
    end

    -- While acquiring the next mob, keep the old pile fixed and continue fast damage.
    if acquire and acquireHum and acquireHum.Health > 0 and acquireRoot and acquireRoot.Parent then
        _G.State.FarmTarget = acquire
        _G.State.CurrentTarget = acquire
        _G.State.ClusterMode = "OFF"
        _G.State.FState = "SHARED_BRING_FARM"
        _G.State.ActionText = "Acquire Mob • " .. mobName

        local acquireHover = math.max(8, tonumber(_G.Settings.TeddySequenceAcquireHover) or 12)
        local targetCF = acquireRoot.CFrame * CFrame.new(0, acquireHover, 0)
        if _G.State:CanRequestTravel() then
            TravelManager:Request(targetCF, "Farm", {
                arrivalThreshold = math.max(5, tonumber(_G.Settings.TeddySequenceAcquireRadius) or 38),
                fallback = fallbackCF or self.SharedPileCFrame,
                combatHover = true,
                persistent = true,
                speed = _G.Settings.TeddyAirSweepSpeed or _G.Settings.FlySpeed or 430,
            })
        end

        me = HRP() or me
        local dist = (me.Position - acquireRoot.Position).Magnitude
        local attackRange = math.max(45,
            tonumber(_G.Settings.TeddySequenceAttackRange)
            or tonumber(_G.Settings.FastAttackRange) or 120)
        local farmHolds = not _G.State.IsTraveling or _G.State.MovementOwner == "Farm"
        local attempted = false
        local taggedBefore = self.SharedTeddyQualified[acquireRoot] ~= nil

        -- Phase TAG: hit THIS exact mob only until one real HP delta is seen.
        -- After the tag succeeds, stop damaging it so fast attack cannot kill it
        -- before the physical acquire/snap finishes.
        if not taggedBefore and dist <= attackRange and farmHolds then
            PrepareCombatTarget(acquire)
            EquipCombatTool()
            attempted = Attack(acquire, mobName)
            if attempted then _G.State.FState = "SHARED_ATTACK" end
        elseif taggedBefore and farmHolds then
            -- Teddy reference keeps damage flowing while moving to the tagged mob.
            -- Damage the already verified pile, NOT the tagged-but-unstacked victim.
            local pilePrimary, pileBest = nil, math.huge
            for _, entry in ipairs(batch) do
                local r = entry.Root
                if r and r.Parent and self.SharedTeddyVerified[r] then
                    local dd = (r.Position - self.SharedPileCFrame.Position).Magnitude
                    if dd < pileBest then
                        pilePrimary, pileBest = entry.Model, dd
                    end
                end
            end
            if pilePrimary then
                PrepareCombatTarget(pilePrimary)
                EquipCombatTool()
                attempted = Attack(pilePrimary, mobName)
                if attempted then _G.State.FState = "SHARED_ATTACK" end
            end
        end

        local lastHP = tonumber(self.SharedTeddyAcquireLastHealth)
        local hp = acquireHum.Health
        if lastHP and hp < lastHP - 0.01 then
            self.SharedTeddyQualified[acquireRoot] = now
            self.SharedTeddyAcquireTaggedAt = now
        end
        self.SharedTeddyAcquireLastHealth = hp

        -- Once real HP loss has been observed, stay close for the ownership handoff.
        -- SharedTeddyRestack performs ONE snap and then verifies persistence without rewriting.
        local tagged = self.SharedTeddyQualified[acquireRoot] ~= nil
        if tagged then
            self:SharedTeddyRestack(false)
        end

        local tagTimeout = math.max(1.0, tonumber(_G.Settings.TeddySequenceTagTimeout) or 3.25)
        if now - (tonumber(self.SharedTeddyAcquireStartedAt) or now) >= tagTimeout
            and not tagged then
            self.SharedTeddyRetryAfter[acquireRoot] =
                now + math.max(0.15, tonumber(_G.Settings.TeddySequenceRetryDelay) or 0.28)
            self.SharedTeddyAcquireModel = nil
            self.SharedTeddyAcquireRoot = nil
            self.SharedTeddyAcquireStartedAt = 0
            self.SharedTeddyAcquireLastHealth = nil
            self.SharedTeddyAcquireTaggedAt = 0
        end

        local phase = tagged and "STACK" or "TAG"
        _G.BobonStatus = ("%s: Teddy • %s %s • pile %d/%d • hit %s")
            :format(prefix, phase, mobName, verified, total,
                attempted and "ACTIVE" or "PROBING")
        return true
    end

    -- Every current mob is either verified or waiting for its one-write persistence check.
    -- Park over the fixed pile and kill; new spawns automatically reopen ACQUIRE.
    local primary, bestDist = nil, math.huge
    for _, entry in ipairs(batch) do
        local root = entry.Root
        if root and root.Parent and self.SharedTeddyVerified[root] then
            local d = (root.Position - self.SharedPileCFrame.Position).Magnitude
            if d < bestDist then
                primary, bestDist = entry.Model, d
            end
        end
    end

    if primary then
        _G.State.FarmTarget = primary
        _G.State.CurrentTarget = primary
        _G.State.ClusterMode = "OFF"
        _G.State.FState = "SHARED_ATTACK"
        _G.State.ActionText = "Attack Pile • " .. mobName

        local pileHover = math.max(12, tonumber(_G.Settings.TeddySequencePileHover) or 24)
        local hoverCF = self.SharedPileCFrame * CFrame.new(0, pileHover, 0)
        if _G.State:CanRequestTravel() then
            TravelManager:Request(hoverCF, "Farm", {
                arrivalThreshold = _G.Settings.FarmArrivalThreshold or 15,
                fallback = fallbackCF or self.SharedPileCFrame,
                combatHover = true,
                persistent = true,
                speed = _G.Settings.TeddyAirSweepSpeed or _G.Settings.FlySpeed or 430,
            })
        end

        PrepareCombatTarget(primary)
        EquipCombatTool()
        local attempted = Attack(primary, mobName)
        _G.BobonStatus = ("%s: Teddy • KILL pile %d/%d • %s")
            :format(prefix, verified, total, attempted and "ACTIVE" or "PROBING")
        return true
    end

    _G.State.FState = "SHARED_BRING_FARM"
    _G.BobonStatus = ("%s: Teddy • VERIFY pile %d/%d"):format(prefix, verified, total)
    return true
end


function ClusterFarmController:SharedBring(mobName, pileCF, fallbackCF, primaryTarget)
    if _G.Settings.SharedSourceFarmMode == false then return 0 end
    if not _G.State or _G.State.Mode ~= "Farming" or _G.State.ActiveActionToken ~= 0 then return 0 end
    if type(mobName) ~= "string" or mobName == "" then return 0 end

    if self.SharedMobName and string.lower(self.SharedMobName) ~= string.lower(mobName) then
        self:SharedRelease("QuestMobChanged")
    end
    self.SharedMobName = mobName

    if _G.Settings.SharedTeddyMode ~= false then
        -- Ignore the moving primary CFrame. The fixed field anchor comes from
        -- fallbackCF and survives target death.
        self:SharedEnsurePile(mobName, primaryTarget, fallbackCF or pileCF)
        if not self.SharedPileCFrame then return 0 end
        self.SharedTeddyActive = true
        local moved = self:SharedTeddyRestack(true)
        return moved
    end

    -- Legacy v22.12 BN path retained as fallback when Teddy mode is disabled.
    local now = tick()
    local interval = math.max(0.04, tonumber(_G.Settings.SharedBringInterval) or 0.08)
    if now - (self.SharedLastBringAt or 0) < interval then
        return self.SharedBringCount or 0
    end
    self.SharedLastBringAt = now
    pcall(function() ExpandSimulationRadius() end)

    local folder = workspace:FindFirstChild("Enemies")
    local me = HRP()
    if not folder or not me or not pileCF then return 0 end
    local pilePos = pileCF.Position
    local fieldCenter = fallbackCF and fallbackCF.Position or pilePos
    local localRange = math.max(120, tonumber(_G.Settings.SharedBringRange) or 350)
    local fieldRange = math.max(localRange, tonumber(_G.Settings.SharedBringFieldRange) or 1200)
    local maxMobs = math.floor(tonumber(_G.Settings.SharedBringMaxMobs) or 0)
    local maxForce = tonumber(_G.Settings.SharedBringMaxForce) or 1000000
    local pGain = tonumber(_G.Settings.SharedBringP) or 3000
    local dGain = tonumber(_G.Settings.SharedBringD) or 100
    self.SharedClassicStableAt = self.SharedClassicStableAt or setmetatable({}, {__mode="k"})
    self.SharedClassicCurrentPile = pilePos
    local candidates, stable = 0, 0

    for _, mob in ipairs(folder:GetChildren()) do
        if IsEnemyNamed(mob, mobName) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root and root.Parent and not root.Anchored then
                local pos = root.Position
                local inField = IsValidPos(pos)
                    and ((pos-fieldCenter).Magnitude <= fieldRange
                        or (pos-pilePos).Magnitude <= localRange
                        or (pos-me.Position).Magnitude <= localRange)
                if inField and (maxMobs <= 0 or candidates < maxMobs) then
                    candidates = candidates + 1
                    if mob == primaryTarget then
                        stable = stable + 1
                    else
                        pcall(function()
                            local bp = root:FindFirstChild("BobonSharedEnemyFlyPosition")
                            if not bp then
                                bp = Instance.new("BodyPosition")
                                bp.Name = "BobonSharedEnemyFlyPosition"
                                bp.Parent = root
                            end
                            bp.MaxForce = Vector3.new(maxForce,maxForce,maxForce)
                            bp.P = pGain
                            bp.D = dGain
                            bp.Position = pilePos
                        end)
                        stable = stable + 1
                    end
                end
            end
        end
    end
    self.SharedBringCount = stable
    return stable
end

function ClusterFarmController:IsSharedAttackEligible(model, primaryTarget)
    if not model or not model.Parent then return false end
    if primaryTarget and model == primaryTarget then return true end

    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not root or not root.Parent then return false end

    if _G.Settings.TeddyAirSweepMode ~= false then
        local at = self.TeddyAirVerified and self.TeddyAirVerified[root]
        local ttl = math.max(0.15, tonumber(_G.Settings.TeddyAirVerifyTTL) or 0.55)
        return at ~= nil and tick() - at <= ttl
    end

    if _G.Settings.SharedTeddyMode ~= false then
        local at = self.SharedTeddyVerified and self.SharedTeddyVerified[root]
        local anchorCF = self.SharedPileCFrame
        if not at or not anchorCF then return false end
        local ttl = math.max(0.10, tonumber(_G.Settings.SharedTeddyVerifyTTL) or 0.35)
        if tick() - at > ttl then return false end
        local ok, pos = pcall(function() return root.Position end)
        if not ok or not IsValidPos(pos) then return false end
        local radius = math.max(5, tonumber(_G.Settings.SharedTeddyVerifyRadius) or 12)
        return (pos - anchorCF.Position).Magnitude <= radius
    end

    local pilePos = self.SharedClassicCurrentPile
    local since = self.SharedClassicStableAt and self.SharedClassicStableAt[root]
    if not pilePos or not since then return false end
    local ok, pos = pcall(function() return root.Position end)
    if not ok or not IsValidPos(pos) then return false end
    local verifyRadius = math.max(6, tonumber(_G.Settings.SharedClassicVerifyRadius) or 14)
    local stableDelay = math.max(0.08, tonumber(_G.Settings.SharedClassicStableDelay) or 0.14)
    if (pos - pilePos).Magnitude > verifyRadius then
        self.SharedClassicStableAt[root] = nil
        return false
    end
    return tick() - since >= stableDelay
end

function ClusterFarmController:SharedPrimaryNoDamage(target, attackWindow)
    if not target or not _G.State:IsTargetValid(target) or attackWindow ~= true then
        self.SharedPrimaryWatchTarget = nil
        self.SharedPrimaryWatchHealth = nil
        self.SharedPrimaryLastDamageAt = 0
        self.SharedPrimaryWatchStartedAt = 0
        return false
    end
    local hum = target:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local now = tick()
    local hp = tonumber(hum.Health) or 0
    if self.SharedPrimaryWatchTarget ~= target then
        self.SharedPrimaryWatchTarget = target
        self.SharedPrimaryWatchHealth = hp
        self.SharedPrimaryLastDamageAt = now
        self.SharedPrimaryWatchStartedAt = now
        return false
    end
    local previous = tonumber(self.SharedPrimaryWatchHealth)
    if previous == nil or hp > previous + 0.01 then
        -- Respawn/heal/replacement is a new observation window, not a combat failure.
        self.SharedPrimaryWatchStartedAt = now
        self.SharedPrimaryLastDamageAt = now
    elseif hp < previous - 0.01 then
        self.SharedPrimaryLastDamageAt = now
    end
    self.SharedPrimaryWatchHealth = hp
    local timeout = math.max(1.5, tonumber(_G.Settings.SharedPrimaryNoDamageTimeout) or 3.0)
    local since = math.max(tonumber(self.SharedPrimaryWatchStartedAt) or now,
        tonumber(self.SharedPrimaryLastDamageAt) or now)
    if now < (tonumber(self.SharedPrimaryRecoveryUntil) or 0) then return false end
    return now - since >= timeout
end


function ClusterFarmController:TeddyAirFarmTick(mobName, fallbackCF, statusPrefix)
    if _G.Settings.TeddyAirSweepMode == false then return false end
    if not _G.State or _G.State.Mode ~= "Farming" or _G.State.ActiveActionToken ~= 0 then return false end
    if type(mobName) ~= "string" or mobName == "" then return false end

    local folder = workspace:FindFirstChild("Enemies")
    local me = HRP()
    if not folder or not me then return true end
    local now = tick()
    local prefix = tostring(statusPrefix or "Farm")
    if self.TeddyAirMobName and string.lower(tostring(self.TeddyAirMobName)) ~= string.lower(mobName) then self:SharedRelease("TeddyMobChanged") end
    self.TeddyAirMobName = mobName
    local fieldCenter
    if typeof(fallbackCF) == "CFrame" then
        fieldCenter = fallbackCF.Position
    elseif typeof(fallbackCF) == "Vector3" then
        fieldCenter = fallbackCF
    else
        fieldCenter = me.Position
    end

    pcall(function() ExpandSimulationRadius() end)

    self.TeddyAirTagged = self.TeddyAirTagged or setmetatable({}, {__mode="k"})
    self.TeddyAirStacked = self.TeddyAirStacked or setmetatable({}, {__mode="k"})
    self.TeddyAirStackStableAt = self.TeddyAirStackStableAt or setmetatable({}, {__mode="k"})
    self.TeddyAirRetryAfter = self.TeddyAirRetryAfter or setmetatable({}, {__mode="k"})
    self.TeddyAirVerified = self.TeddyAirVerified or setmetatable({}, {__mode="k"})
    self.TeddyAirVisited = self.TeddyAirVisited or setmetatable({}, {__mode="k"})

    local fieldRange = math.max(250, tonumber(_G.Settings.TeddyAirFieldRange) or 1800)
    local candidates = {}
    local candidateSet = setmetatable({}, {__mode="k"})
    for _, mob in ipairs(folder:GetChildren()) do
        if IsEnemyNamed(mob, mobName) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root and root.Parent and not root.Anchored then
                local okPos, pos = pcall(function() return root.Position end)
                if okPos and IsValidPos(pos) and IsAllowedWorldPosition(pos)
                    and IsSubmergedPosition(pos) == IsSubmergedPosition(fieldCenter)
                    and (pos - fieldCenter).Magnitude <= fieldRange then
                    candidates[#candidates + 1] = {
                        Model = mob,
                        Humanoid = hum,
                        Root = root,
                        Position = pos,
                    }
                    candidateSet[mob] = true
                end
            end
        end
    end
    self.TeddyAirCandidates = candidates

    local function destroyTeddyHold(r)
        if not r then return end
        local h = r:FindFirstChild("BobonTeddyStackHold")
        if h then pcall(function() h:Destroy() end) end
    end
    local function ensureTeddyHold(r,pos)
        if _G.Settings.TeddyAirUseBodyPosition == false or not r or not r.Parent then return nil end
        local h = r:FindFirstChild("BobonTeddyStackHold")
        if h and not h:IsA("BodyPosition") then pcall(function() h:Destroy() end); h=nil end
        if not h then h=Instance.new("BodyPosition"); h.Name="BobonTeddyStackHold"; h.Parent=r end
        h.MaxForce=Vector3.new(holdForce,holdForce,holdForce); h.P=holdP; h.D=holdD; h.Position=pos
        return h
    end
    local function prepTeddyStack(model,hum,r)
        self:SharedRemember(hum,"Humanoid"); self:SharedRemember(r,"Part")
        pcall(function() hum.WalkSpeed=0; hum.AutoRotate=false; r.CanCollide=false end)
        for _,part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then self:SharedRemember(part,"Part"); pcall(function() part.CanCollide=false end) end
        end
    end

    -- Drop stale focus immediately; weak-key stack tables clean themselves on destroy.
    local focus = self.TeddyAirFocusModel
    if focus and (not focus.Parent or not candidateSet[focus]) then
        self.TeddyAirFocusModel = nil
        self.TeddyAirFocusPhase = nil
        self.TeddyAirFocusStartedAt = 0
        self.TeddyAirFocusLastHealth = nil
        self.TeddyAirFocusRoot = nil
        focus = nil
    end

    if #candidates == 0 then
        _G.State.FarmTarget = nil
        _G.State.CurrentTarget = nil
        _G.State.ClusterMode = "OFF"
        _G.State.FState = "TEDDY_HP_WAIT"
        _G.State.ActionText = "Waiting Mob • " .. tostring(mobName)
        self.TeddyAirFocusModel = nil
        self.TeddyAirFocusPhase = nil
        if fallbackCF and _G.State:CanRequestTravel() then
            local baseCF = typeof(fallbackCF) == "CFrame" and fallbackCF or CFrame.new(fallbackCF)
            TravelManager:Request(baseCF * CFrame.new(0,
                tonumber(_G.Settings.TeddyAirHoverHeight) or 28, 0), "Farm", {
                arrivalThreshold = _G.Settings.ClusterFieldPatrolArrival or 18,
                fallback = fallbackCF,
                combatHover = false,
                persistent = false,
                speed = _G.Settings.TeddyAirSweepSpeed or 430,
            })
        end
        _G.BobonStatus = prefix .. ": Teddy • waiting " .. tostring(mobName)
        return true
    end

    local hover = math.max(12, tonumber(_G.Settings.TeddyAirHoverHeight) or 28)
    local tagHover = math.max(8, tonumber(_G.Settings.TeddyAirTagHoverHeight) or 16)
    local acquireHeight = math.max(1.5, tonumber(_G.Settings.TeddyAirAcquireHeight) or 4)
    local verifyRadius = math.max(6, tonumber(_G.Settings.TeddyAirPullVerifyRadius) or 15)
    local stableDelay = math.max(0.06, tonumber(_G.Settings.TeddyAirPullStableDelay) or 0.14)
    local acquireRadius = math.max(8, tonumber(_G.Settings.TeddyAirAcquireRadius) or 22)
    local causalWindow = math.max(0.25, tonumber(_G.Settings.TeddyAirCausalDamageWindow) or 1.00)
    local focusTimeout = math.max(1.25, tonumber(_G.Settings.TeddyAirFocusTimeout) or 4.25)
    local pullTimeout = math.max(0.75, tonumber(_G.Settings.TeddyAirPullTimeout) or 3.25)
    local retryDelay = math.max(0.15, tonumber(_G.Settings.TeddyAirRetryDelay) or 0.35)
    local leash = math.max(verifyRadius * 2, tonumber(_G.Settings.TeddyAirStackLeash) or 42)
    local holdP = math.max(1000, tonumber(_G.Settings.TeddyAirHoldP) or 7000)
    local holdD = math.max(50, tonumber(_G.Settings.TeddyAirHoldD) or 240)
    local holdForce = math.max(1000000, tonumber(_G.Settings.TeddyAirHoldMaxForce) or 1000000000)
    local pileDepth = math.max(3, tonumber(_G.Settings.TeddyAirPileDepth) or 8)

    -- One moving pile directly below the player. Previously stacked mobs follow it
    -- while Farm flies to the next unproven victim.
    me = HRP() or me
    local pilePos = Vector3.new(
        me.Position.X,
        me.Position.Y - pileDepth + (tonumber(_G.Settings.TeddyAirPileYOffset) or 0),
        me.Position.Z
    )
    if not IsSubmergedPosition(pilePos) then
        pilePos = Vector3.new(pilePos.X, math.max(_G.Settings.MinY or 10, pilePos.Y), pilePos.Z)
    end

    local stackedCount = 0
    for _, entry in ipairs(candidates) do
        local root = entry.Root
        if root and root.Parent and self.TeddyAirStacked[root] then
            local okBefore, before = pcall(function() return root.Position end)
            if not okBefore or not IsValidPos(before) then
                self.TeddyAirStacked[root]=nil; self.TeddyAirVerified[root]=nil; destroyTeddyHold(root)
            else
                local drift=(before-pilePos).Magnitude
                if drift > leash then
                    self.TeddyAirStacked[root]=nil; self.TeddyAirVerified[root]=nil
                    self.TeddyAirRetryAfter[root]=now+retryDelay
                    destroyTeddyHold(root); self:SharedRestoreOne(entry.Model)
                else
                    pcall(function()
                        ensureTeddyHold(root,pilePos)
                        root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
                        if drift > verifyRadius*0.70 then root.CFrame=CFrame.new(pilePos)*root.CFrame.Rotation end
                    end)
                    local okPos,pos=pcall(function() return root.Position end)
                    if okPos and IsValidPos(pos) and (pos-pilePos).Magnitude <= verifyRadius*1.6 then
                        self.TeddyAirVerified[root]=now; stackedCount=stackedCount+1
                    end
                end
            end
        end
    end

    -- Pick one NOT-YET-STACKED mob and commit to it. No rotating every 0.55s:
    -- the bot must cause real HP loss first, then pull that exact mob into the pile.
    focus = self.TeddyAirFocusModel
    if not focus then
        local best, bestScore = nil, math.huge
        for _, entry in ipairs(candidates) do
            local root = entry.Root
            if root and root.Parent and not self.TeddyAirStacked[root]
                and now >= (tonumber(self.TeddyAirRetryAfter[root]) or 0) then
                local dist = (entry.Position - me.Position).Magnitude
                local visited = tonumber(self.TeddyAirVisited[entry.Model]) or 0
                local score = dist + math.min(500, math.max(0, now - visited) * -8)
                if score < bestScore then
                    best = entry.Model
                    bestScore = score
                end
            end
        end
        if best then
            focus = best
            self.TeddyAirFocusModel = best
            self.TeddyAirFocusPhase = "HIT"
            self.TeddyAirFocusStartedAt = now
            local bh = best:FindFirstChildOfClass("Humanoid")
            self.TeddyAirFocusLastHealth = bh and bh.Health or nil
            self.TeddyAirFocusRoot = best:FindFirstChild("HumanoidRootPart")
            self.TeddyAirVisited[best] = now
        end
    end

    -- If every current mob is already stacked, stay above the moving pile and keep
    -- attacking a real live representative. A fresh respawn will become the next HIT focus.
    if not focus then
        local target, bestDist = nil, math.huge
        for _, entry in ipairs(candidates) do
            if self.TeddyAirStacked[entry.Root] then
                local dist = (entry.Root.Position - me.Position).Magnitude
                if dist < bestDist then target, bestDist = entry.Model, dist end
            end
        end
        target = target or candidates[1].Model
        _G.State.FarmTarget = target
        _G.State.CurrentTarget = target
        _G.State.ClusterMode = "OFF"
        _G.State.ClusterPrimary = nil
        _G.State.FState = "TEDDY_STACK_KILL"
        _G.State.ActionText = "Attacking Pile • " .. tostring(mobName)
        PrepareCombatTarget(target)
        EquipCombatTool()
        local attempted = Attack(target, mobName)
        if _G.BobonDiagnostics then
            _G.BobonDiagnostics.Bring = ("TEDDY-STACK %d/%d"):format(stackedCount, #candidates)
            _G.BobonDiagnostics.BringCandidates = #candidates
            _G.BobonDiagnostics.BringMoved = stackedCount
        end
        _G.BobonStatus = ("%s: Teddy • pile %d/%d • hit %s")
            :format(prefix, stackedCount, #candidates, attempted and "ACTIVE" or "PROBING")
        return true
    end

    local hum = focus:FindFirstChildOfClass("Humanoid")
    local root = focus:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not root or not root.Parent then
        self.TeddyAirFocusModel = nil
        self.TeddyAirFocusPhase = nil
        self.TeddyAirFocusStartedAt = 0
        self.TeddyAirFocusLastHealth = nil
        self.TeddyAirFocusRoot = nil
        return true
    end

    _G.State.FarmTarget = focus
    _G.State.CurrentTarget = focus
    _G.State.ClusterMode = "OFF"
    _G.State.ClusterPrimary = nil
    _G.State.FState = "SHARED_ATTACK"

    local phase = tostring(self.TeddyAirFocusPhase or "HIT")
    if phase == "HIT" then
        _G.State.ActionText = "Tagging Mob • " .. tostring(mobName)

        -- Fly above this exact mob and keep real attack dispatch on it.
        if _G.State:CanRequestTravel() then
            TravelManager:Request(CFrame.new(root.Position + Vector3.new(0,tagHover,0)), "Farm", {
                arrivalThreshold = math.max(8, tagHover*0.65),
                fallback = fallbackCF, combatHover = false, persistent = false,
                speed = tonumber(_G.Settings.TeddyAirSweepSpeed) or 430,
            })
        end

        PrepareCombatTarget(focus)
        EquipCombatTool()
        local attempted = Attack(focus, mobName)

        local hp = tonumber(hum.Health) or 0
        local prev = tonumber(self.TeddyAirFocusLastHealth)
        local recentAt = CombatController.RecentTargets and CombatController.RecentTargets[focus] or nil
        local causal = recentAt and now - recentAt <= causalWindow
        if prev and hp < prev - 0.01 and causal then
            pcall(function() self:ConfirmDamageProof(focus) end)
        end
        self.TeddyAirFocusLastHealth = hp

        local proven = self:IsDamageProven(focus)
        if proven then
            self.TeddyAirTagged[root] = now
            self.TeddyAirFocusPhase = "ACQUIRE"
            self.TeddyAirFocusStartedAt = now
            self.TeddyAirStackStableAt[root] = nil
            phase = "ACQUIRE"
        elseif now - (tonumber(self.TeddyAirFocusStartedAt) or now) >= focusTimeout then
            -- Do not fake-tag a no-damage mob. Move on briefly, then revisit it later.
            self.TeddyAirRetryAfter[root] = now + retryDelay
            self.TeddyAirFocusModel = nil
            self.TeddyAirFocusPhase = nil
            self.TeddyAirFocusStartedAt = 0
            self.TeddyAirFocusLastHealth = nil
            self.TeddyAirFocusRoot = nil
        end

        if _G.BobonDiagnostics then
            _G.BobonDiagnostics.Bring = ("TEDDY-HIT %d/%d"):format(stackedCount, #candidates)
            _G.BobonDiagnostics.BringCandidates = #candidates
            _G.BobonDiagnostics.BringMoved = stackedCount
        end
        _G.BobonStatus = ("%s: Teddy • HIT %s • pile %d/%d • %s")
            :format(prefix, tostring(mobName), stackedCount, #candidates,
                proven and "HP-PROVEN" or (attempted and "DAMAGE CHECK" or "PROBING"))
        return true
    end

    -- PULL phase: real HP proof already exists. Stay near the same mob and repeatedly
    -- move it underfoot until the root actually persists there; only then is it STACKED.
    _G.State.ActionText = "Stacking Mob • " .. tostring(mobName)
    if _G.State:CanRequestTravel() then
        TravelManager:Request(CFrame.new(root.Position + Vector3.new(0,acquireHeight,0)), "Farm", {
            arrivalThreshold = math.max(5, acquireHeight+2),
            fallback = fallbackCF, combatHover = false, persistent = false,
            speed = tonumber(_G.Settings.TeddyAirSweepSpeed) or 430,
        })
    end

    me = HRP() or me
    pilePos = Vector3.new(
        me.Position.X,
        me.Position.Y - pileDepth + (tonumber(_G.Settings.TeddyAirPileYOffset) or 0),
        me.Position.Z
    )
    if not IsSubmergedPosition(pilePos) then
        pilePos = Vector3.new(pilePos.X, math.max(_G.Settings.MinY or 10, pilePos.Y), pilePos.Z)
    end

    local near = (root.Position - me.Position).Magnitude <= acquireRadius
    local own = ClientOwnsMob(root)
    if near then
        pcall(function() ExpandSimulationRadius() end)
        self:SharedRemember(root,"Part")
        pcall(function() root.CanCollide=false end)
        pcall(function()
            local rot=root.CFrame.Rotation
            root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
            root.CFrame=CFrame.new(pilePos)*rot
            if own ~= false or _G.Settings.TeddyAirRequireOwnerForPull == false then ensureTeddyHold(root,pilePos) end
            root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
        end)
    end

    local okPos, pos = pcall(function() return root.Position end)
    local inPile = okPos and IsValidPos(pos) and (pos - pilePos).Magnitude <= verifyRadius
    if inPile then
        prepTeddyStack(focus,hum,root)
        local since = tonumber(self.TeddyAirStackStableAt[root]) or now
        if not self.TeddyAirStackStableAt[root] then self.TeddyAirStackStableAt[root] = now end
        if now - since >= stableDelay then
            self.TeddyAirStacked[root] = true
            self.TeddyAirVerified[root] = now
            self.TeddyAirRetryAfter[root] = nil
            ensureTeddyHold(root,pilePos)
            self.TeddyAirFocusModel = nil
            self.TeddyAirFocusPhase = nil
            self.TeddyAirFocusStartedAt = 0
            self.TeddyAirFocusLastHealth = nil
            self.TeddyAirFocusRoot = nil
            stackedCount = stackedCount + 1
        end
    else
        self.TeddyAirStackStableAt[root] = nil
    end

    -- Keep hitting while stacking; damage remains live and the already-stacked pile
    -- stays underfoot instead of becoming a frozen visual-only group.
    PrepareCombatTarget(focus)
    EquipCombatTool()
    local attempted = Attack(focus, mobName)

    if self.TeddyAirFocusModel and now - (tonumber(self.TeddyAirFocusStartedAt) or now) >= pullTimeout then
        -- Pull could not persist. Never claim it as stacked; revisit after another sweep.
        self.TeddyAirRetryAfter[root] = now + retryDelay
        self.TeddyAirFocusModel = nil
        self.TeddyAirFocusPhase = nil
        self.TeddyAirFocusStartedAt = 0
        self.TeddyAirFocusLastHealth = nil
        self.TeddyAirFocusRoot = nil
        self.TeddyAirStackStableAt[root] = nil
        destroyTeddyHold(root)
        self:SharedRestoreOne(focus)
    end

    if _G.BobonDiagnostics then
        _G.BobonDiagnostics.Bring = ("TEDDY-ACQUIRE %d/%d"):format(stackedCount, #candidates)
        _G.BobonDiagnostics.BringCandidates = #candidates
        _G.BobonDiagnostics.BringMoved = stackedCount
    end
    _G.BobonStatus = ("%s: Teddy • ACQUIRE %s • pile %d/%d • hit %s")
        :format(prefix, tostring(mobName), stackedCount, #candidates,
            attempted and "ACTIVE" or "PROBING")
    return true
end

function ClusterFarmController:SharedFarmTick(mobName, fallbackCF)
    if _G.Settings.SharedSourceFarmMode == false then return false end
    if _G.Settings.TeddySequenceMode ~= false then
        return self:TeddySequenceFarmTick(mobName, fallbackCF, "Farm")
    end
    if _G.Settings.TeddyAirSweepMode ~= false then
        return self:TeddyAirFarmTick(mobName, fallbackCF, "Farm")
    end
    -- Teddy mode establishes the fixed field anchor and magnetizes the full spawn
    -- before choosing a representative damage target.
    if _G.Settings.SharedTeddyMode ~= false then
        self:SharedEnsurePile(mobName, nil, fallbackCF)
        if self.SharedPileCFrame then
            self.SharedTeddyActive = true
            pcall(function() self:SharedTeddyRestack(true) end)
        end
    end

    local target = self:SharedSelectTarget(mobName)

    if not target then
        if self.SharedMobName and string.lower(self.SharedMobName) ~= string.lower(mobName) then
            self:SharedRelease("QuestMobChanged")
        end
        self.SharedMobName = mobName
        self.SharedEmptySince = self.SharedEmptySince or tick()
        if self.SharedEmptySince == 0 then self.SharedEmptySince = tick() end
        if _G.State then
            _G.State.FarmTarget = nil
            _G.State.CurrentTarget = nil
            _G.State.FState = "WAITING_MOB"
            _G.State.ActionText = "Waiting Mob • " .. tostring(mobName)
        end

        -- Reference-core wait: stay at the known spawn/quest field. Do not keep a
        -- dead target's pile alive as a prerequisite for the next wave.
        if fallbackCF and _G.State and _G.State:CanRequestTravel() then
            TravelManager:Request(fallbackCF, "Farm", {
                arrivalThreshold = _G.Settings.ClusterFieldPatrolArrival or 18,
                fallback = fallbackCF,
                combatHover = false,
                persistent = false,
                speed = _G.Settings.ClusterFieldPatrolSpeed or 400,
            })
        end
        _G.BobonStatus = "Waiting Mob: " .. tostring(mobName)
        return true
    end

    self.SharedEmptySince = 0
    if _G.Settings.ReferenceCoreMode == true and _G.Settings.SharedTeddyMode == false then
        self:SharedRestoreOne(target)
    end
    local hum = target:FindFirstChildOfClass("Humanoid")
    local root = target:FindFirstChild("HumanoidRootPart")
    local me = HRP()
    if not hum or hum.Health <= 0 or not root or not me then return true end

    local combatAnchor = self:SharedEnsurePile(mobName, target, fallbackCF)
    if not combatAnchor then return true end

    _G.State.FarmTarget = target
    _G.State.CurrentTarget = target
    _G.State.ClusterMode = "OFF"
    _G.State.FState = "SHARED_BRING_FARM"
    _G.State.ActionText = "Killing Mob • " .. tostring(mobName)

    -- Bring is deliberately best-effort. It is never consulted to decide whether
    -- Attack() is allowed to run. In reference-core mode the primary target remains
    -- at its real position and the other mobs are pulled toward it when physics allows.
    local bringCount = 0
    if _G.Settings.GatherMobs ~= false and _G.Settings.BringIsOptimization ~= false then
        bringCount = self:SharedBring(mobName, combatAnchor, fallbackCF, target)
    end

    local hoverHeight = tonumber(_G.Settings.SharedFarmHeight) or 25
    local targetPosition = (_G.Settings.SharedTeddyMode ~= false and self.SharedPileCFrame)
        and self.SharedPileCFrame.Position or root.Position
    local hoverCF = CFrame.new(targetPosition) * CFrame.new(0, hoverHeight, 0)
    if _G.State:CanRequestTravel() then
        TravelManager:Request(hoverCF, "Farm", {
            arrivalThreshold = _G.Settings.FarmArrivalThreshold,
            fallback = fallbackCF or hoverCF,
            combatHover = true,
            persistent = true,
            speed = _G.Settings.SkipTravelSpeed or _G.Settings.FlySpeed or 340,
        })
    end

    local dist = (me.Position - root.Position).Magnitude
    local farmHolds = not _G.State.IsTraveling or _G.State.MovementOwner == "Farm"
    local attackWindow = dist <= (_G.Settings.FastAttackRange or 100) and farmHolds
    if attackWindow then
        PrepareCombatTarget(target)
        EquipCombatTool()
        -- Combat is authoritative even when bringCount == 0. CollectTargets() may
        -- still fan out only to secondary mobs that passed v22.5/v22.6 authority gates.
        local attempted = Attack(target, mobName)
        _G.State.FState = "SHARED_ATTACK"

        if _G.Settings.SharedTeddyMode == false
            and attempted and self:SharedPrimaryNoDamage(target, true) then
            -- A real primary at its real position has stopped producing HP deltas. Release
            -- all visual secondary movers first, then invalidate the stale combat backend.
            -- The next tick keeps the same quest and re-enters fast target handoff cleanly.
            local failingBackend = CombatController.PendingBackend or CombatController.VerifiedBackend
            self:SharedRelease("PrimaryNoDamage")
            self.SharedPrimaryRecoveryUntil = tick()
                + math.max(0.5, tonumber(_G.Settings.SharedPrimaryRecoveryCooldown) or 1.0)
            _G.State.FarmTarget = target
            _G.State.CurrentTarget = target
            _G.State.FState = "SHARED_RECOVER_DAMAGE"
            if failingBackend then
                CombatController:FailBackend(failingBackend, "SHARED-PRIMARY-NO-DAMAGE")
            else
                CombatController:AbortPending("SHARED-PRIMARY-NO-DAMAGE")
            end
            _G.BobonStatus = "Farm: Recovering real damage • " .. tostring(mobName)
            return true
        end
    else
        self:SharedPrimaryNoDamage(nil, false)
    end

    if _G.Settings.SharedTeddyMode ~= false then
        local total = tonumber(_G.BobonDiagnostics and _G.BobonDiagnostics.BringCandidates)
            or tonumber(bringCount) or 0
        _G.BobonStatus = ("Farm: Teddy pile • %s • %d/%d")
            :format(tostring(mobName), tonumber(bringCount) or 0, total)
    elseif _G.Settings.ReferenceCoreMode == true then
        _G.BobonStatus = ("Killing Mob: %s • bring %d (optional)")
            :format(tostring(mobName), tonumber(bringCount) or 0)
    else
        _G.BobonStatus = ("Farm: Shared • %s • grouped %d")
            :format(tostring(mobName), tonumber(bringCount) or 0)
    end
    return true
end

function FarmPositionController:GatherMobCluster(mobName, primary)
    if not _G.State.ClusterAnchor then
        local root = primary and primary:FindFirstChild("HumanoidRootPart")
        if not root then return 0 end
        ClusterFarmController:Activate("QUEST", {mobName}, CFrame.new(root.Position), "Farm")
    end
    return ClusterFarmController:Tick()
end

-- v21.37 SINGLE CLUSTER STATE OWNER.
-- Heartbeat only holds roots that the active controller already verified.
-- Candidate discovery + phase mutation happen from the active Main/Raid tick only.
local ClusterHeartbeatConnection
pcall(function()
    ClusterHeartbeatConnection = RunService.Heartbeat:Connect(function()
        if not SessionAlive() then return end
        if _G.Settings.SharedTeddyMode ~= false
            and ClusterFarmController.SharedTeddyActive == true then
            pcall(function() ClusterFarmController:SharedTeddyRestack(false) end)
        elseif _G.State and _G.State.ClusterMode ~= "OFF" then
            pcall(function() ClusterFarmController:RestackVerifiedOnly() end)
        end
    end)
end)
pcall(function()
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        ClusterFarmController.EnemyAddedConnection = enemies.ChildAdded:Connect(function(mob)
            if not SessionAlive() or not _G.State or _G.State.ClusterMode == "OFF" then return end
            -- Observation only. Do not mutate ClusterPhase/PhaseStartedAt here.
            if mob and ClusterFarmController:IsModelAllowed(mob) then
                _G.State.ClusterLastSeen = tick()
            end
        end)
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
TravelManager.LastExitOwner = nil
TravelManager.LastExitReason = nil
TravelManager.LastExitToken = 0
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
    self.DodgeSpeed = 0
    self.DodgeSpeedUntil = 0
    if _G.State then
        _G.State.DodgeActive = false
        _G.State.DodgeThreatName = nil
    end
    _G.State.IsTraveling = false
    -- [A-3] Release movement owner qua MovementManager API
    MovementManager:Release()
    self:CleanupPhysics(Char())
    self:DisableNoclip()
end

function TravelManager:IsAtCombatAnchor(target)
    return self.AtCombatAnchor and (not target or self.AtCombatTarget == target)
end

function TravelManager:ApplyDodgeOffset(offset, duration, emergencySpeed)
    -- Skill dodge is allowed during the final combat approach too; waiting for
    -- AtCombatAnchor was too late for charge/projectile/AoE casts. It still
    -- requires an active combatHover trip, so puzzle/island travel is untouched.
    if typeof(offset) ~= "Vector3" or not _G.State.IsTraveling
        or not self.CurrentOptions or not self.CurrentOptions.combatHover then
        return false
    end
    self.DodgeOffset = offset
    self.DodgeUntil = tick() + (duration or 0.35)
    self.DodgeSpeed = math.max(tonumber(emergencySpeed) or 0, tonumber(self.DodgeSpeed) or 0)
    self.DodgeSpeedUntil = self.DodgeUntil
    return true
end

function TravelManager:ClearDodgeOffset()
    self.DodgeOffset = Vector3.zero
    self.DodgeUntil = 0
    self.DodgeSpeed = 0
    self.DodgeSpeedUntil = 0
end

local function SameTravelOptions(a, b)
    if not a or not b then return false end
    return a.arrivalThreshold == b.arrivalThreshold
        and a.speed == b.speed
        and a.fallback == b.fallback
        and a.combatHover == b.combatHover
        and a.acquireSweep == b.acquireSweep
        and a.persistent == b.persistent
        and a.hoverHeight == b.hoverHeight
end


function TravelManager:Request(targetCF, owner, options)
    options = options or {}
    owner = owner or "Unknown"


    if not _G.State:CanRequestTravel() then
        return false, "CannotTravel:" .. _G.State.Mode
    end
    -- v21.37 action/movement arbitration. A progression action that claimed the
    -- ActionToken is authoritative; a stale Farm tick may not start/retarget travel.
    if owner == "Farm" and _G.State.ActiveActionToken ~= 0 then
        return false, "ActionBusy:" .. tostring(_G.State.ActionOwner)
    end
    if owner ~= "Farm" and _G.State.ActiveActionToken ~= 0
        and _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
        self:Stop("ActionPreemptFarm")
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
        acquireSweep = options.acquireSweep == true,
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
    self.LastExitOwner = nil
    self.LastExitReason = nil
    self.LastExitToken = 0
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
                self.LastExitOwner = owner
                self.LastExitReason = "Timeout"
                self.LastExitToken = myToken
                -- A single puzzle/item leg must not cancel the whole progression.
                -- Farm/Raid keep the heavy recovery path; claimed progression actions
                -- are retried by TravelAndWait while their ActionToken remains valid.
                if owner == "Farm" or owner == "Raid" then
                    _G.State.IsRecovering = true
                end
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
                        self.LastExitOwner = owner
                        self.LastExitReason = "TargetLost"
                        self.LastExitToken = myToken
                        if owner == "Farm" or owner == "Raid" then
                            _G.State.IsRecovering = true
                        end
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
                    if owner == "Farm" or owner == "Raid" or IsAirFarmCombat() then
                        if owner == "Farm" and travelOptions.acquireSweep == true then
                            hoverHeight = _G.Settings.ClusterAcquireHoverHeight or 12
                        else
                            hoverHeight = owner == "Raid"
                                and (_G.Settings.RaidHoverHeight or _G.Settings.FarmHeight or 22)
                                or (_G.Settings.FarmHeight or 22)
                        end
                    elseif FarmSafetyActive() then
                        hoverHeight = math.max(tonumber(hoverHeight) or 0,
                            _G.Settings.EmergencyHoverHeight or 22)
                    elseif not hoverHeight then
                        hoverHeight = CombatController:WantsClientRange()
                            and (_G.Settings.ClientHoverHeight or 22)
                            or (_G.Settings.BossFarmHeight or 28)
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
                    and (_G.State.FarmTarget == snapModel
                        or _G.State.ClusterAcquireTarget == snapModel)
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


            -- v21.13: preserve v21.8 horizontal approach exactly; only accelerate
            -- the final vertical combat-hover descent. No cluster/root state is touched.
            self.AtCombatAnchor = false
            self.AtCombatTarget = nil
            local delta = targetPos - currentPos
            local direction = delta.Unit
            local speed = flySpeed
            -- v21.28: a skill dodge gets a short emergency burst but never creates
            -- another movement coroutine. The original owner/target remains intact.
            if stepNow < (self.DodgeSpeedUntil or 0) then
                speed = math.max(speed, tonumber(self.DodgeSpeed) or 0)
            end
            local decelDistance = math.max(8, tonumber(_G.Settings.NearMoveDecelDistance) or 18)
            if dist < decelDistance then
                local minNear = math.min(speed, tonumber(_G.Settings.NearMoveMinSpeed) or 110)
                speed = math.max(minNear, speed * (dist / decelDistance))
            end

            local horizontalDelta = Vector3.new(delta.X, 0, delta.Z)
            local horizontalDist = horizontalDelta.Magnitude
            local fastDescend = _G.Settings.FastDescendEnabled ~= false
                and isCombatHover
                and delta.Y < -(tonumber(_G.Settings.FastDescendMinGap) or 7)
                and horizontalDist <= (tonumber(_G.Settings.FastDescendRadius) or 70)

            if fastDescend then
                local horizontalVelocity = Vector3.zero
                if horizontalDist > 0.05 then
                    local factor = math.clamp(
                        tonumber(_G.Settings.FastDescendHorizontalFactor) or 0.82, 0, 1)
                    horizontalVelocity = horizontalDelta.Unit * (speed * factor)
                end
                local descendCap = math.max(speed,
                    tonumber(_G.Settings.FastDescendSpeed) or 380)
                local safeDt = math.max(stepDt, 1 / 60)
                local ySpeed = math.min(descendCap, math.abs(delta.Y) / safeDt)
                bv.Velocity = Vector3.new(
                    horizontalVelocity.X, -ySpeed, horizontalVelocity.Z)
            else
                bv.Velocity = direction * speed
            end
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
                    self.LastExitOwner = owner
                    self.LastExitReason = "Stuck"
                    self.LastExitToken = myToken
                    if owner == "Farm" or owner == "Raid" then
                        _G.State.IsRecovering = true
                    end
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
                self.LastExitOwner = owner
                self.LastExitReason = "ThreadError"
                self.LastExitToken = myToken
                if owner == "Farm" or owner == "Raid" then
                    _G.State.IsRecovering = true
                end
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


-- v21.13 SILENT ALWAYS-ON ARMAMENT HAKI. Never call Buso blindly.
local HakiController = {
    Character = nil,
    Enabled = false,
    ArmamentObservable = false,
    LastBusoRequest = 0,
    PendingBusoAt = 0,
    KenSent = false,
}

function HakiController:Reset()
    self.Character = nil
    self.Enabled = false
    self.ArmamentObservable = false
    self.LastBusoRequest = 0
    self.PendingBusoAt = 0
    self.KenSent = false
end

function HakiController:ReadArmamentState(character)
    if not character then return nil, false end
    local marker = character:FindFirstChild("HasBuso")
    if marker then
        if marker:IsA("BoolValue") then
            return marker.Value == true, true
        elseif marker:IsA("IntValue") or marker:IsA("NumberValue") then
            return tonumber(marker.Value) ~= 0, true
        end
        return true, true
    end
    local okAttr, attr = pcall(function() return character:GetAttribute("HasBuso") end)
    if okAttr and type(attr) == "boolean" then return attr, true end
    return nil, false
end

function HakiController:EnableForCharacter()
    local character = Char()
    if not character or not IsAlive() then return false end

    if self.Character ~= character then
        self.Character = character
        self.Enabled = false
        self.ArmamentObservable = false
        self.LastBusoRequest = 0
        self.PendingBusoAt = 0
        self.KenSent = false
    end

    local active, observableNow = self:ReadArmamentState(character)
    if observableNow then self.ArmamentObservable = true end
    if active == true then
        self.Enabled = true
        self.PendingBusoAt = 0
        if not self.KenSent then
            self.KenSent = true
            pcall(function() CommF_:InvokeServer("Ken", true) end)
        end
        return true
    end

    if self.ArmamentObservable then
        self.Enabled = false
    elseif self.Enabled then
        return true
    end

    local now = tick()
    local grace = math.max(0.20, tonumber(_G.Settings.ArmamentConfirmGrace) or 0.80)
    local cooldown = math.max(0.20, tonumber(_G.Settings.ArmamentRetryCooldown) or 0.45)
    if self.PendingBusoAt > 0 and now - self.PendingBusoAt < grace then return false end
    if now - (self.LastBusoRequest or 0) < cooldown then return false end

    self.LastBusoRequest = now
    self.PendingBusoAt = now
    local okBuso = pcall(function() CommF_:InvokeServer("Buso", true) end)
    if not self.ArmamentObservable and okBuso then self.Enabled = true end

    if not self.KenSent then
        self.KenSent = true
        pcall(function() CommF_:InvokeServer("Ken", true) end)
    end
    return okBuso
end

function HakiController:WatchTick()
    if not IsAlive() then return false end
    return self:EnableForCharacter()
end

-- v20.1 core ability purchases. These are baseline movement/haki abilities used
-- by mature kaitun configs. The probes are throttled, never own movement and the
-- server validates level/Beli/ownership before changing anything.
local CoreAbilityPurchaseController = { LastTry = 0 }
function CoreAbilityPurchaseController:Tick()
    if not _G.Settings.AutoCoreAbilities or not IsAlive() then return false end
    if _G.BobonEconomy and _G.BobonEconomy.Busy then return false end
    local now = tick()
    if now - (self.LastTry or 0) < (_G.Settings.CoreAbilityRetry or 45) then return false end
    self.LastTry = now
    pcall(function() CommF_:InvokeServer("BuyHaki", "Geppo") end)
    pcall(function() CommF_:InvokeServer("BuyHaki", "Buso") end)
    pcall(function() CommF_:InvokeServer("BuyHaki", "Soru") end)
    pcall(function() CommF_:InvokeServer("KenTalk", "Buy") end)
    return true
end

-- v22.6 passive race ability controller. Uses the currently exposed Blox Fruits
-- character/tool state and never claims ActionToken or MovementOwner.
local RaceAbilityController = {
    LastCheck = 0,
    LastV3 = 0,
    LastV4 = 0,
}

local function FireRemoteCompat(remote, ...)
    if not remote then return false end
    local args = {...}
    local ok = pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(table.unpack(args))
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(table.unpack(args))
        else
            error("unsupported remote")
        end
    end)
    return ok
end

function RaceAbilityController:TryV4(character, now)
    if _G.Settings.AutoRaceV4Ability == false then return false end
    if now - (self.LastV4 or 0) < (_G.Settings.RaceV4RetryCooldown or 4.0) then return false end
    local energy = character and character:FindFirstChild("RaceEnergy")
    local transformed = character and character:FindFirstChild("RaceTransformed")
    local energyValue = 0
    pcall(function() energyValue = energy and tonumber(energy.Value) or 0 end)
    local isTransformed = false
    pcall(function() isTransformed = transformed and transformed.Value == true or false end)
    if energyValue < 1 or not transformed or isTransformed then return false end

    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    local awakening = (character and character:FindFirstChild("Awakening"))
        or (backpack and backpack:FindFirstChild("Awakening"))
    local remote = awakening and awakening:FindFirstChild("RemoteFunction")
    if not remote then return false end
    self.LastV4 = now
    return FireRemoteCompat(remote, true)
end

function RaceAbilityController:TryV3(character, now)
    if _G.Settings.AutoRaceV3Ability == false then return false end
    if now - (self.LastV3 or 0) < (_G.Settings.RaceV3RetryCooldown or 4.0) then return false end
    -- If V4 is already transformed, V3 activation is unnecessary.
    local transformed = character and character:FindFirstChild("RaceTransformed")
    local isTransformed = false
    pcall(function() isTransformed = transformed and transformed.Value == true or false end)
    if isTransformed then return false end
    local remotes = RS:FindFirstChild("Remotes")
    local commE = remotes and remotes:FindFirstChild("CommE") or RS:FindFirstChild("CommE", true)
    if not commE then return false end
    self.LastV3 = now
    return FireRemoteCompat(commE, "ActivateAbility")
end

function RaceAbilityController:WatchTick()
    if not IsAlive() then return false end
    local now = tick()
    if now - (self.LastCheck or 0) < (_G.Settings.RaceAbilityCheckInterval or 0.35) then return false end
    self.LastCheck = now
    local character = Char()
    -- V4 gets first chance; if unavailable/not ready, V3 can still fire.
    if self:TryV4(character, now) then return true end
    return self:TryV3(character, now)
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

            -- v22.3 RAW DAMAGE IS NEVER A DODGE SIGNAL.
            -- We cannot reliably attribute one HealthChanged event to PvP vs an
            -- ordinary NPC contact swing, so raw HP loss is continuity-only.
            -- Skill dodge is armed exclusively by DodgeController's current-target
            -- animation/charge/hitbox/hazard evidence.
            if _G.Settings.DodgeOnRawDamage == true then
                local damageTarget = _G.State.CurrentTarget
                local enemies = workspace:FindFirstChild("Enemies")
                if damageTarget and enemies and damageTarget.Parent == enemies
                    and (_G.State.Mode == "Farming" or _G.State.Mode == "Bossing"
                        or _G.State.Mode == "GettingItem") then
                    _G.State.DamageDodgeTarget = damageTarget
                    _G.State.DamageDodgeUntil = tick() + (_G.Settings.DodgeDamageFallbackHold or 1.10)
                end
            else
                _G.State.DamageDodgeTarget = nil
                _G.State.DamageDodgeUntil = 0
            end

            if _G.Settings.EmergencySafetyEnabled ~= false then
                local maxHealth = tonumber(humanoid.MaxHealth) or 0
                local hpPct = maxHealth > 0 and (newHealth / maxHealth) * 100 or 100
                if hpPct <= (_G.Settings.EmergencyHealthPercent or 55) then
                    _G.State.FarmSafetyActive = true
                    _G.State.FarmSafetyUntil = math.max(_G.State.FarmSafetyUntil or 0,
                        tick() + (_G.Settings.EmergencyMinHold or 2.5))
                    if CombatController then
                        CombatController.DesiredClientRange = false
                        CombatController.ClientRetreatUntil = math.max(
                            CombatController.ClientRetreatUntil or 0,
                            _G.State.FarmSafetyUntil)
                    end
                end
            else
                _G.State.FarmSafetyActive = false
                _G.State.FarmSafetyUntil = 0
            end

            if _G.Settings.ContinuityMode then
                -- PvP/NPC contact/knockback/Stun/Busy cannot look like a stalled job.
                -- Preserve ActionToken, MovementOwner, CurrentTarget and combat backend.
                _G.State.LastMoveTime = os.time()
                _G.State.ConsecutiveFails = 0
                DLog("CONTINUITY", "raw incoming damage ignored; job+movement+target preserved")
            end
        end
        if _G.Settings.EmergencySafetyEnabled ~= false
            and _G.State.FarmSafetyActive and humanoid.MaxHealth > 0
            and (newHealth / humanoid.MaxHealth) * 100
                >= (_G.Settings.EmergencyResumePercent or 82)
            and tick() >= (_G.State.FarmSafetyUntil or 0) then
            _G.State.FarmSafetyActive = false
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
        _G.State.FarmSafetyUntil = 0
        _G.State.FarmSafetyActive = false
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
    if not _G.State:IsActionValid(token) or not IsAlive() then return false end

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
    local thresh = opts.arrivalThreshold or _G.Settings.CloseThreshold
    local retryCount = tonumber(opts.retries)
    if retryCount == nil then
        retryCount = (owner == "Farm" or owner == "Raid") and 0 or 2
    end
    retryCount = math.max(0, math.floor(retryCount))
    local perTryTimeout = math.max(3, tonumber(opts.timeout) or 60)

    for attempt = 1, retryCount + 1 do
        if not _G.State:IsActionValid(token) or not IsAlive() then return false end
        _G.State:TouchAction(token)

        local ok, travelToken = TravelManager:Request(cf, owner, opts)
        if ok then
            local deadline = tick() + perTryTimeout
            local arrived = false
            while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
                _G.State:TouchAction(token)
                local hrp = HRP()
                if hrp and (hrp.Position - destination).Magnitude <= thresh then
                    arrived = true
                    break
                end

                -- Do not sit for the full timeout after the movement coroutine has
                -- already reported a local progression failure. Retry this leg instead.
                if TravelManager.LastExitOwner == owner
                    and TravelManager.LastExitToken == travelToken then
                    break
                end
                if not _G.State.IsTraveling
                    and _G.State.MovementOwner ~= owner
                    and TravelManager.CurrentToken == travelToken then
                    break
                end
                task.wait(0.12)
            end

            if arrived then
                _G.State:TouchAction(token)
                local settleUntil = tick() + (opts.settle or 1)
                while _G.State:IsActionValid(token) and IsAlive() and tick() < settleUntil do
                    _G.State:TouchAction(token)
                    task.wait(0.08)
                end
                return _G.State:IsActionValid(token) and IsAlive()
            end
        end

        if attempt <= retryCount then
            if _G.State.IsTraveling and _G.State.MovementOwner == owner then
                TravelManager:Stop("TravelAndWaitRetry")
            end
            local root = HRP()
            if root then
                pcall(function()
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end)
            end
            _G.State:TouchAction(token)
            task.wait(math.min(0.45, 0.12 + attempt * 0.08))
        end
    end
    return false
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
--    v22.20 TARGET-LOCK SKILL-EFFECT DODGE — EMITTED EFFECT ONLY → ONE PULSE → RESUME
--   * Never scans unrelated nearby NPCs as threats; only the TravelManager active target.
--   * No generic Action-priority fallback: ordinary combat/idle animations cannot trigger dodge.
--   * A threat must be seen in consecutive monitor samples before movement changes.
--   * One evade vector is frozen for the cast. Replan only if the chosen evade pocket itself
--     becomes hazardous, preventing the left/right/behind zig-zag seen in Roblox(10).
--   * Attack CONTINUES while DodgeActive; only TravelManager receives a lateral offset.
-- ══════════════════════════════════════════════════════════════════
do
local DodgeController = {
    Active = false,
    StartedAt = 0,
    LastThreatAt = 0,
    LastDodgeAt = 0,
    LastReplanAt = 0,
    Threat = nil,
    ThreatRoot = nil,
    ThreatReason = nil,
    EvadeOffset = Vector3.zero,
    PendingKey = nil,
    PendingCount = 0,
    PendingAt = 0,
    CastTarget = nil,
    CastUntil = 0,
    HazardParts = setmetatable({}, {__mode="k"}),
    HazardMotion = setmetatable({}, {__mode="k"}),
}

-- v22.20: animation is only source-arming evidence. Animation alone NEVER moves the player.
local ATTACK_WORDS = {
    "skill","cast","blast","beam","wave","projectile","charge",
    "roar","stomp","slam","burst","explosion","shockwave",
    "vortex","tornado","laser","eruption","aoe",
    "slash","slice","cleave","swordwave","blade wave","cut",
}
-- Only explicit emitted skill/slash effect names are tracked. Generic Hitbox/Damage/Weapon
-- parts stay excluded so ordinary melee and Teddy acquire movement cannot fake a dodge.
local HARD_HAZARD_WORDS = {
    "projectile","beam","blast","explosion","shockwave","aoe",
    "vortex","tornado","laser","eruption",
    "slash","slice","cleave","swordwave","blade wave","cutwave","cut wave",
}

local function WordMatch(text, words)
    text = string.lower(tostring(text or ""))
    for _, word in ipairs(words) do
        if string.find(text, word, 1, true) then return true end
    end
    return false
end

local function ActiveCombatModel()
    if not _G.State.IsTraveling or not TravelManager.CurrentOptions
        or not TravelManager.CurrentOptions.combatHover then
        return nil
    end
    local ref = TravelManager.TargetRef
    if typeof(ref) ~= "Instance" then return nil end
    local model = ref:IsA("Model") and ref or ref:FindFirstAncestorOfClass("Model")
    local enemies = workspace:FindFirstChild("Enemies")
    if not model or not enemies or model.Parent ~= enemies then return nil end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not root then return nil end
    return model, root, hum
end

local function IsOurCharacterDescendant(obj)
    local c = Char()
    return c and obj and obj:IsDescendantOf(c) or false
end

-- v22.3: PvP/player VFX are never NPC-skill dodge evidence.
local function IsPlayerOwnedEffect(obj)
    local node = obj
    for _ = 1, 6 do
        if not node then break end
        if node:IsA("Model") and Players:GetPlayerFromCharacter(node) then
            return true
        end

        for _, key in ipairs({"Creator","creator","Owner","owner"}) do
            local marker = node:FindFirstChild(key)
            if marker and marker:IsA("ObjectValue") then
                local value = marker.Value
                if value and value:IsA("Player") then return true end
                if value and value:IsA("Model") and Players:GetPlayerFromCharacter(value) then
                    return true
                end
            end
        end

        local uid = node:GetAttribute("OwnerUserId")
            or node:GetAttribute("CreatorUserId")
            or node:GetAttribute("UserId")
        if type(uid) == "number" and uid > 0 then
            local okPlayer, player = pcall(function() return Players:GetPlayerByUserId(uid) end)
            if okPlayer and player then return true end
        end
        node = node.Parent
    end
    return false
end

local function FlatUnit(v, fallback)
    local flat = Vector3.new(v.X,0,v.Z)
    if flat.Magnitude > 0.05 then return flat.Unit end
    if fallback then
        local f = Vector3.new(fallback.X,0,fallback.Z)
        if f.Magnitude > 0.05 then return f.Unit end
    end
    return Vector3.new(1,0,0)
end

local function TrackHazard(obj, extraLabel)
    if not obj or not obj:IsA("BasePart")
        or IsOurCharacterDescendant(obj) or IsPlayerOwnedEffect(obj) then
        return
    end
    local target, targetRoot = ActiveCombatModel()
    local me = HRP()
    if not target or not targetRoot or not me then return end

    local ok, pos, size = pcall(function() return obj.Position, obj.Size end)
    if not ok or not IsValidPos(pos) then return end
    if (pos - me.Position).Magnitude > (_G.Settings.DodgeHazardTrackRadius or 82) then return end

    local label = tostring(obj.Name or "") .. " "
        .. tostring(obj.Parent and obj.Parent.Name or "") .. " "
        .. tostring(extraLabel or "")
    if not WordMatch(label, HARD_HAZARD_WORDS) then return end
    if math.max(size.X,size.Y,size.Z) < 0.45 then return end

    local enemies = workspace:FindFirstChild("Enemies")
    local effectModel = obj:FindFirstAncestorOfClass("Model")
    if effectModel and enemies and effectModel.Parent == enemies and effectModel ~= target then
        return
    end

    local now = tick()
    local sourceRadius = tonumber(_G.Settings.DodgeEffectSourceRadius) or 34
    local fromTarget = obj:IsDescendantOf(target)
    local spawnedAtTarget = (pos - targetRoot.Position).Magnitude <= sourceRadius
    local castArmed = DodgeController.CastTarget == target
        and now <= (tonumber(DodgeController.CastUntil) or 0)

    if not fromTarget and not spawnedAtTarget and not castArmed then return end
    if (pos - targetRoot.Position).Magnitude > (_G.Settings.DodgeTargetHazardRadius or 90)
        and not castArmed then
        return
    end

    DodgeController.HazardParts[obj] = now + (_G.Settings.DodgeHazardTTL or 0.85)
    DodgeController.HazardMotion[obj] = {
        Position = pos,
        At = now,
        Target = target,
    }
end

local hazardConn = workspace.DescendantAdded:Connect(function(obj)
    if not SessionAlive() then return end
    if obj:IsA("BasePart") then
        pcall(TrackHazard, obj)
    elseif obj:IsA("Beam") or obj:IsA("Trail") then
        local carrier = obj.Parent
        if carrier and carrier:IsA("Attachment") then carrier = carrier.Parent end
        if carrier and carrier:IsA("BasePart") then
            pcall(TrackHazard, carrier, tostring(obj.Name or "") .. " " .. obj.ClassName)
        end
    end
end)
BobonUIConnections[#BobonUIConnections+1] = hazardConn

local function NamedAttackAnimation(hum)
    local ok, tracks = pcall(function() return hum:GetPlayingAnimationTracks() end)
    if not ok or not tracks then return false,nil end
    for _, track in ipairs(tracks) do
        if track.IsPlaying then
            local name = tostring(track.Name or "")
            if WordMatch(name,ATTACK_WORDS) then return true,"animation:"..name end
        end
    end
    return false,nil
end

local function HazardTouchesPoint(part, point)
    if not part or not part.Parent then return false end
    local ok,pos,size=pcall(function() return part.Position,part.Size end)
    if not ok or not IsValidPos(pos) then return false end
    local radius=math.max(size.X,size.Y,size.Z)*0.5+(_G.Settings.DodgeHazardMargin or 6)
    return (point-pos).Magnitude<=radius
end

local function ActiveHazardNear(me, targetRoot)
    if not me or not targetRoot then return nil end
    local now = tick()
    local activeTarget = ActiveCombatModel()
    for part, expires in pairs(DodgeController.HazardParts) do
        if not part.Parent or now > expires then
            DodgeController.HazardParts[part] = nil
            DodgeController.HazardMotion[part] = nil
        else
            local motion = DodgeController.HazardMotion[part]
            if not motion or not motion.Target or motion.Target ~= activeTarget then
                DodgeController.HazardParts[part] = nil
                DodgeController.HazardMotion[part] = nil
            else
                local ok, pos, size, assemblyVel = pcall(function()
                    return part.Position, part.Size, part.AssemblyLinearVelocity
                end)
                if ok and IsValidPos(pos) then
                    local toPlayer = me.Position - pos
                    local distance = toPlayer.Magnitude
                    local touches = HazardTouchesPoint(part, me.Position)

                    local velocity = assemblyVel
                    if motion.Position and motion.At and now > motion.At + 0.008 then
                        local inferred = (pos - motion.Position) / math.max(now - motion.At, 0.008)
                        if inferred.Magnitude > velocity.Magnitude then velocity = inferred end
                    end
                    motion.Position = pos
                    motion.At = now

                    local incoming = false
                    local incomingRadius = tonumber(_G.Settings.DodgeIncomingRadius) or 38
                    local minSpeed = tonumber(_G.Settings.DodgeIncomingMinSpeed) or 7
                    if not touches and distance <= incomingRadius and velocity.Magnitude >= minSpeed then
                        local dir = velocity.Unit
                        local dot = distance > 0.01 and dir:Dot(toPlayer.Unit) or 1
                        local forward = toPlayer:Dot(dir)
                        local eta = forward / math.max(velocity.Magnitude, 0.01)
                        local lateral = (toPlayer - dir * math.max(forward, 0)).Magnitude
                        local hitRadius = math.max(size.X,size.Y,size.Z) * 0.5
                            + (_G.Settings.DodgeHazardMargin or 5)
                        incoming = forward >= 0
                            and dot >= (_G.Settings.DodgeIncomingDot or 0.22)
                            and eta <= (_G.Settings.DodgeIncomingLookahead or 0.58)
                            and lateral <= hitRadius + 4
                    end

                    if touches or incoming then return part end
                end
            end
        end
    end
    return nil
end

local function TargetThreat()
    local target, root, hum = ActiveCombatModel()
    local me = HRP()
    if not target or not root or not hum or not me then return nil,nil,nil end
    local dist = (root.Position - me.Position).Magnitude
    if dist > (_G.Settings.DodgeRadius or 46) then return nil,nil,nil end

    local anim = NamedAttackAnimation(hum)
    if anim then
        DodgeController.CastTarget = target
        DodgeController.CastUntil = tick() + (_G.Settings.DodgeCastArmTTL or 0.50)
    elseif DodgeController.CastTarget ~= target
        or tick() > (tonumber(DodgeController.CastUntil) or 0) then
        DodgeController.CastTarget = nil
        DodgeController.CastUntil = 0
    end

    -- Only a real emitted effect can move the player.
    -- Raw HP loss, Stun/Busy, NPC velocity, normal animation and permanent hitboxes are ignored.
    local hazard = ActiveHazardNear(me, root)
    if hazard then
        return target, root, "skill-effect:" .. tostring(hazard.Name or hazard.ClassName)
    end
    return nil,nil,nil
end

local function CandidateScore(worldPos,targetRoot)
    local score=(worldPos-targetRoot.Position).Magnitude
    local now=tick()
    for part,expires in pairs(DodgeController.HazardParts) do
        if part.Parent and now<=expires then
            local ok,pos,size=pcall(function() return part.Position,part.Size end)
            if ok and IsValidPos(pos) then
                local r=math.max(size.X,size.Y,size.Z)*0.5+(_G.Settings.DodgeHazardMargin or 6)
                score=math.min(score,(worldPos-pos).Magnitude-r)
            end
        end
    end
    return score
end

local function ChooseOffset(targetRoot)
    local me=HRP()
    if not me or not targetRoot then return Vector3.zero end
    local distance=math.clamp(tonumber(_G.Settings.DodgeDistance) or 20,12,30)
    local up=math.clamp(tonumber(_G.Settings.DodgeHeight) or 0,0,8)
    local away=FlatUnit(me.Position-targetRoot.Position,-targetRoot.CFrame.LookVector)
    local side=Vector3.new(-away.Z,0,away.X)
    local look=FlatUnit(targetRoot.CFrame.LookVector,-away)
    local vertical=Vector3.new(0,up,0)
    local candidates
    if _G.Settings.DodgeSideStepOnly ~= false then
        -- Prefer a pure left/right sidestep at the existing hover height.
        -- Tiny rear bias is only a fallback pocket if both sides overlap a hazard.
        candidates={
            side*distance+vertical,
            -side*distance+vertical,
            side*(distance*0.85)+away*(distance*0.20)+vertical,
            -side*(distance*0.85)+away*(distance*0.20)+vertical,
        }
    else
        candidates={
            side*distance+vertical,
            -side*distance+vertical,
            away*distance+vertical,
            -look*(distance*0.90)+vertical,
        }
    end
    local hoverBase=FarmPositionController:GetFarmPos(targetRoot.Parent,_G.Settings.FarmHeight or 22)
        or me.Position
    local best,bestScore=candidates[1],-math.huge
    for _,off in ipairs(candidates) do
        local p=hoverBase+off
        if IsAllowedWorldPosition(p) then
            local sc=CandidateScore(p,targetRoot)
            if sc>bestScore then best,bestScore=off,sc end
        end
    end
    return best
end

function DodgeController:Finish(reason)
    self.Active=false
    self.Threat=nil
    self.ThreatRoot=nil
    self.ThreatReason=nil
    self.EvadeOffset=Vector3.zero
    self.PendingKey=nil
    self.PendingCount=0
    _G.State.DodgeActive=false
    _G.State.DodgeThreatName=nil
    _G.State.DamageDodgeTarget = nil
    _G.State.DamageDodgeUntil = 0
    TravelManager:ClearDodgeOffset()
    _G.BobonDiagnostics.Dodge="CLEAR:"..tostring(reason or "safe")
    DLog("DODGE","confirmed safe → resume exact active target")
end

function DodgeController:Begin(enemy,root,why,now)
    if now-(self.LastDodgeAt or 0)<(_G.Settings.DodgeCooldown or 0.30) then return false end
    self.Active=true
    self.StartedAt=now
    self.LastThreatAt=now
    self.LastDodgeAt=now
    self.LastReplanAt=now
    self.Threat=enemy
    self.ThreatRoot=root
    self.ThreatReason=why
    self.EvadeOffset=ChooseOffset(root)
    self.PendingKey=nil
    self.PendingCount=0
    _G.State.DodgeActive=true
    _G.State.DodgeThreatName=enemy and enemy.Name or tostring(why or "skill")
    _G.BobonDiagnostics.Dodge=("EVADE:%s"):format(tostring(why or "skill"))
    return TravelManager:ApplyDodgeOffset(
        self.EvadeOffset,
        _G.Settings.DodgeSkillPulseTTL or 0.44,
        _G.Settings.DodgeEmergencySpeed or 380)
end

function DodgeController:TryDodge()
    if not _G.Settings.DodgeAttacks or not IsAlive() then
        if self.Active then
        local current = ActiveCombatModel()
        if current ~= self.Threat then
            self:Finish("target-changed")
            return false
        end

        if target and target == self.Threat then
            self.LastThreatAt = now
            self.ThreatReason = why or self.ThreatReason
        end

        local maxHold = _G.Settings.DodgeMaxHold or 0.68
        local minHold = _G.Settings.DodgeMinHold or 0.12
        local safeConfirm = _G.Settings.DodgeSafeConfirm or 0.12
        if now - self.StartedAt >= maxHold then
            self:Finish("pulse-complete")
            return true
        end
        if now - self.StartedAt >= minHold
            and now - self.LastThreatAt >= safeConfirm then
            self:Finish("effect-passed")
            return true
        end

        return true
    end

    if not target then
        self.PendingKey=nil
        self.PendingCount=0
        return false
    end

    local key=tostring(target).."|"..tostring(why)
    if self.PendingKey==key and now-(self.PendingAt or 0)<=0.20 then
        self.PendingCount=(self.PendingCount or 0)+1
    else
        self.PendingKey=key
        self.PendingCount=1
    end
    self.PendingAt=now
    if self.PendingCount < (_G.Settings.DodgeConfirmSamples or 2) then return false end
    return self:Begin(target,targetRoot,why,now)
end

task.spawn(function()
    while SessionAlive() do
        task.wait(_G.Settings.DodgeMonitorInterval or 0.05)
        pcall(function() DodgeController:TryDodge() end)
    end
end)
end -- v21.33 target-lock dodge lexical scope
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
_G.BobonSmartFarmWatch = {
    LastProgressAt=tick(), LastPos=nil, LastQuest="", LastTarget=nil, LastHP=nil, RetryCount=0,
}
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
            -- v21.39 SMART FARM STUCK: progress is any meaningful player movement,
            -- quest-text change, target change, or real target HP loss. First clear/retry
            -- the shared farm; only repeated verified no-progress asks HopManager later.
            if _G.Settings.SmartFarmStuckEnabled and _G.State.ActiveActionToken == 0 then
                local w = _G.BobonSmartFarmWatch
                local me = HRP()
                local target = _G.State.FarmTarget
                local hum = target and target:FindFirstChildOfClass("Humanoid")
                local pos = me and me.Position or nil
                local qtext = tostring(GetQuestText() or "")
                local hp = hum and hum.Health or nil
                local hardProgress = false
                local softProgress = false
                -- When a live target exists, merely circling around it is NOT progress.
                -- Quest text or real HP loss resets the failure streak. Target/search movement
                -- only gives a fresh grace window so our own retry does not instantly retrigger.
                if qtext ~= tostring(w.LastQuest or "") then hardProgress = true end
                if hp and w.LastHP and hp < w.LastHP - 0.01 then hardProgress = true end
                if target ~= w.LastTarget then softProgress = true end
                if not target and pos and w.LastPos and (pos - w.LastPos).Magnitude >= 12 then softProgress = true end
                if hardProgress then
                    w.LastProgressAt = tick()
                    w.RetryCount = 0
                elseif softProgress or not w.LastProgressAt then
                    w.LastProgressAt = tick()
                end
                w.LastPos = pos
                w.LastQuest = qtext
                w.LastTarget = target
                w.LastHP = hp

                local stall = tick() - (tonumber(w.LastProgressAt) or tick())
                if stall >= (tonumber(_G.Settings.SmartFarmStuckTimeout) or 40) then
                    w.RetryCount = (tonumber(w.RetryCount) or 0) + 1
                    w.LastProgressAt = tick()
                    _G.BobonStatus = ("Watchdog: Farm no progress • retry %d"):format(w.RetryCount)
                    pcall(function() ClusterFarmController:SharedRelease("SmartFarmStuck") end)
                    if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                        pcall(function() TravelManager:Stop("SmartFarmStuck") end)
                    end
                    pcall(function() _G.State:ClearTargets() end)
                    _G.State.FState = "SMART_STUCK_RETRY"
                    if _G.Settings.SmartFarmStuckHop
                        and w.RetryCount >= (tonumber(_G.Settings.SmartFarmStuckRetryLimit) or 3) then
                        _G.BobonFarmStuckHopRequested = true
                        w.RetryCount = 0
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
    LastMagnetTick = 0,
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
        _G.BobonSkipMagnetPinnedModels = setmetatable({}, {__mode="k"})
        self.LastMagnetTick = 0
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

function SkipRouteController:DirectMagnet(route, primary)
    if _G.Settings.SkipDirectMagnetEnabled == false then return 1, 1 end
    if not route or not primary or not primary.Parent then return 0, 0 end

    local folder = workspace:FindFirstChild("Enemies")
    local primaryHum = primary:FindFirstChildOfClass("Humanoid")
    local primaryRoot = primary:FindFirstChild("HumanoidRootPart")
    local me = HRP()
    if not folder or not primaryHum or primaryHum.Health <= 0
        or not primaryRoot or not primaryRoot.Parent or not me then
        return 0, 0
    end

    if type(_G.BobonSkipMagnetPinnedModels) ~= "table" then
        _G.BobonSkipMagnetPinnedModels = setmetatable({}, {__mode="k"})
    end
    local marks = _G.BobonSkipMagnetPinnedModels
    local now = tick()
    local interval = math.max(0.01, tonumber(_G.Settings.SkipDirectMagnetInterval) or 0.03)
    local ttl = math.max(0.08, tonumber(_G.Settings.SkipDirectMagnetPinnedTTL) or 0.18)
    local verifyRadius = math.max(20, tonumber(_G.Settings.SkipDirectMagnetVerifyRadius) or 55)
    local localRange = math.max(150, tonumber(_G.Settings.SkipDirectMagnetRange) or 700)
    local fieldRange = math.max(localRange, tonumber(_G.Settings.SkipDirectMagnetFieldRange) or 1300)

    local anchorPos = primaryRoot.Position
    local fieldPos = route.Fallback and route.Fallback.Position or anchorPos
    local total, pinned = 0, 0

    -- Count helper is intentionally repeated rather than creating a new top-level helper.
    local function allowedMob(mob)
        for _, wanted in ipairs(route.Names or {}) do
            if IsEnemyNamed(mob, wanted) then return true end
        end
        return false
    end

    -- Throttle writes, but keep reporting live counts between writes.
    if now - (self.LastMagnetTick or 0) < interval then
        for _, mob in ipairs(folder:GetChildren()) do
            if allowedMob(mob) then
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local root = mob:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root and root.Parent then
                    local ok, pos = pcall(function() return root.Position end)
                    if ok and IsValidPos(pos)
                        and ((pos-fieldPos).Magnitude <= fieldRange
                            or (pos-anchorPos).Magnitude <= localRange
                            or (pos-me.Position).Magnitude <= localRange) then
                        total = total + 1
                        if mob == primary or (marks[mob] or 0) > now then
                            pinned = pinned + 1
                        end
                    end
                end
            end
        end
        return pinned, total
    end
    self.LastMagnetTick = now

    -- Compatibility path used by classic public magnets. Any unsupported executor
    -- primitive is contained here and cannot terminate the kaitun.
    pcall(function() ExpandSimulationRadius() end)
    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(LP, "SimulationRadius", math.huge)
        end
    end)

    for _, mob in ipairs(folder:GetChildren()) do
        if allowedMob(mob) then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root and root.Parent and not root.Anchored then
                local okPre, prePos = pcall(function() return root.Position end)
                local inField = okPre and IsValidPos(prePos)
                    and ((prePos-fieldPos).Magnitude <= fieldRange
                        or (prePos-anchorPos).Magnitude <= localRange
                        or (prePos-me.Position).Magnitude <= localRange)
                if inField then
                    total = total + 1
                    if mob == primary then
                        marks[mob] = now + ttl
                        pinned = pinned + 1
                    else
                        -- No PlatformStand, no Sit, no BodyPosition: repeated CFrame only.
                        -- This avoids the statue/ghost state produced by frozen server-owned mobs.
                        pcall(function()
                            root.CanCollide = false
                            root.AssemblyLinearVelocity = Vector3.zero
                            root.AssemblyAngularVelocity = Vector3.zero
                            root.CFrame = CFrame.new(anchorPos)
                        end)

                        local okPost, postPos = pcall(function() return root.Position end)
                        if okPost and IsValidPos(postPos)
                            and (postPos-anchorPos).Magnitude <= verifyRadius then
                            marks[mob] = now + ttl
                            pinned = pinned + 1
                        else
                            marks[mob] = nil
                        end
                    end
                end
            end
        end
    end

    if _G.State then
        _G.State.ClusterPhase = "KILL"
        _G.State.ClusterPhaseVerified = pinned
        _G.State.ClusterPhaseTotal = total
        _G.State.ClusterLastCandidateCount = total
        _G.State.ClusterPrimary = primary
    end
    if _G.BobonDiagnostics then
        _G.BobonDiagnostics.Bring = ("SKIP-MAGNET %d/%d"):format(pinned,total)
        _G.BobonDiagnostics.BringCandidates = total
        _G.BobonDiagnostics.BringMoved = pinned
    end
    return pinned, total
end

function SkipRouteController:Run()
    -- v22.11.1: execute-safe direct magnet. This controller is deliberately
    -- compact and pcall-contained; if magnet writes are unsupported, normal
    -- movement/combat still continue instead of killing the whole script.
    local fastReady = CombatController:IsFastReady()
    if _G.BobonDiagnostics then
        _G.BobonDiagnostics.SkipBackend = fastReady and "FAST" or "BOOTSTRAP"
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
        DLog("SKIP", "Safe direct-magnet route selected: " .. tostring(route.Key))
    elseif Level() > (self.RouteStartLevel or 0) then
        self.RouteStartLevel = Level()
        self.RouteStartTime = os.time()
    end

    if self.RouteStartTime and os.time() - self.RouteStartTime
        > (_G.Settings.SkipRouteFallbackTimeout or 90) then
        self:Reset("skip made no level progress")
        DLog("SKIP", "Safe direct magnet stalled -> normal quest fallback")
        return false
    end

    if HasQuest() == true then
        pcall(function() CommF_:InvokeServer("AbandonQuest") end)
        _G.State.ActiveQuestMob = nil
    end

    _G.State:SetMode("Farming")
    _G.State.FState = "SKIP_FARM"

    -- v22.17: early skip uses the exact same Teddy sequence engine as normal farm.
    -- No separate magnet and no moving pile.
    if _G.Settings.TeddySequenceMode ~= false then
        local skipName = route.Names and route.Names[1] or tostring(route.Display)
        _G.State.ActiveQuestMob = skipName
        return ClusterFarmController:TeddySequenceFarmTick(skipName, route.Fallback, "Skip")
    end
    if _G.Settings.TeddyAirSweepMode ~= false then
        local skipName = route.Names and route.Names[1] or tostring(route.Display)
        _G.State.ActiveQuestMob = skipName
        return ClusterFarmController:TeddyAirFarmTick(skipName, route.Fallback, "Skip")
    end

    -- Preserve a real primary until death so the pile does not jump between mobs.
    local target, targetName = nil, nil
    local old = _G.State.FarmTarget
    if old and old.Parent and _G.State:IsTargetValid(old) then
        for _, wanted in ipairs(route.Names or {}) do
            if IsEnemyNamed(old, wanted) then
                target, targetName = old, wanted
                break
            end
        end
    end
    if not target then
        target, targetName = self:FindTarget(route)
    end

    if not target then
        _G.State.FarmTarget = nil
        _G.State.CurrentTarget = nil
        _G.BobonSkipMagnetPinnedModels = setmetatable({}, {__mode="k"})
        _G.BobonStatus = "Skip: Waiting " .. tostring(route.Display)
        if route.Fallback and _G.State:CanRequestTravel() then
            TravelManager:Request(route.Fallback * CFrame.new(0, _G.Settings.FarmHeight or 22, 0), "Farm", {
                arrivalThreshold = _G.Settings.ClusterFieldPatrolArrival or 18,
                fallback = route.Fallback,
                combatHover = true,
                persistent = false,
                speed = _G.Settings.SkipTravelSpeed or 360,
            })
        end
        return true
    end

    local hum = target:FindFirstChildOfClass("Humanoid")
    local root = target:FindFirstChild("HumanoidRootPart")
    local me = HRP()
    if not hum or hum.Health <= 0 or not root or not root.Parent or not me then
        _G.State.FarmTarget = nil
        _G.State.CurrentTarget = nil
        return true
    end

    _G.State.FarmTarget = target
    _G.State.CurrentTarget = target
    _G.State.ActiveQuestMob = targetName or (route.Names and route.Names[1])

    -- v22.12: Skip no longer has a separate magnet implementation. It uses the
    -- exact same classic BN SharedBring engine as normal level farm.
    local pinned, total = 1, 1
    _G.State.FState = "SHARED_BRING_FARM"
    if _G.Settings.GatherMobs ~= false then
        local okBring, countOrErr = pcall(function()
            return ClusterFarmController:SharedBring(
                targetName or route.Names[1],
                root.CFrame,
                route.Fallback,
                target
            )
        end)
        if okBring then
            pinned = tonumber(countOrErr) or 1
            total = tonumber(_G.BobonDiagnostics and _G.BobonDiagnostics.BringCandidates) or pinned
        else
            DLog("SKIP-BN", "contained error: " .. tostring(countOrErr))
        end
    end

    local display = tostring(route.Display or targetName or (route.Names and route.Names[1]) or "Skip Mob")
    if total > 1 and pinned < total then
        _G.BobonStatus = ("Skip: BN bring %s (%d/%d)"):format(display,pinned,total)
    else
        _G.BobonStatus = ("Skip: Attacking pile %s (%d/%d)"):format(display,pinned,total)
    end

    PrepareCombatTarget(target)

    local hoverHeight = tonumber(_G.Settings.FarmHeight) or 22
    local skipAnchorPos = (_G.Settings.SharedTeddyMode ~= false and ClusterFarmController.SharedPileCFrame)
        and ClusterFarmController.SharedPileCFrame.Position or root.Position
    local hoverCF = CFrame.new(skipAnchorPos) * CFrame.new(0, hoverHeight, 0)
    if _G.State:CanRequestTravel() then
        TravelManager:Request(hoverCF, "Farm", {
            arrivalThreshold = _G.Settings.FarmArrivalThreshold,
            fallback = route.Fallback,
            combatHover = true,
            persistent = true,
            speed = _G.Settings.SkipTravelSpeed or 360,
        })
    end

    me = HRP()
    if not me or not root.Parent then return true end
    local okPos, targetPos = pcall(function() return root.Position end)
    if not okPos or not IsValidPos(targetPos) then return true end

    local range = fastReady
        and (_G.Settings.FastAttackRange or _G.Settings.AttackRange or 100)
        or math.max(_G.Settings.AttackRange or 20, 40)
    local distance = (me.Position-targetPos).Magnitude
    local farmHolds = not _G.State.IsTraveling or _G.State.MovementOwner == "Farm"
    if distance <= range and farmHolds then
        _G.State.FState = "SHARED_ATTACK"
        EquipCombatTool()
        Attack(target, route.Names[1])
    else
        _G.State.FState = "SHARED_BRING_FARM"
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
    LastPurchaseProbe = 0,
    LastStatus = "idle",
    SanguineKnownOwned = false,
    KnownPurchased = {},
    PurchaseFailStreak = 0,
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
    if _G.State then
        _G.State.ObjectiveText = "Full Melee / Combat Style"
        _G.State.ObjectiveProgress = tostring(self.LastStatus)
    end
    DLog("STYLE", "Preferred=" .. tostring(name) .. " | " .. tostring(self.LastStatus))
end

function FightingStyleController:Mastery(value)
    local names = type(value) == "table" and value or {value}
    local best, bestName = 0, names[1]
    for _, name in ipairs(names) do
        local m = EffectiveMastery(name)
        if m > best then best, bestName = m, name end
    end
    return best, bestName
end

function FightingStyleController:Live(value)
    local names = type(value) == "table" and value or {value}
    for _, name in ipairs(names) do
        if FindOwnedTool(name) then return true, name end
    end
    return false, nil
end

function FightingStyleController:Known(value)
    local names = type(value) == "table" and value or {value}
    for _, name in ipairs(names) do
        if FindOwnedTool(name) or EffectiveMastery(name) > 0 or self.KnownPurchased[name] then
            return true, name
        end
    end
    return false, nil
end

function FightingStyleController:MarkKnown(value)
    local names = type(value) == "table" and value or {value}
    for _, name in ipairs(names) do self.KnownPurchased[name] = true end
    InventoryCache.At = 0
    WeaponInventoryCache.At = 0
end


-- v21.29: never treat a successful RemoteFunction invocation as proof that a style
-- was purchased.  The server can return normally while refusing for money/mastery/key.
-- Only a live tool, authoritative inventory/mastery, or a real currency decrease proves it.
function FightingStyleController:ActualOwned(value, forceRefresh)
    local names = type(value) == "table" and value or {value}
    if forceRefresh then
        WeaponInventoryCache.At = 0
    end
    for _, name in ipairs(names) do
        -- Do NOT use generic getInventory here.  Public current kaitun implementations
        -- verify fighting styles from the live Tool/mastery path; treating an inventory
        -- catalog row as ownership can make BuyBlackLeg/BuyElectro never fire.
        if FindOwnedTool(name) then return true, name end
        if EffectiveMastery(name) > 0 then return true, name end
        if self.KnownPurchased[name] then return true, name end
    end
    return false, nil
end

function FightingStyleController:RestoreHeldTool(name)
    if type(name) ~= "string" or name == "" then return end
    local c = Char()
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    local tool = FindOwnedTool(name)
    if not c or not hum or not tool or tool.Parent == c then return end
    pcall(function() hum:EquipTool(tool) end)
end

function FightingStyleController:VerifyPurchase(value, beforeBeli, beforeFragments, seconds)
    local deadline = tick() + (seconds or 1.10)
    repeat
        WeaponInventoryCache.At = 0
        local owned, ownedName = self:ActualOwned(value, false)
        if owned then return true, ownedName end
        task.wait(0.10)
    until tick() >= deadline or not SessionAlive() or not IsAlive()
    return false, nil
end

function FightingStyleController:Reequip(value, remote)
    local names = type(value) == "table" and value or {value}
    local live, liveName = self:Live(names)
    if live then return true, liveName end
    if tick() - (self.LastProbe or 0) < 0.80 then return false, nil end
    self.LastProbe = tick()
    if remote == "DragonClaw" then
        pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","1") end)
        pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end)
    elseif remote == "BuySharkmanKarate" then
        InvokeStyle(remote, true); InvokeStyle(remote)
    elseif remote == "BuyDragonTalon" then
        InvokeStyle(remote, true); InvokeStyle(remote)
    elseif remote == "BuyGodhuman" then
        InvokeStyle(remote, true); InvokeStyle(remote)
    elseif remote == "BuySanguineArt" then
        InvokeStyle(remote, true); InvokeStyle(remote)
    else
        InvokeStyle(remote)
    end
    task.wait(0.08)
    return self:Live(names)
end

-- Purchase every fighting style as soon as its real currency/prerequisites permit.
-- This is deliberately independent from mastery training: buying Dark Step at 150k
-- must not wait for Saber/quest windows, and already-purchased styles may be re-equipped
-- by their normal server endpoint without paying again.
function FightingStyleController:PurchaseTick()
    if not _G.Settings.AutoFightingStyles or not _G.Settings.AutoBuyMelee or not IsAlive() then return false end
    -- Pure purchase probes own no movement and are allowed during Saber/quest actions.
    -- Preserve any quest tool (Torch/Cup/Relic/Key) and put it back after a purchase.
    if tick() - (self.LastPurchaseProbe or 0) < (_G.Settings.MeleePurchaseInterval or 0.20) then return false end

    local c = Char()
    local held = c and c:FindFirstChildOfClass("Tool")
    local heldName = held and held.Name or nil

    local function beginPurchase(label)
        self.LastPurchaseProbe = tick()
        _G.BobonEconomy.LastMeleeAttempt = self.LastPurchaseProbe
        if _G.BobonEconomy then
            -- v21.37: direct purchase remotes own NO movement. A rejected/ambiguous
            -- BuyBlackLeg/BuyElectro/etc. must never stop an active Farm travel.
            _G.BobonEconomy:Notice("MELEE → " .. tostring(label), 2.2)
        end
    end

    local function finishPurchase(value, label, beforeBeli, beforeFragments)
        local verified = self:VerifyPurchase(value, beforeBeli, beforeFragments, 1.10)
        self:RestoreHeldTool(heldName)
        if verified then
            self.PurchaseFailStreak = 0
            self:MarkKnown(value)
            _G.BobonStatus = "Melee: Bought/claimed " .. tostring(label)
            _G.BobonEconomy:Notice("MELEE ✓ " .. tostring(label), 3.0)
            DLog("STYLE", "Verified purchase: " .. tostring(label))
            return true
        end
        self.PurchaseFailStreak = (tonumber(self.PurchaseFailStreak) or 0) + 1
        local backoff = math.min(20, 3 + self.PurchaseFailStreak * 2)
        -- LastPurchaseProbe may intentionally be in the future. PurchaseTick's
        -- existing interval guard then becomes a zero-extra-local retry gate.
        self.LastPurchaseProbe = tick() + backoff
        _G.BobonEconomy:Notice(("MELEE → retry %s in %ds")
            :format(tostring(label), backoff), math.min(backoff, 4))
        DLog("STYLE", "Purchase probe not verified: " .. tostring(label)
            .. " | backoff=" .. tostring(backoff))
        return false
    end

    local function buySimple(names, money, remote, label)
        if self:ActualOwned(names, false) then return false end
        if Beli() < money then return false end
        beginPurchase(label)
        local before = Beli()
        local callOk, callResult = InvokeStyle(remote)
        _G.BobonEconomy:Notice(("MELEE %s • remote=%s • result=%s")
            :format(tostring(label), tostring(callOk), tostring(callResult)), 2.0)
        return finishPurchase(names, label, before, nil)
    end

    -- V1 styles: buy the instant Beli reaches the real fixed purchase requirement.
    if buySimple({"Dark Step","Black Leg"},150000,"BuyBlackLeg","Dark Step") then return true end
    if buySimple({"Electric","Electro"},500000,"BuyElectro","Electric") then return true end
    if buySimple({"Water Kung Fu","Fishman Karate"},750000,"BuyFishmanKarate","Water Kung Fu") then return true end

    -- Dragon Breath uses fragments, not Beli.  Do not mark it owned from pcall alone.
    if not self:ActualOwned({"Dragon Breath","Dragon Claw"}, false) and GetSea() >= 2
        and CanSpendFragments(1500,"Full Melee: Dragon Breath",100) then
        beginPurchase("Dragon Breath")
        local beforeFrag = Fragments()
        pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","1") end)
        pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end)
        if finishPurchase({"Dragon Breath","Dragon Claw"}, "Dragon Breath", nil, beforeFrag) then return true end
    end

    local darkM = self:Mastery({"Dark Step","Black Leg"})
    local electroM = self:Mastery({"Electric","Electro"})
    local waterM = self:Mastery({"Water Kung Fu","Fishman Karate"})
    local dragonM = self:Mastery({"Dragon Breath","Dragon Claw"})

    if not self:ActualOwned("Superhuman", false) and darkM >= 300 and electroM >= 300
        and waterM >= 300 and dragonM >= 300 and Beli() >= 3000000 then
        beginPurchase("Superhuman")
        local before = Beli()
        InvokeStyle("BuySuperhuman")
        if finishPurchase("Superhuman", "Superhuman", before, nil) then return true end
    end

    -- V2 styles: query/probe immediately when their currency/mastery requirement is met.
    -- If a first-time key/quest is still required, verification fails harmlessly and the
    -- dedicated unlock controller performs that prerequisite later.
    if GetSea() >= 2 and darkM >= 400 and not self:ActualOwned("Death Step", false)
        and Beli() >= 2500000 and CanSpendFragments(5000,"Full Melee: Death Step",100) then
        beginPurchase("Death Step"); local before = Beli(); local beforeFrag = Fragments()
        InvokeStyle("BuyDeathStep",true); InvokeStyle("BuyDeathStep")
        if finishPurchase("Death Step", "Death Step", before, beforeFrag) then return true end
    end

    if GetSea() >= 2 and waterM >= 400 and not self:ActualOwned("Sharkman Karate", false)
        and Beli() >= 2500000 and CanSpendFragments(5000,"Full Melee: Sharkman Karate",100) then
        beginPurchase("Sharkman Karate"); local before = Beli(); local beforeFrag = Fragments()
        InvokeStyle("BuySharkmanKarate",true); InvokeStyle("BuySharkmanKarate")
        if finishPurchase("Sharkman Karate", "Sharkman Karate", before, beforeFrag) then return true end
    end

    if GetSea() == 3 and electroM >= 400 and not self:ActualOwned("Electric Claw", false)
        and Beli() >= 3000000 and CanSpendFragments(5000,"Full Melee: Electric Claw",100) then
        beginPurchase("Electric Claw"); local before = Beli(); local beforeFrag = Fragments()
        local _, state = InvokeStyle("BuyElectricClaw", true)
        -- state==4 means Previous Hero quest is still required; do not fake success.
        if state ~= 4 then InvokeStyle("BuyElectricClaw") end
        if finishPurchase("Electric Claw", "Electric Claw", before, beforeFrag) then return true end
    end

    if GetSea() == 3 and dragonM >= 400 and (FindOwnedTool("Fire Essence") or InventoryHas("Fire Essence"))
        and not self:ActualOwned("Dragon Talon", false) and Beli() >= 3000000
        and CanSpendFragments(5000,"Full Melee: Dragon Talon",100) then
        beginPurchase("Dragon Talon"); local before = Beli(); local beforeFrag = Fragments()
        InvokeStyle("BuyDragonTalon",true); InvokeStyle("BuyDragonTalon")
        if finishPurchase("Dragon Talon", "Dragon Talon", before, beforeFrag) then return true end
    end

    local superM = self:Mastery("Superhuman")
    local deathM = self:Mastery("Death Step")
    local sharkM = self:Mastery("Sharkman Karate")
    local clawM = self:Mastery("Electric Claw")
    local talonM = self:Mastery("Dragon Talon")
    if GetSea() == 3 and not self:ActualOwned("Godhuman", false)
        and superM >= 400 and deathM >= 400 and sharkM >= 400 and clawM >= 400 and talonM >= 400
        and Beli() >= 5000000 and CanSpendFragments(5000,"Full Melee: Godhuman",110)
        and MaterialCount("Fish Tail") >= 20 and MaterialCount("Magma Ore") >= 20
        and MaterialCount("Mystic Droplet") >= 10 and MaterialCount("Dragon Scale") >= 10 then
        beginPurchase("Godhuman"); local before = Beli(); local beforeFrag = Fragments()
        InvokeStyle("BuyGodhuman",true); InvokeStyle("BuyGodhuman")
        if finishPurchase("Godhuman", "Godhuman", before, beforeFrag) then return true end
    end

    if GetSea() == 3 and not self:ActualOwned("Sanguine Art", false) and Beli() >= 5000000
        and CanSpendFragments(5000,"Full Melee: Sanguine Art",105)
        and MaterialCount("Leviathan Heart") >= 1 and MaterialCount("Dark Fragment") >= 2
        and MaterialCount("Demonic Wisp") >= 20 and MaterialCount("Vampire Fang") >= 20 then
        beginPurchase("Sanguine Art"); local before = Beli(); local beforeFrag = Fragments()
        InvokeStyle("BuySanguineArt",true); InvokeStyle("BuySanguineArt")
        if finishPurchase("Sanguine Art", "Sanguine Art", before, beforeFrag) then
            self.SanguineKnownOwned = true
            return true
        end
    end
    return false
end

function FightingStyleController:Tick()
    if not _G.Settings.AutoFightingStyles or not _G.Settings.AutoBuyMelee or not IsAlive() then
        _G.State.PreferredCombatTool = nil
        return false
    end
    if _G.State.ActiveActionToken ~= 0 then return false end
    if FindOwnedTool("Sanguine Art") or InventoryHas("Sanguine Art") then self.SanguineKnownOwned = true end

    local function train(names, target, remote, label)
        local mastery = self:Mastery(names)
        if mastery >= target then return false end
        local live, liveName = self:Live(names)
        if not live then
            local known = self:Known(names)
            if not known then return false end
            self:Reequip(names, remote)
            live, liveName = self:Live(names)
        end
        if live and liveName then
            self:SetPreferred(liveName, ("Mastery %s %d/%d"):format(label or liveName, mastery, target))
            return true
        end
        return false
    end

    -- Superhuman chain: all four V1 styles to 300.
    if train({"Dark Step","Black Leg"},300,"BuyBlackLeg","Dark Step") then return true end
    if train({"Electric","Electro"},300,"BuyElectro","Electric") then return true end
    if train({"Water Kung Fu","Fishman Karate"},300,"BuyFishmanKarate","Water Kung Fu") then return true end
    if train({"Dragon Breath","Dragon Claw"},300,"DragonClaw","Dragon Breath") then return true end
    if train("Superhuman",400,"BuySuperhuman","Superhuman") then return true end

    -- Godhuman chain: raise the four bases to 400, then every V2 to 400.
    if train({"Dark Step","Black Leg"},400,"BuyBlackLeg","Dark Step") then return true end
    if train({"Electric","Electro"},400,"BuyElectro","Electric") then return true end
    if train({"Water Kung Fu","Fishman Karate"},400,"BuyFishmanKarate","Water Kung Fu") then return true end
    if train({"Dragon Breath","Dragon Claw"},400,"DragonClaw","Dragon Breath") then return true end
    if train("Death Step",400,"BuyDeathStep","Death Step") then return true end
    if train("Sharkman Karate",400,"BuySharkmanKarate","Sharkman Karate") then return true end
    if train("Electric Claw",400,"BuyElectricClaw","Electric Claw") then return true end
    if train("Dragon Talon",400,"BuyDragonTalon","Dragon Talon") then return true end

    if self:Known("Godhuman") then
        self:Reequip("Godhuman","BuyGodhuman")
        self:SetPreferred("Godhuman","Godhuman ready")
    end
    return false
end

-- ══════════════════════════════════════════════════════════════════
--   v19.0 KAITUN-ONLY SWORD PROGRESSION — TRUE TRIPLE KATANA
--   No random Beli-shop sword sweep. Only TTK prerequisites and the
--   existing kaitun item/progression swords remain; no fake inventory state.
-- ══════════════════════════════════════════════════════════════════
local SwordProgressionController = {
    LastLegendaryProbe = 0,
    LastLegendarySuccessAt = 0,
    LastLegendaryFailedAt = 0,
    LegendaryFailStreak = 0,
    LastTTKProbe = 0,
    LastStatus = "idle",
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

function SwordProgressionController:GetMissingLegendary()
    local missing = {}
    for index, aliases in ipairs(LegendarySwordAliases) do
        if not InventoryHasAny(aliases) then
            missing[#missing + 1] = {Index=index, Aliases=aliases, Label=aliases[#aliases] or aliases[1]}
        end
    end
    return missing
end

function SwordProgressionController:TryLegendaryDealer()
    if not _G.Settings.AutoBuySwords or GetSea() ~= 2 or Level() < 850 then return false end
    local missing = self:GetMissingLegendary()
    if #missing == 0 or Beli() < 2000000 then return false end
    if tick() - self.LastLegendaryProbe < (_G.Settings.LegendarySwordProbe or 8) then return false end
    if not _G.BobonEconomy:TryBegin("TTK") then return false end
    self.LastLegendaryProbe = tick()
    _G.BobonEconomy:PauseFarm("TTK • Legendary Sword Dealer", 1.25)

    local labels = {}
    for _, row in ipairs(missing) do labels[#labels + 1] = tostring(row.Label) end
    self.LastStatus = "TTK • Missing " .. table.concat(labels, "/")
    _G.BobonStatus = self.LastStatus
    _G.BobonEconomy:Notice(self.LastStatus, 2.0)
    DLog("SWORD", self.LastStatus)

    local beforeMissing = #missing
    local beforeBeli = Beli()
    local acquired = false
    for _, choice in ipairs({"1","2","3"}) do
        pcall(function() CommF_:InvokeServer("LegendarySwordDealer", choice) end)
        task.wait(0.08)
        self:InvalidateInventory()
        local after = self:GetMissingLegendary()
        if #after < beforeMissing or Beli() < beforeBeli then
            acquired = true
            break
        end
    end

    if acquired then
        self.LastLegendarySuccessAt = tick()
        self.LastLegendaryFailedAt = 0
        self.LegendaryFailStreak = 0
        self.LastStatus = "TTK • Legendary sword acquired"
        _G.BobonStatus = self.LastStatus
        _G.BobonEconomy:Notice(self.LastStatus, 3.0)
        DLog("SWORD", self.LastStatus)
    else
        self.LastLegendaryFailedAt = tick()
        self.LegendaryFailStreak = (self.LegendaryFailStreak or 0) + 1
    end
    _G.BobonEconomy:End("TTK")
    return acquired
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
    if not _G.BobonEconomy:TryBegin("TTK") then return false end
    self.LastTTKProbe = tick()
    _G.BobonEconomy:PauseFarm("TTK • True Triple Katana", 1.50)
    _G.BobonEconomy:Notice("TTK → purchase", 2.0)

    pcall(function() CommF_:InvokeServer("MysteriousMan", "1") end)
    pcall(function() CommF_:InvokeServer("MysteriousMan", "2") end)
    task.wait(0.35)
    self:InvalidateInventory()
    local verified = InventoryHas("True Triple Katana") == true
    self.LastStatus = verified and "TTK ✓ acquired" or "TTK • purchase not verified"
    _G.BobonStatus = self.LastStatus
    _G.BobonEconomy:Notice(self.LastStatus, verified and 4.0 or 2.5)
    DLog("SWORD", self.LastStatus)
    _G.BobonEconomy:End("TTK")
    return verified
end

function SwordProgressionController:Tick()
    if not _G.Settings.AutoBuySwords or not IsAlive() then return false end
    if _G.State.ActiveActionToken ~= 0 then return false end

    -- Kaitun-only sword work: do NOT buy random shop swords.
    -- Keep the TTK prerequisite chain because it is an explicit kaitun goal.
    -- Training never owns movement: normal quest/cluster farm supplies the kills.
    local missing = self:GetMissingLegendary()
    if #missing > 0 and GetSea() == 2 and Level() >= 850 then
        local labels = {}
        for _, row in ipairs(missing) do labels[#labels + 1] = tostring(row.Label) end
        self.LastStatus = "TTK • Missing " .. table.concat(labels, "/")
    end
    self:TryLegendaryDealer()
    if self:TrainTTKPrerequisite() then return true end
    self:TryTrueTripleKatana()
    return false
end

-- v21.35: removed the old independent 3-second melee/sword worker.
-- Passive mastery selection + TTK probes are executed by the one Priority Scheduler.


-- v21.33: purchase execution moved to the SINGLE ECONOMY WORKER after FruitManager.
-- This prevents Melee and Gacha from spending Beli concurrently.

-- ══════════════════════════════════════════════════════════════════
--     AUTO ITEMS + SEA PROGRESSION v16.1 (GIỮ NGUYÊN + FIX-P8/P9)
--   ActionToken system: ClaimAction → IsActionValid → ReleaseAction
--   Mọi subsystem check token trước MỌI operation
--   ReleaseAction LUÔN được gọi trong finally block (xpcall)
--   Death/Recovery invalidate token → subsystem tự dừng
-- ══════════════════════════════════════════════════════════════════
local MaterialPrepController
local FightingStyleUnlockController
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
    -- Useful kaitun collection: progression weapons + the small set explicitly kept
    -- by the project. This is not a buy-every-shop-sword completionist sweep.
    {Name="Saber",Sea=1,MinLevel=200,Method="Puzzle+Boss",Auto="CheckSaber"},
    {Name="Pole (1st Form)",Sea=1,MinLevel=575,Method="Thunder God",Auto="CheckPoleV1"},
    {Name="Kabucha",Sea=2,MinLevel=700,Method="1,500 fragments",Auto="CheckKabucha"},
    {Name="Rengoku",Sea=2,MinLevel=1100,Method="Hidden Key + Awakened Ice Admiral",Auto="CheckRengoku"},
    {Name="Dragon Trident",Sea=2,MinLevel=1475,Method="Tide Keeper drop",Auto="BossDrop"},
    {Name="Gravity Blade",Sea=2,MinLevel=925,Method="Orbitus drop",Auto="BossDrop"},
    {Name="Midnight Blade",Sea=2,MinLevel=1000,Method="100 Ectoplasm",Auto="CheckMidnightBlade"},
    {Name="Acidum Rifle",Sea=2,MinLevel=700,Method="Factory Core",Auto="CheckAcidumRifle"},
    {Name="Yama",Sea=3,MinLevel=1500,Method="CDK prerequisite",Auto="CheckYama"},
    {Name="Tushita",Sea=3,MinLevel=2000,Method="CDK prerequisite",Auto="CheckTushita"},
    {Name="Cursed Dual Katana",Sea=3,MinLevel=2200,Method="Yama/Tushita + scroll trials",Auto="CheckCDK"},
    {Name="Skull Guitar",Sea=3,MinLevel=2300,Method="Full Moon puzzle + materials",Auto="CheckSoulGuitar"},
    {Name="True Triple Katana",Sea=2,MinLevel=850,Method="3 Legendary swords + mastery",Auto="SwordProgression"},
    {Name="Godhuman",Sea=3,MinLevel=1500,Method="style mastery + materials",Auto="FightingStyles"},
    {Name="Sanguine Art",Sea=3,MinLevel=2400,Method="Leviathan Heart + materials",Auto="FightingStyles"},
}

function ItemProgression:GetMissingCatalog()
    local missing = {}
    for _, item in ipairs(ItemCatalog) do
        local owned = InventoryHas(item.Name)
        if item.Name == "Skull Guitar" then
            owned = owned or InventoryHas("Soul Guitar")
        end
        if Level() >= item.MinLevel and not owned then
            missing[#missing + 1] = item
        end
    end
    return missing
end

local function PrepareClaimedAction(owner)
    -- ClaimAction protects logical work; movement ownership is independent.
    -- v22 saves the farm context for diagnostics/resume, then performs an atomic
    -- handoff. There is still only one movement owner.
    if _G.State then
        _G.State.ResumeQuestMob = _G.State.ActiveQuestMob
        _G.State.ResumeFarmCFrame = _G.State.FarmTarget and _G.State.FarmTarget:FindFirstChild("HumanoidRootPart")
            and _G.State.FarmTarget.HumanoidRootPart.CFrame or nil
        _G.State.LastAtomicOwner = tostring(owner or "Action")
    end
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
    if not self:OptionalReady("Saber") then return false end

    local myToken = _G.State:ClaimAction("Saber")
    if myToken == 0 then return false end
    PrepareClaimedAction("Saber")
    self.NextOptional.Saber = tick() + 4
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Saber • checking saved puzzle stage"

    task.spawn(function()
        local ok, err = xpcall(function()
            local function TouchAction()
                return _G.State:TouchAction(myToken)
            end

            local function Invoke(...)
                local args = {...}
                local success, result = pcall(function()
                    return CommF_:InvokeServer(table.unpack(args))
                end)
                TouchAction()
                return success, result
            end

            local function HasSaber()
                InventoryCache.At = 0
                WeaponInventoryCache.At = 0
                return FindOwnedTool("Saber") ~= nil or InventoryHas("Saber")
            end

            local function EquipNamed(name)
                local c = Char()
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                local tool = FindOwnedTool(name)
                if not tool or not hum then return false end
                if tool.Parent ~= c then
                    pcall(function() hum:EquipTool(tool) end)
                    task.wait(0.18)
                end
                TouchAction()
                return tool.Parent == c
            end

            local function WaitTool(name, seconds)
                local deadline = tick() + (seconds or 6)
                while _G.State:IsActionValid(myToken) and IsAlive() and tick() < deadline do
                    TouchAction()
                    local tool = FindOwnedTool(name)
                    if tool then return tool end
                    InventoryCache.At = 0
                    WeaponInventoryCache.At = 0
                    task.wait(0.15)
                end
                return nil
            end

            local function MapState()
                local map = workspace:FindFirstChild("Map")
                local jungle = map and map:FindFirstChild("Jungle")
                local plates = jungle and jungle:FindFirstChild("QuestPlates")
                local door = plates and plates:FindFirstChild("Door")
                local final = jungle and jungle:FindFirstChild("Final")
                local finalPart = final and final:FindFirstChild("Part", true)
                local desert = map and map:FindFirstChild("Desert")
                local burn = desert and desert:FindFirstChild("Burn")
                local burnPart = burn and burn:FindFirstChild("Part", true)
                return map, jungle, plates, door, finalPart, burnPart
            end

            local function DoorIsOpen()
                local _, _, _, door = MapState()
                return door ~= nil and door.Transparency ~= 0
            end

            local function FinalIsOpen()
                local _, _, _, _, finalPart = MapState()
                return finalPart ~= nil and finalPart.Transparency ~= 0
            end

            local function BurnIsDone()
                local _, _, _, _, _, burnPart = MapState()
                return burnPart ~= nil and burnPart.Transparency ~= 0
            end

            -- Pulse a touch target without ever leaving the character embedded in it.
            -- This is especially important for Jungle button #2, which is mounted on a tree.
            local function StableTouch(targetCF, part, hold)
                if not _G.State:IsActionValid(myToken) or not IsAlive() then return false end
                if typeof(targetCF) ~= "CFrame" then return false end

                if _G.State.IsTraveling and _G.State.MovementOwner == "Saber" then
                    TravelManager:Stop("SaberTouchPulse")
                    task.wait()
                end
                if not MovementManager:Acquire("Saber") then
                    TravelManager:Stop("SaberTouchTakeover")
                    task.wait()
                    if not MovementManager:Acquire("Saber") then return false end
                end

                local c = Char()
                local root = HRP()
                if not c or not root then
                    MovementManager:Release("Saber")
                    return false
                end

                local collision = {}
                for _, obj in ipairs(c:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        collision[obj] = obj.CanCollide
                        obj.CanCollide = false
                    end
                end

                local success = xpcall(function()
                    TouchAction()
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.CFrame = targetCF
                    task.wait(0.16)

                    if part and part.Parent and type(firetouchinterest) == "function" then
                        pcall(function()
                            firetouchinterest(root, part, 0)
                            task.wait(0.06)
                            firetouchinterest(root, part, 1)
                        end)
                    end

                    -- Keep a real overlap briefly for environments without firetouchinterest.
                    local untilAt = tick() + (hold or 0.62)
                    while _G.State:IsActionValid(myToken) and IsAlive() and tick() < untilAt do
                        TouchAction()
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                        task.wait(0.08)
                    end

                    if part and part.Parent and type(firetouchinterest) == "function" then
                        pcall(function()
                            firetouchinterest(root, part, 0)
                            firetouchinterest(root, part, 1)
                        end)
                    end

                    -- Escape upward/outward BEFORE collision is restored. Never leave
                    -- HRP inside a tree, wall, plate, relic slot or curtain.
                    local escape = targetCF.Position + Vector3.new(0, 6, 0)
                    if part and part.Parent then
                        escape = escape + part.CFrame.LookVector * 3
                    end
                    root.CFrame = CFrame.new(escape) * root.CFrame.Rotation
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    task.wait(0.10)
                end, debug.traceback)

                for obj, original in pairs(collision) do
                    if obj and obj.Parent then
                        pcall(function() obj.CanCollide = original end)
                    end
                end
                MovementManager:Release("Saber")
                if not success then
                    warn("[BobonHub] Saber stable-touch failed")
                end
                return success == true
            end

            local function Go(cf, opts)
                opts = opts or {}
                opts.timeout = opts.timeout or 90
                opts.retries = opts.retries == nil and 2 or opts.retries
                return TravelAndWait("Saber", myToken, cf, opts)
            end

            local plateFallback = {
                CFrame.new(-1421.87,55.47,21.78),
                CFrame.new(-1647.20,29.15,438.30),
                CFrame.new(-1324.10,31.46,-461.40),
                CFrame.new(-1152.38,9.75,-700.31),
                CFrame.new(-1180.90,21.00,187.86),
            }

            local function ResolvePlateButton(index)
                local _, _, plates = MapState()
                if not plates then return nil end
                local plate = plates:FindFirstChild("Plate" .. index)
                    or plates:FindFirstChild(tostring(index))
                if not plate then return nil end
                local button = plate:FindFirstChild("Button", true)
                return button and button:IsA("BasePart") and button or nil
            end

            local function RunPlates()
                _G.BobonStatus = "Saber 1/8 • streaming Jungle buttons"
                if not Go(CFrame.new(-1612.56,36.98,148.72), {
                    timeout=90, arrivalThreshold=22, settle=0.20, retries=3,
                }) then
                    return false
                end

                -- Do not infer "door open" from missing streamed objects.
                local streamDeadline = tick() + 8
                while _G.State:IsActionValid(myToken) and tick() < streamDeadline do
                    local _, _, plates, door = MapState()
                    if plates and door then break end
                    TouchAction()
                    task.wait(0.15)
                end

                for cycle = 1, 6 do
                    if DoorIsOpen() then return true end
                    for i = 1, 5 do
                        if not _G.State:IsActionValid(myToken) or not IsAlive() then return false end
                        if DoorIsOpen() then return true end

                        _G.BobonStatus = ("Saber 1/8 • button %d/5 • pass %d/6"):format(i, cycle)
                        local button = ResolvePlateButton(i)
                        local cf = button and button.CFrame or plateFallback[i]
                        StableTouch(cf, button, 0.72)
                        task.wait(0.28)
                    end
                    task.wait(0.45)
                end
                return DoorIsOpen()
            end

            local function GetTorchAndBurn()
                local _, _, _, _, _, burnPart = MapState()
                if BurnIsDone() then return true end

                _G.BobonStatus = "Saber 2/8 • Torch"
                local torch = FindOwnedTool("Torch")
                if not torch then
                    if not Go(CFrame.new(-1610.01,11.50,164.00), {
                        timeout=75, arrivalThreshold=8, settle=0.15, retries=3,
                    }) then return false end
                    -- The public flow obtains the Torch by standing on its fixed pickup.
                    -- Do not select an arbitrary BasePart from Jungle.Final.
                    StableTouch(CFrame.new(-1610.01,11.50,164.00), nil, 0.85)
                    torch = WaitTool("Torch", 7)
                end
                if not torch or not EquipNamed("Torch") then return false end

                _G.BobonStatus = "Saber 3/8 • burning Desert curtain"
                if not Go(CFrame.new(1114.61,5.05,4350.23), {
                    timeout=120, arrivalThreshold=8, settle=0.15, retries=3,
                }) then return false end

                for _ = 1, 4 do
                    local _, _, _, _, _, currentBurn = MapState()
                    StableTouch(CFrame.new(1114.61,5.05,4350.23), currentBurn, 0.95)
                    local verifyUntil = tick() + 2.5
                    while _G.State:IsActionValid(myToken) and tick() < verifyUntil do
                        if BurnIsDone() then return true end
                        TouchAction()
                        task.wait(0.15)
                    end
                    EquipNamed("Torch")
                end
                return BurnIsDone()
            end

            local function HealSickMan()
                _G.BobonStatus = "Saber 4/8 • Cup + Sick Man"
                local _, sick = Invoke("ProQuestProgress", "SickMan")
                if sick == 0 then return true end

                Invoke("ProQuestProgress", "GetCup")
                local cup = WaitTool("Cup", 5)
                if not cup then
                    -- Fallback to the Desert cup room only if the direct server step
                    -- did not materialize the Cup.
                    Go(CFrame.new(1114.27,4.17,4366.15), {
                        timeout=50, arrivalThreshold=7, settle=0.15, retries=2,
                    })
                    StableTouch(CFrame.new(1114.27,4.17,4366.15), nil, 0.55)
                    Invoke("ProQuestProgress", "GetCup")
                    cup = WaitTool("Cup", 5)
                end
                if not cup or not EquipNamed("Cup") then return false end

                -- Public implementations call FillCup directly. Try that first.
                local liveCup = Char() and Char():FindFirstChild("Cup") or FindOwnedTool("Cup")
                if liveCup then Invoke("ProQuestProgress", "FillCup", liveCup) end
                task.wait(0.35)
                Invoke("ProQuestProgress", "SickMan")
                task.wait(0.45)
                local _, after = Invoke("ProQuestProgress", "SickMan")
                if after == 0 then return true end

                -- Proximity fallback for server builds that validate the physical leak/NPC.
                if Go(CFrame.new(1397.06,37.35,-1321.04), {
                    timeout=120, arrivalThreshold=9, settle=0.20, retries=3,
                }) then
                    EquipNamed("Cup")
                    liveCup = Char() and Char():FindFirstChild("Cup") or FindOwnedTool("Cup")
                    if liveCup then Invoke("ProQuestProgress", "FillCup", liveCup) end
                end
                Go(CFrame.new(1457.88,88.25,-1390.40), {
                    timeout=60, arrivalThreshold=12, settle=0.20, retries=2,
                })
                Invoke("ProQuestProgress", "SickMan")
                task.wait(0.45)
                local _, verified = Invoke("ProQuestProgress", "SickMan")
                return verified == 0
            end

            local function FightBoss(name, spawnCF, waitSeconds)
                local boss = FindBoss(name)
                if not boss and spawnCF then
                    Go(spawnCF, {timeout=120,arrivalThreshold=20,settle=0.15,retries=3})
                end
                local waitUntil = tick() + (waitSeconds or 60)
                while not boss and _G.State:IsActionValid(myToken)
                    and IsAlive() and tick() < waitUntil do
                    TouchAction()
                    boss = FindBoss(name)
                    task.wait(0.20)
                end
                if not boss then return false end

                local deadline = tick() + 210
                while _G.State:IsActionValid(myToken) and IsAlive() and tick() < deadline do
                    TouchAction()
                    boss = FindBoss(name)
                    if not boss then return true end
                    local bh = boss:FindFirstChildOfClass("Humanoid")
                    local br = boss:FindFirstChild("HumanoidRootPart")
                    if not bh or bh.Health <= 0 or not br then return true end
                    PrepareCombatTarget(boss)
                    EquipCombatTool()
                    TravelManager:Request(br, "Saber", {
                        arrivalThreshold=_G.Settings.FarmArrivalThreshold,
                        combatHover=true,
                    })
                    if TravelManager:IsAtCombatAnchor(br) then
                        Attack(boss, name)
                    end
                    task.wait(0.08)
                end
                return FindBoss(name) == nil
            end

            local function RunRichMan()
                _G.BobonStatus = "Saber 5/8 • Rich Man"
                local okRich, rich = Invoke("ProQuestProgress", "RichSon")
                if not okRich then return false end

                if rich == nil then
                    -- First dialogue starts the Mob Leader stage.
                    Invoke("ProQuestProgress", "RichSon")
                    task.wait(0.55)
                    return false
                end

                if tonumber(rich) == 0 then
                    _G.BobonStatus = "Saber 6/8 • Mob Leader"
                    if not FightBoss("Mob Leader", CFrame.new(-2967.60,15.0,5328.71), 75) then
                        _G.BobonStatus = "Saber • waiting Mob Leader respawn"
                        return false
                    end
                    Invoke("ProQuestProgress", "RichSon")
                    task.wait(0.55)
                    return false
                end

                if tonumber(rich) == 1 or FindOwnedTool("Relic") then
                    if not FindOwnedTool("Relic") then
                        Invoke("ProQuestProgress", "RichSon")
                    end
                    local relic = WaitTool("Relic", 6)
                    if not relic then
                        -- Some builds validate the Rich Man proximity when rewarding.
                        Go(CFrame.new(-909.11,13.75,4077.35), {
                            timeout=90,arrivalThreshold=14,settle=0.20,retries=3,
                        })
                        Invoke("ProQuestProgress", "RichSon")
                        relic = WaitTool("Relic", 5)
                    end
                    if not relic or not EquipNamed("Relic") then return false end

                    _G.BobonStatus = "Saber 7/8 • Ancient Relic"
                    if not Go(CFrame.new(-1404.92,29.98,3.81), {
                        timeout=120,arrivalThreshold=10,settle=0.15,retries=3,
                    }) then return false end
                    StableTouch(CFrame.new(-1404.92,29.98,3.81), nil, 0.85)
                    Invoke("ProQuestProgress", "PlaceRelic")
                    task.wait(0.75)
                    return FinalIsOpen() or FindBoss("Saber Expert") ~= nil
                end

                -- Unknown server state: re-open the dialogue and re-evaluate instead
                -- of assuming the next stage or ending the whole action.
                Invoke("ProQuestProgress", "RichSon")
                task.wait(0.45)
                return false
            end

            local wholeDeadline = tick() + 900
            while _G.State:IsActionValid(myToken) and IsAlive()
                and tick() < wholeDeadline and not HasSaber() do
                TouchAction()

                local saberBoss = FindBoss("Saber Expert")
                if saberBoss or FinalIsOpen() then
                    _G.BobonStatus = "Saber 8/8 • Saber Expert"
                    if FightBoss("Saber Expert", CFrame.new(-1401.85,35.98,8.82), 80) then
                        InventoryCache.At = 0
                        WeaponInventoryCache.At = 0
                        task.wait(0.5)
                    else
                        _G.BobonStatus = "Saber • waiting Saber Expert"
                        task.wait(0.7)
                    end
                    continue
                end

                local _, sick = Invoke("ProQuestProgress", "SickMan")
                if sick == 0 then
                    RunRichMan()
                    task.wait(0.35)
                    continue
                end

                -- Before Sick Man is complete, server/map checkpoints decide the stage.
                -- Never advance because a streamed object is simply missing.
                if FindOwnedTool("Cup") then
                    HealSickMan()
                elseif BurnIsDone() then
                    HealSickMan()
                elseif FindOwnedTool("Torch") or DoorIsOpen() then
                    if GetTorchAndBurn() then
                        HealSickMan()
                    end
                else
                    if not RunPlates() then
                        _G.BobonStatus = "Saber • buttons not verified; retrying same stage"
                        self.NextOptional.Saber = tick() + 2
                        task.wait(0.7)
                    end
                end
                task.wait(0.25)
            end

            InventoryCache.At = 0
            WeaponInventoryCache.At = 0
            if HasSaber() then
                _G.BobonStatus = "Saber • COMPLETE"
            elseif _G.State:IsActionValid(myToken) and IsAlive() then
                _G.BobonStatus = "Saber • checkpoint timeout; retrying"
                self.NextOptional.Saber = tick() + 2
            end
        end, debug.traceback)

        if not ok then
            warn("[BobonHub] Module Error: Saber: " .. tostring(err))
            self.NextOptional.Saber = tick() + 2
        end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Saber" then
            TravelManager:Stop("SaberComplete")
        end
        MovementManager:Release("Saber")
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "GettingItem" then _G.State:SetMode("Idle") end
    end)
    return true
end


function ItemProgression:CheckPoleV1()
    if not _G.Settings.AutoItems then return false end
    if InventoryHas("Pole (1st Form)") or Level() < 575 or GetSea() ~= 1 then return false end
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
    -- At max level the completion controller may intentionally return to Sea 1
    -- for Saber/Pole. Do not immediately eject it back to Sea 2.
    if Level() >= MAX_LEVEL then return false end
    if GetSea() >= 2 or Level() < 700 then return false end
    -- Before leaving Sea 1, bank Godhuman materials that cannot be farmed here later.
    if MaterialPrepController and MaterialPrepController:TryRunForSeaExit(1) then return true end
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
            local keyWait=tick()+8
            while not key and _G.State:IsActionValid(myToken) and tick()<keyWait do
                _G.State:TouchAction(myToken); task.wait(0.2); key=HasItem("Key")
            end
            if key then
                local c, hum = Char(), Hum()
                if key.Parent ~= c and hum then pcall(function() hum:EquipTool(key) end) end
            end
            if not TravelAndWait("Sea2", myToken, CFrame.new(1347.71,37.38,-1325.65), {
                timeout=90, arrivalThreshold=8, settle=1,
            }) then return end
            task.wait(0.6); _G.State:TouchAction(myToken)

            local boss = FindBoss("Ice Admiral")
            local spawnWait=tick()+60
            while not boss and _G.State:IsActionValid(myToken) and IsAlive() and tick()<spawnWait do
                _G.State:TouchAction(myToken); boss=FindBoss("Ice Admiral"); task.wait(0.25)
            end
            if not boss then self.NextOptional.Sea2=tick()+4; _G.BobonStatus="Sea 2: waiting Ice Admiral"; return end
            local deadline = tick() + 180
            while _G.State:IsActionValid(myToken) and IsAlive() and tick() < deadline do
                _G.State:TouchAction(myToken); boss=FindBoss("Ice Admiral")
                if not boss then break end
                local bh = boss:FindFirstChildOfClass("Humanoid")
                local br = boss:FindFirstChild("HumanoidRootPart")
                if not bh or bh.Health <= 0 or not br then break end
                PrepareCombatTarget(boss); EquipCombatTool()
                TravelManager:Request(br,"Sea2",{arrivalThreshold=_G.Settings.FarmArrivalThreshold,combatHover=true})
                if TravelManager:IsAtCombatAnchor(br) then Attack(boss,"Ice Admiral") end
                task.wait(0.08)
            end

            if _G.State:IsActionValid(myToken) and IsAlive() then
                _G.State:TouchAction(myToken)
                pcall(function() CommF_:InvokeServer("TravelDressrosa") end)
                task.wait(1.2)
                if GetSea() < 2 then
                    pcall(function() CommF_:InvokeServer("TravelDressrosa") end)
                else
                    _G.State.LastServerHop=os.time()
                end
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
    if GetSea() ~= 2 or Level() < 850 then return false end
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
                    _G.State:TouchAction(myToken)
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
                TravelAndWait("Bartilo",myToken,CFrame.new(2099.88,448.93,648.99),{timeout=90,arrivalThreshold=35,settle=0.2})
                local boss=FindBoss("Jeremy"); local spawnWait=tick()+45
                while not boss and _G.State:IsActionValid(myToken) and tick()<spawnWait do
                    _G.State:TouchAction(myToken); boss=FindBoss("Jeremy"); task.wait(0.25)
                end
                if not boss then self.NextOptional.Bartilo=tick()+4; _G.BobonStatus="Progression: Waiting for Jeremy"; return end
                local deadline=tick()+180
                while _G.State:IsActionValid(myToken) and IsAlive() and tick()<deadline do
                    _G.State:TouchAction(myToken); boss=FindBoss("Jeremy"); if not boss then break end
                    local bh=boss:FindFirstChildOfClass("Humanoid"); local br=boss:FindFirstChild("HumanoidRootPart")
                    if not bh or bh.Health<=0 or not br then break end
                    PrepareCombatTarget(boss); EquipCombatTool()
                    TravelManager:Request(br,"Bartilo",{arrivalThreshold=_G.Settings.FarmArrivalThreshold,combatHover=true})
                    if TravelManager:IsAtCombatAnchor(br) then Attack(boss,"Jeremy") end
                    task.wait(0.08)
                end
            elseif progress == 2 then
                local maze = {
                    CFrame.new(-1850.49,13.18,1750.90), CFrame.new(-1858.87,19.38,1712.02),
                    CFrame.new(-1803.94,16.58,1750.90), CFrame.new(-1858.56,16.86,1724.80),
                    CFrame.new(-1869.54,15.99,1681.01), CFrame.new(-1800.10,16.50,1684.52),
                    CFrame.new(-1819.26,14.80,1717.91), CFrame.new(-1813.52,14.86,1724.80),
                }
                for _, cf in ipairs(maze) do
                    _G.State:TouchAction(myToken)
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


local function TrevorStatus()
    local ok, state = pcall(function()
        return CommF_:InvokeServer("TalkTrevor", "1")
    end)
    return ok and state or nil
end

local function FruitCatalogForTrevor()
    local prices = {}
    local ok, rows = pcall(function() return CommF_:InvokeServer("GetFruits") end)
    if ok and type(rows) == "table" then
        for _, row in pairs(rows) do
            if type(row) == "table" then
                local name = row.Name or row.name
                local price = tonumber(row.Price or row.price)
                if name and price then prices[tostring(name)] = price end
            end
        end
    end
    return prices
end

local function LoadCheapestTrevorFruit()
    local prices = FruitCatalogForTrevor()
    local ok, rows = pcall(function() return CommF_:InvokeServer("getInventoryFruits") end)
    if not ok or type(rows) ~= "table" then return false, nil end
    local bestName, bestPrice
    for _, row in pairs(rows) do
        if type(row) == "table" then
            local name = row.Name or row.name
            local price = tonumber(row.Price or row.price or (name and prices[tostring(name)]))
            -- Trevor requires a physical fruit valued at 1,000,000 or more.
            -- Always sacrifice the cheapest qualifying stored fruit first.
            if name and price and price >= 1000000
                and (not bestPrice or price < bestPrice) then
                bestName, bestPrice = tostring(name), price
            end
        end
    end
    if not bestName then return false, nil end
    local loaded = pcall(function() CommF_:InvokeServer("LoadFruit", bestName) end)
    if not loaded then return false, nil end
    task.wait(0.65)
    return true, bestName
end

local function EnsureTrevorAccess()
    local state = TrevorStatus()
    if state == 0 then
        _G.State.NeedTrevorFruit = false
        return true
    end

    -- Some server builds expose a dialogue-ready boolean before the fruit stage.
    if state == true then
        pcall(function() CommF_:InvokeServer("TalkTrevor", "2") end)
        task.wait(0.25)
        state = TrevorStatus()
        if state == 0 then
            _G.State.NeedTrevorFruit = false
            return true
        end
    end

    if state == 1 or state ~= 0 then
        local loaded, fruitName = LoadCheapestTrevorFruit()
        if not loaded then
            _G.State.NeedTrevorFruit = true
            _G.BobonStatus = "Sea 3: Need physical fruit >= $1M for Trevor"
            return false
        end
        _G.BobonStatus = "Sea 3: Trevor • giving " .. tostring(fruitName)
        -- Public kaitun implementations use Trevor's 1/2/3 dialogue sequence.
        -- Re-read state after the sequence; never fake the unlock locally.
        pcall(function() CommF_:InvokeServer("TalkTrevor", "1") end)
        task.wait(0.20)
        pcall(function() CommF_:InvokeServer("TalkTrevor", "2") end)
        task.wait(0.35)
        pcall(function() CommF_:InvokeServer("TalkTrevor", "1") end)
        task.wait(0.20)
        pcall(function() CommF_:InvokeServer("TalkTrevor", "3") end)
        task.wait(0.80)
        state = TrevorStatus()
    end

    local unlocked = state == 0
    _G.State.NeedTrevorFruit = not unlocked
    if not unlocked then _G.BobonStatus = "Sea 3: Trevor access not verified" end
    return unlocked
end

local function ZQuestState()
    local state
    pcall(function() state = CommF_:InvokeServer("ZQuestProgress", "Check") end)
    if state == nil then
        pcall(function() state = CommF_:InvokeServer("ZQuestProgress", "General") end)
    end
    return state
end

function ItemProgression:CheckThirdSea()
    -- At max level the completion controller may intentionally return to Sea 2
    -- for Factory/Rengoku/Dragon Trident/etc. Keep that completion window intact.
    if Level() >= MAX_LEVEL then return false end
    if GetSea() ~= 2 or Level() < 1500 then return false end
    -- Bank Sea-2-only Godhuman/Skull/Sanguine materials before TravelZou.
    if MaterialPrepController and MaterialPrepController:TryRunForSeaExit(2) then return true end
    if not self:OptionalReady("Sea3") then return false end
    local myToken = _G.State:ClaimAction("Sea3")
    if myToken == 0 then return false end
    PrepareClaimedAction("Sea3")
    self.NextOptional.Sea3 = tick() + 8
    _G.State:SetMode("UnlockingSea")
    _G.BobonStatus = "Sea: Unlock 3rd Sea"

    task.spawn(function()
        local ok, err = xpcall(function()
            if not _G.State:IsActionValid(myToken) then return end

            -- Trevor is a hard gate to Don Swan. Do not try to clip/teleport into
            -- the room: obtain a qualifying physical fruit and verify the server state.
            if not EnsureTrevorAccess() then return end

            local zState = ZQuestState()
            if zState == 1 then
                _G.State.Sea3NeedDonSwan = false
                _G.BobonStatus = "Sea 3: Mr. Captain"
                pcall(function() CommF_:InvokeServer("TravelZou") end)
                return
            end

            -- First ask King Red Head to begin. If Don Swan is still required the
            -- server refuses this harmlessly; then we kill a live Don Swan below.
            if TravelAndWait("Sea3", myToken, CFrame.new(-1926.32,12.82,1738.31), {
                timeout=90, arrivalThreshold=10, settle=0.8,
            }) then
                pcall(function() CommF_:InvokeServer("ZQuestProgress", "Begin") end)
                task.wait(1.25)
            end

            local indra = FindBoss("rip_indra")
            if not indra then
                local donSwan = FindBoss("Don Swan")
                if donSwan then
                    _G.State.Sea3NeedDonSwan = false
                    _G.BobonStatus = "Sea 3: Defeating Don Swan"
                    local deadline = tick() + 210
                    while _G.State:IsActionValid(myToken) and IsAlive() and tick() < deadline do
                        local bh = donSwan:FindFirstChildOfClass("Humanoid")
                        local br = donSwan:FindFirstChild("HumanoidRootPart")
                        if not bh or bh.Health <= 0 or not br then break end
                        PrepareCombatTarget(donSwan)
                        EquipCombatTool()
                        TravelManager:Request(br, "Sea3", {
                            arrivalThreshold=_G.Settings.FarmArrivalThreshold,
                            combatHover=true,
                        })
                        if TravelManager:IsAtCombatAnchor(br) then Attack(donSwan, "Don Swan") end
                        task.wait(0.10)
                    end
                    task.wait(1.0)
                    if _G.State:IsActionValid(myToken) then
                        TravelAndWait("Sea3", myToken, CFrame.new(-1926.32,12.82,1738.31), {
                            timeout=90, arrivalThreshold=10, settle=0.5,
                        })
                        pcall(function() CommF_:InvokeServer("ZQuestProgress", "Begin") end)
                        task.wait(1.25)
                        indra = FindBoss("rip_indra")
                    end
                else
                    _G.State.Sea3NeedDonSwan = true
                    _G.BobonStatus = "Sea 3: Waiting/need hop for Don Swan"
                    return
                end
            end

            if indra then
                _G.State.Sea3NeedDonSwan = false
                _G.BobonStatus = "Sea 3: King Red Head • rip_indra"
                local deadline = tick() + 240
                while _G.State:IsActionValid(myToken) and IsAlive() and tick() < deadline do
                    local zNow = ZQuestState()
                    if zNow == 1 then break end
                    local bh = indra:FindFirstChildOfClass("Humanoid")
                    local br = indra:FindFirstChild("HumanoidRootPart")
                    if not bh or bh.Health <= 0 or not br then break end
                    PrepareCombatTarget(indra)
                    EquipCombatTool()
                    TravelManager:Request(br, "Sea3", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        combatHover = true,
                    })
                    if TravelManager:IsAtCombatAnchor(br) then Attack(indra, "rip_indra") end
                    -- Quest completion triggers around half health; allow the server
                    -- cutscene/teleport to resolve instead of requiring a literal kill.
                    if bh.MaxHealth > 0 and bh.Health <= bh.MaxHealth * 0.52 then task.wait(0.8) end
                    task.wait(0.10)
                end
            end

            task.wait(1.0)
            if _G.State:IsActionValid(myToken) and IsAlive() and ZQuestState() == 1 then
                _G.BobonStatus = "Sea 3: Traveling with Mr. Captain"
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
        if _G.State.Mode == "UnlockingSea" then _G.State:SetMode("Idle") end
    end)
    return true
end



-- v17 helpers for optional progression. Every routine is bounded and returns
-- control to quest farming if a server-side prerequisite is absent.
local function FightNamedForAction(name, owner, token, timeout)
    local deadline = tick() + (timeout or 120)
    while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
        _G.State:TouchAction(token)
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


-- ══════════════════════════════════════════════════════════════════
-- v21 MATERIAL PREP + FIGHTING-STYLE HARD PREREQUISITES
-- Mature kaitun behavior is goal-based: gather only material that feeds a
-- permanent progression purchase, keep the player airborne, and return to
-- leveling after a bounded work window.
-- ══════════════════════════════════════════════════════════════════
MaterialPrepController = {
    Active = false,
    NextTry = {},
}

local function HasFireEssence()
    return FindOwnedTool("Fire Essence") ~= nil or InventoryHas("Fire Essence")
end

local function SkullBoneReserve()
    return (_G.Settings.AutoSoulGuitar
        and not (InventoryHas("Skull Guitar") or InventoryHas("Soul Guitar"))) and 500 or 0
end

local function DragonTalonMissing()
    return not InventoryHas("Dragon Talon")
        and math.max(EffectiveMastery("Dragon Breath"), EffectiveMastery("Dragon Claw")) >= 400
end

local function NeedSanguineMaterials()
    return _G.Settings.AutoFightingStyles and _G.Settings.AutoBuyMelee
        and not InventoryHas("Sanguine Art")
end

local function NeedGodhumanMaterials()
    return _G.Settings.AutoFightingStyles and _G.Settings.AutoBuyMelee
        and not InventoryHas("Godhuman")
end

function MaterialPrepController:FarmMaterialGroup(key, material, goal, names, anchorCF, entrance)
    goal = math.max(0, tonumber(goal) or 0)
    if goal <= 0 then return false end
    InventoryCache.At = 0
    if MaterialCount(material) >= goal then return false end
    if not CombatController:IsDamageReady() or not _G.State:CanAct() then return false end
    if tick() < (self.NextTry[key] or 0) then return false end
    self.NextTry[key] = tick() + (_G.Settings.MaterialRetry or 12)

    local label = ("Material: %s %d/%d"):format(material, MaterialCount(material), goal)
    return StartOptionalAction(ItemProgression, "Material-" .. key, "Material", label, function(token)
        if entrance and typeof(entrance) == "Vector3" then
            pcall(function() CommF_:InvokeServer("requestEntrance", entrance) end)
            task.wait(0.8)
        end
        local deadline = tick() + (_G.Settings.MaterialFarmTimeout or 240)
        local lastInventory = 0
        while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
            if tick() - lastInventory >= (_G.Settings.MaterialInventoryRefresh or 1.5) then
                InventoryCache.At = 0
                lastInventory = tick()
                local have = MaterialCount(material)
                _G.BobonStatus = ("Material: %s %d/%d"):format(material, have, goal)
                if have >= goal then break end
            end

            ClusterFarmController:Activate("ITEM", names, anchorCF, "Material")
            ClusterFarmController:Tick()
            local hover = ClusterFarmController:GetHoverCFrame(_G.Settings.FarmHeight or 22)
            if hover and _G.State:CanRequestTravel() then
                TravelManager:Request(hover, "Material", {
                    arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                    combatHover = true,
                    persistent = true,
                })
            end
            local primary = ClusterFarmController:SelectPrimary()
            if primary and _G.State:IsTargetValid(primary) then
                _G.State.CurrentTarget = primary
                PrepareCombatTarget(primary)
                if TravelManager:IsAtCombatAnchor() then
                    EquipCombatTool()
                    Attack(primary, primary.Name)
                end
            end
            task.wait(0.06)
        end
        InventoryCache.At = 0
        FarmPositionController:ReleaseCluster()
    end)
end

function MaterialPrepController:TryRunForSeaExit(sea)
    if sea == 1 and GetSea() == 1 and NeedGodhumanMaterials() then
        if self:FarmMaterialGroup("MagmaOre", "Magma Ore", 20,
            {"Military Soldier","Military Spy"}, CFrame.new(-5411.16,11.08,8454.29)) then return true end
        if self:FarmMaterialGroup("FishTail", "Fish Tail", 20,
            {"Fishman Warrior","Fishman Commando"}, CFrame.new(61122.65,18.5,1569.4),
            Vector3.new(61163.85,11.68,1819.78)) then return true end
    elseif sea == 2 and GetSea() == 2 then
        if NeedGodhumanMaterials() and self:FarmMaterialGroup("MysticDroplet", "Mystic Droplet", 10,
            {"Sea Soldier","Water Fighter"}, CFrame.new(-3054.44,235.54,-10142.82)) then return true end

        local ectoGoal = 0
        if not InventoryHas("Midnight Blade") then ectoGoal = ectoGoal + 100 end
        if _G.Settings.AutoSoulGuitar and not (InventoryHas("Skull Guitar") or InventoryHas("Soul Guitar")) then
            ectoGoal = ectoGoal + 250
        end
        if ectoGoal > 0 and self:FarmMaterialGroup("Ectoplasm", "Ectoplasm", ectoGoal,
            {"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"},
            CFrame.new(919.48,129.56,33436.04), Vector3.new(923.21,126.98,32852.83)) then return true end

        if NeedSanguineMaterials() and self:FarmMaterialGroup("VampireFang", "Vampire Fang", 20,
            {"Vampire"}, CFrame.new(-6037.67,32.18,-1340.66)) then return true end
    end
    return false
end

function MaterialPrepController:TryRunCurrentSea()
    if GetSea() ~= 3 then return false end
    if NeedGodhumanMaterials() and self:FarmMaterialGroup("DragonScale", "Dragon Scale", 10,
        {"Dragon Crew Warrior","Dragon Crew Archer"}, CFrame.new(6709.76,52.34,-1139.03)) then return true end

    local boneGoal = SkullBoneReserve()
    if DragonTalonMissing() and not HasFireEssence() then
        boneGoal = boneGoal + 50 * (_G.Settings.DeathKingReserveRolls or 10)
    end
    if _G.Settings.AutoCDK and not InventoryHas("Cursed Dual Katana") then
        boneGoal = boneGoal + 50 * (_G.Settings.DeathKingReserveRolls or 10)
    end
    if boneGoal > 0 and self:FarmMaterialGroup("Bones", "Bones", boneGoal,
        {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"},
        CFrame.new(-9516,140,6000)) then return true end

    if NeedSanguineMaterials() and self:FarmMaterialGroup("DemonicWisp", "Demonic Wisp", 20,
        {"Demonic Soul"}, CFrame.new(-9505.87,172.10,6158.99)) then return true end
    return false
end

FightingStyleUnlockController = { LastBoneRoll = 0, LastElectricClaw = 0 }
function FightingStyleUnlockController:TryRun()
    if not _G.Settings.AutoFightingStyles or not _G.Settings.AutoBuyMelee then return false end

    local darkM=math.max(EffectiveMastery("Dark Step"),EffectiveMastery("Black Leg"))
    if GetSea()>=2 and darkM>=400 and not FightingStyleController:Known("Death Step") then
        if FindOwnedTool("Library Key") then
            return StartOptionalAction(ItemProgression,"DeathStepDoor","StyleUnlock","Melee: Unlocking Death Step",function(token)
                _G.State:TouchAction(token); EquipNamedTool("Library Key")
                TravelAndWait("StyleUnlock",token,CFrame.new(6377.09,296.63,-6843.89),{timeout=90,arrivalThreshold=7,settle=1.2})
                InvokeStyle("BuyDeathStep",true); InvokeStyle("BuyDeathStep")
                InventoryCache.At=0; WeaponInventoryCache.At=0
            end)
        end
    end

    local waterM=math.max(EffectiveMastery("Water Kung Fu"),EffectiveMastery("Fishman Karate"))
    if GetSea()>=2 and waterM>=400 and not FightingStyleController:Known("Sharkman Karate") and FindOwnedTool("Water Key") then
        local ok=InvokeStyle("BuySharkmanKarate",true); InvokeStyle("BuySharkmanKarate")
        if ok then InventoryCache.At=0; WeaponInventoryCache.At=0 end
        return false
    end

    -- Electric Claw is not a simple shop call the first time: Previous Hero sends
    -- the player to Mansion under a 30-second quest. Public implementations expose
    -- state 4 from BuyElectricClaw(true), then use the Start endpoint.
    local electricM=math.max(EffectiveMastery("Electric"),EffectiveMastery("Electro"))
    if GetSea()==3 and electricM>=400 and not FightingStyleController:Known("Electric Claw")
        and Beli()>=3000000 and CanSpendFragments(5000,"Full Melee: Electric Claw",100)
        and tick()-(self.LastElectricClaw or 0)>=2 then
        self.LastElectricClaw=tick()
        local ok,state=InvokeStyle("BuyElectricClaw",true)
        if ok and state==4 then
            return StartOptionalAction(ItemProgression,"ElectricClawQuest","StyleUnlock","Melee: Electric Claw quest",function(token)
                local hero=CFrame.new(-10371.47,330.76,-10131.42)
                local mansion=CFrame.new(-12550.53,336.23,-7510.42)
                if not TravelAndWait("StyleUnlock",token,hero,{timeout=90,arrivalThreshold=10,settle=0.25}) then return end
                _G.State:TouchAction(token); InvokeStyle("BuyElectricClaw","Start")
                if not TravelAndWait("StyleUnlock",token,mansion,{timeout=28,arrivalThreshold=18,settle=0.15}) then return end
                _G.State:TouchAction(token)
                TravelAndWait("StyleUnlock",token,hero,{timeout=90,arrivalThreshold=10,settle=0.2})
                InvokeStyle("BuyElectricClaw"); InventoryCache.At=0; WeaponInventoryCache.At=0
            end)
        elseif ok then
            InvokeStyle("BuyElectricClaw"); InventoryCache.At=0; WeaponInventoryCache.At=0
        end
    end

    local dragonM=math.max(EffectiveMastery("Dragon Breath"),EffectiveMastery("Dragon Claw"))
    if GetSea()==3 and dragonM>=400 and not FightingStyleController:Known("Dragon Talon") then
        if HasFireEssence() then
            InvokeStyle("BuyDragonTalon",true); InvokeStyle("BuyDragonTalon")
            InventoryCache.At=0; WeaponInventoryCache.At=0
            return false
        end
        local reserve=SkullBoneReserve()
        if MaterialCount("Bones")>=reserve+50 and tick()-(self.LastBoneRoll or 0)>=(_G.Settings.DeathKingRollRetry or 2) then
            self.LastBoneRoll=tick(); pcall(function() CommF_:InvokeServer("Bones","Buy",1,1) end); InventoryCache.At=0
        end
    end
    return false
end

function ItemProgression:CheckKabucha()
    if not _G.Settings.AutoAdvancedItems or GetSea() < 2 or Level() < 700
        or InventoryHas("Kabucha") or not CanSpendFragments(1500, "Item: Kabucha", 20) then return false end
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
    if not _G.Settings.AutoAdvancedItems or not _G.Settings.AutoCDK
        or GetSea() ~= 3 or Level() < 1500 or InventoryHas("Yama") then return false end
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
    if not _G.Settings.AutoAdvancedItems or not _G.Settings.AutoCDK
        or GetSea() ~= 3 or Level() < 2000 or InventoryHas("Tushita") then return false end

    local torch = FindOwnedTool("Holy Torch")
    if torch then
        return StartOptionalAction(self, "Tushita", "Tushita", "Item: Tushita Holy Torch", function(token)
            EquipNamedTool("Holy Torch")
            local map = workspace:FindFirstChild("Map")
            local turtle = map and map:FindFirstChild("Turtle")
            local torches = turtle and turtle:FindFirstChild("QuestTorches")
            local fallback = {
                CFrame.new(-10752.77,412.23,-9366.36), CFrame.new(-11673.41,331.75,-9474.35),
                CFrame.new(-12133.34,519.48,-10653.19), CFrame.new(-13336.50,485.28,-6983.35),
                CFrame.new(-13487.41,334.85,-7926.35),
            }
            for i=1,5 do
                if not _G.State:IsActionValid(token) then return end
                _G.State:TouchAction(token)
                local t=torches and torches:FindFirstChild("Torch"..i)
                local cf=(t and t:IsA("BasePart") and t.CFrame) or fallback[i]
                if t and not t:IsA("BasePart") then local p=t:FindFirstChildWhichIsA("BasePart",true); if p then cf=p.CFrame end end
                TravelAndWait("Tushita",token,cf,{timeout=75,arrivalThreshold=4,settle=0.55})
                if t and type(firetouchinterest)=="function" then
                    local part=t:IsA("BasePart") and t or t:FindFirstChildWhichIsA("BasePart",true)
                    local root=HRP(); if part and root then pcall(function() firetouchinterest(root,part,0); task.wait(0.05); firetouchinterest(root,part,1) end) end
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
                TravelAndWait("Tushita", token, hitbox.CFrame, {timeout=90,arrivalThreshold=5,settle=1})
                if type(firetouchinterest)=="function" and HRP() then pcall(function() firetouchinterest(HRP(),hitbox,0); task.wait(0.05); firetouchinterest(HRP(),hitbox,1) end) end
            else
                TravelAndWait("Tushita", token, CFrame.new(5152,142,912), {timeout=90,arrivalThreshold=8,settle=1})
            end
            _G.State:TouchAction(token); task.wait(0.5)
        end)
    end
    -- No rip_indra/Holy Torch in this server: do not steal movement from leveling.
    return false
end

-- v21 CDK trial helpers. Only states documented by the live Progress table and
-- cross-checked against current public implementations are automated.
-- v21.1 STARTUP FIX: keep CDK-only helpers in a narrow lexical scope.
-- Luau caps simultaneously-active locals in one function/chunk; v21.0 exceeded
-- that cap before later managers were even compiled, so execute produced no UI.
do
local function GetCDKProgress()
    local progress
    pcall(function() progress = CommF_:InvokeServer("CDKQuest","Progress") end)
    if type(progress) ~= "table" then
        pcall(function() progress = CommF_:InvokeServer("CDKQuest","Progress","Good") end)
    end
    return type(progress) == "table" and progress or nil
end

local function BaseMobName(name)
    local n = tostring(name or "")
    n = n:gsub("%s*%[[^%]]+%]", "")
    return (n:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function FindNearestNamedNPC(pos, needles)
    local npcs = workspace:FindFirstChild("NPCs")
    if not npcs then return nil end
    local best, bestDist
    for _, obj in ipairs(npcs:GetDescendants()) do
        if obj:IsA("Model") then
            local lname = string.lower(tostring(obj.Name or ""))
            local match = false
            for _, needle in ipairs(needles) do
                if lname:find(string.lower(needle), 1, true) then match = true break end
            end
            if match then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                if root then
                    local d = (root.Position - pos).Magnitude
                    if not bestDist or d < bestDist then best, bestDist = obj, d end
                end
            end
        end
    end
    return best
end

local function GetDimension(name)
    local map = workspace:FindFirstChild("Map")
    return (map and map:FindFirstChild(name)) or workspace:FindFirstChild(name)
end

local function DimensionCFrame(dim)
    if not dim then return nil end
    if dim:IsA("BasePart") then return dim.CFrame end
    local ok, cf = pcall(function() return dim:GetPivot() end)
    return ok and cf or nil
end

local function ActivateAllPrompts(root)
    if not root or type(fireproximityprompt) ~= "function" then return 0 end
    local count = 0
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if pcall(function() fireproximityprompt(obj) end) then count = count + 1 end
        end
    end
    return count
end

local function DimensionMobNames(center, radius)
    local folder = workspace:FindFirstChild("Enemies")
    local names, seen = {}, {}
    if not folder or not center then return names end
    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and root and (root.Position - center).Magnitude <= radius then
            local n = BaseMobName(mob.Name)
            if n ~= "" and not seen[n] then seen[n] = true; names[#names+1] = n end
        end
    end
    return names
end

local function FightDimension(owner, token, dimensionName, timeout)
    local deadline = tick() + (timeout or 180)
    while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
        local dim = GetDimension(dimensionName)
        local cf = DimensionCFrame(dim)
        if not dim or not cf then return false end
        ActivateAllPrompts(dim)
        local names = DimensionMobNames(cf.Position, _G.Settings.CDKDimensionRadius or 1200)
        if #names > 0 then
            ClusterFarmController:Activate("ITEM", names, cf, owner)
            ClusterFarmController:Tick()
            local hover = ClusterFarmController:GetHoverCFrame(_G.Settings.FarmHeight or 22)
            if hover then TravelManager:Request(hover, owner, {arrivalThreshold=3, combatHover=true, persistent=true}) end
            local primary = ClusterFarmController:SelectPrimary()
            if primary and _G.State:IsTargetValid(primary) and TravelManager:IsAtCombatAnchor() then
                PrepareCombatTarget(primary); EquipCombatTool(); Attack(primary, primary.Name)
            end
        end
        task.wait(0.08)
    end
    FarmPositionController:ReleaseCluster()
    return true
end

local function FindCastleRaidMobs()
    local folder = workspace:FindFirstChild("Enemies")
    local names, seen = {}, {}
    if not folder then return names end
    local castle = Vector3.new(-5500, 313, -2800)
    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")
        local lname = string.lower(BaseMobName(mob.Name))
        local raidMarker = mob:FindFirstChild("Pirate Spawned Tick", true) ~= nil
        local known = lname == "pirate millionaire" or lname == "pistol billionaire"
        if hum and hum.Health > 0 and root and (raidMarker or (known and (root.Position-castle).Magnitude < 2200)) then
            local n = BaseMobName(mob.Name)
            if not seen[n] then seen[n]=true; names[#names+1]=n end
        end
    end
    return names
end

local function FindHazeModel()
    local folder = workspace:FindFirstChild("Enemies")
    if folder then
        for _, mob in ipairs(folder:GetChildren()) do
            local hum = mob:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and mob:FindFirstChild("HazeESP") and mob:FindFirstChild("HumanoidRootPart") then
                return mob, true
            end
        end
    end
    for _, mob in ipairs(RS:GetChildren()) do
        if mob:IsA("Model") and mob:FindFirstChild("HazeESP") and mob:FindFirstChild("HumanoidRootPart") then
            return mob, false
        end
    end
    return nil, false
end

local function CDKProgressChanged(side, expected)
    local p = GetCDKProgress()
    local value = p and tonumber(p[side])
    return value ~= expected
end

local function RunCDKDocks(token)
    local spots = {
        CFrame.new(-4602.5107,16.4465,-2880.9980),
        CFrame.new(4001.1853,10.0894,-2654.8633),
        CFrame.new(-9530.7637,7.2452,-8375.5088),
    }
    for _, cf in ipairs(spots) do
        if not _G.State:IsActionValid(token) or CDKProgressChanged("Good", -3) then break end
        if TravelAndWait("CDK", token, cf, {timeout=90,arrivalThreshold=8,settle=0.5}) then
            local dealer = FindNearestNamedNPC(cf.Position, {"Luxury Boat Dealer","Boat Dealer"})
            if dealer then
                pcall(function() CommF_:InvokeServer("CDKQuest","BoatQuest",dealer,"Check") end)
                pcall(function() CommF_:InvokeServer("CDKQuest","BoatQuest",dealer) end)
                task.wait(0.8)
            end
        end
    end
end

local function RunCDKSenseOfDuty(token)
    local names = FindCastleRaidMobs()
    if #names == 0 then return false end
    local anchor = CFrame.new(-5500,313,-2800)
    local deadline = tick() + 180
    while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline
        and not CDKProgressChanged("Good", -4) do
        names = FindCastleRaidMobs()
        if #names == 0 then task.wait(0.5) continue end
        ClusterFarmController:Activate("ITEM", names, anchor, "CDK")
        ClusterFarmController:Tick()
        local hover = ClusterFarmController:GetHoverCFrame(_G.Settings.FarmHeight or 22)
        if hover then TravelManager:Request(hover, "CDK", {arrivalThreshold=3,combatHover=true,persistent=true}) end
        local primary = ClusterFarmController:SelectPrimary()
        if primary and TravelManager:IsAtCombatAnchor() then
            PrepareCombatTarget(primary); EquipCombatTool(); Attack(primary, primary.Name)
        end
        task.wait(0.06)
    end
    FarmPositionController:ReleaseCluster()
    return true
end

local function RunCDKSoulless(token)
    if GetDimension("HeavenDimension") then
        return FightDimension("CDK", token, "HeavenDimension", 180)
    end
    local queen = FindBoss("Cake Queen")
    if not queen then return false end
    local deadline = tick() + 118
    while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
        local hum = queen and queen:FindFirstChildOfClass("Humanoid")
        local root = queen and queen:FindFirstChild("HumanoidRootPart")
        if not queen or not queen.Parent or not hum or hum.Health <= 0 or not root then break end
        PrepareCombatTarget(queen); EquipCombatTool()
        TravelManager:Request(root, "CDK", {arrivalThreshold=3,combatHover=true,hoverHeight=_G.Settings.BossFarmHeight or 24})
        if TravelManager:IsAtCombatAnchor(root) then Attack(queen, "Cake Queen") end
        task.wait(0.08)
    end
    local waitDim = tick() + 8
    while _G.State:IsActionValid(token) and tick() < waitDim and not GetDimension("HeavenDimension") do task.wait(0.2) end
    if GetDimension("HeavenDimension") then return FightDimension("CDK", token, "HeavenDimension", 180) end
    return true
end

local function RunCDKPain(token)
    EquipNamedTool("Yama")
    local deadline = tick() + (_G.Settings.CDKTrialTimeout or 600)
    while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline
        and not CDKProgressChanged("Evil", -3) do
        local mob = FindMob("Forest Pirate")
        if not mob then
            TravelManager:Request(CFrame.new(-13274.48,332.38,-7769.58), "CDK", {persistent=true})
            task.wait(1); continue
        end
        local root = mob:FindFirstChild("HumanoidRootPart")
        local hum = Hum()
        if not root or not hum then task.wait(0.2); continue end
        local pct = hum.MaxHealth > 0 and hum.Health / hum.MaxHealth * 100 or 100
        EquipNamedTool("Yama")
        if pct <= 22 then
            TravelManager:Request(CFrame.new(root.Position + Vector3.new(0,28,0)), "CDK", {persistent=true})
            repeat task.wait(0.25) until not _G.State:IsActionValid(token) or not IsAlive()
                or (Hum() and Hum().MaxHealth > 0 and Hum().Health/Hum().MaxHealth*100 >= 72)
        else
            -- Trial requires taking damage with Yama; intentionally do not attack.
            TravelManager:Request(CFrame.new(root.Position + Vector3.new(0,1,4)), "CDK", {persistent=true})
            _G.BobonStatus = "CDK: Pain and Suffering - taking damage"
            task.wait(0.25)
        end
    end
    return true
end

local function RunCDKHaze(token)
    local deadline = tick() + (_G.Settings.CDKTrialTimeout or 600)
    local qIndex = 1
    while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline
        and not CDKProgressChanged("Evil", -4) do
        local target, live = FindHazeModel()
        if target then
            local root = target:FindFirstChild("HumanoidRootPart")
            if live and root then
                local names, seen = {}, {}
                local folder = workspace:FindFirstChild("Enemies")
                for _, mob in ipairs(folder and folder:GetChildren() or {}) do
                    if mob:FindFirstChild("HazeESP") and mob:FindFirstChildOfClass("Humanoid")
                        and mob:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local n=BaseMobName(mob.Name); if not seen[n] then seen[n]=true; names[#names+1]=n end
                    end
                end
                ClusterFarmController:Activate("ITEM", names, CFrame.new(root.Position), "CDK")
                ClusterFarmController:Tick()
                local hover=ClusterFarmController:GetHoverCFrame(_G.Settings.FarmHeight or 22)
                if hover then TravelManager:Request(hover,"CDK",{arrivalThreshold=3,combatHover=true,persistent=true}) end
                local primary=ClusterFarmController:SelectPrimary()
                if primary and TravelManager:IsAtCombatAnchor() then
                    PrepareCombatTarget(primary); EquipCombatTool(); Attack(primary, primary.Name)
                end
            elseif root and IsValidPos(root.Position) then
                TravelManager:Request(CFrame.new(root.Position + Vector3.new(0,22,0)), "CDK", {persistent=true})
            end
        else
            -- Stream Sea-3 islands until the server exposes the next purple-marked NPC.
            local sea3 = {}
            for _, q in ipairs(QDB) do if q.Min >= 1500 and q.MC then sea3[#sea3+1]=q.MC end end
            if #sea3 > 0 then
                qIndex = ((qIndex - 1) % #sea3) + 1
                TravelAndWait("CDK", token, sea3[qIndex], {timeout=45,arrivalThreshold=25,settle=0.2})
                qIndex = qIndex + 1
            else task.wait(0.5) end
        end
        task.wait(0.06)
    end
    FarmPositionController:ReleaseCluster()
    return true
end

local function RunCDKFear(token)
    if GetDimension("HellDimension") then
        _G.State.CDKResumeStage = "Fear"
        local result = FightDimension("CDK", token, "HellDimension", 220)
        if CDKProgressChanged("Evil", -5) then _G.State.CDKResumeStage = nil end
        return result
    end
    local reaper = FindBoss("Soul Reaper") or FindMob("Soul Reaper")
    if reaper and reaper:FindFirstChild("HumanoidRootPart") then
        _G.State.CDKResumeStage = "Fear"
        EquipNamedTool("Yama")
        local root = reaper.HumanoidRootPart
        local deadline = tick() + 120
        while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline
            and not GetDimension("HellDimension") and not CDKProgressChanged("Evil", -5) do
            EquipNamedTool("Yama")
            -- Intentional trial death: Soul Reaper must kill the player. Never attack it.
            TravelManager:Request(CFrame.new(root.Position + Vector3.new(0,1,4)), "CDK", {persistent=true})
            _G.BobonStatus = "CDK: Fear the Reaper - intentional trial death"
            task.wait(0.2)
        end
        return true
    end
    if FindOwnedTool("Hallow Essence") then
        EquipNamedTool("Hallow Essence")
        TravelAndWait("CDK", token, CFrame.new(-8932.32,146.83,6062.55), {
            timeout=90,arrivalThreshold=7,settle=1.2,
        })
        return true
    end
    -- No Reaper/essence: use Death King rolls only from bones above Skull reserve.
    local reserve = SkullBoneReserve()
    if MaterialCount("Bones") >= reserve + 50 then
        pcall(function() CommF_:InvokeServer("Bones","Buy",1,1) end)
        InventoryCache.At = 0
    end
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

    local progress = GetCDKProgress()
    local good = progress and tonumber(progress.Good)
    local evil = progress and tonumber(progress.Evil)
    local fragments = MaterialCount("Alucard Fragment")

    if good == -3 then
        return StartOptionalAction(self,"CDK","CDK","CDK: Docks Legend",RunCDKDocks)
    elseif good == -4 then
        if #FindCastleRaidMobs() == 0 then _G.BobonStatus="CDK: Waiting Castle Pirate Raid"; return false end
        return StartOptionalAction(self,"CDK","CDK","CDK: Sense of Duty",RunCDKSenseOfDuty)
    elseif good == -5 then
        if not GetDimension("HeavenDimension") and not FindBoss("Cake Queen") then
            _G.BobonStatus="CDK: Waiting Cake Queen for Soulless"; return false
        end
        return StartOptionalAction(self,"CDK","CDK","CDK: Soulless",RunCDKSoulless)
    elseif evil == -3 then
        return StartOptionalAction(self,"CDK","CDK","CDK: Pain and Suffering",RunCDKPain)
    elseif evil == -4 then
        return StartOptionalAction(self,"CDK","CDK","CDK: Haze of Misery",RunCDKHaze)
    elseif evil == -5 or _G.State.CDKResumeStage == "Fear" then
        return StartOptionalAction(self,"CDK","CDK","CDK: Fear the Reaper",RunCDKFear)
    end

    if fragments < 3 then
        pcall(function() CommF_:InvokeServer("CDKQuest","Progress","Evil") end)
        pcall(function() CommF_:InvokeServer("CDKQuest","StartTrial","Evil") end)
        self.NextOptional.CDK = tick() + 3
        return false
    elseif fragments < 6 then
        pcall(function() CommF_:InvokeServer("CDKQuest","Progress","Good") end)
        pcall(function() CommF_:InvokeServer("CDKQuest","StartTrial","Good") end)
        self.NextOptional.CDK = tick() + 3
        return false
    end

    pcall(function() CommF_:InvokeServer("CDKQuest","OpenDoor") end)
    local boss = FindBoss("Cursed Skeleton Boss")
    if not boss or not CombatController:IsDamageReady() then return false end
    return StartOptionalAction(self,"CDK","CDK","Item: Cursed Dual Katana final",function(token)
        pcall(function() CommF_:InvokeServer("CDKQuest","StartTrial","Boss") end)
        local deadline=tick()+240
        while _G.State:IsActionValid(token) and IsAlive() and tick()<deadline do
            boss=FindBoss("Cursed Skeleton Boss")
            if not boss then break end
            local hum=boss:FindFirstChildOfClass("Humanoid")
            local root=boss:FindFirstChild("HumanoidRootPart")
            if not hum or hum.Health<=0 or not root then break end
            if not EquipNamedTool("Yama") then EquipNamedTool("Tushita") end
            PrepareCombatTarget(boss)
            TravelManager:Request(root,"CDK",{arrivalThreshold=3,combatHover=true,hoverHeight=_G.Settings.BossFarmHeight or 24})
            if TravelManager:IsAtCombatAnchor(root) then Attack(boss,"Cursed Skeleton Boss") end
            task.wait(0.08)
        end
        _G.State.CDKResumeStage=nil
    end)
end

end -- v21.1 CDK helper scope

function ItemProgression:CheckAcidumRifle()
    if GetSea() ~= 2 or Level() < 700 or InventoryHas("Acidum Rifle") then return false end
    if not self:OptionalReady("AcidumRifle") then return false end

    -- Acidum Rifle is a live Factory Core drop. Never camp or steal movement
    -- while the Factory is closed; only act when a real Core is present.
    local core = FindMob("Core") or FindBoss("Core")
    if not core or not _G.State:IsTargetValid(core) then return false end

    self.NextOptional.AcidumRifle = tick() + (_G.Settings.ProgressionRetry or 45)
    return StartOptionalAction(self, "AcidumRifle", "Factory", "Item: Factory Core / Acidum Rifle", function(token)
        FightNamedForAction("Core", "Factory", token, math.min(_G.Settings.OptionalWorkTimeout or 150, 280))
    end)
end

-- v21.1 STARTUP FIX: same isolation for Skull Guitar puzzle helpers.
do
local function HasSkullGuitar()
    -- Current display/tool name is Skull Guitar; legacy inventories/remotes may
    -- still expose Soul Guitar. Treat either as already owned.
    return InventoryHas("Skull Guitar") or InventoryHas("Soul Guitar")
end

local function GuitarProgress()
    local p
    pcall(function() p=CommF_:InvokeServer("GuitarPuzzleProgress","Check") end)
    return type(p)=="table" and p or nil
end

local function FindTrophyPart(castle, index)
    if not castle then return nil end
    local wanted="trophy"..tostring(index)
    for _, obj in ipairs(castle:GetDescendants()) do
        if string.lower(tostring(obj.Name or "")) == wanted then
            if obj:IsA("BasePart") then return obj end
            if obj:IsA("Model") then return obj:FindFirstChild("Handle") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true) end
        end
    end
    return nil
end

local function AngleNear(value, target, tolerance)
    local function norm(a) return ((a + 180) % 360) - 180 end
    return math.abs(norm(value-target)) <= (tolerance or 8)
end

local function FindSegmentIndicator(segment)
    if not segment then return nil end
    local before={}
    for _,obj in ipairs(segment:GetDescendants()) do
        if obj:IsA("BasePart") then before[obj]={Z=obj.Orientation.Z,Y=obj.Position.Y} end
    end
    if not TryClickDetector(segment) then return nil end
    task.wait(0.12)
    local changed
    for obj,old in pairs(before) do
        if obj.Parent then
            if math.abs(obj.Orientation.Z-old.Z)>1 or math.abs(obj.Position.Y-old.Y)>10 then changed=obj break end
        end
    end
    if changed then return changed end
    -- Fallback: line/indicator-like descendant.
    for _,obj in ipairs(segment:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n=string.lower(obj.Name)
            if n:find("line",1,true) or n:find("indicator",1,true) then return obj end
        end
    end
    return segment:FindFirstChildWhichIsA("BasePart",true)
end

local function SolveSkullTrophies(token)
    local map=workspace:FindFirstChild("Map")
    local castle=map and map:FindFirstChild("Haunted Castle")
    local tablet=castle and castle:FindFirstChild("Tablet")
    if not castle or not tablet then return false end
    TravelAndWait("SkullGuitar",token,CFrame.new(-9532.82,6.47,6078.07),{timeout=90,arrivalThreshold=12,settle=0.4})
    local blanks={2,5,6,8,9}
    for _,idx in ipairs(blanks) do
        if not _G.State:IsActionValid(token) then return false end
        local seg=tablet:FindFirstChild("Segment"..idx)
        local indicator=FindSegmentIndicator(seg)
        if indicator then
            for _=1,8 do
                if indicator.Position.Y < -500 then break end
                TryClickDetector(seg); task.wait(0.08)
            end
        end
    end
    local segmentMap={1,3,4,7,10}
    for trophyIndex,segmentIndex in ipairs(segmentMap) do
        if not _G.State:IsActionValid(token) then return false end
        local trophy=FindTrophyPart(castle,trophyIndex)
        local seg=tablet:FindFirstChild("Segment"..segmentIndex)
        if not trophy or not seg then return false end
        local y=trophy.Orientation.Y
        local targetZ=(AngleNear(y,90,15) or AngleNear(y,-90,15)) and 180 or 90
        local indicator=FindSegmentIndicator(seg)
        if not indicator then return false end
        for _=1,8 do
            if AngleNear(math.abs(indicator.Orientation.Z),targetZ,10) then break end
            TryClickDetector(seg); task.wait(0.08)
        end
    end
    task.wait(0.5)
    local p=GuitarProgress()
    return p and p.Trophies==true or false
end

local function FindPipeTargetColor(pipes, partName)
    if not pipes then return nil end
    for _,obj in ipairs(pipes:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name==partName then return obj.BrickColor end
    end
    return nil
end

local function SolveSkullPipes(token)
    local map=workspace:FindFirstChild("Map")
    local castle=map and map:FindFirstChild("Haunted Castle")
    local lab=castle and castle:FindFirstChild("Lab Puzzle")
    if not lab then return false end
    local floor=lab:FindFirstChild("ColorFloor")
    local pipes=lab:FindFirstChild("Pipes")
    if not floor or not pipes then return false end
    TravelAndWait("SkullGuitar",token,CFrame.new(-9628.027,6.131,6157.478),{timeout=90,arrivalThreshold=12,settle=0.4})
    for i=1,10 do
        if not _G.State:IsActionValid(token) then return false end
        local name="Part"..i
        local tile=floor:FindFirstChild(name)
        if tile and tile:IsA("BasePart") and tile:FindFirstChildWhichIsA("ClickDetector",true) then
            local target=FindPipeTargetColor(pipes,name)
            if not target and i==10 then target=BrickColor.new("Storm blue") end
            if target then
                for _=1,10 do
                    if tile.BrickColor==target then break end
                    TryClickDetector(tile); task.wait(0.08)
                end
            end
        end
    end
    task.wait(0.5)
    local p=GuitarProgress()
    return p and p.Pipes==true or false
end

local function RunSkullSwamp(token)
    local anchor=CFrame.new(-10170.73,138.65,5934.27)
    local deadline=tick()+(_G.Settings.SkullSwampTimeout or 240)
    while _G.State:IsActionValid(token) and IsAlive() and tick()<deadline do
        local p=GuitarProgress(); if p and p.Swamp==true then break end
        ClusterFarmController:Activate("ITEM",{"Living Zombie"},anchor,"SkullGuitar")
        ClusterFarmController:Tick()
        local batch=ClusterFarmController.LastBatch or {}
        _G.BobonStatus=("Skull Guitar: Swamp %d/6 stacked"):format(#batch)
        local hover=ClusterFarmController:GetHoverCFrame(_G.Settings.FarmHeight or 22)
        if hover then TravelManager:Request(hover,"SkullGuitar",{arrivalThreshold=3,combatHover=true,persistent=true}) end
        if #batch>=6 then
            local primary=ClusterFarmController:SelectPrimary()
            if primary and TravelManager:IsAtCombatAnchor() then
                PrepareCombatTarget(primary); EquipCombatTool(); Attack(primary,"Living Zombie")
            end
        end
        task.wait(0.05)
    end
    FarmPositionController:ReleaseCluster()
end

function ItemProgression:CheckSoulGuitar()
    if not _G.Settings.AutoSoulGuitar or GetSea() ~= 3 or Level() < 2300
        or HasSkullGuitar() then return false end
    if not self:OptionalReady("SoulGuitar") then return false end

    -- Material bill first. Dark Fragment is handled opportunistically by BossManager.
    if MaterialCount("Bones") < 500 or MaterialCount("Ectoplasm") < 250
        or MaterialCount("Dark Fragment") < 1 then
        _G.BobonStatus=("Skull Guitar: materials B%d/500 E%d/250 D%d/1"):format(
            MaterialCount("Bones"),MaterialCount("Ectoplasm"),MaterialCount("Dark Fragment"))
        return false
    end
    if not CanSpendFragments(5000,"Item: Skull Guitar",70) then return false end

    local npcs=workspace:FindFirstChild("NPCs")
    if npcs and npcs:FindFirstChild("Skeleton Machine") then
        pcall(function() CommF_:InvokeServer("soulGuitarBuy",true) end)
        self.NextOptional.SoulGuitar=tick()+3
        return false
    end

    local progress=GuitarProgress()
    if not progress then
        return StartOptionalAction(self,"SoulGuitar","SkullGuitar","Skull Guitar: Full Moon gravestone",function(token)
            TravelAndWait("SkullGuitar",token,CFrame.new(-8655.02,141.32,6160.02),{timeout=90,arrivalThreshold=10,settle=0.6})
            pcall(function() CommF_:InvokeServer("gravestoneEvent",2) end)
            pcall(function() CommF_:InvokeServer("gravestoneEvent",2,true) end)
        end)
    end
    if progress.Swamp==false then
        return StartOptionalAction(self,"SoulGuitar","SkullGuitar","Skull Guitar: six Living Zombies",RunSkullSwamp)
    elseif progress.Gravestones==false then
        return StartOptionalAction(self,"SoulGuitar","SkullGuitar","Skull Guitar: gravestones",function(token)
            local map=workspace:FindFirstChild("Map"); local castle=map and map:FindFirstChild("Haunted Castle")
            if not castle then return end
            local order={{"Placard7","Left"},{"Placard6","Left"},{"Placard5","Left"},{"Placard4","Right"},{"Placard3","Left"},{"Placard2","Right"},{"Placard1","Right"}}
            for _,row in ipairs(order) do
                if not _G.State:IsActionValid(token) then break end
                local placard=castle:FindFirstChild(row[1]); local side=placard and placard:FindFirstChild(row[2])
                if side then TryClickDetector(side) end; task.wait(0.1)
            end
        end)
    elseif progress.Ghost==false then
        pcall(function() CommF_:InvokeServer("GuitarPuzzleProgress","Ghost") end)
        pcall(function() CommF_:InvokeServer("GuitarPuzzleProgress","Ghost",true) end)
        self.NextOptional.SoulGuitar=tick()+2
        return false
    elseif progress.Trophies==false then
        return StartOptionalAction(self,"SoulGuitar","SkullGuitar","Skull Guitar: randomized trophies",function(token)
            if not SolveSkullTrophies(token) then _G.BobonStatus="Skull Guitar: trophy map signature retry" end
        end)
    elseif progress.Pipes==false then
        return StartOptionalAction(self,"SoulGuitar","SkullGuitar","Skull Guitar: pipe colors",function(token)
            if not SolveSkullPipes(token) then _G.BobonStatus="Skull Guitar: pipe map signature retry" end
        end)
    end
    pcall(function() CommF_:InvokeServer("soulGuitarBuy",true) end)
    self.NextOptional.SoulGuitar=tick()+3
    return false
end

end -- v21.1 Skull Guitar helper scope

function ItemProgression:CheckRaceV2()
    if not _G.Settings.AutoRaceV2 or GetSea() ~= 2 or Level() < 850 then return false end
    local bartilo
    pcall(function() bartilo=CommF_:InvokeServer("BartiloQuestProgress","Bartilo") end)
    if type(bartilo)=="number" and bartilo<3 then return false end
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
            local flower1, flower2 = workspace:FindFirstChild("Flower1",true), workspace:FindFirstChild("Flower2",true)
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
            if FindOwnedTool("Flower 1") and FindOwnedTool("Flower 2") and FindOwnedTool("Flower 3") and Beli() >= 500000 then
                if TravelAndWait("RaceV2", token, CFrame.new(-2779.84,72.97,-3574.02), {
                    timeout=90, arrivalThreshold=6, settle=0.8,
                }) then
                    pcall(function() CommF_:InvokeServer("Alchemist","3") end)
                end
            end
        end
    end)
end

-- Permanent progression is driven by one watcher and may preempt ordinary level
-- farming as soon as a real prerequisite is ready.  Every movement-heavy branch
-- still has to claim ActionToken/PrepareClaimedAction, so there is only one owner.
-- Sticky hard milestones (Saber/Sea gates) remain blocking until server progress
-- proves completion; optional work uses bounded retries and relinquishes cleanly.
function ItemProgression:GetBlockingReason()
    local now=tick()
    if now-(self.BlockingCheckedAt or 0)<0.50 then
        return self.BlockingReason
    end
    self.BlockingCheckedAt=now

    local reason=nil
    local sea,lv=GetSea(),Level()
    if _G.Settings.AutoItems and _G.Settings.AutoSaber
        and sea==1 and lv>=200 and not InventoryHas("Saber") then
        reason="Saber"
    elseif sea==1 and lv>=700 then
        reason="Second Sea"
    elseif sea==2 and lv>=850 then
        local bartilo
        pcall(function() bartilo=CommF_:InvokeServer("BartiloQuestProgress","Bartilo") end)
        if type(bartilo)=="number" and bartilo<3 then
            reason="Bartilo"
        elseif lv>=1500 then
            reason="Third Sea"
        end
    end

    self.BlockingReason=reason
    _G.State.ProgressionLock=reason
    return reason
end

function ItemProgression:RunChecks(allowSea, allowOptional)
    if not allowSea or not _G.State:CanAct() then return false end

    -- v21.33: Melee purchases are handled by the single economy worker, not this
    -- progression scheduler.  This avoids duplicate purchase coroutines racing Gacha.

    -- v21.35: ready melee unlock work is called once by Priority Scheduler,
    -- not again from inside this item chain.

    -- Sea-1 permanent milestone before world exit.
    if allowOptional and self:CheckSaber() then return true end
    if allowOptional and self:CheckPoleV1() then return true end
    if self:CheckSecondSea() then return true end

    -- Sea-2 hard progression chain. Bartilo gates Race V2/Third Sea; every routine
    -- re-reads its server progress and relinquishes the token if a spawn is absent.
    if self:CheckBartilo() then return true end
    if allowOptional and self:CheckRaceV2() then return true end

    if allowOptional then
        if MaterialPrepController and MaterialPrepController:TryRunCurrentSea() then return true end

        -- Passive melee mastery + TTK probing are scheduler-owned in v21.35.

        if self:CheckKabucha() then return true end
        if self:CheckRengoku() then return true end
        if self:CheckMidnightBlade() then return true end
        if self:CheckAcidumRifle() then return true end
    end

    if self:CheckThirdSea() then return true end
    if not allowOptional then return false end

    -- Sea-3 permanent item/weapon chain.
    if self:CheckYama() then return true end
    if self:CheckTushita() then return true end
    if self:CheckCDK() then return true end
    if self:CheckSoulGuitar() then return true end
    return false
end

-- v21.35: old ProgressionWatcher removed.  Permanent movement work is started
-- only by the unified Priority Scheduler defined after RaidController.

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
    {N="Stone",Sea=3,MinLevel=1550}, {N="Hydra Leader",Sea=3,MinLevel=1675}, {N="Island Empress",Sea=3,MinLevel=1675}, -- legacy alias
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
    -- Only live bosses tied to the explicitly retained kaitun items. The manager
    -- never camps a spawn here; it acts only when the boss already exists.
    ["Thunder God"] = "Pole (1st Form)",
    ["Awakened Ice Admiral"] = "Rengoku",
    ["Tide Keeper"] = "Dragon Trident",
    ["Orbitus"] = {"Gravity Blade", "Gravity Cane"},
    ["Fajita"] = {"Gravity Blade", "Gravity Cane"}, -- legacy pre-Update-26 alias
}

local function RequiredDarkFragments()
    local need = 0
    if _G.Settings.AutoSoulGuitar and not (InventoryHas("Skull Guitar") or InventoryHas("Soul Guitar")) then
        need = need + 1
    end
    if _G.Settings.AutoFightingStyles and _G.Settings.AutoBuyMelee and not InventoryHas("Sanguine Art") then
        need = need + 2
    end
    return need
end

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
                local wantedSwordDrop = wantedItem ~= nil
                    and BossDropMissing(wantedItem)
                local progressionBoss = entry.N == "Tyrant of the Skies"
                    and level >= 2600 and not SubmergedAccessController.Confirmed
                local darkFragmentBoss = entry.N == "Darkbeard"
                    and MaterialCount("Dark Fragment") < RequiredDarkFragments()
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
                    local cdkProgress = nil
                    if _G.Settings.AutoCDK and not InventoryHas("Cursed Dual Katana") then
                        cdkProgress = GetCDKProgress()
                    end
                    local fearStage = _G.State.CDKResumeStage == "Fear"
                        or (type(cdkProgress)=="table" and tonumber(cdkProgress.Evil)==-5)
                    local eliteNeeded = false
                    if _G.Settings.AutoCDK and not InventoryHas("Yama") then
                        local ep=0
                        pcall(function() ep=tonumber(CommF_:InvokeServer("EliteHunter","Progress")) or 0 end)
                        eliteNeeded = ep < 30
                    end
                    hopTarget = (_G.Settings.HopElite and eliteNeeded
                            and (entry.N == "Diablo" or entry.N == "Deandre" or entry.N == "Urban"))
                        or (_G.Settings.HopFindDarkbeard and entry.N == "Darkbeard"
                            and MaterialCount("Dark Fragment") < RequiredDarkFragments())
                        or (_G.Settings.HopFindSoulReaper and entry.N == "Soul Reaper" and fearStage)
                        or (_G.Settings.HopFindMirrorFractal and entry.N == "Dough King"
                            and level >= MAX_LEVEL and _G.Settings.AutoKatakuri
                            and not InventoryHas("Mirror Fractal"))
                        or (_G.Settings.HopFindTushita
                            and (entry.N == "rip_indra" or entry.N == "rip_indra True Form")
                            and _G.Settings.AutoCDK and level >= 2000 and not InventoryHas("Tushita"))
                        or (_G.Settings.HopFindValkyrieHelm
                            and (entry.N == "rip_indra" or entry.N == "rip_indra True Form")
                            and _G.Settings.AutoSpawnRipIndra and level >= MAX_LEVEL
                            and not InventoryHas("Valkyrie Helm"))
                end
                if (wantedSwordDrop or progressionBoss or darkFragmentBoss or styleKeyBoss or farmDrops or hopTarget)
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

-- v21.34 REQUIRED-SPAWN PRIORITY.  These are not generic boss hunts: each row
-- is tied to a concrete permanent kaitun upgrade that is currently missing.
-- A live required boss may preempt level farm; if it is absent, HopManager may
-- search another server even when generic Hop is disabled.
function BossManager:GetPriorityDemand()
    local sea, lv = GetSea(), Level()

    if _G.Settings.AutoFightingStyles and _G.Settings.AutoBuyMelee and sea == 2 then
        if lv >= 1400 and not FightingStyleController:Known("Death Step")
            and math.max(EffectiveMastery("Dark Step"), EffectiveMastery("Black Leg")) >= 400
            and not FindOwnedTool("Library Key") then
            return {"Awakened Ice Admiral"}, "melee-library-key"
        end
        if lv >= 1475 and not FightingStyleController:Known("Sharkman Karate")
            and math.max(EffectiveMastery("Water Kung Fu"), EffectiveMastery("Fishman Karate")) >= 400
            and not FindOwnedTool("Water Key") then
            return {"Tide Keeper"}, "melee-water-key"
        end
    end

    if _G.Settings.AutoItems and sea == 1 and lv >= 575 and not InventoryHas("Pole (1st Form)") then
        return {"Thunder God"}, "item-pole-v1"
    end
    if _G.Settings.AutoItems and sea == 2 then
        if lv >= 1100 and not InventoryHas("Rengoku") and not FindOwnedTool("Hidden Key") then
            return {"Awakened Ice Admiral"}, "item-rengoku-key"
        end
        if lv >= 1475 and not InventoryHas("Dragon Trident") then
            return {"Tide Keeper"}, "item-dragon-trident"
        end
        if lv >= 925 and not InventoryHas("Gravity Blade") and not InventoryHas("Gravity Cane") then
            return {"Orbitus", "Fajita"}, "item-gravity-blade"
        end
    end
    return nil
end

function BossManager:FindPriorityBoss()
    local names, reason = self:GetPriorityDemand()
    if not names then return nil, nil, nil end
    local best, bestDist, bestEntry = nil, math.huge, nil
    local me = HRP()
    for _, name in ipairs(names) do
        local boss = FindBoss(name)
        if boss then
            local root = boss:FindFirstChild("HumanoidRootPart")
            local dist = root and me and (root.Position - me.Position).Magnitude or 0
            if dist < bestDist then
                best, bestDist = boss, dist
                for _, entry in ipairs(BossDatabase) do
                    if entry.N == name then bestEntry = entry; break end
                end
            end
        end
    end
    return best, bestEntry, reason
end

function BossManager:TryPriorityBoss()
    if self.Active or not _G.State:CanAct()
        or not CombatController:IsDamageReady() then return false end
    local boss, entry, reason = self:FindPriorityBoss()
    if not boss or not entry then return false end
    local token = _G.State:ClaimAction("BossPriority")
    if token == 0 then return false end
    PrepareClaimedAction("BossPriority")
    self.Active = true
    _G.State.WorkIntent = "PROGRESSION:" .. tostring(reason or entry.N)
    task.spawn(function() self:_RunBoss(boss, entry, token) end)
    return true
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
    -- v21.33: below max level, a boss may start only after the Quest wrapper has
    -- stayed CLOSED for a confirmed window. A one-frame UI rebuild must never
    -- turn a normal level quest into an unrelated boss trip.
    if Level() < MAX_LEVEL then
        if _G.State.ProgressionLock then return false end
        if _G.State.QuestClosedStable ~= true then return false end
        if _G.State.ActiveQuestMob ~= nil then return false end
    end
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
--      v20.0 FACTORY EVENT CONTROLLER — SEA 2 LIVE-EVENT PRIORITY
--   Factory is not a permanent farm target. It preempts normal quest work only
--   while a real Core exists in workspace.Enemies, then releases everything and
--   lets the main level farm resume on the next tick.
-- ══════════════════════════════════════════════════════════════════
local FactoryController = {
    Active = false,
    NextTry = 0,
}

function FactoryController:FindCore()
    if GetSea() ~= 2 then return nil end
    local core = FindMob("Core") or FindBoss("Core")
    if core and _G.State:IsTargetValid(core) then return core end
    return nil
end

function FactoryController:_Finish(token, reason)
    if _G.State.IsTraveling and _G.State.MovementOwner == "Factory" then
        TravelManager:Stop("Factory:" .. tostring(reason))
    end
    CombatController:WatchTarget(nil, nil)
    _G.State:ClearTargets()
    _G.State:ReleaseAction(token)
    self.Active = false
    self.NextTry = tick() + (_G.Settings.FactoryRetry or 2)
    if _G.State.Mode == "Factory" then _G.State:SetMode("Idle") end
end

function FactoryController:_Run(core, token)
    local ok, err = xpcall(function()
        _G.State:SetMode("Factory")
        _G.BobonStatus = "Factory: Core spawned • attacking"
        local deadline = tick() + (_G.Settings.FactoryFightTimeout or 300)
        while SessionAlive() and _G.State:IsActionValid(token) and IsAlive()
            and tick() < deadline do
            _G.State:TouchAction(token)
            if not core or not core.Parent then break end
            local hum = core:FindFirstChildOfClass("Humanoid")
            local root = core:FindFirstChild("HumanoidRootPart")
            if not hum or hum.Health <= 0 or not root then break end
            _G.State.CurrentTarget = core
            PrepareCombatTarget(core)
            EquipCombatTool()
            TravelManager:Request(root, "Factory", {
                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                combatHover = true,
                hoverHeight = _G.Settings.BossFarmHeight or 28,
            })
            if TravelManager:IsAtCombatAnchor(root) then
                Attack(core, "Core")
            end
            task.wait(0.08)
        end
        InventoryCache.At = 0
        WeaponInventoryCache.At = 0
    end, debug.traceback)
    if not ok then warn("[BobonHub] Module Error: FactoryController: " .. tostring(err)) end
    self:_Finish(token, ok and "complete" or "error")
end

function FactoryController:TryRun()
    if not _G.Settings.AutoFactoryEvent or self.Active
        or GetSea() ~= 2 or Level() < (_G.Settings.FactoryMinLevel or 700)
        or tick() < (self.NextTry or 0) or not IsAlive()
        or not _G.State:CanAct() then
        return false
    end
    local core = self:FindCore()
    if not core then return false end
    local token = _G.State:ClaimAction("Factory")
    if token == 0 then return false end
    PrepareClaimedAction("Factory")
    self.Active = true
    task.spawn(function() self:_Run(core, token) end)
    return true
end


-- ══════════════════════════════════════════════════════════════════
--              KATAKURI CONTROLLER v18 — MAX LEVEL ONLY
-- ══════════════════════════════════════════════════════════════════
local KatakuriController = {
    NextTry = 0,
    LastProgress = nil,
    LastProgressAt = 0,
    LastProgressChangeAt = 0,
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
    if InventoryHas("Mirror Fractal") then return false end
    if _G.Settings.KatakuriOnlyMax ~= false then return Level() >= MAX_LEVEL end
    return Level() >= math.max(1500, tonumber(_G.Settings.KatakuriMinLevel) or 1500)
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
    if n ~= nil and n ~= self.LastProgress then
        self.LastProgressChangeAt = now
    elseif n ~= nil and (self.LastProgressChangeAt or 0) <= 0 then
        self.LastProgressChangeAt = now
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
    local stale = remaining ~= nil and (self.LastProgressChangeAt or 0) > 0
        and tick() - self.LastProgressChangeAt > (_G.Settings.KatakuriProgressStallTimeout or 120)
    local suffix = stale and " • counter stale/rechecking" or ""
    return self:StartAction("Katakuri: Cake mobs remaining " .. label .. suffix, function(token)
        self:FarmNamed(CAKE_MOBS, token, math.min(_G.Settings.KatakuriWorkTimeout or 90, 90))
        self.LastProgressAt = 0
    end)
end

-- ══════════════════════════════════════════════════════════════════
--              FRUIT MANAGER v21.27 — ANYWHERE GACHA + SAFE STORE
--   Internal server endpoint remains CommF_("Cousin","Buy") in current public hubs.
--   No CFrame/NPC proximity/MovementOwner is required by this client path: the server
--   validates level, money and the real gacha cooldown.  This manager therefore works
--   while normal farm/progression keeps the character wherever it already is.
-- ══════════════════════════════════════════════════════════════════
local FruitManager = {
    LastStore = 0,
    Busy = false,
    NextRollAt = 0,
    LastAttemptAt = 0,
    LastSuccessAt = 0,
    LastObservedBeli = Beli(),
    SuppressMoneyWakeUntil = 0,
    LastResult = "idle",
}

_G.BobonRaidFallbackFruitPrices = _G.BobonRaidFallbackFruitPrices or {
    ["Rocket-Rocket"]=5000, ["Spin-Spin"]=7500, ["Blade-Blade"]=30000, ["Chop-Chop"]=30000,
    ["Spring-Spring"]=60000, ["Bomb-Bomb"]=80000, ["Smoke-Smoke"]=100000, ["Spike-Spike"]=180000,
    ["Flame-Flame"]=250000, ["Falcon-Falcon"]=300000, ["Ice-Ice"]=350000, ["Sand-Sand"]=420000,
    ["Dark-Dark"]=500000, ["Diamond-Diamond"]=600000, ["Light-Light"]=650000, ["Rubber-Rubber"]=750000,
    ["Barrier-Barrier"]=800000, ["Ghost-Ghost"]=940000, ["Magma-Magma"]=960000,
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
    if name:find("%-") and not FruitIdFallback[name] then return name end
    return FruitIdFallback[name] or (name .. "-" .. name)
end

local function LooksLikeFruitTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local original
    pcall(function() original = tool:GetAttribute("OriginalName") end)
    if type(original) == "string" and original ~= "" then return true end
    if tool:FindFirstChild("Fruit") then return true end
    local n = string.lower(tostring(tool.Name or ""))
    return n:find("fruit", 1, true) ~= nil
end

function FruitManager:CountPhysicalFruits()
    local count = 0
    local c = Char()
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if c then
        for _, tool in ipairs(c:GetChildren()) do
            if LooksLikeFruitTool(tool) then count = count + 1 end
        end
    end
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if LooksLikeFruitTool(tool) then count = count + 1 end
        end
    end
    return count
end


function FruitManager:CountStoredFruits()
    local ok, rows = pcall(function() return CommF_:InvokeServer("getInventoryFruits") end)
    if not ok or type(rows) ~= "table" then return nil end
    local total = 0
    for _, row in pairs(rows) do
        if type(row) == "table" then
            total = total + math.max(1, tonumber(row.Count or row.count or row.Amount or row.amount or 1) or 1)
        end
    end
    return total
end

function FruitManager:LooksLikeCooldownResult(result)
    if type(result) ~= "string" then return false end
    local text = string.lower(result)
    return text:find("cooldown",1,true) ~= nil
        or text:find("come back",1,true) ~= nil
        or text:find("wait",1,true) ~= nil
        or text:find("hour",1,true) ~= nil
        or text:find("minute",1,true) ~= nil
        or text:find("not ready",1,true) ~= nil
end

function FruitManager:LooksLikeUnavailableResult(result)
    if type(result) ~= "string" then return false end
    local text = string.lower(result)
    return text:find("not enough",1,true) ~= nil
        or text:find("don't have enough",1,true) ~= nil
        or text:find("do not have enough",1,true) ~= nil
        or text:find("can't afford",1,true) ~= nil
        or text:find("cannot afford",1,true) ~= nil
        or text:find("need $",1,true) ~= nil
        or text:find("need beli",1,true) ~= nil
        or text:find("need money",1,true) ~= nil
        or (text:find("level",1,true) ~= nil and text:find("need",1,true) ~= nil)
end

function FruitManager:RaidReserveNeeded()
    if _G.Settings.RaidReserveCheapFruit == false or not _G.State then return false end
    if GetSea() < 2 or FindOwnedTool("Special Microchip") then return false end
    local goal = tonumber(_G.State.FragmentDemandGoal) or 0
    return goal > 0 and Fragments() < goal
end

function FruitManager:GetRaidReserveTool()
    if not self:RaidReserveNeeded() then return nil end
    local cap = tonumber(_G.Settings.RaidCheapFruitMaxPrice) or 650000
    local best, bestPrice
    local c = Char()
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    for _, container in ipairs({c, backpack}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if LooksLikeFruitTool(tool) then
                    local id = FruitOriginalName(tool)
                    local price = id and _G.BobonRaidFallbackFruitPrices[id] or nil
                    if price and price <= cap and (not bestPrice or price < bestPrice) then
                        best, bestPrice = tool, price
                    end
                end
            end
        end
    end
    return best, bestPrice
end

function FruitManager:StoreBackpackFruits(force)
    if not _G.Settings.FruitEnabled then return false end
    if _G.State and _G.State.ActionOwner == "Raid" then return false end
    local now = tick()
    if not force and now - self.LastStore < (_G.Settings.FruitStoreInterval or 8) then return false end
    self.LastStore = now

    local reserveTool = self:GetRaidReserveTool()
    local storedAny = false
    local c = Char()
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    for _, container in ipairs({c, backpack}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if LooksLikeFruitTool(tool) and tool ~= reserveTool then
                    local fruitName = FruitOriginalName(tool)
                    if fruitName then
                        local ok, result = pcall(function()
                            return CommF_:InvokeServer("StoreFruit", fruitName, tool)
                        end)
                        storedAny = storedAny or (ok and result ~= false)
                        task.wait(0.10)
                    end
                end
            end
        end
    end
    return storedAny
end

function FruitManager:LooksLikeSuccessResult(result)
    if typeof(result) == "Instance" then return true end
    if type(result) == "table" then
        return result.Name ~= nil or result.Fruit ~= nil or result.Item ~= nil
    end
    if type(result) ~= "string" then return false end
    if self:LooksLikeCooldownResult(result) then return false end
    local text = string.lower(result)
    return text:find("bought",1,true) ~= nil
        or text:find("you got",1,true) ~= nil
        or text:find("received",1,true) ~= nil
        or text:find("rolled",1,true) ~= nil
end

function FruitManager:TryRandomFruit(forceWake)
    if not _G.Settings.GetFruits or not _G.Settings.FruitEnabled or self.Busy or not IsAlive() then return false end
    if Level() < (_G.Settings.RandomFruitMinLevel or 50) then
        self.LastResult = "level<50"
        return false
    end

    local now = tick()
    local confirmedCooldownUntil = (self.LastSuccessAt or 0) + (_G.Settings.RandomFruitSuccessCooldown or 7200)
    if (self.LastSuccessAt or 0) > 0 and now < confirmedCooldownUntil then return false end
    if now - (self.LastAttemptAt or 0) < (_G.Settings.RandomFruitAttemptMinGap or 0.75) then return false end
    if not forceWake and now < (self.NextRollAt or 0) then return false end
    if forceWake and now < (self.SuppressMoneyWakeUntil or 0) then return false end

    self.Busy = true
    self.LastAttemptAt = now
    _G.State.LastRandomFruit = now

    -- No NPC travel: current public implementations invoke Cousin/Buy directly.
    -- Verify by server-observable state, not merely by pcall returning successfully.
    local beforeBeli = Beli()
    local beforeFruitCount = self:CountPhysicalFruits()
    local beforeStoredCount = self:CountStoredFruits()
    _G.BobonEconomy.LastGachaAttempt = now
    _G.BobonEconomy:Notice("GACHA → request", 2.0)
    local ok, result = pcall(function()
        return CommF_:InvokeServer("Cousin", "Buy")
    end)
    _G.BobonEconomy:Notice("GACHA • result=" .. tostring(result), 2.5)

    if not ok then
        self.LastResult = "invoke-error:" .. tostring(result)
        self.NextRollAt = tick() + (_G.Settings.RandomFruitInterval or 5)
        DLog("FRUIT", "Gacha invoke failed: " .. tostring(result))
        self.Busy = false
        return false
    end

    local confirmed = self:LooksLikeSuccessResult(result)
    local knownCooldown = self:LooksLikeCooldownResult(result)
    local knownUnavailable = self:LooksLikeUnavailableResult(result)
    if not confirmed and not knownCooldown and not knownUnavailable then
        local deadline = tick() + (_G.Settings.RandomFruitResultWait or 1.50)
        repeat
            task.wait(0.12)
            local physicalNow = self:CountPhysicalFruits()
            if physicalNow > beforeFruitCount then
                confirmed = true
                break
            end
            if beforeStoredCount ~= nil then
                local storedNow = self:CountStoredFruits()
                if storedNow ~= nil and storedNow > beforeStoredCount then
                    confirmed = true
                    break
                end
            end
        until tick() >= deadline or not SessionAlive()
    end

    if confirmed then
        self.LastSuccessAt = tick()
        self.LastResult = "rolled"
        _G.State.LastRandomFruit = self.LastSuccessAt
        self.NextRollAt = self.LastSuccessAt + (_G.Settings.RandomFruitSuccessCooldown or 7200)
        self.SuppressMoneyWakeUntil = self.NextRollAt
        _G.BobonEconomy:Notice("GACHA ✓ rolled", 4.0)
        DLog("FRUIT", "Random fruit VERIFIED from anywhere")
        task.wait(0.20)
        pcall(function() self:StoreBackpackFruits(true) end)
    else
        self.LastResult = "server-rejected:" .. tostring(result)
        local delay = _G.Settings.RandomFruitUnknownRetry or 4
        if knownCooldown then
            delay = math.max(delay, _G.Settings.RandomFruitCooldownRejectDelay or 30)
            self.SuppressMoneyWakeUntil = tick() + delay
        elseif knownUnavailable then
            delay = math.max(delay, _G.Settings.RandomFruitRejectRetry or 12)
            self.SuppressMoneyWakeUntil = 0
        else
            self.SuppressMoneyWakeUntil = 0
        end
        self.NextRollAt = tick() + delay
        _G.BobonEconomy:Notice("GACHA ↻ " .. tostring(result), 3.0)
        DLog("FRUIT", "Gacha not verified; result=" .. tostring(result) .. " retry=" .. tostring(delay))
    end

    self.Busy = false
    return confirmed
end

-- v21.34 EVENT-DRIVEN GACHA POPUP GUARD. It only acts for a few seconds around
-- this script's own gacha attempt and never destroys camera children/Lighting effects.
FruitManager.PopupConnections = {}
function FruitManager:CloseRecentPopup()
    if _G.Settings.FruitPopupGuard == false then return end
    if tick() - (self.LastAttemptAt or 0) > 5.0 then return end
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then return end
    local closed = false
    local popup = pg:FindFirstChild("ModelPopup")
    if popup and popup:IsA("ScreenGui") and popup.Enabled then
        local frame = popup:FindFirstChild("CloseButtonFrame")
        local button = frame and frame:FindFirstChild("CloseButton")
        if button and type(firesignal) == "function" then
            pcall(function() firesignal(button.Activated) end)
            pcall(function() firesignal(button.MouseButton1Click) end)
        end
        pcall(function() popup.Enabled = false end)
        closed = true
    end
    local main = pg:FindFirstChild("Main")
    local inv = main and main:FindFirstChild("FruitInventory")
    if inv and inv:IsA("GuiObject") and inv.Visible then
        local exit = inv:FindFirstChild("Info") and inv.Info:FindFirstChild("Exit")
        if exit and type(firesignal) == "function" then
            pcall(function() firesignal(exit.Activated) end)
            pcall(function() firesignal(exit.MouseButton1Click) end)
        else
            pcall(function() inv.Visible = false end)
        end
        closed = true
    end
    if closed then
        local cam = workspace.CurrentCamera
        local hum = Char() and Char():FindFirstChildOfClass("Humanoid")
        if cam and hum and cam.CameraType == Enum.CameraType.Scriptable then
            pcall(function()
                cam.CameraType = Enum.CameraType.Custom
                cam.CameraSubject = hum
            end)
        end
    end
end

pcall(function()
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        FruitManager.PopupConnections[#FruitManager.PopupConnections+1] = pg.ChildAdded:Connect(function(child)
            if not SessionAlive() then return end
            local name = string.lower(tostring(child.Name or ""))
            if name:find("fruit",1,true) or name:find("gacha",1,true)
                or name:find("modelpopup",1,true) or name:find("reward",1,true) then
                task.delay(0.03, function() FruitManager:CloseRecentPopup() end)
            end
            if child.Name == "ModelPopup" then
                FruitManager.PopupConnections[#FruitManager.PopupConnections+1] = child:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if child.Parent and child.Enabled then
                        task.delay(0.02, function() FruitManager:CloseRecentPopup() end)
                    end
                end)
            end
        end)
        local popup = pg:FindFirstChild("ModelPopup")
        if popup then
            FruitManager.PopupConnections[#FruitManager.PopupConnections+1] = popup:GetPropertyChangedSignal("Enabled"):Connect(function()
                if popup.Enabled then task.delay(0.02, function() FruitManager:CloseRecentPopup() end) end
            end)
        end
    end
end)

-- v21.33 SINGLE ECONOMY WORKER — GACHA FIRST, then ALL MELEE.
-- One serial worker remains, so Beli transactions cannot race each other.
-- Gacha always gets first refusal when its client cooldown allows an attempt.
-- After success OR rejection, the worker re-reads balance and immediately probes melee.
task.spawn(function()
    while SessionAlive() and task.wait(_G.Settings.EconomyTick or 0.25) do
        if not IsAlive() then continue end

        if _G.Settings.GetFruits and _G.Settings.FruitEnabled
            and _G.BobonEconomy:TryBegin("GACHA") then
            local okGacha, rolled = pcall(function()
                FruitManager:StoreBackpackFruits()
                return FruitManager:TryRandomFruit(_G.BobonEconomy.Wake == true)
            end)
            _G.BobonEconomy:End("GACHA")
            if not okGacha then
                _G.BobonEconomy:Notice("GACHA ERROR • " .. tostring(rolled), 4.0)
            end
        end
        _G.BobonEconomy.Wake = false

        if _G.Settings.AutoFightingStyles and _G.Settings.AutoBuyMelee
            and _G.BobonEconomy:TryBegin("MELEE") then
            local okMelee, bought = pcall(function() return FightingStyleController:PurchaseTick() end)
            _G.BobonEconomy:End("MELEE")
            if not okMelee then
                _G.BobonEconomy:Notice("MELEE ERROR • " .. tostring(bought), 4.0)
            end
        end
    end
end)

-- Wake the gacha immediately when Beli increases.  This removes the old 30-second
-- blind window where the player could already have enough money but the buyer slept.
do
    local data = LP:FindFirstChild("Data")
    local beliValue = data and data:FindFirstChild("Beli")
    if beliValue then
        FruitManager.LastObservedBeli = tonumber(beliValue.Value) or Beli()
        beliValue:GetPropertyChangedSignal("Value"):Connect(function()
            if not SessionAlive() then return end
            local current = tonumber(beliValue.Value) or Beli()
            local previous = tonumber(FruitManager.LastObservedBeli) or 0
            FruitManager.LastObservedBeli = current
            if current <= previous then return end
            if not IsAlive() then return end
            -- Wake the serial economy immediately. Gacha gets first refusal; if it is
            -- cooldown-blocked, melee still sees the new balance in the same cycle.
            FruitManager.NextRollAt = 0
            _G.BobonEconomy.Wake = true
        end)
    end
end


-- ══════════════════════════════════════════════════════════════════
--   v19.0 SMART FRAGMENT MANAGER + BASIC RAID CONTROLLER
--   Only activates when live progression has registered a Fragment shortage.
--   Never auto-awakens fruit and never uses Advanced/Order raids for farming.
-- ══════════════════════════════════════════════════════════════════
local FragmentManager = {}
local RaidController = {
    Active = false,
    NextTry = 0,
    LastChipResult = nil,
    CurrentRaidName = nil,
    StartFragments = 0,
}

function FragmentManager:GetDemand()
    local state = _G.State
    if not state then return nil end
    local at = tonumber(state.FragmentDemandAt) or 0
    if at <= 0 or tick() - at > (_G.Settings.RaidFragmentDemandTTL or 120) then
        state.FragmentDemandGoal = 0
        state.FragmentDemandCost = 0
        state.FragmentDemandReason = nil
        state.FragmentDemandPriority = 0
        return nil
    end
    local goal = math.max(0, tonumber(state.FragmentDemandGoal) or 0)
    if goal <= 0 or Fragments() >= goal then
        state.FragmentDemandGoal = 0
        state.FragmentDemandCost = 0
        state.FragmentDemandReason = nil
        state.FragmentDemandPriority = 0
        state.FragmentDemandAt = 0
        return nil
    end
    return {Goal=goal, Cost=tonumber(state.FragmentDemandCost) or 0,
        Reason=state.FragmentDemandReason or "Progression",
        Priority=tonumber(state.FragmentDemandPriority) or 0}
end

local function RaidTimerVisible()
    local pg = LP:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local timer = main and main:FindFirstChild("Timer")
    return timer and timer:IsA("GuiObject") and timer.Visible == true or false
end

local function RaidLocationPosition(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj.Position, obj.CFrame end
    if obj:IsA("Model") then
        local ok, cf = pcall(function() return obj:GetPivot() end)
        if ok then return cf.Position, cf end
    end
    local ok, p = pcall(function() return obj.Position end)
    if ok and typeof(p) == "Vector3" then return p, CFrame.new(p) end
    return nil
end

function RaidController:GetRaidLocations()
    local origin = workspace:FindFirstChild("_WorldOrigin")
    local locations = origin and origin:FindFirstChild("Locations")
    if not locations then return {} end
    local out = {}
    for i = 1, 5 do
        local obj = locations:FindFirstChild("Island " .. i)
        local pos, cf = RaidLocationPosition(obj)
        if obj and pos and IsValidPos(pos) then
            out[#out + 1] = {Index=i, Object=obj, Position=pos, CFrame=cf}
        end
    end
    return out
end

function RaidController:IsRaidActive()
    return RaidTimerVisible() or #self:GetRaidLocations() > 0
end

function RaidController:GetBasicRaidNames()
    local names, seen = {}, {}
    local mod = RS:FindFirstChild("Raids")
    if mod and mod:IsA("ModuleScript") then
        local ok, data = pcall(require, mod)
        if ok and type(data) == "table" and type(data.raids) == "table" then
            for _, name in pairs(data.raids) do
                if type(name) == "string" and name ~= "" and not seen[name] then
                    seen[name] = true
                    names[#names + 1] = name
                end
            end
        end
    end
    if #names == 0 then
        for _, name in ipairs({"Flame","Dark","Ice","Sand","Smoke"}) do
            names[#names + 1] = name
        end
    end
    return names
end

function RaidController:ChooseRaidName()
    local available, availableSet = self:GetBasicRaidNames(), {}
    for _, name in ipairs(available) do availableSet[string.lower(name)] = name end
    local data = LP:FindFirstChild("Data")
    local fruit = data and data:FindFirstChild("DevilFruit")
    local current = fruit and string.lower(tostring(fruit.Value or "")) or ""
    current = current:match("^([^%-]+)") or current
    local prefs = _G.Settings.RaidPreferredNames or {"Flame","Dark","Ice","Sand","Smoke"}
    for _, wanted in ipairs(prefs) do
        local live = availableSet[string.lower(wanted)]
        if live and string.lower(wanted) ~= current then return live end
    end
    for _, wanted in ipairs(prefs) do
        local live = availableSet[string.lower(wanted)]
        if live then return live end
    end
    return available[1]
end

local function FindSpecialMicrochip()
    return FindOwnedTool("Special Microchip") or HasItem("Special Microchip")
end

function RaidController:GetFruitCatalogPrices()
    local prices = {}
    local ok, rows = pcall(function() return CommF_:InvokeServer("GetFruits") end)
    if ok and type(rows) == "table" then
        for _, row in pairs(rows) do
            if type(row) == "table" then
                local name = row.Name or row.name
                local price = tonumber(row.Price or row.price)
                if name and price then prices[tostring(name)] = price end
            end
        end
    end
    return prices
end

function RaidController:LoadCheapestStoredFruit()
    local prices = self:GetFruitCatalogPrices()
    local ok, rows = pcall(function() return CommF_:InvokeServer("getInventoryFruits") end)
    if not ok or type(rows) ~= "table" then return false end
    local bestName, bestPrice
    local cap = tonumber(_G.Settings.RaidCheapFruitMaxPrice) or 650000
    for _, row in pairs(rows) do
        if type(row) == "table" then
            local name = row.Name or row.name
            if name then
                local rawName = tostring(name)
                local fallbackId = FruitIdFallback[rawName] or rawName
                local price = tonumber(row.Price or row.price or prices[rawName] or _G.BobonRaidFallbackFruitPrices[fallbackId])
                if price and price <= cap and (not bestPrice or price < bestPrice) then
                    bestName, bestPrice = tostring(name), price
                end
            end
        end
    end
    if not bestName then return false end
    local okLoad = pcall(function() CommF_:InvokeServer("LoadFruit", bestName) end)
    if not okLoad then return false end
    task.wait(0.45)
    return true
end

function RaidController:GetPhysicalCheapFruit()
    local cap = tonumber(_G.Settings.RaidCheapFruitMaxPrice) or 650000
    local best, bestPrice
    local reserveTool, reservePrice = FruitManager:GetRaidReserveTool()
    if reserveTool and reserveTool.Parent then return reserveTool, reservePrice end
    for _, container in ipairs({Char(), LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if LooksLikeFruitTool(tool) then
                    local id = FruitOriginalName(tool)
                    local price = id and _G.BobonRaidFallbackFruitPrices[id] or nil
                    if price and price <= cap and (not bestPrice or price < bestPrice) then
                        best, bestPrice = tool, price
                    end
                end
            end
        end
    end
    return best, bestPrice
end

function RaidController:ProtectBackpackFruits(keepTool)
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    local c = Char()
    for _, container in ipairs({c, backpack}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if LooksLikeFruitTool(tool) and tool ~= keepTool then
                    local fruitName = FruitOriginalName(tool)
                    if fruitName then
                        pcall(function() CommF_:InvokeServer("StoreFruit", fruitName, tool) end)
                        task.wait(0.08)
                    end
                end
            end
        end
    end
end

function RaidController:AcquireChip(raidName)
    if FindSpecialMicrochip() then return true end

    local function verifyChip(delay)
        task.wait(delay or 0.35)
        return FindSpecialMicrochip() ~= nil
    end

    local function selectNormal()
        local ok, result = pcall(function() return CommF_:InvokeServer("RaidsNpc", "Select", raidName) end)
        self.LastChipResult = ok and result or tostring(result)
        return ok and verifyChip(0.45)
    end

    local function selectWithFruit(tool)
        if not tool or not tool.Parent then return false end
        local hum = Char() and Char():FindFirstChildOfClass("Humanoid")
        if hum and tool.Parent ~= Char() then pcall(function() hum:EquipTool(tool) end); task.wait(0.12) end
        local id = FruitOriginalName(tool)
        local raw = tostring(tool.Name or "")
        local stripped = raw:gsub("%s+[Ff]ruit$", "")
        for _, fruitArg in ipairs({raw, stripped, id}) do
            if fruitArg and tostring(fruitArg) ~= "" then
                local ok, result = pcall(function()
                    return CommF_:InvokeServer("RaidsNpc", "Select", raidName, fruitArg)
                end)
                self.LastChipResult = ok and result or tostring(result)
                if ok and verifyChip(0.25) then return true end
            end
        end
        return selectNormal()
    end

    -- Prefer exactly one cheap physical fruit when Fragment progression needs Raid.
    local cheap = self:GetPhysicalCheapFruit()
    self:ProtectBackpackFruits(cheap)
    task.wait(0.12)
    if cheap and cheap.Parent and selectWithFruit(cheap) then return true end

    -- Normal Beli chip route next. The server owns its real cooldown.
    if selectNormal() then return true end

    -- If Beli is cooldown-blocked, explicitly unstore the cheapest safe fruit and retry.
    if self:LoadCheapestStoredFruit() then
        task.wait(0.20)
        local loaded = self:GetPhysicalCheapFruit()
        if loaded and selectWithFruit(loaded) then return true end
    end
    return false
end

function RaidController:FindStartDetector()
    local map = workspace:FindFirstChild("Map")
    if not map then return nil end
    local sea = GetSea()
    local preferred = sea == 2 and map:FindFirstChild("CircleIsland") or (sea == 3 and map:FindFirstChild("Boat Castle"))
    local summon = preferred and preferred:FindFirstChild("RaidSummon2", true)
    if summon then
        local cd = summon:FindFirstChildWhichIsA("ClickDetector", true)
        if cd then return cd end
        local pp = summon:FindFirstChildWhichIsA("ProximityPrompt", true)
        if pp then return pp end
    end
    for _, node in ipairs(map:GetDescendants()) do
        if node.Name == "RaidSummon2" then
            local cd = node:FindFirstChildWhichIsA("ClickDetector", true)
            if cd then return cd end
            local pp = node:FindFirstChildWhichIsA("ProximityPrompt", true)
            if pp then return pp end
        end
    end
    return nil
end

function RaidController:TravelNear(cf, token, timeout)
    if typeof(cf) ~= "CFrame" then return false end
    local deadline = tick() + (timeout or 25)
    while SessionAlive() and IsAlive() and _G.State:IsActionValid(token) and tick() < deadline do
        _G.State:TouchAction(token)
        local root = HRP()
        if root and (root.Position-cf.Position).Magnitude <= 9 then return true end
        TravelManager:Request(cf, "Raid", {arrivalThreshold=7, speed=_G.Settings.RaidTravelSpeed or 300})
        task.wait(0.06)
    end
    return false
end

function RaidController:SolveSea2Lab(token)
    if GetSea() ~= 2 or _G.Settings.RaidLabFallback == false then return false end
    local map = workspace:FindFirstChild("Map")
    local circle = map and map:FindFirstChild("CircleIsland")
    local lab = circle and circle:FindFirstChild("Lab")
    local combo = lab and lab:FindFirstChild("Combo")
    if not combo then return false end

    local targets = {"Red","Blue","Green","Blue"}
    local function partOf(obj)
        if not obj then return nil end
        if obj:IsA("BasePart") then return obj end
        return obj:FindFirstChildWhichIsA("BasePart", true)
    end
    local function colorName(obj)
        local part = partOf(obj)
        if not part then return "Unknown" end
        local bc = string.lower(tostring(part.BrickColor or ""))
        local c = part.Color
        if bc:find("red",1,true) or (c.R > 0.60 and c.G < 0.35 and c.B < 0.35) then return "Red" end
        if bc:find("blue",1,true) or (c.B > 0.55 and c.R < 0.40) then return "Blue" end
        if bc:find("green",1,true) or (c.G > 0.55 and c.R < 0.40 and c.B < 0.45) then return "Green" end
        return "Other"
    end

    for i = 1, 4 do
        if not _G.State:IsActionValid(token) then return false end
        local button = combo:FindFirstChild("Button" .. i)
        local part = partOf(button)
        local detector = button and button:FindFirstChildWhichIsA("ClickDetector", true)
        if not button or not part or not detector or type(fireclickdetector) ~= "function" then return false end
        self:TravelNear(part.CFrame * CFrame.new(0, 3, 0), token, 25)
        local attempts = 0
        while colorName(button) ~= targets[i] and attempts < (_G.Settings.RaidLabMaxClicksPerButton or 8) do
            _G.State:TouchAction(token)
            pcall(function() fireclickdetector(detector, 1) end)
            attempts = attempts + 1
            task.wait(0.22)
        end
        if colorName(button) ~= targets[i] then return false end
    end
    return true
end

function RaidController:StartRaid(token)
    if self:IsRaidActive() then return true end
    if not FindSpecialMicrochip() then return false end

    local function fireStart()
        local detector = self:FindStartDetector()
        if not detector then return false end
        if detector:IsA("ClickDetector") and type(fireclickdetector) == "function" then
            return pcall(function() fireclickdetector(detector, 1) end)
        elseif detector:IsA("ProximityPrompt") and type(fireproximityprompt) == "function" then
            return pcall(function() fireproximityprompt(detector) end)
        end
        return false
    end
    local function confirm()
        local deadline = tick() + (_G.Settings.RaidStartConfirmTimeout or 12)
        while SessionAlive() and IsAlive() and tick() < deadline do
            if token and not _G.State:IsActionValid(token) then return false end
            if self:IsRaidActive() then return true end
            task.wait(0.20)
        end
        return self:IsRaidActive()
    end

    if fireStart() and confirm() then return true end
    if GetSea() == 2 and token and self:SolveSea2Lab(token) then
        task.wait(_G.Settings.RaidStartRetry or 2.0)
        if fireStart() and confirm() then return true end
    end
    self.LastChipResult = "RAID-START-UNAVAILABLE"
    return false
end

function RaidController:GetIslandWithEnemies()
    local islands = self:GetRaidLocations()
    if #islands == 0 then return nil, nil, nil end
    local folder = workspace:FindFirstChild("Enemies")
    local radius = _G.Settings.RaidGatherRadius or 700
    local fallback = islands[#islands]
    for i = #islands, 1, -1 do
        local island = islands[i]
        local nearest, nearestDist, boss = nil, math.huge, nil
        if folder then
            for _, mob in ipairs(folder:GetChildren()) do
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local root = mob:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    local d = (root.Position - island.Position).Magnitude
                    if d <= radius then
                        if IsRaidBossModel(mob) then boss = boss or mob
                        elseif d < nearestDist then nearest, nearestDist = mob, d end
                    end
                end
            end
        end
        if boss or nearest then return island, nearest, boss end
    end
    return fallback, nil, nil
end

function RaidController:FightTick(token)
    local island, regular, boss = self:GetIslandWithEnemies()
    if not island then _G.BobonStatus = "Raid: Waiting for island" return end
    if boss and _G.State:IsTargetValid(boss) then
        FarmPositionController:ReleaseCluster()
        local root = boss:FindFirstChild("HumanoidRootPart")
        if root then
            _G.State.CurrentTarget = boss
            PrepareCombatTarget(boss)
            TravelManager:Request(root, "Raid", {arrivalThreshold=_G.Settings.FarmArrivalThreshold,
                combatHover=true, hoverHeight=_G.Settings.RaidHoverHeight or 22,
                speed=_G.Settings.RaidTravelSpeed or 300, persistent=true})
            if TravelManager:IsAtCombatAnchor(root) then EquipCombatTool(); Attack(boss, boss.Name) end
            _G.BobonStatus = "Raid: Final boss"
        end
        return
    end

    ClusterFarmController:Activate("RAID", {"*"}, island.CFrame, "Raid")
    ClusterFarmController:Tick()
    local phase, stacked, total = ClusterFarmController:UpdatePhase()
    local acquire = phase == "ACQUIRE" and ClusterFarmController:GetAcquireTarget() or nil
    local acquireRoot = acquire and acquire:FindFirstChild("HumanoidRootPart")
    if acquireRoot and _G.State:IsTargetValid(acquire) then
        _G.State.CurrentTarget = acquire
        TravelManager:Request(acquireRoot, "Raid", {
            arrivalThreshold=_G.Settings.ClusterAcquireArrivalThreshold or 8,
            combatHover=true, acquireSweep=true,
            speed=_G.Settings.ClusterAcquireTravelSpeed or _G.Settings.RaidTravelSpeed or 300,
        })
        _G.BobonStatus = ("Raid: Island %d • ACQUIRE %d/%d"):format(island.Index, stacked, total)
        return
    end

    local primary = ClusterFarmController:SelectPrimary() or regular
    local hover = ClusterFarmController:GetHoverCFrame(_G.Settings.RaidHoverHeight or 22)
    if hover then
        TravelManager:Request(hover, "Raid", {arrivalThreshold=_G.Settings.FarmArrivalThreshold,
            combatHover=true, speed=_G.Settings.RaidTravelSpeed or 300, persistent=true})
    end
    if phase == "KILL" and primary and _G.State:IsTargetValid(primary) then
        _G.State.CurrentTarget = primary
        PrepareCombatTarget(primary)
        if TravelManager:IsAtCombatAnchor() then EquipCombatTool(); Attack(primary, primary.Name) end
    end
    _G.BobonStatus = ("Raid: Island %d • %s %d/%d • %d/%d Frag")
        :format(island.Index, tostring(phase), stacked, total, Fragments(),
            math.max(Fragments(), tonumber(_G.State.FragmentDemandGoal) or 0))
end

function RaidController:_Finish(token, reason)
    FarmPositionController:ReleaseCluster()
    CombatController:WatchTarget(nil, nil)
    if _G.State.IsTraveling and _G.State.MovementOwner == "Raid" then TravelManager:Stop("Raid:" .. tostring(reason)) end
    _G.State:ClearTargets()
    _G.State:ReleaseAction(token)
    self.Active = false
    self.CurrentRaidName = nil
    _G.State.RaidLastFinish = tick()
    if _G.State.Mode == "Raiding" then _G.State:SetMode("Idle") end
end

function RaidController:_Run(token, demand)
    local ok, err = xpcall(function()
        self.StartFragments = Fragments()
        _G.State.RaidLastStart = tick()
        local deadline = tick() + (_G.Settings.RaidRunTimeout or 900)
        while SessionAlive() and _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
            _G.State:TouchAction(token)
            local liveDemand = FragmentManager:GetDemand()
            if not liveDemand or Fragments() >= liveDemand.Goal then break end
            local raidName = self:ChooseRaidName()
            if not raidName then self.NextTry = tick() + (_G.Settings.RaidNoChipRetry or 90); break end
            self.CurrentRaidName = raidName
            _G.State:SetMode("Raiding")
            _G.BobonStatus = ("Fragments: %d/%d • %s"):format(Fragments(), liveDemand.Goal, raidName)
            if not self:IsRaidActive() then
                if not self:AcquireChip(raidName) then
                    self.NextTry = tick() + (_G.Settings.RaidNoChipRetry or 90)
                    _G.BobonStatus = "Fragments: No raid chip • resume farm"
                    break
                end
                if not self:StartRaid(token) then
                    self.NextTry = tick() + (_G.Settings.RaidNoChipRetry or 90)
                    _G.BobonStatus = "Fragments: Raid start unavailable • resume farm"
                    break
                end
            end
            local raidStartFrag = Fragments()
            local activeDeadline = tick() + 780
            while SessionAlive() and _G.State:IsActionValid(token) and IsAlive()
                and tick() < activeDeadline and self:IsRaidActive() do
                _G.State:TouchAction(token)
                self:FightTick(token)
                task.wait(0.06)
            end
            FarmPositionController:ReleaseCluster()
            if _G.State.IsTraveling and _G.State.MovementOwner == "Raid" then TravelManager:Stop("RaidRoundEnd") end
            task.wait(1.0)
            local gain = math.max(0, Fragments() - raidStartFrag)
            _G.State.RaidLastGain = gain
            if gain <= 0 and not self:IsRaidActive() then self.NextTry = tick() + 30; break end
            -- Never call Awakener here. Fragment farming must not spend its reward.
        end
    end, debug.traceback)
    if not ok then warn("[BobonHub] Module Error: RaidController: " .. tostring(err)) end
    self:_Finish(token, ok and "complete" or "error")
end

function RaidController:TryStart()
    if not _G.Settings.AutoFragmentRaid or self.Active or tick() < (self.NextTry or 0) then return false end
    if GetSea() < 2 or Level() < 1100 or not IsAlive() or not _G.State:CanAct() then return false end
    local demand = FragmentManager:GetDemand()
    if not demand then return false end
    local token = _G.State:ClaimAction("Raid")
    if token == 0 then return false end
    PrepareClaimedAction("Raid")
    self.Active = true
    task.spawn(function() self:_Run(token, demand) end)
    return true
end

function RaidController:TryPreempt()
    local demand = FragmentManager:GetDemand()
    if not demand then return false end
    local started = self:TryStart()
    if started then
        _G.State.WorkIntent = "RAID:" .. tostring(demand.Reason or "Fragments")
        _G.BobonStatus = ("Fragments: %d/%d • preempting farm"):format(Fragments(), demand.Goal or 0)
    end
    return started
end

-- ══════════════════════════════════════════════════════════════════
--      v21.35 ONE PRIORITY SCHEDULER + SEA/STALL HARDENING
--   No movement subsystem below runs in a second progression watcher.
--   The serial Economy worker remains separate because Gacha/Melee purchases
--   own money, not movement, and already arbitrate Gacha-first atomically.
-- ══════════════════════════════════════════════════════════════════
function _G.BobonSeaTransitionCleanup(newSea)
    local state = _G.State
    if not state then return false end
    newSea = tonumber(newSea) or GetSea()
    if state.LastKnownSea == 0 then
        state.LastKnownSea = newSea
        state.Sea = newSea
        return false
    end
    if state.LastKnownSea == newSea then return false end

    local oldSea = state.LastKnownSea
    state.LastKnownSea = newSea
    state.Sea = newSea
    state.SeaTransitionAt = tick()
    state.PriorityStage = "SEA_TRANSITION"
    state.PriorityDetail = tostring(oldSea) .. "→" .. tostring(newSea)
    state.WorkIntent = "SEA_TRANSITION"
    _G.BobonStatus = ("Sea: %d → %d • clearing stale state"):format(oldSea, newSea)

    pcall(function() TravelManager:Stop("SeaTransition") end)
    pcall(function() FarmPositionController:ReleaseCluster() end)
    pcall(function() CombatController:WatchTarget(nil, nil) end)
    pcall(function() state:ClearTargets() end)
    state.ActiveQuestMob = nil
    state.QuestLastSeenAt = 0
    state.QuestClosedSince = 0
    state.QuestClosedStable = false
    state.ProgressionLock = nil
    state.FragmentDemandGoal = 0
    state.FragmentDemandCost = 0
    state.FragmentDemandReason = nil
    state.FragmentDemandPriority = 0
    state.FragmentDemandAt = 0

    pcall(function()
        ClusterFarmController.LastBatch = {}
        ClusterFarmController.SpawnMemory = {}
        ClusterFarmController.SpawnMarkerCache = {}
        ClusterFarmController.SpawnMarkerCacheAt = {}
        ClusterFarmController.SpawnRouteIndex = {}
        ClusterFarmController.PatrolIndex = 1
        ClusterFarmController.PatrolLastPoint = nil
    end)
    pcall(function() InventoryCache.At = 0 end)
    pcall(function() WeaponInventoryCache.At = 0 end)
    pcall(function()
        if _G.BobonFruitFinderState then
            _G.BobonFruitFinderState.LastTool = nil
            _G.BobonFruitFinderState.LastScan = 0
        end
        if _G.BobonSmartFarmWatch then
            _G.BobonSmartFarmWatch.LastProgressAt = tick()
            _G.BobonSmartFarmWatch.LastPos = nil
            _G.BobonSmartFarmWatch.LastQuest = ""
            _G.BobonSmartFarmWatch.LastTarget = nil
            _G.BobonSmartFarmWatch.LastHP = nil
            _G.BobonSmartFarmWatch.RetryCount = 0
        end
        _G.BobonFarmStuckHopRequested = nil
    end)
    pcall(function()
        for key in pairs(ItemProgression.NextOptional or {}) do ItemProgression.NextOptional[key] = 0 end
    end)
    return true
end

function _G.BobonPriorityWatchdogTick()
    local state = _G.State
    if not state then return false end
    if state.ActiveActionToken == 0 then
        state.PriorityWatchOwner = nil
        state.PriorityWatchStatus = nil
        state.PriorityWatchAt = 0
        return false
    end

    local owner = tostring(state.ActionOwner or "Action")
    local status = tostring(_G.BobonStatus or "")
    if state.PriorityWatchOwner ~= owner or state.PriorityWatchStatus ~= status then
        state.PriorityWatchOwner = owner
        state.PriorityWatchStatus = status
        state.PriorityWatchAt = tick()
        return false
    end

    local staleFor = tick() - (tonumber(state.PriorityWatchAt) or tick())
    if staleFor < (_G.Settings.PriorityStatusStallTimeout or 75) then return false end
    local liveTarget = state.CurrentTarget and state:IsTargetValid(state.CurrentTarget)
    if state.IsTraveling or liveTarget then return false end

    warn(("[BobonHub] Progression stall release: %s • %s • %.1fs")
        :format(owner, status, staleFor))
    pcall(function() FarmPositionController:ReleaseCluster() end)
    pcall(function() TravelManager:Stop("PriorityStall") end)
    pcall(function() CombatController:WatchTarget(nil, nil) end)
    pcall(function() state:ClearTargets() end)
    state:ForceReleaseAction("PriorityStall")
    state:SetMode("Idle")
    state.WorkIntent = "RECOVER:PRIORITY_STALL"
    state.PriorityStage = "STALL_RECOVERY"
    state.PriorityWatchAt = tick()
    return true
end

-- v21.39 dropped-fruit finder. It is called by the one Priority Scheduler and
-- owns movement only after ClaimAction, so it cannot race normal Farm travel.
_G.BobonFruitFinderState = {
    LastScan=0,
    LastTool=nil,
    Blocked=setmetatable({}, {__mode="k"}),
    Candidates=setmetatable({}, {__mode="k"}),
    Initialized=false,
    Connection=nil,
}

function _G.BobonFruitCandidateAdd(obj)
    if not obj or not obj:IsA("Tool") then return false end
    local low = string.lower(tostring(obj.Name))
    local tip = tostring(obj.ToolTip or "")
    local originalName = obj:GetAttribute("OriginalName")
    local isFruit = tip == "Blox Fruit"
        or (low:find("fruit", 1, true) ~= nil and (originalName ~= nil or obj:FindFirstChild("Handle") ~= nil))
    if isFruit then
        _G.BobonFruitFinderState.Candidates[obj] = true
        return true
    end
    return false
end

function _G.BobonEnsureFruitCache()
    local state = _G.BobonFruitFinderState
    if state.Initialized then return end
    state.Initialized = true
    -- One initial inventory of world fruit candidates; after that DescendantAdded
    -- maintains the cache. This removes the old full-workspace scan every 0.75s.
    for _, obj in ipairs(workspace:GetDescendants()) do
        _G.BobonFruitCandidateAdd(obj)
    end
    if not state.Connection then
        state.Connection = workspace.DescendantAdded:Connect(function(obj)
            if SessionAlive() then pcall(_G.BobonFruitCandidateAdd, obj) end
        end)
    end
end

function _G.BobonFindWorldFruit()
    if _G.Settings.FruitFinderEnabled == false then return nil end
    _G.BobonEnsureFruitCache()
    local state = _G.BobonFruitFinderState
    local now = tick()
    if now - (tonumber(state.LastScan) or 0) < (_G.Settings.FruitFinderScanInterval or 0.85) then
        local old = state.LastTool
        if old and old.Parent then return old end
        return nil
    end
    state.LastScan = now
    state.LastTool = nil
    local me = HRP()
    if not me then return nil end
    local maxDistance = tonumber(_G.Settings.FruitFinderMaxDistance) or 450
    local best, bestDist
    for obj in pairs(state.Candidates) do
        if not obj or not obj.Parent or obj:IsDescendantOf(LP) then
            state.Candidates[obj] = nil
        else
            local blockedUntil = state.Blocked and tonumber(state.Blocked[obj]) or 0
            if blockedUntil <= now then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    local d = (handle.Position - me.Position).Magnitude
                    if d <= maxDistance and (not bestDist or d < bestDist) then
                        best, bestDist = obj, d
                    end
                end
            end
        end
    end
    state.LastTool = best
    return best
end

function _G.BobonFruitFinderTryRun()
    if _G.Settings.FruitFinderEnabled == false or not _G.State:CanAct() then return false end
    if _G.Settings.FruitFinderPreemptQuest ~= true then
        local hq = HasQuest()
        if hq ~= false or _G.State.Mode == "Farming" or _G.State.FarmTarget ~= nil
            or (_G.State.ActiveQuestMob and tostring(_G.State.ActiveQuestMob) ~= "") then
            return false
        end
        if _G.State.QuestClosedStable ~= true then return false end
    end
    local tool = _G.BobonFindWorldFruit()
    if not tool or not tool.Parent then return false end
    local token = _G.State:ClaimAction("FruitFinder")
    if token == 0 then return false end
    PrepareClaimedAction("FruitFinder")
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Fruit Finder: " .. tostring(tool.Name)
    task.spawn(function()
        local ok, err = xpcall(function()
            local deadline = tick() + (tonumber(_G.Settings.FruitFinderTimeout) or 28)
            while _G.State:IsActionValid(token) and tool.Parent and IsAlive() and tick() < deadline do
                _G.State:TouchAction(token)
                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                if not handle then break end
                local me = HRP()
                if not me then break end
                local maxDist = tonumber(_G.Settings.FruitFinderMaxDistance) or 450
                if (me.Position - handle.Position).Magnitude > maxDist then break end
                if (me.Position - handle.Position).Magnitude > 8 then
                    TravelManager:Request(handle.CFrame, "FruitFinder", {
                        arrivalThreshold=5, persistent=false, combatHover=false,
                        speed=_G.Settings.ClusterFieldPatrolSpeed or 400,
                    })
                else
                    if type(firetouchinterest) == "function" then
                        pcall(function()
                            firetouchinterest(me, handle, 0)
                            task.wait(0.04)
                            firetouchinterest(me, handle, 1)
                        end)
                    else
                        pcall(function() me.CFrame = handle.CFrame end)
                    end
                end
                task.wait(0.08)
            end
            task.wait(0.2)
            pcall(function() FruitManager:StoreBackpackFruits() end)
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: FruitFinder: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "FruitFinder" then
            TravelManager:Stop("FruitFinderComplete")
        end
        local stillWorld = tool and tool.Parent and not tool:IsDescendantOf(LP)
        if stillWorld and _G.BobonFruitFinderState.Blocked then
            _G.BobonFruitFinderState.Blocked[tool] = tick() + (tonumber(_G.Settings.FruitFinderFailedRetry) or 120)
        end
        if _G.State:IsActionValid(token) then _G.State:ReleaseAction(token) end
        if _G.State.Mode == "GettingItem" then _G.State:SetMode("Idle") end
        _G.BobonFruitFinderState.LastTool = nil
        _G.BobonFruitFinderState.LastScan = tick()
    end)
    return true
end

-- v21.39 mastery tool scheduler: set one preferred weapon only; the normal farm
-- remains the sole mastery engine. This mirrors the useful Yama/Tushita idea from
-- the shared source without creating another equip or movement worker.
function _G.BobonMasteryToolPulse()
    if _G.Settings.MasteryToolSchedulerEnabled ~= true then return false end
    if not _G.State or _G.State.ActiveActionToken ~= 0 then return false end
    if _G.Settings.AutoCDK and GetSea() == 3 and Level() >= 2200
        and not InventoryHas("Cursed Dual Katana") then
        if InventoryHas("Yama") and EffectiveMastery("Yama") < 350 then
            _G.State.PreferredCombatTool = "Yama"
            _G.State.PriorityHint = ("CDK mastery Yama %d/350"):format(EffectiveMastery("Yama"))
            return true
        end
        if InventoryHas("Tushita") and EffectiveMastery("Tushita") < 350 then
            _G.State.PreferredCombatTool = "Tushita"
            _G.State.PriorityHint = ("CDK mastery Tushita %d/350"):format(EffectiveMastery("Tushita"))
            return true
        end
    end
    return false
end

-- Elite ChildAdded only wakes the scheduler; it never moves or attacks itself.
_G.BobonEliteWake = {Model=nil, At=0}
pcall(function()
    local enemies = workspace:FindFirstChild("Enemies")
    if _G.Settings.EliteWakeEnabled == true and enemies and not _G.BobonEliteWake.Connection then
        _G.BobonEliteWake.Connection = enemies.ChildAdded:Connect(function(mob)
            local n = mob and tostring(mob.Name) or ""
            if n == "Diablo" or n == "Deandre" or n == "Urban" then
                _G.BobonEliteWake.Model = mob
                _G.BobonEliteWake.At = tick()
                if _G.State then _G.State.PriorityHint = "Elite spawned: " .. n end
            end
        end)
    end
end)

function _G.BobonQuestFarmProtected()
    if _G.Settings.QuestFarmIsolation == false or _G.Settings.SharedSourceFarmMode == false then return false end
    local state = _G.State
    if not state or state.ActiveActionToken ~= 0 then return false end
    local hasQuest = HasQuest()
    if hasQuest ~= true then return false end
    local mobName = state.ActiveQuestMob
    return type(mobName) == "string" and mobName ~= ""
end

-- v22 atomic berry pickup. Video evidence showed short "Collect Berry" detours;
-- public current scripts identify bushes via CollectionService tag "BerryBush" and
-- berry names via bush attributes. This implementation is bounded and scheduler-owned.
_G.BobonBerryState = {Blocked=setmetatable({}, {__mode="k"}), LastTry=0}
function _G.BobonFindNearestBerry()
    if _G.Settings.BerryPickupEnabled ~= true then return nil end
    local me = HRP(); if not me then return nil end
    local maxDist = tonumber(_G.Settings.BerryPickupMaxDistance) or 550
    local bestPart, bestBush, bestDist
    local ok, bushes = pcall(function()
        return game:GetService("CollectionService"):GetTagged("BerryBush")
    end)
    if not ok or type(bushes) ~= "table" then return nil end
    local now = tick()
    for _, bush in ipairs(bushes) do
        if bush and bush.Parent and (tonumber(_G.BobonBerryState.Blocked[bush]) or 0) <= now then
            local model = bush.Parent
            for attr, value in pairs(bush:GetAttributes()) do
                if value then
                    local part = model:FindFirstChild(tostring(attr), true)
                    if part and part:IsA("BasePart") then
                        local d = (part.Position - me.Position).Magnitude
                        if d <= maxDist and (not bestDist or d < bestDist) then
                            bestPart, bestBush, bestDist = part, bush, d
                        end
                    end
                end
            end
        end
    end
    return bestPart, bestBush
end

function _G.BobonBerryTryRun()
    if _G.Settings.BerryPickupEnabled ~= true or not _G.State:CanAct() then return false end
    if tick() - (tonumber(_G.BobonBerryState.LastTry) or 0) < 1.0 then return false end
    _G.BobonBerryState.LastTry = tick()
    local part, bush = _G.BobonFindNearestBerry()
    if not part or not bush then return false end
    local token = _G.State:ClaimAction("Berry")
    if token == 0 then return false end
    PrepareClaimedAction("Berry")
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Collect Berry"
    task.spawn(function()
        local collected = false
        local ok, err = xpcall(function()
            local deadline = tick() + (tonumber(_G.Settings.BerryPickupTimeout) or 5.0)
            while _G.State:IsActionValid(token) and IsAlive() and part.Parent and tick() < deadline do
                _G.State:TouchAction(token)
                local me = HRP(); if not me then break end
                local d = (part.Position - me.Position).Magnitude
                if d > (tonumber(_G.Settings.BerryPickupMaxDistance) or 550) then break end
                if d > 5 then
                    TravelManager:Request(part.CFrame * CFrame.new(0,1,0), "Berry", {
                        arrivalThreshold=4, persistent=false, combatHover=false,
                        speed=_G.Settings.ClusterFieldPatrolSpeed or 400,
                    })
                else
                    local prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true)
                        or (bush.Parent and bush.Parent:FindFirstChildWhichIsA("ProximityPrompt", true))
                    if prompt and type(fireproximityprompt) == "function" then
                        pcall(function() fireproximityprompt(prompt) end)
                    else
                        pcall(function()
                            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            task.wait(0.08)
                            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        end)
                    end
                    task.wait(0.25)
                    collected = (not part.Parent) or (bush:GetAttribute(part.Name) ~= true)
                    if collected then break end
                end
                task.wait(0.08)
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Berry: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Berry" then TravelManager:Stop("BerryComplete") end
        if not collected and bush then
            _G.BobonBerryState.Blocked[bush] = tick() + (tonumber(_G.Settings.BerryFailedRetry) or 90)
        end
        if _G.State:IsActionValid(token) then _G.State:ReleaseAction(token) end
        if _G.State.Mode == "GettingItem" then _G.State:SetMode("Idle") end
    end)
    return true
end

-- v22 opportunistic Castle Pirate Raid. Existing FindCastleRaidMobs() already
-- validates live raid-marked/known Castle enemies; this controller merely turns
-- that observation into one bounded scheduler action.
_G.BobonCastleRaidState = {NextTry=0}
function _G.BobonCastleRaidTryRun()
    if _G.Settings.AutoCastleRaidEvent ~= true or GetSea() ~= 3
        or Level() < (tonumber(_G.Settings.CastleRaidMinLevel) or 1500)
        or not _G.State:CanAct() or tick() < (_G.BobonCastleRaidState.NextTry or 0) then return false end
    local names = FindCastleRaidMobs()
    if #names == 0 then return false end
    local token = _G.State:ClaimAction("CastleRaid")
    if token == 0 then return false end
    PrepareClaimedAction("CastleRaid")
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Castle Raid • clearing pirates"
    _G.BobonCastleRaidState.NextTry = tick() + 4
    task.spawn(function()
        local ok, err = xpcall(function()
            local deadline = tick() + (tonumber(_G.Settings.CastleRaidTimeout) or 90)
            while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
                _G.State:TouchAction(token)
                names = FindCastleRaidMobs()
                if #names == 0 then break end
                local target = FindAnyNamed(names)
                if not target or not _G.State:IsTargetValid(target) then task.wait(0.2) continue end
                local root = target:FindFirstChild("HumanoidRootPart")
                if not root then task.wait(0.1) continue end
                _G.State.CurrentTarget = target
                _G.BobonStatus = "Castle Raid • " .. tostring(target.Name)
                TravelManager:Request(root.CFrame * CFrame.new(0, tonumber(_G.Settings.SharedFarmHeight) or 25, 0),
                    "CastleRaid", {arrivalThreshold=_G.Settings.FarmArrivalThreshold, combatHover=true, persistent=true})
                local me = HRP()
                if me and (me.Position-root.Position).Magnitude <= (_G.Settings.FastAttackRange or 100) then
                    PrepareCombatTarget(target); EquipCombatTool(); Attack(target, target.Name)
                end
                task.wait(0.08)
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: CastleRaid: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "CastleRaid" then TravelManager:Stop("CastleRaidComplete") end
        _G.State:ClearTargets(); CombatController:WatchTarget(nil,nil)
        if _G.State:IsActionValid(token) then _G.State:ReleaseAction(token) end
        if _G.State.Mode == "GettingItem" then _G.State:SetMode("Idle") end
    end)
    return true
end

-- v22 GOAL PLANNER: presentation + scheduler intent source of truth. It never moves.
function _G.BobonGoalPlannerPulse()
    local state = _G.State
    if not state then return end

    -- ACTION = what owns the avatar right now.
    if state.ActiveActionToken ~= 0 and state.ActionOwner then
        state.ActionText = tostring(_G.BobonStatus or state.ActionOwner)
    elseif state.Mode == "Farming" then
        local mob = tostring(state.ActiveQuestMob or "quest mob")
        local fs = tostring(state.FState or "")
        if fs == "WAITING_MOB" or fs:find("WAIT",1,true) then
            state.ActionText = "Waiting Mob • " .. mob
        elseif fs:find("ATTACK",1,true) or fs == "SHARED_BRING_FARM" then
            state.ActionText = "Killing Mob • " .. mob
        else
            state.ActionText = "Level Farm • " .. mob
        end
    else
        state.ActionText = tostring(_G.BobonStatus or state.Mode or "Idle")
    end

    -- OBJECTIVE = long-term reason. FightingStyleController:SetPreferred may set a
    -- more precise mastery objective during the same pulse.
    local objective, progress = nil, nil
    if state.ProgressionLock then
        objective = "Required Progression"
        progress = tostring(state.ProgressionLock)
    else
        local styleStatus = FightingStyleController and tostring(FightingStyleController.LastStatus or "") or ""
        if styleStatus ~= "" and styleStatus ~= "idle" and styleStatus ~= "Godhuman ready" then
            objective = "Full Melee / Combat Style"
            progress = styleStatus
        end
        if not objective and FragmentManager then
            local ok, demand = pcall(function() return FragmentManager:GetDemand() end)
            if ok and demand then
                objective = tostring(demand.Reason or "Fragments")
                progress = ("Fragments %d/%d"):format(Fragments(), tonumber(demand.Goal) or 0)
            end
        end
        if not objective and state.PriorityStage and state.PriorityStage ~= "LEVEL_FARM"
            and state.PriorityStage ~= "BOOT" then
            objective = tostring(state.PriorityStage):gsub("_", " ")
            progress = tostring(state.PriorityDetail or "")
        end
    end
    if not objective then
        if Level() < MAX_LEVEL then
            objective = "Reach Max Level"
            progress = ("Level %d/%d"):format(Level(), MAX_LEVEL)
        else
            objective = "Endgame Completion"
            progress = tostring(state.PriorityHint or "")
        end
    end
    state.ObjectiveText = objective
    state.ObjectiveProgress = progress or ""
end

function _G.BobonOptionalDetourReady()
    local state = _G.State
    if not state or state.ActiveActionToken ~= 0 or not state:CanAct() then return false end
    if tick() < (tonumber(state.ResumeFarmUntil) or 0) then return false end
    if state.Mode == "Farming" then
        state.FarmLeaseSince = tonumber(state.FarmLeaseSince) or tick()
        if state.FarmLeaseSince == 0 then state.FarmLeaseSince = tick() end
        local minFarm = math.max(0, tonumber(_G.Settings.OptionalDetourMinFarmSeconds) or 2.0)
        if tick() - state.FarmLeaseSince < minFarm then return false end
    else
        state.FarmLeaseSince = 0
    end
    return true
end

function _G.BobonPriorityPulse()
    local state = _G.State
    if not state or not IsAlive() then return false end
    local sea = GetSea()
    if _G.Settings.SeaTransitionCleanup ~= false and _G.BobonSeaTransitionCleanup(sea) then return true end
    state.Sea = sea
    if _G.BobonPriorityWatchdogTick() then return true end
    pcall(_G.BobonGoalPlannerPulse)
    if state.ActiveActionToken ~= 0 or not state:CanAct() then return false end

    -- 1) Sticky hard gates: Saber / Second Sea / Bartilo / Third Sea.
    local blocking = ItemProgression:GetBlockingReason()
    state.ProgressionLock = blocking
    if blocking then
        state.PriorityStage = "HARD_GATE"
        state.PriorityDetail = tostring(blocking)
        state.WorkIntent = "PROGRESSION:" .. tostring(blocking)
        local ok, started = pcall(function() return ItemProgression:RunChecks(true, true) end)
        if not ok then warn("[BobonHub] Module Error: PriorityHardGate: " .. tostring(started)) end
        if not started and state.ActiveActionToken == 0 then
            _G.BobonStatus = "Progression: " .. tostring(blocking) .. " • waiting/retry"
        end
        return true
    end

    local questFarmProtected = _G.BobonQuestFarmProtected()
    local optionalReady = _G.BobonOptionalDetourReady()
    -- v22: an active quest is a resume context, not a permanent prison. Optional
    -- work may interrupt only through this scheduler, only when optionalReady, and
    -- ReleaseAction grants the farm a grace window before another detour can start.

    -- Dropped world fruit is a short, bounded pickup action. Mandatory hard gates
    -- stay above it; ordinary level farm and optional progression stay below it.
    do
        local ok, started = true, false
        if optionalReady and (not questFarmProtected or _G.Settings.FruitFinderPreemptQuest == true) then ok, started = pcall(_G.BobonFruitFinderTryRun) end
        if not ok then warn("[BobonHub] Module Error: PriorityFruitFinder: " .. tostring(started))
        elseif started then
            state.PriorityStage = "FRUIT_FINDER"
            state.PriorityDetail = tostring(_G.BobonStatus or "Fruit")
            return true
        end
    end

    -- Berry collection is the same kind of short atomic detour as fruit pickup.
    do
        local ok, started = true, false
        if optionalReady then ok, started = pcall(_G.BobonBerryTryRun) end
        if not ok then warn("[BobonHub] Module Error: PriorityBerry: " .. tostring(started))
        elseif started then
            state.PriorityStage = "BERRY"
            state.PriorityDetail = "Collect"
            return true
        end
    end

    -- If an Elite just streamed in and Yama still needs Elite progress, wake the
    -- existing Yama progression immediately rather than waiting for a later poll.
    do
        local wake = _G.BobonEliteWake
        local elite = wake and wake.Model
        if optionalReady and _G.Settings.EliteWakeEnabled == true
            and (not questFarmProtected or _G.Settings.EliteWakePreemptQuest == true)
            and elite and elite.Parent and GetSea() == 3 and Level() >= 1500
            and _G.Settings.AutoCDK and not InventoryHas("Yama") then
            local progress = 0
            pcall(function() progress = tonumber(CommF_:InvokeServer("EliteHunter", "Progress")) or 0 end)
            if progress < 30 then
                local ok, started = pcall(function() return ItemProgression:CheckYama() end)
                if not ok then warn("[BobonHub] Module Error: PriorityEliteWake: " .. tostring(started))
                elseif started then
                    state.PriorityStage = "ELITE_YAMA"
                    state.PriorityDetail = tostring(elite.Name) .. " • " .. tostring(progress) .. "/30"
                    wake.Model = nil
                    return true
                end
            else
                wake.Model = nil
            end
        elseif wake and elite and (not elite.Parent or tick() - (tonumber(wake.At) or 0) > 120) then
            wake.Model = nil
        end
    end

    -- Live Castle pirate raid is opportunistic, bounded, and resumes the quest afterwards.
    do
        local ok, started = true, false
        if optionalReady then ok, started = pcall(_G.BobonCastleRaidTryRun) end
        if not ok then warn("[BobonHub] Module Error: PriorityCastleRaid: " .. tostring(started))
        elseif started then
            state.PriorityStage = "CASTLE_RAID"
            state.PriorityDetail = "Pirates"
            return true
        end
    end

    -- Passive mastery/TTK pulse is throttled but belongs to this scheduler.
    if tick() - (tonumber(state.PriorityLastPassiveAt) or 0)
        >= (_G.Settings.PriorityPassiveInterval or 1.25) then
        state.PriorityLastPassiveAt = tick()
        state.PriorityHint = ""
        pcall(_G.BobonMasteryToolPulse)
        local meleeTraining = false
        if _G.Settings.AutoFightingStyles and _G.Settings.AutoBuyMelee then
            local ok, result = pcall(function() return FightingStyleController:Tick() end)
            meleeTraining = ok and result == true
        end
        if not meleeTraining and _G.Settings.AutoBuySwords then
            pcall(function() SwordProgressionController:Tick() end)
            local swordStatus = tostring(SwordProgressionController.LastStatus or "")
            if swordStatus:find("Missing", 1, true) or swordStatus:find("mastery", 1, true) then
                state.PriorityHint = swordStatus
            end
        elseif meleeTraining then
            state.PriorityHint = tostring(_G.BobonStatus or "Melee mastery")
        end
    end

    -- 2) A ready style door/quest/key is immediate progression.
    if optionalReady and FightingStyleUnlockController then
        local ok, started = pcall(function() return FightingStyleUnlockController:TryRun() end)
        if not ok then warn("[BobonHub] Module Error: PriorityStyleUnlock: " .. tostring(started))
        elseif started then
            state.PriorityStage = "MELEE_UNLOCK"
            state.PriorityDetail = tostring(_G.BobonStatus or "Melee")
            return true
        end
    end

    -- 3) Live boss carrying a currently-required key/item.
    do
        local ok, started = true, false
        if optionalReady then ok, started = pcall(function() return BossManager:TryPriorityBoss() end) end
        if not ok then warn("[BobonHub] Module Error: PriorityBoss: " .. tostring(started))
        elseif started then
            state.PriorityStage = "REQUIRED_BOSS"
            state.PriorityDetail = tostring(_G.BobonStatus or "Boss")
            return true
        end
    end

    -- 4) Factory is time-limited; if Core is live, take it before ordinary farming.
    do
        local ok, started = true, false
        if optionalReady then ok, started = pcall(function() return FactoryController:TryRun() end) end
        if not ok then warn("[BobonHub] Module Error: PriorityFactory: " .. tostring(started))
        elseif started then
            state.PriorityStage = "FACTORY"
            state.PriorityDetail = "Core"
            return true
        end
    end

    -- Early Dough King/Mirror Fractal preparation, matching the studied kaitun:
    -- once Third Sea is available it may pre-farm Cake mobs/Cocoa rather than waiting for max level.
    if optionalReady and _G.Settings.AutoKatakuri and _G.Settings.KatakuriOnlyMax == false
        and GetSea() == 3 and Level() >= (tonumber(_G.Settings.KatakuriMinLevel) or 1500)
        and not InventoryHas("Mirror Fractal") then
        local ok, started = pcall(function() return KatakuriController:TryRun() end)
        if not ok then warn("[BobonHub] Module Error: PriorityEarlyDough: " .. tostring(started))
        elseif started then
            state.PriorityStage = "DOUGH_PREP"
            state.PriorityDetail = tostring(_G.BobonStatus or "Mirror Fractal")
            return true
        end
    end

    -- 5) A registered Fragment shortage preempts level farm.
    do
        local demand = FragmentManager:GetDemand()
        if optionalReady and demand then
            state.PriorityStage = "FRAGMENTS"
            state.PriorityDetail = tostring(demand.Reason or "Progression")
            state.PriorityHint = ("Need %d/%d Frag • %s")
                :format(Fragments(), tonumber(demand.Goal) or 0, tostring(demand.Reason or "Progression"))
            if RaidController:TryPreempt() then return true end
        end
    end

    -- 6) Remaining permanent/optional kaitun progression.
    do
        local ok, started = true, false
        if optionalReady then ok, started = pcall(function() return ItemProgression:RunChecks(true, true) end) end
        if not ok then warn("[BobonHub] Module Error: PriorityProgression: " .. tostring(started))
        elseif started then
            state.PriorityStage = "PROGRESSION"
            state.PriorityDetail = tostring(_G.BobonStatus or "Progression")
            return true
        end
    end

    state.PriorityStage = "LEVEL_FARM"
    state.PriorityDetail = ""
    state.WorkIntent = "LEVEL_FARM"
    pcall(_G.BobonGoalPlannerPulse)
    return false
end

-- Scheduler task is started AFTER CompletionSeaController is declared so that
-- max-level sea completion and Dough/endgame can join the same progression owner.


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
local RAINBOW_BOSSES = {"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate"}
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

function FruitSniper:NormalizeList(value)
    if type(value) == "string" then
        return value ~= "" and {value} or {}
    end
    if type(value) ~= "table" then return {} end
    local out = {}
    for _, name in ipairs(value) do
        if type(name) == "string" and name ~= "" then out[#out + 1] = name end
    end
    return out
end

function FruitSniper:SnapshotFruitTools()
    local out = {}
    for _, container in ipairs({Char(), LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")}) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Tool") then out[obj] = true end
            end
        end
    end
    return out
end

function FruitSniper:HasNewFruitTool(before)
    for _, container in ipairs({Char(), LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")}) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Tool") and not before[obj] then
                    local tip = tostring(obj.ToolTip or "")
                    local name = tostring(obj.Name or "")
                    if tip == "Blox Fruit" or string.find(string.lower(name), "fruit", 1, true) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function FruitSniper:Tick()
    local wanted = self:NormalizeList(_G.Settings.SnipeFruit)
    if #wanted == 0 or tick() - self.LastTry < 5 or not IsAlive() then return false end
    self.LastTry = tick()

    local stock = nil
    local okStock, rows = pcall(function() return CommF_:InvokeServer("GetFruits") end)
    if okStock and type(rows) == "table" then
        stock = {}
        for _, row in pairs(rows) do
            if type(row) == "table" and type(row.Name) == "string" then
                local onSale = row.OnSale
                if onSale == nil then onSale = row.OnStock end
                if onSale == nil then onSale = row.Stock end
                if onSale == nil or onSale == true or (type(onSale) == "number" and onSale > 0) then
                    stock[string.lower(row.Name)] = true
                end
            end
        end
    end

    for _, name in ipairs(wanted) do
        if not stock or stock[string.lower(name)] then
            local beforeBeli = Beli()
            local beforeTools = self:SnapshotFruitTools()
            local okCall = pcall(function() CommF_:InvokeServer("PurchaseRawFruit", name, false) end)
            if okCall then
                task.wait(0.15)
                local bought = Beli() < beforeBeli or self:HasNewFruitTool(beforeTools)
                if bought then
                    _G.BobonStatus = "Fruit Snipe: " .. tostring(name) .. " ✓"
                    pcall(function() FruitManager:StoreBackpackFruits() end)
                    return true
                end
            end
        end
    end
    return false
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

-- v21 completion shuttle: mature kaituns revisit older seas after leveling so
-- useful permanent items are not lost merely because their boss/event did not spawn
-- before the mandatory world transition. This runs only at MAX level.
local CompletionSeaController = { LastTravel = 0 }

function CompletionSeaController:TargetSea()
    if Level() < MAX_LEVEL then return nil end
    if _G.Settings.AutoSaber and not InventoryHas("Saber") then return 1, "Saber" end
    if not InventoryHas("Pole (1st Form)") then return 1, "Pole V1" end

    if not InventoryHas("Kabucha") then return 2, "Kabucha" end
    if not InventoryHas("Rengoku") then return 2, "Rengoku" end
    if not InventoryHas("Midnight Blade") then return 2, "Midnight Blade" end
    if not InventoryHas("Acidum Rifle") then return 2, "Acidum Rifle / Factory" end
    if not InventoryHas("Dragon Trident") then return 2, "Dragon Trident" end
    if not InventoryHas("Gravity Blade") and not InventoryHas("Gravity Cane") then return 2, "Gravity Blade" end

    return 3, "endgame"
end

function CompletionSeaController:TryTravel()
    if Level() < MAX_LEVEL or not _G.State:CanAct() then return false end
    local wanted, reason = self:TargetSea()
    if not wanted or wanted == GetSea() then return false end
    if tick() - (self.LastTravel or 0) < 12 then return false end
    self.LastTravel = tick()
    local token = _G.State:ClaimAction("CompletionSea")
    if token == 0 then return false end
    _G.State:SetMode("UnlockingSea")
    _G.BobonStatus = ("Completion: Sea %d • %s"):format(wanted, tostring(reason))
    task.spawn(function()
        local ok = pcall(function()
            if wanted == 1 then
                CommF_:InvokeServer("TravelMain")
            elseif wanted == 2 then
                CommF_:InvokeServer("TravelDressrosa")
            else
                CommF_:InvokeServer("TravelZou")
            end
        end)
        task.wait(2)
        if _G.State:IsActionValid(token) then _G.State:ReleaseAction(token) end
        if not ok and _G.State.Mode == "UnlockingSea" then _G.State:SetMode("Idle") end
    end)
    return true
end

-- v21.35 unified scheduler task starts here, after every permanent/endgame
-- controller it needs has a lexical binding.  This is the only permanent
-- progression watcher; MainController does not start these controllers.
task.spawn(function()
    while SessionAlive() do
        task.wait(_G.Settings.PrioritySchedulerInterval or 0.20)
        local ok, started = pcall(_G.BobonPriorityPulse)
        if not ok then
            warn("[BobonHub] Module Error: PriorityScheduler: " .. tostring(started))
            continue
        end
        if started or not _G.State:CanAct() then continue end

        -- Max-level completion shuttle precedes optional endgame grinding.
        if Level() >= MAX_LEVEL then
            local okCompletion, completion = pcall(function() return CompletionSeaController:TryTravel() end)
            if not okCompletion then
                warn("[BobonHub] Module Error: PriorityCompletionSea: " .. tostring(completion))
            elseif completion then
                _G.State.PriorityStage = "COMPLETION_SEA"
                _G.State.PriorityDetail = tostring(_G.BobonStatus or "Completion")
                continue
            end

            -- Dough/Cake and generic boss work are endgame-only and start only
            -- when the quest wrapper is confirmed closed, preventing quest theft.
            if HasQuest() == false and _G.State.QuestClosedStable == true then
                local okKata, kata = pcall(function() return KatakuriController:TryRun() end)
                if not okKata then
                    warn("[BobonHub] Module Error: PriorityKatakuri: " .. tostring(kata))
                elseif kata then
                    _G.State.PriorityStage = "KATAKURI"
                    _G.State.PriorityDetail = tostring(_G.BobonStatus or "Dough")
                    continue
                end
                local okBoss, boss = pcall(function() return BossManager:TryFightBoss() end)
                if not okBoss then
                    warn("[BobonHub] Module Error: PriorityEndgameBoss: " .. tostring(boss))
                elseif boss then
                    _G.State.PriorityStage = "ENDGAME_BOSS"
                    _G.State.PriorityDetail = tostring(_G.BobonStatus or "Boss")
                    continue
                end
            end
        end
    end
end)

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
    if _G.BobonFarmStuckHopRequested and _G.State.ActiveActionToken == 0
        and _G.State.Mode ~= "Dead" and _G.State.Mode ~= "Respawning"
        and _G.State.Mode ~= "ServerHop" then
        _G.BobonFarmStuckHopRequested = nil
        return "farm-no-progress"
    end

    local activeQuestFight = _G.Settings.ContestSuppressPlayerHop
        and _G.State.Mode == "Farming"
        and _G.State.ActiveActionToken == 0
        and _G.State.FarmTarget ~= nil
        and _G.State:IsTargetValid(_G.State.FarmTarget)
        and _G.State.ActiveQuestMob ~= nil
        and IsEnemyNamed(_G.State.FarmTarget, _G.State.ActiveQuestMob)

    if _G.Settings.HopPlayerNear and not activeQuestFight and _G.State.ActiveActionToken == 0 then
        local me=HRP()
        if me then
            for _, p in ipairs(Players:GetPlayers()) do
                local pr=p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if pr and (pr.Position-me.Position).Magnitude <= (_G.Settings.HopPlayerNearRadius or 250) then
                    return "player-near"
                end
            end
        end
    end
    -- Required permanent progression is allowed to search another server even
    -- when generic Hop is disabled.  Never interrupt an already claimed action,
    -- and never hop if the required boss is already alive in this server.
    if _G.Settings.HopRequiredProgression and _G.State.ActiveActionToken == 0
        and _G.State.Mode ~= "Dead" and _G.State.Mode ~= "Respawning" then
        local names, requiredReason = BossManager:GetPriorityDemand()
        if names then
            for _, name in ipairs(names) do
                if FindBoss(name) then return nil end
            end
            return requiredReason
        end
    end

    -- TTK dealer stock is server-dependent. After repeated verified no-progress
    -- probes, allow a targeted progression hop even when generic Hop is OFF.
    if _G.Settings.HopRequiredProgression and _G.State.ActiveActionToken == 0
        and GetSea() == 2 and Level() >= 850 and _G.Settings.AutoTrueTripleKatana
        and Beli() >= 2000000 and not InventoryHas("True Triple Katana") then
        local missing = SwordProgressionController:GetMissingLegendary()
        local failNeed = math.max(2, tonumber(_G.Settings.LegendarySwordHopFailures) or 3)
        if #missing > 0 and (SwordProgressionController.LegendaryFailStreak or 0) >= failNeed then
            local label = missing[1] and missing[1].Label or "legendary-sword"
            return "ttk-dealer-" .. tostring(label)
        end
    end

    if not _G.Settings.HopEnabled then return nil end

    -- Server hopping is demand-driven. Never throw away a valid level quest or
    -- interrupt a claimed puzzle/raid/boss action merely because a generic hop
    -- checkbox is enabled.
    if _G.State.ActiveActionToken ~= 0
        or _G.State.Mode == "Farming" or _G.State.Mode == "GettingQuest"
        or _G.State.Mode == "GettingItem" or _G.State.Mode == "Bossing"
        or _G.State.Mode == "UnlockingSea" or _G.State.Mode == "Raiding" then
        return nil
    end

    local sea, lv = GetSea(), Level()

    -- MAX-level completion pass: if an older-sea useful item was missed, stay in
    -- that sea and hop only for its actual spawn/event. Direct-purchase items such
    -- as Kabucha/Midnight Blade are handled by ItemProgression without hopping.
    if lv >= MAX_LEVEL and sea == 1 then
        if _G.Settings.AutoSaber and not InventoryHas("Saber") then
            if FindBoss("Mob Leader") or FindBoss("Saber Expert") then return nil end
            return "completion-saber"
        end
        if not InventoryHas("Pole (1st Form)") then
            if FindBoss("Thunder God") then return nil end
            return "completion-pole-v1"
        end
    elseif lv >= MAX_LEVEL and sea == 2 then
        if not InventoryHas("Rengoku") and not FindOwnedTool("Hidden Key") then
            if FindBoss("Awakened Ice Admiral") then return nil end
            return "completion-rengoku"
        end
        if not InventoryHas("Acidum Rifle") then
            local core = FindMob("Core") or FindBoss("Core")
            if core and _G.State:IsTargetValid(core) then return nil end
            return "completion-factory-core"
        end
        if not InventoryHas("Dragon Trident") then
            if FindBoss("Tide Keeper") then return nil end
            return "completion-dragon-trident"
        end
        if not InventoryHas("Gravity Blade") and not InventoryHas("Gravity Cane") then
            if FindBoss("Orbitus") or FindBoss("Fajita") then return nil end
            return "completion-gravity-blade"
        end
    end

    -- Mandatory Sea-3 gate: a stored/dropped qualifying fruit or Don Swan spawn
    -- is more important than optional end-game hunts.
    if sea == 2 and lv >= 1500 then
        if _G.State.NeedTrevorFruit and _G.Settings.HopFindFruit then
            local fruit = FindDroppedFruit()
            if fruit then CollectDroppedFruit(fruit); return nil end
            return "sea3-trevor-fruit"
        end
        if _G.State.Sea3NeedDonSwan then
            if FindBoss("Don Swan") then return nil end
            return "sea3-don-swan"
        end
    end

    -- CDK critical path: Soul Reaper only matters during Fear the Reaper.
    if sea == 3 and _G.Settings.HopFindSoulReaper and _G.Settings.AutoCDK
        and not InventoryHas("Cursed Dual Katana") then
        local p = GetCDKProgress()
        local fear = _G.State.CDKResumeStage == "Fear"
            or (type(p)=="table" and tonumber(p.Evil) == -5)
        if fear then
            if FindBoss("Soul Reaper") or FindOwnedTool("Hallow Essence") then return nil end
            return "cdk-soul-reaper"
        end
    end

    -- Tushita needs rip_indra/Holy Torch; hop only when that prerequisite is the
    -- actual missing CDK branch, not throughout ordinary leveling.
    if sea == 3 and lv >= 2000 and _G.Settings.HopFindTushita and _G.Settings.AutoCDK
        and not InventoryHas("Tushita") then
        if FindOwnedTool("Holy Torch") or FindBoss("rip_indra") or FindBoss("rip_indra True Form") then return nil end
        return "cdk-tushita-indra"
    end

    -- Yama requires Elite Hunter progress. Only hunt elites while Yama is missing.
    if sea == 3 and lv >= 1500 and _G.Settings.HopElite and _G.Settings.AutoCDK
        and not InventoryHas("Yama") then
        local progress=0
        pcall(function() progress=tonumber(CommF_:InvokeServer("EliteHunter","Progress")) or 0 end)
        if progress < 30 then
            if FindLiveNamed({"Diablo","Deandre","Urban"}) then return nil end
            return "cdk-yama-elite"
        end
    end

    -- Skull/Sanguine need Dark Fragments. Do not hop Darkbeard after the required
    -- number has already been banked.
    if sea == 2 and _G.Settings.HopFindDarkbeard then
        local need = RequiredDarkFragments()
        if need > 0 and MaterialCount("Dark Fragment") < need then
            if FindBoss("Darkbeard") then return nil end
            return "dark-fragment"
        end
    end

    -- Dough King is a max-level progression target in this kaitun.
    if sea == 3 and lv >= MAX_LEVEL and _G.Settings.HopFindMirrorFractal
        and _G.Settings.AutoKatakuri and not InventoryHas("Mirror Fractal") then
        if FindBoss("Dough King") then return nil end
        return "dough-king-mirror"
    end

    -- Valkyrie Helm is useful only when the user enabled the rip_indra branch.
    if sea == 3 and lv >= MAX_LEVEL and _G.Settings.HopFindValkyrieHelm
        and _G.Settings.AutoSpawnRipIndra and not InventoryHas("Valkyrie Helm") then
        if FindBoss("rip_indra") or FindBoss("rip_indra True Form") then return nil end
        return "indra-valkyrie"
    end

    -- Mirage hopping is deferred until Mirror Fractal is actually owned. This
    -- prevents a cosmetic hop option from sabotaging level/progression farming.
    if sea == 3 and lv >= MAX_LEVEL and _G.Settings.HopFindMirage
        and InventoryHas("Mirror Fractal") then
        if MiragePresent() then return nil end
        return "mirage"
    end

    -- Generic dropped-fruit hunting is lowest priority and only runs after max.
    if lv >= MAX_LEVEL and _G.Settings.HopFindFruit then
        local fruit = FindDroppedFruit()
        if fruit then CollectDroppedFruit(fruit); return nil end
        return "fruit"
    end
    return nil
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
--   Priority: Recovery/Team are local gates; permanent movement priority is v21.35 Scheduler.
--   This loop owns only quest/farm plus confirmed-safe optional user event/boss windows.
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

-- v21.5 GLOBAL MOB CORE: these helpers are deliberately name-agnostic.
-- They consume the current QDB/active quest mob instead of hard-coding any NPC.
local FarmDamageWatch = {
    Target=nil, Health=nil, Count=0, Generation=0,
    StartedAt=0, LastDamageAt=0,
}

local function ResetFarmDamageWatch(target)
    FarmDamageWatch.Target = target
    FarmDamageWatch.Health = nil
    FarmDamageWatch.Count = 0
    FarmDamageWatch.Generation = _G.State and _G.State.ClusterGeneration or 0
    FarmDamageWatch.StartedAt = tick()
    FarmDamageWatch.LastDamageAt = tick()
end

local function ObserveFarmDamage(target)
    if not target or not _G.State:IsTargetValid(target) then
        ResetFarmDamageWatch(nil)
        return false
    end
    if FarmDamageWatch.Target ~= target
        or FarmDamageWatch.Generation ~= (_G.State.ClusterGeneration or 0) then
        ResetFarmDamageWatch(target)
        return false
    end
    local now = tick()
    local totalHealth, liveCount = 0, 0
    if _G.State.ClusterMode == "QUEST" and ClusterFarmController then
        for _, entry in ipairs(ClusterFarmController.LastBatch or {}) do
            local model = entry.Model
            local hum = model and model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and ClusterFarmController:IsVerified(model) then
                totalHealth = totalHealth + hum.Health
                liveCount = liveCount + 1
            end
        end
    end
    if liveCount == 0 then
        local hum = target:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        totalHealth, liveCount = hum.Health, 1
    end

    -- A changing batch is activity, not proof of a failed attack. This avoids
    -- revoking a healthy cluster while another stacked mob dies or respawns.
    if FarmDamageWatch.Health == nil
        or FarmDamageWatch.Count ~= liveCount
        or totalHealth > FarmDamageWatch.Health + 0.01 then
        FarmDamageWatch.StartedAt = now
        FarmDamageWatch.LastDamageAt = now
    elseif totalHealth < FarmDamageWatch.Health - 0.01 then
        FarmDamageWatch.LastDamageAt = now
    end
    FarmDamageWatch.Health = totalHealth
    FarmDamageWatch.Count = liveCount
    local noDamageFor = now - math.max(FarmDamageWatch.StartedAt or now, FarmDamageWatch.LastDamageAt or now)
    return noDamageFor >= math.max(3.0, (_G.Settings.CombatProbeTimeout or 0.9) * 3)
end

local function QuestChaseLimit()
    return math.max(
        (_G.Settings.MaxFarmDistance or 300) + 50,
        tonumber(_G.Settings.GatherMaxDistance) or 3000
    )
end

local function ResolveQuestClusterAnchor(q, mobName)
    local state = _G.State
    if state.ClusterMode == "QUEST" and state.ClusterAnchor
        and state.ClusterMobName and string.lower(tostring(state.ClusterMobName))
            == string.lower(tostring(mobName)) then
        return state.ClusterAnchor
    end

    local base = q and q.MC
    local folder = workspace:FindFirstChild("Enemies")
    local positions = {}
    local fieldRadius = math.max(120,
        (_G.Settings.ClusterAuthorityEnabled ~= false
            and tonumber(_G.Settings.ClusterAuthorityFieldRadius))
        or tonumber(_G.Settings.ClusterQuestRadius)
        or 1200)

    if folder then
        for _, mob in ipairs(folder:GetChildren()) do
            if IsEnemyNamed(mob, mobName) then
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local root = mob:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    local ok, pos = pcall(function() return root.Position end)
                    if ok and IsAllowedWorldPosition(pos) then
                        local inField = not base or typeof(base) ~= "CFrame"
                            or (pos - base.Position).Magnitude <= math.max(fieldRadius * 2.5, 260)
                        if inField then positions[#positions + 1] = pos end
                    end
                end
            end
        end
    end

    if #positions > 0 then
        -- Choose a center that minimizes the FARTHEST live mob distance, not the
        -- nearest single mob. This is important for 100-stud server-valid hit/probe
        -- range: parking on one mob can leave the other two outside the real range.
        local sum = Vector3.zero
        local minX, maxX = math.huge, -math.huge
        local minY, maxY = math.huge, -math.huge
        local minZ, maxZ = math.huge, -math.huge
        for _, p in ipairs(positions) do
            sum = sum + p
            minX, maxX = math.min(minX, p.X), math.max(maxX, p.X)
            minY, maxY = math.min(minY, p.Y), math.max(maxY, p.Y)
            minZ, maxZ = math.min(minZ, p.Z), math.max(maxZ, p.Z)
        end
        local centroid = sum / #positions
        -- v21.36: fixed pile must sit on a REAL live mob position. A geometric
        -- centroid can land in empty terrain/water (exactly the fountain in video 7837).
        local centers = {}
        for _, p in ipairs(positions) do centers[#centers + 1] = p end

        local bestCenter, bestMax, bestAvg, bestCentroidDist
        for _, center in ipairs(centers) do
            local maxDist, total = 0, 0
            for _, p in ipairs(positions) do
                local d = (p - center).Magnitude
                maxDist = math.max(maxDist, d)
                total = total + d
            end
            local avg = total / #positions
            local centroidDist = (center - centroid).Magnitude
            if not bestCenter or maxDist < bestMax - 0.01
                or (math.abs(maxDist - bestMax) <= 0.01 and avg < bestAvg - 0.01)
                or (math.abs(maxDist - bestMax) <= 0.01
                    and math.abs(avg-bestAvg) <= 0.01
                    and centroidDist < bestCentroidDist) then
                bestCenter, bestMax, bestAvg, bestCentroidDist =
                    center, maxDist, avg, centroidDist
            end
        end
        if bestCenter then
            DLog("FARM", ("Live-medoid pile anchor -> %s (%d mobs, max %.1f)")
                :format(tostring(mobName), #positions, bestMax or 0))
            return CFrame.new(bestCenter)
        end
    end
    return base
end

task.spawn(function()
    while SessionAlive() and task.wait(0.15) do
        -- Skip nếu subsystem đang giữ ActionToken
        if _G.State.ActiveActionToken ~= 0 then continue end
        if _G.State.Mode == "Recovering" or _G.State.Mode == "Dead"
            or _G.State.Mode == "Respawning" or _G.State.Mode == "ServerHop" then
            continue
        end
        if not IsAlive() then continue end
        if tick() < (tonumber(_G.State.EconomyPauseUntil) or 0) then
            if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                TravelManager:Stop("EconomyPause")
            end
            _G.State.FState = "ECONOMY_PAUSE"
            _G.BobonStatus = tostring(_G.State.EconomyPauseReason or "Economy: purchasing")
            continue
        elseif _G.State.EconomyPauseReason then
            _G.State.EconomyPauseReason = nil
        end


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

            -- v21.35: Factory/Raid/permanent progression are started only by the
            -- Priority Scheduler. MainController remains the single quest/farm loop.

            -- LEVEL FARM FALLBACK. Permanent progression is handled by the
            -- one v21.35 Priority Scheduler outside this large closure.
            local lv = Level()
            local questState = HasQuest() -- true / false / nil (UI not ready)
            local questNow = tick()
            if questState == true then
                _G.State.QuestLastSeenAt = questNow
                _G.State.QuestClosedSince = 0
                _G.State.QuestClosedStable = false
            elseif questState == false then
                if (_G.State.QuestClosedSince or 0) <= 0 then
                    _G.State.QuestClosedSince = questNow
                end
                _G.State.QuestClosedStable =
                    questNow - (_G.State.QuestClosedSince or questNow)
                        >= (_G.Settings.QuestCloseConfirm or 0.20)
            else
                -- unreadable/rebuilding UI is never evidence that the quest closed
                _G.State.QuestClosedStable = false
            end

            -- Sticky mandatory progression wins over level farm until it is actually
            -- complete.  This is the architectural fix for Saber -> Farm -> Boss ->
            -- Saber ping-pong seen in the supplied video.
            local progressionLock = ItemProgression:GetBlockingReason()
            _G.State.ProgressionLock = progressionLock
            if progressionLock then
                _G.State.WorkIntent = "PROGRESSION:" .. tostring(progressionLock)
                if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                    TravelManager:Stop("MandatoryProgressionLock")
                end
                FarmPositionController:ReleaseCluster()
                _G.State:ClearTargets()
                if _G.State.ActiveActionToken == 0 then
                    _G.BobonStatus = "Progression: " .. tostring(progressionLock) .. " • scheduler"
                end
                return
            else
                _G.State.WorkIntent = "LEVEL_FARM"
            end

            -- v21.35: required bosses, live Factory and Fragment Raid are all
            -- started by the one Priority Scheduler, never independently here.

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
                -- v21.35: Completion Sea, Katakuri/Dough, permanent items, Raid
                -- and passive melee/TTK all belong to Priority Scheduler.
                _G.State:SetMode("Idle")
                _G.BobonStatus = "Max Level: Scheduler waiting"
                return
            end

            -- Keep one canonical mob name for the quest wrapper that is
            -- currently active. On re-execution, adopt it only when the UI
            -- contains an exact QDB mob name. A localized/unreadable wrapper
            -- is still safe to farm by level, but bring stays disabled until
            -- this session accepts the next quest and knows its exact mob.
            if questState == false and _G.State.QuestClosedStable == true then
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
            -- v21.33: retain the canonical active quest across a brief wrapper blink.
            -- Without this lease the controller cleared Farm, opened a "safe item window",
            -- and could launch BossManager before the Quest UI rebuilt.
            if not hasQuest and questState == nil and questMatch ~= false
                and _G.State.ActiveQuestMob
                and questNow - (_G.State.QuestLastSeenAt or 0)
                    <= (_G.Settings.QuestUILease or 0.65) then
                hasQuest = true
            end
            -- Right after StartQuest, some UI builds briefly hide/rebuild the
            -- Quest wrapper. Do not cancel the accepted quest and fly back to
            -- the giver during that short transition.
            if not hasQuest and questState == nil and questMatch ~= false
                and _G.State.LastQuestAccepted > 0
                and tick() - _G.State.LastQuestAccepted
                    <= math.min(_G.Settings.QuestAcceptGrace or 1.25, 1.25) then
                hasQuest = true
            end
            local questOk = hasQuest
            local questMobName = _G.State.ActiveQuestMob or q.M

            -- Quest-first invariant: quest vừa hết, bị mất, sai mob, hoặc UI
            -- không còn xác nhận được đều phải quay lại giver ngay trong tick
            -- này.  Dừng target/travel cũ trước để không bay tiếp tới mob cũ.
            if not hasQuest then
                -- HARD QUEST-FIRST: a confirmed closed/wrong quest cannot fall
                -- through to farm, boss, item, or stale travel in this tick.
                FarmPositionController:ReleaseCluster()
                _G.State:ClearTargets()
                _G.State.ActiveQuestMob = nil
                if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                    TravelManager:Stop("QuestClosedRefresh")
                end
                _G.State:SetMode("GettingQuest")
                _G.State.FState = "QUEST_REFRESH"
                _G.BobonStatus = "Quest: Refreshing " .. q.M
                local hrp = HRP()
                local atGiver = hrp and (hrp.Position - q.QC.Position).Magnitude
                    <= (_G.Settings.QuestInteractDistance or 8)
                if HandleQuestAtGiver(q, atGiver) then return end
                _G.State.FState = "QUEST_TRAVEL"
                _G.BobonStatus = "Quest: Traveling to " .. q.M
                TravelManager:Request(q.QC, "Farm", {
                    arrivalThreshold = _G.Settings.QuestInteractDistance or 8,
                    combatHover = false,
                    persistent = false,
                })
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
                        local atGiver = HRP() and (HRP().Position - q.QC.Position).Magnitude <= (_G.Settings.QuestInteractDistance or 8)
                        if HandleQuestAtGiver(q, atGiver) then
                            return
                        else
                            TravelManager:Request(q.QC, "Farm", {
                                arrivalThreshold = _G.Settings.QuestInteractDistance or 8,
                                combatHover = false,
                                persistent = false,
                            })
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
                local atGiver = hrp and (hrp.Position - q.QC.Position).Magnitude <= (_G.Settings.QuestInteractDistance or 8)
                if HandleQuestAtGiver(q, atGiver) then
                    return
                else
                    _G.BobonStatus = "Quest: Traveling to " .. q.M
                    TravelManager:Request(q.QC, "Farm", {
                                arrivalThreshold = _G.Settings.QuestInteractDistance or 8,
                                combatHover = false,
                                persistent = false,
                            })
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

            -- v21.38 NORMAL QUEST FARM: source-shared BN loop is authoritative.
            -- It intentionally bypasses ClusterPhase / ownership / damage-lease logic.
            if _G.Settings.SharedSourceFarmMode ~= false then
                if _G.State.ClusterMode ~= "OFF" then
                    FarmPositionController:ReleaseCluster()
                end
                if ClusterFarmController:SharedFarmTick(questMobName, q.MC) then
                    return
                end
            end

            -- v18.7 QUEST CLUSTER: q.MC is the stable spawn-area anchor.
            -- A mob death no longer destroys the cluster or forces player travel.
            local questAnchor = ResolveQuestClusterAnchor(q, questMobName) or q.MC
            ClusterFarmController:Activate("QUEST", {questMobName}, questAnchor, "Farm")
            -- Tick owns candidate scan + exactly one phase transition.
            ClusterFarmController:Tick()

            local anchorHeight = _G.Settings.FarmHeight or 22
            local hoverCF = ClusterFarmController:GetHoverCFrame(anchorHeight)
            if ClusterFarmController:IsShadowCombatActive() then
                hoverCF = ClusterFarmController:GetShadowCoverageHoverCFrame(anchorHeight) or hoverCF
            end

            -- v21.34 PHASED FARM: ACQUIRE physically visits unverified quest mobs
            -- and stacks them at one fixed anchor.  Damage is withheld until KILL.
            local acquireTarget = _G.State.ClusterPhase == "ACQUIRE" and ClusterFarmController:GetAcquireTarget() or nil
            local acquireRoot = acquireTarget
                and acquireTarget:FindFirstChild("HumanoidRootPart")
            local acquiring = acquireRoot ~= nil
                and _G.State:IsTargetValid(acquireTarget)
                and IsEnemyNamed(acquireTarget, questMobName)
            if acquiring then
                _G.State.FState = "ACQUIRE_STACK"
                _G.BobonStatus = ("Farm: ACQUIRE + STACK %s (%d/%d)")
                    :format(tostring(questMobName), tonumber(_G.State.ClusterPhaseVerified) or 0, tonumber(_G.State.ClusterPhaseTotal) or 0)
                if _G.State:CanRequestTravel() then
                    TravelManager:Request(acquireRoot, "Farm", {
                        arrivalThreshold = _G.Settings.ClusterAcquireArrivalThreshold
                            or _G.Settings.FarmArrivalThreshold,
                        fallback = hoverCF or q.MC,
                        combatHover = true,
                        acquireSweep = true,
                        speed = _G.Settings.ClusterAcquireTravelSpeed
                            or _G.Settings.SkipTravelSpeed or 340,
                    })
                end
            elseif acquireTarget then
                _G.State.ClusterAcquireTarget = nil
                _G.State.ClusterAcquireStartedAt = 0
                _G.State.ClusterAcquireDeadline = 0
            end

            -- VERIFY/PROMOTE: first prefer a verified mob already stacked at the
            -- persistent anchor. Killing the old primary simply promotes another.
            _G.State.FState = "VERIFY_TARGET"
            local contested = _G.State:IsTargetValid(_G.State.FarmTarget)
                and IsEnemyNamed(_G.State.FarmTarget, questMobName)
                and IsFarmTargetContested(_G.State.FarmTarget)
            if not contested then
                local promoted = ClusterFarmController:SelectPrimary()
                if not promoted and _G.State.ClusterPhase == "KILL" then
                    promoted = ClusterFarmController:SelectFallbackRealTarget()
                    if promoted and (tonumber(_G.State.ClusterPhaseVerified) or 0) <= 0 then
                        _G.BobonStatus = "Farm: KILL-FALLBACK real " .. tostring(questMobName)
                    end
                end
                local probeTarget = not promoted and ClusterFarmController:SelectProbePrimary() or nil
                local chosen = promoted or probeTarget
                if chosen then
                    _G.State.FarmTarget = chosen
                    _G.State.CurrentTarget = chosen
                    _G.State.ClusterPrimary = promoted
                elseif _G.Settings.ClusterAuthorityEnabled ~= false
                    and _G.State.ClusterMode == "QUEST" then
                    -- Authority mode never chases a merely visible same-name NPC.
                    -- If it is neither verified nor the one active HP probe, clear
                    -- the stale target and keep the player on the shared field anchor.
                    _G.State.FarmTarget = nil
                    _G.State.CurrentTarget = nil
                    _G.State.ClusterPrimary = nil
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
            local authorityProbeTarget = target
                and ClusterFarmController:IsProbeCandidate(target)
                and not verifiedClusterTarget
            -- An acquisition request above must survive this tick. Without this
            -- branch, MOVE_TO_CLUSTER immediately retargeted the same owner back
            -- to hoverCF and the sweep never reached the remaining spawn roots.
            if acquiring then
                _G.State.FState = "ACQUIRE_STACK"
            elseif hoverCF and (verifiedClusterTarget or authorityProbeTarget) and not contested then
                _G.State.FState = authorityProbeTarget and "AUTHORITY_PROBE" or "MOVE_TO_CLUSTER"
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
                local normalTooFar = dist > QuestChaseLimit()
                local contestTooFar = dist > math.max((_G.Settings.ContestChaseDistance or 900), QuestChaseLimit())
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
                -- v21.33 active spawn-field search: never sit on an empty anchor.
                local sweepGoal, sweepKind = ClusterFarmController:GetFieldSweepGoal(q.MC)
                if sweepGoal and _G.State:CanRequestTravel() then
                    _G.State.FState = sweepKind == "LIVE" and "FIELD_SWEEP_LIVE"
                        or (sweepKind == "SPAWN" and "FIELD_SPAWN_SWEEP" or "FIELD_PATROL")
                    if sweepKind == "LIVE" then
                        _G.BobonStatus = "Farm: sweeping live " .. tostring(questMobName) .. " spawn"
                        TravelManager:Request(sweepGoal, "Farm", {
                            arrivalThreshold = _G.Settings.ClusterAcquireArrivalThreshold
                                or _G.Settings.FarmArrivalThreshold,
                            fallback = hoverCF or q.MC,
                            combatHover = true,
                            acquireSweep = true,
                            speed = _G.Settings.ClusterFieldPatrolSpeed
                                or _G.Settings.ClusterAcquireTravelSpeed or 420,
                        })
                    else
                        _G.BobonStatus = sweepKind == "SPAWN"
                            and ("Farm: sweeping exact " .. tostring(questMobName) .. " spawns")
                            or ("Farm: searching " .. tostring(questMobName) .. " field")
                        TravelManager:Request(sweepGoal, "Farm", {
                            arrivalThreshold = _G.Settings.ClusterFieldPatrolArrival or 18,
                            fallback = q.MC,
                            combatHover = false,
                            persistent = false,
                            speed = _G.Settings.ClusterFieldPatrolSpeed or 400,
                        })
                    end
                elseif hoverCF and _G.State:CanRequestTravel() then
                    TravelManager:Request(hoverCF, "Farm", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        fallback = q.MC,
                        combatHover = true,
                        persistent = true,
                    })
                end
            end

            -- v21.34 KILL PHASE ONLY. ACQUIRE never attacks: first make one real
            -- fixed pile, then fan fresh swings across every eligible victim.  This removes
            -- the old hybrid gather/attack path that could kill one mob at its spawn while
            -- the rest of the client-only pile became statues.
            hrp = HRP()
            target = _G.State.FarmTarget
            targetRoot = target and target:FindFirstChild("HumanoidRootPart")
            if _G.State.ClusterPhase == "KILL"
                and target and targetRoot and hrp and _G.State:IsTargetValid(target) then
                PrepareCombatTarget(target)

                -- Global liveness fallback: if a whole verified pile stops producing HP
                -- deltas, revoke the stale authority/backend and force physical reacquire.
                if not authorityProbeTarget
                    and not ClusterFarmController:IsShadowCombatActive()
                    and ClusterFarmController:GetVerifiedCount() <= 1
                    and ClusterFarmController:GetProbeCount() == 0
                    and TravelManager:IsAtCombatAnchor()
                    and ObserveFarmDamage(target) then
                    VerifiedGatherRoots[targetRoot] = nil
                    DamageProvenGatherRoots[targetRoot] = nil
                    GatherAuthorityClass[targetRoot] = nil
                    if _G.State.ClusterPrimary == target then _G.State.ClusterPrimary = nil end
                    local failingBackend = CombatController.PendingBackend
                        or CombatController.VerifiedBackend
                    if failingBackend then
                        CombatController:FailBackend(failingBackend, "GLOBAL-MOB-NO-DAMAGE")
                    end
                    if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                        TravelManager:Stop("GlobalMobNoDamageReacquire")
                    end
                    _G.State.ClusterPhase = "ACQUIRE"
                    _G.State.ClusterPhaseStartedAt = tick()
                    _G.State.ClusterWaveStartedAt = _G.State.ClusterPhaseStartedAt
                    _G.BobonStatus = "Farm: Reacquiring " .. tostring(questMobName)
                    ResetFarmDamageWatch(target)
                    return
                end

                local flatDist = (Vector3.new(hrp.Position.X,0,hrp.Position.Z)
                    - Vector3.new(targetRoot.Position.X,0,targetRoot.Position.Z)).Magnitude
                local farmHolds = not _G.State.IsTraveling or _G.State.MovementOwner == "Farm"
                local shadowClusterAttack = ClusterFarmController:IsShadowCombatActive()
                    and ClusterFarmController:GetShadowReachableCount(
                        _G.Settings.ClusterShadowAttackRange or _G.Settings.FastAttackRange or 100) > 0
                if flatDist <= (_G.Settings.FastAttackRange or _G.Settings.AttackRange or 100)
                    and farmHolds
                    and (shadowClusterAttack or authorityProbeTarget or TravelManager:IsAtCombatAnchor()) then
                    _G.State.FState = shadowClusterAttack and "SHADOW_CLUSTER_ATTACK"
                        or (authorityProbeTarget and "AUTHORITY_PROBE_ATTACK" or "ATTACK_CLUSTER")
                    EquipCombatTool()
                    Attack(target, questMobName)
                    if os.time() - lastAttackLog >= 5 then
                        lastAttackLog = os.time()
                        DLog("ATTACK", "Cluster fanout: " .. target.Name)
                    end
                end
            else
                ResetFarmDamageWatch(nil)
                if not acquiring and _G.State.FState ~= "FIELD_SWEEP_LIVE"
                    and _G.State.FState ~= "FIELD_PATROL"
                    and _G.State.FState ~= "FIELD_SPAWN_SWEEP" then
                    _G.BobonStatus = "Farm: " .. tostring(_G.State.ClusterPhase) .. " • searching " .. questMobName .. " spawn"
                end
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
    -- Silent: never overwrite farm/skip/boss Status with Haki text.
    pcall(function() HakiController:EnableForCharacter() end)
    task.wait(0.5)
    _G.State:SetMode("Idle")
end)

-- ══════════════════════════════════════════════════════════════════
--              BACKGROUND SYSTEMS (Fix #15,#16,#17,#18)
--   TUYỆT ĐỐI KHÔNG background loop nào điều khiển movement
--   Remote calls có cooldown/batch limit, không spam
--   pcall wrap mọi remote, lỗi không ảnh hưởng main loop
-- ══════════════════════════════════════════════════════════════════


-- Silent Armament keeper. Polling is cheap; Buso itself is sent only after
-- ReadArmamentState reports OFF and cooldown/grace permits it.
task.spawn(function()
    while SessionAlive() do
        task.wait(_G.Settings.ArmamentWatchInterval or 0.15)
        pcall(function() HakiController:WatchTick() end)
        pcall(function() RaceAbilityController:WatchTick() end)
    end
end)

-- Core ability purchase probe (non-blocking, throttled).
task.spawn(function()
    while SessionAlive() and task.wait(5) do
        pcall(function() CoreAbilityPurchaseController:Tick() end)
    end
end)

-- Anti-AFK (Fix #16)
LP.Idled:Connect(function()
    if not SessionAlive() then return end
    pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
end)


-- Do not mutate Tool.Handle. Enlarging every melee/sword handle to 50 studs
-- and hiding it can invalidate the live Tool controller and was shared by all
-- weapons, which is why Combat, other melee styles and swords failed alike.
-- Enemy-side target preparation already supplies the local acquisition box.


-- Auto Stats — cap-aware. Resolve live values when possible so points are not
-- repeatedly sent to a capped stat. If the current client exposes an unfamiliar
-- Data layout, preserve the old bounded 70/30 behavior as a compatibility fallback.
local function ReadLiveStatLevel(statName)
    local d = LP:FindFirstChild("Data")
    if not d then return nil end
    local stats = d:FindFirstChild("Stats")
    local candidates = {}
    if stats then
        candidates[#candidates + 1] = stats:FindFirstChild(statName)
        candidates[#candidates + 1] = stats:FindFirstChild(statName .. " Level")
    end
    candidates[#candidates + 1] = d:FindFirstChild(statName)
    candidates[#candidates + 1] = d:FindFirstChild(statName .. " Level")
    for _, node in ipairs(candidates) do
        if node then
            if node:IsA("IntValue") or node:IsA("NumberValue") then
                return tonumber(node.Value)
            end
            local valueNode = node:FindFirstChild("Level") or node:FindFirstChild("Value")
            if valueNode and (valueNode:IsA("IntValue") or valueNode:IsA("NumberValue")) then
                return tonumber(valueNode.Value)
            end
            for _, attr in ipairs({"Level","Value","StatLevel"}) do
                local value = node:GetAttribute(attr)
                if type(value) == "number" then return value end
            end
        end
    end
    return nil
end

task.spawn(function()
    while SessionAlive() and task.wait(3) do
        if not _G.Settings.AutoStats then continue end
        pcall(function()
            local d = LP:FindFirstChild("Data")
            if not d then return end
            local pts = d:FindFirstChild("Points") and tonumber(d.Points.Value) or 0
            if pts <= 0 then return end
            local batch = math.min(pts, _G.Settings.StatBatchLimit or 100)
            local statCap = MAX_LEVEL or 2800
            local meleeLevel = ReadLiveStatLevel("Melee")
            local defenseLevel = ReadLiveStatLevel("Defense")

            local meleeAdd, defAdd = 0, 0
            if meleeLevel ~= nil and defenseLevel ~= nil then
                meleeAdd = math.min(batch, math.max(0, statCap - meleeLevel))
                local remaining = batch - meleeAdd
                defAdd = math.min(remaining, math.max(0, statCap - defenseLevel))
            else
                meleeAdd = math.floor(batch * 0.7)
                defAdd = batch - meleeAdd
            end

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
            local tracked = _G.State.FarmTarget == mob or _G.State.CurrentTarget == mob
            local touchedAt = CombatController.RecentTargets
                and CombatController.RecentTargets[mob] or nil
            local recentlyDispatched = touchedAt
                and tick() - touchedAt <= 3.0
            if (tracked or recentlyDispatched)
                and not DamageAttributedToOtherPlayer(mob, h) then
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
    pcall(function() if ClusterHeartbeatConnection then ClusterHeartbeatConnection:Disconnect() end end)
    pcall(function()
        if ClusterFarmController and ClusterFarmController.EnemyAddedConnection then
            ClusterFarmController.EnemyAddedConnection:Disconnect()
            ClusterFarmController.EnemyAddedConnection = nil
        end
    end)
    pcall(function()
        if FruitManager and FruitManager.PopupConnections then
            for _, conn in ipairs(FruitManager.PopupConnections) do if conn then conn:Disconnect() end end
            FruitManager.PopupConnections = {}
        end
    end)
    pcall(function()
        if _G.BobonEliteWake and _G.BobonEliteWake.Connection then
            _G.BobonEliteWake.Connection:Disconnect()
            _G.BobonEliteWake.Connection = nil
        end
    end)
    pcall(function()
        if _G.BobonFruitFinderState and _G.BobonFruitFinderState.Connection then
            _G.BobonFruitFinderState.Connection:Disconnect()
            _G.BobonFruitFinderState.Connection = nil
        end
    end)
    pcall(function() BindPlayerDamage(nil, nil) end)
    pcall(function()
        for _, conn in ipairs(BobonUIConnections or {}) do
            if conn then conn:Disconnect() end
        end
        BobonUIConnections = {}
    end)
    pcall(function() if BobonUIRoot and BobonUIRoot.Parent then BobonUIRoot:Destroy() end end)
    BobonUIRoot = nil
end


print("[BobonHub v22.7] Full Script Loaded Successfully!")
print("[BobonHub v22.7] Architecture: Goal Planner | Atomic Scheduler | Combat-First Farm | Single Movement Owner")
print("[BobonHub v22.7] Core: GoalPlanner | PriorityScheduler | TravelManager | CombatController | EconomyMutex")
print("[BobonHub v22.7] Modules: HP-Proof QuestFarm | Ability V3/V4 | Mastery Skills | Material Prep | Atomic Fruit/Berry/Elite/Castle | Raid/Fragments | Full Progression | Bobon Fire HUD")
print("[BobonHub v22.7] Progression: Level+Mastery | Saber/Sea2/3 | Full Melee | Factory/Items | TTK/CDK | Skull Guitar | Early Dough King | Endgame")
print("[BobonHub v22.7] Data: Sea1/2/3 QDB | Submerged | Boss/item catalog")
print("[BobonHub v22.7] Sea: " .. _G.State.Sea .. " | Level: " .. Level())
