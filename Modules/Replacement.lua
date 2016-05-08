﻿local Dta = select(2, ...)

Dta.Replacement = {}

function Dta.Replacement.GetItemForSkin(item_type, skin)
	local details = Dta.Defaults.ItemDB[item_type]
	if not details or not details.shape then
		return nil
	end
	return skin[details.shape]
end

--Dta.Replacement.Skins = {}

function Dta.Replacement.loadSkins()
	local items = {}
	for name, _ in pairs(Dta.Defaults.Skins) do
		table.insert(items, name)
	end
	return items
end

-- fonts need plank, tile and pole, not all skins have them:
function Dta.Replacement.loadAlphabetSkins()
	local items = {}
	for name, skin in pairs(Dta.Defaults.Skins) do
		if skin.tile and skin.plank and skin.pole then
			table.insert(items, name)
		end
	end
	return items
end

function Dta.Replacement.ReplaceClicked()
	local settings = {}
	local reskinWindow = Dta.ui.windowReskin
	local old_skin = reskinWindow.oldSkinSelect:GetSelectedItem()
	local new_skin = reskinWindow.newSkinSelect:GetSelectedItem()

	if not old_skin or not Dta.Defaults.Skins[old_skin] or
	   not new_skin or not Dta.Defaults.Skins[new_skin] then
		Dta.CPrint(Dta.Lang[Dta.Language].Prints.SelectSkin)
		return
	end
	settings.old_skin_lookup = {}
	for shape, details in pairs(Dta.Defaults.Skins[old_skin]) do
		settings.old_skin_lookup[details.type] = shape
	end
	--dump(settings.old_skin_lookup) -- TEMP
	settings.skin_data = Dta.Defaults.Skins[new_skin]
	settings.replace_shape = {
		tile = reskinWindow.tile:GetChecked(),
		rectangle = reskinWindow.rectangle:GetChecked(),
		triangle = reskinWindow.triangle:GetChecked(),
		plank = reskinWindow.plank:GetChecked(),
		cube = reskinWindow.cube:GetChecked(),
		sphere = reskinWindow.sphere:GetChecked(),
		pole = reskinWindow.pole:GetChecked(),
		disc = reskinWindow.disc:GetChecked(),
	}

	Dta.Replacement.ReplaceClipboard(settings)
end

function Dta.Replacement.ReplaceClipboard(settings)
	local Lang = Dta.Lang[Dta.Language]
	if not Dta.clipboard.items then
		Dta.CPrint(Lang.Prints.ClipboardEmpty)
		return
	end
	local stats = {}
	for i, details in pairs(Dta.clipboard.items) do
		local shape = settings.old_skin_lookup[details.type]
		if shape and settings.replace_shape[shape] and settings.skin_data[shape] then
			details.type = settings.skin_data[shape].type
			details.name = settings.skin_data[shape].name
			stats[shape] = (stats[shape] or 0) + 1
			--Dta.CPrint("replaced:" .. details.name)
		end
	end
	-- print statistics:
	Dta.CPrint(Lang.Prints.Summary)
	if stats.tile then 		Dta.CPrint(Lang.Text.Tile .. string.format(": %i", stats.tile)) end
	if stats.rectangle then	Dta.CPrint(Lang.Text.Rectangle .. string.format(": %i", stats.rectangle)) end
	if stats.triangle then	Dta.CPrint(Lang.Text.Triangle .. string.format(": %i", stats.triangle)) end
	if stats.plank then		Dta.CPrint(Lang.Text.Plank .. string.format(": %i", stats.plank)) end
	if stats.cube then		Dta.CPrint(Lang.Text.Cube .. string.format(": %i", stats.cube)) end
	if stats.sphere then	Dta.CPrint(Lang.Text.Sphere .. string.format(": %i", stats.sphere)) end
	if stats.pole then		Dta.CPrint(Lang.Text.Pole .. string.format(": %i", stats.pole)) end
	if stats.disc then		Dta.CPrint(Lang.Text.Disc .. string.format(": %i", stats.disc)) end
end
