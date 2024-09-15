CoD.MenuListItemWidget = InheritFrom(LUI.UIElement)

function CoD.MenuListItemWidget.new(HudRef, InstanceRef)
    local Widget = LUI.UIElement.new()
    Widget:setClass(CoD.MenuListItemWidget)
    Widget.id = "MenuListItemWidget"
    Widget.soundSet = "default"
    Widget.anyChildUsesUpdateState = true

    Widget:makeFocusable()
    Widget:setHandleMouse(true)
    Widget:setLeftRight(true, false, 0, 57)
    Widget:setTopBottom(true, false, 0, 57)

    LUI.OverrideFunction_CallOriginalSecond(Widget, "setState", function(Widget, StateName)
        if StateName == "Disabled" then
            --Widget:makeNotFocusable()

            if Widget.CraftableItemCost.costText then
                Widget.CraftableItemCost:setText(Widget.CraftableItemCost.costText)
            end

            Widget:setZoom(-1)
        elseif StateName == "Owned" then
            --Widget:makeNotFocusable()

            Widget.CraftableItemCost:setText(Engine.Localize("OWNED"))
            Widget:setZoom(-1)
        else
            Widget:makeFocusable()

            if StateName == "Locked" then
                Widget.CraftableItemCost:setText("LOCKED")
                Widget:setZoom(-1)
            else
                if Widget.CraftableItemCost.costText then
                    Widget.CraftableItemCost:setText(Widget.CraftableItemCost.costText)
                end

                if Widget.CraftableItemIcon.itemIcon then
                    Widget.CraftableItemIcon:setImage(RegisterImage(Widget.CraftableItemIcon.itemIcon))
                end

                Widget:setZoom(1)
            end
        end
    end)

    Widget.Background = LUI.UIImage.new()
    Widget.Background:setLeftRight(true, true, 0, 0)
    Widget.Background:setTopBottom(true, true, 0, 0)
    Widget.Background:setImage(RegisterImage("ui_purchasemenu_bg"))
    Widget.Background:setRGB(0.560784314, 0.552941176, 0.549019608)
    Widget:addElement(Widget.Background)

    local focusPipsOffset = 8
    Widget.focusPips = LUI.UIImage.new()
    Widget.focusPips:setLeftRight(true, true, -focusPipsOffset, focusPipsOffset)
    Widget.focusPips:setTopBottom(true, true, -focusPipsOffset, focusPipsOffset)
    Widget.focusPips:setImage(RegisterImage("ui_purchasemenu_focus_pips"))
    Widget.focusPips:setRGB(0.9, 0.9, 0.9)
    Widget:addElement(Widget.focusPips)

    Widget.CraftableItemIcon = LUI.UIImage.new()
    Widget.CraftableItemIcon:setLeftRight(true, true, 6, -6)
    Widget.CraftableItemIcon:setTopBottom(true, true, 6, -6)
    Widget.CraftableItemIcon:setImage(RegisterImage("blacktransparent"))
    Widget:addElement(Widget.CraftableItemIcon)

    Widget.OwnedGlow = LUI.UIImage.new()
    Widget.OwnedGlow:setAlpha(0)
    Widget.OwnedGlow:setLeftRight(false, true, -14, -2)
    Widget.OwnedGlow:setTopBottom(true, false, 2, 14)
    Widget.OwnedGlow:setRGB(1, 0.768627451, 0)
    Widget.OwnedGlow:setImage(RegisterImage("ui_purchasemenu_item_circle"))
    Widget:addElement(Widget.OwnedGlow)

    Widget.CraftableItemCostBG = LUI.UIImage.new()
    Widget.CraftableItemCostBG:setLeftRight(true, true, 4, -4)
    Widget.CraftableItemCostBG:setTopBottom(false, true, -16, -4)
    Widget.CraftableItemCostBG:setRGB(0.1,0.1,0.1)
    --Widget:addElement(Widget.CraftableItemCostBG)

    Widget.CraftableItemCost = LUI.UIText.new()
    Widget.CraftableItemCost:setLeftRight(true, true, 4, -4)
    Widget.CraftableItemCost:setTopBottom(false, true, -16, -4)
    Widget.CraftableItemCost:setTTF("fonts/cwlight.ttf")
    --Widget:addElement(Widget.CraftableItemCost)

    Widget:linkToElementModel(Widget, "itemIcon", true, function(ModelRef)
        local icon = Engine.GetModelValue(ModelRef)
        if icon then
            Widget.CraftableItemIcon.itemIcon = icon
            Widget.CraftableItemIcon:setImage(RegisterImage(icon))
        end
    end)

    Widget:linkToElementModel(Widget, "cost", true, function(ModelRef)
        local cost = Engine.GetModelValue(ModelRef)
        if cost then
            local text = "$" .. tostring(cost)
            Widget.CraftableItemCost:setText(text)
            Widget.CraftableItemCost.costText = text
        end

        HudRef:updateElementState(Widget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = cost,
            modelName = "cost"
        })
    end)

    Widget:linkToElementModel(Widget, "name", true, function(ModelRef)
        local name = Engine.GetModelValue(ModelRef)

        HudRef:updateElementState(Widget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = name,
            modelName = "name"
        })
    end)

    Widget.clipsPerState = {
        DefaultState = {
            DefaultClip = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314, 0.552941176, 0.549019608)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.9, 0.9, 0.9)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            GainFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843, 0.77254902, 0.752941176)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                local function HandleFocusPipsClip(Sender, Event)
                    if not Event.interrupted then
                        Sender:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
                    end

                    Sender:setScale(1)
                    Sender:setAlpha(0.65)

                    if Event.interrupted then
                        Widget.clipFinished(Sender, Event)
                    else
                        Sender:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
                    end
                end

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setScale(1.1)
                Widget.focusPips:setAlpha(0.3)
                HandleFocusPipsClip(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            LoseFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314, 0.552941176, 0.549019608)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.focusPips:setScale(1.1)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.9, 0.9, 0.9)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            Focus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843, 0.77254902, 0.752941176)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0.65)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end
        },
        Locked = {
            DefaultClip = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314 - 0.23, 0.552941176 - 0.23, 0.549019608 - 0.23)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.5, 0.5, 0.5)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            GainFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843, 0.77254902, 0.752941176)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            LoseFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314, 0.552941176, 0.549019608)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.9, 0.9, 0.9)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            Focus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843, 0.77254902, 0.752941176)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end
        },
        ParentElement = {
            DefaultClip = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314, 0.552941176, 0.549019608)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.9, 0.9, 0.9)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            GainFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843, 0.77254902, 0.752941176)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                local function HandleFocusPipsClip(Sender, Event)
                    if not Event.interrupted then
                        Sender:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
                    end

                    Sender:setScale(1)
                    Sender:setAlpha(0.65)

                    if Event.interrupted then
                        Widget.clipFinished(Sender, Event)
                    else
                        Sender:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
                    end
                end

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setScale(1.1)
                Widget.focusPips:setAlpha(0.3)
                HandleFocusPipsClip(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            LoseFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314, 0.552941176, 0.549019608)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.focusPips:setScale(1.1)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.9, 0.9, 0.9)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            Focus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843, 0.77254902, 0.752941176)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0.65)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end
        },
        Owned = {
            DefaultClip = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843 - 0.05, 0.77254902 - 0.05, 0.752941176 - 0.05)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(1)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            GainFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843 + 0.05, 0.77254902 + 0.05, 0.752941176 + 0.05)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(1)
                Widget.clipFinished(Widget.OwnedGlow, {})

                local function HandleFocusPipsClip(Sender, Event)
                    if not Event.interrupted then
                        Sender:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
                    end

                    Sender:setScale(1)
                    Sender:setAlpha(0.65)

                    if Event.interrupted then
                        Widget.clipFinished(Sender, Event)
                    else
                        Sender:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
                    end
                end

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setScale(1.1)
                Widget.focusPips:setAlpha(0.3)
                HandleFocusPipsClip(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            LoseFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843 - 0.05, 0.77254902 - 0.05, 0.752941176 - 0.05)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(1)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.focusPips:setScale(1.1)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            Focus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.819607843 + 0.05, 0.77254902 + 0.05, 0.752941176 + 0.05)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(1)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0.65)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(1,1,1)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end
        },
        Disabled = {
            DefaultClip = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314 - 0.29, 0.552941176 - 0.29, 0.549019608 - 0.29)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.focusPips:setScale(1.1)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.5, 0.5, 0.5)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            GainFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314 - 0.29, 0.552941176 - 0.29, 0.549019608 - 0.29)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                local function HandleFocusPipsClip(Sender, Event)
                    if not Event.interrupted then
                        Sender:beginAnimation("keyframe", 120, false, false, CoD.TweenType.Linear)
                    end

                    Sender:setScale(1)
                    Sender:setAlpha(0.65)

                    if Event.interrupted then
                        Widget.clipFinished(Sender, Event)
                    else
                        Sender:registerEventHandler("transition_complete_keyframe", Widget.clipFinished)
                    end
                end

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setScale(1.1)
                Widget.focusPips:setAlpha(0.3)
                HandleFocusPipsClip(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.5, 0.5, 0.5)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            LoseFocus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314 - 0.29, 0.552941176 - 0.29, 0.549019608 - 0.29)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setAlpha(0)
                Widget.focusPips:setScale(1.1)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.5, 0.5, 0.5)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end,
            Focus = function()
                Widget:setupElementClipCounter(4)

                Widget.Background:completeAnimation()
                Widget.Background:setRGB(0.560784314 - 0.29, 0.552941176 - 0.29, 0.549019608 - 0.29)
                Widget.clipFinished(Widget.Background, {})

                Widget.OwnedGlow:completeAnimation()
                Widget.OwnedGlow:setAlpha(0)
                Widget.clipFinished(Widget.OwnedGlow, {})

                Widget.focusPips:completeAnimation()
                Widget.focusPips:setScale(1)
                Widget.focusPips:setAlpha(0.65)
                Widget.clipFinished(Widget.focusPips, {})

                Widget.CraftableItemIcon:completeAnimation()
                Widget.CraftableItemIcon:setRGB(0.5, 0.5, 0.5)
                Widget.CraftableItemIcon:setAlpha(1)
                Widget.clipFinished(Widget.CraftableItemIcon, {})
            end
        }
    }

    Widget.StateTable = {
        {
            stateName = "Owned",
            condition = function(ItemRef, HudRef, UpdateTable)
                local itemModel = Widget:getModel()
                if itemModel then
                    local nameModel = Engine.GetModel(itemModel, "name")
                    if nameModel then
                        local name = Engine.GetModelValue(nameModel)
                        if name then
                            local ownedItems = Engine.GetModelValue(Engine.GetModel(Engine.GetModelForController(InstanceRef), "cw_perk_buyables.owned_perks"))
                            if ownedItems then
                                local ownedItemsTable = LUI.splitString(ownedItems, "|")
                                if ownedItemsTable then
                                    for k,ownedItemName in pairs(ownedItemsTable) do
                                        if ownedItemName == name then
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                return false
            end
        },
        {
            stateName = "Locked",
            condition = function(ItemRef, HudRef, UpdateTable)
                local itemModel = Widget:getModel()
                if itemModel then
                    local roundLockModel = Engine.GetModel(itemModel, "roundLock")
                    if roundLockModel then
                        local roundLock = Engine.GetModelValue(roundLockModel)
                        if roundLock then
                            return IsModelValueLessThan(InstanceRef, "gameScore.roundsPlayed", roundLock + 1)
                        end
                    end
                end

                return false
            end
        },
        {
            stateName = "ParentElement",
            condition = function(ItemRef, HudRef, UpdateTable)
                local cost = Engine.GetModelValue(Engine.GetModel(Widget:getModel(), "cost"))
                if cost and cost == -1 then
                    return true
                end
                
                return false
            end
        },
        {
            stateName = "Disabled",
            condition = function(ItemRef, HudRef, UpdateTable)
                local score = Engine.GetModelValue(Engine.GetModel(Engine.GetModel(DataSources.ZMPlayerList.getModel(InstanceRef), "0"), "playerScore"))
                local cost = Engine.GetModelValue(Engine.GetModel(Widget:getModel(), "cost"))

                if score == nil or cost == nil then
                    return false
                end

                return tonumber(score) < tonumber(cost)
            end
        }
    }
    Widget:mergeStateConditions(Widget.StateTable)

    Widget:subscribeToModel(Engine.GetModel(Engine.GetModel(DataSources.ZMPlayerList.getModel(InstanceRef), "0"), "playerScore"), function(ModelRef)
        HudRef:updateElementState(Widget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "PlayerList.0.playerScore"
        })
    end)

    Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "gameScore.roundsPlayed"), function(ModelRef)
        HudRef:updateElementState(Widget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "gameScore.roundsPlayed"
        })
    end)

    Widget:subscribeToModel(Engine.GetModel(Engine.GetModelForController(InstanceRef), "cw_perk_buyables.owned_perks"), function(ModelRef)
        HudRef:updateElementState(Widget, {
            name = "model_validation",
            menu = HudRef,
            modelValue = Engine.GetModelValue(ModelRef),
            modelName = "cw_perk_buyables.owned_perks"
        })
    end)

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

    Widget:registerEventHandler("mouseenter", function(Sender, Event)
        Sender:processEvent({name = "gain_focus", controller = InstanceRef})
    end)

    LUI.OverrideFunction_CallOriginalSecond(Widget, "close", function(Widget)
        Widget.Background:close()
        Widget.focusPips:close()
        Widget.OwnedGlow:close()
        Widget.CraftableItemIcon:close()
    end)

    return Widget
end