-- Builds Core/SeasonData.lua from the file VoidcoreAdvisorGen leaves in your saved variables,
-- so a new patch does not need any copy and paste:
--
--   1. In game: enable VoidcoreAdvisorGen, open the Adventure Guide, type /vcagen run,
--      wait for "Generation complete!" and type /reload (or log out).
--   2. Run from the addon folder:
--        lua tools/build_seasondata.lua "<WoW>/_retail_/WTF/Account/<name>/SavedVariables/VoidcoreAdvisorGen.lua"
--      It writes Core/SeasonData.lua (the old file is kept as Core/SeasonData.lua.bak).
--   3. Compare what changed before you release:
--        lua tools/compare_seasondata.lua Core/SeasonData.lua.bak Core/SeasonData.lua
local source = arg[1]
local target = arg[2] or "Core/SeasonData.lua"
if not source then
    print('usage: lua tools/build_seasondata.lua "<path to VoidcoreAdvisorGen.lua>" [output file]')
    os.exit(1)
end

-- The saved variables file defines VoidcoreAdvisorGenDB.
local env = {}
local chunk, err = loadfile(source, "t", env)
if not chunk then
    print("cannot read " .. source .. ": " .. tostring(err))
    os.exit(1)
end
chunk()
local db = env.VoidcoreAdvisorGenDB
local data = db and (db.seasonData or db)
if type(data) ~= "table" or type(data.raids) ~= "table" or type(data.dungeons) ~= "table" then
    print("VoidcoreAdvisorGenDB.seasonData was not found or is incomplete. Run /vcagen run in game first.")
    os.exit(1)
end

-- Serialises a table with sorted keys, so the same data always gives the same file.
local function sortedKeys(t)
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end
    table.sort(keys, function(a, b)
        if type(a) == type(b) then
            return a < b
        end
        return type(a) == "number"
    end)
    return keys
end

local function isArray(t)
    local n = 0
    for _ in pairs(t) do
        n = n + 1
    end
    return n == #t
end

local function serialize(value, indent)
    local t = type(value)
    if t == "number" or t == "boolean" then
        return tostring(value)
    elseif t == "string" then
        return string.format("%q", value):gsub("\\n", "\n")
    elseif t == "table" then
        if next(value) == nil then
            return "{}"
        end
        local pad = indent .. "    "
        if isArray(value) then
            local allNumbers = true
            for _, v in ipairs(value) do
                if type(v) ~= "number" then
                    allNumbers = false
                end
            end
            if allNumbers then
                local parts = {}
                for _, v in ipairs(value) do
                    parts[#parts + 1] = tostring(v)
                end
                return "{" .. table.concat(parts, ", ") .. "}"
            end
        end
        local lines = {}
        for _, k in ipairs(sortedKeys(value)) do
            local key = type(k) == "number" and ("[" .. k .. "]") or ("[" .. string.format("%q", k) .. "]")
            lines[#lines + 1] = pad .. key .. " = " .. serialize(value[k], pad) .. ","
        end
        return "{\n" .. table.concat(lines, "\n") .. "\n" .. indent .. "}"
    end
    error("cannot write a " .. t)
end

-- Keep the header and footer of the current file; only the data table is replaced.
local f = io.open(target, "rb")
if not f then
    print("cannot open " .. target)
    os.exit(1)
end
local old = f:read("*a")
f:close()
local startAt = old:find("VCA.SeasonData = {", 1, true)
local footerAt = old:find("\n-- Compatibility:", 1, true)
if not startAt or not footerAt then
    print("the current " .. target .. " does not have the expected layout")
    os.exit(1)
end

local backup = io.open(target .. ".bak", "wb")
backup:write(old)
backup:close()

local out = old:sub(1, startAt - 1) .. "VCA.SeasonData = " .. serialize(data, "") .. "\n" .. old:sub(footerAt)
local w = io.open(target, "wb")
w:write(out)
w:close()
print("Wrote " .. target .. " (previous file saved as " .. target .. ".bak).")
print("Next: lua tools/compare_seasondata.lua " .. target .. ".bak " .. target)
