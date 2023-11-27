-- this looks like it can get away with being the second most minimalist addon ever
-- local logger = LibDebugLogger("SC-DWA")
-- logger:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)


-- basic list of random messages.
local MESSAGES = {
  "Behold, a hidden prize discovered in a chest!",
  "Look, a concealed chest revealing its secrets!",
  "With grace, my paws uncover a treasure chest!",
  "A humble sack conceals a wealth of treasures!",
  "The keen eyes of the Khajiit find a chest of hidden wonders!",
  "Meow! A chest of treasures is unveiled!",
  "In the shadows, a sack of hidden treasures awaits!",
  "A cunning Khajiit reveals a treasure chest's secrets!",
  "Meow-some treasure discovered in a hidden chest!",
  "Purrrfect! A sack brimming with concealed riches!",
  "A secret chest graces me with its hidden treasures!",
  "The Khajiit's senses detect a sack full of hidden bounty!",
  "Hidden within a chest lies a trove of treasures!",
  "A stealthy Khajiit reveals a chest of hidden wealth!",
  "A cunning find! A sack overflowing with treasures!",
  "With stealth and skill, a Khajiit uncovers a treasure chest!",
  "Hear me roar! A hidden chest gifts its treasures to a Khajiit!",
  "A sneaky Khajiit uncovers a sack filled with hidden treasures!",
  "A Khajiit's keen eye spots a chest of hidden wonders!",
  "Paws of the Khajiit unveil a sack brimming with treasures!",
  "Witness the elegance of a Khajiit revealing a hidden chest!",
  "Hidden vermin? Nay, a chest of treasures!",
  "A stealthy paw reveals a hidden chest of treasures!",
  "Huzzah! A secret sack reveals its concealed bounty!",
  "A wily Khajiit uncovers a chest full of hidden riches!",
  "Mrrrow! A sack overflowing with hidden treasures!",
  "A Khajiit's agile paws unveil a chest bestowed with treasures!",
  "Meow-nificent! A hidden chest yields its hidden bounty!",
  "Gaze upon the Khajiit's success, a sack filled with hidden wonders!",
  "A chest, once hidden, now reveals its hidden riches!",
  "A cunning Khajiit uncovers a trove concealed within a chest!",
  "With a sly smile, a Khajiit discovers a hidden sack of treasures!",
  "A feline masterstroke reveals a chest laden with hidden riches!",
  "Oh, the treasures within! A Khajiit has found a hidden chest!",
  "A mischievous Khajiit reveals a sack concealing hidden wonders!",
  "Paws of the Khajiit unlock a chest brimming with treasures!",
  "In a hidden realm, a chest yields its precious bounty!",
  "A clever Khajiit unveils a sack filled with hidden riches!",
  "Meow-tastic! A hidden chest reveals its hidden trove!",
  "A Khajiit's stealth uncovers a sack of concealed treasures!",
  "Behold, a chest that relinquishes its hidden treasures to a Khajiit!",
  "Eureka! A hidden sack filled with treasures unveils itself!",
  "A Khajiit's keen senses detect a chest brimming with hidden riches!",
  "In the darkness, a chest whispers of concealed treasures!",
  "With grace and cunning, a Khajiit reveals a hidden sack of wonders!",
  "A hidden chest unveils its secrets to a resourceful Khajiit!",
  "Meow-lodic! A hidden sack grants its treasures to a clever Khajiit!",
  "A Khajiit's dexterity unlocks a chest filled with hidden riches!",
  "Enchanting treasures lie within! A Khajiit reveals a hidden chest!",
  "Behold my triumph! A hidden sack spills forth its concealed treasures!",
  "Paws of fortune! A chest unearthed, treasures await!",
  "Behold! A hidden chest reveals its secrets to this one.",
  "By the moons! A sack filled with hidden spoils awaits discovery.",
  "Hear this, fellow wanderers! A chest discovered, riches within!",
  "This khajiit's keen eye uncovers a treasure-filled sack.",
  "Rejoice! A chest uncovered, its treasures now claimed.",
  "Look here! A hidden chest yields its bountiful rewards.",
  "Fortune smiles upon me! A sack of treasures revealed.",
  "Sands of luck! A chest discovered, filled with untold riches.",
  "This one has found a hidden chest, filled with secrets and treasures.",
  "Revealed from shadows, riches held within this humble sack!",
  "A chest unlocked, revealing its long-lost treasures!",
  "Meow-velous! A hidden sack brimming with hidden treasures.",
  "Aaah, the thrill of discovery! A chest filled with treasures awaits.",
  "By claws and stealth, a hidden chest discovered, its riches claimed.",
  "Listen, fellow adventurers! A sack of riches lies waiting.",
  "A whisper from the shadows led me to this treasure chest of wonders!",
  "Hidden no more, a chest beckons with its mysterious contents.",
  "Cat's luck! A sack uncovered, its treasures now mine.",
  "Rejoice, for the shadows relinquish their hold on a chest of hidden treasures!",
  "This one has stumbled upon a cache, and now attends to its secrets.",
  "The sands of fate have revealed a hidden treasure, and this Khajiit moves to unlock its mysteries.",
  "By the moons! A concealed chest awaits, and I shall unveil its contents with nimble paws.",
}


-- hook the LockpickNotifier code, and randomize the message after every
-- invocation of the function with the announcement.  this will probably trigger
-- more often than necessary, but YOLO, random is random.
ZO_PreHook(LPN, "StartLockpick", function()
    if LPN and LPN.savedVars then
      local index = 1 + math.floor(math.random() * #MESSAGES)
      if MESSAGES[index] then
        LPN.savedVars.messageText = MESSAGES[index]
      end
    end
end)
