-- IconManager Module
local IconManager = {}
IconManager.IconSets = {}

--[[
    Loads an icon set into the manager.
    libraryName: (string) The name for this icon library (e.g., "lucide", "craft").
    iconSetData: (table) The module or data structure containing functions to get icon assets.
                 Expected to have a GetAsset(iconName, iconSize) function.
--]]
function IconManager:LoadIconSet(libraryName, iconSetData)
    if not libraryName or not iconSetData then
        warn("IconManager:LoadIconSet - libraryName and iconSetData are required.")
        return
    end

    if not iconSetData.GetAsset or typeof(iconSetData.GetAsset) ~= "function" then
        warn("IconManager:LoadIconSet - iconSetData for '" .. libraryName .. "' does not have a GetAsset function.")
        return
    end

    self.IconSets[libraryName] = iconSetData
    -- print("IconManager: Loaded icon set '" .. libraryName .. "'")
end

--[[
    Retrieves icon asset details.
    libraryName: (string) The name of the icon library.
    iconName: (string) The name of the icon.
    iconSize: (number, optional) The desired size of the icon (e.g., 24, 48). Default might be handled by the specific icon set.
    Returns: (table { Url, ImageRectSize, ImageRectOffset, Id } or nil)
--]]
function IconManager:GetIcon(libraryName, iconName, iconSize)
    local iconSet = self.IconSets[libraryName]
    if not iconSet then
        warn("IconManager:GetIcon - Icon library '" .. libraryName .. "' not loaded.")
        return nil
    end

    local success, assetData = pcall(function()
        return iconSet:GetAsset(iconName, iconSize)
    end)

    if not success or not assetData then
        -- Don't warn for every failed icon lookup, as it might be intentional (e.g. optional icons)
        -- print("IconManager:GetIcon - Failed to get icon '" .. iconName .. "' from library '" .. libraryName .. "'. Error: " .. tostring(assetData))
        return nil
    end

    -- Ensure the returned data has the expected fields (Url might be Id for some systems, adapt as needed)
    -- For Lucide, GetAsset returns: {IconName, Id, Url, ImageRectSize, ImageRectOffset}
    if not assetData.Url or not assetData.ImageRectSize or not assetData.ImageRectOffset then
         warn("IconManager:GetIcon - Icon '" .. iconName .. "' from '" .. libraryName .. "' returned incomplete data.")
         return nil
    end

    return {
        Url = assetData.Url,
        ImageRectSize = assetData.ImageRectSize,
        ImageRectOffset = assetData.ImageRectOffset,
        Id = assetData.Id -- Included for completeness
    }
end

return IconManager
