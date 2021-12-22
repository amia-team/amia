// User-defined event constants used in Amia.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Initial Release.
// 01/01/2004 jpavelch         Added consts for PC area counting.
// 19/11/2007 disco            cleaned old constants
//

const int INITIALIZE = 2000;            // Initialize Something
const int HORROR_DOOR_OPEN = 2001;      // Open the door [maybe remove this one]
const int SPIRE_DOOR_GATEIN = 2002;     // Gates in Dark Spire door
const int SPIRE_DOOR_CREATED = 2003;    // Spire door has been created
const int GAUNTLET_SHOCKERDIED = 2010;  // Notifies area that shocker is dead
const int CORPSE_DESTROY = 2011;        // Tells corpse to destroy self
const int AREA_PCENTER = 2012;          // PC has entered an area
const int AREA_PCEXIT = 2013;           // PC has left an area
const int SHOCKER_DEATH = 2050;         // Gauntlet shocker

