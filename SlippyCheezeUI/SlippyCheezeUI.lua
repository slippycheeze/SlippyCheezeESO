local NAME = 'SlippyCheezeUI'
local logger = LibDebugLogger("SC-UI")
-- logger:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)

local function setWindowPosition(window, point, target, relativePoint, offsetX, offsetY)
    window:ClearAnchors()
    window:SetAnchor(point, target, relativePoint, offsetX, offsetY)
    local handler = window:GetHandler("OnMoveStop")
    if handler then
      handler()
    end
end

local function HandlePerformanceMeters()
    if not ZO_PerformanceMeters then
      logger:Debug("ZO_PerformanceMeters is falsey")
      return
    end

    -- check if this is what we expected.
    local isValidAnchor, point, _, relativePoint, _, offsetY, _ = ZO_PerformanceMeters:GetAnchor(0)
    logger:Debug{isValidAnchor=isValidAnchor, point=point, relativePoint=relativePoint, offsetY=offsetY}
    if not isValidAnchor
      or point ~= BOTTOM
      or relativePoint ~= BOTTOM
      or offsetY ~= 20
    then
      logger:Debug("Updating ZO_PerformanceMeters anchor point")
      ZO_PerformanceMeters:ClearAnchors()
      ZO_PerformanceMeters:SetAnchor(BOTTOM, GuiRoot, BOTTOM, 0, 20)
      -- cloned from the ESOUI code, this syncs the position into the
      -- SavedVariables, so we should be correct after a clean exit.
      ZO_PerformanceMeters_OnMoveStop(ZO_PerformanceMeters)
    end

    -- should only ever need to do this once, and once only
    logger:Debug("UnregisterForEvent")
    EVENT_MANAGER:UnregisterForEvent(NAME, EVENT_PLAYER_ACTIVATED)
end

local function HandleRareFishTracker()
  if not (RFT and RFT.window and RFT.window.GetAnchor) then
    return
  end

  local window = RFT.window
  local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY, anchorConstraints = window:GetAnchor(0)
  if not isValidAnchor then
    logger:Debug("RareFishTracker: anchor 0 is not valid")
    return
  end

  if point ~= TOPRIGHT
    or relativeTo ~= TOPRIGHT
    or offsetX ~= -280
    or offsetY ~= 5
  then
    RFT.account.lockPosition = false
    setWindowPosition(window, TOPLEFT, GuiRoot, TOPLEFT, GuiRoot:GetWidth() - window:GetWidth() - 280, 5)
    RFT.account.lockPosition = true
  end

  if RFT.settings.shown or RFT.settings.shown_world then
    RFT.settings.shown = false
    RFT.settings.shown_world = false
    RFT.RefreshWindow()
  end
end


local function HandleInventorySpaceWarning()
  if not (InventorySpaceWarning and InventorySpaceWarning.savedVariables) then
    return
  end

  local sv = InventorySpaceWarning.savedVariables
  if sv.left ~= 725 or sv.top ~= 560 then
    sv.left = 725
    sv.top = 560
    InventorySpaceIndicator:ClearAnchors()
    InventorySpaceIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sv.left, sv.top)
  end

  if sv.alwaysShow == true then
    InventorySpaceWarning.UpdateAlwaysShowState(false)
  end

  if sv.spaceLimit ~= 30 then
    InventorySpaceWarning.UpdateSpaceLimit(30)
  end
end


local function HandleCombatMetronome()
  -- this one is blessedly easy, thank the heavens.
  if not (CombatMetronome and CombatMetronomeSavedVars) then
    return
  end
  if not CombatMetronome.config.global then
    if CombatMetronome.menu.options[2].name ~= "Account Wide" then
      logger:Error("CombatMetronome: unexpected menu option ["..CombatMetronome.menu.options[2].name.."]")
      return
    end
    CombatMetronome.menu.options[2].setFunc(true)
  end
end


local function HandleSwitchBar()
  if not (SwitchBar and SwitchBar.SavedVars and SwitchBarMain) then
    return
  end

  local sv = SwitchBar.SavedVars
  if sv.offsetX ~= 850 or sv.offsetY ~= 520 then
    setWindowPosition(SwitchBarMain, TOPLEFT, GuiRoot, TOPLEFT, 850, 520)
  end
  if sv.hideBackground ~= true then
    SwitchBar.SetBGHidden(true)
  end
  if sv.bgAlpha ~= 75 then
    SwitchBar.SetAlpha(75)
  end
  if sv.size ~= 48 then
    SwitchBar.SetSize(48)
  end
end

EVENT_MANAGER:RegisterForEvent(NAME, EVENT_PLAYER_ACTIVATED, function(_, intitial)
    HandlePerformanceMeters()
    HandleRareFishTracker()
    HandleInventorySpaceWarning()
    HandleCombatMetronome()
    HandleSwitchBar()
end)
