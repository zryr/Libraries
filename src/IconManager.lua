-- IconManager.lua
return function(dependencies)
    local IconManager = {}
    local iconLibraries = {}

    local LucideData = dependencies.Lucide
    local CraftData = dependencies.Craft

    local function loadLibraryFromData(name, libraryData)
        if libraryData and type(libraryData) == "table" and libraryData.Spritesheets and libraryData.Icons then
            iconLibraries[name] = libraryData
            for iconKey, iconData in pairs(libraryData.Icons) do
                local spritesheetNum = iconData.Image
                if libraryData.Spritesheets[tostring(spritesheetNum)] then
                    iconData.SpritesheetID = libraryData.Spritesheets[tostring(spritesheetNum)]
                else
                    warn("IconManager: Spritesheet number " .. tostring(spritesheetNum) .. " not found for icon " .. iconKey .. " in library " .. name)
                end
            end
        else
            warn("IconManager: Failed to process icon library data for '" .. name .. "'.")
            iconLibraries[name] = {Icons = {}, Spritesheets = {}}
        end
    end

    if LucideData then
        loadLibraryFromData("Lucide", LucideData)
    else
        warn("IconManager: Lucide icon data not provided.")
        iconLibraries["Lucide"] = {Icons={}, Spritesheets={}}
    end

    if CraftData then
        loadLibraryFromData("Craft", CraftData)
    else
        warn("IconManager: Craft icon data not provided.")
        iconLibraries["Craft"] = {Icons={}, Spritesheets={}}
    end

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
end
