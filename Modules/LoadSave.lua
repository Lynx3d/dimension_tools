local Dta = select(2, ...)
local Lang = Dta.Lang

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
	Dta.losa.loadGroupItemAttributes(Dta.ui.windowLoSa.constructions.nameLoad:GetSelectedItem(), Dta.ui.windowLoSa.constructions.loadAtOriginalLoc:GetChecked(), Dta.ui.windowLoSa.constructions.LoadNewItems:GetChecked())
end

function Dta.losa.constructionRemoveClicked()
	Dta.losa.removeGroupItem(Dta.ui.windowLoSa.constructions.nameLoad:GetSelectedItem())
	Dta.losa.refreshLoadSelect()
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

function Dta.losa.loadConstructions()
	local constructs
	if Dta.ui.loadLoSa == "Default" then
		constructs = Dta.constructionsdefaults
	elseif Dta.ui.loadLoSa == "Saved" then
		constructs = Dta.constructions
	elseif Dta.ui.loadLoSa == "Tbx" then
		constructs = Dta.constructionstbx
	end

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
			Dta.constructions[name] = groupDetails
			Dta.settings.set_savedsets("SavedSets", Dta.constructions)
			Dta.CPrint(string.format(Lang[Dta.Language].Prints.Saved, name))
		else
			Dta.CPrint(Lang[Dta.Language].Prints.MinOneItem)
		end
	else
		Dta.CPrint(Lang[Dta.Language].Prints.EnterName)
	end
end

---------------------------------
--SHOPPINGLIST
---------------------------------

function Dta.losa.printShoppingList(name)
	if Dta.ui.loadLoSa == "Default" then
		if name ~= nil and name ~= "" then
			if Dta.constructionsdefaults[name] ~= nil then
				Dta.groupClipboard = Dta.constructionsdefaults[name]
				local list = Dta.losa.getGroupShoppingList()
				if list ~= nil and Dta.losa.tableLength(list) > 0 then
					Dta.CPrint(string.format(Lang[Dta.Language].Prints.LoadNeededItems, name))
					for id, details in pairs(list) do
						Dta.CPrint(string.format("%s: %d", details.name, details.amount))
					end
				else
					Dta.CPrint(Lang[Dta.Language].Prints.WordCouldNotPrint)
				end
			else
				Dta.CPrint(string.format(Lang[Dta.Language].Prints.SetNotFound, name))
			end
		else
			Dta.CPrint(Lang[Dta.Language].Prints.LoadPrintMats)
		end
	elseif Dta.ui.loadLoSa == "Saved" then
		if name ~= nil and name ~= "" then
			if Dta.constructions[name] ~= nil then
				Dta.groupClipboard = Dta.constructions[name]
				local list = Dta.losa.getGroupShoppingList()
				if list ~= nil and Dta.losa.tableLength(list) > 0 then
					Dta.CPrint(string.format(Lang[Dta.Language].Prints.LoadNeededItems, name))
					for id, details in pairs(list) do
						Dta.CPrint(string.format("%s: %d", details.name, details.amount))
					end
				else
					Dta.CPrint(Lang[Dta.Language].Prints.WordCouldNotPrint)
				end
			else
				Dta.CPrint(string.format(Lang[Dta.Language].Prints.SetNotFound, name))
			end
		else
			Dta.CPrint(Lang[Dta.Language].Prints.LoadPrintMats)
		end
	elseif Dta.ui.loadLoSa == "Tbx" then
		if name ~= nil and name ~= "" then
			if Dta.constructionstbx[name] ~= nil then
				Dta.groupClipboard = Dta.constructionstbx[name]
				local list = Dta.losa.getGroupShoppingList()
				if list ~= nil and Dta.losa.tableLength(list) > 0 then
					Dta.CPrint(string.format(Lang[Dta.Language].Prints.LoadNeededItems, name))
					for id, details in pairs(list) do
						Dta.CPrint(string.format("%s: %d", details.name, details.amount))
					end
				else
					Dta.CPrint(Lang[Dta.Language].Prints.WordCouldNotPrint)
				end
			else
				Dta.CPrint(string.format(Lang[Dta.Language].Prints.SetNotFound, name))
			end
		else
			Dta.CPrint(Lang[Dta.Language].Prints.LoadPrintMats)
		end
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
	local group = itemlist or Dta.groupClipboard
	if #group > 0 then
		local shoppingList = {}
		for k, details in pairs(group) do
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

function Dta.losa.loadGroupItemAttributes(name, pasteAtOriginalLoc, pasteNewItems)
	if not name or name == "" then
		Dta.CPrint(Lang[Dta.Language].Prints.LoadSelectSet)
		return
	end
	local PasteMultipleCopies = Dta.ui.windowLoSa.constructions.LoadMultipleSets:GetChecked()
	local NrCopies = Dta.ui.windowLoSa.constructions.NrCopies:GetText()
	local OffsetX = Dta.ui.windowLoSa.constructions.x:GetText()
	local OffsetY = Dta.ui.windowLoSa.constructions.y:GetText()
	local OffsetZ = Dta.ui.windowLoSa.constructions.z:GetText()

	if NrCopies == nil or NrCopies == "" then NrCopies = 1 end
	if OffsetX == nil or OffsetX == "" then OffsetX = 0 end
	if OffsetY == nil or OffsetY == "" then OffsetY = 0 end
	if OffsetZ == nil or OffsetZ == "" then OffsetZ = 0 end

	if not tonumber(NrCopies) or
		not tonumber(OffsetX) or
		not tonumber(OffsetY) or
		not tonumber(OffsetZ) then
		Dta.CPrint(Lang[Dta.Language].Prints.NumbersOnly)
		return
	end

	local constructionSet
	if Dta.ui.loadLoSa == "Default" then
		constructionSet = constructionsdefaults
	elseif Dta.ui.loadLoSa == "Saved" then
		constructionSet = Dta.constructions
	elseif Dta.ui.loadLoSa == "Tbx" then
		constructionSet = Dta.constructionstbx
	end

	if constructionSet and constructionSet[name] ~= nil then
		Dta.groupClipboard = constructionSet[name]
		Dta.losa.pasteGroup(pasteAtOriginalLoc, pasteNewItems, NrCopies, OffsetX, OffsetY, OffsetZ, name)
	else
		Dta.CPrint(string.format(Lang[Dta.Language].Prints.SetNotFound, name))
	end
end

function Dta.losa.pasteGroup(pasteAtOriginalLoc, pasteNewItems, NrCopies, OffsetX, OffsetY, OffsetZ, name)
	if pasteNewItems then
		local shoppingList = Dta.losa.getGroupShoppingList()
		local missingItems = Dta.losa.checkInventory(shoppingList, NrCopies)
		Dta.ItemsToPlace = #Dta.groupClipboard * tonumber(NrCopies)
		Dta.FinishedSet = false
		Dta.items.DeselectAll()
		Dta.Setname = name

		if Dta.losa.tableLength(missingItems) > 0 then
			Dta.CPrint(Lang[Dta.Language].Prints.NotLoadedBags)
			for id, details in pairs(missingItems) do
				Dta.CPrint(string.format("%s: %d", details.name, details.amount))
			end
		else
			local player = Inspect.Unit.Detail("player")

			Dta.losa.Co_LoadItem = coroutine.create(function ()
				for k, details in pairs(Dta.groupClipboard) do
					if k < #Dta.groupClipboard then
						Dta.LoadSet_Co_Active = true
					else
						Dta.LoadSet_Co_Active = false
					end

					local item = details.type

					local newPlacement = {
						coordX = details.coordX,
						coordY = details.coordY,
						coordZ = details.coordZ,
						yaw = details.yaw,
						pitch = details.pitch,
						roll = details.roll,
						scale = details.scale,
					}

					if not pasteAtOriginalLoc then
						local cp = Dta.items.getCentralPoint(Dta.groupClipboard)
						newPlacement.coordX = player.coordX + (details.coordX - cp.x) + 15
						newPlacement.coordY = player.coordY + (details.coordY - cp.minValuaY) + 0.05
						newPlacement.coordZ = player.coordZ + (details.coordZ - cp.z)
					end

						Dta.losa.PasteSet(item, name, NrCopies, OffsetX, OffsetY, OffsetZ, newPlacement.coordX, newPlacement.coordY, newPlacement.coordZ, newPlacement.yaw, newPlacement.pitch, newPlacement.roll, newPlacement.scale)
						coroutine.yield()

				end
			end)
			coroutine.resume(Dta.losa.Co_LoadItem)

		end
	elseif not pasteNewItems then
		local shoppingList = Dta.losa.getGroupShoppingList()
		local missingItems = Dta.losa.checkSelected(shoppingList)

		if Dta.losa.tableLength(missingItems) > 0 then
			Dta.CPrint(Lang[Dta.Language].Prints.NotLoadedSelection)
			for id, details in pairs(missingItems) do
				Dta.CPrint(string.format("%s: %d", details.name, details.amount))
			end
		else
			local player = Inspect.Unit.Detail("player")

				for k, details in pairs(Dta.groupClipboard) do

					if k < #Dta.groupClipboard then
						Dta.LoadSet_Co_Active = true
					else
						Dta.LoadSet_Co_Active = false
						Dta.CPrint(string.format(Lang[Dta.Language].Prints.SetLoaded, name))
					end

					local item = table.remove(Dta.itemList[details.type],1)

					local newPlacement = {
						coordX = details.coordX,
						coordY = details.coordY,
						coordZ = details.coordZ,
						yaw = details.yaw,
						pitch = details.pitch,
						roll = details.roll,
						scale = details.scale,
					}

					if not pasteAtOriginalLoc then
						local cp = Dta.items.getCentralPoint(Dta.groupClipboard)
						newPlacement.coordX = player.coordX + (details.coordX - cp.x) + 15
						newPlacement.coordY = player.coordY + (details.coordY - cp.minValuaY) + 0.05
						newPlacement.coordZ = player.coordZ + (details.coordZ - cp.z)
					end

					Dta.items.QueueLoad(item, newPlacement.coordX, newPlacement.coordY, newPlacement.coordZ, newPlacement.pitch, newPlacement.roll, newPlacement.yaw, newPlacement.scale)
				end

		end

	end

end

function Dta.losa.PasteSet(item, name, NrCopies, OffsetX, OffsetY, OffsetZ, Set_x, Set_y, Set_z, Set_yaw, Set_pitch, Set_roll, Set_scale) --ToDo Split up for Bag, Bank or Both

	local items = Inspect.Item.List(Utility.Item.Slot.Inventory())
	for slot, id in pairs(items) do
		if id ~= false then
			local data = Inspect.Item.Detail(id)
			if data.type == item then
				Dta.losa.Co_PlaceItem = coroutine.create(function ()
					for k = 1, tonumber(NrCopies), 1 do
						local Xoffset = tonumber(OffsetX) * k
						local Yoffset = tonumber(OffsetY) * k
						local Zoffset = tonumber(OffsetZ) * k

						local newPlacement = {
								coordX = Set_x + Xoffset,
								coordY = Set_y + Yoffset,
								coordZ = Set_z + Zoffset,
								yaw = Set_yaw,
								pitch = Set_pitch,
								roll = Set_roll,
								scale = Set_scale }

						if k < tonumber(NrCopies) then
							Dta.PlaceItem_Co_Active = true
						else
							Dta.PlaceItem_Co_Active = false
						--print(string.format("Item set \"%s\" loaded", name))
						end

						Command.Dimension.Layout.Place(id, newPlacement)
						coroutine.yield()--return
					end
				end)
				coroutine.resume(Dta.losa.Co_PlaceItem)
			end
		end
	end
end

function Dta.losa.checkSelected(shoppingList)
	if #Dta.groupClipboard > 0 then
		Dta.itemList = {}
		for _, item in pairs(Dta.selectedItems) do
			if shoppingList[item.type] ~= nil then
				if Dta.itemList[item.type] == nil then
					Dta.itemList[item.type] = {item.id}
				else
					table.insert(Dta.itemList[item.type], item.id)
				end

				if shoppingList[item.type].amount == 1 then
					shoppingList[item.type] = nil
				else
					shoppingList[item.type].amount = shoppingList[item.type].amount - 1
				end
			end
		end
		return shoppingList
	end
end

function Dta.losa.checkInventory(shoppingList, NrCopies) --ToDo Split up for Bag, Bank or Both
	if #Dta.groupClipboard > 0 then
		--loop through bags
		--print(#shoppingList)
		bagNo = 1
		for _, bag in pairs(Inspect.Item.Detail(Utility.Item.Slot.Inventory("bag"))) do
			--loop through each slot in the bag
			for slot = 1, bag.slots, 1 do
				local item = Inspect.Item.Detail(Utility.Item.Slot.Inventory(bagNo, slot))
				--if the item matches something in the shopping list
				if item ~= nil and shoppingList[item.type] ~= nil then
					if item.stack == nil then item.stack = 1 end --if the item has no stack value, set its stack to 1
					if shoppingList[item.type].amount * NrCopies <= item.stack then --if there are more items in the stack than needed
						shoppingList[item.type] = nil -- remove the item from the shopping list (we have enough)
						Dta.itemList[item.type] = item.id --add the item to the item list
					else --otherwise just remove the amount we have
						shoppingList[item.type].amount = shoppingList[item.type].amount * NrCopies - item.stack
					end
				end
			end
			bagNo = bagNo + 1
		end
		return shoppingList
	end
end

----------------------------------
--REMOVESET
----------------------------------

function Dta.losa.removeGroupItem(name)
	if name ~= nil and name ~= "" then
		if Dta.constructions[name] ~= nil then
			Dta.constructions[name] = nil
			Dta.settings.set("SavedSets", Dta.constructions)
			Dta.CPrint(string.format(Lang[Dta.Language].Prints.SetRemoved, name))
		else
			Dta.CPrint(string.format(Lang[Dta.Language].Prints.NotRemoved, name))
		end
	else
		Dta.CPrint(Lang[Dta.Language].Prints.RemoveSelectSet)
	end
end
