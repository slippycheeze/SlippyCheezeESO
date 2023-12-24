local logger = LibDebugLogger("SC-PAAR")
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

-- performance hacks
local EVENT_MANAGER = EVENT_MANAGER
local unpack = unpack
local select = select

if AutoResearch == nil then
  logger:Info("AutoResearch is not present")
elseif PersonalAssistant == nil then
    logger:Info("PersonalAssistant is not present")
elseif PersonalAssistant.Worker == nil then
    logger:Info("PersonalAssistant.Worker is not present")
else
  -- no need to wait, everything we want for hooking is already present when
  -- this file is evaluated, so we are good to go!
  logger:Info("will hook PA Worker StartCraftingInterraction")
  local PAWorker_StartCraftingInterraction = PersonalAssistant.Worker.StartCraftingInterraction

  -- forward-declare the hook function, since the defer/hook pair want to
  -- reference each other.  replaced shortly.
  local BeforeStartCraftingInterraction = function()
    logger:Error("BeforeStartCraftingInterraction dummy function called!")
  end
  
  -- don't have to care if this is called twice, as it'll just reset the delay
  -- and call it a bit later.  which is just fine™.
  local function DeferFor(delay, ...)
    local deferredArguments = {...}  -- needed to be able to reference the varargs in the closure.

    EVENT_MANAGER:RegisterForUpdate("SC-PAAR", delay, function()
        EVENT_MANAGER:UnregisterForUpdate("SC-PAAR")
        BeforeStartCraftingInterraction(unpack(deferredArguments))
    end)
  end

 BeforeStartCraftingInterraction = function(...)
    if select('#', ...) == 0 then
      logger:Debug("we closed the crafting interface")
      active = false
      state  = IDLE
    else
      active = true
    end

    if not active then
      return PAWorker_StartCraftingInterraction(...)
    end

    if state == IDLE then
      -- first call, we need to reschedule to make sure the AutoResearch event
      -- handler is called first; without that it will by default be called after
      -- our handler, and we can't tell if it is going to interrupt our work.
      logger:Debug("IDLE → WAIT_FOR_AUTORESEARCH")
      state = WAIT_FOR_AUTORESEARCH
      -- delay zero means "next frame", which is definitely after *all* our
      -- callbacks have been run.
      return DeferFor(0, ...)   
    end

    if state == WAIT_FOR_AUTORESEARCH then
      local rs = AutoResearch.researchState
      if rs == 'stopping' or rs == 'stopped' then
        -- AutoResearch is done, 
        logger:Debug("WAIT_FOR_AUTORESEARCH → BUSY, AutoResearch.researchState is", rs)
        state = BUSY
      end
    end

    if state == BUSY then
      logger:Debug("calling PersonalAssistant from state", state)
      state = WEIRD               -- catch if I am invoked more times than expected.
      return PAWorker_StartCraftingInterraction(...)
    else
      logger:Debug("deferring call with state =", state, "active =", active, "AR.rs =", AutoResearch.researchState)
      return DeferFor(100, ...)
    end
  end

  -- attach the actual hook function now.
  PersonalAssistant.Worker.StartCraftingInterraction = BeforeStartCraftingInterraction
  logger:Info("PA Worker StartCraftingInterraction hook was installed")
end
