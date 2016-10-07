local Dta = select(2, ...)

local ReskinWindowSettings = {
	WIDTH = 315,
	HEIGHT = 250,
	CLOSABLE = true,
	MOVABLE = true,
	POS_X = "ReskinwindowPosX",
	POS_Y = "ReskinwindowPosY"
}

function Dta.ui.buildReskinWindow()
	local Locale = Dta.Locale
	local x = Dta.settings.get("ReskinwindowPosX")
	local y = Dta.settings.get("ReskinwindowPosY")

	local newWindow = Dta.ui.Window.Create("ReskinWindow",
							Dta.ui.context,
							Locale.Titles.Reskin,
							ReskinWindowSettings.WIDTH,
							ReskinWindowSettings.HEIGHT,
							x, y,
							ReskinWindowSettings.CLOSABLE,
							ReskinWindowSettings.MOVABLE,
							Dta.ui.hideReskinWindow,
							Dta.ui.WindowMoved
							)
	local reskinWindow = newWindow.content
	newWindow.settings = ReskinWindowSettings

	newWindow.oldFilterLabel = Dta.ui.createText("OldSkinFilter", reskinWindow, 10, 5, Locale.Text.Category, 14)
	newWindow.oldFilterSelect = Dta.ui.createDropdown("OldCategorySelect", reskinWindow, 120, 5, 180)
	newWindow.oldFilterSelect:SetItems(Dta.Replacement.loadSkinCategories())
	newWindow.oldFilterSelect:SetSelectedIndex(1)
	newWindow.oldFilterSelect.Event.ItemSelect = Dta.Replacement.FilterOldChanged
	newWindow.oldSkinLabel = Dta.ui.createText("OldSkinLabel", reskinWindow, 10, 30, Locale.Text.OldSkin, 14)
	newWindow.oldSkinSelect = Dta.ui.createDropdown("OldSkinSelect", reskinWindow, 120, 30, 180)
	newWindow.oldSkinSelect:SetItems(Dta.Replacement.loadSkins())

	newWindow.newFilterLabel = Dta.ui.createText("NewSkinFilter", reskinWindow, 10, 55, Locale.Text.Category, 14)
	newWindow.newFilterSelect = Dta.ui.createDropdown("OldCategorySelect", reskinWindow, 120, 55, 180)
	newWindow.newFilterSelect:SetItems(Dta.Replacement.loadSkinCategories())
	newWindow.newFilterSelect:SetSelectedIndex(1)
	newWindow.newFilterSelect.Event.ItemSelect = Dta.Replacement.FilterNewChanged
	newWindow.newSkinLabel = Dta.ui.createText("NewSkinLabel", reskinWindow, 10, 80, Locale.Text.NewSkin, 14)
	newWindow.newSkinSelect = Dta.ui.createDropdown("NewSkinSelect", reskinWindow, 120, 80, 180)
	newWindow.newSkinSelect:SetItems(Dta.Replacement.loadSkins())

	newWindow.tile = Dta.ui.createCheckbox("replaceTiles", reskinWindow, 20, 110, Locale.Text.Tile, true)
	newWindow.rectangle = Dta.ui.createCheckbox("replaceRectangle", reskinWindow, 20, 135, Locale.Text.Rectangle, true)
	newWindow.triangle = Dta.ui.createCheckbox("replaceTriangles", reskinWindow, 20, 160, Locale.Text.Triangle, true)
	newWindow.plank = Dta.ui.createCheckbox("replacePlanks", reskinWindow, 20, 185, Locale.Text.Plank, true)
	--
	newWindow.cube = Dta.ui.createCheckbox("replaceCubes", reskinWindow, 155, 110, Locale.Text.Cube, true)
	newWindow.sphere = Dta.ui.createCheckbox("replaceSpheres", reskinWindow, 155, 135, Locale.Text.Sphere, true)
	newWindow.pole = Dta.ui.createCheckbox("replacePoles", reskinWindow, 155, 160, Locale.Text.Pole, true)
	newWindow.disc = Dta.ui.createCheckbox("replaceDiscs", reskinWindow, 155, 185, Locale.Text.Disc, true)


	newWindow.replaceBtn = Dta.ui.createButton("SkinReplace", reskinWindow, 100, 210, nil, nil, Locale.Buttons.Apply, nil, Dta.Replacement.ReplaceClicked)
	return newWindow
end

-- Show the reskin window
function Dta.ui.showReskinWindow()
	if Dta.ui.windowReskin == nil then
		Dta.ui.windowReskin = Dta.ui.buildReskinWindow()
	else
		Dta.ui.windowReskin:SetVisible(true)
		Dta.ui.windowReskin.oldFilterSelect:SetEnabled(true)
		Dta.ui.windowReskin.newFilterSelect:SetEnabled(true)
		Dta.ui.windowReskin.oldSkinSelect:SetEnabled(true)
		Dta.ui.windowReskin.newSkinSelect:SetEnabled(true)
	end
	Dta.ui.activeReskin = true
end

-- Hide the reskin window
function Dta.ui.hideReskinWindow()
	Dta.ui.windowReskin:SetVisible(false)
	Dta.ui.windowReskin:ClearKeyFocus()
	-- workaround for dropdown not closing automatically
	Dta.ui.windowReskin.oldFilterSelect:SetEnabled(false)
	Dta.ui.windowReskin.newFilterSelect:SetEnabled(false)
	Dta.ui.windowReskin.oldSkinSelect:SetEnabled(false)
	Dta.ui.windowReskin.newSkinSelect:SetEnabled(false)
	Dta.ui.activeReskin = false
end

-- Toggle the reskin window
function Dta.ui.toggleReskinWindow()
	if Dta.ui.activeReskin then Dta.ui.hideReskinWindow()
	else Dta.ui.showReskinWindow() end
end
