SC_BSFW = SC_BSFW or {}

-- performance hacks
local NAME = "BarSwapFailWarning"
local BSFW = SC_BSFW
local EVENT_MANAGER = EVENT_MANAGER


local logger = LibDebugLogger("SC-BSFW")
logger:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)


local function OnWeaponSwapFailed()
  EVENT_MANAGER:UnregisterForUpdate(NAME)
  logger:Error("BSFW detected a weapon swap failure")
end

-- invoked from bindings.xml when we trigger.  explicitly returns `false` to
-- allow "other layers" to handle the event, which is how I observe but don't
-- interrupt the normal (and highly secure) function of the swap action.
--
-- see the last footnote in https://wiki.esoui.com/Key_bindings
function SC_BSFW_OnWeaponSwap(keybind)
  -- this is called unconditionally from the XML, so I need to apply the same
  -- conditional logic that the base game does to ensure an *actual* ability bar
  -- swap is intended here.
  --
  -- https://github.com/esoui/esoui/blob/e19757b4ef1bdc76345f09cc1497dce8072920b2/esoui/ingame/globals/bindings.xml#L102
  --
  -- ```lua
  -- if SKILLS_FRAGMENT and SKILLS_FRAGMENT:IsShowing() then
  --   ACTION_BAR_ASSIGNMENT_MANAGER:CycleCurrentHotbar()
  -- else
  --   OnWeaponSwap()
  -- end
  -- ```
  if SKILLS_FRAGMENT and SKILLS_FRAGMENT:IsShowing() then
    -- this is a fakey version, used to manage skill assignment, and won't
    -- trigger the events needed to cancel the warning, so ignore.
    logger:Debug("ignoring swap while SKILLS_FRAGMENT is showing")
    return false
  end


  -- BSFW.weaponSwapTime = GetTimeString()  -- good enough for government work, and debugging.
  -- BSFW.weaponSwapFrame = GetFrameTimeMilliseconds()  -- really thorough?  IDK.

  -- register for an update in 30ms; if we already had a timer running, this
  -- will overwrite it with another 30ms version, which should probably do what
  -- I want, I think?  probably?
  logger:Debug("SC_BSFW_OnWeaponSwap is registering OnWeaponSwapFailed")
  EVENT_MANAGER:RegisterForUpdate(NAME, 300, OnWeaponSwapFailed)

  return false                  -- I did *NOT* consume this event.
end


local function OnActiveWeaponPairChanged(_, activeWeaponPair, locked)
  logger:Debug("SC_BSFW_OnActiveWeaponPairChanged is unregistering OnWeaponSwapFailed", activeWeaponPair, locked)
  EVENT_MANAGER:UnregisterForUpdate(NAME)
end


-- invoked when our addon is ready to be configured — "static" function!
local function OnAddOnLoaded(_, addonName)
  -- WARNING: not a method, just a function.
  if addonName == NAME then
    logger:Debug("OnAddOnLoaded invoked, binding events and inserting action layer")

    -- catch hold of the notification that fires *after* the swap has happened.
    EVENT_MANAGER:RegisterForEvent(NAME, EVENT_ACTIVE_WEAPON_PAIR_CHANGED, OnActiveWeaponPairChanged)

    -- inject our action layer into the stack, directly above the "general"
    -- action layer that holds the standard keybinds for weapon swapping.
    --
    -- placement is very deliberate, since I want to be *sure* that anything
    -- intending to override the general layer *also* overrides my
    -- warning generation.
    InsertNamedActionLayerAbove("SC_BSFW_OBSERVER", GetString(SI_KEYBINDINGS_LAYER_GENERAL))

    EVENT_MANAGER:UnregisterForEvent(NAME, EVENT_ADD_ON_LOADED)  -- don't care any more.
  end
end

-- REVISIT: disabled until I figure out how to show an alert

-- EVENT_MANAGER:RegisterForEvent(NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

