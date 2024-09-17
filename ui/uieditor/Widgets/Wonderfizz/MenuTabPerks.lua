require("ui.uieditor.widgets.Wonderfizz.MenuListItemWidget")
require("ui.uieditor.widgets.Scrollbars.verticalScrollbar")
require("ui.uieditor.widgets.Scrollbars.verticalCounter")
require("ui.uieditor.widgets.Wonderfizz.PerksUIListWidget")
require("ui.uieditor.widgets.Wonderfizz.ExitButtonDobby")

CoD.MenuTabPerks = InheritFrom(LUI.UIElement)

-- Datasource for populating our list with elements
DataSources.BuyablePerksDataSource = DataSourceHelpers.ListSetup("BuyablePerksDataSource", function(InstanceRef)
    local dataTable = {}

    local function AddPerkEntry(displayText, cost, responseStr, iconName, description)
        table.insert(dataTable, {
            models = {
                text = displayText,
                description = description,
                cost = cost,
                responseStr = responseStr .. "." .. tostring(cost),
                name = LUI.splitString(responseStr, ".")[2],
                itemIcon = iconName
            }
        })
    end

    local quickReviveCost = 500
    if Engine.GetLobbyClientCount(Enum.LobbyType.LOBBY_TYPE_GAME) > 1 then
        quickReviveCost = 1500
    end

    -- Stock 8 perks (no electric cherry)
    AddPerkEntry("Quick Revive", quickReviveCost, "perk.quickrevive", "ui_purchasemenu_quickrevive", "Drink to revive faster. Self-Revive on solo.")
    AddPerkEntry("Deadshot Daquiri", 1500, "perk.deadshot", "ui_purchasemenu_deadshot", "Drink to improve aiming down sights.")
    AddPerkEntry("Double Tap 2.0", 2000, "perk.doubletap2", "ui_purchasemenu_doubletap", "Drink to shoot double firepower.")
    AddPerkEntry("Stamin-Up", 2000, "perk.staminup", "ui_purchasemenu_staminup", "Drink to run and sprint faster.")
    AddPerkEntry("Juggernog", 2500, "perk.armorvest", "ui_purchasemenu_armorvest", "Drink to increase health.")
    AddPerkEntry("Speed Cola", 3000, "perk.fastreload", "ui_purchasemenu_speedcola", "Drink to reload faster.")
    AddPerkEntry("Widows Wine", 4000, "perk.widowswine", "ui_purchasemenu_widows", "Drink to gain Widow's Wine grenades.")
    AddPerkEntry("Mule Kick", 4000, "perk.additionalprimaryweapon", "ui_purchasemenu_mulekick", "Drink to carry an additional weapon.")

    -- Logical's perks
    --AddPerkEntry("Fighter's Fizz", 3500, "perk.jetquiet", "ui_purchasemenu_ffyl", "Drink to regain all perks on downed kills.")
    --AddPerkEntry("I.C.U.", 2500, "perk.immunecounteruav", "ui_purchasemenu_icu", "Drink for faster low-health regen.")

    --[[

    FUNCTION ARGUMENTS:

    AddPerkEntry("Display Name", perk_cost, "perk.speciality", "perk_menu_icon", "description")

    [NOTE]: The "perk_menu_icon" is the name of the image from APE.
    You must also load any custom images in your zone file OR inside the db_wunderfizz.zpkg file like so:

    image,perk_menu_icon

    - the "perk." is needed before the speciality

    ]]

    --- shuffle dataTable ensuring no duplicates
    for i = #dataTable, 2, -1 do
        local j = math.random(i)
        dataTable[i], dataTable[j] = dataTable[j], dataTable[i]
    end

    --- delete until only 3 are left
    while #dataTable > 3 do
        table.remove(dataTable)
    end

    return dataTable
end, true)

local function PostLoadCallback(Widget, InstanceRef, HudRef)
    Widget.ListBackground.CraftablesList:ScaleListAndBackgroundForElementCount()

    LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function(Widget)
        Widget.ListBackground.CraftablesList:close()
        Widget.ListBackground.DescriptionText:close()
        Widget.ListBackground.ScoreText:close()
        Widget.ListBackground.ScoreIcon:close()
        Widget.ListBackground.CostText:close()
        Widget.ListBackground.CostIcon:close()
        Widget.ListBackground.CostWord:close()
        Widget.ListBackground.ItemNameText:close()
        Widget.ListBackground.ExitButtonDobby:close()
        Widget.ListBackground:close()
    end)
end

function CoD.MenuTabPerks.new(HudRef, InstanceRef) 
    local Widget = LUI.UIElement.new()
    Widget:setClass(CoD.MenuTabPerks)
    Widget.id = "MenuTabPerks"
    Widget.soundSet = "default"
    Widget:setUseStencil(false)

    Widget:setLeftRight(true, true, 0, 0)
    Widget:setTopBottom(true, true, 0, 0)

    Widget:makeFocusable()
    Widget:setHandleMouse(true)
    Widget.onlyChildrenFocusable = true
    Widget.anyChildUsesUpdateState = true

    Widget.ListBackground = LUI.UIImage.new()
    Widget.ListBackground:setLeftRight(false, false, -192, 192)
    Widget.ListBackground:setTopBottom(false, true, -302, -116)
    Widget.ListBackground:setImage(RegisterImage("$blacktransparent"))
    --Widget.ListBackground:setMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
    Widget.ListBackground:makeFocusable()
    Widget.ListBackground:setHandleMouse(true)
    Widget.ListBackground.onlyChildrenFocusable = true
    Widget.ListBackground.anyChildUsesUpdateState = true
    Widget.ListBackground.id = "ListBackground"
    Widget:addElement(Widget.ListBackground)

    local scoreIconStartRight = -9
    local scoreIconWidth = 14
    Widget.ListBackground.ScoreIcon = LUI.UIImage.new()
    Widget.ListBackground.ScoreIcon:setLeftRight(false, true, scoreIconStartRight - scoreIconWidth, scoreIconStartRight)
    Widget.ListBackground.ScoreIcon:setTopBottom(false, true, 33, 47)
    Widget.ListBackground.ScoreIcon:setImage(RegisterImage("ui_coldwar_zombie_essense"))
    Widget.ListBackground:addElement(Widget.ListBackground.ScoreIcon)

    Widget.ListBackground.ScoreText = LUI.UIText.new()
    Widget.ListBackground.ScoreText:setLeftRight(false, true, -23, -7)
    Widget.ListBackground.ScoreText:setTopBottom(false, true, 35, 50)
    Widget.ListBackground.ScoreText:setTTF("fonts/coldwar/cwlight.ttf")
    Widget.ListBackground.ScoreText:setRGB(0.898039216, 0.88627451, 0.882352941)
    Widget.ListBackground:addElement(Widget.ListBackground.ScoreText)

    -- Grab player score data..
    Widget.ListBackground.ScoreText:subscribeToGlobalModel(InstanceRef, "ZMPlayerList", "0", function(ModelRef)
        local localPlayerModel = ModelRef
        local localPlayerScoreModel = Engine.GetModel(localPlayerModel, "playerScore")
        
        if Widget.ListBackground.ScoreText.scoreSubscription then
            Widget.ListBackground.ScoreText:removeSubscription(Widget.ListBackground.ScoreText.scoreSubscription)
            Widget.ListBackground.ScoreText.scoreSubscription = nil
        end

        Widget.ListBackground.ScoreText.scoreSubscription = Widget.ListBackground.ScoreText:subscribeToModel(localPlayerScoreModel, function(ModelRef)
            local score = Engine.GetModelValue(ModelRef)
            if score then
                Widget.ListBackground.ScoreText:setText(Engine.Localize(Engine.GetModelValue(ModelRef)))
                local textWidth = Widget.ListBackground.ScoreText:getTextWidth()
                Widget.ListBackground.ScoreIcon:setLeftRight(false, true, scoreIconStartRight - scoreIconWidth - textWidth, scoreIconStartRight - textWidth)
            end
        end)
    end)

    Widget.ListBackground.CostIcon = LUI.UIImage.new()
    Widget.ListBackground.CostIcon:setLeftRight(false, true, scoreIconStartRight - scoreIconWidth, scoreIconStartRight)
    Widget.ListBackground.CostIcon:setTopBottom(true, false, 11.5, 25.5)
    Widget.ListBackground.CostIcon:setImage(RegisterImage("ui_coldwar_zombie_essense"))
    Widget.ListBackground:addElement(Widget.ListBackground.CostIcon)

    Widget.ListBackground.CostText = LUI.UIText.new()
    Widget.ListBackground.CostText:setLeftRight(false, true, -23, -7)
    Widget.ListBackground.CostText:setTopBottom(true, false, 13.5, -1.5)
    Widget.ListBackground.CostText:setTTF("fonts/coldwar/cwlight.ttf")
    Widget.ListBackground.CostText:setRGB(0, 0, 0)
    Widget.ListBackground:addElement(Widget.ListBackground.CostText)

    Widget.ListBackground.CostWord = LUI.UIText.new()
    Widget.ListBackground.CostWord:setLeftRight(false, true, -23, -7)
    Widget.ListBackground.CostWord:setTopBottom(true, false, 13.5, -1.5)
    Widget.ListBackground.CostWord:setTTF("fonts/coldwar/cwlight.ttf")
    Widget.ListBackground.CostWord:setText("Cost:")
    Widget.ListBackground.CostWord:setRGB(0, 0, 0)
    Widget.ListBackground:addElement(Widget.ListBackground.CostWord)

    Widget.ListBackground.ItemNameText = LUI.UIText.new()
    Widget.ListBackground.ItemNameText:setLeftRight(true, true, 12.5-6, -12.5+6)
    Widget.ListBackground.ItemNameText:setTopBottom(true, false, 34.5 - 26.5, 56 - 26.5)
    Widget.ListBackground.ItemNameText:setTTF("fonts/coldwar/cwbold.ttf")
    Widget.ListBackground.ItemNameText:setAlignment(LUI.Alignment.Left)
    Widget.ListBackground.ItemNameText:setText("")
    Widget.ListBackground.ItemNameText:setRGB(0.498039216, 0.109803922, 0.0705882353)
    Widget.ListBackground:addElement(Widget.ListBackground.ItemNameText)

    Widget.ListBackground.DescriptionText = LUI.UIText.new()
    Widget.ListBackground.DescriptionText:setLeftRight(true, true, 12.5-6, -12.5+6)
    Widget.ListBackground.DescriptionText:setTopBottom(true, false, 48-7, 66-7)
    Widget.ListBackground.DescriptionText:setTTF("fonts/coldwar/cwbold.ttf")
    Widget.ListBackground.DescriptionText:setAlignment(LUI.Alignment.Left)
    Widget.ListBackground.DescriptionText:setRGB(0.866666667, 0.803921569, 0.71372549)
    Widget.ListBackground:addElement(Widget.ListBackground.DescriptionText)

    Widget.ListBackground.CraftablesListBacking = LUI.UIImage.new()
    Widget.ListBackground.CraftablesListBacking:setLeftRight(false, false, -213, -213)
    Widget.ListBackground.CraftablesListBacking:setTopBottom(true, true, 418, -36)
    Widget.ListBackground.CraftablesListBacking:setImage(RegisterImage("ui_purchasemenu_bg"))
    Widget.ListBackground.CraftablesListBacking:setMaterial(LUI.UIImage.GetCachedMaterial("ui_multiply"))
    Widget.ListBackground.CraftablesListBacking:setRGB(0.274509804, 0.254901961, 0.22745098)
    Widget.ListBackground.CraftablesListBacking:setAlpha(0)
    Widget.ListBackground:addElement(Widget.ListBackground.CraftablesListBacking)

    Widget.ListBackground.ExitButtonDobby = CoD.ExitButtonDobby.new(HudRef, InstanceRef)
    Widget.ListBackground.ExitButtonDobby:setLeftRight(true, false, 6, 50)
    Widget.ListBackground.ExitButtonDobby:setTopBottom(false, true, 30, 50)
    Widget.ListBackground.ExitButtonDobby.id = "ExitButtonDobby"
    --Widget.ListBackground:addElement(Widget.ListBackground.ExitButtonDobby)

    -- Each of our specific craftables.. Populated by the datasource..
    Widget.ListBackground.CraftablesList = CoD.PerksUIListWidget.new(HudRef, InstanceRef, 2)
    Widget.ListBackground.CraftablesList:setLeftRight(false, false, -192, 192)
    Widget.ListBackground.CraftablesList:setTopBottom(true, false, 92, 120)
    Widget.ListBackground.CraftablesList:SetDataSources("BuyablePerksDataSource")
    Widget.ListBackground.CraftablesList:setWidgetType(CoD.MenuListItemWidget)
    Widget.ListBackground.CraftablesList:makeFocusable()
    Widget.ListBackground.CraftablesList:setHorizontalCount(8)
    Widget.ListBackground.CraftablesList:SetSpacingAndPadding(9)
    Widget.ListBackground.CraftablesList:SetItemSize(57)
    Widget.ListBackground:addElement(Widget.ListBackground.CraftablesList)

    Widget.ListBackground.CraftablesList.id = "CraftablesList"

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

    if PostLoadCallback then
        PostLoadCallback(Widget, InstanceRef, HudRef)
    end

    return Widget
end