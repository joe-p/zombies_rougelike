CoD.ExitButtonDobby = InheritFrom(LUI.UIElement)
CoD.ExitButtonDobby.new = function(HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end

	Widget:setUseStencil(false)
    Widget.id = "ExitButtonDobby"
	Widget:setClass(CoD.ExitButtonDobby)
	Widget:makeFocusable()
	Widget:setHandleMouse(true)
    
	Widget.soundSet = "HUD"

	Widget:setLeftRight(true, false, 0, 44)
	Widget:setTopBottom(true, false, 0, 20)
	Widget.anyChildUsesUpdateState = true

    local rgbOffset = 0.04
    local highlightOffset = 0.05
    Widget.ButtonImage = LUI.UIImage.new()
    Widget.ButtonImage:setLeftRight(true, true, 0, 0)
    Widget.ButtonImage:setTopBottom(true, true, 0, 0)
    Widget.ButtonImage:setImage(RegisterImage("ui_purchasemenu_bg"))
    Widget.ButtonImage:setRGB(51/255 + rgbOffset, 47/255 + rgbOffset, 42/255 + rgbOffset)
    Widget:addElement(Widget.ButtonImage)

	Widget.clipsPerState = {
        DefaultState = {
            DefaultClip = function()
                Widget:setupElementClipCounter(1)

                Widget.ButtonImage:completeAnimation()
                Widget.ButtonImage:setAlpha(0.8)
                Widget.ButtonImage:setRGB(51/255 + rgbOffset, 47/255 + rgbOffset, 42/255 + rgbOffset)
                Widget.clipFinished(Widget.ButtonImage, {})
            end,
            Focus = function()
                Widget:setupElementClipCounter(1)

                Widget.ButtonImage:completeAnimation()
                Widget.ButtonImage:setRGB(51/255 + rgbOffset + highlightOffset, 47/255 + rgbOffset + highlightOffset, 42/255 + rgbOffset + highlightOffset)
                Widget.clipFinished(Widget.ButtonImage, {})
            end,
            GainOver = function()
                Widget:setupElementClipCounter(1)

                Widget.ButtonImage:completeAnimation()
                Widget.ButtonImage:setRGB(51/255 + rgbOffset + highlightOffset, 47/255 + rgbOffset + highlightOffset, 42/255 + rgbOffset + highlightOffset)
                Widget.clipFinished(Widget.ButtonImage, {})
            end,
            Over = function()
                Widget:setupElementClipCounter(1)

                Widget.ButtonImage:completeAnimation()
                Widget.ButtonImage:setRGB(51/255 + rgbOffset + highlightOffset, 47/255 + rgbOffset + highlightOffset, 42/255 + rgbOffset + highlightOffset)
                Widget.clipFinished(Widget.ButtonImage, {})
            end,
            LoseOver = function()
                Widget:setupElementClipCounter(1)

                Widget.ButtonImage:completeAnimation()
                Widget.ButtonImage:setRGB(51/255 + rgbOffset, 47/255 + rgbOffset, 42/255 + rgbOffset)
                Widget.clipFinished(Widget.ButtonImage, {})
            end
        }
    }

    HudRef:AddButtonCallbackFunction(Widget, InstanceRef, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil, function(ItemRef, HudRef, InstanceRef, arg3)
        HudRef:close()
        return true
    end, function(ItemRef, HudRef, InstanceRef)
        return true
    end, true)

	Widget:registerEventHandler("gain_focus", function(Sender, Event)
		local success = nil
        
        if Sender.m_focusable then
            if Sender.gainFocus then
                success = Sender:gainFocus(Event)
            elseif Sender.super.gainFocus then
                success = Sender:gainFocus(Event)
            end
        else
            success = false
        end

		return success
	end)

	Widget:registerEventHandler("lose_focus", function(Sender, Event)
		local success = nil
        
        if Sender.loseFocus then
            success = Sender:loseFocus(Event)
        elseif Sender.super.loseFocus then
            success = Sender:loseFocus(Event)
        end

		return success
	end)

    Widget:registerEventHandler("mouseleave", function(Sender, Event)
        -- set back to defaultclip..
        if Sender:playClip("LoseOver") then
            Sender.nextClip = "DefaultClip"
        else
            Sender:playClip("DefaultClip")
        end

        Sender:processEvent({name = "lose_focus", controller = InstanceRef})
    end)

    Widget:registerEventHandler("mouseenter", function(Sender, Event)
        Sender:processEvent({name = "gain_focus", controller = InstanceRef})
    end)

	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function(Sender)
		Sender.ButtonImage:close()
	end)

	if PostLoadFunc then
		PostLoadFunc(Widget, InstanceRef, HudRef)
	end

	return Widget
end