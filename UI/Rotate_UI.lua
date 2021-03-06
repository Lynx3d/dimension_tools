﻿local Dta = select(2, ...)

Dta.rotate_ui = {}

-------------------------------
-- BUILD THE DIMENSIONTOOLS RotateWINDOW
-------------------------------

local RotateWindowSettings = {
	WIDTH = 305,
	HEIGHT = 130,
	CLOSABLE = true,
	MOVABLE = true,
	POS_X = "RotatewindowPosX",
	POS_Y = "RotatewindowPosY"
}

function Dta.rotate_ui.buildRotateWindow()
	local x = Dta.settings.get("RotatewindowPosX")
	local y = Dta.settings.get("RotatewindowPosY")
	local newWindow = Dta.ui.Window.Create("RotateWindow",
							Dta.ui.context,
							Dta.Locale.Titles.Rotate,
							RotateWindowSettings.WIDTH,
							RotateWindowSettings.HEIGHT,
							x,
							y,
							RotateWindowSettings.CLOSABLE,
							RotateWindowSettings.MOVABLE,
							Dta.rotate_ui.hideRotateWindow,
							Dta.ui.WindowMoved
							)
	newWindow.settings = RotateWindowSettings
	local Rotatewindow = newWindow.content

	Rotatewindow.background2 = UI.CreateFrame("Texture", "RotatewindowBackground2", Rotatewindow)
	Rotatewindow.background2:SetPoint("BOTTOMCENTER", Rotatewindow, "BOTTOMCENTER")
	Rotatewindow.background2:SetWidth(RotateWindowSettings.WIDTH)
	Rotatewindow.background2:SetHeight(80)
	Rotatewindow.background2:SetAlpha(0.3)
	Rotatewindow.background2:SetTexture("Rift", "dimensions_tools_header.png.dds")
	Rotatewindow.background2:SetLayer(5)

	-------------------------------
	--ITEM DETAILS
	-------------------------------
	Rotatewindow.modifyRotation = Dta.ui.createFrame("modifyRotation", Rotatewindow, 10, 5, Rotatewindow:GetWidth()-20, Rotatewindow:GetHeight()-20)
	Rotatewindow.modifyRotation:SetLayer(30)
	--Rotatewindow.modifyRotation:SetBackgroundColor(1, 0, 0, 0.5) --Debug

	Rotatewindow.modifyRotation.pitchLabel = Dta.ui.createText("modifyRotationPitchLabel", Rotatewindow.modifyRotation, 0, 0, Dta.Locale.Text.Pitch, 14, {1, 0, 0, 1})
	Rotatewindow.modifyRotation.yawLabel = Dta.ui.createText("modifyRotationYawLabel", Rotatewindow.modifyRotation, 0, 25, Dta.Locale.Text.Yaw, 14, {0, 1, 0, 1})
	Rotatewindow.modifyRotation.rollLabel = Dta.ui.createText("modifyRotationRollLabel", Rotatewindow.modifyRotation, 0, 50, Dta.Locale.Text.Roll, 14, {0, 1, 1, 1})

	Rotatewindow.modifyRotation.pitch = Dta.ui.createTextfield("modifyRotationPitch", Rotatewindow.modifyRotation, 40, 0, 85)
	Rotatewindow.modifyRotation.yaw = Dta.ui.createTextfield("modifyRotationYaw", Rotatewindow.modifyRotation, 40, 25, 85)
	Rotatewindow.modifyRotation.roll = Dta.ui.createTextfield("modifyRotationRoll", Rotatewindow.modifyRotation, 40, 50, 85)

	Rotatewindow.modifyRotation.fetchPitch = Dta.ui.createReloadButton("fetchPitch", Rotatewindow.modifyRotation, 125, 0, Dta.rotate.fetchPitchButtonClicked)
	Rotatewindow.modifyRotation.fetchYaw = Dta.ui.createReloadButton("fetchYaw", Rotatewindow.modifyRotation, 125, 25, Dta.rotate.fetchYawButtonClicked)
	Rotatewindow.modifyRotation.fetchRoll = Dta.ui.createReloadButton("fetchRoll", Rotatewindow.modifyRotation, 125, 50, Dta.rotate.fetchRollButtonClicked)
	Rotatewindow.modifyRotation.fetchPitch:EventAttach(Event.UI.Input.Mouse.Right.Click, Dta.rotate.fetchAllButtonClicked, "FetchAllRot")
	Rotatewindow.modifyRotation.fetchYaw:EventAttach(Event.UI.Input.Mouse.Right.Click, Dta.rotate.fetchAllButtonClicked, "FetchAllRot")
	Rotatewindow.modifyRotation.fetchRoll:EventAttach(Event.UI.Input.Mouse.Right.Click, Dta.rotate.fetchAllButtonClicked, "FetchAllRot")

	Rotatewindow.modifyRotation.modeAbs = Dta.ui.createCheckbox("modifyRotationModeAbs", Rotatewindow.modifyRotation, 160, 0, Dta.Locale.Text.Absolute, true, nil, Dta.rotate.modifyRotationModeAbsChanged)
	Rotatewindow.modifyRotation.modeRel = Dta.ui.createCheckbox("modifyRotationModeRel", Rotatewindow.modifyRotation, 160, 20, Dta.Locale.Text.Relative, false, nil, Dta.rotate.modifyRotationModeRelChanged)
	Rotatewindow.modifyRotation.modeAsGrp = Dta.ui.createCheckbox("modifyPositionMoveAsGrp", Rotatewindow.modifyRotation, 175, 40, Dta.Locale.Text.MoveAsGroup, false, nil, Dta.rotate.ModeAsGroupChanged)
	Rotatewindow.modifyRotation.modeAsGrp:CBSetEnabled(false)
	Rotatewindow.modifyRotation.modeLocal = Dta.ui.createCheckbox("modifyRotationModeLocal", Rotatewindow.modifyRotation, 175, 60, Dta.Locale.Text.LocalAxes, false, nil, Dta.rotate.ModeLocalAxesChanged)
	Rotatewindow.modifyRotation.modeLocal:CBSetEnabled(false)

	Rotatewindow.modifyRotation.changeBtn = Dta.ui.createButton("modifyRotationBtn", Rotatewindow.modifyRotation, 0, 85, nil, nil, Dta.Locale.Buttons.Rotate, nil, Dta.rotate.modifyRotationButtonClicked)
	Rotatewindow.modifyRotation.resetBtn = Dta.ui.createButton("modifyRotationResetBtn", Rotatewindow.modifyRotation, 150, 85, nil, nil, Dta.Locale.Buttons.Reset, nil, Dta.rotate.modifyRotationResetButtonClicked)

	Dta.ui.AddFocusCycleElement(Rotatewindow, Rotatewindow.modifyRotation.pitch)
	Dta.ui.AddFocusCycleElement(Rotatewindow, Rotatewindow.modifyRotation.yaw)
	Dta.ui.AddFocusCycleElement(Rotatewindow, Rotatewindow.modifyRotation.roll)
	Rotatewindow:EventAttach(Event.UI.Input.Key.Down.Dive, Dta.ui.FocusCycleCallback, "RotateWindow_TabFocusCycle")

	-- TODO: temp fix for new window hierarchy
	newWindow.modifyRotation = Rotatewindow.modifyRotation
	return newWindow
end

-- Show the toolbox window
function Dta.rotate_ui.showRotateWindow(rotate_window)
	rotate_window:SetVisible(true)
end

-- Hide the toolbox window
function Dta.rotate_ui.hideRotateWindow(rotate_window)
	rotate_window:SetVisible(false)
	rotate_window:ClearKeyFocus()
end

Dta.RegisterTool("Rotate", Dta.rotate_ui.buildRotateWindow, Dta.rotate_ui.showRotateWindow, Dta.rotate_ui.hideRotateWindow)
