require("ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame")
require("ui.uieditor.widgets.Footer.fe_LeftContainer_NOTLobby")
require("ui.uieditor.widgets.footerbuttonprompt")

require("ui.uieditor.widgets.Wonderfizz.PerkMenuTabBar")
require("ui.uieditor.widgets.Wonderfizz.ExitButtonDobby")

local function PreLoadCallback(HudRef, InstanceRef)
    HudRef.disablePopupOpenCloseAnim = true
    local buyablesModel = Engine.CreateModel(Engine.GetModelForController(InstanceRef), "cw_perk_buyables")
    local ownedItemsModel = Engine.CreateModel(buyablesModel, "owned_perks")
end

-- Instead of restructuring, we're just removing the tab bar and forcing it to use this tab..
local function PostLoadCallback(HudRef, InstanceRef)
    local DefaultTab = "CoD.MenuTabPerks"
    HudRef.TabFrame:changeFrameWidget(DefaultTab)

    local framedWidget = HudRef.TabFrame.framedWidget
    if framedWidget then
        framedWidget.ListBackground.CraftablesList:ScaleListAndBackgroundForElementCount()

        local List = framedWidget.ListBackground.CraftablesList
        local sizePerExtraItem = List.spacingAndPadding + (List.itemSize / 2) -- default minimum of 6 items per row (always 2 rows)
        local extraItemsPerSide = math.ceil((List.hCount - 6) / 2)
        if extraItemsPerSide < 0 then
            extraItemsPerSide = 0
        end

        -- the 307 on each side was made for 8 items
        HudRef.wonderfizzBackground:setLeftRight(false, false, -307 + (sizePerExtraItem * 2) - (sizePerExtraItem * extraItemsPerSide), 307 - (sizePerExtraItem * 2) + (sizePerExtraItem * extraItemsPerSide))
    end
end

function LUI.createMenu.WonderfizzMenuBase(InstanceRef)
    local HudRef = CoD.Menu.NewForUIEditor("WonderfizzMenuBase")
    
    if PreLoadCallback then
        PreLoadCallback(HudRef, InstanceRef)
    end
    
    HudRef.soundSet = "default"
    HudRef:setOwner(InstanceRef)
    HudRef:setLeftRight(true, true, 0, 0)
    HudRef:setTopBottom(true, true, 0, 0)
    PlaySoundSetSound(HudRef, "menu_open")
    
    HudRef.buttonModel = Engine.CreateModel(Engine.GetModelForController(InstanceRef), "WonderfizzMenuBase.buttonPrompts")
    HudRef.anyChildUsesUpdateState = true
    HudRef.disableBlur = true
    HudRef.disableDarkenElement = true
    Engine.LockInput(InstanceRef, true)
    Engine.SetUIActive(InstanceRef, true)

    HudRef.wonderfizzText = LUI.UIText.new()
    HudRef.wonderfizzText:setLeftRight(false, false, -168, 168)
    HudRef.wonderfizzText:setTopBottom(true, false, 78, 115)
    HudRef.wonderfizzText:setTTF("fonts/coldwar/cwbold.ttf")
    HudRef.wonderfizzText:setText("DER WUNDERFIZZ")
    HudRef:addElement(HudRef.wonderfizzText)

    HudRef.wonderfizzBackground = LUI.UIImage.new()
    HudRef.wonderfizzBackground:setLeftRight(false, false, -307, 307)
    HudRef.wonderfizzBackground:setTopBottom(false, true, -347, -59)
    HudRef.wonderfizzBackground:setImage(RegisterImage("ui_wonderfizz_menu"))
    HudRef:addElement(HudRef.wonderfizzBackground)
    
    -- This is a UIFrame. You can make it use whatever widget you want through script.. Used to display different tab information..
    HudRef.TabFrame = LUI.UIFrame.new(HudRef, InstanceRef, 0, 0, false)
    HudRef.TabFrame:setLeftRight(true, true, 0, 0)
    HudRef.TabFrame:setTopBottom(true, true, 0, 0)
    HudRef.TabFrame.id = "TabFrame"
    HudRef.TabFrame:setHandleMouse(true)
    HudRef:addElement(HudRef.TabFrame)

    local buttonBottomOffset = 87
    local buttonLeftOffset = 370
    HudRef.ExitButtonDobby = CoD.ExitButtonDobby.new(HudRef, InstanceRef)
    HudRef.ExitButtonDobby:setLeftRight(true, false, buttonLeftOffset, buttonLeftOffset + 44)
    HudRef.ExitButtonDobby:setTopBottom(false, true, -buttonBottomOffset - 20, -buttonBottomOffset)
    HudRef.ExitButtonDobby.id = "ExitButtonDobby"
    --HudRef:addElement(HudRef.ExitButtonDobby)

    -- Button Shit
    HudRef.leftButtonBar = CoD.fe_LeftContainer_NOTLobby.new(HudRef, InstanceRef)
	HudRef.leftButtonBar:setLeftRight(true, false, 445.96, 877.96)
	HudRef.leftButtonBar:setTopBottom(true, false, 523.25, 555.25)
	HudRef.leftButtonBar:setScale(0.5)
	HudRef:addElement(HudRef.leftButtonBar)
    
    -- This is the part that shows the text and the animation at the top of the screen. It also shows buttonprompts at the bottom of the screen.. 
    HudRef.MenuFrame = CoD.GenericMenuFrame.new(HudRef, InstanceRef)
    HudRef.MenuFrame:setLeftRight(true, true, 0, 0)
    HudRef.MenuFrame:setTopBottom(true, true, 0, 0)
    HudRef.MenuFrame.titleLabel:setText(Engine.Localize("TEST TAB MENU"))
    HudRef.MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(Engine.Localize("DER WONDERFIZZ"))
    --HudRef:addElement(HudRef.MenuFrame)

    HudRef.TabFrame.navigation = {
        down = HudRef.ExitButtonDobby
    }
    HudRef.ExitButtonDobby.navigation = {
        up = HudRef.TabFrame
    }
    CoD.Menu.AddNavigationHandler(HudRef, HudRef, InstanceRef)

    HudRef:registerEventHandler("menu_loaded", function(Sender, Event)
        -- Remove size to safe area unless you want the menu to be fullscreen!
        SizeToSafeArea(Sender, InstanceRef)
        return Sender:dispatchEventToChildren(Event)
    end)

    -- Needed to make the button prompts display at the bottom of the screen
    --HudRef.MenuFrame:setModel(HudRef.buttonModel, InstanceRef)
    --HudRef.leftButtonBar:setModel(HudRef.buttonModel, InstanceRef)

    HudRef:processEvent({name = "menu_loaded", controller = InstanceRef})
    HudRef:processEvent({name = "update_state", menu = HudRef})
    
    -- Focus on the TabFrame when the menu opens
    if not HudRef:restoreState() then
        HudRef.TabFrame:processEvent({
            name = "gain_focus",
            controller = InstanceRef
        })
    end

    -- Close everything when we're done..
    LUI.OverrideFunction_CallOriginalSecond(HudRef, "close", function(HudRef)        
        HudRef.MenuFrame:close()
        HudRef.TabFrame:close()
        HudRef.wonderfizzBackground:close()
        HudRef.wonderfizzText:close()
        HudRef.leftButtonBar:close()
        HudRef.ExitButtonDobby:close()

        Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "WonderfizzMenuBase.buttonPrompts"))
    end)
    
    if PostLoadCallback then
        PostLoadCallback(HudRef, InstanceRef)
    end

    return HudRef
end