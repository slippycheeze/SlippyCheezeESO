EVENT_MANAGER:RegisterForEvent(
  "HiderNoHiding",
  EVENT_PLAYER_ACTIVATED,
  function()
    if LibDebugLogger then
      LibDebugLogger:SetBlockChatOutputEnabled(false)  -- don't block d() output
    end
  end
)
