# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [unreleased] - 

### Added

### Changed
- Endir's Point plot updates
- Naming for Job System PLC spawners has been fixed. **Please report any typos!**
- Changed "/s f_jsname" & "/s f_jsbio" to allow any Job System item to be customized
- Added "/s f_jsname" & "/s f_jsbio" details to every job log going forward

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

