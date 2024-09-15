require("ui.uieditor.widgets.CAC.cac_3dTitleIntermediary")
require("ui.uieditor.widgets.Footer.fe_FooterContainer_NOTLobby")
CoD.perkmenuframe = InheritFrom(LUI.UIElement)
CoD.perkmenuframe.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(Widget, InstanceRef)
	end
	Widget:setUseStencil(false)
	Widget:setClass(CoD.perkmenuframe)
	Widget.id = "perkmenuframe"
	Widget.soundSet = "default"
	Widget:setLeftRight(true, false, 0, 1280)
	Widget:setTopBottom(true, false, 0, 720)
	Widget.anyChildUsesUpdateState = true
	local topBorder = LUI.UIImage.new()
	topBorder:setLeftRight(true, true, -52, 51)
	topBorder:setTopBottom(true, false, -51, 85.5)
	topBorder:setRGB(0, 0, 0)
	topBorder:setAlpha(0.4)
	Widget:addElement(topBorder)
	Widget.topBorder = topBorder
	
	local titleLabel = LUI.UITightText.new()
	titleLabel:setLeftRight(true, false, 57, 134)
	titleLabel:setTopBottom(true, false, 31.5, 79.5)
	titleLabel:setAlpha(0)
	titleLabel:setText(Engine.Localize("MENU_NEW"))
	titleLabel:setTTF("fonts/FoundryGridnik-Bold.ttf")
	Widget:addElement(titleLabel)
	Widget.titleLabel = titleLabel
	
	local cac3dTitleIntermediary0 = CoD.cac_3dTitleIntermediary.new(HudRef, InstanceRef)
	cac3dTitleIntermediary0:setLeftRight(true, false, -78, 531)
	cac3dTitleIntermediary0:setTopBottom(true, false, 0, 146)
	cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(Engine.Localize("MENU"))
	Widget:addElement(cac3dTitleIntermediary0)
	Widget.cac3dTitleIntermediary0 = cac3dTitleIntermediary0
	
	local CategoryListLine = LUI.UIImage.new()
	CategoryListLine:setLeftRight(true, true, -12, 12)
	CategoryListLine:setTopBottom(true, false, 79.5, 89)
	CategoryListLine:setRGB(0.9, 0.9, 0.9)
	CategoryListLine:setImage(RegisterImage("uie_t7_menu_cac_tabline"))
	Widget:addElement(CategoryListLine)
	Widget.CategoryListLine = CategoryListLine
	
	local feFooterContainerNOTLobby = CoD.fe_FooterContainer_NOTLobby.new(HudRef, InstanceRef)
	feFooterContainerNOTLobby:setLeftRight(true, true, 1, -1)
	feFooterContainerNOTLobby:setTopBottom(false, true, -67, 0)
	feFooterContainerNOTLobby:linkToElementModel(Widget, nil, false, function (ModelRef)
		feFooterContainerNOTLobby:setModel(ModelRef, InstanceRef)
	end)
	feFooterContainerNOTLobby:registerEventHandler("menu_loaded", function (Sender, Event)
		local f3_local0 = nil
		SizeToSafeArea(Sender, InstanceRef)
		if not f3_local0 then
			f3_local0 = Sender:dispatchEventToChildren(Event)
		end
		return f3_local0
	end)
	Widget:addElement(feFooterContainerNOTLobby)
	Widget.feFooterContainerNOTLobby = feFooterContainerNOTLobby
	
	LUI.OverrideFunction_CallOriginalFirst(Widget, "setState", function (f4_arg0, f4_arg1)
		if IsElementInState(f4_arg0, "Update") then
			SetElementStateByElementName(Widget, "cac3dTitleIntermediary0", InstanceRef, "Update")
		end
	end)
	LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function (Sender)
		Sender.cac3dTitleIntermediary0:close()
		Sender.feFooterContainerNOTLobby:close()
	end)
	if PostLoadFunc then
		PostLoadFunc(Widget, InstanceRef, HudRef)
	end
	return Widget
end

