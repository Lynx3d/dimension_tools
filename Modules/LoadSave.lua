local Dta = select(2, ...)

Dta.losa = {}

--------------------------------------
--LOAD / SAVE BUTTON HANDLERS
--------------------------------------

function Dta.losa.constructionLoadDeafaultSetsChanged()
	if Dta.ui.windowLoSa.constructions.loadDeafaultSets:GetChecked() then
		Dta.ui.loadLoSa = "Default"
		Dta.ui.windowLoSa.constructions.loadSavedSets:SetChecked(false)
		Dta.ui.windowLoSa.constructions.loadTbxSets:SetChecked(false)
		Dta.ui.windowLoSa.constructions.remove:SetVisible(false)
		Dta.ui.windowLoSa.constructions.loadAtOriginalLoc:SetVisible(false)
		Dta.ui.windowLoSa.constructions.loadAtOriginalLoc:SetChecked(false)
		Dta.losa.constructionLoadNewItemsChanged()
		Dta.losa.refreshLoadSelect()
	elseif not Dta.ui.windowLoSa.constructions.loadSavedSets:GetChecked() and not Dta.ui.windowLoSa.constructions.loadTbxSets:GetChecked()then
		Dta.ui.windowLoSa.constructions.loadDeafaultSets:SetChecked(true)
	end
end

function Dta.losa.constructionLoadSavedSetsChanged()
	if Dta.ui.windowLoSa.constructions.loadSavedSets:GetChecked() then
		Dta.ui.loadLoSa = "Saved"
		Dta.ui.windowLoSa.constructions.loadDeafaultSets:SetChecked(false)
		Dta.ui.windowLoSa.constructions.loadTbxSets:SetChecked(false)
		Dta.ui.windowLoSa.constructions.remove:SetVisible(true)
		Dta.ui.windowLoSa.constructions.loadAtOriginalLoc:SetVisible(true)
		Dta.ui.windowLoSa.constructions.loadAtOriginalLoc:SetChecked(false)
		Dta.losa.constructionLoadNewItemsChanged()
		Dta.losa.refreshLoadSelect()
	elseif not Dta.ui.windowLoSa.constructions.loadDeafaultSets:GetChecked() and not Dta.ui.windowLoSa.constructions.loadTbxSets:GetChecked()then
		Dta.ui.windowLoSa.constructions.loadSavedSets:SetChecked(true)
	end
end

function Dta.losa.constructionLoadTbxSetsChanged()
	if Dta.ui.windowLoSa.constructions.loadTbxSets:GetChecked() then
		Dta.ui.loadLoSa = "Tbx"
		Dta.ui.windowLoSa.constructions.loadSavedSets:SetChecked(false)
		Dta.ui.windowLoSa.constructions.loadDeafaultSets:SetChecked(false)
		Dta.ui.windowLoSa.constructions.remove:SetVisible(false)
		Dta.ui.windowLoSa.constructions.loadAtOriginalLoc:SetVisible(true)
		Dta.ui.windowLoSa.constructions.loadAtOriginalLoc:SetChecked(false)
		Dta.losa.constructionLoadNewItemsChanged()
		Dta.losa.refreshLoadSelect()
	elseif not Dta.ui.windowLoSa.constructions.loadSavedSets:GetChecked() and not Dta.ui.windowLoSa.constructions.loadDeafaultSets:GetChecked()then
		Dta.ui.windowLoSa.constructions.loadTbxSets:SetChecked(true)
	end
end

function Dta.losa.constructionLoadNewItemsChanged()
	if Dta.ui.windowLoSa.constructions.LoadNewItems:GetChecked() and Dta.ui.windowLoSa.constructions.loadSavedSets:GetChecked() then
		Dta.ui.windowLoSa.constructions.LoadMultipleSets:SetVisible(true)
	elseif Dta.ui.windowLoSa.constructions.LoadNewItems:GetChecked() and Dta.ui.windowLoSa.constructions.loadTbxSets:GetChecked() then
		Dta.ui.windowLoSa.constructions.LoadMultipleSets:SetVisible(true)
	else
		Dta.ui.windowLoSa.constructions.LoadMultipleSets:SetVisible(false)
		Dta.ui.windowLoSa.constructions.LoadMultipleSets:SetChecked(false)
	end
end

function Dta.losa.constructionLoadMultipleSetsChanged()
	if Dta.ui.windowLoSa.constructions.LoadMultipleSets:GetChecked() then
		Dta.ui.windowLoSa.constructions.NrCopiesLabel:SetVisible(true)
		Dta.ui.windowLoSa.constructions.OffsetLabel:SetVisible(true)
		Dta.ui.windowLoSa.constructions.xLabel:SetVisible(true)
		Dta.ui.windowLoSa.constructions.yLabel:SetVisible(true)
		Dta.ui.windowLoSa.constructions.zLabel:SetVisible(true)
		Dta.ui.windowLoSa.constructions.NrCopies:SetVisible(true)
		Dta.ui.windowLoSa.constructions.x:SetVisible(true)
		Dta.ui.windowLoSa.constructions.y:SetVisible(true)
		Dta.ui.windowLoSa.constructions.z:SetVisible(true)
	elseif not Dta.ui.windowLoSa.constructions.LoadMultipleSets:GetChecked() then
		Dta.ui.windowLoSa.constructions.NrCopiesLabel:SetVisible(false)
		Dta.ui.windowLoSa.constructions.OffsetLabel:SetVisible(false)
		Dta.ui.windowLoSa.constructions.xLabel:SetVisible(false)
		Dta.ui.windowLoSa.constructions.yLabel:SetVisible(false)
		Dta.ui.windowLoSa.constructions.zLabel:SetVisible(false)
		Dta.ui.windowLoSa.constructions.NrCopies:SetVisible(false)
		Dta.ui.windowLoSa.constructions.NrCopies:SetText("")
		Dta.ui.windowLoSa.constructions.x:SetVisible(false)
		Dta.ui.windowLoSa.constructions.x:SetText("")
		Dta.ui.windowLoSa.constructions.y:SetVisible(false)
		Dta.ui.windowLoSa.constructions.y:SetText("")
		Dta.ui.windowLoSa.constructions.z:SetVisible(false)
		Dta.ui.windowLoSa.constructions.z:SetText("")
	end
end

function Dta.losa.constructionSaveClicked()
	Dta.losa.saveGroupItemAttributes(Dta.ui.windowLoSa.constructions.name:GetText())
	Dta.losa.refreshLoadSelect()
end

function Dta.losa.constructionLoadClicked()
	local losaUI = Dta.ui.windowLoSa.constructions
	local cr = coroutine.wrap(Dta.losa.loadItemSet)
	cr(losaUI.nameLoad:GetSelectedItem(), losaUI.loadAtOriginalLoc:GetChecked(), losaUI.LoadNewItems:GetChecked())
end

function Dta.losa.constructionRemoveClicked()
	Dta.losa.removeGroupItem(Dta.ui.windowLoSa.constructions.nameLoad:GetSelectedItem())
end

function Dta.losa.refreshLoadSelect()
	Dta.ui.windowLoSa.constructions.nameLoad:SetItems(Dta.losa.loadConstructions())
	Dta.ui.windowLoSa.constructions.nameLoad:ResizeToFit()
	Dta.ui.windowLoSa.constructions.nameLoad:SetWidth(245)
	if Dta.ui.windowExpImp then
		Dta.ui.windowExpImp.ImportExport.ExportLoad:SetItems(Dta.expimp.loadExport())
		Dta.ui.windowExpImp.ImportExport.ExportLoad:ResizeToFit()
		Dta.ui.windowExpImp.ImportExport.ExportLoad:SetWidth(245)
	end
end

function Dta.losa.constructionPrintMaterials()
	Dta.losa.printShoppingList(Dta.ui.windowLoSa.constructions.nameLoad:GetSelectedItem())
end

function Dta.losa.constructionToClipboard()
	local cr = coroutine.wrap(Dta.losa.copyToClipboard)
	cr(Dta.ui.windowLoSa.constructions.nameLoad:GetSelectedItem())
end

function Dta.losa.constructionSearchKeyUp(frame, hEvent, key)
	if key == "Return" then
		Dta.ui.windowLoSa.constructions.nameLoad:SetItems(Dta.losa.filterConstructions())
	end
end

-- sort alphabetically rather than by ASCII value
-- if strings only differ in case, use default < operator
local function sortAlphabet(str1, str2)
	local s1, s2 = string.lower(str1), string.lower(str2)
	if s1 < s2 then
		return true
	elseif s1 > s2 then
		return false
	else
		return str1 < str2
	end
end

function Dta.losa.getConstructionSet()
	if Dta.ui.loadLoSa == "Default" then
		return Dta.constructionsdefaults, false
	elseif Dta.ui.loadLoSa == "Saved" then
		return Dta.settings.get_savedsets("SavedSets"), true
	elseif Dta.ui.loadLoSa == "Tbx" then
		return Dta.constructionstbx, true
	end
end

function Dta.losa.loadConstructions()
	local constructs = Dta.losa.getConstructionSet()

	-- TODO: cache for all 3 sources, and only redo on demand
	Dta.losa.sortedConstructions = {}
	local itemsets = Dta.losa.sortedConstructions

	if not constructs then
		return itemsets
	end

	for name, _ in pairs(constructs) do
		table.insert(itemsets, name)
	end
	table.sort(itemsets, sortAlphabet)
	return itemsets
end

function Dta.losa.filterConstructions()
	local searchString = string.lower(Dta.ui.windowLoSa.constructions.search:GetText())
	if searchString == "" then
		return Dta.losa.sortedConstructions
	end
	local filteredSets = {}

	for _, name in pairs(Dta.losa.sortedConstructions) do
		if string.find(string.lower(name), searchString, 1, true) then
			table.insert(filteredSets, name)
		end
	end
	return filteredSets
end

function Dta.losa.confirmPlayerDistance(player, cp)
	local vec = { cp.x - player.coordX, cp.y - player.coordY, cp.z - player.coordZ }
	local distance = math.sqrt(vec[1] * vec[1] + vec[2] * vec[2] + vec[3] * vec[3])
	if distance > 200 then
		Dta.ui.showConfirmation(string.format(Dta.Locale.Text.ConfirmUsePosition, distance), true, false, coroutine.running())
		return coroutine.yield()
	end
	return true
end

--------------------------------------
-- COPY SET TO CLIPBOARD
--------------------------------------

function Dta.losa.copyToClipboard(name)
	local losa_ui = Dta.ui.windowLoSa.constructions
	local constructionSet, atOriginalLoc = Dta.losa.getConstructionSet()
	atOriginalLoc = atOriginalLoc and losa_ui.loadAtOriginalLoc:GetChecked()

	if constructionSet and constructionSet[name] ~= nil then
		local cp = Dta.items.getCentralPoint(constructionSet[name])
		local player = Inspect.Unit.Detail("player")
		-- check if set location is reasonably near
		if atOriginalLoc and not Dta.losa.confirmPlayerDistance(player, cp) then
			return
		end
		-- TODO: check if clipboard empty
		Dta.clipboard.items = Dta.copyTable(constructionSet[name], true)
		Dta.clipboard.itemCount = #Dta.clipboard.items
		if not atOriginalLoc then
			local offset_x = player.coordX - cp.x + 15
			local offset_y = player.coordY - cp.minValuaY + 0.05
			local offset_z = player.coordZ - cp.z
			for _, item in pairs(Dta.clipboard.items) do
				item.coordX = item.coordX + offset_x
				item.coordY = item.coordY + offset_y
				item.coordZ = item.coordZ + offset_z
			end
		end
		Dta.CPrint(string.format(Dta.Locale.Prints.CopiedClipboard, name))
	end
end

--------------------------------------
--SAVESET
--------------------------------------

function Dta.losa.saveGroupItemAttributes(name)
	if name ~= nil and name ~= "" then
		if Dta.selectionCount > 0 then

			local groupDetails = {}
			for _, item in pairs(Dta.selectedItems) do
				table.insert(groupDetails, {name = item.name,
											type = item.type,
											coordX = item.coordX,
											coordY = item.coordY,
											coordZ = item.coordZ,
											yaw = item.yaw,
											pitch = item.pitch,
											roll = item.roll,
											scale = item.scale})
			end
			local constructions = Dta.settings.get_savedsets("SavedSets") or {}
			constructions[name] = groupDetails
			Dta.settings.set_savedsets("SavedSets", constructions)
			Dta.CPrint(string.format(Dta.Locale.Prints.Saved, name))
		else
			Dta.CPrint(Dta.Locale.Prints.MinOneItem)
		end
	else
		Dta.CPrint(Dta.Locale.Prints.EnterName)
	end
end

---------------------------------
--SHOPPINGLIST
---------------------------------

function Dta.losa.printShoppingList(name)
	local constructionSet = Dta.losa.getConstructionSet()

	if name ~= nil and name ~= "" then
		if constructionSet and constructionSet[name] ~= nil then
			local list = Dta.losa.getGroupShoppingList(constructionSet[name])
			if list ~= nil and Dta.losa.tableLength(list) > 0 then
				Dta.CPrint(string.format(Dta.Locale.Prints.LoadNeededItems, name))
				for id, details in pairs(list) do
					Dta.CPrint(string.format("%s: %d", details.name, details.amount))
				end
			else
				Dta.CPrint(Dta.Locale.Prints.WordCouldNotPrint)
			end
		else
			Dta.CPrint(string.format(Dta.Locale.Prints.SetNotFound, name))
		end
	else
		Dta.CPrint(Dta.Locale.Prints.LoadPrintMats)
	end
end

function Dta.losa.tableLength(t)
	if t ~= nil then
		local count = 0
		for _ in pairs(t) do count = count + 1 end
		return count
	else
		return 0
	end
end

function Dta.losa.getGroupShoppingList(itemlist)
	if #itemlist > 0 then
		local shoppingList = {}
		for k, details in pairs(itemlist) do
			if shoppingList[details.type] == nil then
				shoppingList[details.type] = {name = details.name, amount = 1}
			else
				shoppingList[details.type].amount = shoppingList[details.type].amount + 1
			end
		end
		return shoppingList
	end
end

----------------------------------
--LOADSET
----------------------------------

function Dta.losa.loadItemSet(name, atOriginalLoc, newItems)
	if not Dta.checkIdle() then
		return
	end
	-- check input
	local settings = {}
	local success = {}
	local losa_ui = Dta.ui.windowLoSa.constructions
	settings.coordX, success.x = Dta.ui.checkNumber(losa_ui.x:GetText(), 0)
	settings.coordY, success.y = Dta.ui.checkNumber(losa_ui.y:GetText(), 0)
	settings.coordZ, success.z = Dta.ui.checkNumber(losa_ui.z:GetText(), 0)
	settings.n_copies, success.n_copies = Dta.ui.checkNumber(losa_ui.NrCopies:GetText(), 1)

	if not success.x or
		not success.y or
		not success.z or
		not success.n_copies then
		Dta.CPrint(Dta.Locale.Prints.NumbersOnly)
		return
	end

	local constructionSet = Dta.losa.getConstructionSet()

	if constructionSet and constructionSet[name] ~= nil then
		settings.cp = Dta.items.getCentralPoint(constructionSet[name])
		settings.player = Inspect.Unit.Detail("player")
		-- check if set location is reasonably near
		if atOriginalLoc and not Dta.losa.confirmPlayerDistance(settings.player, settings.cp) then
			return
		end
		-- check available items
		local shoppingList = Dta.losa.getGroupShoppingList(constructionSet[name])
		if newItems then
			Dta.losa.ScanInventory(shoppingList, true, false) -- settings.include_bags, settings.include_bank)
			local missing = Dta.losa.checkShoppingList(shoppingList, settings.n_copies)
			if missing then
				Dta.losa.printMissingItems(missing, shoppingList, Dta.Locale.Prints.NotLoadedBags)
				return
			end
			Dta.items.DeselectAll()
			Dta.Co_DoneMessage = string.format(Dta.Locale.Prints.SetLoaded, name)
			Dta.AddItem_Co = coroutine.create(Dta.losa.pasteGroup)
			local ok, err = coroutine.resume(Dta.AddItem_Co, constructionSet[name], shoppingList, settings, newItems, atOriginalLoc)
			if not ok then dump(err) end
		else
			Dta.losa.ScanSelection(shoppingList)
			local missing = Dta.losa.checkShoppingList(shoppingList, settings.n_copies)
			if missing then
				Dta.losa.printMissingItems(missing, shoppingList, Dta.Locale.Prints.NotLoadedSelection)
				return
			end
			Dta.losa.pasteGroup(constructionSet[name], shoppingList, settings, newItems, atOriginalLoc)
		end
	else
		Dta.CPrint(string.format(Dta.Locale.Prints.SetNotFound, name))
	end
end

function Dta.losa.pasteGroup(itemSet, shoppingList, settings, new_items, atOriginalLoc)
	-- determine new position unless at pasting at original position
	local newPlacement = { coordX = 0, coordY = 0, coordZ = 0 }
	if not atOriginalLoc then
		local player = settings.player
		newPlacement.coordX = player.coordX - settings.cp.x + 15
		newPlacement.coordY = player.coordY - settings.cp.minValuaY + 0.05
		newPlacement.coordZ = player.coordZ - settings.cp.z
	end
	-- paste the requested number of copies
	for k = 0, settings.n_copies - 1, 1 do
		local offset = { coordX = newPlacement.coordX + k * settings.coordX,
						coordY = newPlacement.coordY + k * settings.coordY,
						coordZ = newPlacement.coordZ + k * settings.coordZ }
		Dta.copa.pasteSet(itemSet, shoppingList, offset, new_items)
	end
end

----------------------------------
--REMOVESET
----------------------------------

function Dta.losa.deleteItemSet(name)
	local constructions = Dta.settings.get_savedsets("SavedSets")
	constructions[name] = nil
	Dta.losa.refreshLoadSelect()
	Dta.CPrint(string.format(Dta.Locale.Prints.SetRemoved, name))
end

function Dta.losa.removeGroupItem(name)
	local constructions = Dta.settings.get_savedsets("SavedSets")
	if name ~= nil and name ~= "" then
		if constructions and constructions[name] ~= nil then
			Dta.ui.showConfirmation(string.format(Dta.Locale.Text.ConfirmDeleteSet, name),
									Dta.losa.deleteItemSet, nil, name)
		else
			Dta.CPrint(string.format(Dta.Locale.Prints.NotRemoved, name))
		end
	else
		Dta.CPrint(Dta.Locale.Prints.RemoveSelectSet)
	end
end
