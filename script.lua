getgenv().Configs = {
    Team = "Pirates",

    ["Auto Saber"] = true,
    ["Auto Spawn Dough King"] = true,
    ["Auto Spawn rip_indra"] = true,

    ["Cursed Dual Katana"] = true,
    ["Skull Guitar"] = true,
    ["Auto Race V2"] = true,

    ["Get Fruits"] = true,
    ["Rainbow Haki"] = true,

    ["Snipe Fruit"] = {
        "Kitsune-Kitsune",
        "Dragon-Dragon",
        "Yeti-Yeti",
        "Gas-Gas",
    },

    ["Switch Melee"] = true,
    ["Lock Fragment"] = 0,
    ["Hop Player Near"] = false,

    ["Farm Core"] = {
        ["Reference Mode"] = true,

        ["Bring Mobs"] = true,
        ["Bring Is Optimization"] = true,
        ["Safe Bring"] = true,

        ["Farm Height"] = 22,

        ["Atomic Fruit Pickup"] = true,
        ["Atomic Berry Pickup"] = false,

        ["Elite Observer"] = true,
        ["Castle Raid Event"] = true,
        ["Early Dough King"] = true,

        ["Smart Stuck Hop"] = false,

        ["Ignore Raw Damage"] = true,
        ["Low Health Safety"] = true,
        ["Dodge While Attacking"] = true,
        ["Side Step Dodge"] = true,
        ["Raw Damage Dodge"] = false,
    },

    ["FPS Boost"] = {
        Enable = true,
        ["FPS Cap"] = 30,
        ["Hide Game UI"] = false,
        ["Disable 3D Render"] = false,
    },

    ["Farm Boss Drops"] = {
        Enable = true,
        ["When x2 Exp Expired"] = true,
    },

    ["Farm Mastery"] = {
        Enable = true,

        ["Farm Mastery Weapons"] = {
            "Melee",
            "Sword",
            "Gun",
        },

        ["Guns To Farm"] = {
            "Kabucha",
            "Acidum Rifle",
            "Skull Guitar",
        },

        ["Swords To Farm"] = {
            "Saber",
            "Rengoku",
            "Midnight Blade",
            "Yama",
            "Tushita",
            "Cursed Dual Katana",
        },

        ["Mastery Health (%)"] = 25,

        ["Use Skills"] = true,
        ["Skill Range"] = 60,
        ["Skill Cooldown"] = 1,

        ["Target Aim"] = true,
        ["Mouse Aim"] = true,
    },

    Hop = {
        Enable = true,

        ["Hop Required Progression"] = true,
        ["Find Fruit"] = true,
        ["Hop Elite"] = true,

        ["Hop Find Darkbeard"] = true,
        ["Hop Find Mirage"] = true,
        ["Hop Find Mirror Fractal"] = true,
        ["Hop Find Soul Reaper"] = true,
        ["Hop Find Tushita"] = true,
        ["Hop Find Valkyrie Helm"] = true,
    },

    ["Shutdown"] = false,
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/akabobon/kaitunbobonbloxkid/refs/heads/main/script.lua"))()
