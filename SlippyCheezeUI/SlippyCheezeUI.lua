local NAME = 'SlippyCheezeUI'
local logger = LibDebugLogger("SC-UI")
-- logger:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)

EVENT_MANAGER:RegisterForEvent(NAME, EVENT_PLAYER_ACTIVATED, function(_, intitial)
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
end)
