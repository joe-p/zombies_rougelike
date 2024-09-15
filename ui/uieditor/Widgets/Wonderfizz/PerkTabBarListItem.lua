CoD.PerkTabBarListItem = InheritFrom(LUI.UIElement)

local function PostLoadCallback(Widget, InstanceRef, HudRef)
	Widget:setHandleMouse(true)
end

function CoD.PerkTabBarListItem.new(HudRef, InstanceRef) 
    local Widget = LUI.UIElement.new()
    Widget:setClass(CoD.PerkTabBarListItem)
    Widget.id = "PerkTabBarListItem"
    Widget.soundSet = "default"
    Widget:setUseStencil(false)

    Widget.anyChildUsesUpdateState = true

    Widget:setLeftRight(true, false, 0, 88)
    Widget:setTopBottom(true, false, 0, 20)

    Widget.TabBackground = LUI.UIImage.new()
    Widget.TabBackground:setLeftRight(true, true, 0, 0)
    Widget.TabBackground:setTopBottom(true, true, 0, 0)
    Widget.TabBackground:setImage(RegisterImage("ui_purchasemenu_bg"))
    Widget:addElement(Widget.TabBackground)

    Widget.TabBackgroundFocus = LUI.UIImage.new()
    Widget.TabBackgroundFocus:setLeftRight(true, true, 0, 0)
    Widget.TabBackgroundFocus:setTopBottom(true, true, 0, 0)
    Widget.TabBackgroundFocus:setImage(RegisterImage("ui_purchasemenu_bg"))
    Widget.TabBackgroundFocus:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
    Widget.TabBackgroundFocus:setRGB(1, 0, 0)
    Widget:addElement(Widget.TabBackgroundFocus)

	Widget.Text = LUI.UIText.new()
	Widget.Text:setLeftRight(true, true, 5, -5)
	Widget.Text:setTopBottom(false, true, -12, -2)
	Widget.Text:setAlpha(0.7)
	Widget.Text:setTTF("fonts/escom.ttf")
	Widget.Text:setLetterSpacing(2)
	Widget.Text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
	Widget.Text:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget.Text:linkToElementModel(Widget, "tabName", true, function(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			Widget.Text:setText(Engine.Localize(ModelValue))
		end
	end)
	Widget:addElement(Widget.Text)

	Widget.TextDark = LUI.UIText.new()
	Widget.TextDark:setLeftRight(true, true, 5, -5)
	Widget.TextDark:setTopBottom(false, true, -12, -2)
	Widget.TextDark:setRGB(0, 0, 0)
	Widget.TextDark:setAlpha(0)
	Widget.TextDark:setTTF("fonts/escom.ttf")
	Widget.TextDark:setMaterial(LUI.UIImage.GetCachedMaterial("sw4_2d_uie_font_cached_glow"))
	Widget.TextDark:setShaderVector(0, 0.08, 0, 0, 0)
	Widget.TextDark:setShaderVector(1, 0, 0, 0, 0)
	Widget.TextDark:setShaderVector(2, 1, 0, 0, 0)
	Widget.TextDark:setLetterSpacing(2)
	Widget.TextDark:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_CENTER)
	Widget.TextDark:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	Widget.TextDark:linkToElementModel(Widget, "tabName", true, function(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			Widget.TextDark:setText(Engine.Localize(ModelValue))
		end
	end)
	Widget:addElement(Widget.TextDark)

    Widget.clipsPerState = {
        DefaultState = {
            DefaultClip = function()
                Widget:setupElementClipCounter(4)

                Widget.TabBackground:completeAnimation()
                Widget.TabBackground:setAlpha(0.7)
                Widget.clipFinished(Widget.TabBackground, {})

                Widget.TabBackgroundFocus:completeAnimation()
                Widget.TabBackgroundFocus:setAlpha(0)
                Widget.clipFinished(Widget.TabBackgroundFocus, {})

                Widget.Text:completeAnimation()
                Widget.Text:setAlpha(0.7)
                Widget.Text:setTopBottom(false, true, -12, -2)
                Widget.clipFinished(Widget.Text, {})

                Widget.TextDark:completeAnimation()
                Widget.TextDark:setAlpha(0)
                Widget.TextDark:setTopBottom(false, true, -12, -2)
                Widget.clipFinished(Widget.TextDark, {})
            end,
            Active = function()
                Widget:setupElementClipCounter(4)

                Widget.TabBackground:completeAnimation()
                Widget.TabBackground:setAlpha(0)
                Widget.clipFinished(Widget.TabBackground, {})

                Widget.TabBackgroundFocus:completeAnimation()
                Widget.TabBackgroundFocus:setAlpha(0.8)
                Widget.clipFinished(Widget.TabBackgroundFocus, {})

                Widget.Text:completeAnimation()
                Widget.Text:setAlpha(0)
                Widget.Text:setTopBottom(false, true, -16, -6)
                Widget.clipFinished(Widget.Text, {})

                Widget.TextDark:completeAnimation()
                Widget.TextDark:setAlpha(1)
                Widget.TextDark:setTopBottom(false, true, -16, -6)
                Widget.clipFinished(Widget.TextDark, {})
            end,
            GainActive = function()
                Widget:setupElementClipCounter(4)

                Widget.TabBackground:completeAnimation()
                Widget.TabBackground:setAlpha(0)
                Widget.clipFinished(Widget.TabBackground, {})

                Widget.TabBackgroundFocus:completeAnimation()
                Widget.TabBackgroundFocus:setAlpha(0.8)
                Widget.clipFinished(Widget.TabBackgroundFocus, {})

                Widget.Text:completeAnimation()
                Widget.Text:setAlpha(0)
                Widget.Text:setTopBottom(false, true, -16, -6)
                Widget.clipFinished(Widget.Text, {})

                Widget.TextDark:completeAnimation()
                Widget.TextDark:setAlpha(1)
                Widget.TextDark:setTopBottom(false, true, -16, -6)
                Widget.clipFinished(Widget.TextDark, {})
            end,
            LoseActive = function()
                Widget:setupElementClipCounter(4)

                Widget.TabBackground:completeAnimation()
                Widget.TabBackground:setAlpha(0.7)
                Widget.clipFinished(Widget.TabBackground, {})

                Widget.TabBackgroundFocus:completeAnimation()
                Widget.TabBackgroundFocus:setAlpha(0)
                Widget.clipFinished(Widget.TabBackgroundFocus, {})

                Widget.Text:completeAnimation()
                Widget.Text:setAlpha(0.7)
                Widget.Text:setTopBottom(false, true, -12, -2)
                Widget.clipFinished(Widget.Text, {})

                Widget.TextDark:completeAnimation()
                Widget.TextDark:setAlpha(0)
                Widget.TextDark:setTopBottom(false, true, -12, -2)
                Widget.clipFinished(Widget.TextDark, {})
            end,
            Over = function()
                Widget:setupElementClipCounter(4)

                Widget.TabBackground:completeAnimation()
                Widget.TabBackground:setAlpha(0)
                Widget.clipFinished(Widget.TabBackground, {})

                Widget.TabBackgroundFocus:completeAnimation()
                Widget.TabBackgroundFocus:setAlpha(0.4)
                Widget.clipFinished(Widget.TabBackgroundFocus, {})

                Widget.Text:completeAnimation()
                Widget.Text:setAlpha(0)
                Widget.Text:setTopBottom(false, true, -20, -10)
                Widget.clipFinished(Widget.Text, {})

                Widget.TextDark:completeAnimation()
                Widget.TextDark:setAlpha(1)
                Widget.TextDark:setTopBottom(false, true, -20, -10)
                Widget.clipFinished(Widget.TextDark, {})
            end,
            GainOver = function()
                Widget:setupElementClipCounter(4)

                Widget.TabBackground:completeAnimation()
                Widget.TabBackground:setAlpha(0)
                Widget.clipFinished(Widget.TabBackground, {})

                Widget.TabBackgroundFocus:completeAnimation()
                Widget.TabBackgroundFocus:setAlpha(0.4)
                Widget.clipFinished(Widget.TabBackgroundFocus, {})

                Widget.Text:completeAnimation()
                Widget.Text:setAlpha(0)
                Widget.Text:setTopBottom(false, true, -20, -10)
                Widget.clipFinished(Widget.Text, {})

                Widget.TextDark:completeAnimation()
                Widget.TextDark:setAlpha(1)
                Widget.TextDark:setTopBottom(false, true, -20, -10)
                Widget.clipFinished(Widget.TextDark, {})
            end,
            LoseOver = function()
                Widget:setupElementClipCounter(4)

                Widget.TabBackground:completeAnimation()
                Widget.TabBackground:setAlpha(0.7)
                Widget.clipFinished(Widget.TabBackground, {})

                Widget.TabBackgroundFocus:completeAnimation()
                Widget.TabBackgroundFocus:setAlpha(0)
                Widget.clipFinished(Widget.TabBackgroundFocus, {})

                Widget.Text:completeAnimation()
                Widget.Text:setAlpha(0.7)
                Widget.Text:setTopBottom(false, true, -12, -2)
                Widget.clipFinished(Widget.Text, {})

                Widget.TextDark:completeAnimation()
                Widget.TextDark:setAlpha(0)
                Widget.TextDark:setTopBottom(false, true, -12, -2)
                Widget.clipFinished(Widget.TextDark, {})
            end
        }
    }

    LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function(Widget)
        Widget.TabBackground:close()
    end)

    if PostLoadCallback then
        PostLoadCallback(Widget, InstanceRef, HudRef)
    end

    return Widget
end