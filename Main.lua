local addon, Dta = ...

--Addon information
Dta.Version = addon.toc.Version --Inspect.Addon.Detail(Inspect.Addon.Current()).toc.Version
Dta.AddonID = addon.toc.Identifier
Dta.SettingsRevision = 2
Dta.Language = Inspect.System.Language()
Dta.Lang = {}
Dta.Tools = {}

--Items
Dta.selectedItems = {}
Dta.selectionCount = 0
Dta.clipboard = {}
Dta.notifyThreshold = 10

--Load & Save
Dta.constructionsdefaults = {}
Dta.constructionstbx = {}
Dta.SelectionQueue = {}

--Import & Export
Dta.ExportTbx = {}
Dta.ExportSaved = {}
Dta.ExportImport_Sets = {}

--Move, Rotate and Scale
Dta.pendingActions = {}
Dta.lastFrameTime = 0

--Copy & Paste
Dta.FlickerOffset = true

--Others
Dta.PlayerID = Inspect.Unit.Lookup("player")
Dta.InDimension = false

--Flying
Dta.desiredPitch = 0
Dta.pitchButtons = {}
Dta.waitingForCarpet = false
Dta.FlyingType = "IFEC11D174272F87C,3E1F104FE8C67224,,,,,,"
Dta.magicYOffset = 0.4755 -- height of Tribal Table
Dta.carpetId = false
Dta.lastPlayerPos = {coordX = 0, coordY = 0, coordZ = 0}
Dta.savePosNew = {coordX = 0, coordY = 0, coordZ = 0}
Dta.savePosOld = {coordX = -0.2, coordY = 0, coordZ = 0}
Dta.lastCarpetMove = 0
Dta.lastYaw = 0

---------------------------------
--CATCH COROUTINES
---------------------------------
Dta.AddItem_Co = nil
Dta.pending_add = false

--------------------------------------
--MAIN FUNCTIONS
--------------------------------------

function Dta.main()
	Command.Event.Attach(Command.Slash.Register("tt"), Dta.commandHandler, "Tinker Tools Command")
	Command.Event.Attach(Event.Unit.Availability.Full, Dta.Event_Unit_Availability_Full, "Event_Unit_Availability_Full")
	Command.Event.Attach(Event.Unit.Detail.Zone, Dta.Event_Unit_Detail_Zone, "Event_Unit_Detail_Zone")
	Command.Event.Attach(Event.System.Update.Begin, Dta.tick, "refresh")
	Command.Event.Attach(Event.Dimension.Layout.Add, Dta.addEventHandler, "Update selection")
	Command.Event.Attach(Event.Dimension.Layout.Remove, Dta.removeEventHandler, "Update selection")
	Command.Event.Attach(Event.Dimension.Layout.Update, Dta.updateEventHandler, "Update selection")
end

-- print text to all consoles (chat windows/tabs) enabled in settings
function Dta.CPrint(text, html)
	local consoles = Dta.settings.get("ConsoleOutput")
	local open_consoles = Inspect.Console.List()
	-- apparently not available during loading screens
	if not open_consoles then return end
	for k, _ in pairs(consoles) do
		local console_id = string.format("v00000000%08x", k-1)
		if open_consoles[console_id] then
			Command.Console.Display(console_id, false, text, html == true)
		end
	end
end

local function toolIsActive(self)
	return self.window and self.window:GetVisible()
end

local function toolToggle(self)
	if self.window then
		if self.window:GetVisible() then
			self.Hide(self.window)
		else
			self.Show(self.window)
		end
	else
		self.window = self.CreateUI()
	end
end

-- register a tool with some commonly required callbacks
function Dta.RegisterTool(name, createFunc, showFunc, hideFunc)
	assert(type(createFunc) == "function" and type(showFunc) == "function" and type(hideFunc) == "function")
	local tool = { CreateUI = createFunc, Show = showFunc, Hide = hideFunc, IsActive = toolIsActive }
	tool.Toggle = function() toolToggle(tool) end
	Dta.Tools[name] = tool
end


function Dta.checkIdle()
	if Dta.AddItem_Co then
		-- ask user whether to abort
		Dta.ui.showNotification(Dta.Locale.Text.NotIdleNotification,
			Dta.killProcess, nil)
		return false
	end
	return true
end

function Dta.killProcess()
	Dta.AddItem_Co = nil
	Dta.pending_add = false
	if #Dta.pendingActions > 0 then
		Dta.pendingActions = {}
	end
	if #Dta.SelectionQueue > 0 then
		Dta.SelectionQueue = {}
	end
end

function Dta.addEventHandler(hEvent, dimensionItem) --executed all the time in a dimension
	if Dta.pending_add then
		local id, _ = next(dimensionItem)
		Dta.items.QueueSelection(id)
		Dta.pending_add = false
		coroutine.resume(Dta.AddItem_Co)
	end

	if Dta.waitingForCarpet == true then
		for id, value in pairs(dimensionItem) do
			local data = Inspect.Dimension.Layout.Detail(id)
			if data ~= nil then
				if data.type == Dta.FlyingType then
					Dta.carpetId = id
					Dta.waitingForCarpet = false
				end
			end
		end
	end

end

function Dta.removeEventHandler(hEvent, dimensionItem) --Executed when item is removed
	--if #Dta.pendingActions == 1 then
	--	Dta.CPrint(Dta.Locale.Prints.ProcessFinished)
	--end
	if Dta.carpetId and dimensionItem[Dta.carpetId] then
		Dta.flying.FlyingRemoved()
	end

	if Dta.selectionCount > 0 then
		Dta.items.updateSelection(dimensionItem, true)
	end
end

function Dta.updateEventHandler(hEvent, dimensionItem) --Executed on every select/ deselect or change of an dimension item
	--if #Dta.pendingActions == 1 then
	--	print(Dta.Locale.Prints.ProcessFinished)
	--end
	Dta.items.updateSelection(dimensionItem, false)
end

local function EnterDimension()
	-- reset copy&paste pivot, because it may be off-limit
	Dta.copa.pivot = nil

	if Dta.InDimension then return end
	Dta.ui.showMainButton()
	-- TODO: attach tick callback
	Dta.InDimension = true
end

local function LeaveDimension()
	if not Dta.InDimension then return end
	Dta.ui.hideMainButton()
	-- TODO: detatch tick callback
	if Dta.ui.active then Dta.ui.hideMainWindow() end
	Dta.InDimension = false
end

local function IsDimension(zoneID)
	local ZoneDetails = Inspect.Zone.Detail(zoneID)
	if not ZoneDetails or not ZoneDetails.name then
		return false
	end
	local ZoneName = ZoneDetails.name
	if string.sub(ZoneName, 1, 9) == "Dimension" or string.sub(ZoneName, 1, 9) == "Измерение" then
		return true
	end
	-- Octus Monastery fix:
	if ZoneDetails.id == "z7E4460FA8D2B98EF" then
		return true
	end
	return false
end
------------------------
-- entering a dimension (or changing zones in general) can happen in two ways:
-- player data stays available and we get an Event.Unit.Detail.Zone, or
-- player enters a Event.Unit.Availability.Partial in loading screen (zone
-- becomes undefined) and we need to check zone again at Event.Unit.Availability.Full
------------------------
function Dta.Event_Unit_Detail_Zone(hEvent, u)
	if u[Dta.PlayerID] ~= nil then -- value may be "false", so explicit nil check
		local newZone = u[Dta.PlayerID]
		-- Dta._CurrentZoneID = newZone
		if newZone and IsDimension(newZone) then
			EnterDimension()
		else
			LeaveDimension()
		end
		if Dta.carpetId then
			Dta.flying.FlyingRemoved()
			--Dta.CPrint("You left Tribal Magic behind...")
		end
	end
end

function Dta.Event_Unit_Availability_Full(hEvent, t)
	for k,v in pairs(t) do
		if v == "player" then
			local PlayerDetails = Inspect.Unit.Detail("player")
			-- Dta._CurrentZoneID = PlayerDetails.zone
			if IsDimension(PlayerDetails.zone) then
				EnterDimension()
			else
				LeaveDimension()
			end
			break
		end
	end
end

function Dta.commandHandler(hEvent, command)

	if command == "reset" then
		for name, val in pairs(Dta.settings.defaults) do
			if string.sub(name, -4, -2) == "Pos" then
				Dta.settings.set(name, val)
			end
		end
		local elements = { Dta.ui.windowtest, Dta.ui.buttonMainToggle, Dta.ui.windowHelp }
		for _, tool in pairs(Dta.Tools) do
			table.insert(elements, tool.window)
		end
		for _, window in pairs(elements) do
			window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Dta.settings.get(window.settings.POS_X), Dta.settings.get(window.settings.POS_Y))
		end
		Dta.CPrint("Positions reset")
	elseif command == "help" then
		Dta.help_ui.toggleHelpWindow()
	elseif command == "import_dt" then
		Dta.settings.import_dimtools()
	elseif command == "config" then
		Dta.config_ui.showConfigWindow()
	elseif command == "force" then
		EnterDimension()
	elseif command == "check_lang" then
		local function checkLang(lang1, lang2, stack)
			for key, val in pairs(lang1) do
				if type(val) == "table" then
					if not rawget(lang2, key) then
						Dta.CPrint("Missing table: " .. table.concat(stack, ".") .. "." .. key)
					else
						table.insert(stack, key)
						checkLang(val, lang2[key], stack)
						table.remove(stack)
					end
				elseif not rawget(lang2, key) then
					Dta.CPrint("Missing string: " .. table.concat(stack, ".") ..  "." .. key)
				end
			end
		end
		checkLang(Dta.Lang.English, Dta.Lang.French, {"French"})
		checkLang(Dta.Lang.English, Dta.Lang.German, {"German"})
	else
		if Dta.InDimension == true then
			Dta.ui.toggleMainWindow()
		else
			Dta.CPrint(Dta.Locale.Prints.DimensionOnly)
		end
	end
end

--------------------------------------
--QUEUE HANDLER
--------------------------------------

function Dta.tick(handle)
	local currentFrameTime = Inspect.Time.Frame()
	local deltaT = 	currentFrameTime - Dta.lastFrameTime

	Dta.lastFrameTime = currentFrameTime

	if #Dta.pendingActions > 0 and not Dta.pending_add then
		-- Rift (3.6) has a global command queue with a depth of 100 and throttling (25/sec ?).
		-- We don't want to completely cram the queue, but keep 20 command slots for other addons;
		-- 10 commands per tick should also be plenty to reach queue limit eventually.
		local count = 0
		while #Dta.pendingActions > 0 and count < 10 and Inspect.Queue.Status("global", 20) do
			local action = table.remove(Dta.pendingActions, 1)
			if action.op == "scale" then
				Command.Dimension.Layout.Place(action.id, {scale=action.amount})
			elseif action.op == "move" then
				Command.Dimension.Layout.Place(action.id, {coordX=action.x, coordY=action.y, coordZ=action.z})
			elseif action.op == "rotate" then
				Command.Dimension.Layout.Place(action.id, {pitch=action.pitch, yaw=action.yaw, roll=action.roll})
			elseif action.op == "select" then
				Command.Dimension.Layout.Select(action.id, true)
			elseif action.op == "add" then
				Dta.pending_add = true
				-- Command.Dimension.Layout.Place(action.id, action.details)
				-- *NOTE*: below code is to get more useful information about a seemingly random error
				-- that claims incorrect function usage despite the given arguments should always have
				-- the same structure, and at least their data type clearly matches the docs.
				local success, rval = pcall(Command.Dimension.Layout.Place, action.id, action.details)
				if not success then
					local details = Inspect.Item.Detail(action.id)
					local item_info = details and Utility.Serialize.Inline(details) or "N/A"
					local placement_info = Utility.Serialize.Inline(action.details)
					local error_details = "Item Details:\n" .. item_info .. "\nPlacement Info:\n" .. placement_info .. "\n Rift error:\n" .. rval
					error(error_details)
				end
				-- can't queue multiple new items placements
				break
			elseif action.op == "xform" then
				Command.Dimension.Layout.Place(action.id, action.details)
			elseif action.op == "notify" then
				Dta.CPrint(action.text)
			end
			count = count + 1
		end
	end

	-- remove Coroutine when it has finished; TODO: move to Add handler?
	if Dta.AddItem_Co and not Dta.pending_add then
		if coroutine.status(Dta.AddItem_Co) == "dead" then
			Dta.AddItem_Co = nil
		end
	end

	if #Dta.SelectionQueue > 0 and not Dta.AddItem_Co then
		local count = 0
		while #Dta.SelectionQueue > 0 and count < 10 and Inspect.Queue.Status("global", 20) do
			local action = table.remove(Dta.SelectionQueue, 1)
			if action.op == "deselect" then
				Command.Dimension.Layout.Select(action.id, false)
			elseif action.op == "select" then
				Command.Dimension.Layout.Select(action.id, true)
			end
			if not next(Dta.SelectionQueue) and Dta.Co_DoneMessage then
				Dta.CPrint(Dta.Co_DoneMessage)
				Dta.Co_DoneMessage = nil
			end
			count = count + 1
		end
	end

	if Dta.carpetId then
		Dta.flying.UpdateCarpet()
	end
end
Dta.main()
