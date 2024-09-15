require("UI.LUI.LUIList")

CoD.PerksUIListWidget = InheritFrom(LUI.UIList)

local function PostLoadCallback(Widget, InstanceRef, HudRef)
    Widget:SetSpacingAndPadding(2)
    Widget:SetItemSize(16)

    LUI.OverrideFunction_CallOriginalSecond(Widget, "SetActiveDataSource", function(List, DataSourceName, Event)
        local parent = List:getParent()
        if parent then
            parent.ItemNameText:setText("")
            parent.DescriptionText:setText("")
        end
    end)
end

function CoD.PerksUIListWidget.new(HudRef, InstanceRef)
    local Widget = LUI.UIList.new(HudRef, InstanceRef, 0, 0, nil, true, false, 0, 0, false, false)
    Widget.id = "PerksUIListWidget"

    -- Can't make new class, so these have to be inside Widget
    Widget.ScaleListAndBackgroundForElementCount = function(List)
        local Background = List:getParent()
        if Background and Background.CraftablesListBacking and List.spacingAndPadding and List.itemSize then
            local ListBacking = Background.CraftablesListBacking
            local buyablesDatasource = List:getDataSource()
            if buyablesDatasource then
                local buyablesCount = buyablesDatasource.getCount(List)
                if buyablesCount then
                    local countPerRow = math.ceil(buyablesCount / 2)
                    if countPerRow < 6 then
                        countPerRow = 6
                    end
                    List:setHorizontalCount(countPerRow)

                    local halfSize = List.hCount * (List.itemSize / 2)
                    local roomForLeftRightSpacing = ((List.hCount) * List.spacingAndPadding) + (List.itemSize / 2)

                    -- Round up so we don't get werid rows that need extra scrolling..
                    local rowCount = math.ceil(buyablesCount / List.hCount)
                    List:setVerticalCount(rowCount)

                    local roomForTopBottomSpacing = (rowCount-1) * List.spacingAndPadding

                    Background:setLeftRight(false, false, -halfSize - roomForLeftRightSpacing / 2, halfSize + roomForLeftRightSpacing / 2)
                    Background:setTopBottom(false, false, 0 + 26.5, 72 + 26.5 + List.itemSize*rowCount + roomForTopBottomSpacing)

                    --HudRef.CustomTabBar:SizeTabsToWidth(math.abs(halfSize + roomForLeftRightSpacing / 2 - (-halfSize - roomForLeftRightSpacing / 2)) / 3)

                    -- List backing should be size of list + 8 on width both sides, +8 on height both sides
                    ListBacking:setLeftRight(false, false, -8 -halfSize - roomForLeftRightSpacing / 2 + List.itemSize / 4, halfSize + roomForLeftRightSpacing / 2 - List.itemSize / 4 + 8)
                    ListBacking:setTopBottom(true, false, 36-8, 36 + 8*rowCount + List.itemSize*rowCount)

                    List:setLeftRight(false, false, -halfSize - roomForLeftRightSpacing / 2 + List.itemSize / 4, halfSize + roomForLeftRightSpacing / 2 - List.itemSize / 4)
                    List:setTopBottom(true, false, 72, 72 + List.itemSize*rowCount)
                    List:setSpacing(List.spacingAndPadding)
                end
            end
        end
    end

    Widget.SetSpacingAndPadding = function(List, SpacingSize)
        List.spacingAndPadding = SpacingSize
    end

    Widget.SetItemSize = function(List, ItemSize)
        List.itemSize = ItemSize
    end

    Widget.SetDataSources = function(List, PrimaryDataSource, SecondaryDataSource)
        List:setDataSource(PrimaryDataSource)
        List.primaryDataSource = PrimaryDataSource
        List.secondaryDataSource = SecondaryDataSource
    end

    Widget.IsCurrentDataSourceEqualTo = function(List, DataSourceName)
        local currentDataSourceName = List.dataSourceName
        if currentDataSourceName and DataSourceName then
            if currentDataSourceName == DataSourceName then
                return true
            end
        end

        return false
    end

    Widget.SetActiveDataSource = function(List, DataSourceName, Event)
        local focusItem = nil
        List:setDataSource(DataSourceName)

        if Event then
            if Event.filter then
                List:getDataSource().setCurrentFilterItem(Event.filter)
                List:updateDataSource()
            end

            if Event.focusOnLastActiveItem then
                focusItem = List.lastActiveItem
            end
        end

        List:setActiveItem(focusItem or List:getFirstSelectableItem())

        if focusItem then
            List.lastActiveItem = nil
        end

        List:ScaleListAndBackgroundForElementCount()
    end

    Widget:registerEventHandler("list_item_gain_focus", function(Sender, Event)
        if Sender.m_focusable then
            local parent = Widget:getParent()
            if parent then
                local itemNameText = parent.ItemNameText
                local descriptionText = parent.DescriptionText
                local costText = parent.CostText
                local costIcon = parent.CostIcon
                local costWord = parent.CostWord
                if IsSelfInState(Sender, "Locked") then
                    local roundLock = Engine.GetModelValue(Engine.GetModel(Sender:getModel(), "roundLock"))
                    if roundLock then
                        parent.DescriptionText:setText(Engine.Localize("NOT ENOUGH MONEY"))
                    end
                elseif IsSelfInState(Sender, "Owned") then
                    if costText and costIcon and costWord then
                        costText:setAlpha(0)
                        costIcon:setAlpha(0)
                        costWord:setAlpha(0)
                    end
                else
                    if itemNameText and descriptionText and costText and costIcon and costWord then
                        costText:setAlpha(1)
                        costIcon:setAlpha(1)
                        costWord:setAlpha(1)
                        itemNameText:setText(LocalizeToUpperString(Engine.GetModelValue(Engine.GetModel(Sender:getModel(), "text"))))
                        descriptionText:setText(Engine.Localize(Engine.GetModelValue(Engine.GetModel(Sender:getModel(), "description"))))
                        costText:setText(Engine.Localize(Engine.GetModelValue(Engine.GetModel(Sender:getModel(), "cost"))))
                        local textWidth = costText:getTextWidth()
                        local scoreIconStartRight = -9
                        local scoreIconWidth = 14
                        costIcon:setLeftRight(false, true, scoreIconStartRight - scoreIconWidth - textWidth, scoreIconStartRight - textWidth)
                        local leftAnchor, rightAnchor, left, right = costIcon:getLocalLeftRight()
                        costWord:setLeftRight(leftAnchor, rightAnchor, left - 19, right - 19)
                    end
                end
            end     
        end
    end)

    -- B callback needs to be on the menu instead of the list item so we can go back and close when unfocused..
    HudRef:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function(ItemRef, HudRef, InstanceRef, arg3)
        if Widget:IsCurrentDataSourceEqualTo(Widget.primaryDataSource) then
            PlaySoundSetSound(HudRef, "menu_go_back")
            HudRef:close()
            return true
        else
            if Widget:IsCurrentDataSourceEqualTo(Widget.secondaryDataSource) and Widget.primaryDataSource then
                PlaySoundSetSound(HudRef, "menu_no_selection")
                Widget:SetActiveDataSource(Widget.primaryDataSource, {focusOnLastActiveItem = true})
            end
        end

        return true
    end, function(ItemRef, HudRef, InstanceRef)
        if Widget:IsCurrentDataSourceEqualTo(Widget.primaryDataSource) and Widget.primaryDataSource then
            CoD.Menu.SetButtonLabel(HudRef, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "Close")
            return true
        else
            if Widget:IsCurrentDataSourceEqualTo(Widget.secondaryDataSource) and Widget.secondaryDataSource then
                CoD.Menu.SetButtonLabel(HudRef, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MENU_BACK")
                return true
            end
        end

        return false
    end, true)

    HudRef:AddButtonCallbackFunction(Widget, InstanceRef, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function(ItemRef, HudRef, InstanceRef, arg3)
        if IsSelfInState(ItemRef, "Disabled") or IsSelfInState(ItemRef, "Owned") then
            return false
        end
        if Widget:IsCurrentDataSourceEqualTo(Widget.primaryDataSource) and Widget.secondaryDataSource then
            if not IsSelfInState(ItemRef, "Disabled") and not IsSelfInState(ItemRef, "Locked") then
                PlaySoundSetSound(HudRef, "action")
                local responseStr = Engine.GetModelValue(Engine.GetModel(Widget:getModel(), "responseStr"))
                Widget.lastActiveItem = Widget.activeWidget
                Widget:SetActiveDataSource(Widget.secondaryDataSource, {filter = responseStr .. "_"})
            end

            return true
        else
            if not IsSelfInState(ItemRef, "Disabled") and not IsSelfInState(ItemRef, "Locked") then
                PlaySoundSetSound(HudRef, "action")
                Engine.SendMenuResponse(InstanceRef, "WonderfizzMenuBase", Engine.GetModelValue(Engine.GetModel(ItemRef:getModel(), "responseStr")))
            end

            return true 
        end
    end, function(ItemRef, HudRef, InstanceRef)
        if not IsSelfInState(ItemRef, "Disabled") and not IsSelfInState(ItemRef, "Locked") then

            return true
        end

        return false
    end, true)

    if PostLoadCallback then
        PostLoadCallback(Widget, InstanceRef, HudRef)
    end

    return Widget
end