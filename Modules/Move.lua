local Dta = select(2, ...)

Dta.move = {}

-------------------------------
-- POSITION CHECKBOXES / BUTTON HANDLERS
-------------------------------
function Dta.move.modifyPositionModeAbsChanged()
	if Dta.ui.windowMove.modifyPosition.modeAbs:GetChecked() then
		Dta.ui.windowMove.modifyPosition.modeRel:SetChecked(false)
		Dta.ui.windowMove.modifyPosition.moveAsGrp:CBSetEnabled(true)
	elseif not Dta.ui.windowMove.modifyPosition.modeRel:GetChecked() then
		Dta.ui.windowMove.modifyPosition.modeAbs:SetChecked(true)
	end
end

function Dta.move.modifyPositionModeRelChanged()
	if Dta.ui.windowMove.modifyPosition.modeRel:GetChecked() then
		Dta.ui.windowMove.modifyPosition.modeAbs:SetChecked(false)
		Dta.ui.windowMove.modifyPosition.moveAsGrp:CBSetEnabled(false)
	elseif not Dta.ui.windowMove.modifyPosition.modeAbs:GetChecked() then
		Dta.ui.windowMove.modifyPosition.modeRel:SetChecked(true)
	end
end

function Dta.move.modifyPositionButtonClicked()
	Dta.move.setItemPositions(Dta.ui.windowMove.modifyPosition.x:GetText(),
	Dta.ui.windowMove.modifyPosition.y:GetText(),
	Dta.ui.windowMove.modifyPosition.z:GetText(),
	Dta.ui.windowMove.modifyPosition.modeRel:GetChecked(),
	Dta.ui.windowMove.modifyPosition.moveAsGrp:GetChecked())
end

function Dta.move.modifyPositionResetButtonClicked()
	Dta.move.resetItemPositions()
end

function Dta.move.fetchXButtonClicked()
	if Dta.selectionCenter then
		Dta.ui.windowMove.modifyPosition.x:SetText(tostring(Dta.items.round(Dta.selectionCenter.x, 4)))
	end
end

function Dta.move.fetchYButtonClicked()
	if Dta.selectionCenter then
		Dta.ui.windowMove.modifyPosition.y:SetText(tostring(Dta.items.round(Dta.selectionCenter.y, 4)))
	end
end

function Dta.move.fetchZButtonClicked()
	if Dta.selectionCenter then
		Dta.ui.windowMove.modifyPosition.z:SetText(tostring(Dta.items.round(Dta.selectionCenter.z, 4)))
	end
end

function Dta.move.fetchAllButtonClicked()
	if Dta.selectionCenter then
		Dta.ui.windowMove.modifyPosition.x:SetText(tostring(Dta.items.round(Dta.selectionCenter.x, 4)))
		Dta.ui.windowMove.modifyPosition.y:SetText(tostring(Dta.items.round(Dta.selectionCenter.y, 4)))
		Dta.ui.windowMove.modifyPosition.z:SetText(tostring(Dta.items.round(Dta.selectionCenter.z, 4)))
	end
end

--------------------------------------
--MOVE ONE ITEM
--------------------------------------

function Dta.move.setItemPosition(index, x, y, z, relative)
	if Dta.selectedItems[index] ~= nil then
		local newPlacement = {}
		if relative ~= nil and relative then -- relative positioning
			if x == nil or x == "" then x = 0 end
			if y == nil or y == "" then y = 0 end
			if z == nil or z == "" then z = 0 end

			if not tonumber(x) or
			   not tonumber(y) or
			   not tonumber(z) then
				Dta.CPrint(Dta.Locale.Prints.NumbersOnly)
				return
			end

			newPlacement = {coordX = Dta.selectedItems[index].coordX + tonumber(x), coordY = Dta.selectedItems[index].coordY + tonumber(y), coordZ = Dta.selectedItems[index].coordZ + tonumber(z)}
		else -- absolute positioning
			if x == nil or x == "" then x = Dta.selectedItems[index].coordX end
			if y == nil or y == "" then y = Dta.selectedItems[index].coordY end
			if z == nil or z == "" then z = Dta.selectedItems[index].coordZ end

			if not tonumber(x) or
			   not tonumber(y) or
			   not tonumber(z) then
				Dta.CPrint(Dta.Locale.Prints.NumbersOnly)
				return
			end

			newPlacement = {coordX = tonumber(x), coordY = tonumber(y), coordZ = tonumber(z)}
		end

		Dta.items.QueueMove(Dta.selectedItems[index].id, newPlacement.coordX, newPlacement.coordY, newPlacement.coordZ)
	else
		Dta.CPrint(Dta.Locale.Prints.ModifyPosition)
	end
end

--------------------------------------
--MOVE MULTIPLE ITEMS
--------------------------------------

function Dta.move.setItemPositions(x, y, z, relative, groupMode)
	if Dta.selectionCount > 0 then
		if not relative and groupMode and Dta.selectionCount > 1 then -- group move
			local cp = Dta.items.getCentralPoint(Dta.selectedItems)
			Dta.move.Co_MoveItemGroup = coroutine.create(function ()
				for k, details in pairs(Dta.selectedItems) do
					local newX, newY, newZ
					if x == nil or x == "" then newX = details.coordX else newX = x + (details.coordX - cp.x) end
					if y == nil or y == "" then newY = details.coordY else newY = y + (details.coordY - cp.y) end
					if z == nil or z == "" then newZ = details.coordZ else newZ = z + (details.coordZ - cp.z) end
					Dta.move.setItemPosition(k, newX, newY, newZ, false)
				end
			end)
			coroutine.resume(Dta.move.Co_MoveItemGroup)
		else
			Dta.move.Co_MoveItem = coroutine.create(function ()
				for k, details in pairs(Dta.selectedItems) do
					Dta.move.setItemPosition(k, x, y, z, relative)
				end
			end)
			coroutine.resume(Dta.move.Co_MoveItem)
		end
		Dta.items.QueueNotification(Dta.Locale.Prints.ProcessFinished, Dta.selectionCount)
	end
end

--------------------------------------
--RESET ITEMS TO PLAYER POSITION
--------------------------------------

function Dta.move.resetItemPositions()
	if Dta.selectionCount > 0 then
		local player = Inspect.Unit.Detail("player")
		Dta.move.Co_MoveItemReset = coroutine.create(function ()
			for k, details in pairs(Dta.selectedItems) do
				Dta.move.setItemPosition(k, player.coordX, player.coordY + 0.1, player.coordZ, false)
			end
		end)
		coroutine.resume(Dta.move.Co_MoveItemReset)
		Dta.items.QueueNotification(Dta.Locale.Prints.ProcessFinished, Dta.selectionCount)
	end
end
