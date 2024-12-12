// Include file for the Amia module.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 12/08/2003 jpavelch         Initial Release.
// 04/23/2004 jpavelch         Moved DM and ADM lists to database.
// 04/25/2004 jpavelch         Added support for Amia NWNX2 plug-in.
// 20050307   jking            Removed that support; simpler is better
// 20050411   jking            Added back the AR_KillServer call
// 20050615   jking            Added SafeRemoveAllEffects
// 20051012   kfw              Disabled SEI, True Races compatibility
// 20051223   jking            Added AR_IsHighAdmin, fixed AR_IsAdmin to
//                             remove admin status token if re-checked in-game
//                             and the database changes.
// 20051231   kfw              SQLEncodeSpecialChars() for PC Player Names in SQL Query
// 20060612   kfw              Optimized Racial System refresh in SafeRemoveAllEffects() function.
// 20061001   kfw              Added a timestamp macro.
// 20061018   disco            Extended the timestamp functions
// 20061103   disco            Added party jump functions
// 20061103   disco            Added exploit log function
// 20061126   disco            Added some SQL entry checks
// 20070112   disco            Added two IP check functions
// 20070910   disco            Too many changes to mention...
// 20071009   disco            Added GetAmountPerLevels()
// 20071109   disco            Big update, exachanged a lot of functions with other libs
// 20071118   Disco            Using PCKEY now
// 20080215   Disco            Added utility_inc content
// 20080505   disco            Added TakeFeatUses
// 20080611   disco            Rewrote server reset routines
// 20080711   disco            Cleaned up unused functions, added Terra's time plugin
// 20080505   disco            Added GetIsSkillSuccessfulPrivate()
// 20080921   disco            Added GetItemByName()
// 20081130   disco            Added GetIsInsideTrigger and KillPC
// 2009/02/23 disco            Updated racial/class/area effects refresher
// 20090315   Terra            Unpossess familiars on reset to counter KillServer() getting stuck in a recursive loop
// 20090325   disco            added xp recording function
// 20090513   disco            updated CopyItem and CopyItemAndModify
// 2009-05-26 Disco            Added some anti exploit measures to GiveRewardToParty()
// 2009-01-04 Disco            Added GetIsCivilised()
// 2009-06-20 Disco            Updated FreezePC function
// 2011-03-16 Disco            Added GetPartyMemberWithLocalInt and GetPartyMemberWithLocalString
// 2012-03-04 PoS              Added HiPS nerf functionality.
// 2012-04-15 Mathias          Added GetBludgeoningWeapon and GetPiercingWeapon
// 2012-07-24 Glim             Added check to ds_drown to only affect PCs
// 2012-09-27 Glim             Added optional LocalInt to negate Light Sensativity in an area
// 2012-10-30 PoS              Added NewHoursToSeconds for day/night duration change

//-------------------------------------------------------------------------------
// constants
//-------------------------------------------------------------------------------
//const int RACE_TRAITS       = 850;
const int SPELL_THE_FALL    = 851;
const int SPELL_THE_RISE    = 852;
const int DEATH_EFFECTS     = 853;
const int SHOP_EFFECTS      = 854;
const int ULTRAVISION_ON    = 855;

const string HIPS_FLAG      = "HIPS_clearing";


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "aps_include"
#include "cs_inc_xp"
#include "inc_td_sysdata"
#include "inc_runtime_api"
#include "inc_module_vars"
//#include "inc_ds_j_lib"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


// Safely remove all effects on players.
void SafeRemoveAllEffects( object oPC );

//Without parameters it returns the current runtime (in seconds) of the module.
//With parameters it returns the future runtime (in seconds).
int GetRunTime( int nMinutes=0, int nSeconds=0 );

//Flags an object as blocked until nMinutes and nSecond have passed
//default: block for 5 minutes
void SetBlockTime( object oTarget=OBJECT_SELF, int nMinutes=5, int nSeconds=0, string sVariable="BlockUntil" );

//I have put this in a separate fucntion. Hope that counters some issues.
void CreateTimestamp( object oTarget, int nMinutes, int nSeconds, string sVariable );

//Returns remaining time if oTarget is flagged as blocked
int GetIsBlocked( object oTarget=OBJECT_SELF, string sVariable="BlockUntil" );

//checks if oObject is a partymember of oPC
int ds_check_partymember( object oPC, object oObject );

//transports oPC and all partymembers inside a the nearest trigger called "party_trigger" to sWaypoint
void ds_transport_party( object oPC, string sWaypoint );

//logs possible exploit
void log_exploit( object oPC, object oArea, string sType );

//logs possible exploit, flexible version
//if oPC is a PC/DM it logs name, account, cdkey.
//If oPC is something else it logs name, tag, resref
//you can use sType, SString, and nInt for your own tracking pleasure
void log_to_exploits( object oPC, string sType, string sString="" , int nInt=0 );

//logs data into the item tracker
void TrackItems( object oPC, object oTarget, string sItemName, string sAction );

//returns catergory of the item (ie: long sword, large shield, ring)
string GetItemBaseTypeName( object oItem );

//Calculates this: nResult = nAmount per nStep levels if you have nLevels.
//Maximum is nCap. nCap == 0 ignores the cap and nStep == 1 gives nAmount/level.
//Example: +1 Dodge AC/8 levels, max of +3
int GetAmountPerLevels( int nLevels, int nAmount, int nStep=1, int nCap=0 );

//safe version of DestroyObject. Returns TRUE if the item was taken.
int ds_take_item( object oPC, string sTag );

//safe version of CreateItemOnObject; checks for doubles.
//give sTag if sTemplate isn't identical
void ds_create_item( string sTemplate, object oPC, int n=1, string sTag="" );

// Applies Light Blindness to a player character.
void ApplyLightBlindness( object oPC, object oArea );

// Applies Underwater effects to player.
void ApplyUnderwaterEffects( object oPC, object oArea );

//check for underwater items
//returns TRUE when an underwater item is equipped, or oPC cannot drown
int ds_check_uw_items ( object oPC );

//drowns oPC if necessary
void ds_drown( object oPC, float fInterval = 30.0 );

// use this function to create a creature that gets hooked into the despawn routines
// oPC is the person triggering the spawn
object ds_spawn_critter(  object oPC, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sTag="" );

// use this function to create a creature that gets hooked into the despawn routines
// oPC is the person triggering the spawn
void ds_spawn_critter_void(  object oPC, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sTag="" );

//gives gold and non-ECL corrected XP to party in area
void GiveRewardToParty( object oPC, int nXP, int nGP, string sTrackingVar );

//spawns a treasure chest in an encounter
//oOrigin is the spawnlocation
void SpawnTreasureChest( object oOrigin, object oMonster );

//cleanup oTarget, including inventory
void SafeDestroyObject( object oTarget );

// Sends a message to all players currently logged in.
void SendMessageToAllPCs( string sMessage );

// Returns TRUE if a player has a polymorph effect.
int GetIsPolymorphed( object oPC );

// Exports a single player if it is not polymorphed.
void AR_ExportPlayer( object oPC );

// Exports all players on the server.
void AR_ExportPlayers( );

//saves and boots players
//starts KillServer
void SaveBootPlayers( );

//saves and boots player
void SaveBootPlayer( object oPC, string sRef );

// Shuts down the Amia Server.
void KillServer( );

//remove all effects placed on oPC by nSpell
int RemoveEffectsBySpell( object oPC, int nSpell );

//returns true if item is a weapon
int GetIsWeapon( object oItem );

//takes uses of the feat and returns TRUE if there were enough uses
//returns false and keeps remaining uses if not
int TakeFeatUses( object oPC, int nFeat, int nUses );

//creates and deletes item without returning a value. Handy for delays.
void CreateObjectVoid( int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="", float fDestroyTime=0.0 );

//freezes oPC for fDuration seconds and sends him sMessage.
void FreezePC( object oPC, float fDuration, string sMessage="" );

//combines light blindness, underwater effects, and racial effects in one package
//also strips previous applications
// nDarkness == 0 for normal situations
// nDarkness == 1 when you enter a Darness globe
// nDarkness == 2 when you exit one
void ApplyAreaAndRaceEffects( object oPC, int nApplyTraits=0, int nDarkness=0 );

//GetIsSkillSuccessful() without feedback
int GetIsSkillSuccessfulPrivate( object oTarget, int nSkill, int nDifficulty );

//returns oPC's alignment in CE,NE,LG format
string GetAlignmentString( object oPC );

//Returns item called sName in oPC's inventory
object GetItemByName( object oPC, string sName );

//checks if oPC is inside a trigger
int GetIsInsideTrigger( object oPC, string sTriggerTag );

//no bullshit killing, 10000 magical damage.
void KillPC( object oPC );

//adds nValue to the current value of sVariable
void UpdateModuleVariable( string sVariable, int nValue );

//works like CopyObject but properly copies non-default description as well
object CopyObjectFixed( object oSource, location lLocation, object oOwner = OBJECT_INVALID, string sNewTag = "");

//works like CopyItem but properly copies non-default description as well
object CopyItemFixed( object oItem, object oTargetInventory=OBJECT_INVALID, int bCopyVars = FALSE );

//works like CopyItemAndModify but properly copies non-default description as well
object CopyItemAndModifyFixed( object oItem, int nType, int nIndex, int nNewValue, int bCopyVars = FALSE );

//checks if oCreature is somewhat civilised
//this includes PCs, humanoids, dragons etc
//use biped to make sure you only get humanoids
//oCreature must have at least 6 intelligence
int GetIsCivilised( object oCreature, int nMustBeBiped=FALSE );

//upgraded version from itemprops
//returns the weapon equiped by oTarget or oTarget if it is a weapon
object GetWeapon( object oTarget );

//checks if oCaster is able to cast epic spells
int GetCanCastEpicSpells( object oCaster );

//Clears all effects made by a object possessing sTag
void ClearEffectMadeByObjectWithTag( object oTarget, string sTag );

//This function returns the party member which has the value of the local
//  variable sKey set to any integer but 0
//If you set nValue the local value must be equal to it as well
//Set nInArea to 1 if you only want to check partymembers in the same area
object GetPartyMemberWithLocalInt( object oPC, string sKey, int nValue=0, int nInArea=0 );


//This function returns the party member which has the value of the local
//  variable sKey set to any string
//If you set sValue the local value must be equal to it as well
//Set nInArea to 1 if you only want to check partymembers in the same area
object GetPartyMemberWithLocalString( object oPC, string sKey, string sValue="", int nInArea=0 );

//I guess this one's pretty clear?
object GetFirstObjectInAreaByTag( object oArea, string sTag );

// Returns TRUE if the weapon is a bludgeoning weapon.
int GetBludgeoningWeapon( object oItem );

// Returns TRUE if the weapon is a piercing weapon.
int GetPiercingWeapon( object oItem );

// Converts nTime into a number of seconds
float NewHoursToSeconds( int nTime );

//------------------------------------------------------------------------------
// Functions
//------------------------------------------------------------------------------

void ClearEffectMadeByObjectWithTag( object oTarget, string sTag ){

    effect eEffect = GetFirstEffect( oTarget );
    while( GetIsEffectValid( eEffect ) ){

        if( GetTag( GetEffectCreator( eEffect ) ) == sTag )
            RemoveEffect( oTarget, eEffect );


        eEffect = GetNextEffect( oTarget );
    }
}

// Safely remove all effects on a player
void SafeRemoveAllEffects( object oPC ){

    effect eEffect = GetFirstEffect( oPC );

    while ( GetIsEffectValid(eEffect) ) {
        // Skip unyielding effects
        if ( GetEffectSubType ( eEffect ) == SUBTYPE_UNYIELDING ) continue;
        if ( GetEffectSubType( eEffect ) != SUBTYPE_SUPERNATURAL )
        {

            //remove if it isn't a custom spell effect
            if ( GetName( GetEffectCreator( eEffect ) ) != "ds_norestore" ){

                RemoveEffect( oPC, eEffect );
            }
        }

        eEffect = GetNextEffect( oPC );
    }

    if ( GetIsPC( oPC ) ){

        // Refresh Amia's Racial System.
        ApplyAreaAndRaceEffects( oPC );
    }
}

//Without parameters it returns the current runtime (in seconds) of the module.
//With parameters it returns the future runtime (in seconds).
int GetLegacyRunTime( int nMinutes=0, int nSeconds=0 ){

    //get starttime in seconds
    int nTimestamp = GetServerRunTime( );

    if ( !nTimestamp ){

        SendMessageToAllDMs( "WARNING: COULD NOT RETRIEVE SERVER RUNTIME!" );
    }

    return nTimestamp + ( 60 * nMinutes ) + nSeconds;
}

//Flags an object as blocked until nMinutes and nSecond have passed
//default: block for 5 minutes
void SetBlockTime( object oTarget=OBJECT_SELF, int nMinutes=5, int nSeconds=0, string sVariable="BlockUntil" ){

    //debug... something isn't really working well with the plugin
    //I do a quick block right away, which I override with the (probably delayed) runtime
    //debug... something isn't really working well with the time plugin
    SetLocalInt( OBJECT_SELF, "QuickBlock", 1 );
    DelayCommand( 1.0, DeleteLocalInt( OBJECT_SELF, "QuickBlock" ) );

    DelayCommand( 0.0, CreateTimestamp( oTarget, nMinutes, nSeconds, sVariable ) );
}

//I have put this in a separate fucntion. Hope that counters some issues.
void CreateTimestamp( object oTarget, int nMinutes, int nSeconds, string sVariable ){

    int nDelayTimestamp = GetRunTime( nMinutes, nSeconds );

    SetLocalInt( oTarget, sVariable, nDelayTimestamp );
}

//Returns remaining time if oTarget is flagged as blocked
int GetIsBlocked( object oTarget=OBJECT_SELF, string sVariable="BlockUntil" ){

    //debug... something isn't really working well with the plugin
    //I do a quick block right away, which I override with the (probably delayed) runtime
    //99999 secs is over a day, which should exceed one session
    if ( GetLocalInt( OBJECT_SELF, "QuickBlock" ) == 1 ){

        return 1;
    }

    int nBlockUntil  = GetLocalInt( oTarget, sVariable );

    if ( nBlockUntil == 0 ){

        return 0;
    }

    int nRunTime  = GetRunTime();
    int nRemain   = nBlockUntil - nRunTime;

    if( nRemain < 0 ){

       SetLocalInt( OBJECT_SELF, sVariable, 0 );
       return 0;
    }

    return nRemain;
}

//transports oPC and all partymembers inside a the nearest trigger called "party_trigger" to sWaypoint
void ds_transport_party( object oPC, string sWaypoint ){

    object oDest    = GetWaypointByTag( sWaypoint );
    object oTrigger = GetNearestObjectByTag( "party_trigger" );
    object oObject  = GetFirstInPersistentObject( oTrigger );

    while ( GetIsObjectValid( oObject ) ) {

        if ( ds_check_partymember( oPC, oObject ) ) {

            if ( GetLocalInt( oPC, "tester" ) == 1 ){

                SendMessageToPC( oPC,  GetName( oPC )+" selected for transport." );
            }

            AssignCommand( oObject, ClearAllActions( TRUE ) );
            AssignCommand( oObject, ActionJumpToObject( oDest, FALSE ) );
        }

        oObject = GetNextInPersistentObject( oTrigger );
    }
}

//checks if oObject is a partymember of oPC
int ds_check_partymember( object oPC, object oObject ){

    object PCtoCheck;

    if ( oPC == oObject ){

        //you're always a member of your own party
        return TRUE;
    }

    if ( GetIsPC( oObject ) ) {

        PCtoCheck = oObject;
    }
    else if ( GetIsPossessedFamiliar( oObject ) ){

        //we want to check for familiars and such
        PCtoCheck = GetMaster( oObject );
    }

    else {

        return FALSE;
    }

    object oPartyMember = GetFirstFactionMember(oPC, TRUE );

    while( GetIsObjectValid( oPartyMember ) == TRUE ){

        if( oPartyMember == PCtoCheck ){

            return TRUE;
        }

        oPartyMember = GetNextFactionMember( oPC, TRUE );
    }

    return FALSE;
}

void log_exploit( object oPC, object oArea, string sType ){

    if ( !GetIsObjectValid( oPC ) ){

        return;
    }

    string sQuery;

    if ( GetIsPC( oPC ) == FALSE ){
        sQuery = "INSERT INTO exploits  VALUES ( NULL, '"
                        +sType+"', '"
                        +SQLEncodeSpecialChars( GetPCPlayerName(oPC) )+"', '"
                        +SQLEncodeSpecialChars( GetName(GetMaster(oPC) ) )+"', '"
                        +GetPCPublicCDKey(oPC)+"', "
                        +IntToString(GetGold(GetMaster(oPC)))+", '"
                        +SQLEncodeSpecialChars( GetName(oArea) )+"', NOW() )";
    }
    else {

        sQuery = "INSERT INTO exploits  VALUES ( NULL, '"
                        +sType+"', '"
                        +SQLEncodeSpecialChars( GetPCPlayerName(oPC) )+"', '"
                        +SQLEncodeSpecialChars( GetName(oPC) )+"', '"
                        +GetPCPublicCDKey(oPC)+"', "
                        +IntToString(GetGold(oPC))+", '"
                        +SQLEncodeSpecialChars( GetName(oArea) )+"', NOW() )";
    }

    SQLExecDirect( sQuery );
}

void log_to_exploits( object oPC, string sType, string sString="" , int nInt=0 ){

    string sQuery;

    sType   = GetStringLeft( sType, 50 );
    sString = GetStringLeft( sString, 50 );

    if ( GetIsPC( oPC ) || GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

       sQuery = "INSERT INTO exploits  VALUES ( NULL, '"
                +SQLEncodeSpecialChars( sType )+"', '"
                +SQLEncodeSpecialChars( GetPCPlayerName(oPC) )+"', '"
                +SQLEncodeSpecialChars( GetName(oPC) )+"', '"
                +GetPCPublicCDKey(oPC)+"', "
                +SQLEncodeSpecialChars( IntToString(nInt) )+", '"
                +SQLEncodeSpecialChars(  sString )+"', NOW() )";
    }
    else{

       sQuery = "INSERT INTO exploits  VALUES ( NULL, '"
                +SQLEncodeSpecialChars( sType )+"', '"
                +GetTag(oPC)+"/"+GetResRef(oPC)+"', '"
                +SQLEncodeSpecialChars( GetName(oPC) )+"', '"
                +"n.a.', "
                +SQLEncodeSpecialChars( IntToString(nInt) )+", '"
                +SQLEncodeSpecialChars(  sString )+"', NOW() )";
    }

    //execute query
    SQLExecDirect( sQuery );
}

void TrackItems( object oPC, object oTarget, string sItemName, string sAction ){

    object oArea = GetArea(oPC);
    //I prefer a key/value match when using INSERT
    string sKeys = "id,user_login, user_character, target_login, target_character,item_name,item_action,area_name,area_playercount,date";

    //get the right values to store into the database
    //broken up for ease of reading
    string sValues = "'" + SQLEncodeSpecialChars( GetPCPlayerName( oPC ) )
                 + "','" + SQLEncodeSpecialChars( GetName( oPC ) )
                 + "','" + SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) )
                 + "','" + SQLEncodeSpecialChars( GetName( oTarget ) )
                 + "','" + SQLEncodeSpecialChars( sItemName )
                 + "','" + SQLEncodeSpecialChars( sAction )
                 + "','" + SQLEncodeSpecialChars( GetName( oArea ) )
                 + "',"  + IntToString( GetLocalInt( oArea, "PlayerCount" ) );
    //collate parts into one query
    //The index 'id' is automatically updated by MySQL, hence the NULL value
    //NOW() is an SQL function that inserts the current data and time in a field
    string sQuery = "INSERT INTO item_tracking (" + sKeys + ") VALUES (NULL," + sValues + ", NOW())";

    //execute query
    SQLExecDirect( sQuery );
}

// Returns the name of a base type for an item.
string GetItemBaseTypeName( object oItem ){

    int nType = GetBaseItemType( oItem );
    switch ( nType ) {
        case BASE_ITEM_AMULET:          return "an amulet";           break;
        case BASE_ITEM_ARMOR:           return "a set of armor";      break;
        case BASE_ITEM_ARROW:           return "some arrows";         break;
        case BASE_ITEM_BASTARDSWORD:    return "a bastard sword";     break;
        case BASE_ITEM_BATTLEAXE:       return "a battle axe";        break;
        case BASE_ITEM_BELT:            return "a belt";              break;
        case BASE_ITEM_BLANK_POTION:    return "a blank potion";      break;
        case BASE_ITEM_BLANK_SCROLL:    return "a blank scroll";      break;
        case BASE_ITEM_BLANK_WAND:      return "a blank wand";        break;
        case BASE_ITEM_BOLT:            return "some bolts";          break;
        case BASE_ITEM_BOOK:            return "a book";              break;
        case BASE_ITEM_BOOTS:           return "a pair of boots";     break;
        case BASE_ITEM_BRACER:          return "a set of bracers";    break;
        case BASE_ITEM_BULLET:          return "some bullets";        break;
        case BASE_ITEM_CBLUDGWEAPON:    return "a creature item";     break;
        case BASE_ITEM_CLOAK:           return "a cloak";             break;
        case BASE_ITEM_CLUB:            return "a club";              break;
        case BASE_ITEM_CPIERCWEAPON:    return "a creature claw";     break;
        case BASE_ITEM_CRAFTMATERIALMED: return "a misc crafting item";   break;
        case BASE_ITEM_CRAFTMATERIALSML: return "a misc crafting item";   break;
        case BASE_ITEM_CREATUREITEM:    return "a creature item";     break;
        case BASE_ITEM_CSLASHWEAPON:    return "a creature claw";     break;
        case BASE_ITEM_CSLSHPRCWEAP:    return "a creature item";     break;
        case BASE_ITEM_DAGGER:          return "a dagger";            break;
        case BASE_ITEM_DART:            return "some darts";          break;
        case BASE_ITEM_DIREMACE:        return "a dire mace";         break;
        case BASE_ITEM_DOUBLEAXE:       return "a double axe";        break;
        case BASE_ITEM_DWARVENWARAXE:   return "a dwarven axe";       break;
        case BASE_ITEM_ENCHANTED_POTION: return "an enchanted potion"; break;
        case BASE_ITEM_ENCHANTED_SCROLL: return "an enchanted scroll"; break;
        case BASE_ITEM_ENCHANTED_WAND:  return "an enchanted wand";    break;
        case BASE_ITEM_GEM:             return "a gem";               break;
        case BASE_ITEM_GLOVES:          return "a set of gloves";     break;
//      case BASE_ITEM_GOLD:
        case BASE_ITEM_GREATAXE:        return "a great axe";         break;
        case BASE_ITEM_GREATSWORD:      return "a great sword";       break;
        case BASE_ITEM_GRENADE:         return "a grenade";            break;
        case BASE_ITEM_HALBERD:         return "a halberd";           break;
        case BASE_ITEM_HANDAXE:         return "a hand axe";          break;
        case BASE_ITEM_HEALERSKIT:      return "a heal kit";          break;
        case BASE_ITEM_HEAVYCROSSBOW:   return "a heavy crossbow";    break;
        case BASE_ITEM_HEAVYFLAIL:      return "a heavy flail";       break;
        case BASE_ITEM_HELMET:          return "a helm";              break;
//      case BASE_ITEM_INVALID:
        case BASE_ITEM_KAMA:            return "a kama";              break;
        case BASE_ITEM_KATANA:          return "a katana";            break;
        case BASE_ITEM_KEY:             return "a key";               break;
        case BASE_ITEM_KUKRI:           return "a kukri";             break;
        case BASE_ITEM_LARGEBOX:        return "a large box";         break;
        case BASE_ITEM_LARGESHIELD:     return "a large shield";      break;
        case BASE_ITEM_LIGHTCROSSBOW:   return "a light crossbow";    break;
        case BASE_ITEM_LIGHTFLAIL:      return "a light flail";       break;
        case BASE_ITEM_LIGHTHAMMER:     return "a light hammer";      break;
        case BASE_ITEM_LIGHTMACE:       return "a light mace";        break;
        case BASE_ITEM_LONGBOW:         return "a long bow";          break;
        case BASE_ITEM_LONGSWORD:       return "a long sword";        break;
        case BASE_ITEM_MAGICROD:        return "a magic rod";         break;
        case BASE_ITEM_MAGICSTAFF:      return "a magic staff";       break;
        case BASE_ITEM_MAGICWAND:       return "a magic wand";        break;
        case BASE_ITEM_MISCLARGE:       return "a misc item";         break;
        case BASE_ITEM_MISCMEDIUM:      return "a misc item";         break;
        case BASE_ITEM_MISCSMALL:       return "a misc item";         break;
        case BASE_ITEM_MISCTALL:        return "a misc item";         break;
        case BASE_ITEM_MISCTHIN:        return "a misc item";         break;
        case BASE_ITEM_MISCWIDE:        return "a misc item";         break;
        case BASE_ITEM_MORNINGSTAR:     return "a morning star";      break;
        case BASE_ITEM_POTIONS:         return "a magic potion";      break;
        case BASE_ITEM_QUARTERSTAFF:    return "a quarter staff";     break;
        case BASE_ITEM_RAPIER:          return "a rapier";            break;
        case BASE_ITEM_RING:            return "a ring";              break;
        case BASE_ITEM_SCIMITAR:        return "a scimitar";          break;
        case BASE_ITEM_SCROLL:          return "a scroll";            break;
        case BASE_ITEM_SCYTHE:          return "a scythe";            break;
        case BASE_ITEM_SHORTBOW:        return "a short bow";         break;
        case BASE_ITEM_SHORTSPEAR:      return "a spear";             break;
        case BASE_ITEM_SHORTSWORD:      return "a short sword";       break;
        case BASE_ITEM_SHURIKEN:        return "a shuriken";          break;
        case BASE_ITEM_SICKLE:          return "a sickle";            break;
        case BASE_ITEM_SLING:           return "a sling";             break;
        case BASE_ITEM_SMALLSHIELD:     return "a small shield";      break;
        case BASE_ITEM_SPELLSCROLL:     return "a spell scroll";      break;
        case BASE_ITEM_THIEVESTOOLS:    return "a thieves tool";      break;
        case BASE_ITEM_THROWINGAXE:     return "a throwing axe";      break;
        case BASE_ITEM_TORCH:           return "a torch";             break;
        case BASE_ITEM_TOWERSHIELD:     return "a tower shield";      break;
        case BASE_ITEM_TRAPKIT:         return "a trap kit";          break;
        case BASE_ITEM_TWOBLADEDSWORD:  return "a two-bladed sword";  break;
        case BASE_ITEM_WARHAMMER:       return "a war hammer";        break;
        case BASE_ITEM_WHIP:            return "a whip";              break;
    }

    return "an unidentified item";
}


int GetAmountPerLevels( int nLevels, int nAmount, int nStep=1, int nCap=0 ){

    int nResult = nAmount * ( 1 + ( ( nLevels - 1 ) / nStep ) );

    if ( nResult > nCap && nCap != 0 ){

        return nCap;
    }
    else{

        return nResult;
    }
}

int ds_take_item( object oPC, string sTag ){

    object oItemToTake;
    SetPlotFlag( oItemToTake, FALSE );
    oItemToTake = GetItemPossessedBy( oPC, sTag );

    if( GetIsObjectValid( oItemToTake ) !=  0 ){

        DestroyObject( oItemToTake );
        return TRUE;
    }

    return FALSE;
}

void ds_create_item( string sTemplate, object oPC, int n=1, string sTag="" ){

    if ( sTag == "" ){

        sTag = sTemplate;
    }

    object oItem = GetItemPossessedBy( oPC, sTag );

    if( oItem == OBJECT_INVALID ){

        CreateItemOnObject( sTemplate, oPC, n );
    }
}

// Applies Light Blindness to a player character.
void ApplyLightBlindness( object oPC, object oArea ){

    string szRace       = GetStringLowerCase( GetSubRace( oPC ) );

    //SendMessageToPC( oPC, "You are a "+szRace );

    // Check light sensitive races and apply light penalties accordingly.
    if( szRace == "drow" ||
        szRace == "kobold" ||
        szRace == "duergar" ||
        szRace == "shadow elf" ||
        szRace == "orog" ||
        GetLocalInt( oPC, "LightSensitive" ) == 1 ){

        SendMessageToPC( oPC, "You are light sensitive!" );

        // Outdoors and daylight.
        if( !GetIsAreaInterior( oArea )                         &&
            GetIsAreaAboveGround( oArea ) == AREA_ABOVEGROUND   &&
            GetIsDay( )                                         &&
            GetLocalInt( oArea, "CloudCover" ) == FALSE         &&
            GetLocalInt( oPC, "jj_darkness_domain" ) != TRUE ){

            // find the current time and set the duration
            // GetIsDay will return true between hour 7 and 18 (see advanced in module props)
            int nTime = 18-GetTimeHour();
            //This shouldnt happen because GetIsDay in previous statement
            if( nTime <= 0 )return;

            int nHour;
            int nDur;
            float fDur = HoursToSeconds( nTime );

//Debug Message
string sDur = IntToString( nTime );
string sHour = IntToString( GetTimeHour() );
SendMessageToPC( oPC, "Hour is "+sHour+", Sensitivity for "+sDur+" hours." );

            // effects.
            effect eAttackDecrease      = SupernaturalEffect( EffectAttackDecrease( 1 ) );
            effect eSearchPenalty       = SupernaturalEffect( EffectSkillDecrease( SKILL_SEARCH, 1 ) );
            effect eSpotPenalty         = SupernaturalEffect( EffectSkillDecrease( SKILL_SPOT, 1 ) );

            // Module :: Permanent Light Penalty
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eAttackDecrease, oPC, fDur );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSearchPenalty, oPC, fDur );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSpotPenalty, oPC, fDur );
        }
    }
}

void ApplyUnderwaterEffects( object oPC, object oArea ){

    if ( GetLocalInt( oArea, "underwater" ) == 1 && !GetLocalInt( oPC, "drowning" ) ){

        effect eBubbles  = SupernaturalEffect( EffectVisualEffect( VFX_DUR_BUBBLES ) );
        effect eImmunity = SupernaturalEffect( EffectDamageImmunityIncrease( DAMAGE_TYPE_FIRE, 50 ) );
        effect eWeakness = SupernaturalEffect( EffectDamageImmunityDecrease( DAMAGE_TYPE_ELECTRICAL, 50 ) );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eBubbles, oPC );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eImmunity, oPC );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eWeakness, oPC );

        SetLocalInt( oPC, "drowning", TRUE );

        DelayCommand( 30.0, ds_drown( oPC ) );
    }
}

int ds_check_uw_items ( object oPC ) {

    int nRace       = GetRacialType( oPC );
    string sSubRace = GetSubRace( oPC );

    if ( sSubRace == "Aquatic Elf" || sSubRace == "Air Genasi" || sSubRace == "Water Genasi" ){

        SendMessageToPC( oPC, "<c?  >Drown Test: "+sSubRace+" cannot drown."+"</c>" );
        return TRUE;
    }
    else if ( nRace == RACIAL_TYPE_CONSTRUCT || nRace == RACIAL_TYPE_UNDEAD || nRace == RACIAL_TYPE_ELEMENTAL ){

        SendMessageToPC( oPC, "<c?  >Drown Test: Elementals, Undead & Constructs cannot drown."+"</c>" );
        return TRUE;
    }
    else if ( GetLocalInt( oPC, "CannotDrown" ) == 1 && GetIsPolymorphed( oPC ) ){

        SendMessageToPC( oPC, "<c?  >Drown Test: Shifter with merged Underwater gear."+"</c>" );
        return TRUE;
    }


    int nSlot;
    object oItem;

    for ( nSlot=0; nSlot < NUM_INVENTORY_SLOTS; nSlot++ ){

        oItem    = GetItemInSlot( nSlot, oPC );

        if ( GetTag( oItem ) == "ds_underwater" ){

            SendMessageToPC( oPC, "<c?  >Drown Test: Underwater gear detected."+"</c>" );
            return TRUE;
        }
    }

    return FALSE;
}

void ds_drown( object oPC, float fInterval = 30.0 ){

    if ( GetLocalInt( GetArea( oPC ), "underwater" ) == 1 ){

        if ( GetIsPC( oPC ) == TRUE ){

            if ( ds_check_uw_items ( oPC ) ){

                SendMessageToPC( oPC, "<c?  >Drown Test: You are protected from drowning."+"</c>" );
                DelayCommand( fInterval, ds_drown( oPC ) );
            }
            else if ( FortitudeSave( oPC, 24 ) > 0 ){

                SendMessageToPC( oPC, "<c?  >Drown Test: Made Fort save"+"</c>" );
                DelayCommand( fInterval, ds_drown( oPC ) );
            }
            else{

                SendMessageToPC( oPC, "<c?  >Drown Test: Failed Fort save"+"</c>" );
                effect eDeath = EffectDeath();
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC );
            }
        }
    }
}

object ds_spawn_critter( object oPC, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sTag="" ){

    if ( sTag == "" ){

        sTag = GetResRef( GetAreaFromLocation( lLocation ) ) + "__" + sTemplate;
    }

    object oCreature = CreateObject( OBJECT_TYPE_CREATURE, sTemplate, lLocation, bUseAppearAnimation, sTag );

    //ai vars
    DelayCommand( 0.2, SetLocalObject( oCreature, "ds_ai_target", oPC ) );    //ds_ai_target is also used in ds_ai_

    // despawner.
    DelayCommand( 0.4, SetLocalInt( oCreature, "CS_DSPWN", 1 ) );
    DelayCommand( 600.0, ExecuteScript( "cs_monstr_despwn", oCreature ) );

    return oCreature;
}

void ds_spawn_critter_void( object oPC, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sTag="" ){

    if ( sTag == "" ){

        sTag = GetResRef( GetAreaFromLocation( lLocation ) ) + "__" + sTemplate;
    }

    object oCreature = CreateObject( OBJECT_TYPE_CREATURE, sTemplate, lLocation, bUseAppearAnimation, sTag );

    //ai vars
    DelayCommand( 0.2, SetLocalObject( oCreature, "ds_ai_target", oPC ) );    //ds_ai_target is also used in ds_ai_

    // despawner.
    DelayCommand( 1.0, SetLocalInt( oCreature, "CS_DSPWN", 1 ) );
    DelayCommand( 600.0, ExecuteScript( "cs_monstr_despwn", oCreature ) );

}

void GiveRewardToParty( object oPC, int nXP, int nGP, string sTrackingVar ){

    object oArea            = GetArea( oPC );
    object oMember          = GetFirstFactionMember( oPC, FALSE );
    int bHasPenalty         = FALSE;
    int nPCs                = 0;
    int nHenchmen           = 0;
    int nPartySize          = 0;
    float fCharLevel        = 0.0;
    float fLowLevel         = 1000.0;
    float fHighLevel        = -10.0;
    float fPartyLevel       = 0.0;
    float fLevelDiff        = 0.0;
    float fPenalty          = 0.15;

    while ( GetIsObjectValid( oMember ) ) {

        if ( GetArea( oMember ) == oArea && !GetIsDead( oMember ) ) {

            if ( GetMaster( oMember ) == OBJECT_INVALID ) {

                ++nPCs;

                fCharLevel  = GetLocalFloat( oMember, "CS_ECL" );

                fPartyLevel = fPartyLevel + fCharLevel;

                if ( fCharLevel < fLowLevel ) fLowLevel = fCharLevel;
                if ( fCharLevel > fHighLevel ) fHighLevel = fCharLevel;
            }
            else if ( GetIsPossessedFamiliar( oMember ) ){

                ++nPCs;

                fCharLevel  = GetLocalFloat( GetMaster( oMember ), "CS_ECL" );

                fPartyLevel = fPartyLevel + fCharLevel;

                if ( fCharLevel < fLowLevel ) fLowLevel = fCharLevel;
                if ( fCharLevel > fHighLevel ) fHighLevel = fCharLevel;
            }
            else {

                ++nHenchmen;
            }
        }

        oMember = GetNextFactionMember( oPC, FALSE );
    }

    //get average party level
    if ( nPCs > 0 ){

        fPartyLevel = fPartyLevel / nPCs;
    }
    else{

        SendMessageToPC( oPC, "It appears that your party has 0 members. This must be some bug. Squash it!" );
        return;
    }

    //check if party meets criteria
    fLevelDiff = fHighLevel - fLowLevel;
    nPartySize = nPCs + nHenchmen;

    if ( fLevelDiff > 5.0 ){
        bHasPenalty = TRUE;
        fPenalty = ( FloatToInt(fLevelDiff) / 5 ) * fPenalty ;
        if( fLevelDiff > 25.0 ) {
            fPenalty = 0.80;
        }
    }

    oMember      = GetFirstFactionMember( oPC );

    while ( GetIsObjectValid( oMember ) ) {

        if ( GetArea( oMember ) == oArea && !GetIsDead( oMember ) ) {

            if( bHasPenalty ) nXP = nXP - ( FloatToInt( nXP * fPenalty ) );
            if ( nXP < 1 ) nXP = 1;
            GiveCorrectedXP( oMember, nXP, sTrackingVar );
            GiveGoldToCreature( oMember, nGP );
        }

        oMember = GetNextFactionMember( oPC );
    }
}

void SpawnTreasureChest( object oOrigin, object oMonster ){

    // Variables.
    object oTreasureChest               = OBJECT_INVALID;
    int nTreasureChest                  = d100() == 5;

    // Regular spawn point valid.
    if( GetIsObjectValid( oOrigin ) ){

        // If applicable, spawn a treasure chest using the last spawned monster's CR.
        if( nTreasureChest && GetIsObjectValid( oMonster ) ){

            // Variables.
            float fMonsterCR            = GetChallengeRating( oMonster );

            // Treasure Chest CR is equal to 75% of the last monster's CR.
            int nTreasureChestCR        = FloatToInt( 0.75 * fMonsterCR );
            if( nTreasureChestCR > 40 )
                nTreasureChestCR = 40; // Cap the CR to prevent Uber Loot generation.

            // Treasure Chest Open Lock DC is equal to last monster's CR + 10 + 1d12
            int nTreasureChestDC        = FloatToInt( fMonsterCR ) + 10 + d12( );

            // Spawn the treasure chest.
            oTreasureChest = CreateObject( OBJECT_TYPE_PLACEABLE, "cs_treas_ches001", GetLocation( oOrigin ) );

            // Assign the CR to the treasure chest - Delayed because the object isn't spawned yet.
            DelayCommand( 0.1, SetLocalInt( oTreasureChest, "CR", nTreasureChestCR ) );

            // Assign the Open Lock DC to the treasure chest - Delayed because the object isn't spawned yet.
            DelayCommand( 0.2, SetLockUnlockDC( oTreasureChest, nTreasureChestDC ) );

            // Assign a Hardness to the treasure chest.
            DelayCommand( 0.3, SetHardness( d10( ), oTreasureChest ) );

            // Assign extra Hitpoints to the treasure chest.
            DelayCommand( 0.4, ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectTemporaryHitpoints( d20( ) ), oTreasureChest ) );

            // 50% chance to have a trap set on the treasure chest.
            if( d2( ) < 2 ){

                int nTrapType = 0;

                // Minor.
                if(         fMonsterCR >= 0.0 && fMonsterCR <= 10.0 ){
                    switch( d4( ) ){    case 1:     nTrapType = TRAP_BASE_TYPE_MINOR_HOLY;                  break;
                                        case 2:     nTrapType = TRAP_BASE_TYPE_MINOR_SONIC;                 break;
                                        case 3:     nTrapType = TRAP_BASE_TYPE_MINOR_TANGLE;                break;
                                        default:    nTrapType = TRAP_BASE_TYPE_MINOR_SPIKE;                 break;  }   }
                // Average.
                else if(    fMonsterCR > 10.0 && fMonsterCR <= 20.0 ){
                    switch( d4( ) ){    case 1:     nTrapType = TRAP_BASE_TYPE_AVERAGE_ELECTRICAL;          break;
                                        case 2:     nTrapType = TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH;         break;
                                        case 3:     nTrapType = TRAP_BASE_TYPE_AVERAGE_GAS;                 break;
                                        default:    nTrapType = TRAP_BASE_TYPE_AVERAGE_NEGATIVE;            break;  }   }
                // Strong.
                else if(    fMonsterCR > 20.0 && fMonsterCR <= 30.0 ){
                    switch( d4( ) ){    case 1:     nTrapType = TRAP_BASE_TYPE_STRONG_FROST;                break;
                                        case 2:     nTrapType = TRAP_BASE_TYPE_STRONG_SONIC;                break;
                                        case 3:     nTrapType = TRAP_BASE_TYPE_STRONG_HOLY;                 break;
                                        default:    nTrapType = TRAP_BASE_TYPE_STRONG_NEGATIVE;             break;  }   }
                // Deadly.
                else{
                    switch( d4( ) ){    case 1:     nTrapType = TRAP_BASE_TYPE_DEADLY_ACID_SPLASH;          break;
                                        case 2:     nTrapType = TRAP_BASE_TYPE_DEADLY_HOLY;                 break;
                                        case 3:     nTrapType = TRAP_BASE_TYPE_DEADLY_FIRE;                 break;
                                        default:    nTrapType = TRAP_BASE_TYPE_DEADLY_ELECTRICAL;           break;  }   }

                // Spawn the trap.
                DelayCommand( 0.5, CreateTrapOnObject( nTrapType, oTreasureChest ) );
            }

            // Candy: Put a yellow glow on the treasure chest - Delayed because the object isn't spawned yet.
            int nGlow = VFX_DUR_GLOW_BLUE;

            switch( d3( ) ){

                case 1:     nGlow = VFX_DUR_GLOW_PURPLE;    break;
                case 2:     nGlow = VFX_DUR_GLOW_RED;       break;
                default:    nGlow = VFX_DUR_GLOW_YELLOW;    break;
            }

            effect eGlow = ExtraordinaryEffect( EffectVisualEffect( nGlow ) );

            DelayCommand( 0.9, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGlow, oTreasureChest, 0.0 ) );

            // Automatically purge the chest in ~8 minutes.
            DelayCommand( 495.0, SafeDestroyObject( oTreasureChest ) );
            DestroyObject( oTreasureChest, 500.0 );

        }
    }

    return;
}

void SafeDestroyObject( object oTarget ){

    if ( oTarget != OBJECT_INVALID ){

        AssignCommand( oTarget, SetIsDestroyable( TRUE, FALSE, FALSE ) );

        SetPlotFlag( oTarget, FALSE );

        DestroyObject( oTarget, ( 1.0 ) );                                                                                                                                              object oItem = GetFirstItemInInventory( oTarget );

        while ( GetIsObjectValid( oItem ) == TRUE ){

            SetPlotFlag( oItem, FALSE );

            DestroyObject( oItem );

            oItem = GetNextItemInInventory( oTarget );
        }
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

// Sends a message to all players currently logged in.
//
void SendMessageToAllPCs( string sMessage )
{
    object oPC = GetFirstPC( );
    while ( GetIsPC(oPC) ) {
        SendMessageToPC( oPC, sMessage );
        oPC = GetNextPC( );
    }
}

// Returns TRUE if a player has a polymorph effect.
//
int GetIsPolymorphed( object oPC )
{
    effect eEffect = GetFirstEffect( oPC );
    while ( GetIsEffectValid(eEffect) ) {
        if ( GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH )
            return TRUE;

        eEffect = GetNextEffect( oPC );
    }

    return FALSE;
}

// Exports a single player if it is not polymorphed.
//
void AR_ExportPlayer( object oPC ){

    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ) {

        SendMessageToPC( oPC, "- DM Avatars cannot be saved. -" );
    }
    else if ( GetIsPolymorphed( oPC ) ) {

        SendMessageToPC( oPC, "- Polymorphed characters cannot be saved. -" );
    }
    else if ( GetIsResting( oPC ) ) {

        SendMessageToPC( oPC, "- Resting characters cannot be saved. -" );
    }
    else {

        ExportSingleCharacter( oPC );
        SendMessageToPC( oPC, "- Your character has been saved. -" );
    }
}

// We need to loop through manually and save non-polymorphed chars.  There is
// an issue with polymorphed attributes sticking when saving a char that is
// shifted/polymorphed.
void AR_ExportPlayers( ){

    //SendMessageToAllDMs( "Exporting Players..." );

    float fDelay = 0.0;

    object oPC = GetFirstPC( );

    while ( GetIsPC( oPC ) ) {

        DelayCommand( fDelay, AR_ExportPlayer(oPC) );
        fDelay += 0.2;

        oPC = GetNextPC( );
    }

    return;
}

void SaveBootPlayers( ){

    // Variables
    object oModule          = GetModule( );
    string sMessage         = "- Amia is closing down. Don't try to login until it is up again because you will be booted. -";
    string sRef;
    int i;

    //block new players
    SetLocalInt( oModule, "ds_closing", 1 );

    // Broadcast Amia Shutdown

    float fDelay = 5.0;

    object oPC = GetFirstPC( );
    object oMaster;

    WriteTimestampedLogEntry( "Booting "+GetName( oPC ) );

    while ( GetIsObjectValid( oPC ) ) {

        UnpossessFamiliar( oPC );

        //create check mechanism
        ++i;
        sRef = "pl_"+IntToString(i);
        SetLocalObject( oModule, sRef, oPC );

        //feedback
        SendMessageToPC( oPC, sMessage );

        //take away polies
        effect eLoop = GetFirstEffect( oPC );
        int nResult;

        while ( GetIsEffectValid( eLoop ) ){

            if ( GetEffectType( eLoop ) == EFFECT_TYPE_POLYMORPH ){

                RemoveEffect( oPC, eLoop );

                ++nResult;
            }

            eLoop = GetNextEffect(oPC);
        }

        //start removing people
        DelayCommand( fDelay, SaveBootPlayer( oPC, sRef ) );
        fDelay += 0.2;

        oPC = GetNextPC( );
    }

    fDelay += 5.0;

    DelayCommand( fDelay, KillServer( ) );

    return;
}

void SaveBootPlayer( object oPC, string sRef ){

    // Variables
    object oModule          = GetModule( );
    string sRef;

    if ( GetIsObjectValid( oPC ) ){

        AR_ExportPlayer( oPC );

        DelayCommand( 1.0, BootPC( oPC ) );
        DelayCommand( 1.5, DeleteLocalObject( oModule, sRef ) );
    }
}


// Shuts down the Amia Server
void KillServer( ){

    // Check if everybody is saved
    object oModule = GetModule( );
    object oPC;
    string sRef;
    int i;

    for ( i=1; i<100; ++i ){

        sRef = "pl_"+IntToString(i);
        oPC  = GetLocalObject( oModule, sRef );

        if ( GetIsObjectValid( oPC ) ){

            DelayCommand( 5.0, KillServer( ) );
            return;
        }
    }

    return;
}

int RemoveEffectsBySpell( object oPC, int nSpell ){

    effect eLoop = GetFirstEffect( oPC );
    int nResult;

    while ( GetIsEffectValid( eLoop ) ){

        if ( GetEffectSpellId( eLoop ) == nSpell ){

            RemoveEffect( oPC, eLoop );

            ++nResult;
        }

        eLoop = GetNextEffect(oPC);
    }

    return nResult;
}


int GetIsWeapon( object oItem ){

    int nType = GetBaseItemType( oItem );

    switch ( nType ) {

        case BASE_ITEM_BASTARDSWORD:    return TRUE;   break;
        case BASE_ITEM_BATTLEAXE:       return TRUE;   break;
        case BASE_ITEM_CLUB:            return TRUE;   break;
        case BASE_ITEM_DAGGER:          return TRUE;   break;
        case BASE_ITEM_DART:          return TRUE;   break;
        case BASE_ITEM_DIREMACE:        return TRUE;   break;
        case BASE_ITEM_DOUBLEAXE:       return TRUE;   break;
        case BASE_ITEM_DWARVENWARAXE:   return TRUE;   break;
        case BASE_ITEM_GREATAXE:        return TRUE;   break;
        case BASE_ITEM_GREATSWORD:      return TRUE;   break;
        case BASE_ITEM_HALBERD:         return TRUE;   break;
        case BASE_ITEM_HANDAXE:         return TRUE;   break;
        case BASE_ITEM_HEAVYCROSSBOW:   return TRUE;   break;
        case BASE_ITEM_HEAVYFLAIL:      return TRUE;   break;
        case BASE_ITEM_KAMA:            return TRUE;   break;
        case BASE_ITEM_KATANA:          return TRUE;   break;
        case BASE_ITEM_KUKRI:           return TRUE;   break;
        case BASE_ITEM_LIGHTCROSSBOW:   return TRUE;   break;
        case BASE_ITEM_LIGHTFLAIL:      return TRUE;   break;
        case BASE_ITEM_LIGHTHAMMER:     return TRUE;   break;
        case BASE_ITEM_LIGHTMACE:       return TRUE;   break;
        case BASE_ITEM_LONGBOW:         return TRUE;   break;
        case BASE_ITEM_LONGSWORD:       return TRUE;   break;
        case BASE_ITEM_MAGICSTAFF:      return TRUE;   break;
        case BASE_ITEM_MORNINGSTAR:     return TRUE;   break;
        case BASE_ITEM_QUARTERSTAFF:    return TRUE;   break;
        case BASE_ITEM_RAPIER:          return TRUE;   break;
        case BASE_ITEM_SCIMITAR:        return TRUE;   break;
        case BASE_ITEM_SCYTHE:          return TRUE;   break;
        case BASE_ITEM_SHORTBOW:        return TRUE;   break;
        case BASE_ITEM_SHORTSPEAR:      return TRUE;   break;
        case BASE_ITEM_SHORTSWORD:      return TRUE;   break;
        case BASE_ITEM_SHURIKEN:        return TRUE;   break;
        case BASE_ITEM_SICKLE:          return TRUE;   break;
        case BASE_ITEM_SLING:           return TRUE;   break;
        case BASE_ITEM_THROWINGAXE:     return TRUE;   break;
        case BASE_ITEM_TRIDENT:         return TRUE;   break;
        case BASE_ITEM_TWOBLADEDSWORD:  return TRUE;   break;
        case BASE_ITEM_WARHAMMER:       return TRUE;   break;
        case BASE_ITEM_WHIP:            return TRUE;   break;
    }

    return FALSE;
}


//takes uses of the feat and returns TRUE if there were enough uses
//returns false and keeps remaining uses if not
int TakeFeatUses( object oPC, int nFeat, int nUses ){

    int nCount;
    int i;

    while ( GetHasFeat( nFeat, oPC ) ){

        ++nCount;
        DecrementRemainingFeatUses( oPC, nFeat );

        if ( nCount == nUses ){

            SendMessageToPC( oPC, "Feat uses decremented." );

            return TRUE;
        }
    }


    SendMessageToPC( oPC, "Not enough feat uses left." );

    for ( i=0; i<nCount; ++i ){

        IncrementRemainingFeatUses( oPC, nFeat );
    }

    return FALSE;
}

void CreateObjectVoid( int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="", float fDestroyTime=0.0 ){

    object oObject = CreateObject( nObjectType, sTemplate, lLocation, bUseAppearAnimation, sNewTag );

    if ( fDestroyTime > 0.0 ){

        DestroyObject( oObject, fDestroyTime );
    }
}

void FreezePC( object oPC, float fDuration, string sMessage="" ){

    effect eFreeze = EffectCutsceneImmobilize();
    effect eVis    = EffectVisualEffect( VFX_DUR_PARALYZE_HOLD );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, fDuration );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oPC, fDuration );

    SetCommandable( FALSE, oPC );

    if ( sMessage != "" ){

        SendMessageToPC( oPC, "<c?  >"+sMessage+"</c>" );
    }
}

void ApplyAreaAndRaceEffects( object oPC, int nApplyTraits=0, int nDarkness=0 ){

    object oArea   = GetArea( oPC );
    effect eEffect = GetFirstEffect( oPC );
    object oCaster = GetLocalObject( GetModule(), "ds_areaeffects" );
    string sCasterTag;

    if ( nApplyTraits ){

        //remove a few immunities
        RemoveEffectsBySpell( oPC, SPELL_NEGATIVE_ENERGY_PROTECTION );
        RemoveEffectsBySpell( oPC, SPELL_UNDEATHS_ETERNAL_FOE );
    }

        // For Master Scout
    if( GetIsAreaNatural( oArea ) &&
        GetHasFeat( 1178, oPC ) == TRUE &&
        !GetLocalInt( oPC, "SCOUT_DASH_SET" ) ) {

        // effects.
        effect eSpeed       = EffectMovementSpeedIncrease( 10 );
        effect eLink        = EffectLinkEffects( eSpeed, eLink );

        eLink               = SupernaturalEffect( eLink );

        SetLocalInt( oPC, "SCOUT_DASH_SET", 1 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
    }
    else if( !GetIsAreaNatural( oArea ) &&
        GetHasFeat( 1178, oPC ) == TRUE &&
        GetLocalInt( oPC, "SCOUT_DASH_SET" ) == 1 ) {

        effect eEffects     = GetFirstEffect( oPC );
        /* Cycle the creature's effects and anything created by the PC
        and is affected by a saving throw penalty, remove it, and exit. */
        while( GetIsEffectValid( eEffects ) ) {
            if( GetEffectType( eEffects ) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE &&
                GetEffectSubType( eEffects ) == SUBTYPE_SUPERNATURAL )
            {
                // Dix.
                RemoveEffect( oPC, eEffects );
                DeleteLocalInt( oPC, "SCOUT_DASH_SET" );
                break;
            }

            eEffects = GetNextEffect( oPC );
        }
    }

    if( GetHasFeat( 1179, oPC ) == TRUE &&
        !GetLocalInt( oPC, "SCOUT_STRIDE_SET" ) ) {

        // effects.
        effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
        effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
        effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
        effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);

        //Link effects
        effect eLink = EffectLinkEffects(eParal, eEntangle);
        eLink = EffectLinkEffects(eLink, eSlow);
        eLink = EffectLinkEffects(eLink, eMove);

        eLink               = SupernaturalEffect( eLink );

        SetLocalInt( oPC, "SCOUT_STRIDE_SET", 1 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
    }

    if( !GetHasFeat( 1179, oPC ) == TRUE &&
        GetLocalInt( oPC, "SCOUT_STRIDE_SET" ) ) {

        effect eEffects     = GetFirstEffect( oPC );
        /* Cycle the creature's effects and anything created by the PC
        and is affected by a saving throw penalty, remove it, and exit. */
        while( GetIsEffectValid( eEffects ) ) {
            if( GetEffectType( eEffects ) == EFFECT_TYPE_IMMUNITY &&
                GetEffectSubType( eEffects ) == SUBTYPE_SUPERNATURAL &&
                GetEffectDurationType( eEffects ) == DURATION_TYPE_PERMANENT )
            {
                // Dix.
                RemoveEffect( oPC, eEffects );
                DeleteLocalInt( oPC, "SCOUT_STRIDE_SET" );
                break;
            }

            eEffects = GetNextEffect( oPC );
        }
    }

    //polymorph area retrigger fix
    if ( GetLocalInt( oArea, "underwater" ) != 1 ){

        SetLocalInt( oPC, "drowning", FALSE );
    }

    //Search for effects set by areas
    while ( GetIsEffectValid( eEffect ) ) {

        sCasterTag = GetTag( GetEffectCreator( eEffect ) );

        //remove custom spell effects
        if ( sCasterTag == "ds_areaeffects" ){

            RemoveEffect( oPC, eEffect );
        }
        else if ( nApplyTraits == 1 && sCasterTag == "ds_permeffects" ){

            RemoveEffect( oPC, eEffect );
        }

        eEffect = GetNextEffect( oPC );
    }

    if ( nApplyTraits ){

        oCaster = GetLocalObject( GetModule(), "ds_permeffects" );

        AssignCommand( oCaster, ApplyTraits( oPC ) );
    }

    oCaster = GetLocalObject( GetModule(), "ds_areaeffects" );

    AssignCommand( oCaster, ApplyUnderwaterEffects( oPC, oArea ) );

    if ( nDarkness != 1 ){

        AssignCommand( oCaster, ApplyLightBlindness( oPC, oArea ) );
    }
}

int GetIsSkillSuccessfulPrivate( object oTarget, int nSkill, int nDifficulty ){

    // Do the roll for the skill
    if ( GetSkillRank(nSkill, oTarget) + d20() >= nDifficulty ){

        // They passed the DC
        return TRUE;
    }

    // Failed the check
    return FALSE;
}

string GetAlignmentString( object oPC ){

    string sAlignmentName = "";

    int nAlignment = GetAlignmentLawChaos( oPC );

    if ( nAlignment == ALIGNMENT_CHAOTIC ) { sAlignmentName = "C"; }
    if ( nAlignment == ALIGNMENT_LAWFUL ) { sAlignmentName = "L"; }
    if ( nAlignment == ALIGNMENT_NEUTRAL ) { sAlignmentName = "N"; }

    nAlignment = GetAlignmentGoodEvil( oPC );

    if ( nAlignment == ALIGNMENT_EVIL ) { sAlignmentName += "E"; }
    if ( nAlignment == ALIGNMENT_GOOD ) { sAlignmentName += "G"; }
    if ( nAlignment == ALIGNMENT_NEUTRAL ) { sAlignmentName += "N"; }

    return sAlignmentName;
}


object GetItemByName( object oPC, string sName ){

    object oItem = GetFirstItemInInventory( oPC );

    while ( GetIsObjectValid( oItem ) ){

        if ( GetName( oItem ) == sName ){

            return oItem;
        }

        oItem = GetNextItemInInventory( oPC );
    }

    return OBJECT_INVALID;
}


//checks if oPC is inside a trigger
int GetIsInsideTrigger( object oPC, string sTriggerTag ){

    //beat up killer if area is guarded
    object oTrigger = GetNearestObjectByTag( sTriggerTag, oPC );

    if ( !GetIsObjectValid( oTrigger ) ){

        return FALSE;
    }

    object oObject  = GetFirstInPersistentObject( oTrigger );

    while ( GetIsObjectValid( oObject ) ) {

        if ( oPC == oObject ) {

            return TRUE;
        }

        oObject = GetNextInPersistentObject( oTrigger );
    }

    return FALSE;
}

void KillPC( object oPC ){

    effect eOuch = EffectDamage( 10000 );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eOuch, oPC );
}

void UpdateModuleVariable( string sVariable, int nValue ){

    object oModule = GetModule();

    SetLocalInt( oModule, sVariable, GetLocalInt( oModule, sVariable ) + nValue );
}

//works like CopyObject but properly copies non-default description as well
object CopyObjectFixed( object oItem, location lLocation, object oOwner = OBJECT_INVALID, string sNewTag = ""){

    string sDescription   = GetDescription( oItem, FALSE, FALSE );
    string sIDDescription = GetDescription( oItem, FALSE, TRUE );
    object oCopy          = CopyObject( oItem, lLocation, oOwner, sNewTag );

    SetDescription( oCopy, sDescription, FALSE );
    SetDescription( oCopy, sIDDescription, TRUE );

    return oCopy;
}
//works like CopyItem but properly copies non-default description as well
object CopyItemFixed( object oItem, object oTargetInventory=OBJECT_INVALID, int bCopyVars = FALSE ){

    string sDescription   = GetDescription( oItem, FALSE, FALSE );
    string sIDDescription = GetDescription( oItem, FALSE, TRUE );
    object oCopy          = CopyItem( oItem, oTargetInventory, bCopyVars );

    SetDescription( oCopy, sDescription, FALSE );
    SetDescription( oCopy, sIDDescription, TRUE );

    return oCopy;
}

//works like CopyItemAndModify but properly copies non-default description as well
object CopyItemAndModifyFixed( object oItem, int nType, int nIndex, int nNewValue, int bCopyVars = FALSE ){

    string sDescription   = GetDescription( oItem, FALSE, FALSE );
    string sIDDescription = GetDescription( oItem, FALSE, TRUE );
    object oCopy          = CopyItemAndModify( oItem, nType, nIndex, nNewValue, bCopyVars );

    SetDescription( oCopy, sDescription, FALSE );
    SetDescription( oCopy, sIDDescription, TRUE );

    return oCopy;
}

//checks if oCreature is somewhat civilised
//this includes PCs, humanoids, dragons etc
//use biped to make sure you only get humanoids
//oCreature must have at least 6 intelligence
int GetIsCivilised( object oCreature, int nMustBeBiped=FALSE ){

    if ( GetIsPC( oCreature ) ){

        return TRUE;
    }

    int nRace = GetRacialType( oCreature );
    int nInt  = GetAbilityScore( oCreature, ABILITY_INTELLIGENCE, TRUE );

    if ( nRace == RACIAL_TYPE_ANIMAL
      || nRace == RACIAL_TYPE_ABERRATION
      || nRace == RACIAL_TYPE_BEAST
      || nRace == RACIAL_TYPE_CONSTRUCT
      || nRace == RACIAL_TYPE_ELEMENTAL
      || nRace == RACIAL_TYPE_OOZE
      || nRace == RACIAL_TYPE_UNDEAD
      || nRace == RACIAL_TYPE_VERMIN ){

        return FALSE;
    }


    if ( nMustBeBiped ){

        if ( nRace == RACIAL_TYPE_DRAGON
          || nRace == RACIAL_TYPE_MAGICAL_BEAST ){

            return FALSE;
        }
    }

    if ( nRace == RACIAL_TYPE_DRAGON
      || nRace == RACIAL_TYPE_MAGICAL_BEAST
      || nRace == RACIAL_TYPE_HUMANOID_GOBLINOID
      || nRace == RACIAL_TYPE_HUMANOID_MONSTROUS
      || nRace == RACIAL_TYPE_HUMANOID_ORC
      || nRace == RACIAL_TYPE_HUMANOID_REPTILIAN
      || nRace == RACIAL_TYPE_OUTSIDER
      || nRace == RACIAL_TYPE_FEY
      || nRace == RACIAL_TYPE_GIANT
      || nRace == RACIAL_TYPE_SHAPECHANGER ){

        if ( nInt < 7 ){

            return FALSE;
        }
    }

    return TRUE;
}


object GetWeapon( object oTarget ){

    if ( !GetIsObjectValid( oTarget ) ){

        return OBJECT_INVALID;
    }

    if ( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ) {

        if ( IPGetIsMeleeWeapon( oTarget ) ){

            return oTarget;
        }
        else{

            return OBJECT_INVALID;
        }
    }

    object oWeapon = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oTarget );

    if ( GetIsObjectValid( oWeapon ) && IPGetIsMeleeWeapon( oWeapon ) ) {

        return oWeapon;
    }

    oWeapon = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oTarget );

    if ( GetIsObjectValid( oWeapon ) && IPGetIsMeleeWeapon( oWeapon ) ){

        return oWeapon;
    }

    oWeapon = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oTarget );

    if ( GetIsObjectValid( oWeapon ) ){

        return oWeapon;
    }

    oWeapon = GetItemInSlot( INVENTORY_SLOT_CWEAPON_B, oTarget );

    if ( GetIsObjectValid( oWeapon ) ){

        return oWeapon;
    }

    return OBJECT_INVALID;
}

int GetCanCastEpicSpells( object oCaster )
{
    if (!GetIsPC(oCaster)) return TRUE;
    int iChaCaster = GetLevelByClass(CLASS_TYPE_BARD, oCaster) +
                     GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
    int iIntCaster = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
    int iWisCaster = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) +
                     GetLevelByClass(CLASS_TYPE_DRUID, oCaster);
    if (iChaCaster > iIntCaster && iChaCaster > iWisCaster)
    {
        if (GetAbilityScore(oCaster, ABILITY_CHARISMA, TRUE) >= 20)
            return TRUE;
        else
            return FALSE;
    }
    if (iIntCaster > iWisCaster)
    {
        if (GetAbilityScore(oCaster, ABILITY_INTELLIGENCE, TRUE) >= 20)
            return TRUE;
        else
            return FALSE;
    }
    if (GetAbilityScore(oCaster, ABILITY_WISDOM, TRUE) >= 20)
        return TRUE;
    return FALSE;
}

object GetPartyMemberWithLocalInt( object oPC, string sKey, int nValue=0, int nInArea=0 ){

    object oPartyMember = GetFirstFactionMember( oPC, TRUE );
    object oArea        = GetArea( oPC );

    while( GetIsObjectValid( oPartyMember ) == TRUE ){

        if ( ( nInArea == 1 && GetArea( oPartyMember ) == oArea ) || nInArea == 0 ){

            if ( nValue != 0 ){

                if( GetLocalInt( oPartyMember, sKey ) == nValue ){

                    return oPartyMember;
                }
            }
            else{


                if( GetLocalInt( oPartyMember, sKey ) != 0 ){

                    return oPartyMember;
                }
            }
        }

        oPartyMember = GetNextFactionMember( oPC, TRUE );
    }

    return OBJECT_INVALID;
}

object GetPartyMemberWithLocalString( object oPC, string sKey, string sValue="", int nInArea=0 ){

    object oPartyMember = GetFirstFactionMember( oPC, TRUE );
    object oArea        = GetArea( oPC );

    while( GetIsObjectValid( oPartyMember ) == TRUE ){

        if ( ( nInArea == 1 && GetArea( oPartyMember ) == oArea ) || nInArea == 0 ){

            if ( sValue != "" ){

                if( GetLocalString( oPartyMember, sKey ) == sValue ){

                    return oPartyMember;
                }
            }
            else{


                if( GetLocalString( oPartyMember, sKey ) != "" ){

                    return oPartyMember;
                }
            }
        }

        oPartyMember = GetNextFactionMember( oPC, TRUE );
    }

    return OBJECT_INVALID;
}

object GetFirstObjectInAreaByTag( object oArea, string sTag ){

    object oObject = GetFirstObjectInArea( oArea );

    while ( GetIsObjectValid( oObject ) ){

        if ( GetTag( oObject ) == sTag ){

            return oObject;
        }

        oObject = GetNextObjectInArea();
    }

    return OBJECT_INVALID;
}

int GetBludgeoningWeapon( object oItem ) {

    // Variables.
    int nItem = GetBaseItemType( oItem );

    if ( ( nItem == BASE_ITEM_CLUB ) ||
      ( nItem == BASE_ITEM_LIGHTFLAIL ) ||
      ( nItem == BASE_ITEM_HEAVYFLAIL ) ||
      ( nItem == BASE_ITEM_LIGHTHAMMER ) ||
      ( nItem == BASE_ITEM_WARHAMMER ) ||
      ( nItem == BASE_ITEM_LIGHTMACE ) ||
      ( nItem == BASE_ITEM_DIREMACE ) ||
      ( nItem == BASE_ITEM_MAGICSTAFF ) ||
      ( nItem == BASE_ITEM_QUARTERSTAFF ) ||
      ( nItem == BASE_ITEM_MORNINGSTAR ) ||
      ( nItem == BASE_ITEM_SLING )||
      ( nItem == BASE_ITEM_CBLUDGWEAPON )
      ) {
        return TRUE;
   }
   return FALSE;
}

int GetPiercingWeapon( object oItem ) {

    // Variables.
    int nItem = GetBaseItemType( oItem );

    if ( ( nItem == BASE_ITEM_SHURIKEN ) ||
      ( nItem == BASE_ITEM_DART ) ||
      ( nItem == BASE_ITEM_HEAVYCROSSBOW ) ||
      ( nItem == BASE_ITEM_LIGHTCROSSBOW ) ||
      ( nItem == BASE_ITEM_LONGBOW ) ||
      ( nItem == BASE_ITEM_SHORTBOW ) ||
      ( nItem == BASE_ITEM_DAGGER ) ||
      ( nItem == BASE_ITEM_SHORTSWORD ) ||
      ( nItem == BASE_ITEM_SHORTSPEAR ) ||
      ( nItem == BASE_ITEM_CPIERCWEAPON ) ||
      ( nItem == BASE_ITEM_CSLSHPRCWEAP ) ||
      ( nItem == BASE_ITEM_MORNINGSTAR ) ||
      ( nItem == BASE_ITEM_HALBERD ) ||
      ( nItem == BASE_ITEM_SCYTHE )
      ) {
        return TRUE;
   }
   return FALSE;
}

float NewHoursToSeconds( int nTime )
{
    nTime = nTime * 120;

    return IntToFloat( nTime );
}
