# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

### Changed

### Fixed
- Big Game Hunter: Large Wasps now have vermin immunities
- Big Game Hunter: Umber Hulks no longer sound like wolves, have chaos gaze



## [2.2.11] - 2022-09-16

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
- Operator Oleig has found an appreciation for Tyrannosaurus Hides
- Shadowdancer quest "UA: shadow affinity quest" For learning the Shadow affinity ability (widget)

### Changed
- OI Area updates
- OI Monster
- Path of Pain: The Path's self damage is too punitive and early levels are too punitive. To address this, the roundly incrementing self-damage now caps as follows:
	- Pain lv 1 = cap 10 dmg/round
	- Pain lv 2 = cap 15 dmg/round
	- Pain lv 3 = cap 20 dmg/round
	- Pain lv 4 = cap 25 dmg/round
	- Pain lv 5 = cap 25 dmg/round
- The Job Item Refresher will now accept old versions of Mythal Tubes, Bandage Bags, Gem Pouches, Trap Cases, Wand Cases, Scroll Holders, Backpacks, Scabbards, and Quivers
- Added icons for Backpacks, Scabbards, and Quiver to the hak
- Updated base items for Backpacks, Scabbards, and Quiver
- Plot updates to Cetha Festival Grounds
- Plot updates to Cetha West Gate

### Fixed
- Moonpier, given head back to <c Í >Ferdinando the Eccentric</c>
- Underdark lobsul, Zenati, removed default behavioral script in hopes he stops hiding
- Fixed the transition in Alambar Sea: Fortress Khuft
- Alchemist Elemental Resistance potions had incorrect descriptions
- Two Weapon Fighter: The AB bonus stacking blocked as intended. The AB bonus from same-sized weapons to emulate smaller weapons fixed from +4 AB to +2 AB as intended.
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

