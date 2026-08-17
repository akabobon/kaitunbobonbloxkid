-- =================================================================
--         BOBON HUB v21.24.2 MINIMAL PRIORITY BOOTSAFE | ALL-MOB PERSISTENT PILE | FAST DESCEND | HAKI HOLD
--         Long-Run Stable | Single Movement Owner | ActionToken
--         Base: v21.23 ALL-MOB PERSISTENT PILE | Version: v21.24.2
--
--  v21.24.2 MINIMAL PRIORITY / BOOT-SAFE FIX:
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


print("[BobonHub v21.24.2 MINIMAL PRIORITY BOOTSAFE + ALL-MOB PILE] Loading...")


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
        backdrop.BackgroundColor3 = Color3.fromRGB(24,21,20)
        backdrop.BackgroundTransparency = 1
        backdrop.BorderSizePixel = 0
        backdrop.Parent = BootGui

        local card = Instance.new("Frame")
        card.AnchorPoint = Vector2.new(0.5,0.5)
        card.Size = UDim2.new(0, 520, 0, 120)
        card.Position = UDim2.fromScale(0.5,0.5)
        card.BackgroundColor3 = Color3.fromRGB(35,29,27)
        card.BackgroundTransparency = 0.46
        card.BorderSizePixel = 0
        card.Parent = backdrop

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0,16)
        corner.Parent = card

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255,103,40)
        stroke.Transparency = 0.62
        stroke.Thickness = 1.2
        stroke.Parent = card

        BootLabel = Instance.new("TextLabel")
        BootLabel.BackgroundTransparency = 1
        BootLabel.Size = UDim2.new(1,-30,1,-30)
        BootLabel.Position = UDim2.new(0,15,0,15)
        BootLabel.Font = Enum.Font.GothamBold
        BootLabel.TextSize = 16
        BootLabel.TextColor3 = Color3.fromRGB(255,242,230)
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
    FarmHeight          = 22,
    BossFarmHeight      = 28,
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
    ClusterAuthorityFieldRadius = 650,
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
    ClusterIndependentSwingGap = 0.022,
    ClusterIndependentSwingMaxTargets = 8,
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
    ClusterQuestRadius  = 650,
    ClusterAcquireSweep = true,
    ClusterAcquireTimeout = 2.00,
    ClusterAcquireMaxTimeout = 6.00,
    ClusterAcquireSettle = 0.60,
    ClusterAcquireRetry = 0.12,
    ClusterAcquireMaxAttempts = 6,
    ClusterAcquireCycleRetry = 0.35,
    ClusterAcquireArrivalThreshold = 3.25,
    ClusterAcquireTravelSpeed = 360,
    ClusterAcquireHoverHeight = 6,
    ClusterAcquireGroupRadius = 140,
    ClusterOwnershipSettle = 0.18,
    ClusterAcquirePreferCoverage = true,
    -- v21.23: fallback ONLY for environments where ownership cannot be queried.
    -- It requires real HP damage at the mob's real position + close physical approach,
    -- then a one-shot movement persistence test before the mob may join the pile.
    ClusterDamageLeaseEnabled = true,
    ClusterDamageLeaseAcquireRadius = 18,
    ClusterDamageLeaseProofWindow = 0.28,
    ClusterDamageLeaseProofChecks = 5,
    ClusterDamageLeaseProofRadius = 7,
    ClusterDamageLeaseSnapRejectRadius = 18,
    ClusterDamageLeaseTTL = 2.50,
    -- v21.22: a single exact pile stays horizontally under the player during sweep.
    ClusterOnePileUnderfoot = true,
    ClusterPileFollowDuringSweep = true,
    ClusterPileSettleRadius = 20,
    ClusterPileUseAcquireGroundY = true,
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
    RaidNoChipRetry      = 90,
    RaidFragmentDemandTTL= 120,
    RaidCheapFruitMaxPrice = 650000,
    -- Core movement optimization: one short snap only for the active quest mob.
    -- This is intentionally not exposed in Configs; it is part of the farm core.
    NearQuestSnap        = true,
    NearQuestSnapDistance= 70,
    NearQuestSnapCooldown= 0.08,
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
    ProgressionRetry    = 45,
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
    BringDamageProven = 0,
    BringUnknown = 0,
    BringServerOwned = 0,
    BringProbe = 0,
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
    FarmSafetyUntil   = 0,
    FarmSafetyActive  = false,
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


local BobonUIRoot = nil
local BobonUIConnections = {}

-- ══════════════════════════════════════════════════════════════════
--             UI — BOBON EMBER FULLSCREEN HUD v5
--   Fixed full-screen overlay. Centered dashboard. No drag, no outer side bars.
--   Smoke-grey glass + ember accents; game remains visible through the HUD.
-- ══════════════════════════════════════════════════════════════════
do
    local okUI, uiErr = pcall(function()
        local UIS = game:GetService("UserInputService")
        local Lighting = game:GetService("Lighting")

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
        pcall(function()
            SafeDestroy(Lighting:FindFirstChild("BobonHubBlur"))
            local cam = workspace.CurrentCamera
            if cam then SafeDestroy(cam:FindFirstChild("BobonHubBlur")) end
        end)

        local SG = Instance.new("ScreenGui")
        BobonUIRoot = SG
        SG.Name = "BobonHubUI"
        SG.ResetOnSpawn = false
        SG.IgnoreGuiInset = true
        SG.DisplayOrder = 10000
        SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        SG.Parent = uiParent

        local ACCENT_A = Color3.fromRGB(255,106,38)   -- ember orange
        local ACCENT_B = Color3.fromRGB(255,58,45)    -- flame red
        local ACCENT_C = Color3.fromRGB(255,193,82)   -- fire gold
        local READY_GREEN = Color3.fromRGB(82,245,156)
        local DANGER_RED = Color3.fromRGB(255,84,92)
        local TEXT_MAIN = Color3.fromRGB(255,246,238)
        local TEXT_MUTED = Color3.fromRGB(197,180,173)
        local CARD_BG = Color3.fromRGB(39,31,29)

        local function Corner(obj, px)
            local x = Instance.new("UICorner")
            x.CornerRadius = UDim.new(0, px or 12)
            x.Parent = obj
            return x
        end

        local function Stroke(obj, color, transparency, thickness)
            local x = Instance.new("UIStroke")
            x.Color = color or ACCENT_A
            x.Transparency = transparency or 0.65
            x.Thickness = thickness or 1
            x.Parent = obj
            return x
        end

        local function FireGradient(obj)
            local g = Instance.new("UIGradient")
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, ACCENT_C),
                ColorSequenceKeypoint.new(0.34, ACCENT_A),
                ColorSequenceKeypoint.new(0.68, ACCENT_B),
                ColorSequenceKeypoint.new(1.00, ACCENT_C),
            })
            g.Rotation = 0
            g.Parent = obj
            return g
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
            x.TextTruncate = Enum.TextTruncate.AtEnd
            x.Parent = parent
            return x
        end

        local function Card(parent, pos, size)
            local x = Instance.new("Frame")
            x.Position = pos
            x.Size = size
            x.BackgroundColor3 = CARD_BG
            x.BackgroundTransparency = 0.34
            x.BorderSizePixel = 0
            x.Parent = parent
            Corner(x, 14)
            Stroke(x, Color3.fromRGB(255,126,78), 0.70, 1)
            return x
        end

        -- No black full-screen plate and no blur wall: the world stays visible.
        local Panel = Instance.new("Frame")
        Panel.Name = "BobonFullscreen"
        Panel.AnchorPoint = Vector2.new(0.5,0.5)
        Panel.Position = UDim2.fromScale(0.5,0.5)
        Panel.Size = UDim2.fromScale(1,1)
        -- Grey translucent veil: keep the same HUD layout, only restore readable
        -- contrast like the reference video without turning the screen black.
        Panel.BackgroundColor3 = Color3.fromRGB(30,27,27)
        Panel.BackgroundTransparency = 0.52
        Panel.BorderSizePixel = 0
        Panel.Parent = SG

        -- Centered information canvas only; transparent and borderless, so the
        -- previous two tall cyan/purple vertical lines are gone completely.
        local Content = Instance.new("Frame")
        Content.Name = "Dashboard"
        Content.AnchorPoint = Vector2.new(0.5,0.5)
        Content.Position = UDim2.fromScale(0.5,0.5)
        Content.Size = UDim2.new(0.78,0,0.78,0)
        Content.BackgroundColor3 = Color3.fromRGB(36,30,29)
        Content.BackgroundTransparency = 0.61
        Content.BorderSizePixel = 0
        Content.Parent = Panel

        local SizeLimit = Instance.new("UISizeConstraint")
        SizeLimit.MinSize = Vector2.new(620,430)
        SizeLimit.MaxSize = Vector2.new(920,620)
        SizeLimit.Parent = Content

        local ContentScale = Instance.new("UIScale")
        ContentScale.Scale = 0.96
        ContentScale.Parent = Content

        local Header = Instance.new("Frame")
        Header.Position = UDim2.new(0,28,0,22)
        Header.Size = UDim2.new(1,-56,0,62)
        Header.BackgroundTransparency = 1
        Header.Parent = Content

        local Brand = Text(Header, "◈  BOBON HUB", 28, TEXT_MAIN, true, Enum.TextXAlignment.Center)
        Brand.Position = UDim2.new(0,0,0,0)
        Brand.Size = UDim2.new(1,0,0,32)
        local BrandGradient = FireGradient(Brand)
        local Sub = Text(Header, "BLOX FRUITS  •  KAITUN", 11, ACCENT_C, true, Enum.TextXAlignment.Center)
        Sub.Position = UDim2.new(0,0,0,34)
        Sub.Size = UDim2.new(1,0,0,18)

        local OnlineDot = Instance.new("Frame")
        OnlineDot.AnchorPoint = Vector2.new(1,0.5)
        OnlineDot.Position = UDim2.new(1,-58,0,15)
        OnlineDot.Size = UDim2.new(0,8,0,8)
        OnlineDot.BackgroundColor3 = READY_GREEN
        OnlineDot.BorderSizePixel = 0
        OnlineDot.Parent = Header
        Corner(OnlineDot, 8)
        local OnlineL = Text(Header, "ONLINE", 10, READY_GREEN, true, Enum.TextXAlignment.Right)
        OnlineL.AnchorPoint = Vector2.new(1,0)
        OnlineL.Position = UDim2.new(1,0,0,5)
        OnlineL.Size = UDim2.new(0,50,0,20)
        local Ver = Text(Header, "v21.24.2", 9, ACCENT_C, false, Enum.TextXAlignment.Left)
        Ver.Position = UDim2.new(0,0,0,5)
        Ver.Size = UDim2.new(0,60,0,20)

        local LevelCard = Card(Content, UDim2.new(0.04,0,0.17,0), UDim2.new(0.44,0,0.12,0))
        local LevelCap = Text(LevelCard, "LEVEL", 10, TEXT_MUTED, true)
        LevelCap.Position = UDim2.new(0,16,0,7); LevelCap.Size = UDim2.new(1,-32,0,16)
        local LevelValue = Text(LevelCard, "1", 25, TEXT_MAIN, true)
        LevelValue.Position = UDim2.new(0,16,0,23); LevelValue.Size = UDim2.new(1,-32,1,-27)

        local SeaCard = Card(Content, UDim2.new(0.52,0,0.17,0), UDim2.new(0.44,0,0.12,0))
        local SeaCap = Text(SeaCard, "WORLD", 10, TEXT_MUTED, true)
        SeaCap.Position = UDim2.new(0,16,0,7); SeaCap.Size = UDim2.new(1,-32,0,16)
        local SeaValue = Text(SeaCard, "SEA 1", 22, ACCENT_A, true)
        SeaValue.Position = UDim2.new(0,16,0,23); SeaValue.Size = UDim2.new(0.55,-16,1,-27)
        local TeamL = Text(SeaCard, "PIRATES ✓", 11, READY_GREEN, true, Enum.TextXAlignment.Right)
        TeamL.Position = UDim2.new(0.55,0,0,23); TeamL.Size = UDim2.new(0.45,-16,1,-27)

        local StatusCard = Card(Content, UDim2.new(0.04,0,0.32,0), UDim2.new(0.92,0,0.19,0))
        local StatusDot = Instance.new("Frame")
        StatusDot.Position = UDim2.new(0,16,0,18)
        StatusDot.Size = UDim2.new(0,9,0,9)
        StatusDot.BackgroundColor3 = READY_GREEN
        StatusDot.BorderSizePixel = 0
        StatusDot.Parent = StatusCard
        Corner(StatusDot, 9)
        local ModeL = Text(StatusCard, "FARMING", 11, READY_GREEN, true)
        ModeL.Position = UDim2.new(0,34,0,11); ModeL.Size = UDim2.new(0.42,0,0,22)
        local FlagL = Text(StatusCard, "READY", 10, ACCENT_A, true, Enum.TextXAlignment.Right)
        FlagL.Position = UDim2.new(0.52,0,0,11); FlagL.Size = UDim2.new(0.48,-16,0,22)
        local StatusL = Text(StatusCard, "Initializing...", 18, TEXT_MAIN, true, Enum.TextXAlignment.Center)
        StatusL.Position = UDim2.new(0,16,0.34,0); StatusL.Size = UDim2.new(1,-32,0.33,0)
        local ClusterL = Text(StatusCard, "Cluster: waiting", 11, TEXT_MUTED, false, Enum.TextXAlignment.Center)
        ClusterL.Position = UDim2.new(0,16,0.70,0); ClusterL.Size = UDim2.new(1,-32,0.22,0)

        local BeliCard = Card(Content, UDim2.new(0.04,0,0.54,0), UDim2.new(0.44,0,0.12,0))
        local BeliCap = Text(BeliCard, "BELI", 10, TEXT_MUTED, true)
        BeliCap.Position = UDim2.new(0,16,0,7); BeliCap.Size = UDim2.new(1,-32,0,16)
        local BeliL = Text(BeliCard, "$ 0", 18, Color3.fromRGB(255,196,91), true)
        BeliL.Position = UDim2.new(0,16,0,24); BeliL.Size = UDim2.new(1,-32,1,-28)

        local FragCard = Card(Content, UDim2.new(0.52,0,0.54,0), UDim2.new(0.44,0,0.12,0))
        local FragCap = Text(FragCard, "FRAGMENTS", 10, TEXT_MUTED, true)
        FragCap.Position = UDim2.new(0,16,0,7); FragCap.Size = UDim2.new(1,-32,0,16)
        local FragL = Text(FragCard, "◈ 0", 18, Color3.fromRGB(255,126,66), true)
        FragL.Position = UDim2.new(0,16,0,24); FragL.Size = UDim2.new(1,-32,1,-28)

        local KillCard = Card(Content, UDim2.new(0.04,0,0.69,0), UDim2.new(0.44,0,0.11,0))
        local KillCap = Text(KillCard, "KILLS", 10, TEXT_MUTED, true)
        KillCap.Position = UDim2.new(0,16,0,6); KillCap.Size = UDim2.new(0.4,0,0,15)
        local KillL = Text(KillCard, "0", 17, Color3.fromRGB(255,84,92), true)
        KillL.Position = UDim2.new(0,16,0,21); KillL.Size = UDim2.new(1,-32,1,-25)

        local TimeCard = Card(Content, UDim2.new(0.52,0,0.69,0), UDim2.new(0.44,0,0.11,0))
        local TimeCap = Text(TimeCard, "RUNTIME", 10, TEXT_MUTED, true)
        TimeCap.Position = UDim2.new(0,16,0,6); TimeCap.Size = UDim2.new(0.48,0,0,15)
        local TimeL = Text(TimeCard, "00:00:00", 17, TEXT_MAIN, true)
        TimeL.Position = UDim2.new(0,16,0,21); TimeL.Size = UDim2.new(1,-32,1,-25)

        local Footer = Card(Content, UDim2.new(0.04,0,0.83,0), UDim2.new(0.92,0,0.10,0))
        local CombatL = Text(Footer, "COMBAT  WAITING", 10, Color3.fromRGB(255,190,102), true)
        CombatL.Position = UDim2.new(0,16,0,0); CombatL.Size = UDim2.new(0.48,-16,1,0)
        local BringL = Text(Footer, "BRING  WAITING", 10, TEXT_MUTED, true, Enum.TextXAlignment.Right)
        BringL.Position = UDim2.new(0.52,0,0,0); BringL.Size = UDim2.new(0.48,-16,1,0)

        -- Fixed toggle button remains visible when the full overlay is hidden.
        local Toggle = Instance.new("TextButton")
        Toggle.Name = "BobonToggle"
        Toggle.AnchorPoint = Vector2.new(1,0)
        Toggle.Position = UDim2.new(1,-18,0,18)
        Toggle.Size = UDim2.new(0,42,0,42)
        Toggle.BackgroundColor3 = Color3.fromRGB(42,29,25)
        Toggle.BackgroundTransparency = 0.28
        Toggle.BorderSizePixel = 0
        Toggle.Text = "◈"
        Toggle.TextColor3 = ACCENT_A
        Toggle.TextSize = 19
        Toggle.Font = Enum.Font.GothamBold
        Toggle.AutoButtonColor = false
        Toggle.ZIndex = 100
        Toggle.Parent = SG
        Corner(Toggle, 13)
        Stroke(Toggle, ACCENT_A, 0.45, 1.2)

        local Hint = Text(Content, "Right Ctrl  •  Hide / Show", 9, TEXT_MUTED, false, Enum.TextXAlignment.Center)
        Hint.AnchorPoint = Vector2.new(0.5,1)
        Hint.Position = UDim2.new(0.5,0,1,-8)
        Hint.Size = UDim2.new(0.6,0,0,16)

        local function Fmt(n)
            local st = tostring(math.floor(tonumber(n) or 0))
            return st:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
        end

        local visible = true
        local busy = false
        local function SetVisible(v)
            if busy or v == visible then return end
            busy = true
            visible = v
            if v then
                Panel.Visible = true
                ContentScale.Scale = 0.96
                pcall(function()
                    TS:Create(ContentScale, TweenInfo.new(0.20, Enum.EasingStyle.Quad), {Scale=1}):Play()
                end)
                task.delay(0.21, function() busy = false end)
            else
                pcall(function()
                    TS:Create(ContentScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Scale=0.96}):Play()
                end)
                task.delay(0.16, function()
                    if not visible then Panel.Visible = false end
                    busy = false
                end)
            end
        end

        BobonUIConnections[#BobonUIConnections + 1] =
            Toggle.MouseButton1Click:Connect(function() SetVisible(not visible) end)
        BobonUIConnections[#BobonUIConnections + 1] =
            UIS.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == Enum.KeyCode.RightControl then
                SetVisible(not visible)
            end
        end)

        pcall(function()
            ContentScale.Scale = 0.94
            TS:Create(ContentScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Scale=1}):Play()
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
                    if mode == "Farming" or mode == "Raiding" then
                        StatusDot.BackgroundColor3 = READY_GREEN
                    elseif mode == "Recovering" or mode == "Dead" then
                        StatusDot.BackgroundColor3 = DANGER_RED
                    else
                        StatusDot.BackgroundColor3 = ACCENT_C
                    end
                    local clusterMode = tostring(state.ClusterMode or "OFF")
                    local candidates = tonumber(diag.BringCandidates) or 0
                    local owned = tonumber(diag.BringOwned) or 0
                    local proven = tonumber(diag.BringDamageProven) or 0
                    local probes = tonumber(diag.BringProbe) or 0
                    local reachable = tonumber(diag.BringReachable) or 0
                    local visual = tonumber(diag.BringVisual) or 0
                    local unknown = tonumber(diag.BringUnknown) or 0
                    local moved = tonumber(diag.BringMoved) or 0
                    if clusterMode ~= "OFF" then
                        ClusterL.Text = ("ALL-MOB %s  • found %d • owned %d • stacked %d • unowned %d • api %s")
                            :format(clusterMode, candidates, owned, moved,
                                math.max(0, candidates - owned),
                                tostring(diag.OwnerAPI or "CHECK"))
                    else
                        ClusterL.Text = "ALL-MOB CLUSTER OFF  •  waiting"
                    end
                    if state.FState == "SKIP_FARM" and (state.Sea or 1) == 1 then
                        FlagL.Text = lv <= 50 and "SKIP • FLOOR 1" or "SKIP • FLOOR 2"
                    elseif state.LastTargetContested and tick() - state.LastTargetContested <= (_G.Settings.ContestGrace or 3) then
                        FlagL.Text = "CONTESTED"
                    elseif state.ClusterAcquireTarget then
                        FlagL.Text = "OWNERSHIP SWEEP"
                    elseif probes > 0 then
                        FlagL.Text = "VERIFYING ×" .. tostring(probes)
                    elseif clusterMode ~= "OFF" then
                        FlagL.Text = "STACK ×" .. tostring(moved)
                    else
                        FlagL.Text = "READY"
                    end
                    local packet = tostring(diag.Packet or "WAITING")
                    local ready = packet:find("CONFIRMED",1,true) ~= nil
                    CombatL.Text = ready and "COMBAT  READY" or ("COMBAT  " .. packet)
                    CombatL.TextColor3 = ready and READY_GREEN or ACCENT_C
                    if moved > 0 then
                        BringL.Text = "BRING  VERIFIED ×" .. tostring(moved)
                        BringL.TextColor3 = ACCENT_A
                    elseif candidates > moved then
                        BringL.Text = "BRING  OWNERSHIP SWEEP "
                            .. tostring(moved) .. "/" .. tostring(candidates)
                        BringL.TextColor3 = ACCENT_C
                    else
                        BringL.Text = "BRING  " .. tostring(diag.Bring or "WAITING")
                        BringL.TextColor3 = TEXT_MUTED
                    end
                end)
                task.wait(0.25)
            end
        end)

        task.spawn(function()
            while SessionAlive() and SG.Parent do
                pcall(function()
                    OnlineDot.BackgroundTransparency = OnlineDot.BackgroundTransparency > 0.2 and 0 or 0.45
                    Toggle.TextColor3 = Toggle.TextColor3 == ACCENT_A and ACCENT_C or ACCENT_A
                    BrandGradient.Rotation = (BrandGradient.Rotation + 18) % 360
                end)
                task.wait(0.8)
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
    local h = Hum()
    if not h or h.Health <= 0 or h.MaxHealth <= 0 then return false end
    local state = _G.State
    if not state then return false end
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
local GatherDamageLeaseUntil = setmetatable({}, { __mode = "k" })
local GatherMoveTrial = setmetatable({}, { __mode = "k" })
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
    local shadowQuest = questGatherActive and ClusterFarmController
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
                    if (questGatherActive or clusterGatherActive) and enemy ~= preferred then
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
    local airFarm = IsAirFarmCombat()
    local shadowQuest = airFarm and ClusterFarmController
        and ClusterFarmController:IsShadowCombatActive()
    local stackedCount = tonumber(_G.BobonDiagnostics
        and _G.BobonDiagnostics.BringMoved) or 0
    local clusterMulti = airFarm
        and _G.State and _G.State.ClusterMode ~= "OFF"
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

    if self.VerifiedBackend and self:BackendAvailable(self.VerifiedBackend) then
        if not (airFarm and IsClientInputBackend(self.VerifiedBackend)) then
            return self.VerifiedBackend
        end
    end

    if airFarm then
        local order = shadowQuest
            and {"LEGACY-2", "TOKEN-4", "CLIENT-HELPER"}
            or (clusterMulti
                and {"TOKEN-4", "CLIENT-HELPER", "LEGACY-2"}
                or {"CLIENT-HELPER", "TOKEN-4", "LEGACY-2"})
        for _, name in ipairs(order) do
            if self:BackendAvailable(name) then return name end
        end
        return nil
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

    local clusterIndependent = IsAirFarmCombat()
        and _G.Settings.ClusterIndependentSwingFanout == true
        and _G.State and _G.State.ClusterMode ~= "OFF"
        and #entries >= 2
    local maxFanout = math.max(2,
        math.floor(tonumber(_G.Settings.ClusterIndependentSwingMaxTargets) or 8))
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
    local clusterFanout = _G.State and _G.State.ClusterMode ~= "OFF"
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
    GatherDamageLeaseUntil = setmetatable({}, { __mode = "k" })
    GatherMoveTrial = setmetatable({}, { __mode = "k" })
    if ClusterFarmController then
        ClusterFarmController.LastBatch = {}
        ClusterFarmController.AcquireBlockedUntil = setmetatable({}, { __mode = "k" })
        ClusterFarmController.AcquireAttempts = setmetatable({}, { __mode = "k" })
        ClusterFarmController.PositionProof = setmetatable({}, { __mode = "k" })
        ClusterFarmController.RemotePullRetryAt = setmetatable({}, { __mode = "k" })
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
    local changed = state.ClusterMode ~= mode or state.ClusterMobName ~= list[1]
        or not state.ClusterAnchor
        or (state.ClusterAnchor.Position - cf.Position).Magnitude > (_G.Settings.ClusterAnchorMaxDrift or 18)
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
    GatherDamageLeaseUntil = setmetatable({}, { __mode = "k" })
    GatherMoveTrial = setmetatable({}, { __mode = "k" })
        self.AcquireBlockedUntil = setmetatable({}, { __mode = "k" })
        self.AcquireAttempts = setmetatable({}, { __mode = "k" })
        self.PositionProof = setmetatable({}, { __mode = "k" })
        self.RemotePullRetryAt = setmetatable({}, { __mode = "k" })
        state.ClusterGeneration = (state.ClusterGeneration or 0) + 1
        state.ClusterActivatedAt = tick()
        state.ClusterPrimary = nil
        state.ClusterAcquireTarget = nil
        state.ClusterAcquireStartedAt = 0
        state.ClusterAcquireDeadline = 0
        state.ClusterAcquireCompleted = 0
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
    state.ClusterAnchor = CFrame.new(cf.Position)
    state.ClusterMobNames = list
    state.ClusterMobName = list[1]
    state.ClusterOwner = owner or "Farm"
    return true
end

function ClusterFarmController:GetPileAnchorPosition()
    local state = _G.State
    local baseCF = state and state.ClusterAnchor
    if not baseCF then return nil end

    local base = baseCF.Position
    if _G.Settings.ClusterOnePileUnderfoot == false then
        state.ClusterPileAnchor = CFrame.new(base)
        return base
    end

    -- Stable hover already uses FarmOffsetX. Put the final pile at that same X/Z
    -- so it is literally below the player's feet instead of 3 studs to the side.
    local stable = Vector3.new(base.X + (_G.Settings.FarmOffsetX or 0), base.Y, base.Z)
    local me = HRP()
    if not me then
        state.ClusterPileAnchor = CFrame.new(stable)
        return stable
    end

    local flatToStable = (Vector3.new(me.Position.X, 0, me.Position.Z)
        - Vector3.new(stable.X, 0, stable.Z)).Magnitude
    local acquire = state.ClusterAcquireTarget
    local acquireHum = acquire and acquire:FindFirstChildOfClass("Humanoid")
    local acquireRoot = acquire and acquire:FindFirstChild("HumanoidRootPart")
    -- Do not call IsVerified() here: IsVerified itself asks for the pile anchor.
    -- The acquire handle may remain set for one main-loop tick after ownership
    -- transfers; following it for that tiny window keeps the pile underfoot.
    local acquireLive = acquire and acquire.Parent and self:IsModelAllowed(acquire)
        and acquireHum and acquireHum.Health > 0 and acquireRoot and acquireRoot.Parent
    local follow = _G.Settings.ClusterPileFollowDuringSweep ~= false
        and (acquireLive or flatToStable > (_G.Settings.ClusterPileSettleRadius or 20))

    if follow then
        local groundY = base.Y
        if _G.Settings.ClusterPileUseAcquireGroundY ~= false and acquireLive then
            local r = acquireRoot
            if r and r.Parent then
                local ok, y = pcall(function() return r.Position.Y end)
                if ok and type(y) == "number" and y == y then groundY = y end
            end
        end
        local moving = Vector3.new(me.Position.X, groundY, me.Position.Z)
        state.ClusterPileAnchor = CFrame.new(moving)
        return moving
    end

    state.ClusterPileAnchor = CFrame.new(stable)
    return stable
end

function ClusterFarmController:GetHoverCFrame(height)
    local anchor = _G.State and _G.State.ClusterAnchor
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
            GatherDamageLeaseUntil[root] = nil
            GatherMoveTrial[root] = nil
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
    elseif authority == "DAMAGE-LEASE" then
        if (GatherDamageLeaseUntil[root] or 0) <= tick()
            or not self:IsDamageProven(model) then
            GatherAuthorityClass[root] = nil
            GatherDamageLeaseUntil[root] = nil
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
        and (GatherDamageLeaseUntil[root] or 0) > now then
        GatherDamageLeaseUntil[root] = now
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
                GatherDamageLeaseUntil[root] = nil
                GatherMoveTrial[root] = nil
                VerifiedGatherRoots[root] = now
                return true
            end
        end
        return true
    end

    -- v21.23 fallback: only UNKNOWN ownership may try this path. We never override an
    -- explicit false result from a working ownership API. The hit happened while the
    -- mob was still at its real replicated position, so the HP delta is genuine.
    if own == nil and _G.Settings.ClusterDamageLeaseEnabled ~= false
        and state and (state.ClusterMode == "QUEST" or state.ClusterMode == "SKIP") then
        local me = HRP()
        local okPos, pos = pcall(function() return root.Position end)
        local acquireRadius = tonumber(_G.Settings.ClusterDamageLeaseAcquireRadius) or 18
        if me and okPos and IsValidPos(pos)
            and (pos - me.Position).Magnitude <= acquireRadius then
            local pile = self:GetPileAnchorPosition()
                or (state.ClusterAnchor and state.ClusterAnchor.Position)
            if pile and not GatherMoveTrial[root] then
                local okMove = pcall(function()
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.CFrame = CFrame.new(pile)
                end)
                if okMove then
                    -- One write only. RestackBatch will intentionally NOT rewrite this root
                    -- until enough Heartbeats prove the position did not snap back.
                    GatherMoveTrial[root] = {
                        StartedAt = now,
                        Anchor = pile,
                        Checks = 0,
                    }
                    GatherAuthorityClass[root] = "DAMAGE-TRIAL"
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
    if not state or (state.ClusterMode ~= "QUEST" and state.ClusterMode ~= "SKIP")
        or _G.Settings.ClusterAcquireSweep == false or not self:PolicyValid() then
        if state then
            state.ClusterAcquireTarget = nil
            state.ClusterAcquireStartedAt = 0
            state.ClusterAcquireDeadline = 0
        end
        return nil
    end

    if state.ClusterMode == "QUEST"
        and _G.Settings.ClusterQuestPhysicalFallback ~= true then
        state.ClusterAcquireTarget = nil
        state.ClusterAcquireStartedAt = 0
        state.ClusterAcquireDeadline = 0
        return nil
    end
    if state.ClusterMode == "SKIP"
        and _G.Settings.ClusterSkipPhysicalFallback == false then
        state.ClusterAcquireTarget = nil
        state.ClusterAcquireStartedAt = 0
        state.ClusterAcquireDeadline = 0
        return nil
    end

    local now = tick()
    local current = state.ClusterAcquireTarget
    if current and current.Parent and self:IsModelAllowed(current)
        and not self:IsVerified(current) then
        if now <= (state.ClusterAcquireDeadline or 0) then return current end
        local attempts = (self.AcquireAttempts[current] or 0) + 1
        self.AcquireAttempts[current] = attempts
        local retryAfter = attempts >= (_G.Settings.ClusterAcquireMaxAttempts or 1)
            and (_G.Settings.ClusterAcquireCycleRetry or 20)
            or (_G.Settings.ClusterAcquireRetry or 1.2)
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
            and not GatherMoveTrial[root]
            and (self.AcquireBlockedUntil[model] or 0) <= now
            and ClientOwnsMob(root) ~= true then
            local ok, livePos = pcall(function() return root.Position end)
            local pos = entry.Position or GatherOriginalPositions[root]
                or (ok and livePos or nil)
            if pos and IsValidPos(pos) then
                acquirePool[#acquirePool + 1] = {
                    Model = model,
                    Root = root,
                    Position = pos,
                    PlayerDistance = me and (pos - me.Position).Magnitude or 0,
                }
            end
        end
    end

    -- v21.21 group sweep: choose the real mob whose neighborhood covers the most
    -- still-unowned mobs. One proximity pass can therefore transfer several nearby
    -- assemblies instead of forcing a strict mob-by-mob tour.
    local best, bestDist, bestCoverage = nil, nil, -1
    local groupRadius = math.max(25,
        tonumber(_G.Settings.ClusterAcquireGroupRadius) or 90)
    for _, row in ipairs(acquirePool) do
        local coverage = 1
        if _G.Settings.ClusterAcquirePreferCoverage ~= false then
            coverage = 0
            for _, other in ipairs(acquirePool) do
                if (other.Position - row.Position).Magnitude <= groupRadius then
                    coverage = coverage + 1
                end
            end
        end
        if coverage > bestCoverage
            or (coverage == bestCoverage
                and (bestDist == nil or row.PlayerDistance < bestDist)) then
            best = row.Model
            bestDist = row.PlayerDistance
            bestCoverage = coverage
        end
    end
    if best then
        state.ClusterAcquireTarget = best
        state.ClusterAcquireStartedAt = now
        local eta = (bestDist or 0) / math.max(1,
            _G.Settings.SkipTravelSpeed or _G.Settings.FlySpeed or 180)
        state.ClusterAcquireDeadline = now + math.clamp(
            eta + (_G.Settings.ClusterAcquireSettle or 0.7),
            _G.Settings.ClusterAcquireTimeout or 0.9,
            _G.Settings.ClusterAcquireMaxTimeout or 4.0)
    end
    return best
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
    local anchorCF = state and state.ClusterAnchor
    if not anchorCF then return 0 end

    local anchor = self:GetPileAnchorPosition() or anchorCF.Position
    local now = tick()
    local kept, verifiedCount = {}, 0

    local function writeRoot(root)
        return pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = CFrame.new(anchor)
        end)
    end

    local proofWindow = tonumber(_G.Settings.ClusterDamageLeaseProofWindow) or 0.28
    local proofChecks = math.max(2,
        math.floor(tonumber(_G.Settings.ClusterDamageLeaseProofChecks) or 5))
    local proofRadius = tonumber(_G.Settings.ClusterDamageLeaseProofRadius) or 7
    local rejectRadius = tonumber(_G.Settings.ClusterDamageLeaseSnapRejectRadius) or 18
    local leaseTTL = tonumber(_G.Settings.ClusterDamageLeaseTTL) or 1.80

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
            if own == true then
                if writeRoot(root) then
                    GatherAuthorityClass[root] = "OWNED"
                    GatherDamageLeaseUntil[root] = nil
                    GatherMoveTrial[root] = nil
                    VerifiedGatherRoots[root] = now
                    GatherProbeCandidates[root] = nil
                    GatherProbeFailedUntil[root] = nil
                    verifiedCount = verifiedCount + 1
                end
            else
                local trial = GatherMoveTrial[root]
                if trial then
                    -- IMPORTANT: do not rewrite during proof. A server-owned root must get
                    -- a chance to snap back; otherwise a local-only statue could pass.
                    local okTrialPos, trialPos = pcall(function() return root.Position end)
                    if okTrialPos and IsValidPos(trialPos) then
                        local dist = (trialPos - trial.Anchor).Magnitude
                        if dist <= proofRadius then
                            trial.Checks = (trial.Checks or 0) + 1
                            if now - (trial.StartedAt or now) >= proofWindow
                                and trial.Checks >= proofChecks
                                and self:IsDamageProven(model) then
                                GatherMoveTrial[root] = nil
                                GatherAuthorityClass[root] = "DAMAGE-LEASE"
                                GatherDamageLeaseUntil[root] = now + leaseTTL
                                VerifiedGatherRoots[root] = now
                                verifiedCount = verifiedCount + 1
                            end
                        elseif dist >= rejectRadius
                            or now - (trial.StartedAt or now) > proofWindow + 0.35 then
                            GatherMoveTrial[root] = nil
                            GatherDamageLeaseUntil[root] = nil
                            GatherAuthorityClass[root] = nil
                            VerifiedGatherRoots[root] = nil
                        end
                    end
                elseif GatherAuthorityClass[root] == "DAMAGE-LEASE"
                    and (GatherDamageLeaseUntil[root] or 0) > now
                    and self:IsDamageProven(model) then
                    -- Damage-backed lease has already survived a no-rewrite persistence
                    -- test. Keep the root in the moving underfoot pile until damage goes
                    -- stale; every later HP delta refreshes the lease.
                    if writeRoot(root) then
                        VerifiedGatherRoots[root] = now
                        -- Do NOT extend the lease here. Only a new real HP delta in
                        -- ConfirmDamageProof may refresh it.
                        verifiedCount = verifiedCount + 1
                    end
                else
                    if GatherAuthorityClass[root] == "OWNED"
                        or GatherAuthorityClass[root] == "DAMAGE-LEASE"
                        or GatherAuthorityClass[root] == "DAMAGE-TRIAL" then
                        GatherAuthorityClass[root] = nil
                    end
                    GatherDamageLeaseUntil[root] = nil
                    VerifiedGatherRoots[root] = nil
                    GatherProbeCandidates[root] = nil
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
    local questFieldRadius = tonumber(_G.Settings.ClusterAuthorityFieldRadius)
        or tonumber(_G.Settings.ClusterQuestRadius) or 180
    local maxDistance = state.ClusterMode == "RAID"
        and math.max(100, tonumber(_G.Settings.RaidGatherRadius) or 700)
        or (state.ClusterMode == "QUEST"
            and math.max(80, questFieldRadius)
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

    if stacked > 0 then
        _G.BobonDiagnostics.Bring = "AUTHORITY-STACK"
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

-- TRUE ALL-MOB magnet: Heartbeat keeps every member of the latest full-spawn
-- snapshot pinned to one anchor while a light rescan discovers new respawns.
local ClusterHeartbeatConnection
pcall(function()
    ClusterHeartbeatConnection = RunService.Heartbeat:Connect(function()
        if not SessionAlive() then return end
        if _G.State and _G.State.ClusterMode ~= "OFF" then
            pcall(function() ClusterFarmController:RestackBatch() end)
        end
    end)
end)
task.spawn(function()
    while SessionAlive() and task.wait(0.03) do
        local ok, err = pcall(function() ClusterFarmController:Tick() end)
        if not ok and _G.Settings.DEBUG then warn("[BobonHub] Cluster Error: " .. tostring(err)) end
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
    local now = tick()
    if now - (self.LastTry or 0) < (_G.Settings.CoreAbilityRetry or 45) then return false end
    self.LastTry = now
    pcall(function() CommF_:InvokeServer("BuyHaki", "Geppo") end)
    pcall(function() CommF_:InvokeServer("BuyHaki", "Buso") end)
    pcall(function() CommF_:InvokeServer("BuyHaki", "Soru") end)
    pcall(function() CommF_:InvokeServer("KenTalk", "Buy") end)
    return true
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
            local maxHealth = tonumber(humanoid.MaxHealth) or 0
            local hpPct = maxHealth > 0 and (newHealth / maxHealth) * 100 or 100
            if hpPct <= (_G.Settings.EmergencyHealthPercent or 55) then
                -- Preserve the exact job/target/cluster, but stop sitting inside NPC
                -- melee range. This fixes the video failure where Snowmen chip HP to
                -- zero while the client-input backend keeps the player at ~5 studs.
                _G.State.FarmSafetyActive = true
                _G.State.FarmSafetyUntil = math.max(_G.State.FarmSafetyUntil or 0,
                    tick() + (_G.Settings.EmergencyMinHold or 2.5))
                if CombatController then
                    CombatController.DesiredClientRange = false
                    CombatController.ClientRetreatUntil = math.max(
                        CombatController.ClientRetreatUntil or 0,
                        _G.State.FarmSafetyUntil)
                end
                _G.BobonStatus = "Farm: Safe hover • recovering HP"
            end
            if _G.Settings.ContinuityMode then
                -- Damage/knockback must not look like a travel stall. Keep the
                -- existing ActionToken, MovementOwner, target and Mode intact.
                _G.State.LastMoveTime = os.time()
                _G.State.ConsecutiveFails = 0
                DLog("CONTINUITY", "incoming damage preserved job; safe-hover may engage")
            end
        end
        -- Hysteresis: do not descend again the instant HP crosses the trigger.
        if _G.State.FarmSafetyActive and humanoid.MaxHealth > 0
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
    -- Teddy-style early skip needs a verified fast backend. If damage cannot be
    -- proven, normal quest farming remains the safe bootstrap/fallback.
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
        -- Any real level progress refreshes the watchdog without destroying the
        -- persistent cluster. Floor transition is handled by CurrentKey above.
        self.RouteStartLevel = Level()
        self.RouteStartTime = os.time()
    end

    if self.RouteStartTime and os.time() - self.RouteStartTime
        > (_G.Settings.SkipRouteFallbackTimeout or 90) then
        self:Reset("skip made no level progress")
        DLog("SKIP", "Teddy skip stalled → normal quest fallback")
        return false
    end

    -- The showcase farms these high-level mobs without the normal low-level quest.
    if HasQuest() == true then
        pcall(function() CommF_:InvokeServer("AbandonQuest") end)
        _G.State.ActiveQuestMob = nil
    end

    _G.State:SetMode("Farming")
    _G.State.FState = "SKIP_FARM"
    _G.BobonStatus = "Level Farming | Skip Mode | "
        .. (route.Key == "TeddyFloor1" and "Floor 1" or "Floor 2")

    -- Keep one persistent spawn anchor and refresh the complete same-name batch.
    ClusterFarmController:Activate("SKIP", route.Names, route.Fallback, "Farm")
    ClusterFarmController:Tick()

    local hoverHeight = _G.Settings.FarmHeight or 22
    local hoverCF = ClusterFarmController:GetHoverCFrame(hoverHeight)

    -- v21.7 CRITICAL FIX:
    -- Acquire BEFORE requesting the persistent hover anchor. The old order did:
    --   hoverCF request -> mob request -> next tick hoverCF request
    -- so the same Farm owner atomically retargeted away from the mob every tick.
    -- Both Floor 1 and Floor 2 therefore showed found>0, owned=0, stacked=0 and
    -- appeared to teleport to the island then stand forever.
    local acquireTarget = ClusterFarmController:GetAcquireTarget()
    local acquireRoot = acquireTarget
        and acquireTarget:FindFirstChild("HumanoidRootPart")
    local acquiring = acquireRoot ~= nil
        and _G.State:IsTargetValid(acquireTarget)
        and ClusterFarmController:IsModelAllowed(acquireTarget)

    local primary = ClusterFarmController:SelectPrimary()
    local target = nil
    local targetRoot = nil

    if acquiring then
        -- The acquisition trip owns this tick. Do NOT overwrite it with hoverCF.
        _G.State.FState = "SKIP_FARM"
        _G.State.FarmTarget = acquireTarget
        _G.State.CurrentTarget = acquireTarget
        target = acquireTarget
        targetRoot = acquireRoot
        PrepareCombatTarget(acquireTarget)

        local stacked = ClusterFarmController:GetVerifiedCount()
        local total = tonumber(_G.BobonDiagnostics.BringCandidates) or 0
        _G.BobonStatus = ("Skip: Gathering + attacking %s (%d/%d)")
            :format(tostring(route.Display or route.Names[1]), stacked, total)

        if _G.State:CanRequestTravel() then
            TravelManager:Request(acquireRoot, "Farm", {
                arrivalThreshold = _G.Settings.ClusterAcquireArrivalThreshold
                    or _G.Settings.FarmArrivalThreshold,
                fallback = hoverCF or route.Fallback,
                combatHover = true,
                speed = _G.Settings.SkipTravelSpeed or 320,
            })
        end

    elseif primary then
        -- No more immediate acquire target: settle above the verified stack.
        _G.State.FState = "SKIP_FARM"
        _G.State.FarmTarget = primary
        _G.State.CurrentTarget = primary
        target = primary
        targetRoot = primary:FindFirstChild("HumanoidRootPart")
        PrepareCombatTarget(primary)

        if hoverCF and _G.State:CanRequestTravel() then
            TravelManager:Request(hoverCF, "Farm", {
                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                fallback = route.Fallback,
                combatHover = true,
                speed = _G.Settings.SkipTravelSpeed or 320,
                persistent = true,
            })
        end

    else
        -- v21.13: no immediate nearest-mob chase here. RestackBatch gets the first
        -- chance to remote-pull the whole floor; GetAcquireTarget becomes the single
        -- bounded fallback only if zero mobs can be proven at the anchor.
        _G.State.FarmTarget = nil
        _G.State.CurrentTarget = nil
        if hoverCF and _G.State:CanRequestTravel() then
            TravelManager:Request(hoverCF, "Farm", {
                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                fallback = route.Fallback,
                combatHover = true,
                speed = _G.Settings.SkipTravelSpeed or 320,
                persistent = true,
            })
        end
        _G.BobonStatus = "Skip: Remote gathering " .. tostring(route.Display)
        return true
    end

    -- HYBRID ATTACK: while acquiring, damage the exact real floor mob as soon as
    -- it is inside the verified fast-attack range. Once settled, require the
    -- normal combat anchor. CollectTargets will also include every verified
    -- same-name mob already stacked at the anchor.
    local me = HRP()
    if target and targetRoot and me and _G.State:IsTargetValid(target) then
        local okPos, targetPos = pcall(function() return targetRoot.Position end)
        if okPos and IsValidPos(targetPos) then
            local range = _G.Settings.FastAttackRange or _G.Settings.AttackRange or 100
            local distance = (me.Position - targetPos).Magnitude
            local farmHolds = not _G.State.IsTraveling
                or _G.State.MovementOwner == "Farm"
            local canHit = distance <= range and farmHolds
                and (acquiring or TravelManager:IsAtCombatAnchor())

            if canHit then
                EquipCombatTool()
                Attack(target, route.Names[1])
            end
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
                if CanSpendFragments(1500, "Full Melee: Dragon Breath", 100) then
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
                        if CanSpendFragments(1500, "Full Melee: Dragon Breath", 100) then
                            pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","1") end)
                            pcall(function() CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end)
                        end
                    else
                        InvokeStyle(row.baseRemote)
                    end
                end
                return false
            end
            if tick() - self.LastProbe >= 15 and CanSpendFragments(5000, "Full Melee: V2 Fighting Style", 100) then
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
        if tick() - self.LastProbe >= 20 and CanSpendFragments(5000, "Full Melee: Godhuman", 110) then
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
        and Level() >= 2400 and tick() - self.LastProbe >= 30 and CanSpendFragments(5000, "Full Melee: Sanguine Art", 105) then
        self.LastProbe = tick()
        InvokeStyle("BuySanguineArt", true)
        InvokeStyle("BuySanguineArt")
    end
    -- Godhuman/Sanguine purchase probes do not need to monopolize the combat
    -- preference. Return false so sword mastery can train during normal farm.
    return false
end

-- ══════════════════════════════════════════════════════════════════
--   v19.0 KAITUN-ONLY SWORD PROGRESSION — TRUE TRIPLE KATANA
--   No random Beli-shop sword sweep. Only TTK prerequisites and the
--   existing kaitun item/progression swords remain; no fake inventory state.
-- ══════════════════════════════════════════════════════════════════
local SwordProgressionController = {
    LastLegendaryProbe = 0,
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

    -- Kaitun-only sword work: do NOT buy random shop swords.
    -- Keep the TTK prerequisite chain because it is an explicit kaitun goal.
    -- Training never owns movement: normal quest/cluster farm supplies the kills.
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
    if not self:OptionalReady("Saber") then return false end
    local myToken = _G.State:ClaimAction("Saber")
    if myToken == 0 then return false end
    PrepareClaimedAction("Saber")
    self.NextOptional.Saber = tick() + 5
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

FightingStyleUnlockController = { LastBoneRoll = 0 }
function FightingStyleUnlockController:TryRun()
    if not _G.Settings.AutoFightingStyles or not _G.Settings.AutoBuyMelee then return false end

    -- Death Step: Library Key from Awakened Ice Admiral permanently opens the door.
    local darkM = math.max(EffectiveMastery("Dark Step"), EffectiveMastery("Black Leg"))
    if GetSea() == 2 and darkM >= 400 and not InventoryHas("Death Step") then
        if FindOwnedTool("Library Key") then
            return StartOptionalAction(ItemProgression, "DeathStepDoor", "StyleUnlock",
                "Melee: Unlocking Death Step", function(token)
                EquipNamedTool("Library Key")
                TravelAndWait("StyleUnlock", token, CFrame.new(6377.09,296.63,-6843.89), {
                    timeout=90, arrivalThreshold=7, settle=1.2,
                })
                InvokeStyle("BuyDeathStep", true)
                InvokeStyle("BuyDeathStep")
            end)
        end
    end

    -- Sharkman Karate: Water Key is consumed/validated by the teacher endpoint.
    local waterM = math.max(EffectiveMastery("Water Kung Fu"), EffectiveMastery("Fishman Karate"))
    if GetSea() == 2 and waterM >= 400 and not InventoryHas("Sharkman Karate")
        and FindOwnedTool("Water Key") then
        InvokeStyle("BuySharkmanKarate", true)
        InvokeStyle("BuySharkmanKarate")
        return false
    end

    -- Dragon Talon: Fire Essence comes from Death King's 50-Bone surprise roll.
    local dragonM = math.max(EffectiveMastery("Dragon Breath"), EffectiveMastery("Dragon Claw"))
    if GetSea() == 3 and dragonM >= 400 and not InventoryHas("Dragon Talon") then
        if HasFireEssence() then
            InvokeStyle("BuyDragonTalon", true)
            InvokeStyle("BuyDragonTalon")
            return false
        end
        local reserve = SkullBoneReserve()
        if MaterialCount("Bones") >= reserve + 50
            and tick() - (self.LastBoneRoll or 0) >= (_G.Settings.DeathKingRollRetry or 2) then
            self.LastBoneRoll = tick()
            pcall(function() CommF_:InvokeServer("Bones","Buy",1,1) end)
            InventoryCache.At = 0
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

    -- Permanent milestone first: once Lv.200 Saber is eligible it must preempt level farm.
    if self:CheckSaber() then return true end

    -- Goal-based material and hard style prerequisites.
    if MaterialPrepController and MaterialPrepController:TryRunCurrentSea() then return true end
    if FightingStyleUnlockController and FightingStyleUnlockController:TryRun() then return true end

    -- Kaitun-only progression.
    if self:CheckRaceV2() then return true end
    local meleeBusy = false
    pcall(function() meleeBusy = FightingStyleController:Tick() == true end)
    if not meleeBusy then pcall(function() SwordProgressionController:Tick() end) end

    -- Useful kaitun item queue. Every routine is bounded; missing spawns/keys return
    -- control to level farming instead of camping indefinitely.
    if self:CheckPoleV1() then return true end
    if self:CheckKabucha() then return true end
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
    if _G.State and _G.State.ActionOwner == "Raid" then return false end
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
                local price = tonumber(row.Price or row.price or prices[tostring(name)])
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

function RaidController:ProtectBackpackFruits()
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not backpack then return end
    for _, tool in ipairs(backpack:GetChildren()) do
        if LooksLikeFruitTool(tool) then
            local fruitName = FruitOriginalName(tool)
            if fruitName then
                pcall(function() CommF_:InvokeServer("StoreFruit", fruitName, tool) end)
                task.wait(0.08)
            end
        end
    end
end

function RaidController:AcquireChip(raidName)
    if FindSpecialMicrochip() then return true end
    -- Never let a random/high-value physical fruit sitting in Backpack become
    -- an accidental chip payment. Store first, then explicitly load only a
    -- low-value fruit if the normal $100k chip route is on cooldown.
    self:ProtectBackpackFruits()
    task.wait(0.2)
    local function selectChip()
        local ok, result = pcall(function() return CommF_:InvokeServer("RaidsNpc", "Select", raidName) end)
        self.LastChipResult = ok and result or tostring(result)
        task.wait(0.8)
        return FindSpecialMicrochip() ~= nil
    end
    if selectChip() then return true end
    if self:LoadCheapestStoredFruit() and selectChip() then return true end
    return false
end

function RaidController:FindStartDetector()
    local map = workspace:FindFirstChild("Map")
    if not map then return nil end
    local sea = GetSea()
    local preferred = sea == 2 and map:FindFirstChild("CircleIsland") or (sea == 3 and map:FindFirstChild("Boat Castle"))
    local summon = preferred and preferred:FindFirstChild("RaidSummon2", true)
    local detector = summon and summon:FindFirstChildWhichIsA("ClickDetector", true)
    if detector then return detector end
    for _, node in ipairs(map:GetDescendants()) do
        if node.Name == "RaidSummon2" then
            local cd = node:FindFirstChildWhichIsA("ClickDetector", true)
            if cd then return cd end
        end
    end
    return nil
end

function RaidController:StartRaid()
    if self:IsRaidActive() then return true end
    if not FindSpecialMicrochip() then return false end
    local detector = self:FindStartDetector()
    if not detector or type(fireclickdetector) ~= "function" then
        self.LastChipResult = "NO-CLICKDETECTOR"
        return false
    end
    if not pcall(function() fireclickdetector(detector) end) then return false end
    local deadline = tick() + 12
    while SessionAlive() and IsAlive() and tick() < deadline do
        if self:IsRaidActive() then return true end
        task.wait(0.2)
    end
    return self:IsRaidActive()
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
    local primary = ClusterFarmController:SelectPrimary() or regular
    local hover = ClusterFarmController:GetHoverCFrame(_G.Settings.RaidHoverHeight or 22)
    if hover then
        TravelManager:Request(hover, "Raid", {arrivalThreshold=_G.Settings.FarmArrivalThreshold,
            combatHover=true, speed=_G.Settings.RaidTravelSpeed or 300, persistent=true})
    end
    if primary and _G.State:IsTargetValid(primary) then
        _G.State.CurrentTarget = primary
        PrepareCombatTarget(primary)
        if TravelManager:IsAtCombatAnchor() then EquipCombatTool(); Attack(primary, primary.Name) end
    end
    _G.BobonStatus = ("Raid: Island %d • %d/%d Frag"):format(island.Index, Fragments(),
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
                if not self:StartRaid() then
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
        tonumber(_G.Settings.ClusterAuthorityFieldRadius) or 180)

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
        local boxCenter = Vector3.new(
            (minX + maxX) * 0.5,
            (minY + maxY) * 0.5,
            (minZ + maxZ) * 0.5
        )
        local centers = {centroid, boxCenter}
        if base and typeof(base) == "CFrame" then centers[#centers + 1] = base.Position end
        for _, p in ipairs(positions) do centers[#centers + 1] = p end

        local bestCenter, bestMax, bestAvg
        for _, center in ipairs(centers) do
            local maxDist, total = 0, 0
            for _, p in ipairs(positions) do
                local d = (p - center).Magnitude
                maxDist = math.max(maxDist, d)
                total = total + d
            end
            local avg = total / #positions
            if not bestCenter or maxDist < bestMax - 0.01
                or (math.abs(maxDist - bestMax) <= 0.01 and avg < bestAvg) then
                bestCenter, bestMax, bestAvg = center, maxDist, avg
            end
        end
        if bestCenter then
            DLog("FARM", ("Authority minimax anchor -> %s (%d mobs, max %.1f)")
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

            -- Live Factory is a time-limited Sea-2 event. It is the one core event
            -- allowed to preempt an ordinary level quest; another claimed action
            -- still wins because TryRun requires State:CanAct().
            local okFactory, factoryResult = pcall(function() return FactoryController:TryRun() end)
            if not okFactory then
                warn("[BobonHub] Module Error: FactoryController: " .. tostring(factoryResult))
            elseif factoryResult then
                return
            end


            -- v21.24.2 PRIORITY: run the EXISTING progression controller before level farm.
            -- No new scheduler/function is introduced: this is intentionally a one-line
            -- reordering on top of the known-booting v21.23 architecture.
            if ItemProgression:RunChecks(true, true) then
                return
            end

            -- LEVEL FARM FALLBACK: runs only if no progression action claimed this tick.
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
                -- First revisit older seas until all retained useful items are complete.
                local okCompletion, completionResult = pcall(function()
                    return CompletionSeaController:TryTravel()
                end)
                if not okCompletion then
                    warn("[BobonHub] Module Error: CompletionSeaController: " .. tostring(completionResult))
                elseif completionResult then
                    return
                end
                -- Continue end-game progression instead of becoming permanently Idle.
                local okEnd, endResult = pcall(function()
                    return ItemProgression:RunChecks(true, true)
                end)
                if okEnd and endResult then return end
                local okRaidEnd, raidEnd = pcall(function() return RaidController:TryStart() end)
                if not okRaidEnd then
                    warn("[BobonHub] Module Error: RaidController: " .. tostring(raidEnd))
                elseif raidEnd then
                    return
                end
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

                    local okRaid, raidResult = pcall(function() return RaidController:TryStart() end)
                    if not okRaid then
                        warn("[BobonHub] Module Error: RaidController: " .. tostring(raidResult))
                    elseif raidResult then
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
            local questAnchor = ResolveQuestClusterAnchor(q, questMobName) or q.MC
            ClusterFarmController:Activate("QUEST", {questMobName}, questAnchor, "Farm")
            ClusterFarmController:Tick()

            local anchorHeight = _G.Settings.FarmHeight or 22
            local hoverCF = ClusterFarmController:GetHoverCFrame(anchorHeight)
            if ClusterFarmController:IsShadowCombatActive() then
                hoverCF = ClusterFarmController:GetShadowCoverageHoverCFrame(anchorHeight) or hoverCF
            end

            -- v21.6 VIDEO SWEEP FARM: acquisition and damage run in the same main
            -- tick. Travel keeps approaching the exact active-quest mob while
            -- the attack phase below starts as soon as that real root is inside
            -- FastAttackRange. Heartbeat still stacks it after ownership moves.
            local acquireTarget = ClusterFarmController:GetAcquireTarget()
            local acquireRoot = acquireTarget
                and acquireTarget:FindFirstChild("HumanoidRootPart")
            local acquiring = acquireRoot ~= nil
                and _G.State:IsTargetValid(acquireTarget)
                and IsEnemyNamed(acquireTarget, questMobName)
            if acquiring then
                _G.State.FState = "GATHER_AND_ATTACK"
                local stacked = tonumber(_G.State.ClusterAcquireCompleted) or 0
                local total = tonumber(_G.BobonDiagnostics.BringCandidates) or 0
                _G.BobonStatus = ("Farm: ONE-PILE gather + attack %s (%d/%d)")
                    :format(tostring(questMobName), stacked, total)
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
                _G.State.FState = "GATHER_AND_ATTACK"
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
                -- v21.13 REMOTE-MAGNET FIRST: stay on the shared hover anchor.
                -- GetAcquireTarget is now the ONLY physical-acquisition fallback, and
                -- it activates only after the remote-pull grace with zero verified mobs.
                -- This removes the second independent path that used to chase a spawn
                -- even while the remote magnet was still trying to collapse the batch.
                if hoverCF and _G.State:CanRequestTravel() then
                    TravelManager:Request(hoverCF, "Farm", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        fallback = q.MC,
                        combatHover = true,
                        persistent = true,
                    })
                end
            end

            -- ATTACK: verified cluster roots are stacked inside one XZ pocket.
            -- During acquisition the real quest root becomes preferred as soon
            -- as it is inside remote range; verified stacked roots in the same
            -- range are still fanned out by CombatController:CollectTargets().
            hrp = HRP()
            local hybridAcquireAttack = false
            if acquiring and acquireRoot and acquireRoot.Parent and hrp then
                local okAcquirePos, acquirePos = pcall(function()
                    return acquireRoot.Position
                end)
                hybridAcquireAttack = okAcquirePos and IsValidPos(acquirePos)
                    and (hrp.Position - acquirePos).Magnitude
                        <= (_G.Settings.FastAttackRange or _G.Settings.AttackRange or 100)
            end
            target = hybridAcquireAttack and acquireTarget or _G.State.FarmTarget
            targetRoot = target and target:FindFirstChild("HumanoidRootPart")
            local hybridClusterAttack = false
            if acquiring and not hybridAcquireAttack and targetRoot and targetRoot.Parent
                and hrp and ClusterFarmController:IsVerified(target) then
                local okClusterPos, clusterPos = pcall(function()
                    return targetRoot.Position
                end)
                hybridClusterAttack = okClusterPos and IsValidPos(clusterPos)
                    and (hrp.Position - clusterPos).Magnitude
                        <= (_G.Settings.FastAttackRange or _G.Settings.AttackRange or 100)
            end
            if target and targetRoot and hrp and _G.State:IsTargetValid(target) then
                PrepareCombatTarget(target)

                -- v21.6 GLOBAL no-damage recovery: applies to every stable quest
                -- mob. A locally stacked-looking root is not allowed to trap the
                -- farm forever. A live acquisition root uses CombatController's
                -- own per-target HP proof because its position is still changing.
                if not hybridAcquireAttack and not authorityProbeTarget
                    and not ClusterFarmController:IsShadowCombatActive()
                    and ClusterFarmController:GetVerifiedCount() <= 1
                    and ClusterFarmController:GetProbeCount() == 0
                    and TravelManager:IsAtCombatAnchor()
                    and ObserveFarmDamage(target) then
                    VerifiedGatherRoots[targetRoot] = nil
                    DamageProvenGatherRoots[targetRoot] = nil
                    GatherAuthorityClass[targetRoot] = nil
                    if _G.State.ClusterPrimary == target then _G.State.ClusterPrimary = nil end
                    -- A full three-second batch stall is stronger evidence than
                    -- a single missed packet. Rotate the actual backend instead
                    -- of aborting and immediately retrying the same dead route.
                    local failingBackend = CombatController.PendingBackend
                        or CombatController.VerifiedBackend
                    if failingBackend then
                        CombatController:FailBackend(failingBackend,
                            "GLOBAL-MOB-NO-DAMAGE")
                    end
                    if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                        TravelManager:Stop("GlobalMobNoDamageReacquire")
                    end
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
                if flatDist <= _G.Settings.AttackRange and farmHolds
                    and (shadowClusterAttack or authorityProbeTarget or hybridAcquireAttack
                        or hybridClusterAttack or TravelManager:IsAtCombatAnchor()) then
                    _G.State.FState = shadowClusterAttack and "SHADOW_CLUSTER_ATTACK"
                        or (authorityProbeTarget and "AUTHORITY_PROBE_ATTACK"
                            or ((hybridAcquireAttack or hybridClusterAttack)
                                and "ATTACK_WHILE_GATHERING" or "ATTACK_CLUSTER"))
                    EquipCombatTool()
                    -- v21.23: once a real HP hit has started the one-shot movement
                    -- persistence trial, stop spamming that unstacked mob for a moment.
                    -- This keeps the NPC alive long enough to join the pile instead of
                    -- killing it at its original spawn before the gather proof finishes.
                    local moveTrialInFlight = targetRoot and GatherMoveTrial[targetRoot] ~= nil
                    if not moveTrialInFlight then
                        Attack(target, questMobName)
                    else
                        _G.BobonDiagnostics.Packet = "WAIT-PILE-PROOF"
                    end
                    if os.time() - lastAttackLog >= 5 then
                        lastAttackLog = os.time()
                        DLog("ATTACK", ((hybridAcquireAttack or hybridClusterAttack)
                            and "Gather target: " or "Cluster target: ") .. target.Name)
                    end
                end
            else
                ResetFarmDamageWatch(nil)
                if not acquiring then
                    _G.BobonStatus = "Farm: Waiting for " .. questMobName .. " spawn"
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


print("[BobonHub v21.24.2] Full Script Loaded Successfully!")
print("[BobonHub v21.24.2] Architecture: Persistent Travel | ActionToken | Single Owner")
print("[BobonHub v21.24.2] Core: TravelManager | StateManager | RecoveryManager")
print("[BobonHub v21.24.2] Modules: QuestFarm | One-Pile Real-Ownership Cluster | Teddy Air Combat | Factory | Material Prep | Full Melee | CDK/Skull | Fire HUD")
print("[BobonHub v21.24.2] Progression: Farm | Sea2/3 | Factory | Pole/Kabucha/Rengoku/Dragon Trident/Gravity Blade/Midnight/Acidum | TTK/CDK Trials | Full Melee Materials | Core Abilities | Skull Guitar Puzzle | Dough King")
print("[BobonHub v21.24.2] Data: Sea1/2/3 QDB | Submerged | Boss/item catalog")
print("[BobonHub v21.24.2] Sea: " .. _G.State.Sea .. " | Level: " .. Level())
