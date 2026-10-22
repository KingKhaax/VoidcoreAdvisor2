-- Compares two generated SeasonData files and lists what changed between them: raid
-- bosses and dungeons added or removed, and items that appeared or disappeared from a
-- boss pool. Use it after regenerating the data for a new patch.
--
--   lua tools/compare_seasondata.lua old/SeasonData.lua new/SeasonData.lua
local oldPath, newPath = arg[1], arg[2]
if not oldPath or not newPath then
    print("usage: lua tools/compare_seasondata.lua <old SeasonData.lua> <new SeasonData.lua>")
    os.exit(1)
end

local function load(path)
    local chunk, err = loadfile(path)
    if not chunk then
        print("cannot read " .. path .. ": " .. tostring(err))
        os.exit(1)
    end
    local VCA = {}
    chunk("VoidcoreAdvisor", VCA)
    return VCA.SeasonData or {}
end

local old, new = load(oldPath), load(newPath)
local changes = 0

local function say(text)
    print(text)
    changes = changes + 1
end

local function keys(t)
    local list = {}
    for k in pairs(t or {}) do
        list[#list + 1] = k
    end
    table.sort(list, function(a, b)
        return tostring(a) < tostring(b)
    end)
    return list
end

local function toSet(list)
    local set = {}
    for _, v in ipairs(list or {}) do
        set[v] = true
    end
    return set
end

local function diffLists(label, a, b)
    local sa, sb = toSet(a), toSet(b)
    for _, id in ipairs(b or {}) do
        if not sa[id] then
            say(string.format("  + %s: item %d added", label, id))
        end
    end
    for _, id in ipairs(a or {}) do
        if not sb[id] then
            say(string.format("  - %s: item %d removed", label, id))
        end
    end
end

-- Raid bosses
for _, id in ipairs(keys(new.raids)) do
    if not (old.raids and old.raids[id]) then
        say("+ raid boss " .. tostring(id) .. " added")
    end
end
for _, id in ipairs(keys(old.raids)) do
    local o, n = old.raids[id], new.raids and new.raids[id]
    if not n then
        say("- raid boss " .. tostring(id) .. " removed")
    else
        for _, diff in ipairs({14, 15, 16}) do
            diffLists(string.format("boss %s difficulty %d", tostring(id), diff), o[diff], n[diff])
        end
    end
end

-- Dungeons
for _, id in ipairs(keys(new.dungeons)) do
    if not (old.dungeons and old.dungeons[id]) then
        say("+ dungeon " .. tostring(id) .. " added")
    end
end
for _, id in ipairs(keys(old.dungeons)) do
    local o, n = old.dungeons[id], new.dungeons and new.dungeons[id]
    if not n then
        say("- dungeon " .. tostring(id) .. " removed")
    else
        local specs = {}
        for specID in pairs(o.bySpec or {}) do
            specs[specID] = true
        end
        for specID in pairs(n.bySpec or {}) do
            specs[specID] = true
        end
        for _, specID in ipairs(keys(specs)) do
            diffLists(string.format("dungeon %s spec %s", tostring(id), tostring(specID)),
                o.bySpec and o.bySpec[specID], n.bySpec and n.bySpec[specID])
        end
    end
end

if changes == 0 then
    print("No differences.")
else
    print(string.format("%d differences. Review them before releasing: a changed pool resets nothing by itself, " ..
        "but the season fingerprint wipes obtained data when the raid or dungeon list changes.", changes))
end
