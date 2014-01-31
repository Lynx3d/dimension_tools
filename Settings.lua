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
  MainwindowPosX = 0,
  MainwindowPosY = 32,
  MovewindowPosX = 0,
  MovewindowPosY = 370,
  ScalewindowPosX = 0,
  ScalewindowPosY = 720,
  CopyPastewindowPosX = 455,
  CopyPastewindowPosY = 32,
  RotatewindowPosX = 0,
  RotatewindowPosY = 545,
  LoSawindowPosX = 455,
  LoSawindowPosY = 330,
  ExpImpwindowPosX = 785,
  ExpImpwindowPosY  = 32,
  HelpwindowPosX = 400,
  HelpwindowPosY  = 100,
  ExpImp_tbxwindowPosX = 785,
  ExpImp_tbxwindowPosY  = 330,
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
  if Dta.settings.defaults[setting] == value then
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
  if Dta_defaults[setting] ~= nil then
    return Dta_defaults[setting]
  else
    return nil
  end
end

function Dta.settings.set_savedsets(setting, value)
  if Dta_defaults[setting] == value then
    Dta.settings.savedsets[setting] = nil
  else
    Dta.settings.savedsets[setting] = value
  end

  return Dta.settings.savedsets[setting]
end


Dta.settings.main()
