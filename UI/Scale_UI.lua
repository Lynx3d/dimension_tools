﻿local Dta = select(2, ...)
local Lang = Dta.Lang

Dta.scale_ui = {}

-------------------------------
-- BUILD THE DIMENSIONTOOLS SCALEWINDOW
-------------------------------

local ScaleWindowSettings = {
	TITLE = Lang[Dta.Language].Titles.Scale,
	WIDTH = 305,
	HEIGHT = 130,
	CLOSABLE = true,
	MOVABLE = true,
}

function Dta.scale_ui.buildScaleWindow()
	local x = Dta.settings.get("ScalewindowPosX")
	local y = Dta.settings.get("ScalewindowPosY")
	local newWindow = Dta.ui.Window.Create("Scalewindow",
							Dta.ui.context,
							ScaleWindowSettings.TITLE,
							ScaleWindowSettings.WIDTH,
							ScaleWindowSettings.HEIGHT,
							x,
							y,
							ScaleWindowSettings.CLOSABLE,
							ScaleWindowSettings.MOVABLE,
							Dta.scale_ui.ScaleWindowClosed,
							Dta.scale_ui.ScaleWindowMoved
							)
	local Scalewindow = newWindow.content

	Scalewindow.background2 = UI.CreateFrame("Texture", "ScaleWindowBackground2", Scalewindow)
	Scalewindow.background2:SetPoint("BOTTOMCENTER", Scalewindow, "BOTTOMCENTER")
	Scalewindow.background2:SetWidth(ScaleWindowSettings.WIDTH)
	Scalewindow.background2:SetHeight(80)
	Scalewindow.background2:SetAlpha(0.3)
	Scalewindow.background2:SetTexture("Rift", "dimensions_tools_header.png.dds")
	Scalewindow.background2:SetLayer(5)

	-------------------------------
	--ITEM DETAILS
	-------------------------------

	Scalewindow.modifyScale = Dta.ui.createFrame("modifyScale", Scalewindow, 10, 5, Scalewindow:GetWidth()-20, Scalewindow:GetHeight()-20)
	Scalewindow.modifyScale:SetLayer(30)
	--Scalewindow.modifyScale:SetBackgroundColor(1, 0, 0, 0.5) --Debug

	Scalewindow.modifyScale.label = Dta.ui.createText("modifyScaleLabel", Scalewindow.modifyScale, 75, 0, Lang[Dta.Language].Text.Scale, 14)

	Scalewindow.modifyScale.scale = Dta.ui.createTextfield("modifyScaleScale", Scalewindow.modifyScale, 120, 0, 100)

	Scalewindow.modifyScale.modeAbs = Dta.ui.createCheckbox("modifyScaleModeAbs", Scalewindow.modifyScale, 45, 30, Lang[Dta.Language].Text.Absolute, true, nil, Dta.scale.modifyScaleModeAbsChanged)
	Scalewindow.modifyScale.modeRel = Dta.ui.createCheckbox("modifyScaleModeRel", Scalewindow.modifyScale, 175, 30, Lang[Dta.Language].Text.Relative, false, nil, Dta.scale.modifyScaleModeRelChanged)
	Scalewindow.modifyScale.modeGrp = Dta.ui.createCheckbox("modifyScaleModeGrp", Scalewindow.modifyScale, 175, 50, Lang[Dta.Language].Text.ScaleAsGroup, false, nil, nil)

	Scalewindow.modifyScale.changeBtn = Dta.ui.createButton("modifyScaleBtn", Scalewindow.modifyScale, 0, 85, nil, nil, Lang[Dta.Language].Buttons.Scale, nil, Dta.scale.modifyScaleButtonClicked)
	Scalewindow.modifyScale.resetBtn = Dta.ui.createButton("modifyScaleResetBtn", Scalewindow.modifyScale, 150, 85, nil, nil, Lang[Dta.Language].Buttons.Reset, nil, Dta.scale.modifyScaleResetButtonClicked)

	-- TODO: temp fix for new window hierarchy
	newWindow.modifyScale = Scalewindow.modifyScale

	return newWindow
end

-- Show the toolbox window
function Dta.scale_ui.showScaleWindow()
	if Dta.ui.windowScale == nil then
		Dta.ui.windowScale = Dta.scale_ui.buildScaleWindow()
	else
		Dta.scale_ui.windowScale:SetVisible(true)
	end
	Dta.ui.activeScale = true
end

-- Hide the toolbox window
function Dta.scale_ui.hideScaleWindow()
	Dta.ui.windowScale:SetVisible(false)
	Dta.ui.windowScale = nil
	Dta.ui.activeScale = false
end

-- Toggle the toolbox window
function Dta.scale_ui.toggleScaleWindow()
	if Dta.ui.windowScale then Dta.scale_ui.hideScaleWindow()
	else Dta.scale_ui.showScaleWindow() end
end

--Called when the window has been closed
function Dta.scale_ui.ScaleWindowClosed()
	Dta.scale_ui.hideScaleWindow()
end

--Called when the window has been moved
function Dta.scale_ui.ScaleWindowMoved()
	Dta.settings.set("ScalewindowPosX", Dta.ui.windowScale:GetLeft())
	Dta.settings.set("ScalewindowPosY", Dta.ui.windowScale:GetTop())
end
