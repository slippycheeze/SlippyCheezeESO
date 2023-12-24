-- this looks like it can get away with being the second most minimalist addon ever
-- local logger = LibDebugLogger("SC-DWA")
-- logger:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)

-- 

-- include or not inheritcolor in this, so if I flip to some colored one I can
-- more easily turn it off.
-- local chestIcon = 'esoui/art/icons/mapkey/mapkey_bank.dds:inheritcolor'
-- local iconSize  = '80%'
-- local chestColor = 'FF4500'     -- bright orange
-- local formattedAlert = '|c%s|t%s:%s:%s|t%s|c':format(
--   chestColor,
--   iconSize,
--   iconSize,
--   chestIcon,
--   'CHEST'
-- )


local emotion = {
"sweet Riddle'Thar",
"Jone and Jode",
"heart of Mara",
"bright moons",
"wabbacat",
  
}

-- basic list of random messages.
local MESSAGES = {
  "A chest unlocked, revealing its long-lost treasures!",
  "A chest, once hidden, now reveals its hidden riches!",
  "A clever Khajiit unveils a chest filled with hidden riches!",
  "A cunning find! A chest overflowing with treasures!",
  "A cunning Khajiit reveals a treasure chest's secrets!",
  "A hidden chest unveils its secrets to a resourceful Khajiit!",
  "A humble chest conceals a wealth of treasures!",
  "A Khajiit's agile paws unveil a chest bestowed with treasures!",
  "A Khajiit's dexterity unlocks a chest filled with hidden riches!",
  "A Khajiit's keen eye spots a chest of hidden wonders!",
  "A Khajiit's keen senses detect a chest brimming with hidden riches!",
  "A Khajiit's stealth uncovers a chest of concealed treasures!",
  "A mischievous Khajiit reveals a chest concealing hidden wonders!",
  "A secret chest graces me with its hidden treasures!",
  "A sneaky Khajiit uncovers a chest filled with hidden treasures!",
  "A stealthy Khajiit reveals a chest of hidden wealth!",
  "A stealthy paw reveals a hidden chest of treasures!",
  "A whisper from the shadows led me to this treasure chest of wonders!",
  "A wily Khajiit uncovers a chest full of hidden riches!",
  "Aaah, the thrill of discovery! A chest filled with treasures awaits.",
  "Behold! A hidden chest reveals its secrets to this one.",
  "Behold, a chest that relinquishes its hidden treasures to a Khajiit!",
  "Behold, a hidden prize discovered in a chest!",
  "By claws and stealth, a hidden chest discovered, its riches claimed.",
  "By the moons! A chest filled with hidden spoils awaits discovery.",
  "By the moons! A concealed chest awaits, and I shall unveil its contents with nimble paws.",
  "Rajhin's luck! A chest uncovered, its treasures mine.",
  "Enchanting treasures lie within! A Khajiit reveals a hidden chest!",
  "Eureka! A hidden chest filled with treasures unveils itself!",
  "Fortune smiles upon me! A chest of treasures revealed.",
  "Gaze upon the Khajiit's success, a chest filled with hidden wonders!",
  "Hear this, fellow wanderers! A chest discovered, riches within!",
  "Hidden no more, a chest beckons with its mysterious contents.",
  "Hidden within a chest lies a trove of treasures!",
  "In the darkness, a chest whispers of concealed treasures!",
  "In the shadows, a chest of hidden treasures awaits!",
  "Look here! A hidden chest yields its bountiful rewards.",
  "Look, a concealed chest revealing its secrets!",
  "Oh, the treasures within! A Khajiit has found a hidden chest!",
  "Paws of fortune! A chest unearthed, treasures await!",
  "Paws of the Khajiit unlock a chest brimming with treasures!",
  "Rejoice! A chest uncovered, its treasures now claimed.",
  "Rejoice, for the shadows relinquish their hold on a chest of hidden treasures!",
  "Revealed from shadows, riches held within this humble chest!",
  "Sands of luck! A chest discovered, filled with untold riches.",
  "The keen eyes of the Khajiit find a chest of hidden wonders!",
  "The Khajiit's senses detect a chest full of hidden bounty!",
  "The sands of fate have revealed a hidden treasure, and this Khajiit moves to unlock its mysteries.",
  "This khajiit's keen eye uncovers a treasure-filled chest.",
  "This one has found a hidden chest, filled with secrets and treasures.",
  "This one has stumbled upon a cache, and now attends to its secrets.",
  "With a sly smile, a Khajiit discovers a hidden chest of treasures!",
  "With grace and cunning, a Khajiit reveals a hidden chest of wonders!",
  "With grace, my paws uncover a treasure chest!",
  "With stealth and skill, a Khajiit uncovers a treasure chest!",
  "Witness the elegance of a Khajiit revealing a hidden chest!",
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
