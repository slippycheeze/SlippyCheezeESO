-- this looks like it can get away with being the second most minimalist addon ever
-- local logger = LibDebugLogger("SC-DWA")
-- logger:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)


-- auto-flush the TTC data saved for upload on every UI reload, after the player
-- is available.  since that is 100 percent after data is loaded, this should be
-- perfectly safe.
--
-- done on every cycle since it'll upload after, eg, /reloadui as well as login.
local NAME = "SC-TTCAutoClear"
EVENT_MANAGER:RegisterForEvent(NAME, EVENT_PLAYER_ACTIVATED, function()
    local TTC = TamrielTradeCentre
    if TTC and TTC.Data and TTC.Data.AutoRecordEntries then
      TTC.Data.AutoRecordEntries.Guilds = {}
      TTC.Data.AutoRecordEntries.Count = 0

      EVENT_MANAGER:UnregisterForEvent(NAME, EVENT_PLAYER_ACTIVATED)
    end
end)
