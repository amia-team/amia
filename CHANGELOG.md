# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
## [Unreleased]

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
- Bottled Companion non player race (dynamic) models now also correctly can copy tails/wings if skin allows

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

