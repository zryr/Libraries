import re

with open('UB-V5-QOL.lua', 'r') as f:
    content = f.read()

# Replace the embedded CoreSystems mock logic and the old require stub with the actual HTTP loadstring
stub_search = """local CoreSystems = require("UBHubLib_Icons_Fonts_Themes_Config.lua")
-- Provided a stub, we'll embed the CoreSystems module directly.

-- [[ CORE SYSTEMS (Theming, Icons, Fonts, ConfigManager) ]]
local Themes = {"""

stub_replace = """local success, CoreSystems = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/zryr/Libraries/refs/heads/Jules/UBHubLib_Icons_Fonts_Themes_Config.lua"))()
end)

if not success or not CoreSystems then
    warn("Failed to load CoreSystems from GitHub, falling back to local/cached version or error.")
end

local Themes = CoreSystems.Themes or {"""
content = content.replace(stub_search, stub_replace)

# Now, we also need to change how the functions are accessed since they are now on the CoreSystems object, not local variables.
# Actually, the entire block of "local function GetColor" etc. was embedded. Let's completely replace the embedded block with a simple assignment.

embedded_block_search = r'-- \[\[ CORE SYSTEMS \(Theming, Icons, Fonts, ConfigManager\) \]\][\s\S]*?-- \[\[ END CORE SYSTEMS \]\]'
embedded_block_replace = """local success, CoreSystems = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/zryr/Libraries/refs/heads/Jules/UBHubLib_Icons_Fonts_Themes_Config.lua"))()
end)

if not success or not CoreSystems then
    warn("Failed to load CoreSystems. Library cannot function properly.")
    return {}
end

local Themes = CoreSystems.Themes
local CurrentTheme = CoreSystems.CurrentTheme

local GetColor = CoreSystems.GetColor
local ApplyGradient = CoreSystems.ApplyGradient
local ApplyColor = CoreSystems.ApplyColor

local FontManager = CoreSystems.FontManager
local Icons = CoreSystems.Icons
local GetIcon = CoreSystems.GetIcon

local ConfigManager = CoreSystems.ConfigManager"""

content = re.sub(r'-- \[\[ CORE SYSTEMS \(Theming, Icons, Fonts, ConfigManager\) \]\][\s\S]*?-- \[\[ END CORE SYSTEMS \]\]', embedded_block_replace, content)

# Clean up the dangling stub at the top if it still exists
content = content.replace('local CoreSystems = require("UBHubLib_Icons_Fonts_Themes_Config.lua")\n-- Provided a stub, we\'ll embed the CoreSystems module directly.', '')

with open('UB-V5-QOL.lua', 'w') as f:
    f.write(content)

print("Patching CoreSystems require complete")
