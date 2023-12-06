-- this looks like it can get away with being the second most minimalist addon ever
local logger = LibDebugLogger("SC-DWA")
-- logger:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)

EVENT_MANAGER:RegisterForEvent(
  "DrawWeaponsAutomatically",
  EVENT_RETICLE_TARGET_CHANGED,
  function()
    -- we are expected to query things here, no data attach to event. :(
    if
      ArePlayerWeaponsSheathed()
      and DoesUnitExist("reticleover")
      and not IsUnitDead("reticleover")
      and GetUnitReaction("reticleover") == UNIT_REACTION_HOSTILE 
    then
      -- everything worked, time to goooo.
      logger:Debug(
        'TogglePlayerWield(): '..'/'..
        tostring(GetUnitDisplayName("reticleover") or 'nil')
        ..'/'..
        tostring(GetUnitNameHighlightedByReticle() or 'nil')
        ..'/'..
        tostring(GetUnitName("reticleover") or 'nil')
        ..'/'..
        tostring(GetUnitType("reticleover") or 'nil')
        ..'/'
      )
      TogglePlayerWield()
    end
  end
)
