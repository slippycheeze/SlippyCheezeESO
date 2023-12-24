-- this looks like it can get away with being the second most minimalist addon ever
-- local logger = LibDebugLogger("SC-DWA")
-- logger:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)
local AC = AutoCategory

AC.RegisterPlugin("AutoCategoryExtras", function()
    AC.AddRuleFunc("id", function(...)
        local id = GetItemLinkItemId(AC.checkingItemLink)
        if not ... then
          return id
        end
        -- list of ID values, scan for them.
        for _, value in pairs({...}) do
          if value == id then
            return true
          end
        end
        return false
    end)
end)
