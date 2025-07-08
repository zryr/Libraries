-- FontManager.lua
return function(dependencies)
    local FontManager = {}

    local registeredFonts = {}

    function FontManager.RegisterFont(fontName, fontIdOrPath)
    if type(fontIdOrPath) == "string" and not fontIdOrPath:match("^rbxassetid://") then
        -- Assuming it's a path for custom assets if not an rbxassetid
        registeredFonts[fontName] = fontIdOrPath
    else
        registeredFonts[fontName] = Font.new(fontIdOrPath)
    end
end

function FontManager.GetFont(fontName)
    return registeredFonts[fontName]
end

function FontManager.ApplyFont(guiObject, fontNameOrInstance, weight, style)
    local fontFace
    if typeof(fontNameOrInstance) == "Font" then
        fontFace = fontNameOrInstance
    elseif type(fontNameOrInstance) == "string" then
        fontFace = registeredFonts[fontNameOrInstance]
    end

    if fontFace then
        if typeof(fontFace) == "string" then -- Custom asset path
             -- For custom assets, we assume the path directly works or is handled by the UI element itself.
             -- Roblox's FontFace property expects a Font object or a specific string format.
             -- Direct string paths for custom fonts are not standard for TextLabel.FontFace.
             -- This might need adjustment based on how custom fonts are loaded/applied if not using rbxassetid.
             -- For now, we'll warn if it's a path and not a Font object.
            if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
                -- Attempt to create FontFace if it's an rbxassetid string path
                if fontFace:match("^rbxassetid://") then
                    guiObject.FontFace = Font.new(fontFace, weight or Enum.FontWeight.Regular, style or Enum.FontStyle.Normal)
                else
                     -- If it's a file path like "Fonts/MyFont.otf", this won't directly work.
                     -- Roblox handles custom fonts usually by uploading them and using their rbxassetid.
                     -- For now, we'll print a warning. Actual loading of custom font files would require more.
                    warn("FontManager: Custom font path '"..fontFace.."' provided. Direct path assignment to FontFace is not standard. Ensure the font is loaded and use its rbxassetid or Font object.")
                    -- As a fallback, try setting it directly if it's a known system font name
                    local success, _ = pcall(function() guiObject.Font = Enum.Font[fontFace] end)
                    if not success then
                        guiObject.Font = Enum.Font.SourceSans -- Default fallback
                    end
                end
            end
        elseif typeof(fontFace) == "Font" then
            if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
                guiObject.FontFace = fontFace
            end
        end
    else
        warn("FontManager: Font '" .. tostring(fontNameOrInstance) .. "' not registered.")
        if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
            guiObject.Font = Enum.Font.SourceSans -- Default fallback
        end
    end
end

-- Pre-register a default font for convenience, similar to WindUI
FontManager.RegisterFont("Default", "rbxassetid://12187365364") -- WindUI's default font

return FontManager
end)
