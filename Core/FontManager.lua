-- FontManager Module
local FontManager = {}
FontManager.RegisteredFonts = {}

--[[
    Registers a font.
    fontName: (string) The name to refer to this font by.
    fontEnum: (Enum.Font) The Roblox Font enum, if it's a standard font.
    fontAssetId: (string or number) The asset ID for custom fonts (e.g., "rbxassetid://12345")
--]]
function FontManager:RegisterFont(fontName, fontEnum, fontAssetId)
    if not fontName then
        warn("FontManager:RegisterFont - fontName is required.")
        return
    end
    if fontEnum and typeof(fontEnum) ~= "EnumItem" then
        warn("FontManager:RegisterFont - fontEnum for '" .. fontName .. "' is not a valid Enum.Font.")
        fontEnum = nil -- Ignore if invalid
    end
    if fontAssetId then
        if typeof(fontAssetId) == "number" then
            fontAssetId = "rbxassetid://" .. tostring(fontAssetId)
        elseif typeof(fontAssetId) ~= "string" or not string.match(fontAssetId, "^rbxassetid://") then
            warn("FontManager:RegisterFont - fontAssetId for '" .. fontName .. "' is not a valid asset ID string.")
            fontAssetId = nil -- Ignore if invalid
        end
    end

    if not fontEnum and not fontAssetId then
        warn("FontManager:RegisterFont - Must provide either fontEnum or fontAssetId for '" .. fontName .. "'.")
        return
    end

    self.RegisteredFonts[fontName] = {
        Enum = fontEnum,
        AssetId = fontAssetId
    }
    -- print("FontManager: Registered font '" .. fontName .. "'")
end

--[[
    Retrieves a font.
    fontName: (string) The name of the font to retrieve.
    Returns: (Font Enum or Font object for custom fonts)
--]]
function FontManager:GetFont(fontName)
    local fontData = self.RegisteredFonts[fontName]
    if not fontData then
        warn("FontManager:GetFont - Font '" .. fontName .. "' not registered. Falling back to SourceSans.")
        return Enum.Font.SourceSans -- Fallback
    end

    if fontData.AssetId then
        -- For TextLabel.Font, we need to return the Font enum or a Font object made from asset ID.
        -- Font.new(assetIdString) is the correct way for custom fonts.
        return Font.new(fontData.AssetId, fontData.Enum or Enum.Font.Legacy) -- Provide a base enum for weight/style if not specified
    elseif fontData.Enum then
        return fontData.Enum
    else
        warn("FontManager:GetFont - Font '" .. fontName .. "' has invalid data. Falling back to SourceSans.")
        return Enum.Font.SourceSans -- Fallback
    end
end

return FontManager
