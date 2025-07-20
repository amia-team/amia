
=# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

### Added
- Barrier PLC to the palette
- Dale food/drinks (Fendel's new shop) to the palette
- New merchant file (Hinn Inn)

### Changed
- PLC palette
- Plot updates to
	- Underdark: Bloodspear Keep
	- Underdark: Hollow Cavern
	- East Coast: Sandy Beach
	- Kingdom of Kohlingen: Greengarden, The Old City
- Settlement System guard update to The Dale

### Fixed

[4.20.1 2025-07-13]
### Added
- Guard equipment items to the palette
- Kohlingen, Winya, Dale, Barak Runedar settlement guards
- War troops widget for war events
- War troops script

### Changed
- Shifters no longer lose shape-casted spells upon unshifting
- While polymorphed, Intensity, Rage and Ferocity monster abilities now buff two abilities as per the base spell
- Polymorphing no longer has a cooldown
- Adjusted a few existing scripts to account for war troops
- Fixed some more Bloodspear settlement guards on the palette
- East Coast: Sandy Beach plot update

### Fixed
- Defensive Stance's effects are no longer removed when you lose the temporary HP


[4.19.0 2025-06-22]
### Added
- 1 Player portrait
- Monkey Grip feat (general feat, requires 13+ STR and +3 Base Attack Bonus)

### Changed
- (Creature Type) Empathy widgets are all 3/Day now
- Trog lizards are slightly bigger
- Item/Creature/PLC palettes updated in-game
- Two-handed weapon bonus now works with polymorph effects (only affects Risen Lord)
- Risen Lord strength decreased from 24 to 20 to counterbalance the two-handed bonus 

### Fixed
- Some PLC positioning in a player house (OCD edition)
- Changed a painting in a different player house
- Hunter Frog and Desert Beetle Matriarch voicesets
- Maximus's bio no longer says it's on Amia
- Khem: Anara Oasis secret door spawns correctly now
- Hidden transition in Serpent Isle: Library is bigger now
- Southport East medium rental home will go inside now
- Bloodspear Badge has a bio now
- Removed an incorrectly locked door in Bloodspear Keep Interior
- Eldritch Spear no longer applies damage and effect to the main target twice
- Eldritch Blast now crits instead of misses on rolling a 20 with touch attack
- Warlock multisummoning is now less silly and uses actual summons instead of henchmen
- (Let us know if other multisummoning is behaving poorly so we can update it to the new method!)
- Aura of Alignment no longer doubles SR and damage shield when cast as extended
- Amia's two-handed bonus no longer has a rounding error that resulted in a slight loss of damage
- Two-handed bonus now updates on strength loss and gain
- Owl's Wisdom is now applied while polymorphed (apparently this was a thing the whole time)


[4.16.0 2025-06-07]
### Added
- Undead guard for Bloodspear to palette

### Changed
- Made tridents affected by Weapon Finesse for Small characters (2-handed) just like Spear for Medium characters
- Finished 1 player housing
- Bloodspear guards in the guard summoner area are updated and ready for leader use now
- Invasions for all areas have been disabled

### Fixed
- Put missing clothes back on a nanny
- Shifter Goblin Voodoo Stick appearance
- Bloodspear monster NPCs (in-game and on palette) are now evil monsters, and not CG humans
- Corruptor of Fate (EMD Summon) is no longer naked
- Removed a spell from all settlement mages, spawned and in-game
- Ogrillon in Sandy Beach isn't T-posing anymore
- Removed a buggy robe mounted pheno
- Remove the No-PvP flag in Fortress Wiltun
- Chromatic Crystal node in Plane of Elemental Earth: Glittering Cavern
- Fix the cost of a 10-stack of Rogue's Cunning potions
- Removed Khem option from Sailor Ernods' dialogue in Fort Cystana: South
- Mishnaeglen's Flower quest

[4.15.0 2025-03-30]
### Added
- New phenotypes for robes 33 and 216
- New Djinni Temple (Puzzle centric dungeon)

### Changed
- DM dummy area names 1-9 > 01-09
- Plot updates to
	- Obsidian Isle: Calderis, Great Hall
	- Obsidian Isle: Calderis, The Midnight Rose
	- Obsidian Isle: Calderis, Thunderstrike's Demise
- Removed Stoneshield Armors, Helmet of Seafolk, and Elemental Mastery Gloves (Will add to Epic Bin or another method in future)
- Moved all Blistering Weapons to Abyss shop
- Reduced Sandy Beach invasion density
- Removed archers from Demon Invasion, lower spawn density
- Ghoul Touch AOE now decreases 2 physical damage instead of 2 magical damage
- Shadow Conjuration, Greater Shadow Conjuration, and Shades now have the same metamagic options as the base spells

### Fixed
- Bane spell and hostile cantrips now correctly signal the target and remove caster's invis/sanctuary
- DTS pickpocket fixed. Checks to see if you have the skill before giving you +50. 
- DTS doesnt give XP if you are level 30 once more 
- Cav Horse Widget now displays the name of custom mount's names in the conversation window
- Ancient Barrier Devices now use the proper VFX for their type
- Ghoul Touch AOE now correctly applies -2 AB
- Magic Missile and Shadow Magic Missile, if the caster has epic spell focus, now correctly check for an additional target
- Infestation of Maggots no longer auto-succeeds against disease immune targets (apparently this was a thing all along!)

[4.14.0 2025-03-11]
### Added
- 19 Portraits
- 51 PLCs
- 136 Door models
- 94 Creature appearances (Witcher NPCs, horses, worms, kobolds, beetles, lots of animals, Tiamat)
- 14 VFX

### Changed
- Removed some obsolete DM areas
- Added an NPC to the Prancing Stallion in Gregory's Landing
- Player housing update
- Plot update to Fort Cystana: South

### Fixed
- Aura versus Alignment no longer stacks with itself for a bajillion SR
- Exploding cat in Destrier Stables
- Aeolosh's portrait (hopefully)
- Removed excessive Farmer nodes from Khem: Khalem
- Emerald Dragon and Hellfire Wyrm portraits
- Cat names in appearance.2da so they're alphabetical in Toolset for real

[4.13.0 2025-03-02]
### Added
- Crouching Lemur and Gregory's Landing settlements to the Beacon script
- Crouching Lemur beacon waypoint to the Beacon Activator item

### Changed
- Adjusted job nodes in:
	- Traveller's Rest
	- Kingdom of Kohlingen: Fort Cystana, Western Beach
	- Skull Peaks: Trummels
	- Obsidian Isle: Southeastern bay
- Plot updates to:
	- Kingdom of Kohlingen: Greengarden, Manor Grounds (spawn removal)
	- East Coast: Sandy Beach (add guards/broken idol of Mystra)
	- Underdark: Hollow Cavern (add guards)
	- Skull Peaks: Crouching Lemur Monastery
	- Kingdom of Kohlingen: Gregory's Landing
	- Kingdom of Kohlingen: Gregory's Landing, Elaraliel Estate
	- Amia Forest
- Moved the Sandy Beach world boss to Troll Wall area
- Updated some player housing

### Fixed
- Missing invasion variables in
	- Forest of Despair: Northwest
	- Forest of Despair: Moonpier Outpost
	- Moonpier
	- Underdark: Bloodspear Keep
- Floating sign in Moonpier: Community Center
- Argent Keep adjustment: Lord Commander's Quarters > Regent's Quarters

[4.12.0 2025-02-20]

### Fixed
- Portal in Obsidian Isle: Calderis, North
- Hidden area in Obsidian Isle

### Changed
- Plot changes to
	- Obsidian Isle: Volcano, Redwood Tribe Warren
	- Moonpier
	- Moonper: Community Center
	- Malarfang Forest: Northwest
	- Malarfang Forest: Moonpier Outpost
	- Ruathym: Ostland, Frygtmere North
	- Ruathym: Ostland, Ostdur

### Fixed
- Portal in Obsidian Isle: Calderis, North
- Fredoc's (quest in Glinulan's Hold) speechwithquest string variable
- Purple Worm's racial type (should be magical beast)
- Favored Enemy for all racial types
- Huge Leech faction to Hostile
- Portal in Obsidian Isle: Calderis, North
- Hidden area in Obsidian Isle

[4.11.0 2025-02-17]

### Added
- Blackguard Epic Fiendish Rest Menu selection added
- RA and Beans DM areas added
- Robe model 32 (Male Human Assassin phenotype)
- Added player tools feat that gets added on login
- Added beta preview of new associate chat tool (Bottled companions currently excluded)
- Dev Feature: First pass at a new way to define and manage spells in C#

### Changed
- Lesser Planar Binding, Evil: Canoloth [Neutral] adjusted to be in line with other summons
- Greater Planar Binding, Evil: Mezzeloth [Neutral] moved UP from planar binding, adjusted power
- Planar Binding & Planar Ally, Evil: Skereloth [Neutral] new skin to replace Mezzeloth, adjusted to be in line with other summons
- Gate 17 - 21, Evil: Sword Battleloth [Neutral] moved up from greater planar binding, adjusted power
- Gate 22 - 26, Evil: Nycaloth [Neutral] moved up from Gate 17-21, power adjusted
- Gate 27+, Evil: Yagnaloth [Neutral] moved up from Gate 22-26, power adjusted
- Vampiric regen scaling added to gate, feat adjustments, and claw fixes
- Blackguard NE summon reworked into Ultroloth, utility CC summon
- Trissa's name removed from sign in Wiltun's portal chamber
- Blackguard CE summon buffed: 2 more AC, Self Conceal 3, and Acid damage on daggers instead of negative energy
- Asabi, Bloated Basilisk boss nerfed to level appropriate
- Renamed 'Moonpier: Seer's Caves' > 'Moonpier: Community Center' (area refactor)
- Darkness now applies a blindness effect to monsters that are not protected via true seeing or ultravision
- Removed playertools command

### Fixed
- Fixed BGH desert area bug
- Party trigger back in Underriver
- Fix for Mishaeglan's quest in Caraigh's Old Shrine, cleaning up plcs/flags
- Fixed saving throws in Player Tools

[4.10.1 2025-02-05]

### Added
- Faction Pen created for Dev use
- Hangman's Cove Settlement Guards to core
- Barak Runedar Standard Guards deployed
- Big Game Hunter (BGH) additional option to hunt just bandits 
- Missing hawk for BGH deployed
- Faction standing are now reset when leaving BGH hunting zone for neutral critters like rabbits, etc

### Changed
- Southport, Central Shop tweaks
- Ancient Devices VFX updated
- Ancient Devices effects will override eachother instead of blocking now
- Hangman's Cove Guards deployed
- Big Game Hunter (BGH) bosses will now always drop their special loot
- BGH Moose will now drop large bones
- BGH Polar Bear will now drop large and medium bones
- Reduced Hide/MS on a multitude of BGH critters to make them easier to spot in areas.
- Heavily reduced chance to run into a bandit camp during BGH based on feed back

### Fixed
- Ice Giants DTS Fixed
- Big Game Hunter (BGH) Vicious spiders and cobra will now drop loot
- Resolved a few BGH areas that were empty on spawn in
- BGH issue where you could go into an occupied hunting zone resolved


## [4.9.0 - 2025-01-25]

### Added
- Greater Mythal drops will always occur for normal epic bosses 
- Traps for dungeons and DM use

### Changed
- mushroom node + prettying up cave mouth around Barrow Lake
- Demon Invasions: Chaos rises a bit higher now, and demon invasions will continue to come back till taken care of

### Fixed
- Warlock's Unflee the Scene no longer gives Uncanny Dodge for the spell duration. Also only applies the sanctuary effect if the warlock is in combat so as not unnecessarily flood the combat log when just hasting about.
- Khem Anara Oasis and Khem: Djedet Invasion numbers decreased


## [4.8.1 - 2025-01-21]

### Added
- Construction started in Old Kohl Tempus Temple
- Whalebones areas (plot only at the moment)

### Changed
- Old Kohl Update has a temple/keep now
- Removed Summon Creature III from troglodyte cleric
- Edited the bios of some of the bard song items for clarity
- Removed sneak attack immunity from various Abyss mobs
- Removed death spell immunity from certain Abyss mobs

### Fixed
- Sonicx fixes for Manor or Mourn, Electric Castle, Frost Giants, Bloodspear Arena, Bloodmoon Orcs, Actand non-epic
- Essence Crossbow recipe (Now asks for Zurkhwood heavy crossbow instead of Adamantine, lol)
- Zurkhwood spelling in Zurkhwood crafted items
- Bloated Basilisk will drop its quest item now
- Gibberling Camp Transition
- DTS no longer giving double XP to player
- DTS no longer counting summon in bonus DC equation
- Slightly decreased XP for challenges for DTS

## [4.7.0 - 2024-12-15]

### Added
- 3 New half-orc heads (#42, #43, #44)
- Creature appearances:
	- Dragon: Hellfire Wyrm
	- Dragon: Red, Realistic
	- Dragon: Bronze, Realistic
	- Hamster, Giant Space
- Portraits:
	- Hellfire Wyrm
	- Hamster
- 72 building PLCs
- Holdable hamster (torch appearance)
- Associate Customization, read here for more: https://www.amiaworld.com/phpbb/viewtopic.php?p=1231#p1231
- DTS to Ancient Mound Trogs
- DTS to Gibbering Maw
- Head Changer item for druid/shifter types
- Quests:
	- Endir's Point: Fernor Troll Quest
	- Djedet: Asabi Quest
- Invasion areas:
	- Forrstakkr: Mt Firth
	- Forrstakkr: Howness South Road
	- Frozenfar: Fernor Road, Coast
	- Khem: Anara Oasis
	- Khem: The Seven Sisters of Hoet
- Invasion Overflow:
	- Forrstakkr: Howness
	- Frozenfar: Endir's Point
	- Khem: Djedet
- DM commands added: createvfx, getvfx, removevfx, setsoundset

### Changed
- Gibbering Maw complete rework
- Ancient Mound Trogs dungeon changed up a bit
- Sand Minotaur DTS numbers and chests
- Lowland Swamp spawns (trogs only show at night now)
- Default portraits for base 10 chromatic/metallic dragons (they look better now)
- Default raven model looks like a raven now
- Headchanger blocker updated for new/un-hidden heads
- Continued updates to Mizfit and Moonlight
- Visualizer-made visual effects now persist after death and reset (can be removed with Visualizer, normally)
	- If you notice instances of the visuals yeeting, please let us know so we can fix it!

### Fixed
- Old Kohl has transitions to it again
- baseitems.2da appearance range for amulets expanded to 250 to allow more visible options
- Lost Animals (invasion patrol items) are unlimited/day now
- Moonpier Frostblessed Maul has properties now
- Several accidentally hidden heads for male halfling (qty 17) and male half-orc (qty 4)

## [4.6.1 - 2024-12-01]

### Added
- Rest Menu option to toggle on/off usable for job system PLCs
- Added in persist PLC restrictions based on faction specific keys

### Changed
- Old Kohl now has more walls and the temple in construction
- Gregory's Landing stables cat Patches skin changed to tabby (non-triangle head) as per Ama's wishes.
- rua_bergrin, rua_wiltun_convs and wil_pjotr_guide convos no longer refer to a long-dead Jarl Arsant Wiltun V
- wil_pjotr_guide Card changed to Cary to reflect plot changes
- Renamed cart driver in the Dale (Frontier's to Traveller's)
- Lost Kid has a scale variable now
- Magically Supressed Spider Eggs (Job System item) has a correct bio now

### Fixed
- Removed redundant gate transitions from Shadowscape's gates, ensured existing transitions outside gates are linked properly.
- Caraigh Coast Road buildings now have doors.

## [4.6.0 - 2024-11-25]

### Added
- 3 new character portraits
- 1% chance to find a lost animal on patrol (36 animals added as bottled companions)
- New Quest NPC Faction so NPCs aren't attacked in hostile zones
- 6 new animal portraits
	- 1533 crab_
	- 1534 scorp_
	- 1535 toad_
	- 1536 bobcat_
	- 1537 hawk_
	- 1538 moose_ 
- Robe 232 to other phenotypes
- Moonpier Invasion
- Moonpier Outpost Invasion
- Baphitaur DTS, new amulet Archmages Secret, new boss Baphitaur Archmage, new area Baphitaur Hidden Depths
- Complete Job PLC Spawner QOL Update: Modify x, y, z, rotation, size, and usuablity now on all PLC. 
- Establish a Job System PLC as permanent aka persists between resets. Job Spawner Widget is sacrified in exchange.
- 2 new NPCs in Destrier Stables
- Path blockers to Destrier Stable back room; minor PLC tweaks
- Bio to Zachary Addams
- Coffee item to palette
- Stacks of 10 items for shops: Flame Weapon scrolls, Ironguts/Rogue's Cunning Potions
- Crossbow merchant in Frozenfar: Endir's Point, Shops
- 1 shop to Underdark: Bloodspear Keep, Interiors

### Changed
- Transitions from oldkohl to grngard, feylake, radiant
- Patrols reduce invasion percent by 4 instead of 5. 
- Increase Invasion percent per reset check, there are two a reset, to 6 from 5.
- Blackmoor Keep interiors no longer no-rest areas
- Blackmoor plot spawn triggers removed from Caraigh
- Crystal Node map note from Amia Forest: Northwest
- Ruathym: Caraigh, Dark Hills boulders; taken by Grove as material for Ubtao shrine
- Cleaned up DM Archive: Khylaria (removed old request items, PLCs, horses, changed 2 NPCs from hostile to defender faction)
- Gregory's Landing: Destrier Stables finished, pending final check/approval
- "No Porting" variable removed from Gregory's Landing & Destrier Stables
- Gregory's Landing racial gates now match Fort Cystana's
- First Knight Card of Wiltun moved from Wiltun Keep to Gregory's Landing Destrier Stables
- First Knight Card's bio for grammar/syntax/etc
- "Card" quest NPC renamed "Cary", given new bio to reflect relationship to First Knight Card
- Updated the W&S Guide NPC dialogue to reflect recent IC changes
- Added 10-stack Flame Weapon scrolls to many shops that had singles
- Darkness epic boss has a different skin now
- Gave each of the following settlements a 25,000 gp sell merchant:
	- Barak Runedar: Grundi
	- Setersborg: Ulfar Scarfoot
	- Howness: Olaf Feilan
	- Osthavn: Blacksmith
	- Fort Wiltun: Magister Yeagan
	- Ceyren's Mill: Uralia
	- Calderis: Havoc
	- The Dale: Muck Magus
	- Eilistraeen Shrine: Thrar
	- Endir's Point: Thorgrun
	- Nes'ek: Jaya Undt
	- Oakmist Vale: Naerth
	- Ridgewood: Figan Holdord
	- Salandran Temple: Temple Quartermaster
	- Shadowscape: Karisa
	- Southport: Jewelry Merchant
	- The Triumvir: Wilson Yadgerson
	- Winya Ravana: Thraldurin Chedrille
	- Zanshibon: Haji

### Fixed
- Mizfit Tailor's plcs
- Southport quest reward
- Southport quest keys
- Faction doors
- Reposition some JS nodes in Southport's warehouse
- Soldier patrol not getting proper reward bonus if it was set to secondary
- Racial trigger in Ruathym: Caraigh, Cloudfen Grove
- Various js PLC adjustments (Cystana South, Grumdek Murr EIP, Caraigh, L'Obsul, Forrstakkr, Amia Forest)
- Rats drop ears for rat ear peddlers again
- DTS adjustment, UD - Illuminated Caverns areas
- Re-add js_farmland trigger to Eilistraeen Shrine
- Howness, Temple of Helm metal plates under Bahamut now identified by default
- Typos and clarity in rau_seer convo
- Restore car_hound triggers for Father Darian's quest
- 55 Hunter creatures (portraits, voicesets, bios, skins)
- Positive Energy Plane exit portal, for real this time
- Rebilith typo (world boss)
- 15 broken animal portraits
- DTS waypoints in all "Unknown" areas now spawn characters facing away from the doors
- Edited some DTS area names for typos or consistency
- Manor of Mourn DTS fix
- Various misplaced PLCs (fire giant mines, Ceyren's Mill, Caraigh - Cloudfen Grove & Plateau)
- Floating/misplaced/missing doors in Gregory's Landing
- Quick-fix to typo, missing ds_speak line on new NPC, putting start point back in the entry
- Missing ds_speak line on Zachary Addams
- Some color tags on items in the Palette
- Removed some Plot flags for quest items that don't need them
- Removed some duplicate items from the item palette
- Patrol xp for soldiers correctly multiplies now
- Some palette creature categories
- Baphitaur name typo

## [4.5.2 - 2024-11-10]

### Added
- Travel flag for Southport to Travel Agency
- Mizfit shop/residence
- Mizfit key
- 2 starter quests in the Wave and Traveller's Rest

### Changed
- Removal of webs and rubble that are blocking challenges in burningcrypt
- Animals that spawned neutral won't anymore unless an area has a check to allow it (currently only Amia Forest)
- Removed a couple Farmer nodes in Djedet and added one Papyrus (there were way too many Farmer nodes in one area)
- Removed NoPorting area variables in Gauntlet of Terror and Abyss Forgotten Temple
- Mishnaeglen's quest in the W&S is now a proper EE quest

### Fixed
- Southport quest fixes
- Misc Southport scoundrel resource fixes
- Removed a debug message from job system harvesting
- DTS tweaks in Crypt of the Burning Dead
- Removal of dev crit from Bezerker of Baghtru
- Frost Giant King spawn trigger isn't halfway up a wall now
- Silverbark tree in Sandy Beach Cliffs reachable now
- Removed duplicate items from a potion shop
- Removed some rubble that blocked a DTS challenge in Darkhold
- Gauntlet store will buy ammo/projectiles now

## [4.5.1 - 2024-11-09]

### Added
- Wiltun Invasion Added
- Brog Invasion Added
- Two Obsidian Invasions Added 
- Silent Bay Shrine Invasion Added
- 6 PLCs to the PLC palette

### Changed
- Old Kohl Construction 1.2, Water wheels and Memorial Wall
- Removed class restrictions on some old shops that don't need them
- Thud in Bloodspear updated to be accurate
- Removed Grundi's metagaming
- Ancient Barrier Devices will have different VFX for the different types
- Putting a Supply Crate down in an area where invasions don't happen will create a new item to pick up, rather than wasting it

### Fixed
- Fixed door, transition and chair in TBQS
- Fixed Invasion Bosses by removing Trophy in inventory
- Fixed, Added in missing Fang Golem blueprint
- Southport quest fixes
- Fixed Invasion messages
- Fixed Obsidian Isle Calderis North map pin
- Boat routes between Wiltun/Moonpier Re-added
- Updated Wharftown references in Moonpier conversation
- Bugs in Bloodspear quests
- Ancient Barrier Device (Negative Energy) typo fix
- Job Journal tag check bug in invasion patrols

## [4.5.0 - 2024-11-02]

### Added
- DTS to Manor of Mourn
- TBQS 2nd floor
- Deity interaction with Hoar statue, Greengarden
- Invasions Added (Check the forums link for a full break down)
- New Recipes Added: Fang Golem, Supply Crates
- Patrol Feature Added
- 2 wing models (black angel/unarmored angel)

### Changed
- kohl_city replaced with kohl_city2
- transitions updated
- Moved Owlbear spawn location
- Mythal fuser will now also split mythals

### Fixed
- Gobbo escape hatch
- Redirected a transition to its proper place in UD 
- dragon cloth of both chaos and tyranny are actually made of cloth now
- Fix to a broken Southport quest
- Head Changer in character maintenance will let you choose elf female 60 to 70 now

## [4.4.3 - 2024-10-12]

### Added
- Bloodspear Arena (no entrance to it yet)
- Gobbo archers Deployed
- Escape hatch for Gobbo archers
- dm_bagoffelt2
- Spawner has a mini boss feature now for Dev use
- Spawns have variable sizes now when spawned on the map
- Unique Add ons to Spawns are present now. They are bigger, stronger versions of normal mobs that can spawn. They have a 50% chance to drop loot.
- Added in Global Boss resource drop
- Added in Recipes for Global Bosses.
	- Jeweler
		- Ring of Fortification (+5 Universal Saves) - Mythical Sample + Platinum Ring
		- Amulet of Spell Protection (+5 AC, 32 SR, +1 Universal Saves) - Mythical Sample + Platinum Amulet

	- Tailor
		- Cloak of Spell Protection (+5 AC, 32 SR, +2 Universal Saves) - Mythical Sample + Rothewool 
		- Boots of Freedom (+5 AC, Freedom, +1 Universal Saves) - Mythical Sample + Silk Boots 
		- Dragon Scale Belt (+3 Universal Save, +3 Regeneration) - Mythical Sample + Leather Belt

	- Smith
		- Helmet of the Clear Mind (+6 Will Save, +3 Regen) - Mythical Sample + Mithral Helmet

	- Artificer
		- Citrine Ioun (Poison Immunity, Disease Immunity) - Mythical Sample + Elemental Essence Water 
		- Moonstone Ioun (Freedom) - Mythical Sample + Elemental Essence Air 
		- Bloodstone Ioun (Evasion) - Mythical Sample + Elemental Essence Fire 
		- Obsidian Ioun (32 SR) - Mythical Sample + Elemental Essence Earth

		- Ancient Barrier Device
			- Acid (+1 Dodge AC, +10% Acid Immunity) - Mythical Sample + Emerald
			- Cold (+1 Dodge AC, +10% Cold Immunity) - Mythical Sample + Diamond
			- Electrical (+1 Dodge AC, +10% Electric Immunity) - Mythical Sample + Sapphire
			- Fire (+1 Dodge AC, +10% Fire Immunity) - Mythical Sample + Ruby
			- Negative (+1 Dodge AC, +10% Negative Energy Immunity) - Mythical Sample + Crystal

### Changed
- Request, Old Request, Summon Widgets set to dropable
- Made bags, Misc Medium (and 2), Misc Large, and Trap Kits take up fewer inventory spaces.

### Fixed
- Prancing Stallion
- Portal from Positive Plane
- tiny map shows for TBQS now
- Bugs in Oakmist Vale

## [4.4.2 - 2024-10-05]

### Added
- 1 player portrait
- 1 creature portrait: gorilla
- Added an Emberwood interior
- New Jergalite Dungeon and Quest in Obsidian Isle: Calderis, North



### Changed
- Finished stocking Hangman's Cove Warehouse
- Rest menu emotes will now let you sit as if in a chair wherever you're standing
- DTS added to:
	- Whispering Rift
	- Skull Peaks: Summit
- Plot updates to:
	- Amia Forest
	- Amia Forest: Oakmist Vale
	- Amia Forest: Oakmist Vale, Community Hut
	- Amia Forest: Oakmist Vale, Treetop Village
	- Amia Forest: Oakmist Vale, Caves
	- Chult: Ruins
	- Ruathym: Caraigh, Mushroom Cave
	- Khem: Temple of the Eight Gods
	- Obsidian Isle: Emberwood, East - Wysteria Galere
	- Obsidian Isle: Emberwood, East - Wysteria Galere Sanctum
	- Final construction in Obsidian Isle: Calderis, North completed


### Fixed
- Bugs in Amia Forest: Treetop Village and Huts
- DTS party bonus wont count user now
- Animate Undead and Create Undead Scaling fix 2.0
- Adjusted loot dropping scripts to avoid bug where you dont get any loot

## [4.4.1 - 2024-09-15]

### Added
- Hangman's Cove Warehouse and key
- Demonreach: Hangman's Cove Portal area
- Ambassador Rocksport to Barak Runedar: Citadel
- Club, Scimitar, Spear, Trident, Two-Bladed Sword to be affected by Weapon Finesse (all Medium-size)
- 1 player portrait

### Changed
- Guard in Wiltun Keep now is First Knight
- Lighting in the Shrine of the Dawn complete in Greengarden
- Shrine of Repose in Greengarden: Feylake West complete
- Construction phase to Greengarden: Old City Grounds
- Outside of the Shrine of the Dawn in Greengarden Feylake
- Hidden door ways now have bios to give you hints to what they require before clicking it
- Nearby party members will recieve XP for completing DTS challanges.
- Reduced gold income by half
- Scaling "help" with DTS skill check DCs based on nearby PC party members: Each nearby PC party member will reduce the DC by 2
- Moved furniture between two areas
- Double XP time is over!
- Removed an OI NPC for plot reasons
- Moved Obsidian Throne
- Renamed OI Areas (Wysteria Galere, Calderis North)
- Obsidian Isle portal

### Fixed
- Entrance to racial area in Barak Runedar
- Descripton of Motarch in Shrine of Repose
- DTS Animal/NPC factions
- Cryptic Door lock bug
- Flame Ray and Inflict Wounds Rays will do the right damage now
- Factions/scripts on NPCs in The Preserve
- DTS Pickpocket adjusted +50 to account for Amia's negative adjustment
- Fixed Create Undead scaling

## [4.4.0 - 2024-08-31]

### Added
- Some monster abilities to item property Cast Spell (Hurl Rocks, 7 Bolts, 5 Gazes, 7 Howls, 7 Pulses, 3 Rays)
- 4 creature skins: Otter, Wolverine, Spotted Skunk, Hognosed Skunk
- 16 creature portrait: Skunk, Akita, Bull, Cape Ox, Zombie Dog, Fey Wolf, Fox, Goat, German Shepherd, Male Lion, Monkey, Piglet, Sow, Rabbit, Squirrel, Tortoise
- Item puzzle script
- Maze items to the palette
- PLC areas to look at plcs (need port in)
- 5 Player portraits (2 for Summons)
- 3 Festival games for events
- 1 Festival game voucher
- Southport Redux: New quests, areas, dungeons; major rework of existing areas
- Heist/house guards with new scripts
- New "Guard System" & "Guard System - Ally" reputations
- Wildshape Widget to palette
- Frozenfar: Barren Hills, The Preserve
- Associate Customizer for test launch:
	A new tool that allows complete customization of any associate except dominated, this includes: summons, familiars, animal companions, henchmen. This tool is an improved version of summon reskins, but will not automatically replace any pre-existing reskins. If you have designs you would like to try out on the test server, please let us know, as the process will help us test it!

### Changed
- Shrine of Hoar in Greengarden, Shrine of Kelemvor in Feylake West
- Construction for 2 Shrines in Greengarden
- TBQS sign from under construction to open for business
- Updates to various other settlements to support Southport quests/travels
- Boss triggers now support quest-based spawning
- ds_shops conversation has been made modular and customizable
- Wiltun signage has been updated
- Ostland: Havskar construction complete
- Ostland: Havskar Caves is now The Malachite Maze
- Locking functionality to oc_loot_chest
- Sal'dock update in Ebon Wyrm Guild
- Frozenfar: Barren Hills, The High Gates - Added transition to The Preserve
- Plot update to Ridgewood

### Fixed
- All updates for TBQS in
- Garick in Moonpier is no longer hostile and his shop works
- Accidental lake house in the forest
- Bane no longer chilling in Winya
- Daytime area music in Chult Savannah Outskirts
- Wild Animal faction settings so they don't attack random NPCs
- 33 animal skin skinmeshes so they run right, etc.

## [4.3.4 - 2024-08-6]

### Added
- Hangman's Cove Warehouse interior
- 2 Player portraits
- TBQS: Items to the store
- Obsidian Isle: East Plains, Chapel of Jergal
- Fortress Wiltun: Recall Chamber
- Fortress Wiltun settlement insignia
- Job System tree nodes to Oakmist Vale Treetops
- Settlement Guards: Undead template
- Job System recipes for Jeweler:
	- Blue Light Gem: Raw Sapphire + Water Essence
	- Green Light Gem: Raw Emerald + Earth Essence
	- Orange Light Gem: Raw Crystal + Fire Essence
	- Purple Light Gem: Raw Ruby + Water Essence
	- Red Light Gem: Raw Ruby + Fire Essence
	- White Light Gem: Raw Diamond + Air Essence
	- Yellow Light Gem: Raw Crystal + Earth Essence

### Changed
- Unlocked the front door to TBQS
- Hangman's Cove exterior reflecting construction
- Changed portal color in Wiltun: Keep and Caraigh: Northend
- Moved Garick from Wave & Serpent to Moonpier
- Moved the Obsidian Throne to the Dragon's Eye Lighthouse
- Plot updates to OI: Emberwood East/Caves
- Plot update to Fort Cystana Everguard NPCs
- Changed sea travel script/dialogue to add Winya, Oakmist Vale, and Kampo's
- Barak Runedar Citadel now has Queen Samtara
- Settlement guard area adjustments (the henchies for the leader PCs)
- Plot updates to:
	- Moonpier
	- Silent Bay
	- Silent Bay: The Shrine of Eilistraee
	- Amia Forest: Oakmist Vale
	- Amia Forest: Oakmist Vale, Caves
	- Winya Ravana: The Falls
	- Inland Hills
	- 15 Fort Cystana areas (No-Porting removal)

### Fixed
- Blockers in Beastmen Caves
- Thoth Moon domain changed to Luck
- Tamara now supports NN alignment

### Removed
 - Construction sign in front of TBQS
## [4.3.3 - 2024-07-27]

### Added
- Construction to Havskar
- Construction to Hangman's Cove
- 1 player portrait
- Defender 2.0 Changes
- HIPs cool down adjustment via rules2da
- Massive crit option to gloves for unarmed combat

### Changed
- 3 Greengarden shrines
- Demonreach, Hangman's Cove to new tileset
- Moonpier Outpost in Malarfang reverted to restore earlier changes
- Player Housing updated for 1 character
- Item and creature palette updates
- Panther model with wandering jaw changed to a new model
- Blue Lagoon Interior: Arsene's chair fixed, and Arsene added
- Fort Cystana: Add Dragonook spot for dragon shrines

### Fixed
- Remove random scroll in Winya Ravana
- Greengarden, duke's estate, locked door

## [4.3.2 - 2024-07-10]

### Added
- Wall coverings and art to TBQS
- A feytouched cook
- Key for TBQS' office
- Frostspear delay for loot drops so it should hopefully fix Frosty not always dropping at least 1 epic resource
- New drop rates for Lich
	- Divine Mythal: 10% + party count
	- Lich Resource: 20% + party count
	- Epic Resources:  3 Epic Drops base, and every 3 past 5 people gets an extra drop. So 8 gets 4 Epic Resources, 11 get 5 Epic Resources.
- Quick bar loader in player tools

- Questline to Triumvir Mage Hall, and OI Mage Tower that will give a one time use Time Stop Scroll for memorization purposes. 

### Changed
- Updates to some settlement Guards
- Updates to construction in Feylake, Feylake West, Greengarden
- The Bitch Queen's Sway renovations
- Item palette categories for some Items
- Deleted some items off the palette
- Beautified Winya Ravana

### Fixed
- TBQS office access (I hope)
- TBQS chef station
- TBQS Bouncer's clothing
- Faction door in Duke's Estate, Greengarden
- Storage bug (Vetzer)

## [4.3.1 - 2024-06-29]

### Added
- Wild animal AI (it vanished at some point)
- Construction in Feylake, Feylake West, Greengarden
- acolytes to Greengarden for shrines
- settlement guards:kohlingen, barak, bloodspear
- construction of shrines in greengarden
- 1 player portrait
- Tressym portrait
- Crouching Lemur categories for Item and Creature palettes
- Ridgewood Guard Tweak
- Global Bosses fire an announcement once killed

### Changed
- Belenoth mage in Settlement Guard area
- Connected Chult Savannah to other Chult areas so they're accessible without a DM
- Put back original TBQS
- f_voice command will now work on Henchmen, too: Use h subcommand. Will target 1st Henchman, or 2nd Henchman if your 1st is a Vassal
- Gave black and tabby cat models wing compatibility (Tressym!)
- Replace white cat model with updated pretty one (with wing compatibility, too)
- Aurilite Warriors (Barak Runedar):
	- Removed massive crits
	- Made vulnerable to fire
	- Reduced fortitude
	- Reduced HP
- Aurilite Mages (Barak Runedar):
	- Removed blindness/deafness
- Aurilite Ice Elementals (Barak Runedar):
	- Shifted bulk of damage to cold damage (was physical)
- Adjusted Crouching Lemur guards on the Palette
- Removed and edited some Crouching Lemur guard equipment
- Area Changes:
	- Skull Peaks: Crouching Lemur Monastery
	- Skull Peaks: Place of Meeting
	- Skull Peaks: Lower Mountains
	- Greengarden, The Radiant Garden
	- Gregory's Landing
	- Calderis: Ebon Wyrm Guild
	- Silent Bay
	- Crystal River: Bridge
	- Ruathym: Ostland, Ostdur Manor
	- Blue Lagoon: Interior
	- Settlement Guards (OOC area)
	- Some DM areas
- Palette categories for Crouching Lemur items/guards
- Most normal animal spawns will spawn neutral - separate faction

### Fixed

- Bug with merchant boxes that caused a server crash
- Client crash associated with Calderis portal room
- Missing 'Leaves Lootable Corpse' option on 3 Global bosses
- Removed a spawn resref from the goblin area variables that pointed to a nonexistent creature
- Typos in:
	- A lot of map notes
	- The Dale
	- Amia Frontier
	- Malarfang Forest
	- Purple Worm Tunnels
	- Some palette creature bios

## [4.3.0 - 2024-06-15]

### Added
- Other phenotypes for 3 robe models
- Sounds to Traveller's Rest Portal Building
- 16 creature models
- 1 handheld mirror model (4 colors, Club)
- 1 player portrait
- Epic Merchant on Palette

### Changed
- Area Changes:
	- Greengarden: The Old City
	- Malarfang: Ruins (Also renamed to Malarfang: Moonpier Outpost)
	- Moonpier
	- Ruathym: Fortress Wiltun
	- Traveller's Rest: The Wave and Serpent
	- Positive Energy Plane: Unstable Rifts
	- Skull Peaks: Trummels
	- Traveller's Rest: Portal building
	- Plane of Shadow: Shadowscape
	- Skull Peaks: Trummels
	- Barak Runedar: The Frozen Wastes, The Northern Cape
	- Blue Lagoon
	- Ruathym: Ostland, Ostdur
	- Removed OI Event Stuff
	- Updated OI Guard Armor, various areas
	- Removed Belenoth/OI Portal
	- OI Eastern Plains Progress
	- Shadowscape Portal Room
	- Shadowscape borders expansion to allow circumventing the city
	- Shadowscape/OI portals
- Updated Blue Lute Pirate Conversation
- Double XP is permanent for the time being. Happy Summer!

### Fixed
- Module information and palettes
- Removed floating rock in Trummels
- Fixed naked folk in the OI Guild

## [4.2.0 - 2024-05-20]

### Added
- Guards to Settlement Guard area
- Epic Loot Merchant Conversation (weapons outstanding)
- Traveler's Rest Portal Building Interior

### Changed
- Replaced Crouching Lemur Guards with new Settlement Guards
- Replaced Wiltun Guards with the new Settlement Guards
- Lowered DTS percentages for Khem Sand Minotaurs
- Obsidian Isle: Calderis, Ebon Wyrm Guild:
	- Add Sal'dock
	- Change Xarzith's location and dialogue
	- Music tweaks
	- Tweak to Xarzith's description (denoting he's the guildmaster)
	- Added Enhanced recall NPCs
- Obsidian Isle: Eastern Plains progression, Mining trainer
- Obsidian Isle: Kobold Warren: Mining trainer
- Obsidian Isle: Great Hall/Port; event decoration
- Adjusted locations of some of the global bosses
- Updated the Ridgewood government building for plot purposes
- Made the Triumvir music less spooky
- Updated Gauntlet of Terror and Frozen Barrows
	- New PLCs inside Gauntlet
 	- New Job system triggers
 	- New spawn point of creature (Maximus)
  	- Update Maximus
  	- Removed old spawn point and VFX  
- Duergar are now allowed in Bloodspear Keep
- Fixed Arcane Defiance Armor crafting receipts to properly use mythal
- Peerage summons fixed, evasion feat added
- Magical Hemp/Rope, Small Ore, Medium Ore, and Large Ore are now all one. It is now dropped as Magical Ore. These can be used to
make any Warforged, Truestrike, and Surestrike weapon. You can also now use Small/Medium/Large Ore + Hemp/Rope to make any of the weapons.
- Purple Worm will now drop a Magical Ore always, and a random epic resource
- Epic Loot Bin has been reduced by 3 with the reworking of the ore/hemp drops. Meaning more of the resources should be appearing and 
less magical ore bloat. 

### Fixed
- Primary Farmers, Ranchers, and Trappers should now correctly be able to spawn 2 job nodes
- Floating PLCs in player housing
- Fixed a quest item in the Skull Peaks beetle cave
- Tweaked the generic give_item script
- Fixed OI Book Merchant's name/description/dialogue to remove mentions of being stranded
- Loading Screens (hopefully)

## [4.1.0 - 2024-04-15]

### Added
- OI: Portal Chamber
- OI: Ebon Wyrm Guildhall
- OI: Homes
- Ebon Wyrm Guild guards and equipment
- Global (Elyon) Bosses Deployed
- New Global Loot Made (15 Total)
- New jungle tileset
- 6 HD skyboxes
- Dice roller in player tools NUI window

### Changed
- Obsidian Isle: Calderis, Great Hall reshuffle:
	- Portal chamber moved to its own building outside the gates
	- Ebon Wyrm Guildhall created near the southeastern gate of Calderis
	- Library of the Vaunted portal moved to Calderis Mage Tower
	- Shrine of Velsharoon moved to Calderis Mage Tower
	- Existing great hall is largely empty and locked to the public
- Guards have been stationed inside OI: Dragon's Eye Lighthouse
- OI: Eastern Plains Construction beginning
- Moved the stranded book merchant to OI: Mage Tower; his body guards are off duty
- Updates to Gregory's Landing: Prancing Stallion

### Fixed
- Artificer epic item recipes not working
- OI: Calderis should now have working rental homes
- Stinkpot Warrens granite node fixed
- Amia Frontier: East silverbark node fixed
- Typos in Burning Crypt Unknown area
- Some Ancient Chest DTS cooldowns and loot generation settings

## [4.0.03 - 2024-04-8]

### Added
- DTS to UD Glouras, Southport Sewers
- Override2 hak to module
- New Area:
	- Underdark: Bloodspear Keep Portal Chamber
- Added in more Scoundrel doors to Southport East/West/Central and Traveller's Rest
- Added on hit lycan to global bosses, and fluff names

### Changed
- Alchemist Elemental Resistance Potions durations extended to 10 minutes from 1 minute
- Lowered percentages for DTS objects in Hollow Cavern, lowered the overall Level
- Custom Summon widget now stores 3 summons the PC can toggle through
- Remove force-walk effect from Piercing Shot
- Area Changes:
	- Underdark: Bloodspear Keep
	- Underdark: Bloodspear Keep Interiors

### Fixed
- Blackuard Aura of Despair has no VFX (for the caster or the affected target)
- Fixed a Resref mismatch for Mystical Woven Material in Epic Crafting Recipes
- Infinite loop bug in henchman scripts

## [4.0.02 - 2024-03-30]

### Added
- DTS to Sernheim Crypts

### Fixed
- Henchmen not unsummoning on player death
- DTS blockers not despawning.
- OI levers not working right.
- Purple Worm bug tweaks.

## [4.0.01 - 2024-03-24]

### Added
- New script for DTS blockers that destroys them all in one interaction
- Added DTS system to Mylocks
- New Mylocks Inner Sanctum area
- New Mylocks and Mynocks quest in Mylock Hills

### Changed
- Howness: Changed Morgan & Sons to Vetzer Storage
- Mylock Hills, Ruins, and Living Quarters have all been adjusted to create new dungeon flow and add DTS elements
- Minor tweaks to Dragon's Junction
- Mylocks have had their CR increased to better reflect their difficulty
- Increased Dungeon Door XP from DC x 2 to DC x 5 to better match DTS
- Adjusted the tiers for Brewer job system drinks
- Added PM henchmen to exception for custom summon despawning

### Fixed
- An issue with DTS NPCs being locked in male pronouns
- DTS item/bosses categorization
- Changed epic items are actually changed now
- Fixed a few PLC descriptions
- Replaced the bank doors in OI Bank
- Typos in job system recipe script (platnium > platinum)
- Typo in Merchant Storage Chests Convos
- Custom Summon AI corrected
- Vassal Heartbeat script corrected
- Removed another defunct NPC

## [4.0.0 - 2024-03-16]

### Added
- Moved an NPC from EP to Belenoth.
- DTS added to:
	- Marrowmaw Pass, Khem Minotaurs, Burning Crypt, Hollow Cavern
- Custom creature palette file to top hak.
- Custom item palette file to top hak.
- Some missing 10-stack potions.
- A couple new items to Moonpier tanner shop (trimmed a lot of items out of it, too).
- Added new epic loot items for epic crafting system:
	- Bracers of the Elemental Golem: 10/- Acid Resist, 10/- Fire Resist, 10/- Cold Resist, 10/- Electric Resist, +2 CON
	- Dragon Armors of Chaos (+5 AC, 15/- Acid Resist, 15/- Electric Resist, +1 Regen): Half-Plate, Splint Mail, Breastplate, Chain, Hide, Leather, Padded, Cloth
	- Dragon Armors of Tyranny (+5 AC, 15/- Fire Resist, 15/- Cold Resist, +1 Regen): Half-Plate, Splint Mail, Breastplate, Chain, Hide, Leather, Padded, Cloth
	- Arcane Defiance Armors (+5 AC, 32 SR, +2 Saves): Half-Plate, Splint Mail, Breastplate, Hide, Padded
	- Furtive Armors (+5 AC, +2 DEX, +5 Hide, +5 Move Silently): Hide, Leather, Padded, Cloth
	- Gloves of the Honeyed Tongue: +30 Persuade
	- Gloves of the Serpent's Tongue: +30 Bluff
	- Gloves of the Challenger: +30 Taunt
	- Gloves of the Equestrian: +30 Ride
	- Gloves of Conspicuous Threats: +30 Intimidate
	- Gloves of Silent Whispers: +3 DEX, +15 Hide, +15 Move Silently
	- Gloves of Keen Senses: +15 Spot, +15 Listen, +15 Search
	- Earblasters (Darts): +5 Enhancement, 1d8 Sonic, OnHit Deafness DC 20, Vamp Regen +2
	- Frozen Cutters (Shuirkens): +5 Enhancement, 1d8 Slashing, 1d4 Cold, OnHit: Slow DC 20
	- Thunderstrikers (Throwing Axes): +5 Enhancement, 1d8 Piercing, 1d4 Electric, +2 Vampiric Regen
	- Mindreaver (Battleaxe): +5 Enhancement, Keen, 1d8 Piercing, OnHit: Confusion
	- Soulbasher (Club): +5 Enhancement, Keen, 1d4 Magic, 1d4 Piercing, 1d8 Massive Crit
	- Stormweaver Axe (Handaxe): +5 Enhancement, Keen, 1d3 Electric, 1d3 Magic, OnHit: Doom DC 20
	- Etherblade (Katana): +5 Enhancement, Keen, 1d8 Negative, 1d4 Bludgeoning, OnHit: Stun DC 20
	- Vortex Stinger (Kukri): +5 Enhancement, 1d10 Cold, Keen, 1d6 Massive Crit
	- Skelly Smasher (Light Flail): +5 Enhancement, +6 Enhancement vs Undead, 1d10 Positive vs. Undead, 1d6 Slashing) - epx_weap_sklsm
	- Galecaller (Light Hammer): +5 Enhancement, Keen, 1d3 Acid, 1d3 Electric, 1d3 Cold, 1d3 Fire, +2 Vampiric Regen
	- Beauty's Redoubt (1H Magic Staff): +2 CHA, Bonus Spell Slot 9, 8, +5 Spellcraft
	- Sage's Redoubt (1H Magic Staff): +2 INT, Bonus Spell Slots 9, 8, +5 Spellcraft
	- Holy Redoubt (1H Magic Staff): +2 WIS, Bonus Spell Slots, 9, 8, +5 Spellcraft
	- Eldritch Redoubt (1H Magic Staff): +2 DEX, +1 CHA, +5 Concentration
	- Starfall (Morningstar): +5 Enhancement, Keen, 1d8 Slashing, OnHit: Silence DC 20
	- Astral Crescent (Sickle): +5 Enhancement, Keen, 1d4 Positive, 1d4 Acid, OnHit: Blind DC 20
	- Runic Pigsticker (Trident): +5 Enhancement, Keen, 1d8 Bludgeoning, +3 Vampiric Regen
	- Dreamweaver (+5 Enhancement, Keen, 1d4 Sonic, 1d4 Acid, 1d4 Electric, 1d8 Massive Crit
	- Essence Crossbow (Heavy Crossbow): +5 AB, +5 Mighty, 1d12 Massive Crits, 80$% of Weight, 1d6 Sneak Attack Blackguard
	- Hurricane (Light Crossbow): +5 AB, +5 Mighty, 1d12 Massive Crits, Extra Damage Type Slashing
	- Ebon Gale (Shortbow): +5 AB, +5 Mighty, Bonus Damage: Bludgeoning, 1d12 Massive Crit
	- Dalestriker (Sling): +5 AB, +5 Mighty, Bonus Damage: Slashing, 2d12 Massive Crit
	- Crystalwave Staff (Quarterstaff): +5 Enhancement, Keen, 2d6 Slashing, +2 Vampiric Regen, OnHit Freeze DC 30
	- Enigma Totem (Quarterstaff): +4 WIS, Bonus Spell Slots, 9, 9, 8, 8, +10 Spellcraft
	- Icespire (Spear): +5 Enhancement, Keen, 1d6 Cold, 1d6 Sonic, +3 Vampiric Regen, OnHit Stun DC 20
	- Shadowmark (Greataxe): +5 Enhancement, Keen, 2d6 Piercing, 1d6 Sneak Attack Blackguard, +3 Vampiric Regen
	- Typhoon Edge (Halberd): +5 Enhancement, Keen, 1d4 Acid, 1d4 Cold, 1d4 Fire, 1d4 Electric, OnHit: Confusion DC 20
	- Ghostfire (Heavy Flail): +5 Enhancement, +6 Enhancement vs Undead, 1d10 Positive vs. Undead, 1d6 Slashing, OnHit Doom DC 20
	- Starfrost (Scythe): +5 Enhancement, Keen, 2d6 Piercing, 1d6 Massive Crit, OnHit Freeze DC 30
	- Shadow Mirage (Dice Mace): +5 Enhancement, Keen, 2d6 Slashing, +3 Vampiric Regen, 1d6 Sneak Attack Blackguard
	- Double Eclipse (Double Axe): +5 Enhancement, Keen, 1d6 Bludgeoning, 1d6 Positive, Vampiric Regen +3, OnHit: Daze DC 20
	- Frostfall (Two-Bladed Sword): +5 Enhancement, Keen, 2d6 Cold, 1d6 Massive Crit, OnHit Freeze DC 30
	- A Musician's Mind (Ring): Spell Slots: Bard 5/5/6, +3 CHA
	- Shadow's Glance (Ring): Spell Slots: Blackguard 2/3/4, +3 WIS
	- Killer's Balance (Ring): Spell Slots: Assassin 2/3/4, +3 INT
	- Nature's Devotion (Ring): Spell Slots: Druid 8/8/9, +3 WIS
	- Band of Illumination (Ring): Spell Slots: Wizard 8/8/9, +3 INT
	- Mysterious Band Spell (Ring): Slots: Sorcerer 8/8/9, +3 CHA
	- Divine Touch (Ring): Spell Slots: Cleric 8/8/9, +3 WIS
	- Warlock's Empowerment (Ring): +3 CHA, +10 Concentration
	- Warlock's Focus (Ring): +3 DEX, +10 Concentration
	- Cape of the Panther (Cloak): +5 AC, +10 Hide, +10 Move Silently
	- Cape of the Owl (Cloak): +5 AC, +10 Spot, +10 Listen
- Epic Crafting Recipes added for all new/old Epic loot. 100+ Items.
- Throwing Axes, Darts, and Shurikens added to Job System crafting.
- New mini-ioun DTS reward to Elemental Earth Dungeon.
- Convos for Epic Crafting, to include all Stats before crafting

### Changed
- Promoted an Endir's Point NPC.
- Overhauled entire creature palette into new categories.
- Overhauled a lot of the item palette into new categories.
- Slight adjustment to positioning of module start point.
- Adjust Raid activation devices to tell proper lore behind them.
- Crouching Lemur area updates.
- Slight modification to Thorny Chief Boss, as he's a little overtuned currently.
- Scarab of Living changed to: +5 AC, +2 Regeneration, Poison Immunity, Disease Immunity.
- Bracers of the Gemstone Golem changed to: +5 Soak 5 Damage, 5/- Bludgeoning, 5/- Piercing, 5/- Slashing, +2 CON.
- Added additional functionality to us_sit - can do other animations.
- Test server merchant filled out with all kinds of stuff. Secondary merchant deleted (no longer necessary).
- Removed many items from existing Moonpier shop to make it a smaller Tanner/Tailor shop.
- Changed area and battle music in Raid areas.
- Area changes (including some new music):
	- Endir's Point
	- Endir's Point: Hospital
	- Endir's Point: School
	- Moonpier
	- Moonpier: The Lunar Lantern (tavern)
	- Moonpier: Seer's Caves (community center/housing)
	- Moonpier: Moonlight Tradehouse (shops)
	- Moonpier: Harbor Office (customs/jail)
	- Gregory's Landing (started tavern)
	- Khem: Temple of the Eight Gods (permanent Djinn merchants)
- Ioun Stones now use a more modular system to check if a previous ioun is out.
- Added additional colors to the module load for Djinn blue and DTS orange.

### Fixed
- Removed several creature .utc files from creature hak.
- Updated DM Rebuilder script to factor in newer DC/Emote wands during rebuilds.
- Moonweave Sanctum: angry librarian, misplaced smith station.
- Custom summon duration is correct now and only reports the whole seconds, not a bunch of decimals.
- Removed some areas that were gone or had wrong resrefs.
- Removed some missing resources and spawned creatures that aren't needed anymore.
- "Animal Type" Empathies will no longer try to dominate PCs.
- Bug with random head script where NPCs would be headless.
- Re-added CWI NPC to OI's Havoc's Smithy.
- Re-removed CWI NPC from Triumvir (shouldn't be there).
- DTS tweaks and fixes to Elemental Earth Dungeon
- Added new epic (epx_xxxxxxxxx) item tags to two of the ioun stones

## [3.3.0 - 2024-02-25]

### Added
- DTS added to Lizardmen in underdark, Cape Slakh, Underriver, Temple of Malar, and Brigands.
- 1 Player Housing area.
- Area for settlement guards to be found easily.
- 1 missing creature appearance (Gnomish Battle Suit).
- Hallow and Text triggers to palette.
- 8 custom summon creature templates to palette.
- 6 Settlement guard templates to the palette (Elite, Standard, Scout, Mage, Construct, Player Housing).
- Weapons and armor added for the settlement guards.
- New spells from the old dummy ones:
	- Blessed Exorcism (Conjuration), Cleric 6, Range: Personal, AoE: Large, Duration: Instantaneous, Save: Special, Spell Resistance: (See Description)
		- The cleric exorcises the influence of spirits opposed to their patron. All allies in the area of effect are freed from mind influencing maladies, fear, daze, domination, stun, or other mind effects. Any hostile undead or outsiders in the area of effect must make a will save or be turned for 1d6+1 rounds. 
	- Ball of Sound (Evocation), Bard 0, Cleric 0, Druid 0, Sorcerer/Wizard 0, Range: Medium, AoE: Single, Duration: Instantaneous, Save: None Spell Resistance: Yes
		- Does 1d3 cold damage per 2 caster levels to a single target creature.
	- Color of Spring (Transmutation), Druid 6, Range: Personal, AoE: Large, Duration: Instantaneous, Save: Special, Spell Resistance: (See Description)
		- This spell brings new beginnings to those around the caster. Centered around the caster, all natural living allies (as in not undead, constructs, outsiders, or aberrations) in a 20 foot radius will be subject to a restoration spell and be healed 1d8+caster level hit points. Any enemy undead in the radius will need to make a will save or be turned for 1d6 rounds. Any enemy aberrations in the radius will need to make a will save or be stunned for 1d6 rounds. Any enemy constructs in the radius will need to make a fortitude save or be knocked down for 1d6 rounds Any enemy outsiders in the radius will need to make a fortitude save or be dazed for 1d6 rounds. 
	- Druid Punch (Transmutation), Druid 8, Range: Touch, AoE: Single, Duration: Instantaneous, Save: Fortitude (See Description), Spell Resistance: Yes
		- The caster attempts a punch to utterly destroy the unnatural. The caster makes a melee touch attack. If the attack hits, the victim takes 1d8 points of divine damage per caster level. If the target is an undead, construct, outsider, or aberration, they must make a fortitude save or be slain instantly. Undead, constructs, outsiders, and aberrations take full damage even if they pass the save. If the target is any other creature type, they can make a fortitude save to halve the damage taken. 
	- Helma's Curse (Necromancy), Cleric 2, Range: Short, AoE: Single, Duration: 1 Round/level, Save: Will Negates, Spell Resistance: Yes
		- The cleric utters a curse upon enemies of their faith. The curse causes weariness and exhaustion, causing 2 points of strength drain, 2 points of constitution drain, and inflicts a 30% movement speed decrease for 1 round per caster level. This effect cannot be cured by a restoration, however a remove curse can remove the effect. 
	- Myrra's Hex (Enchantment), Druid 1, Range: Medium, Duration: 1 round, 1 round/level, Save: Will negates, Spell Resistance: Yes
		- This witch-hex will attempt to lay a curse of clumsiness upon the victim. The victim must make a will save. If the save is failed, the victim will be knocked down for 1 round, and be cursed with clumsiness, taking 1d6+1 points of dexterity damage for 1 round per caster level. The dexterity damage cannot be restored with a restoration, but a remove curse spell will remove it. 
	- Snorri's Snowball (Evocation), Wizard/Sorcerer 6, Bard 6, Range: Long, AoE: Single/Large, Duration: Instantaneous, Save: Reflex Half (See description), Spell Resistance: Yes
		- The caster casts a snowball at a target, and performs a ranged touch attack against a single target. If the touch attack hits, the target will take 1d6 cold damage per caster level, with no cap. The Snowball will then burst and every target in a 15 ft radius will take 1d6 cold damage per two caster levels, to a maximum of 15d6 damage at level 30. Each Spell Focus in evocation increases the burst damage by 1d6 cold damage, and epic spell focus will increase the burst damage by 3d6 cold damage. A reflex save will half the cold damage taken, evasion applies. Should the initial target be hit by the touch attack, they will not take the burst damage. However if the touch attack misses, they will be subject to the burst damage. 
	- Vinna's Greater Globe (Transmutation), Druid 4, Range: Long, AoE: Large, Duration: 1 round/2 caster levels/Instantaneous, Save: Reflex Negates, Fortitude Partial, Spell Resistance: Yes
		- This spell casts a globe of ravaging plants to assail their foes. Any enemies caught in the spell's radius must make a reflex save or be entangled. The victim's can make subsequent saves to escape the entanglement. However, any targets hit by the entanglement must make a fortitude save or be poisoned. The poison does 2d6 points of dexterity damage. If the target fails the reflex save but has freedom, while they won't be entangled, they will still be subject to the poison.
- Added 20 new variations of Gloves/Hoods/Boots/Belts to job system.
- Reworked the Elemental Boss Drops (The corpses will now stay, easier to spot, and will have the loot on them). There are 32 Tiny Elementals at the end of the fight. 15% drop chance for an epic each. 

### Changed
- Shrunk the Moonweave Sanctum area.
- Updated Moonpier (exterior) guards to settlement template guards.
- Electric Jolt expanded to Bard/Druid/Cleric/Soc/Wiz cantrips.
- Boots of the Broken Ones (+5 AC, +3 DEX) moved to epic loot selection. No longer sold in Abyss.
- Boots of Swift Steps (+4 AC, +3 DEX) added to Abyss/Gauntlet shops.
- Changed resrefs for Magical Ore/Hemp weapons in js_converter (will have no effect on existing weapons).
- Finalize Moonpier's Moonbeam Chapel and Moonweave Sanctum.
- Adjusted Frostspear Staffs once more.
- Warlock buffs:
	- Flee the Scene CL is uncapped and now applies Uncanny Dodge I for the duration.
	- Armored Caster arcane spell failure reduction applies to small shields now.
	- Summon AC progression increased to +6 from +5; soul larvae get +5 HP and +2 AC per tier.

### Fixed
- Edited a broken character file.
- Fixed a broken dwarf NPC in Wave & Serpent.
- Removed extra Wondrous Item crafting bench in Wave & Serpent - it's in the trades hall with other crafters.
- Re-added missing amia_weapons hak from module.ifo.
- Removed duplicate Magical Ore/Hemp weapons from palette.
- Fixed some categories on some weapons on the palette (OCD Style).
- Warlock bugfixes:
	- Fixed a server crash caused by a warlock logging in and out real quick.
	- Binding of Maggots summoning circle now removes itself properly.
	- Frog Drop targeting works now as a small AoE as intended.
	- Unsummon and summon visuals now play properly for multiple summons.
 	- Multiple summons now unsummon properly on new summons.
	- Summons' attack bonus now scales as intended.
- Fixed Job System Material Check Bug.
- Iolite effect now applies to all henchmen instead of just the first one.
- Peerage Vassal will no longer be able to be summoned with other summons or henchmen (except swarms).

## [3.2.0 - 2024-02-25]

### Added
- 4 player-use portraits
- Robe #145 mount phenotypes
- New script that allows modular item-based creature spawning
- Greengarden Guard House interior 
- Legendary Crafting System for Raids and future Epic Crafting
- Wondrous Item Crafting Tables/NPCs added to:
	- Traveller's Rest: Trades Hall
	- Calderis: Havoc's Smithy
	- Fort Cystana: Trade Hall
	- Bloodspear Keep: Interiors
- Crafting loops once again, so you can mass do job system stuff
- CMA is now used in Epic/Raid Crafting. Every 10 levels of base Craft Weapon and Craft Armor reduces the cost of CMAing epic unfinished products by 5k to a maximum of 25k.
- Fully random library book script
- GUI foundations added in backend

### Changed
- Amia Forest deer to spawn as Neutral
- OI Calderis Name Change
- OI Updates to Eastern Foothills
- New Quest: Earthen Rift
- Added functionality to us_jump_to_tag for quest requirements
- Added functionality to ee_generic_quest for quest requirements
- Fixed some job system bugs
- OI Port Construction update
- Changed the bio of one of the Drink: Water items, since there were two identical ones on the palette
- Made book items into adorable 1x1 icons
- Plot Updates:
	- Moonpier
	- Moonpier: Moonbeam Chapel
	- Moonpier: Moonweave Sanctum (New)
	- Facelift to Duke's Estate in Greengarden
	- Greengarden: Guard House
- Warlock's Frog Drop now has a small AoE for easier deployment.
- Tweaked the percentages for Underkingdom DTS

### Fixed
- Fixed Shadowflame Manor placeables
- Fixed Belenoth corridor crowding
- OI Bank Doors
- Gave the Underkingdom its music back
- Manacles will throw people out properly when they're in the same area now
- Fixed DTS triggers in Actand (Celestials/Demons)
- WARLOCK
	- Chain, Spear, and Blast no longer allow friendly targeting
	- Chain, Spear, Blast, and Pulse no longer crit targets that are crit immune.
	- Eldritch Blast (including all shapes) is no longer blocked by level 1 spell immune (still respects mantles and spell resistance).
	- You can no longer cast invocations in anti-magic zones.
	- Invocations properly ignore DMs now.
	- Energy resist feats work properly now.
	- Word of Changing no longer is removed when the temp HP is removed.
	- True seeing now properly blocks Writhing Darkness.
	- Frog Drop now properly spawns frog at the target location and subsequent frogs are spawned at the location of frog death.
	- Primordial Gust no longer crashes the game when cast on fixtures (whooooops!)
	- Primordial Gust properly varies damage calc for each target.
	- Loud Decay visual and sound effect fixed.
	- Loud Decay properly varies damage calc for each target.
	- Warlock summons' AI is fixed. (They attack instantly on summoning and don't run away anymore.)
	- Warlock summons now unsummon properly when the duration runs out.
	- Warlock summons' stats are fixed; tweaking of stats made a lot easier.
	- A visual cue for the Eldritch Mastery works now.
	- Fiendish Resilience renamed into Otherworldly Resilience.
	- Stale item property remover no longer incorrectly removes Armored Caster.

## [3.1.0 - 2024-02-21]

### Added
- New item spawner item
- New OnSpawn script for mobs that will spawn in neutral, can be attacked without breaking all factions
- New spell targeting area indicators added for all area spells
- 1 new player portrait

### Changed
- Improved Item Spawners on backend; can now set quantity; no longer uses database, so will not break with name/login changes (will not break existing items)
- Updated Faction/Settlement spawn area
- Removed some outdated items from the palette
- Added new items to the palette
- Added more functionality to PLC scaling
- Remove ruins from Skull Peaks Trummels
- Added cart from Moonpier to Gregory's Landing and back
- Changed spawns in Amia Forest to have new AI that spawns neutral
- Turned the following items into 1x1 Misc Small inventory items:
	- Job Journal
	- The Book of Transmutation
	- Magical Ammo Bag
	- Box of Hats
	- Box of Masks
	- Greater Tome of Mystra
- Area Plot Updates:
	- Moonpier
	- Moonpier: Moonbeam Chapel
	- Moonpier: Moonstone Caves
	- Ridgewood (NPC updates)
	- The Triumvir: Wandering Magisterium > Renamed to Mage School, remove Hallowing
- Add settlement variables to:
	- Nes'ek
	- Oakmist Vale
	- Quagmire Mercenary Camp
	- Quagmire Kobold Warren
	- Ridgewood
	- Salandran Temple
	- Shadowscape
	- Southport
	- Traveller's Rest
	- The Triumvir
	- Zanshibon

### Fixed
- Removed defunct Amia Music 2da entries
- Fixed missing EE music entries in 2da
- Unlimited cantrip function moved to C# so it'll stop breaking randomly every update
- Fixed and added feedback to animal companion/familiar collision bubble removal
- Updated outdated Portal Lamp conversation
- Traveller's Rest Festival Grounds will no longer randomly ambush you with undead when you rest

## [3.0.1 - 2024-02-18]

### Added
- 1 robe to mounted phenotypes

### Changed
- Remove collision bubble from animal companions and familiars

### Fixed
- Fixed the two BAD mundane PLC in the DTS system
- Fixed a bug in the Job System bonus harvest system
- Dynamic merchant bugfix
- TLK issues
- Polymorph fix for spell slots

## [3.0.0 - 2024-02-11]

### Added
- 11 character portraits
- Holdable playing cards added to items merchants
- OI Emberwood, East - Cave
- Added an egg to the palette
- Deployed DTS to Ruins of the Underkingdom (Fire Giants)
	- Fixes for some PLCs
- Added purple worm appearance and portrait
- Personal/Bank storage chests
- Storage database
- Purple Worm Raid Added
- Construct familiar option
- Construct creature/hide/weapon blueprints
- Primary/Secondary harvest bonus. They get a secondary roll to gain a second resource on successful roll, the chances are 75%/40% for primary/secondary.
- New faction for Job System NPCs
- Weapon Appearances:
	- 2 Scythes
	- 2 Spears
	- 1 Halberd
	- 2 Bastard Swords
	- 1 Greatsword

### Changed
- OI Boar/Bat Spawn & Token removal
- OI Emberwood, East: Added spawns
- Palette Updates
- Banks re-opened in:
	- Traveller's Rest
	- The Dale
	- Fort Wiltun
	- Endir's Point
	- L'Obsul
	- Barak Runedar
	- Kampo's Storehouse
- Bank functionality added to:
	- Fort Cystana: Trade Hall
	- Obsidian Isle: Bank
- Added Settlement variables to:
	- Barak Runedar
	- Setersborg
	- Howness
	- Thordstein
	- Thykkvi
	- Fort Cystana
	- Greengarden
	- Gregory's Landing
	- Whitestag Shore
	- Ostdur
	- Osthavn
	- Havskar
	- Fortress Wiltun
	- Ceyren's Mill
	- Belenoth
	- Bloodspear Keep
	- Blue Lagoon
	- Brokentooth Cave
	- Chillwyck
	- The Dale
	- Djedet
	- Eilistraeen Shrine
	- Endir's Point
	- Hangman's Cove
	- L'obsul
	- Moonpier (Fixed)
- Familiars and Animal Companions now have silent conversations
- Greater Restoration/Neutralize Poison will work on Purple Worm custom poison
- Job System Corpse Weight changed to 1 lb
- Cav with Mounted Archery can use Sling/Light Crossbow now 
- Removed Mounted Combat Pre-req for Mounted Archery
- Scholar Sites reduced from 5 minutes to 1 minute cool down
- Darkness rework. Now uses Anti Light VFX. It is now -1 AB, -1 AC, and -10% Movement speed. If you have ultravision or true seeing it ignores it. 
- Warlock Light's Calling/Loud Decay/Primordial Gust summons now summon without needing to target a hostile creature
- Added map notes in Bloodspear Keep areas

### Fixed
- Fix to Trolls Unknown area (Tileset bug)
- Fix Lentle's quest dialogue
- Fix Frustrated Guard quest NPC pointing to the wrong NPC to visit next
- Fix Lente's name (it wasn't supposed to be Lentle)
- Attempted to fix the Hunter Cave line of sight issue with boss


## [2.9.4 - 2024-01-027]

### Added
- Settlement guard manacles added
- OI: Emberwood East and Central (inaccessible for now)
- OI: Dragon's Eye Lighthouse
- OI: Dragon's Fang Cape, Bitch Queen's Sway
- New Dungeon & Enemies (Still WIP, inaccessible for now)
- DTS - Shekat
- Beeacon alliance guard spawner
- Added HD override to 10 base dragon appearances
- Added 17 Zodiac creature appearances
- Added Ettin, Evil Snowman, Treant 2 appearances
- Added 10 komodo dragon appearances
- Added Weasel, Rat, Spotted Cat appearances
- Added 4 Pegasus mounts (with wings)
- Added 1 zodiac mount
- Added "Enhanced" mage staff overrides
- Added more VFX (horns, quivers)
- Added parasols
- Added magic wand appearances
 
### Changed
- Moonpier resref update
- OI: Arena Updated
- OI: Abandoned Ruin > Research Outpost
- Primary settlement variables added:
	- Winya Ravana
	- Moonpier
- Added check to racial gates for individual banishments
- Guard spawner will work in allied territories
- ds_area_enter unsummons guards being used outside of settlement areas
- Added parasol items to the items vendor

### Fixed
- Moonpier pylon positioning adjusted so it can be clicked easier
- Swarm and Guard summoner widgets won't unsummon other henchmen anymore
- Bugfix for swarm summoning with multiple swarm widgets
- Bugfix for DTS and appraise skill being off
- Made Blinding Speed instant again
- Fixed new ring icons overriding old icons

## [2.9.3 - 2024-01-020]

### Added
- Beacon system for settlement attacks, including an item to engage it
- Swarm summoner: summons up to 15 level 1 creatures, can be fully customized with up to 3 creatures
- Added in a custom random NPC list for DTS for the underdark areas
- Added in the ability to ban NPCs or PLCs from spawning in DTS
- Added bios to all DTS NPC/PLC
- DTS to Frozenfar: Raider's Area in the Underdark
- Guard summoner for settlements - only functional in designated settlement areas
- Mage Guard settlement template NPC complete
- Added fully customizable DTS conversations with NPCs and Challenge PLCs
- Added DTS to Crag Beetles
- About 100 new PLCs
- New Staff appearance
- New Staff type for holdable playing cards
- New skins
	- 1954	Dragon_Amethyst
	- 1955	Dragon_Crystal
	- 1956	Dragon_Emerald
	- 1957	Dragon_Ruby
	- 1958	Dragon_Sapphire
	- 1959	Dragon_Topaz
	- 1960	Dragon_Obsidian
	- 1961	"Humanoid: Fey SH Pixie 1 Black"
	- 1962	"Humanoid: Fey SH Pixie 2 White"
	- 1963	"Humanoid: Fey SH Pixie 3 Red"
	- 1964	"Humanoid: Fey SH Pixie 4 Blue"
	- 1965	"Humanoid: Fey SH Pixie 5 Yellow"
	- 1966	"Humanoid: Fey SH Pixie 6 Orange"
	- 1967	"Humanoid: Fey SH Pixie 7 Purple"
	- 1968	"Humanoid: Fey SH Pixie 8 Green"

### Changed
- Area changes
	- Moonpier: exterior rebuilding complete (interiors pending); Beacon finished
	- Traveller's Rest: Beacon finished
	- Southport East: Beacon finished
	- Fort Cystana: Beacon finished
	- Fort Cystana South: Library exterior finished
	- Oakmist Vale Treetops: Beacon finished
	- Blue Lagoon: Beacon finished
	- Winya Ravana: Beacon finished
	- Whitestag: Beacon finished
	- Salandran Temple: Beacon finished
	- Greengarden: Beacon finished
	- Ridgewood: Beacon finished
	- The Dale: Beacon finished
	- Eilistraeen Shrine: Beacon finished
	- Kingdom of Kohlingen: Greengarden: Plot updates, player housing
	- Underdark: L'Obsul: Bug fixes, tweaks
- Gator/Alligator monsters that spawn all drop alligator hide for quest now
- A few dialogue changes to reflect plot changes
- Job System camel NPCs updated to new camel skins
- Epic loot drop percentage changed to 5% per party member, to a maximum of 50% with ten party members

### Fixed
- Bug fix for trophy drops in OI
- Gator hide tanner quest in Moonpier re-added
- Fixed DTS spelling errors, and added ports to NPCS
- Shadow Mastiff bug fix

## [2.9.2 - 2024-01-013]

### Added

- DTS deployed to Amia Frontier Orcs, Darkhold, and Skull Peaks Trolls
	- New Hidden Area made for DTS Orcs, Darkhold, and Trolls
- Smelly Black Orb item (Fiendish Corrupted class unlocker) added to test server +5 merchant
- Icons and items for OI animal hunting
- Player portrait

### Changed

- Area Updates
	- Kingdom of Kohlingen: Fort Cystana, South
		- Orphanage playground finished
		- 3 Interiors added (unfinished)
	- Kingdom of Kohlingen: Greengarden
		- Player Housing Added
- Switched out a PLC for DTS with another smaller one to fix difficulty in using old PLC
- Swapped out and added in new wings/tails for Abyssal Corrupted
- Swapped out Stinkpot DTS hidden item from ghost visage item to regen ring
- Expanded NPC collision functionality
- Added DTS support for multiple triggers for multiple entrances to a dungeon
- EMD Mummy Dust will no longer block undead summon for Druid (allowing for reskins)
- XP Dragon on test server gives more gold
- OI: Southeastern Bay; spawns changed
- OI: Eastern Cape; renamed to "Dragon's Fang Cape", guards swapped, construction added
- OI: Eastern Plains; spawns changed
- OI Boars & Bats now drop items for an event
- Wizard, Sorcerer, Bard, Cleric, and Druid cantrips are now infinite cast
- Flare, Ray of Frost, and Acid Splash are now cantrips for all cantrip classes
- Flare Changed: 1d4 fire per 3 Caster Level, and -1 to Attack rolls
- Ray of Frost Changed: 1d3 Cold per 2 Caster Level
- Acid Splash Changed: 1d3 Acid per 2 Caster Level
- Lesser Ring of Evasion and Kumakawa no longer have -2 Reflex save
	- Players can just ask in-game to swap for a new version without the Reflex penalty
- Salandran Temple NPCs updated per plot

### Fixed

- Dynamic Merchants had weird settings, fixed

## [2.9.1 - 2024-01-03]

### Added
- 2x player portrait added
- Dungeon Tool System Deployed to Stinkpot Warrens
- Variuos Palette items/plcs/creatures to support plot and other updates

### Changed
- Area Changes
	- Ruathym: Caraigh, Cloudfen Grove
		- Camp upgrade
		- Recall Pylon
	- 3x Player housing progression
	- Oakmist Vale: main, treetops hut, Caves
		- Cave expansion progression (not finished)
		- Tree tops, hut, small tweak of adding plot plc
		- Main, minor tweaks issue fixes
	- Bloodspear Keep 
		- Undead additional Guards
	- Travellers rest
		- Lamp gate brought in line with other gates
	- AshCaverns (all)
		- Complete removal of all area
	- Khem: whispering rift
		- Recall Pylon added
		- Portals that lead to the Alamber sea entry directly redirected here
	- Frozenfar: Belenoth, Interior <-> Obsidian Isle: Port, Great Hall
		- Portal between these two areas, per player request
		- Guards at both ends of the portal
	- Eternal Horizon Hull (ratpack ship)
		- Activation system for Mage private sanctum
	- Ruins of The Underkingdom, The Lava Depths
		- changed CL for loot bonus table
	- Kingdom of Kohlingen: Fort Cystana, South
		- Orpanage playground start (not finished)
	- Barak Rundar: The Frozen Wastes (main, Northern Pass, Southern Fields)
		- Drow Replaced with Aurilites
		- Area name change : Khazat Murr, Northwestern Face -> Southern Fields
- Druid dragon shape now requires only 28 wisdom (was 30)
- Bottled companions now support Z axis difirences
- Sea Travel conversation removal of Ashcaverns
- Actand summons (both demon and celestial)
	- Added bios to summon and widget
	- Overhauled their looks
	- Summon widget uncursed (if you have one already just use it, it will remove the cursed part)
- Lycan ac progression set to lycan level +1 

### Fixed
- Wrowl portrait mash should now display properly
- Abyssal corrupt now properly get the extra body part
- Moonpier, small woppsie fix backend
- Ambush % lowerd
- Gulf of Lumorier: South Coast: Resource node fixed
- Group boss summon system exploit fix


## [2.9.0 - 2023-12-24]

### Added
- Palette additions ( 4 plcs, 1 item, 1 creature)
- Custom summon script for items 
- Lycan forms:
	- Werecrocodile
	- Wereowl
	- Wereshark
	- Wereraccoon
	- Werefox
- Support for Lycans with tails
- 20 New Mount skins 1659 to 1678
- 8 New Creature skins 1946 to 1953
- More robes will now work on mounts

### Changed
- Area changes:
	- Gates and lawsigns update in regards of bannished races
		- The Dale
		- Kingdom of Cystana: All cystana areas
		- Travellers Rest: all areas
		- Oakmist Vale
	- Oakmist vale
		- Pre work for player boat request
	- Actand (the war areas)
		- Final changes, Dungeon now open
- Lycan changes
	- Forms placed into different build categories:
		- Damage Type: Werewolf, Werebat, Werechicken, Wereshark
		- Tank Type: Werecrocodile, Wereboar, Werebear
		- Nimble Type: Wererat, Wereowl, Werefox, Wereraccoon, Werecat
	- Class requirement updated: 6 BAB, Infection Feat, DM Approval
	- Lycantropy Infection (from lycans in the wild, players cant infect)
		- OnHit will fire off every strike now, and have a DC 20 Fort save to get infected
		- Infections can be removed through Remove Disease or Greater Restoration (including Healer NPC casting)
- Complete Warlock 2.0 Overhaul (See Class Modifications forum for details)
- Abyssal Corrupted: You can now choose which type of feature rather then random, but the exact appearance will be random
- Lavender ioun stone now +5 Discipline, +3 Fortitude Saving Throw

### Fixed
- Ambush system fixed: Resting in hunting areas may cause monster ambushes again
- Peerage helmet dropping will stop
- Peerage conversation will be silent now
- Defender stance will now not work while polymorped

## [2.8.1 - 2023-12-10]

### Added
- Raid boss summoning system
- Palette items

### Changed
- Area changes:
	- Oakmist Vale Grove
		- Moved few job system nodes
	- Oakmist Vale Grove, hut
		- repurposing kitchen to tailor hut (with tailor models)
	- Oakmist Vale Grove, Community Hut
		- Adding Chef trainer from kitchen area
		- Adding Kitchen cabinet/supplies from kitchen area
	- Frostspear's Cave / Ancient Crypt / Positive elemental plane
		- removal of default raid boss
		- Summoner pylon added
	- Amia Forest, West
		- Removal of skulls/redlights (ruins now just ruins)
	- Actand Demiplane: Unknown x2
		- Tweaks to area
		- Chest updates
- Demon and Celestial end boss of new dungeon tweaked to be less pushovers
- cavalery will loss bonuses and dismount when trying to polymorp
	
### Fixed
- Amia Forest deers should no not be hostile by default
- DTS loot fixes and tweaks
- Entry statue allows dragon subrace now

## [2.8.0 - 2023-12-06]

### Added
- [redacted] event script
- Custom polymorp script
- Actand demi plane (massive new dungeon)
- Lich raid Quest
- Variuos palette items (rewards of bosses/quests)
- DTS system (dynamic system for adding random things to dungeons that are difirent each time)

### Changed
- Area changes:
	- Actand: The Cliff Village
		- Demi plane entry (not accessible yet)
	- Ruathym: Ostland, Ancient Crypt
		- exploit barrier (doors close/lock at a point in lich fight)
	- Ruathym: Fortress Wiltun
		- Quest giver added for Lich raid (wave will get one aswell soon)
	- Ridgewood, Indoors
		- Gnome golem quest updated to new system
	- Skull Peaks: Glinulan's Hold, Halls
		- Missing companion quest updated to new system
- Dragon disipline overhaull (addition of spells!)
- Dwarven Defender/Defender:
	- Defensive stance 1 round Cooldown when stance drops
	- Defensive stance drops when using items (like healing kits)
	- Bite back reduced to 1 divine per 5 levels of Dwarven Defender/Defender

### Fixed
- Two Weapon fighter AB fix
- Portal lamp bug fix (that one you before needed the crafting menu)
- Hidden object scipt bypass exploit fix
- Storage item (artificer created ones) bug fix that made you lose last item
- Arbarista Piercing Shot exploit fix (no longer able to move with freedom items/spells)
- Fixes to entry statue and subraces (blocking illigal subraces, giving out proper widgets)


## [2.7.16 - 2023-11-25]

### Changed
- Area changes: 
	- Player house update
	- Oakmist Vale Grove, caves
		- Prep for player request finishing
	- Ruathym: Fortress Wiltun, Keep
		- At player leaders request, locked more doors
- Mythal Fuser update! Mythal fusers will now go upto/including Divine.
	- 12 Greaters fuse into 1 Flawless
	- 6  Flawless fuse into 1 Perfect
	- 6  Perfects fuse into 1 Divine
	
### Fixed
- Ruathym: Fortress Wiltun, Keep, Made throne proper sit-able

## [2.7.15 - 2023-11-19]

### Added
- Dukes estate area (not accesible yet)
- Food and drink Plc with inventory

### Changed
- Area changes:
	- Player house update
	- Oakmist Vale Grove:
		- Minor tweaks to previuos added npcs
	- The Dale
		- Further Hinification
	- Kingdom of Kohlingen: Green Garden (main, north, and old city grounds)
		- Plot updates
		- Dukes guards added, Militia replaced
	- Obsidian Island (port, Guard house, Great hall)
		- Guard gear/uniform updated
	- Ruathym: Fortress Wiltun, Keep
		- New Key to doors of keep
	- Ruathym: Caraigh, Shadowflame Keep (interior and exterior)
		- Portal rellocated to roof rather then basment
	- Skull Peaks: Crouching Lemur Monastery
		- Master Tsn removed (passed away)

### Fixed
- Hunters now no longer faill BGH attempts
- Consuming orb of darkness no longer gives party members alighment shift
- Zau'tar interior no longer leads to old L'obsul

## [2.7.14 - 2023-11-10]

### Changed
- Area changes: 
	- Barak Rundar: Citadel, Port
		- Recall pylon added
	- Oakmist Vale
		- (more) Druids, Feys and Redacted added
		- Fire pit new benches
	- Oakmist Vale: Treetop Village (interior and exterior)
		- Weapons Platform finished (last part, all exterior now done)
		- Rental doors added
		- Huts 3-6 and hut 8 interior finished
		- Beacon tree added
	- Oakmist Vale: Caves
		- Start of cave expansion (area extension + empty rooms are in)
	
### Fixed
- Polymorph Drow forms, now properly "drow"
- Robes +4 Merchant fix to show torso
- Winya Ravana: Old map pin removed
- big game hunter, Snowy mountaim
	- Block to get into other zone
	- Extra exit in a "dead" zone in case player gets stuck there
	
## [2.7.13 - 2023-10-27]

### Changed
- Area changes
	- The Dale
		- Recall stone now active
		- Carts moved a bit
	- Oakmist Vale, treetop village
		- Pixies added
	- Winya Ravana
		- Gates update tweaking allowed races better
		- Small Decoration update / player house things
	- Travel Agency
		- Wave & Serpent statue: updated to allowe previuos unbanned races
		- Winya Ravana flag: updated to reflect bannend races properly
	- Player house updates
- Door Lever script now supports tag bassed (opening doors far away)	
- Backend stuff	

### Fixed
- Ayan should now actualy sit down
- winya council tower meeting room glitch fixed

## [2.7.12 - 2023-10-22]

### Added
- 3x Plc to palette for requests

### Changed
- Area changes
	- Ruathym: Fortress Wiltun, Keep
		- Portal added to Shadowflame keep
	- Ruathym: Caraigh, Shadowflame Keep
		- Portal added to Wiltun Keep
	- Amia Forest: Oakmist Vale, Treetop Village
		- Patio hut 3/4 & 5/6 finished
- New skin over Abyssal horror

## [2.7.11 - 2023-10-15]

### Added
- New abyss area: Cambion Emporium + assosiated convos
- New 100% superior bag of holding (no weight, non at all)

### Changed
- area changes:
	- Abyss, variuos
		- Removal of spirit merchant
		- Relaying portals (forgoten temple -> emporium -> citadel)
	- Oakmist vale tree top village
		- Hut 7/8 patio finished
	- Endirs point
		- Militia now updated uniformal uniforms and better gear
		- Additions of helment horrors
	- Triumvir / Wave&serpant 
		- Lady Ayan relocated to the wave

### Fixed
- Endirs point
	- Replacment of resref/tags
	- Resource node reachable now
	- area transition properly at edge of map
- Lady Ayan fixes

## [2.7.10 - 2023-10-08]

### Changed
- Area changes: 
	- Amia forest
		- Proper tiefling block on gate (was already active in another way)
	- Oakmist vale
		- Cherry tree portal active
	- Oakmist vale, Treetops
		- Sundeck furnished
		- Palmtree portal active
	- Winya Ravana
		- Cherry tree Portal Active
	- 2x [Redacted]
		- [Redacted]
		- [Redacted]
	- Chult savana (multiple areas)
		- Updated to dm wishes
	- Tropical island 
		- Extra palm trees for exit of portal
- Thousand faces widget now has size changing options (standart max 10 +/- convo)
- Temporary name changer, added function for random names (description how to set this put in bio of widget)
- Jump_to_tag added option for double key check (needing 2 keys to work)
- Entry gate script ready to block pre ee characters (wont be active till 01-Nov-2023)
- Lichsong widget now 1x1 (ask a dm for replacment)
- Option for dms to allow druids undead summons (for emulation purposes)

## [2.7.9 - 2023-09-24]

### Added
- Player portrait replacment
- Bunch of plcs to palette for plc spawner requests

### Changed
- Area changes:
	- Winya Ravana (and burrows)
		- New gate
		- New gate exception tokens
	- Oakmist vale
		- Variuos farmland patches
		- Entry gate (amia forrest) now correctly blocks outsiders (as we cant block just tieflings yet, will be looked into)
	- Trackless Sea: Merfolk
		- Now open to the public trough the tropical island
- Visualizers now have one shot function rather then only on/off
- Added tilesets as allowed to [redacted]
- Old whitescale script cleaned up for re-use

### Fixed
- Bear Rakshasa hide fix

## [2.7.8 - 2023-09-16]

### Changed
- Area changes:
	- Oakmist vale treetop huts
		- Minor changes to grove huts as per player feedback + tweaks/woopsy fixs
	- The Dale
		- Overhaul Phase 2: Farmlands
		- Jayek returned (plot)
	- Winya ravana
		- Playerhouse woopsy door fixed
	- Coastal hills
		- removed sign indicating dangerus creatures as per plot
- Wild shape changes:
	- Shifter gets same progression of shapes as druid does
	- Druid changed to unlimited duration rather then 1 min/lvl in line with shifter
- Dreamcoin changes:
	- daily login dc removed
	- Weelky dc uncapped now (still 1 per 2 hours of game time)
	- Dm dc's raised to 2 per 2 hours to insentivice running things + compensationg for out of game activity
	
### Fixed
- Gem bags 
	- Can no longer stores ivory (shaped or not)
	- Can no longer store players, npcs, terain, gods or reality

## [2.7.8 - 2023-09-09]

### Added
- spawn_animations script (npcs can spawn with any animation now if set on_spawn)

### Changed
- Recall stone changes:
	- all stone types have a exception added to no portal areas
	- Plc can be spawned from palette as plc for dms to make allowed spots on the go (Portal Allowed Zone))
- Area changes
	- The Dale
		- Overhaul Phase 1: general layout and market square
		- Removal of Jayek (plot)
	- Player housing Updates
	- ALL Cystana and Gregory's landing areas set to no poral allowed due to plot
		- exception zones added
			- Recall point Central cystana
			- City hall portal room
			- [redacted]
	- Oakmist vale
		- Treetop huts 1-2 and 7 added interior
		- Treetops community hut game corner and halway lighting


## [2.7.7 - 2023-09-03]

### Added
- 2x Player housing areas added
	- Oakmist vale: cave
	- Winya ravana: Estate
- Variuos plcs to palette
- 3x new player portrait added


### Changed
- Area updates
	- Silent bay / Shrine of elistraeen (interior)
		- Minor plc tweaks
		- Old plot update that was forgoten
	- Winya Ravana
		- Massive exterior update, exterior construction now compleeted icly
	-Winya Ravana: Council tower
		- Tweaks to bring uptodate
	- Oakmist vale: Community hut
		- Now Finished with all that entails
	- Oakmist vale: Tent
		- Plot update
	- Oakmist vale: Tree top village
		- Unicorn magic statue
	- Amia forest
		- Spawns more deeper in forrest and less hostile
	
### Fixed
- Hydra in big game hunt crashes fixed
- Big game hunter creatures on spawn script minor fixes
- Werefox portrait fixed


## [2.7.6 - 2023-08-27]

### Added
- Kingdom of Kohlingen: Argent Keep, Prison (New Area)
- Kingdom of Kohlingen: Gregory's Landing, Destrier Stables (New Area)
- Kingdom of Kohlingen: Gregory's Landing, Portal Chamber (New Area)
- Kingdom of Kohlingen: Gregory's Landing, Gregory's Landing, Estate (New Area)

### Changed
- Kingdom of Kohlingen: Construction Site renamed to Kingdom of Kohlingen: Gregory's Landing
- Plot Area Updates:
	- Khem: Djedet
	- Kingdom of Kohlingen: Argent Keep
	- Kingdom of Kohlingen: Fort Cystana
	- Kingdom of Kohlingen: Fort Cystana, Hall of the Even Handed
	- Kingdom of Kohlingen: Fort Cystana, North
	- Kingdom of Kohlingen: Fort Cystana, South
	- Kingdom of Kohlingen: Fort Cystana, Western Beach
	- Kingdom of Kohlingen: Greengarden
	- Kingdom of Kohlingen: Gregory's Landing
	- Kingdom of Kohlingen: Trade Way
	- The Dale
	- Trackless Sea: Tropical Island
	- Barak Runedar: Grumdek Murr, Peak
	- Frozenfar: Endir's Point
	- Frozenfar: Endir's Point, Northgarn

### Fixed
- Tweaked link oops in Recall Explainer conversation


## [2.7.5A - 2023-08-18]

### Added
- Enhanced Recall Stone
- Divine Recall Stone
- Quest for Enhanced Recall Stone
- Dialogue that explains all Recall Stones fully
- Kingdom of Kohlingen: Argent Keep, Lower (New Area)
- 25 New Creature appearances (See forum for list.)
- 1  New Wings set (Quadruple wings)
- 1  New Player portrait
- 7  New Creature portraits (See forum for list.)
- 9  New VFX Glasses (See forum for list.)
	
### Changed
- Plot Area Updates:
	- Kingdom of Kohlingen: Fort Cystana North
	- Kingdom of Kohlingen: Fort Cystana
	- Kingdom of Kohlingen: Argent Keep
	- Name changes:
		- All "Kingdom of Cetha" references removed
		- Frontier's rest and all attached interiors renamed to "Traveller's Rest"
		- Festival grounds now part of Traveller's Rest
	- Enhanced Recall stone quest NPCs added to: 
		- Kingdom of Kohlingen: Fort Cystana, Trade Hall
		- Traveller's Rest: Wave & Serpent Guildhouse
		- Silent Bay
		- L'Obsul
		- Winya Ravana: Council Tower
	- L'obsul
		- Portal has a destination again on Amia (and associated "rule" pillars updated)
	- All Traveller's Rest areas updated with law signs, and new guards
- All Recall Stones keep the gold lettering after being attuned
- Mini quest script gained a max item feature so certain quests don't take all items at once
- Removed INT requirement in the healing merchant conversation

### Fixed
- Barbarian rage widget fix, no longer changes names of people
- New Bunny tail should now actually work
- Racial gate in Traveller's Rest (former Frontier's Rest) at lamp now in line with other gates


## [2.7.4A - 2023-07-29]

### Added
- Rabbit tail that uses haircolor
- Area: The table
- 1x Player portrait
	
### Changed
- Triumvir lamp now notes greengarden correctly	
- Candlekeep plot update
- Bottle companions phenotype support (meaning they can float, be old, be mounted, etc mostly for dynamic ones only) 

### Fixed


## [2.7.3A - 2023-07-23]

### Added
- Wings
	- Rainbow feather without armor
	- White feather without armor
- Portrait change option to master hair/tatoo changer
- 2 new mummy horse skins/tails (mounts)
- 2 new portraits (goat and mummy horse)
- 1 new item icon (guild badge)
- Plc to palette	

### Fixed
- All 10 dragon pointy "butt" wings now normal
- Treant no longer magical beast
- DM tool fix
- Soundset changer in character maintinance now works again

## [2.7.2A - 2023-07-14]

### Added
- Floating Hight Adjuster widget + script (comes with 3 build in hights options (and default), dm can alter these or lock it to just 1)
- Jobsystem Smith:
	- Can now craft warforged, sureforged and trueforged weaponry with the apropiate usual ingots + 50.000 gold (failure will not lose the ingot)
- Jobsytem Ranged craftsman:
	- Can now craft the Seeking and isaacs ranged weapons with the appropiate usual hemp/wood + 50.000 gold (failure will not lose the hemp/wood)
	
### Changed
- Alter self widget:
	- Z-axis support added.
 	- Scale support added. 
- Skin changer:
	- Z-axis support added.
- Cantrip update:
	- Ray of Frost: Damage scales 1d3 per 2 caster levels (metamagic does not apply)
	- Electrical Jolt: Damage scales 1d3 per 2 caster levels (metamagic does not apply)
	- Acid Splash: Damage scales 1d3 per 2 caster levels (metamagic does not apply)
	- Flare: Damage scales 1d4 per 3 caster levels (metamagic does not apply) in addition to the default -1 attack bonus penalty against a fort save.

- Area Changes:
	- All cetha areas related to southport/attached areas
		- Plot updates
	- Frontiers rest
		- Orc quest npcs re-added
		- floating fence fixed
		- Guild guards added aditional to SotS guards
	- Wave and serpent guild
		- SotS mostly replaced by guild guards
	- Kingdom of Cetha: Knights Hallow -> Skull Peaks: Knights hallow
		- (name change)
		- All guards, encampments removed
		- Area no longer hallowed as its not supported.
	- Obsidian island: portable
		- Golem added per player request
		
### Fixed
- The dale
	- 3rd firework target, back in the sky
- Gender changer fix
- Helmet 199 (TeS dummer helmet) position fixed
- Rainbow and default feathered armored wings fix

## [2.7.1 - 2023-05-26]

### Added
- Variuos plcs to palette

### Changed
- Area changes
	- All cetha areas updated with removal/replacment of all knights and some guards (plot related)

## [2.7.0 - 2023-05-14]

### Added
- Include script for mob effects
- 2x Tiger portrait added (normal and white)

### Changed
- ds_ai2_onspawn has an effect option, to be expanded
- Area update
	- Kingdom of Cetha: The Wave and Serpent
		- plot update
		- old bank now recall room
	- Kingdom of Cetha: The Wave and Serpent, Portal Chamber
		- Plot update
		- No more portals
	- Kingdom of Cetha: All other areas
		- Plot updates
			
### Fixed
- Cavalry: Can wield light crossbow while mounted with Mounted Archery.
- Dualist can be take as shifter again

## [2.6.9 - 2023-05-11]

### Added
- MANY more nature plcs to palette for requests
- New Hak additions to module:
	- 6 Mirrors (pretty!) plc's
	- 2 Cat statues plc's
	- 1 Painting plc's
	- Kelpie skin
	- Kelpie Tail (and thus mount)

### Changed
- Closed and removed all Vetzer parts of OI bank
- Skin changers now check current skin if it will apply new skin or revert to original (rather then on/off usuage)
- Bottled Companion widget shrunk to 1x1 (of you want to replace your 1x2 poke a dm/rh)
- Artificer storage cases:
	- Recovery amount is set properly (if between half and max recovery, dispends half recovery, if below, all)
	- Gem pouches can store any normal gem kind, and will merge job/non job gems of one kind
	- Bandage bag will store any +1,+3,+6,+10 healing kit type and merge them aslong as they match healing amount
	- Bio's now reflexts right amounts
	
### Fixed
- Cetha west, relocating a fence waypoint to prevent spawn next to eachother
- Bottled Companion non player race (dynamic) models, now also correctly can copy tails/wings if skin allows

## [2.6.8 - 2023-05-06]

### Added
- Player portrait
- New-ish, "Fox: Red" model (current one renamed to "Fox: Desert")
- many new alchemy plcs added to palette

### Changed
- Jobsystem artificer bags/cases max/recovery amounts changed
	- Wand case: 100 max Storage, recover amount 10
	- Scroll case: 100 max Storage, recover amount 10
	- Mythal tube: 100 max Storage, recover amount 1
	- Gem case: 10.000 max Storage, recover amount 100
	- Healing kit case: 10.000 max Storage, recover amount 100

## [2.6.7] - 2023-04-30]

### Added
- 2 new plcs (flag, floating candle)
- 1 new item (misc small 2, was missing for QoL)
- unicorn Poly potion (2da update, new potion item and new script)

### Changed
- Area Changes
	- Winya Ravana: council tower
		- Plot updates 
- Name changer, added the comand to set names in bio (for dm/rh)

### Fixed
- Gen summon bio's updated to reflect number of summoner

## [2.6.6] - 2023-04-22]

### Added
- Player portrait, Izia
- large Signs for job system crafting (arcitects) (these look like the old ones pre EE)
- Plc shrinking unicorn

### Changed
- Changed job system Gargoyle to fancier model
- Craftable signs renamed to small
- Area Changes
	- Djinn oasis 	
		- Minor name tweak
	
### Fixed
- Weapon focus and improved critical feats for trident now require either simple or druid weapon proficiency.
- Crash fix + setting BGH neutral creatures to difirent faction
- Ancient Cordor scriped removed to stop error message + updating cetha areas to have proper entry scripts
- Reapplied some pulled things in the crash bug hunting

## [2.6.5] - 2023-04-16]

### Added
- Prework for warlock changes
	- Empty scripts and creature blueprints, wont be active till future anvil plugin update.
	- For more info on the warlock update: https://www.amiaworld.com/phpbb/viewtopic.php?t=4334
- Hair dye kit, crafted by artists with any Dye and Elemental Essence: water
- Tattoo Kit, Crafted by artist with any Dye and Steel Ingot
- Hair and Tattoo widget, can be bought with dc, and is meaned for shifters, druids, assasins, transmuters and others who can change their looks on the go
- Player portrait
- 2x new plc (flowers) to palette

### Changed
- fire giant king sword now super fancy looking
- Area Changes
	- Amia forest: oakmist vale
		- relabeling pie/drinks baskets
	- Amia forest: oakmist vale, Treetop village
		- Reduced size siege gear (was massive)
		- Removed random floaty lamp

### Fixed
- Fire Giant axes now have shafts again
- Shifter azar and dwarf shape axes now have shafts again
- Big Game Hunter exit, starting bug/exploit
- Big Game Hunter resets Innocent faction on exit
- Unicorn statue mane, made to not be moving now
- Combat dummy crafting now correctly needs phandar wood not planks


## [2.6.4.1]

### Hotfix
- Fixed recall stones turning into generic summoners, including build in fix for existing recallstones that are bugged already

### Changed
- Alter Self widget moved to tutorial on palette

## [2.6.4] - 2023-03-31]

### Added
- 2x new player portrait
- 2x replacment player portrait

### Changed
- Player tools now can make a marked bottled companion sit on most places PCs can
- Area Changes
	- Winya Ravana: council tower
		- missing chair added
	- Amia forest: oakmist vale
		- Waters of life added in 2 spots as per player request
	- Amia forest: oakmist vale, Treetop village
		- "gym" platform finished
		- Spa bar update to fix issues
		
### Fixed
- Demonreach/hangmans cove area npcs now have a faction of themselfs, so only they will turn hostile when attacked not random guards elswhere.

## [2.6.3] - 2023-03-25]

### Added
- PLC added to palette
- 2 more Generic summons (so you can have a total of 5 now)

### Changed
- Playertools now also mark a bottled Companion for speech with "f_voice b" (rather then auto closest, will still do that if non is marked)
- Generic summon is now streamlined to 1 script, using your existing 2e or 3rd GS first time will update them.
- Area changes:	
	- Amia Forest: Oakmist Vale, Treetop Village
		- Daycare finished 
		- Spa bar finished (save a drinks merchant that will come later)
		- Pool finished
	- Amia Forest: Oakmist Vale
		- Added waterfall to match treetop village
	- Blue Lagoon
		- Massive new docks added
### Fixed
- Kingdom of Kohlingen: Fort Cystana, Argent Keep = Changed griffon to have correct portrait
- Fix to prevent shifter CD getting stuck on logging out (there was one, this is a failsafe)
- Fix to prevent Flight CD from getting stuck on logging out
- removed "<c ï¿½ï¿½>" from getting playertools 

	
## [2.6.2] - 2023-03-11]

### Added
- Area Additions:
	- Actand: Obsidian Cave (and  cave deeper)
		- Added a few resource nodes
	- Kingdom of Kohlingen: Greengarden
		- Added a few resource nodes
- Fox portrait (1462 po_CuteFox_) If you see a fox with a wolf/dog portrait let us know!
- Player portrait addition
- Job Item Refresher (in Maintenance: Character Modifier), now also converts non job-system gems into job system gems (Sapphire, Emerald, Ruby, Diamond)
- Some dev/dm QoL
	
### Changed 
- Winya Ravana Token on palette updated as per request
- Variuos foxes now have new fox portrait
- Feline Empathy now 1x1 (ask dm/rh for exchange of old one)
- Area changes:
	- Silent Bay: Crystal Bridge
		- Changed Peacock to Peahen (will now spawn eggs rather then you murdering animals in the shelter for meat)
	- Quagmire: Mercenary Camp
		- Changed steer to to dairy cow (will now milk rather then you murdering random animals in a camp)
	- Northern Sea: The Underport	
		- Updated outdated map pin
	- Winya Ravana: Council Tower
		- Dev side Tag/name plc changes for better orginization (part 1)
	- Amia Forest: Oakmist Vale, Treetop Village
		- pool now functional
		- Hutgroup 1&2 now have decorated platform
		- Lanterns on walkway
		- (rest will follow)
	
### Fixed
- Replacment for portrait po_grifffon_ , this cause a fill was missing, making it not work
- Fixed 2da portrait issue with missing/overwriten values (should not effect anything, but if you see a wrong portrait (non shifter related) let us know, we can fix it)
- Area Fixes:
	- Variuos resourse nodes fixed/moved (can now be reached/used/Appropiate job assigned, part 1 of massive resource checkup)
		- Kingdom of Kohlingen: Tristram's Path
		- Kingdom of Kohlingen: Greengarden, Outskirts
		- Kingdom of Kohlingen: Fort Cystana
		- Kingdom of Kohlingen: Fort Cystana, Western Beach
		- Kingdom of Kohlingen: Fort Cystana, South
		- Kingdom of Kohlingen: Fort Cystana, North
		- Blue Lagoon: Underpass
		- Winya Ravana: Sky Forest
		- Winya Ravana (also some dev side Tag/name plc changes for better orginization)
		- Quagmire: Ruins
		- Northern Sea: The Chute
		- Northern Sea: Springer's Point
			- Also Removed a spawn point as it was spawning mobs at unreacable places
	- Floating/misplaced plc fixes
		- Kingdom of Kohlingen: Greengarden (smithing station moved)
		- Silent Bay: Salandran Temple (merchant box removed)
		- Silent Bay: Crystal Bridge (Floating plcs lowerd)
		- Kingdom of Kohlingen: Construction Site (floating mountains changed)
	- Silent Bay: Shrine of Eilistraee, Mushroom Cave
		- Silk spiders now correct usable/farmable
		- Removed pre EE Jobsystem station
		- Set doors to auto close 20 seconds
		- Linked Tailor trainer to actualy train
		- Fixed not working transition
		- Tweaked placement of resource node to be better reachable
		
## [2.6.1] - 2023-03-03]

### Added
- New area
	- Amia Forest: Oakmist Vale, Treetop huts (wont be accessible till requested/approved and finished icly, just working in advance)
	
### Changed 
- slight palette adjustment (moving a faction key, and adding a old item back)
- Epic Gloves of Swordplay (+30 parry) added back to (epic) lootbin
- Area changes:
	- Amia Forest: Oakmist Vale, Treetop Village
		- Area slightly changed to fit designe better
		- New (temporarly) exit
		- Signs of construction (temporarly)
	- Amia Forest: Oakmist Vale
		- New ladder to topside 
	- Ruathym: Caraigh, Commerce Hall
		- Changed key needed
		
### Fixed
- Blue Lagoon: Interior
	- Chair adjustments
	- broken door fixed
- Frozenfar: Endir's Point
	- Rental signs now reflects proper prices

## [2.6.0.1] - 2023-02-26]

### Changed 
- Rest menu emotes now last indefinitly rather then 20 min
- BC's no longer have collision bubbles (they where bumping npcs around)
- Amia Forest: Oakmist Vale, lift to treetops now open

### Fixed
- Removed resting showing "<c ï¿½ï¿½>"

## [2.6.0] - 2023-02-24]

### Added
- New area
	- Amia Forest: Oakmist Vale, Treetop Village (wont be accesible till 26th mini update)
	- Amia Forest: Oakmist Vale, Community Hut (wont be accessible till requested/approved and finished icly, just needed to a place holder for it)

### Changed 
- Some descriptions and names edited on NPCs for lore expansion/correction
- Areas Renamed
	- Kingdom of Kohlingen: Old City Grounds > Greengarden, East
	- Kingdom of Kohlingen: North Pass > Tristram's Path
	- Kingdom of Kohlingen: Manor Grounds > Greengarden, Manor Grounds
	- Kingdom of Cetha: Southport, Outside the Walls > Frontier's Rest, West Outskirts
- Area Plot Updates
	- Kingdom of Cetha: Knight's Hallow
	- Kingdom of Cetha: Frontier's Rest
	- Kingdom of Cetha: Frontier's Rest, West Outskirts
	- Kingdom of Cetha: Southport Central
	- Kingdom of Cetha: Southport East
	- Amia Forest: Oakmist Vale 
		- Lift added to treetop village
	- Winya Ravana: Council Tower
		- Trashcans added
		- Door upstairs now city token locked

### Fixed
- Obsidian Isle: Port
	- Removed a seemingly stray wall and moved some lamps around at Puresoul's request
- Removed an unused area (removed in a plot ages ago)
- BC dialog tweaked in hopes it loops properly now
- gender changer now displays message only to player
- Many racial descriptions fixed (had odd tokens/signs in them)

## [2.5.9] - 2023-02-18]

### Added
- Papers and other identification items for settlements
- Area added: Ruathym: Caraigh, Commerce Hall

### Changed 
- You can now spawn multiple (different) bottled companions ("/s f_voice b" will target closest to you)
- BC's can now sit/lay on the floor indefinitly (was 10 min)
- BC "do someting" conversation now looping to stay in the conversation when messing with equipment
- Area changes
	- Fort Cystana: North/Argent Keep
		- Key Updates
	- Ruathym: Caraigh, Stormy Cliffs
		- Plot update
	- Ruathym: Caraigh, Shadowflame Keep
		- area name change (was Ruathym: Caraigh, Fortress of The Thane)
	- Ruathym: Caraigh Land's End Inn
		- Transition to stormy cliffs changed to commerce hall
	- Winya Ravana: Council tower
		- Removal of names
		- moving a lever so it can be used
		- no longer under construction

### Fixed
- Job Resource nodes fixes:
	- Cape Slakh: Den of Webs: Silver vein moved (should now be usable)
	- Khem: Khalem: removed 1 job cow, made the other able to be milked (also added a few more normal cows)
	- Northern Sea: The Chute: Felsu tree moved (should now be usable)
	
## [2.5.8] - 2023-02-11]

### Added
- 1 player portrait

### Changed 
- Area changes
	- Winya Ravana: Council tower
		- minor tweaks/cleanup
	- amia forrest: Oakmist vale
		- changed transition type to tent, and added faction lock
	- Ruathym: Fortress Wiltun
		- Plot area update
		
### Fixed
- Fixed an oops with the tailor kit recipe
- Wiltun: Dahey and Tamara now have shop inventories like they're supposed to.

## [2.5.7] - 2023-02-03]

### Added
- 5 player portraits

### Changed 
- Skin changer script now saves portrait each time its used to change into set form (this to allow portrait changes for people with them, and in line with alter self script)
- slight modification to plc jump script to hide feedback
- Area changes
	- Winya Ravana: Council tower
		- Clean up stuff and minor tweaks
		- Archives now done
	- Winya Ravana
		- Map pin updated of council tower
	- Winya Ravana: Temple of corellon
		- Statue of corellon changed to new model
	- amia forrest: Oakmist vale, tent
		- Colors of pillow changed (oversight originaly) and minor decoration tweak
	- amia forrest: Oakmist vale, caves
		- table added to storage

### Fixed 
- Oakmist vale, nemo has a fish portrait now

## [2.5.6] - 2023-01-28]

### Added
- New quest in Greengarden: "A giant with a warm heart."
- Added quest item to palette
- Kingdom of Kohlingen: Fort Cystana, Argent Keep (New Area)

### Changed 
- The grand Vetzer store house closing
	- Locations closed:
		- Frontier's Rest
		- Barak Runedar
		- Endir's Point
		- Wiltun
		- Kampo's
		- The Dale
		- L'Obsul
- Winya council tower: Meeting room finished
- Bringing old scripts with portals for [redacted] in line with lore and other current portal systems
- [redacted] portal exit moved to new location
- Added door guards to Blue Lagoon: Underpass
- Construction progression in Fort Cystana and Fort Cystana: North, mostly the exterior of the new Keep
- Simmons Estate location removed/emptied, House Guard/Everguard moved
- Travel Agency banners updated:
	- "City of Kohlingen" banner changed to "Greengarden"
	- Removed "Return to Prior Location" banner because that's not ready yet
	- Added "Bloodspear Keep" and "Start Location: Evil Underdark" sparkles (Also added waypoint to Bloodspear outside the gates)
	- Added "Blue Lagoon" (Also added waypoint to Blue Lagoon docks)
	- Added "The Triumvir" (Also added a waypoint outside Triumvir Courtyard inn)
 		
### Fixed 
- Descriptions, voicesets, and scripts fixed on lots of guard NPCs
- Tweaked an item spawn script that was behaving oddly

## [2.5.5] - 2023-01-21]

### Added
- Obsidian Island Recall stone quest added (start at the mythal forge in the Great Hall)

### Changed 
- Camping tools (old plc spawners (like cushions, stool, campfire etc ) now no longer show the name of who placed it 
- Travel agency Flag to Winya now leads directly to winya's entry rather then the far away path
- Hunter traps changed, hunters can now chose between 3 trap kinds
	- Hide trap = gives 1 Hide of random quality + 1 game meat
	- Fur trap 	= gives 1 Fur of random quality  + 1 game meat
	- Bone trap = gives 1 Bone of random quality + 1 game meat
- Area changes
	- Winya Ravana: Council tower
		- Guest rooms finished, staff room finished (just no staff yet) variuos signs added
		- Variuos rooms are now warded (message on entering)
		- Cook hired
	- Obsidian Isle: Port, Great Hall	
		- Added npc to start/end recall stone quest
	- Obsidian Isle: Port
		- 2 new npcs for recall stone quest
		
### Fixed 
- Automatic dc message changed to "received" (was Recieved)

## [2.5.4] - 2023-01-14]

### Added
- New Item icon (small3_232)

### Changed
- Area changes
	- Winya Ravana: Council tower
		- Councilors, ambassador, kitchen, atrium rooms finished, corridors enhanced
		- Staff, archive and variuos support rooms updated, but not finished

### Fixed
- Fixed tileset bug Kingdom of Cetha: Southport, West Coast (cordor_Westcoast)

## [2.5.3] - 2023-01-07]

### Added
- "v" voice command to make Vassals (peerage summon) speak, use "/s f_voice v [text]"

### Changed
- Many BGH creatures now will have correct racial type, and some will be not hostile unless attacked first
- Added removal of collision bubble to script that freezes creatures permanently (for statues and such) so they cant be pushed around any more
- Removed class restrictions of crafted magic staff (due enforced properties added light, masterwork quality and +1 attack)
- Area changes
	- Winya Ravana
		- New guards for council tower
	- Winya Ravana: Council tower
		- reconstruction finished
		- partly furnished now (more will follow later updates, but its functional now)

## [2.5.2] - 2022-12-16]

### Added
- Lots of job resources added to the Underdark
- Finished seeding areas with new farmer/rancher/hunter resources

### Changed
- Nec'perya/Thraan'dariv removed from the module

### Fixed
- Fire Ant Queen's Scale now gives the proper 25% fire immunity (script didn't exist previously)
- Fire Ants nerfed to be in line with other similar-CR creatures
- Fixed Argh's Antidote quest
- Fixed Spider Clutch not giving XP
- Illusion & Gnome Domains now properly extend Invisibility, Improved Invisibility, and Invisibility Sphere
- Tyranny Domain now properly extends Dominate Animal, Person, Monster, and Control Undead

## [2.5.2] - 2022-12-10]

### Added
- Area additions:
	- Winya ravana
		- Big game hunter guides 
		- Hunter camp
	- amia forrest: Oakmist vale
		- Big game hunter guides
	- Redacted area
		- Secret entry set up
- 2x Dm Area for beans

### Changed
- new armor design for winya's temple gaurds
- Hunter trainer moved from falls to inside winya (to new hunter camp)
- Area changes:
	- Winya Ravana: Commons area -> Winya Ravana: Council Tower
		- Area name change
		- phase 1 of overhaule of tower to serve the ruling body of winya
	- Amia Forest: Oakmist vale	
		- Minor tweaks to suit previuos updates
	- Winya Ravana: Temple of corellon
		- Futher updates to progress construction interior
		- placed bariers to plug a hole
	- Silent Bay: Crystal Bridge
		- Tweaked lighting setting to be in line with silent bay, this will remove compleet blacknes at night
- Job System Base Resource changes:
	- All cooldowns now set to 120 seconds
	- Farmer, Rancher, and Hunter Trap spawnable resources set to 1
	- Farmer, Rancher, and Hunter Traps now able to be placed in-world by developers
	- Unlimited number of resources allowed on a base resource (was previously 3 max)
	- Raided Supplies added to the palette (Random set of resources on a theme, harvestable by Scoundrels)
	- Chance for Scholar Artifacts & Ivory to be found in random dungeon chests
	- Areas have been seeded with Farmer, Rancher, and Hunter resources, with emphasis on areas A-I and civilized areas
- Area name / resref changes to be more in line with current state / way of working
	- Crystal River: Bridge -> Silent Bay: Crystal Bridge
	- Crystal River: Bridge, animal shelter -> Silent Bay: Crystal Bridge, Animal Shelter
	- Crystal River: The Falls -> Winya Ravana: The Falls
	
### Fixed
- Minor woopsy fixes in grove and grove caves
- Obsidian island: Port, Great hall = Soldier trainer fixed, should now give the job, not just empty log
- More job PLCs rotations corrected (Colored Rugs, Big Leather/Bone horn)
- We really think the spawn size issue with party size is fixed now

## [2.5.1] - 2022-12-03]

### Added
- Fort Cystana: Bistro La Suzail (and Cellar)
- Fort Cystana: Emerald Bathhouse
- New dynamic PLC resizing script
- Shop for Bathhouse
- 2 New PLCs added to palette (Tent and Piano)
- Player portrait malandria
- New area: Amia Forrest: Oakmist Vale, Caves
	- Added wolf den + moved wolfs in it
	- Added storrage cave, partialy filled with storage plc's but room for more
	
### Changed
- Updated sign, door, and NPCs outside restaurant and bathhouse in Fort Cystana
- Key update for a faction
- Added scale to Medieval Chair 1 on palette so it's human-sized by default
- Area changes: 
	- Amia Forrest: Oakmist Vale, Tent
		- Per player request, placed more pillows and moved some barrels
	- Amia Forrest: Oakmist Vale
		- Added entries to wolf den and storage cave
	
### Fixed
- Typos in some Bistro food/drinks
- Changed some doors in Obsidian Isle: Sewers
- Added boat travel trigger to Fallion in Obsidian Isle: Port
- SD Shadowlord summon should mirror PC's gender
- Certain Job System PLCs have had their rotation corrected
- Next attempt to fix Spawn sizes

## [2.5.0] - 2022-11-25]

### Added
- New areas for Obsidian Island encompassing the southeastern side of the island
- New OI Spawns
- 2 new OI quests
- Script for creating dungeon lever doors
- Script for spawning randomized PLCs
- Food and drinks for Cystana restaurant
	
### Changed
- Obsidian Isle: Port : has had a big facelift
- Obsidian Isle: Great Hall : has been reconfigured for flow and security
- Triumvir: Courtyard : Plot update, a new family moved in
- Boat travel added from Wiltun -> Blue Lagoon, per Pinky
- Adjusted Scholar rolls to be 100 Primary and 80 Secondary to match other jobs
- ds_random_head allows for females, too
- Amia Forest: Oakmist Vale, Tent : remade area in difirent tile and big overhaul as per player request/rp
- Amia Forest: Oakmist Vale : Neley is now a proper (arch) druid + fishy animal companion
	
### Fixed
- Typo in Arivara's name in Fort Cystana, North
- spawn_dance not working as intended, fixed
- Renamed npc in wiltun that had old jobsystem name to Sheila
- Switched classes for hawkeye due to woopsie
- Spawn size is now considered based on party size in area not total again

## [2.4.1] - 2022-11-19]

### Added
- New Kohlingen Courtroom area
- New database token
	
### Changed
- Banners and statues in Fort Cystana for Courtroom
- Tweaked prices of Boarshead drinks

## [2.4.0] - 2022-11-18]

### Added
- New Boarshead Tavern interior in Kohlingen
- New tent PLC to palette
- New food and drink items on the palette for Boarshead store
	
### Changed
- Added NPC clergy to Fort Cystana for Red Knight, Siamorphe, Mystra, Bahamut
- Gave existing clergy NPCs names in Fort Cystana
- Added Gregory lying in state
- Added some guards and rangers to patrol areas per Bag's plot
- Removed spawns, fumes, blood, and gas from Construction Site, added VFX
- Completed Boarshead construction in Kohlingen: Greengarden
- Added/moved some Greengarden militia around Greengarden areas
- Shadow jump cooldown is now 12 sec flat, in line with flight
		
### Fixed
- greengarden bug fix (server side)

## [2.3.9] - 2022-11-11]

### Added
- Tailor Kit (script+widget) added, this kit allows storing an armor appearance on it, and deploying it on another armor (so no more need for endles bags of the same armor) craftable by tailors (bolt of silk, steel ingot)
- Item icon for tailor kit (misc small 3)
- Alchemy workbench added to Starlight conclave per player request
- plc, palette, added giant chalkboard (custom -> Trades & Academic & farm -> Academic, Chalkboard)
	
### Changed
- Area Changes:
	- Starlight Conclave: Halls
		- Alchemy Workbench (player request)
		- Hallow triggers (plot update, per Jes)
	- Kingdom of Kohlingen: All Greengarden Areas & City Hall
		- Everguard NPC bios updated
		- Plot updates - Silver Dragons & some NPCs moved/removed
	- Silent Bay: Shrine of Eilistraee, Mushroom Cave
		- Goblin living space updated
	- Ruathym: Fortress Wiltun, Keep
		- Removed lord wiltun
	- Underdark: Bloodspear Keep
		- Added racial lock to main gate, specified settings, per primary leader
	- Belenoth, halls
		- Added desired description to giant book in libary
	- [location redacted]
		- Replaced a static tree to plc tree for better movement options / removing bug that was trapping of players
		- Realigned entry and various mechanical parts to accommodate the change
		
### Fixed
- Small cosmetic change to gender changer message (added a space in feedback)
- Script of Elvoriel, will now cause her default to size 1 instead of 0 when changing shape

## [2.3.8] - 2022-11-04]

### Added
- Gender Changer, script + widget for changing your gender
- Unlimited uses SELF Changer, QoL widget for dms to change existing widgets x/day power self, to unlimited/day power self
- PLC palette additions:
	- Couch: Highside - White (fancy sofa/couch)
	- Chair, Medival 1 (fancy medival chair)
	- Bookshelf 4 (large scroll/book case thing)
	
### Changed
- Parry unlocked: This change has been undocumented for a good while (sorry about that). Parry now ripostes up to your attacks per round. However, Parry can only deflect attacks equal to your attacks per round up to 3 attacks per round. If you run tests contradicting this functionality, let us know! This is our best guess as to how it works, because the tweak is from an outside source, and it's poorly documented and understood by even its creator.

### Fixed
- Bottled companion static skin scaling should now also work
- 20 DD now correctly gets +1 AC and +2 CHA
- Lycan now gets weapon prof creature

## [2.3.7] - 2022-10-30]

### Added
- Four new player portraits
- Updated cat empathy to inclide new cat skins (other empathy's will follow later)
- Added Script spawn_sit_ground for npcs to "sit"on spawn on the floor rather then a stool
- Added variuos plc's to palette for making some old broken things work (and some general dev QoL)
- area additions
	- Amia forest
		- 2 treant tree's 
	- Winya Ravana	
		- further decoration, including more trees and multiple benches
		- moved guard "junk" to inside
		- start of beacon "tree" its growing!
		- very basic stables added 

### Changed
- Put in a missing sign
- Made Elfing compatible with Arcane Archer like other half-elves
- Belorfin's shop allows warlocks now
- Changed limit of plc group cloner script to 30
- Changed plc group cloner to 1x1 item and updated description to reflect changes
- Various dev area changes for Qol and testing
- Added scale storing to Summon Changers, Bottled Companions, and Skin Changers
- Moved and renamed Nof in The Dale
- Made Sir James Tanner's name green to indicate quest NPC status

### Fixed
- Loading screens for Cystana areas
- Job System spawnables incorrectly set in various places


## [2.3.6] - 2022-10-23]

- Script for customizable repeatable bulk-item turn-in quests
- 9 different monsters for Kohlingen spawns

### Changed
- Fort Cystana, Central re-made with Medieval City tileset
- Construction closer to finished in Greengarden, Greengarden Outskirts, Trade Way, Fort Cystana North/South
- Spawns added to Old City Grounds, Radiant Keep, and Manor Grounds, per BagOfFelt
- Beacons added to Fort Cystana and Greengarden
- Construction indicators throughout all Kingdom of Kohlingen areas
- Carts added to Trade Way, Crystal River Falls, Salandran Temple, Greengarden
- Moved Manor Grounds weavery NPCs to Greengarden
- Changed Mayfields Brewery map pin to Boarshead Brewery

## [2.3.5] - 2022-10-21]

### Added
=HAK= -Added 1 new wing appearance

### Changed
=HAK= -Changed the Heavy Flail animations to match Greatsword (hopefully that looks better)

## [2.3.4] - 2022-10-19]

### Changed
- Updated Kohlingen City names to remove the second "Kohlingen" (Greengarden, Old City Outskirts, etc.)

## [2.3.3] - 2022-10-18]

### Added
=HAK= - Added 34 Robes to the hak
=HAK= - Skin Appearances: 6 sharks, 34 birds, 4 gnomish ships, 8 wizards, 3 witches
=HAK= - PLCs: 16 statues, 4 gnomish ships, 7 cultist corpses, 101 NWN2 building PLCs
=HAK= - Added 2 heads from Mahtan
=HAK= - Added new vfx (cat ears/sideburns for more races), .mld and .tga files to amia_top and Amia_parts.
=HAK= - 86 new list additions for visualeffects.2da

## [2.3.2] - 2022-09-23]

### Added
- Eternal Horizon got a few golems.
- A few new PLC curtains.
- 2 new haks: amia_tile_patch3, amia_tile_patch4
	- Gives 24 Bioware tilesets a glow-up that requires no overrides:
		- Barrows Interior
		- Beholder Caves
		- Castle Exterior
		- Castle Interior
		- Castle Interior 2
		- City Exterior
		- City Interior
		- City Interior 2
		- Crypts
		- Desert
		- Drow Interior
		- Dungeon
		- Forest
		- Fort Interior
		- Frozen Wastes
		- Illithid Interior
		- Mines and Caverns
		- Ruins
		- Rural, Summer
		- Rural, Winter
		- Sea Caves
		- Sewers
		- Steamworks
		- Tropical
	- Adds 24 new tilesets:
		- Marble Elven Interiors
		- Sen's UD: Icy Caverns
		- Abyss
		- CTP Babylon
		- CTP Black Desert
		- CTP Brick Interior
		- CTP Cave Ruins
		- CTP Elven City
		- CTP Elven Interior
		- CTP Gothic Interior
		- Daggerdale Swamp
		- Earthen Tunnels
		- GH Castle Interiors
		- Jacoby's Jungle
		- Mines and Caverns Ice
		- UD 1 Main
		- Terria, PHoD Desert
		- Terria, PHoD Hell
		- Terria, PHoD Verdant
		- Terria, SEN Original
		- Winter CRF - Pasilli
		- WoRm Cypress Bayou
		- WoRm Fantasy Interiors
		- WoRm Scorched Earth
		
### Changed
- Haks amia_tile_patch1 and amia_tile_patch2 updated for the above tileset update.

### Fixed
- Warlock no longer counts for PM prereq. However, you can still be a Warlock and PM if you meet the 3 level prereq with some other arcane class.

## [2.3.1] - 2022-09-23]

### Added
- Mini storage chest now live!
	- The chest is made with "Storage Box kit" + 10k gold by merchants (use job log on a kit)
	- Storage Box kit is made with "Shadowtop wood" + "silverbark sap" by arcitects (in station)
	
### Changed
- All merchant job box's retrieve options set to 25, 100, 250 (was 50, 500, 1000) this due to engine limite of 25 chest pages maximum of chests/box's

### Fixed
- Big Game Hunter: Large Wasps now have vermin immunities
- Big Game Hunter: Umber Hulks no longer sound like wolves, have chaos gaze
- variuos exploit fixes
- fix to hak for (re)adding phenotype "old" (9) 


## [2.3.0] - 2022-09-16

### Added
- Areas
	-Plane of Shadow: Shadowscape, Academy
		- added Instructor Glelia for new UA: shadow affinity quest
	- Plane of Shadow: Whispermere
		- added quest trigger for new UA: shadow affinity quest
	- Plane of Shadow: Whispermere, Shadow Citadel
		- added quest trigger for new UA: shadow affinity quest
	- Kingdom of Kohlingen: Construction Site
		- Plot updates(careful, it has strong spawns now)
		- Various areas around it have warning signs now
	- Winya ravana
		- Added candles to cannel 
	- Kingdom of Cetha: Southport, West Coast
		- Stables added
	- Kingdom of Cetha: East Coast, Festival Grounds
		- Grounds a lot more festive now
- Operator Oleig has found an appreciation for Tyrannosaurus Hides
- Shadowdancer quest "UA: shadow affinity quest" For learning the Shadow affinity ability (widget)
- OI Plot updates to area
- OI plot updates to monsters
- QoL DM's
	- 2 extra linkers
	- 4 extra army pens + dagger

### Changed
- Path of Pain: The Path's self damage is too punitive and early levels are too punitive. To address this, the roundly incrementing self-damage now caps as follows:
	- Pain lv 1 = cap 10 dmg/round
	- Pain lv 2 = cap 15 dmg/round
	- Pain lv 3 = cap 20 dmg/round
	- Pain lv 4 = cap 25 dmg/round
	- Pain lv 5 = cap 25 dmg/round
- The Job Item Refresher will now accept old versions of Mythal Tubes, Bandage Bags, Gem Pouches, Trap Cases, Wand Cases, Scroll Holders, Backpacks, Scabbards, and Quivers
- Added icons for Backpacks, Scabbards, and Quiver to the hak
- Updated base items for Backpacks, Scabbards, and Quiver

### Fixed
- Moonpier, given head back to <c Í >Ferdinando the Eccentric</c>
- Underdark lobsul, Zenati, removed default behavioral script in hopes he stops hiding
- Fixed the transition in Alambar Sea: Fortress Khuft
- Alchemist Elemental Resistance potions had incorrect descriptions
- Two Weapon Fighter: The AB bonus stacking blocked as intended. The AB bonus from same-sized weapons to emulate smaller weapons fixed from +4 AB to +2 AB as intended.
- Indomitable: No longer removed by the restoration line spells.
- Updated the JS Base resources script to allow non-spawned rancher animals and farmer crops
- Fixed the unharvestable chickens in Shrine of Eilistraee


## [2.2.10] - 2022-09-09

### Added
- Beacon tower construction in Kohlingen
- Plot updates to OI
- Plot updates to the dale
- Plot updates orc keep

### Changed
- QoL to adjust rotation for spawned PLCs
- reactivated Umbran Arts: Shadow Affinity (and only this one)
- Kingdom of cetha: wave and serpent, changed door to guild/merchant area to not auto close

### Fixed
- Malformed creature sizes adjusted
- Artist Brazier now unusable
- Artist Lamp Post now uses the correct recipe

## [2.2.9] - 2022-09-02] 

### Added
- area
	~ Underdark: L'Obsul
		1. added quest to gain recall stone (3 npcs)
	~ The Dale
		1. towers/balistas
		2. varius plot updates
		3. recall pylon construction site
	~ Underdark: Bloodspear Keep
		Variuos plot updates to exterior and interior
- Added a job log reset NPC to the maintenance room that will reset one of your jobs once per month
- Created several base areas for Obsidian Isle wilderness
- Added racial gates to Obsidian Isle
- Underdark recall stone quest (start at recall pylon in lobsul)
- Magic staff 2h (same aesthetic options as the 1h version)

### Changed
- Aesthetic holdables size changes (smallified for the hobbitses):
	- Trumpet: medium -> small
	- Tools, pole (Shovel): medium -> small
	- Makeshift (Chair): medium -> small
	- Flower Vase (4 varities): medium -> small
	- Custom Items (Pipe / Telescope): medium -> small
- Path of Pain: Base self-damage changed to start at 5 from 20.
- set new recall stone unatunned to accompeny new locations of gaining it. NOTE you need to attune it to a pylon now before it will work (instead of default wave portal room)
- Renamed Underdark: L'Obsul, lower,  storehouse to Underdark: L'Obsul storehouse
- removed Underdark: L'Obsul lower (old area)
- Added links to Obsidian Isle Workshop, Smithy, and Inn
- Construction sites for beacon towers to Whiteshore, Cystana, and Blue Lagoon
- Skull Peaks: Glinulan's Hold, Caverns,  added bash script to trap door
- Grand QoL change for unlimited usage on widgets (many "new" widget with no major mechanical benefit will now be set to unlimited usage instead of 4/day) one's changed so far)
	- Alter self 
	- skin changer
	- bottled companion
	- old (weak) shifter / druid shape widgets (in line with the newer unlimited of newer ones)
	- all of the camper's paradise series

### Fixed
- Cavelery custom bc summon fixed to no longer summon a hive queen instead of set mount
- Kingdome of cetha: trade hall , gave Furth back his head
- Underdark: L'Obsul storehouse, fixed transition to go to proper/new location
- Underdark: L'Obsul Hall of negotiations, fixed transition to go to proper/new location
- Kingdom of Cetha: Skull Peaks, Indoors made chef trainer not undress

## [2.2.8] - 2022-08-27

### Added
- areas	
	- Winya Ravana: Temple of Corellon
	- Winya Ravana: Guard house
- New "red key" for winya's guard
- Variuos plot/upgrade additions to winya in general

### Changed
- Warlock's Word of Changing AB increase nerfed from +1 AB / 2 Warlock levels up to +10 AB max -> +1 AB / 4 Warlock levels up to +5 AB max. The reason is that the spell is intended to emulate a full BAB class and now it does that better. Also, there were some balance worries, as the AB bonus was hefty.
- variuos winya updates, with the guard house being opend (though empty for now)

### Fixed
- WArlock updates
	- Spells:
		- Dark Foresight: Duration was incorrectly 1 round, fixed to scale for rounds per CL.
		- Caustic Mire: Targeting fixed only to target enemies/neutrals. Was giving too much fire vulnerability, fixed to 10%. Damage calculation fixed to 1d6 + cha mod up to 10.
		- Writhing Shadows: Wasn't capped for +10 cha mod damage, capped properly now.
		- Tenacious Plague: Wasn't capped for +10 cha mod damage, capped properly now. The damage die fixed from 1d12 to 2d6.
		- Chilling Tentacles: The paralyze effect wasn't working. Now it rolls the tentacles for 1d4 per round per target, respects NWN grapple rules (size matters!), and paralyzes for 1 round on a successful grapple against fortitude. The cold damage die fixed from 1d12 to 2d6.
		- Curse of Mire and Walk Unseen were flipped in code; they are working now, although casting Walk Unseen on a target other than yourself still makes yourself invisible, not the target. Dunno if this is intended. Probably not? Seems silly, right?
	- Essences:
		- Capped Frightful essence fear effect from 10 to 2 rounds.
		- Binding, bewitching, and utterdark in-game descriptions updated, as they were incorrect.
- Divine Champion: DC levels were stacking for purposes of Divine Might and Divine Shield incorrectly; they no longer stack. Purge Infidel was a weapon property, which allowed for shifters and lycans to exploit it; this was reimplemented as a damage increase effect and the exploit is no longer possible.
- Base armors: In-game base armor descriptions now match Amia's edits to Max Dex AC.
- Fix attempt against crashes


## [

### Added
- Added Discord webhook for guarded areas, PvP involving players and their associates only
- Added DM area for Pinkham
- Added new item for portable shops, named it " Portable Shop" - smaller and lighter than Job System Converter item
- Added plot monsters for BagOfFelt
- Added a Job Item Refresher to the Character Maintenance area that converts old job items to new size/appearance/description

### Changed
- Added code to refund an Underwater Enchantment if used on the wrong target
- Made nearly all the job items into 1x1 size and added descriptions to everything
- Added all the resource nodes to the JS testing room
- Added many of the redone JS items to merchants for ease of testing
- Added a warp between the Dev area and the Job System testing room
- Added a cooldown message in seconds to the job journal spawned resources and every base resource
- Added drow to ban list in Cetha areas
- Drow mechanically blocked by racial gates in Cetha areas
- Created new key to bypass racial gate in Cetha
- Moved Cart to The Dale outside the gates in Frontier's Rest
- Removed portal to L'Obsul from W&S Portal Room
- Detached portal to W&S from L'Obsul
- Added some lights to the Travel Agency for starting locations
- Added Obsidian Isle banner to Travel Agency
- Removed ban-block from Frontier's Rest banner in Travel Agency, since it leads outside the gates now
- Created new 1x1 versions of Tailor backpack, quiver, and scabbards and Artificer storage items
- Created a modular storage/retrieval script for Artificer storage items and included it into js_effects for consistency
- Changed the names of some of the Underdark quests so they have spaces and punctuation
- Edited ds_j_activate to acknowledge the new " Portable Shop" item
- Plot updates to Kohlingen: Construction Site


### Fixed
- Fixed Bendir Dale's Hinn Inn sign
- Fixes to various Job System QoL items
- Fixes to UD quests: Handur's Shield, Pucor's Pick
- Test Server has a version of Frontier's Rest without racial gates
- A Chef recipe has been fixed in the conversation
- Added Game Meat to the conversation to spawn hunter traps so that it's clear you have a chance of either fur/hide/meat
- Removed an old version of L'Obsul that was creating issues with area transitions
- Corrected the inventory descriptions for armor to correctly show Amia's changes to maximum Dex modifier
- Multiclass penalty removed


## [2.2.5] - 2022-07-28

### Added
- Added "/s f_jsname" & "/s f_jsbio" details to every job log going forward

### Changed
- Endir's Point plot updates
- Naming for Job System PLC spawners has been fixed. **Please report any typos!**
- Changed "/s f_jsname" & "/s f_jsbio" to allow any Job System item to be customized

### Fixed
- Ridgewood Merchant inventory fix
- Artist's Black is now craftable
- Tailor crafting dialogue fix
- Artist dialogue updates to add "Cancel" buttons
- Updated raven banners with more descriptive names
- removed outlaw_pvillage from development folder server side
- PLC Spawner description updated to be agnostic
- Tweaks to Job System testing room
- Updated Ridgewood quest item to be destroyable
- Moved Duskwood node in Kingdom of Cetha: Howling Pass
- Moved Mithril node in Kingdom of Kohlingen: North Pass
- Area fixes
	- Demonreach: Blightwood (and) , East
		1. fixed crashing issue
	- Quagmire: Mercenary Camp
		1. fixed crashing issue
	- Welcome to amia
		1. realigned starting point
	- Obsidian Isle 
		1. Great Hall remodel


## [2.2.4] - 2022-07-25

### Added
- Artist Colors to dye bags and use in recipes
- Artist placeables (the rest of them)
- Additional Tailor craftable tent appearances (Blue/White, Red/White, Black/Red)
- All the new Artist recipes
- Dedicated Job System placeable and testing area
- A few new Ridgewood historical-themed items
- pipeline and QoL for dev side for quicker and easier deployment
- plot updates to OI

### Changed
- Job System converter script to base naming off of placed placeables
- Job System converter script to be able to use crafted placeables in recipes
- Artist conversation
- Tailor conversation
- Job System effects script to enable bag dyeing
- Changed hunter "Hanging Skin" placeable appearance to hopefully be easier to use/place
- Changed Job System PLC spawners to be a 1x1 small inventory icon size instead of 2x2
- shifter "buff" nerf reversed cause shifter delay is considerd nerf enough
- Area changes:
 	- Ridgewood (interior and exterior) "living world" updates
		1 Changes and construction around main Ridgewood area
		2 Ambassador's office opened
		3 Trade hall opened
	- midnight rose
		1. interior update
	- Amia Forest: Northwest
		1. added 4 wolfs who moved from somewhere ells
	- Ruathym: Caraigh, Scath Crann
		1. removed 4 wolfs who moved to somewhere ells

### Fixed
- Area changes
	- Khem: Sand Minotaur Cliffs
		1. Moved ruby vein to be reachable
	- Cape Slakh: North
		1. fixed the spawns not spawning
	- Cape Slakh: South
		1. fixed the spawns not spawning
	- Lobsul various	
		1. Fixes
- pipeline fixes



## [2.2.3] - 2022-07-15

### Added
- New widget "the name changer" (will lay a temporary name over your real one. 1 name per widget curently)
- script for the name changer
- hak update to amia_parts, amia_top
	- colored bags
	- lots of new plcs

### Changed
- updated the amia_parts.hak with new version adding many new toys
- updated the amia_top.hak with new version adding many new toys

### Fixed
- more fine tuning for the fallen systen, now hooked into layonhands/divinewrath
- archivie system hooked into the server db to work (already live)

## [2.2.2] - 2022-07-08

### Added
- Archive system! type /s f_file and follow the conversation
- Area additions
	- Kingdom of Cetha: The Wave and Serpent ((ON TEST SERVER))
		1. added bloodsworn feat giving statue
	- Winya Ravana
		1. remodeling/moving parts of winya to accomedate proggress
	- Crystal River: Bridge
		1. removal of old marks of beastman (blood/skulls)
		2. scouts added
		
### Changed
- Changed Risen lord in assosiated .2da to correctly have 24 base str


## [2.2.1] - 2022-07-01

### Added
- area additions:
	- Winya Ravana
		1. Build amphitheater 
		3. start of guard house made
		2. continuation of winya's advancment and designe changes
	- Winya Ravana: Guard house
		1. Guard tower area finished and connected
	- Winya Ravana: crystal lake
		1. added/decorated last tree house guard 
		2. Finished stone guard tower and connected to interior
	- Winya Ravana: Libary
		1. plot update (added recoverd relic books, and shrine)
	- Amia forrest
		1. added 3 benches and 6 "sit" options at agreed location
	- Amia forrest: oakmist vale
		1. added apple tree at agreed location
	- Kingdom of Cetha: The Wave and Serpent ((ON TEST SERVER))
		1. added 2 npcs, 1 that eats job logs, 1 that can give all lycan and peerage feats
		
- various winya plot related things
- added npc to palette to add all lycan and peerage feats (for future test server deployment)
- added 8 scripts for adding peerage and lycan feats (and set correct variable for the latter)
- 44 Artist PLCs
- Start of new archiving system (not implemented yet)


### Changed
- area changes:
	- Winya Ravana
		1. remodeling/moving parts of winya to accomedate proggress

- 1 tailor plc change

### Fixed
- fixes to the deity falling system
- fixes to allowed and disallowed deity's for 
- jewler in bendir caves has its head back 
- Lycan shapes now merge unwerwaterbreathing gear properly


## [2.2.0] - 2022-06-25
 
### Added
- area changes:
	- Winya Ravana: Crystal Lake
		1. added/decorated 3 watchtowers (2 tree houses 1 stone) at plot agreed locations (part of the guard tower update for area)
		2. added gaurds to said watchtowers
	- Winya Ravana: Guard house (currently named winya_gaurd)
		1. Created area, will contain the armetora/guard building of winya, aswell as minor secontary buiuldings like interior guard tower
		2. created base for interior guard tower (under unfinished for now)
- 39 Artist PLCs
- Added a QoL for devs
- added Gruffy bane of the job journals for easy job journal removal
- added fr_take_item conversation

### Changed
- Changed all the BGH loot/drops (hides/furs/glands/bones etc) to have a value similare to other job items
- Satchel description to include small disclaimer
- Artic wolfs and their alpha variant now drop furs instead of hide

### Fixed
- fixed at the "boss" area in Hunting Prey in the Woods...  enlarged exit point, and added a birchtree+rope coil to make exit visible
- Made Victoria at the Kingdom of Cetha: Southport West, Interior stop taking of her robes
- made <c~Îë>Malnurished Orc</c> both versions for BHG mortal
- The fall widget should now properly make divine classes "fallen"and unable to cast
- large overhaul/fix for Divine casters to enforce proper deity/alignment/domain/nature (and mixing of these) for all divine casters

## [2.1.2] - 2022-06-21

### Added
- Plot Updates to Ultrinnan

### Fixed
- Added dune ramp so you can reach outside the "u"/reach resource node in Hunting Prey in the Desert...
- added 2 exit points and blocked of a unofficial exit at Hunting Prey in the Snow Mountains... "boss" area to prevent players getting stuck
- Hunter cooldown fixed: 10 minutes for Hunter Primary/Secondary, 60 minutes for untrained


## [2.1.1] - 2022-06-20

### Fixed
- Hunter cooldown logic reverted, cleaned up. Requires more testing
- "Hunting in a cave" area further tweaked to try and solve for invisible Grick
- Fixed a woopsie transition error in Winya Ravana: Sky Forest 


## [2.1.0] - 2022-06-19

### Added
- Updated tailor convo and converter script with new tags for the above
- Plot Updates to Ultrinnan

- area changes:
	- Winya Ravana 
		1. new racial gate with npcs to accomodate
		2. new npc (son of amilith) and connected him to AA shop
	- Winya Ravana: Sky Forest
		1. added/decorated 2 watchtowers (tree houses) at plot agreed locations
		2. added gaurds to said watchtowers
	- Winya Ravana: Burrows and Caverns
		1. created and added iounblaze (crystal dragon)
		2. created and added diamon guard golem
		3. added hoard of iounblaze
		
### Changed
- Removed old/obsolete PLCs (furs, old carpet, and old stuffed bat)
- Fur 1 > Hanging Fur
- Fur 2 > Vellum Map
- Fur 3 > Satchel (plc container)

- Area name changes"
	- Inland Hills: Sky Forest -> Winya Ravana: Sky Forest
	- Inland Hills: Crystal Lake -> Winya Ravana: Crystal Lake
	- Inland Hills: Burrows and Caverns -> Winya Ravana: Burrows and Caverns
	- Inland Hills: Dragon Haven -> Winya Ravana: Crystal Lake
	
### Fixed
- Fixed logic on hunter cooldown (swapped greater than)
- Messed around with cave hunter area to maybe fix visibility issue
- changed name of deity ring from Gwearon windstrom to gwaeron windstrom
- changed description on magical ingots and hemp and wood to contact dm to excange

## [2.0.0] - 2022-06-16
 
### Added
- This changelog
### Changed
### Fixed

