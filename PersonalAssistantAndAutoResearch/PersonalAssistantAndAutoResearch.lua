local logger = LibDebugLogger("SC-PAAW")
logger:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)


-- sadly, I need a state machine to keep track of where everything is going.
--
-- nil  - not at a crafting station
local IDLE = 1
local WAIT_FOR_AUTORESEARCH = 2
local BUSY = 3
local WEIRD = 4

local active = false
local state = IDLE

local function BeforeStartCraftingInterraction(orig, ...)
  if select('#', ...) == 0 then
    logger:Debug("we closed the crafting interface")
    active = false
    state  = IDLE
  else
    active = true
  end

  if not active then
    return orig(...)
  end

  if state == IDLE then
    -- first call, we need to reschedule to make sure the AutoResearch event
    -- handler is called first; without that it will by default be called after
    -- our handler, and we can't tell if it is going to interrupt our work.
    logger:Debug("IDLE → WAIT_FOR_AUTORESEARCH")
    state = WAIT_FOR_AUTORESEARCH
    
    local deferred = {...}
    return zo_callLater(function() BeforeStartCraftingInterraction(orig, unpack(deferred)) end, 0)
  end

  if state == WAIT_FOR_AUTORESEARCH then
    local rs = AutoResearch.researchState
    if rs == 'stopping' or rs == 'stopped' then
      -- AutoResearch is done, 
      logger:Debug("WAIT_FOR_AUTORESEARCH → BUSY, AutoResearch.researchState is", AutoResearch.researchState)
      state = BUSY
    end
  end

  if state == BUSY then
    logger:Debug("calling PersonalAssistant from state", state)
    state = WEIRD               -- catch if I am invoked more times than expected.
    return orig(...)
  else
    logger:Debug("deferring call with state", state, "and active", active)
    local deferred = {...}
    return zo_callLater(function() BeforeStartCraftingInterraction(orig, unpack(deferred)) end, 100)
  end
end



if AutoResearch == nil then
  logger:Info("AutoResearch is not present")
elseif PersonalAssistant == nil then
    logger:Info("PersonalAssistant is not present")
elseif PersonalAssistant.Worker == nil then
    logger:Info("PersonalAssistant.Worker is not present")
else
  -- no need to wait, everything we want for hooking is already present when
  -- this file is evaluated, so we are good to go!
  logger:Info("hooking PA Worker StartCraftingInterraction")
  local orig = PersonalAssistant.Worker.StartCraftingInterraction
  PersonalAssistant.Worker.StartCraftingInterraction = function(...)
    return BeforeStartCraftingInterraction(orig, ...)
  end
end
