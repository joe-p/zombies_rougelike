# Zombies Rougelike

A work-in-progress rougelike mode for Call of Duty: Black Ops III Zombies. The goal is to create a fun gameplay loop that offers even more replayability to the game by adding variety to the mid and late game.

# Current Features

## Starting Loadout

The chosen map's starting loadout is preserved, but the player will also be given a bowie knife to balance for the fact that a weapon cannot be aquired until the shop round is reached (and enough doors are opened to reach a box).

## Diffulty Scaling

Right now the only adjustment to difficulty is an increase in zombie speed earlier than normal.

## Shop Rounds

Shop rounds occur every three rounds. They currently last for 60 seconds and during the shop no zombies are spawned.

### Shop Menu

Every shop round the player is presented with three random perks to buy. Currently the shop only contains standard perks, but eventually it will be expanded to contain more unique items.

### Mystery Boxes

Every shop round a "firesale" is activated which causes all mystery boxes in the map to become active. Unlike regular firesales, however, every box *starts* at 950 (or whatever the map default is) and its price raises exponentially. For example, the box starts at 950, then 1,900 after the first use, then 7,600 after the second use, and so on. This means that early on it is beneficial to open the doors to different boxes to get their lower prices. In co-op, it is optimial for each player to go to a different box to prevent this exponential price growth. The exact scaling may be adjusted in the future, but the idea is to make it harder to switch guns mid-game to add more variety to different runs.

# Planned Features

* Reduce effects of base perks but allow them to be bought multiple times (ie. jugg gives less health it normally does, but you can get more by buying it multiple times)
* Add more unique items to shop with various synergies and tradeoffs (health, damage, speed, drop-rates, scoring, etc.)
* Determine good scaling model for both the player and zombies health/damage to allow for a less monotonous late-game

# Map Compatibility

One of the goals of this mode is to support as many maps as possible. The mod tries to make as few assumptions as possible about how the map behaves, but below are the requirements for a map to be compatible. If you are not a map developer, you don't need to worry about this as most maps will be compatible out of the box.  

## Firesale

This mod requires that the map keeps the default `zm_powerup_fire_sale::start_fire_sale` OR implements it with the same notifies: `fire_sale_on` and `fire_sale_off`. `fire_sale_on` should indicate that all the boxes are spawned and the chest cost, defined by `.zombie_cost`, will not change afterwards. It is also expected that `level.zombie_vars["zombie_powerup_fire_sale_time"]` is respected by `zm_powerup_fire_sale::start_fire_sale`.

## Chests

Each chest in the map (that should work with firesale) should be in `level.chests`. The chest must notify `chest_accessed` when it is used and it should respect `zm_magic_chest::hide_chest();`.

# Credits

* [L3akMod](https://wiki.modme.co/wiki/black_ops_3/Lua-(LUI).html) - The D3V Team (DTZxPorter, SE2Dev, Nukem)
* [Cold War Wunderfizz v3.2](https://www.devraw.net/releases/cold-war-wunderfizz-v3.2) - Dobby
* [Black Ops 3 Mod Tools Discord](https://discord.com/invite/black-ops-3-mod-tools-230615005194616834) - Everyone there has been super helpful! (especially Scrappy and Rayjiun)
* [T7MTEnhancements](https://github.com/Scobalula/T7MTEnhancements) - [Scobalula](https://github.com/Scobalula/)
* [Decompiled Scripts](https://github.com/shiversoftdev/t7-source) - [serious](https://github.com/shiversoftdev)
