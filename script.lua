getgenv().Key = "nophonehome"
getgenv().NewUI = true
getgenv().NoPhoneHome = { blockBanana = true, blockDiscord = true }

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local settings = getgenv().NoPhoneHome or {}
if settings.blockBanana == nil then settings.blockBanana = true end
if settings.blockDiscord == nil then settings.blockDiscord = true end
getgenv().NoPhoneHome = settings

local function isBlocked(url)
    local u = tostring(url or ""):lower()
    if settings.blockBanana and u:find("banana-hub.xyz", 1, true) then return true end
    if settings.blockDiscord and (u:find("discord.com", 1, true) or u:find("discordapp.com", 1, true)) then return true end
    return false
end

local function fakeResponse()
    return {
        StatusCode = 200,
        Headers = { ["content-type"] = "application/json" },
        Body = '{"success":true,"ok":true,"data":{}}',
        Success = true,
    }
end

local function extractUrl(args)
    for _, a in ipairs(args) do
        if type(a) == "table" and a.Url then return a.Url end
    end
    return args[1]
end

local function wrap(fn)
    return function(...)
        local args = { ... }
        if isBlocked(extractUrl(args)) then return fakeResponse() end
        return fn(...)
    end
end

local hooks = {
    function() return request end,
    function() return http_request end,
    function() return http_request2 end,
    function() return syn and syn.request end,
    function() return fluxus and fluxus.request end,
    function() return http and http.request end,
    function() return game and game.HttpGet end,
    function() return game and game.HttpGetAsync end,
    function() return game and game.HttpPost end,
    function() return game and game.HttpPostAsync end,
    function() return game and game:GetService("HttpService").RequestAsync end,
}

for _, get in ipairs(hooks) do
    local ok, fn = pcall(get)
    if ok and type(fn) == "function" then
        local wrapped = wrap(fn)
        local hok = pcall(hookfunction, fn, wrapped)
        if not hok then
            pcall(function()
                if fn == request then request = wrapped end
                if fn == http_request then http_request = wrapped end
                if syn and fn == syn.request then syn.request = wrapped end
                if fluxus and fn == fluxus.request then fluxus.request = wrapped end
                if http and fn == http.request then http.request = wrapped end
                if fn == game.HttpGet then game.HttpGet = wrapped end
                if fn == game.HttpGetAsync then game.HttpGetAsync = wrapped end
                if fn == game.HttpPost then game.HttpPost = wrapped end
                if fn == game.HttpPostAsync then game.HttpPostAsync = wrapped end
                if fn == game:GetService("HttpService").RequestAsync then
                    game:GetService("HttpService").RequestAsync = wrapped
                end
            end)
        end
    end
end

print("[Kaitun Safe Loader] blocking: banana-hub.xyz, discord.com")

local ok, script = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua")
if ok and script and #script > 1000 then
    loadstring(script)()
else
    warn("[Kaitun Safe Loader] failed to fetch BananaHub.lua:", ok, script)
end
