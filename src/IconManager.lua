-- IconManager.lua
local IconManager = {}

local iconLibraries = {}

local function loadLibrary(name, path)
    local success, libraryModule = pcall(require, path)
    if success and type(libraryModule) == "table" and libraryModule.Spritesheets and libraryModule.Icons then
        iconLibraries[name] = libraryModule
        -- Pre-process icons to include the full spritesheet path
        for iconKey, iconData in pairs(libraryModule.Icons) do
            local spritesheetNum = iconData.Image
            if libraryModule.Spritesheets[tostring(spritesheetNum)] then
                iconData.SpritesheetID = libraryModule.Spritesheets[tostring(spritesheetNum)]
            else
                warn("IconManager: Spritesheet number " .. tostring(spritesheetNum) .. " not found for icon " .. iconKey .. " in library " .. name)
            end
        end
    else
        warn("IconManager: Failed to load icon library '" .. name .. "' from path: " .. path:GetFullName())
        iconLibraries[name] = {Icons = {}, Spritesheets = {}} -- Provide an empty table to prevent errors
    end
end

-- Assuming script.Parent.Parent is the root of the UB-V5-QOL library structure
-- Adjust the path if src is not directly under the main library script's parent
local currentScript = script
local libraryRoot = currentScript.Parent.Parent

loadLibrary("Lucide", libraryRoot.Icons.Lucide)
loadLibrary("Craft", libraryRoot.Icons.Craft)


function IconManager.GetIcon(libraryName, iconName)
    local library = iconLibraries[libraryName]
    if not library then
        warn("IconManager: Library '" .. libraryName .. "' not found.")
        return nil
    end

    local iconData = library.Icons[iconName]
    if not iconData then
        warn("IconManager: Icon '" .. iconName .. "' not found in library '" .. libraryName .. "'.")
        -- Fallback to a default/missing icon if needed, or just return nil
        return nil
    end

    -- Return a copy of the icon data to prevent modification of the original
    local dataCopy = {}
    for k, v in pairs(iconData) do
        dataCopy[k] = v
    end

    -- Ensure the full SpritesheetID is returned
    if not dataCopy.SpritesheetID and dataCopy.Image then
         local spritesheetNum = dataCopy.Image
         if library.Spritesheets[tostring(spritesheetNum)] then
            dataCopy.SpritesheetID = library.Spritesheets[tostring(spritesheetNum)]
        end
    end

    return dataCopy
end

-- Helper function to apply icon data to an ImageLabel or ImageButton
function IconManager.ApplyIcon(guiObject, libraryName, iconName)
    if not (guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton")) then
        warn("IconManager.ApplyIcon: guiObject must be an ImageLabel or ImageButton.")
        return
    end

    local iconData = IconManager.GetIcon(libraryName, iconName)
    if iconData and iconData.SpritesheetID then
        guiObject.Image = iconData.SpritesheetID
        if iconData.ImageRectOffset then
            guiObject.ImageRectOffset = iconData.ImageRectOffset
        end
        if iconData.ImageRectSize then
            guiObject.ImageRectSize = iconData.ImageRectSize
        end
    else
        -- Fallback: try to load directly if it's an rbxassetid (e.g. for single images)
        if type(iconName) == "string" and iconName:match("^rbxassetid://") then
            guiObject.Image = iconName
            guiObject.ImageRectOffset = Vector2.new(0,0) -- Reset offset/size if it was a spritesheet icon before
            guiObject.ImageRectSize = Vector2.new(0,0)
        else
            warn("IconManager.ApplyIcon: Could not apply icon '" .. tostring(iconName) .. "' from library '" .. tostring(libraryName) .. "'.")
            guiObject.Image = "" -- Clear image if icon not found
        end
    end
end


return IconManager
