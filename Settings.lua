local Dta = select(2, ...)
local Lang = Dta.Lang
-- Set English as Default and fallback
function addLangFallback(language)
	setmetatable(Lang[language], { __index = Lang["English"] })
	for k, v in pairs(Lang[language]) do
		if type(v) == "table" then
			setmetatable(v, { __index = Lang["English"][k] })
		end
	end
end

if not Lang[Dta.Language] or Dta.Language == "German" then -- german is w.i.p.
	Lang[Dta.Language] = Lang["English"]
end
addLangFallback("French")
--addLangFallback("German")

Dta.settings = {}

--------------------------------------
--SAVE AND LOAD SETTINGS
--------------------------------------

Dta.settings.savedsets = {}
Dta.settings.saveddefaults = {
	SavedSets = {},
}
Dta.settings.settings = {}
Dta.settings.defaults = {
	MainbuttonPosX = 10,
	MainbuttonPosY = 100,
	MainwindowPosX = 0,
	MainwindowPosY = 32,
	MovewindowPosX = 0,
	MovewindowPosY = 370,
	ScalewindowPosX = 0,
	ScalewindowPosY = 450,
	CopyPastewindowPosX = 320,
	CopyPastewindowPosY = 410,
	RotatewindowPosX = 0,
	RotatewindowPosY = 410,
	LoSawindowPosX = 320,
	LoSawindowPosY = 450,
	ExpImpwindowPosX = 320,
	ExpImpwindowPosY  = 370,
	HelpwindowPosX = 650,
	HelpwindowPosY  = 335,
	FlyingwindowPosX = 475,
	FlyingwindowPosY = 32,
	AlphabetwindowPosX = 0,
	AlphabetwindowPosY = 530,
	MeasurementswindowPosX = 0,
	MeasurementswindowPosY = 490,
	Language = "Auto",
	WindowStyle = "default",
	ConsoleOutput = { [1] = true }
}

function Dta.settings.main()
	Command.Event.Attach(Event.Addon.SavedVariables.Load.End, Dta.settings.load, "Loaded settings")
	Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, Dta.settings.save, "Saved settings")
	Command.Event.Attach(Event.Addon.SavedVariables.Load.End, Dta.settings.loadSets, "Loaded Sets")
	Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, Dta.settings.saveSets, "Saved Sets")
end

-- Load the settings into the settings table
function Dta.settings.load(hEvent, addon)
	if Dta_Settings ~= nil then Dta.settings.settings = Dta_Settings end
	local language = Dta.settings.get("Language")
	if language ~= "Auto" then
		if not Lang[language] then
			Dta.CPrint("Language '" .. language .. "' is not available.")
		else
			Dta.Language = language
		end
	end
end

--Save the settings table
function Dta.settings.save(hEvent, addon)
	Dta_Settings = Dta.settings.settings
end

-- Load the Sets into the settings table
function Dta.settings.loadSets(hEvent, addon)
	if Dta_Sets ~= nil then Dta.settings.savedsets = Dta_Sets end
end

--Save the Sets table
function Dta.settings.saveSets(hEvent, addon)
	Dta_Sets = Dta.settings.savedsets
end

--------------------------------------
--GET AND SET SETTINGS
--------------------------------------

function Dta.settings.get(setting)
	if Dta.settings.settings[setting] ~= nil then
		return Dta.settings.settings[setting]
	elseif Dta.settings.defaults[setting] ~= nil then
		return Dta.settings.defaults[setting]
	else
		return nil
	end
end

function Dta.settings.set(setting, value)
	if type(value) ~= "table" and Dta.settings.defaults[setting] == value then
		Dta.settings.settings[setting] = nil
	else
		Dta.settings.settings[setting] = value
	end

	return Dta.settings.settings[setting]
end

--------------------------------------
--GET AND SET SETS
--------------------------------------

function Dta.settings.get_savedsets(setting)
	if Dta.settings.savedsets[setting] ~= nil then
		return Dta.settings.savedsets[setting]
	elseif Dta.settings.saveddefaults[setting] ~= nil then
		return Dta.settings.saveddefaults[setting]
	else
		return nil
	end
end

function Dta.settings.get_defaultsets(setting)
	if Dta.Defaults[setting] ~= nil then
		return Dta.Defaults[setting]
	else
		return nil
	end
end

function Dta.settings.get_alphabetFonts(setting)
	if Dta.Defaults[setting] ~= nil then
		return Dta.Defaults[setting]
	else
		return nil
	end
end

function Dta.settings.get_alphabetSize(setting, font)
	if Dta.Defaults[setting][font] ~= nil then
		return Dta.Defaults[setting][font]
	else
		return nil
	end
end

function Dta.settings.get_alphabetLetters(setting, font, size)
	if Dta.Defaults[setting][font][size] ~= nil then
		return Dta.Defaults[setting][font][size]
	else
		return nil
	end
end

function Dta.settings.get_Skins(setting)
	if Dta.Defaults[setting] ~= nil then
		return Dta.Defaults[setting]
	else
		return nil
	end
end

function Dta.settings.set_savedsets(setting, value)
	if Dta.Defaults[setting] == value then
		Dta.settings.savedsets[setting] = nil
	else
		Dta.settings.savedsets[setting] = value
	end

	return Dta.settings.savedsets[setting]
end

function Dta.settings.get_tbxsets(setting)
	if tbx_Settings[setting] ~= nil then
		return tbx_Settings[setting]
	else
		return nil
	end
end

Dta.settings.main()
