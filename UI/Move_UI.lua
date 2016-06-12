﻿local Dta = select(2, ...)

Dta.move_ui = {}

-------------------------------
-- BUILD THE DIMENSIONTOOLS MOVEWINDOW
-------------------------------

local MoveWindowSettings = {
	WIDTH = 305,
	HEIGHT = 130,
	CLOSABLE = true,
	MOVABLE = true,
	POS_X = "MovewindowPosX",
	POS_Y = "MovewindowPosY"
}

function Dta.move_ui.buildMoveWindow()
	local x = Dta.settings.get("MovewindowPosX")
	local y = Dta.settings.get("MovewindowPosY")

	local newWindow = Dta.ui.Window.Create("MoveWindow",
							Dta.ui.context,
							Dta.Locale.Titles.Move,
							MoveWindowSettings.WIDTH,
							MoveWindowSettings.HEIGHT,
							x,
							y,
							MoveWindowSettings.CLOSABLE,
							MoveWindowSettings.MOVABLE,
							Dta.move_ui.MoveWindowClosed,
							Dta.ui.WindowMoved
							)
	newWindow.settings = MoveWindowSettings
	local Movewindow = newWindow.content

	Movewindow.background2 = UI.CreateFrame("Texture", "MoveWindowBackground2", Movewindow)
	Movewindow.background2:SetPoint("BOTTOMCENTER", Movewindow, "BOTTOMCENTER")
	Movewindow.background2:SetWidth(MoveWindowSettings.WIDTH)
	Movewindow.background2:SetHeight(80)
	Movewindow.background2:SetAlpha(0.3)
	Movewindow.background2:SetTexture("Rift", "dimensions_tools_header.png.dds")
	Movewindow.background2:SetLayer(5)

	-------------------------------
	--ITEM DETAILS
	-------------------------------

	Movewindow.modifyPosition = Dta.ui.createFrame("modifyPosition", Movewindow, 10, 5, Movewindow:GetWidth()-20, Movewindow:GetHeight()-20)
	Movewindow.modifyPosition:SetLayer(30)
	--Movewindow.modifyPosition:SetBackgroundColor(1, 0, 0, 0.5) --Debug

	Movewindow.modifyPosition.xLabel = Dta.ui.createText("modifyPositionXLabel", Movewindow.modifyPosition, 0, 0, "X", 14, {1, 0, 0, 1})
	Movewindow.modifyPosition.yLabel = Dta.ui.createText("modifyPositionYLabel", Movewindow.modifyPosition, 0, 25, "Y", 14, {0, 1, 0, 1})
	Movewindow.modifyPosition.zLabel = Dta.ui.createText("modifyPositionZLabel", Movewindow.modifyPosition, 0, 50, "Z", 14, {0, 1, 1, 1})

	Movewindow.modifyPosition.x = Dta.ui.createTextfield("modifyPositionX", Movewindow.modifyPosition, 20, 0, 105)
	Movewindow.modifyPosition.y = Dta.ui.createTextfield("modifyPositionY", Movewindow.modifyPosition, 20, 25, 105)
	Movewindow.modifyPosition.z = Dta.ui.createTextfield("modifyPositionZ", Movewindow.modifyPosition, 20, 50, 105)

	Movewindow.modifyPosition.fetchX = Dta.ui.createReloadButton("fetchX", Movewindow.modifyPosition, 125, 0, Dta.move.fetchXButtonClicked)
	Movewindow.modifyPosition.fetchY = Dta.ui.createReloadButton("fetchY", Movewindow.modifyPosition, 125, 25, Dta.move.fetchYButtonClicked)
	Movewindow.modifyPosition.fetchZ = Dta.ui.createReloadButton("fetchZ", Movewindow.modifyPosition, 125, 50, Dta.move.fetchZButtonClicked)
	Movewindow.modifyPosition.fetchX:EventAttach(Event.UI.Input.Mouse.Right.Click, Dta.move.fetchAllButtonClicked, "FetchAll")
	Movewindow.modifyPosition.fetchY:EventAttach(Event.UI.Input.Mouse.Right.Click, Dta.move.fetchAllButtonClicked, "FetchAll")
	Movewindow.modifyPosition.fetchZ:EventAttach(Event.UI.Input.Mouse.Right.Click, Dta.move.fetchAllButtonClicked, "FetchAll")

	Movewindow.modifyPosition.modeAbs = Dta.ui.createCheckbox("modifyPositionModeAbs", Movewindow.modifyPosition, 160, 5, Dta.Locale.Text.Absolute, true, nil, Dta.move.modifyPositionModeAbsChanged)
	Movewindow.modifyPosition.modeRel = Dta.ui.createCheckbox("modifyPositionModeRel", Movewindow.modifyPosition, 160, 45, Dta.Locale.Text.Relative, false, nil, Dta.move.modifyPositionModeRelChanged)

	Movewindow.modifyPosition.moveAsGrp = Dta.ui.createCheckbox("modifyPositionMoveAsGrp", Movewindow.modifyPosition, 175, 25, Dta.Locale.Text.MoveAsGroup, false)
	Movewindow.modifyPosition.moveAsGrp:SetVisible(Dta.selectionCount > 1)

	Movewindow.modifyPosition.changeBtn = Dta.ui.createButton("modifyPositionBtn", Movewindow.modifyPosition, 0, 85, nil, nil, Dta.Locale.Buttons.Move, nil, Dta.move.modifyPositionButtonClicked)
	Movewindow.modifyPosition.resetBtn = Dta.ui.createButton("modifyPositionResetBtn", Movewindow.modifyPosition, 150, 85, nil, nil, Dta.Locale.Buttons.Reset, nil, Dta.move.modifyPositionResetButtonClicked)

	Dta.ui.AddFocusCycleElement(Movewindow, Movewindow.modifyPosition.x)
	Dta.ui.AddFocusCycleElement(Movewindow, Movewindow.modifyPosition.y)
	Dta.ui.AddFocusCycleElement(Movewindow, Movewindow.modifyPosition.z)
	Movewindow:EventAttach(Event.UI.Input.Key.Up.Dive, Dta.ui.FocusCycleCallback, "MoveWindow_TabFocusCycle")

	-- TODO: temp fix for new window hierarchy
	newWindow.modifyPosition = Movewindow.modifyPosition

	return newWindow -- Movewindow
end

-- Show the toolbox window
function Dta.move_ui.showMoveWindow()
	if Dta.ui.windowMove == nil then
		Dta.ui.windowMove = Dta.move_ui.buildMoveWindow()
	else
		Dta.ui.windowMove:SetVisible(true)
	end
	Dta.ui.activeMove = true
end

-- Hide the toolbox window
function Dta.move_ui.hideMoveWindow()
	Dta.ui.windowMove:SetVisible(false)
	Dta.ui.windowMove:ClearKeyFocus()
--	Dta.ui.windowMove = nil
	Dta.ui.activeMove = false
end

-- Toggle the toolbox window
function Dta.move_ui.toggleMoveWindow()
	if Dta.ui.activeMove then Dta.move_ui.hideMoveWindow()
	else Dta.move_ui.showMoveWindow() end
end

--Called when the window has been closed
function Dta.move_ui.MoveWindowClosed()
	Dta.move_ui.hideMoveWindow()
end
