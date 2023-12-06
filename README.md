# SlippyCheeze ESO micro-addons

**WARNING**: this is the stuff that is so small, or so niche, or whatever, that
I don't think it worth pushing to ESOUI.  so, uh, not really expecting
much interest.

In the event someone out there wants to contact me about them,
PC-EU `@SlippyCheeze` is much more likely to get a response than either email or
a message here.

## Draw Weapons Automatically

When your reticle passes over a hostile enemy, draw your weapons if they were
sheathed, and nothing gets in the way.  This uses the ZOS definition of "enemy
under the reticle" which can be weirdly broad, but generally works out
well enough.

At the very least, it mostly stopped me being frustrated because my first "light
attack" did nothing but trigger weapons out, when I *expected* it to hit
something with a pointy thing or zappy thing.


## Bar Swap Fail Warning (**INCOMPLETE**)

When finished, this will detect if the bar swap key has been pressed, but is not
followed by an actual bar swap event.  If that happens, it'll **REVISIT**
somehow warn about the fact.

Of course, once code complete, it'll need some significant testing, because I'll
bet there are a dozen edge cases that I need to account for around all this.

Easy repros are: hit "weapon swap" twice in quick succession, or start a channel
like Arcanist Cephelarch Flail and weapon swap after it begins (~ 1 server RTT,
I think) but before the 0.3 second channel happens.


## Khajiit Lockpick Notifier

A little hack on the excellent [Lockpick Notifier][LockpickNotifier] addon,
which fills out a message for group chat when you start unlocking a chest in
a dungeon and/or trial.

I wanted a bit of variety to what it said, instead of a single fixed message,
because who doesn't like a bit of light role-play now and then?

So, this swaps to a new, random, Khajiit themed comment after every lockpick
attempt, regardless of if it was announced or not.  More random than necessary,
but rare enough I don't care.

[LockpickNotifier]: https://www.esoui.com/downloads/info3085-LockpickNotifier.html


## Personal Assistant and AutoResearch

Integrates these two addons, so that AutoResearch doesn't fight over the
crafting station with Personal Assistant doing automatic deconstruction, etc.

Written before PA had auto-research features, but kept becuase it PA isn't going
to add the same sort of priority ordering that AR offers, and I /do/ want to
research traits in priority order while I build back up my crafter on
a new server.


## Hider, No Hiding

LibDebugLogger comes with a feature to hide the output of a ZOS provided "debug"
function; sadly, it used to be the more or less standard way to emit messages
for the user from addons.

So having it hidden is **technically** correct, but not actually very helpful:
a bunch of addons I use depend on it outputting the message to show,
eg, progress.

This simply disabled the feature at load time, then vanishes.


## SlippyCheezeUI

Small UI tweaks for myself.  You almost certainly don't want to use this, unless
you are me.  See the code itself for what it does, if you are, or you do.
