require("ui.uieditor.widgets.Wonderfizz.PerkTabBarListItem")
require("ui.uieditor.widgets.Wonderfizz.MenuTabPerks")

CoD.PerkMenuTabBar = InheritFrom(LUI.UIElement)
CoD.PerkMenuTabBar.SizeTabsToWidth = function(TabBar, Width)
    TabBar:setLeftRight(false, false, (-Width*3)/2, (Width*3)/2)
	for k, v in LUI.IterateTableBySortedKeys(TabBar.grid.layoutItems) do
		for i, j in LUI.IterateTableBySortedKeys(v) do
			j:setLeftRight(true, false, 0, Width)
		end
	end

    TabBar.grid:updateLayout()
end

-- Datasource for populating our list with elements
DataSources.TabsSource = DataSourceHelpers.ListSetup("TabsSource", function(InstanceRef)
    local dataTable = {}

    local function AddTab(tabName, tabWidget, tabId, tabIcon)
        table.insert(dataTable, {
            models = {
                tabName = tabName,
                tabWidget = tabWidget,
                tabIcon = tabIcon
            },
            properties = {
                tabId = tabId
            }
        })
    end

    AddTab("Perks", "CoD.MenuTabPerks", "perks", "")

    return dataTable
end, true)

local function PostLoadCallback(Widget, InstanceRef, HudRef)
	HudRef:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_LB, nil, function(f3_arg0, f3_arg1, f3_arg2, f3_arg3)
		if not PropertyIsTrue(Widget, "m_disableNavigation") then
			Widget.grid:navigateItemLeft()
		end
	end, AlwaysFalse, false)
	HudRef:AddButtonCallbackFunction(HudRef, InstanceRef, Enum.LUIButton.LUI_KEY_RB, nil, function(f4_arg0, f4_arg1, f4_arg2, f4_arg3)
		if not PropertyIsTrue(Widget, "m_disableNavigation") then
			Widget.grid:navigateItemRight()
		end
	end, AlwaysFalse, false)
	Widget:setForceMouseEventDispatch(true)
end

function CoD.PerkMenuTabBar.new(HudRef, InstanceRef) 
    local Widget = LUI.UIElement.new()
    Widget:setClass(CoD.PerkMenuTabBar)
    Widget.id = "PerkMenuTabBar"
    Widget.soundSet = "default"
    Widget:setUseStencil(false)

    Widget:setLeftRight(true, true, 0, 0)
    Widget:setTopBottom(true, true, 0, 0)

    Widget.anyChildUsesUpdateState = true
    Widget.onlyChildrenFocusable = true

	Widget.grid = LUI.GridLayout.new(HudRef, InstanceRef, true, 0, 0, 0, 0, nil, nil, false, false, 0, 0, false, false)
	Widget.grid:setLeftRight(true, true, 0, 0)
	Widget.grid:setTopBottom(true, true, 0, 0)
	Widget.grid:setWidgetType(CoD.PerkTabBarListItem)
    Widget.grid:setDataSource("TabsSource")
	Widget.grid:setHorizontalCount(1)

	Widget.grid:registerEventHandler("menu_loaded", function(Sender, Event)
		local success = nil
		UpdateDataSource(Widget, Sender, InstanceRef)
		if not success then
			success = Sender:dispatchEventToChildren(Event)
		end
		return success
	end)

	Widget.grid:registerEventHandler("mouse_left_click", function(Sender, Event)
		local success = nil
		SelectItemIfPossible(Widget, Sender, InstanceRef, Event)
		PlaySoundSetSound(Widget, "list_right")
		if not success then
			success = Sender:dispatchEventToChildren(Event)
		end
		return success
	end)

	Widget:addElement(Widget.grid)


    if PostLoadCallback then
        PostLoadCallback(Widget, InstanceRef, HudRef)
    end

    return Widget
end