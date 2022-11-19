//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: inc_ds_j_lib
//group: jobs
//used as: include
//date: 2009-02-9
//author: Disco

//-------------------------------------------------------------------------------
// changelog
//-------------------------------------------------------------------------------
// 03 Mar 2011  - Selmak moved int ds_j_GetTraderSlotsOccupied and added
//                 void ds_j_ClearJobLog (common job log clearing routine)
// 18 Jun 2011  - Selmak added support for cloned job system placeables in
//                 ds_j_InitialiseSource function.
// 07 Dec 2011  - Selmak changed ds_j_BuyResource to not add the GP value of
//                 items to the price.
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "inc_ds_crafting"

//-------------------------------------------------------------------------------
// constants
//-------------------------------------------------------------------------------

//init values
const int DS_J_LOW_POINTS           = 3;
const int DS_J_MED_POINTS           = 6;
const int DS_J_HIGH_POINTS          = 9;
const int DS_J_NONE_ID              = 0;
const int DS_J_LOW_ID               = 1;
const int DS_J_MED_ID               = 2;
const int DS_J_HIGH_ID              = 3;
const int DS_J_SOURCEDELAY          = 120;

const int nXPCooldown = 120;


//names
const string DS_J_INSTRUCTOR        = "Instructor";
const string DS_J_MERCHANT          = "Merchant";

//tags, resrefs
const string DS_J_JOURNAL           = "ds_j_journal";
const string DS_J_CHEST             = "ds_j_chest";
const string DS_J_TRAP              = "ds_j_trap";
const string DS_J_CROP              = "ds_j_crop";
const string DS_J_TREE              = "ds_j_tree";
const string DS_J_ORE               = "ds_j_ore";
const string DS_J_GEM               = "ds_j_gem";
const string DS_J_ALTAR             = "ds_j_altar";
const string DS_J_NPC               = "ds_j_npc";
const string DS_J_CRITTER           = "ds_j_critter";
const string DS_J_UNDEAD            = "ds_j_undead";
const string DS_J_JOB               = "ds_j_job";
const string DS_J_RESOURCE          = "ds_j_material";
const string DS_J_MAT_CACHE         = "ds_j_mat_storage";
const string DS_J_RES_CACHE         = "ds_j_res_storage";
const string DS_J_DESCR_CACHE       = "ds_j_descr_storage";
const string DS_J_CR_CACHE          = "ds_j_cr_storage";
const string DS_J_STOCK_CACHE       = "ds_j_stock_storage";
const string DS_J_CATEGORY          = "ds_j_category";
const string DS_J_TEMPLATES         = "ds_j_templates";
const string DS_J_BLOCK             = "ds_j_block";

//local variables, the actual variable names are kept short
const string DS_J_ID                = "ds_j_i";
const string DS_J_NAME              = "ds_j_n";
const string DS_J_RESREF            = "ds_j_r";
const string DS_J_CHANCE            = "ds_j_ch";
const string DS_J_PRICE             = "ds_j_pr";
const string DS_J_QUANTITY          = "ds_j_qnt";
const string DS_J_AVAILABILITY      = "ds_j_avbl";
const string DS_J_DONE              = "ds_j_done";
const string DS_J_INPUT1            = "ds_j_i1";
const string DS_J_INPUT2            = "ds_j_i2";
const string DS_J_USER              = "ds_j_u";
const string DS_J_TIME              = "ds_j_t";
const string DS_J_SPWNPTS           = "ds_j_s";
const string DS_J_AREA              = "ds_j_a";
const string DS_J_BUSY              = "ds_j_busy";
const string DS_J_DELETE            = "ds_j_del";
const string DS_J_LOW               = "low";
const string DS_J_MED               = "med";
const string DS_J_HIGH              = "high";
const string DS_J_RESOURCE_PREFIX   = "ds_j_res_";
const string DS_J_TITLE             = "ds_j_t_";
const string DS_J_MATERIAL_PREFIX   = "ds_j_mat_";
const string DS_J_TOTAL             = "ds_j_tt";
const string DS_J_CORPSES           = "ds_j_crp";
const string DS_J_TYPE              = "ds_j_tp";
const string DS_J_RANK3             = "ds_j_r3";
const string DS_J_TAUGHT_PREFIX     = "ds_j_ta_";
const string DS_J_BOWL              = "ds_j_bwl";
const string DS_J_MAT               = "ds_j_mat";
const string DS_J_ICON              = "ds_j_ic";
const string DS_J_CR_PREFIX         = "ds_j_cr_";
const string DS_J_VFX               = "ds_j_vfx";
const string DS_J_BUY               = "ds_j_b_";
const string DS_J_OBSERVE           = "ds_j_obs";
const string DS_J_SELLER            = "ds_j_sl";
const string DS_J_WEIGHT            = "ds_j_w_";
const string DS_J_FAILBONUS         = "ds_j_fb";
const string DS_J_LASTJOB           = "ds_j_lj";

//messages
const string DS_J_FAILURE           = "Bah. You failed to process this resource.";

//needs to go to a colour lib
const string CLR_ORANGE             = "<c�� >";
const string CLR_RED                = "<c�  >";
const string CLR_GRAY               = "<c���>";
const string CLR_BLUE               = "<c  �>";
const string CLR_END                = "</c>";

struct Multioptions {

    string sResRef;
    string sTemplate;
};

struct Storage {

    string sIndex;
    string sSlot;
    int nAmount;
    int nSlot;
};


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//returns resource id from item
int ds_j_GetResourceID( object oPC, object oItem );

//returns the rank oPC has in nJob
//DMs always get rank 3
int ds_j_GetJobRank( object oPC, int nJob );

//initialises job system
void ds_j_InitialiseSystems( object oModule );

//gets a random area based on oPC's level
//it corrects for ud/non-ud tasks on B
object ds_j_GetSpawnArea( object oPC );

//gets a random spawnpoint within an area
object ds_j_GetSpawnPoint( object oPC, object oArea );

//creates a target NPC in this area if needed
void ds_j_SpawnTarget( object oPC, object oArea );

//reads database lists and caches them on the trainer object
//this minimises database access
void ds_j_InitialiseTrainer( object oTrainer );

//reads database lists and caches them on the source object
//this minimises database access
int ds_j_InitialiseSource( object oSource );

//takes the PC and the Source that needs to produce items
//this function also checks if PC meets minimum hitdice for rank
//always returns 1 for a DM
//return values:
// -1: error (too little hitdice for rank)
//  0: fail
//  1: success
//  2: double success
int ds_j_StandardRoll( object oPC, int nJob );

//gives oPC standard XP, use nMod to multiply this amount
//returns job rank, you never know what it's good for :D
int ds_j_GiveStandardXP( object oPC, int nJob, int nResult, float fMod=1.0, float fDelay=0.0 );

//checks which target material is made from nSourceMaterial
//mind that alloys can be made of two components, so you need to check both
int ds_j_GetTargetResource( object oSource, int nInputResource, int nInput=1 );

//checks which source resource is needed to make nTargetResource
//mind that alloys can be made of two components, so you need to check both
int ds_j_GetInputResource( object oSource, int nTargetResource, int nInput=1 );

//creates an altar for the preacher's god
void ds_j_CreateAltar( object oPC, location lTarget  );

//destroys the altar when oPC is the creator
//makes oPC pray if he isn't
void ds_j_UseAltar( object oPC, object oAltar );

//does the (delayed) worship routine
void ds_j_Worship( object oPC, object oPriest, object oAltar );

//matches alignment of oPC with oAltar
//taken from the idol scripts
int ds_j_MatchAlignment( object oPC, object oAltar );

//returns alignment name
//taken from the idol scripts
string ds_j_GetAlignmentName( object oPC );

// Returns TRUE if object oBehind is located behind object oInFront as
// determined by the direction oInFront is facing.
int ds_j_GetIsBehind( object oInFront, object oBehind, float fMaxDistance=0.0 );

//immobilises PC
void ds_j_FreezePC( object oPC, float fDuration, string sMessage="" );

//caches resource names and prices
void ds_j_CacheResources( int nStart=1, int nEnd=100 );

//gets resource name from cache
string ds_j_GetResourceName( int nResource );

//gets resource description from cache
string ds_j_GetResourceDescription( int nResource );

//gets resource price from cache
int ds_j_GetResourcePrice( int nResource );

//gets resource material from cache
int ds_j_GetResourceMaterial( int nResource );

//gets resource weight from cache
int ds_j_GetResourceWeight( int nResource );

//caches resource stocks
void ds_j_CacheStock( string sModule );

//moves resource stocks from cache to database
void ds_j_FlushStock();

//gets stock amount for nResource from cache
int ds_j_GetStock( int nResource );

//sets stock amount for nResource in cache, returns current value
int ds_j_ChangeStock( int nResource, int nChange );

//caches material names and price modifiers
void ds_j_CacheMaterial();

//gets material name from cache
string ds_j_GetMaterialName( int nMaterial );

//gets material price from cache
int ds_j_GetMaterialPrice( int nMaterial );

//returns the type of material oItem is made of
//returns 0 if no material property can be found
int ds_j_GetMaterialFromItem( object oItem, int nSlot=1 );

//returns the quality of oItem
//returns 0 if no quality property can be found
int ds_j_GetQualityFromItem( object oItem );

//puts quality and material properties on item
void ds_j_AddMaterialProperties( object oPC, object oItem, int nMaterial1, int nRank, int nResult, int nMaterial2=0, int nNoCreator=0 );

//used by merchants to buy a single resource
void ds_j_BuyResource( object oPC, object oInventory, object oMerchant, object oItem, int nEvaluate=0, int nJob=0 );

//loops through merchant chest and calls ds_j_BuyResource for each valid item
void ds_j_BuyInventory( object oPC, object oInventory, object oMerchant, int nEvaluate=0, int nJob=0 );

//create a new item.
//if nIcon > 0 it will take sResref as an item in the template chest
//if sNewtag is given it will create a new tag on the item
object ds_j_CreateItemOnPC( object oPC, string sResRef, int nResource, string sName="", string sNewTag="", int nIcon=0 );

//this adds (and removes) jobs from a PC
void ds_j_TrainPC( object oPC, object oTrainer );

//you can only use one of the 6 ability boosters
int ds_j_CheckBoostJobs( object oPC, int nJob );

//writes chat channel onto items
void ds_j_Scribe( object oPC, string sMessage );

//creates a random job system gem on oPC
void ds_j_CreateRandomGemOnPC( object oPC );

//checks if the PLC contains two items that are suitable for copying
//returns > 1 if so and deals with the rest if nConvo == 1
//return values:
// 1 valid combination, color options, probably multiple parts
// 2 valid combination, no color options, simple model
int ds_j_CopyCheck( object oPC, object oPLC, string sPLCTag, int nJob, int nConvo=1 );

//acts like CopyItemAndModify, but returns result as well and deletes temp item
object ds_j_CopyReplaceItem( object oItem, int nType, int nIndex, int nNewValue );

//Completely clears the PC's job log
void ds_j_ClearJobLog( object oPC );

// Boolean. Checks whether the PC's trader slots are occupied by any resources.
int ds_j_GetTraderSlotsOccupied( object oPC );


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int ds_j_GetResourceID( object oPC, object oItem ){

    if ( !GetIsObjectValid( oItem ) ){

        //SendMessageToPC( oPC, CLR_RED+"There is no item in this object!" );

        return FALSE;
    }

    //quick first check. Only items that start with DS_J_RESOURCE_PREFIX can be used
    if ( FindSubString( GetTag( oItem ), DS_J_RESOURCE_PREFIX ) != 0 ){

        SendMessageToPC( oPC, "["+CLR_RED+GetName( oItem )+" is not processed by this object."+CLR_END+"]" );

        return FALSE;
    }

    return StringToInt( GetSubString( GetTag( oItem ), 9, 15 ) );
}

int ds_j_GetJobRank( object oPC, int nJob ){

    if ( GetIsDM( oPC ) ){

        return 3;
    }

    return GetPCKEYValue( oPC, DS_J_JOB+"_" + IntToString( nJob ) );
}


//also sets skyboxes!
void ds_j_InitialiseSystems( object oModule ){

    //-------------------------------------------
    //item templates
    //-------------------------------------------
    object oTemplates = GetObjectByTag( DS_J_TEMPLATES );


    SetLocalObject( oModule, DS_J_TEMPLATES, oTemplates );

    object oTemplate = GetFirstItemInInventory( oTemplates );

    while ( GetIsObjectValid( oTemplate ) ){

        SetLocalObject( oTemplates, GetResRef( oTemplate ), oTemplate );

        oTemplate = GetNextItemInInventory( oTemplates );

    }

    //-------------------------------------------
    //areas, skybox & temp cache
    //-------------------------------------------
    object oModule     = GetModule();
    object oAreaMarker = GetObjectByTag( "is_area" );
    object oArea       = GetArea( oAreaMarker );
    object oTempCache  = CreateObject( OBJECT_TYPE_WAYPOINT, "ds_storage", GetLocation( oAreaMarker ) );
    float fDelay;
    int i;


    while( GetIsObjectValid( oAreaMarker ) ){

        if ( GetObjectType( oAreaMarker ) == OBJECT_TYPE_WAYPOINT ){

            oArea = GetArea( oAreaMarker );

            if ( GetIsAreaInterior( oArea ) == FALSE &&
                 GetIsAreaAboveGround( oArea ) == AREA_ABOVEGROUND &&
                 GetSkyBox( oArea ) == SKYBOX_NONE ){

                fDelay = 1.0 + i/10.0;

                DelayCommand( fDelay, SetSkyBox( d4(), oArea ) );
            }

            SetLocalObject( oTempCache, GetResRef( oArea ), oArea );


            ++i;
            oAreaMarker = GetObjectByTag( "is_area", i );
            oArea       = GetArea( oAreaMarker );
        }
    }

    //-------------------------------------------
    //areas, cr cache
    //-------------------------------------------
    object oStorage         = CacheCache( DS_J_CR_CACHE );

    if ( !GetIsObjectValid( oStorage ) ){

        log_to_exploits( OBJECT_INVALID, "ds_j", "no cr cache!" );
    }

    string sModule = IntToString( GetLocalInt( oModule, "Module" ) );
    string sSQL    = "SELECT resref, cr FROM area_cr WHERE module="+sModule+" ORDER by cr";
    string sPrefix;
    int nCRgroup   = 0;
    string sKey;
    string sPrevKey;

    //reset previous counter
    i=0;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        nCRgroup = 1 + ( StringToInt( SQLGetData( 2 ) ) / 6 );

        if ( nCRgroup > 6 ) {

            nCRgroup = 6;
        }

        sKey     = DS_J_CR_PREFIX + IntToString( nCRgroup );

        //make sure counter resets for each CR group
        if ( sPrevKey != sKey && i != 0 ){

            //store number of areas within this group
            SetLocalInt( oStorage, sPrevKey, i );

            i=0;
        }

        //retrieve the area object from the temporary cache
        oArea = GetLocalObject( oTempCache, SQLGetData( 1 ) );

        if ( GetStringLeft( GetName( oArea ), 1 ) == " "
              || GetStringLeft( GetName( oArea ), 1 ) == "_" ) {

            //ignore, test or DM area
            WriteTimestampedLogEntry( "Ignoring DM area "+GetName( oArea ) );
        }
        else if ( GetLocalInt( oArea, DS_J_BLOCK ) ){

            WriteTimestampedLogEntry( "Ignoring blocked area "+GetName( oArea ) );
        }
        else if ( GetIsObjectValid( oArea ) ){

            ++i;

            //resref
            SetLocalObject( oStorage, sKey+"_"+IntToString(i), oArea );

        }
        else{

            WriteTimestampedLogEntry( "Can't find area object for "+SQLGetData( 1 )+" on "+sKey+"_"+IntToString(i) );
        }

        sPrevKey = sKey;
    }

    //store number of areas within last group
    SetLocalInt( oStorage, sKey, i );


    //-------------------------------------------
    //further caching
    //-------------------------------------------
    CacheCache( DS_J_RES_CACHE );
    DelayCommand( 0.2, ds_j_CacheResources( 1, 150 ) );
    DelayCommand( 0.4, ds_j_CacheResources( 151, 300 ) );
    DelayCommand( 0.6, ds_j_CacheResources( 301, 450 ) );
    DelayCommand( 0.8, ds_j_CacheResources( 451, 600 ) );
    DelayCommand( 1.0, ds_j_CacheMaterial() );
    DelayCommand( 1.2, ds_j_CacheStock( sModule ) );

    //-------------------------------------------
    //cleanup temp cache
    //-------------------------------------------
    DelayCommand( 1.0, DestroyObject( oTempCache ) );
}

object ds_j_GetSpawnArea( object oPC ){

    object oStorage = CacheCache( DS_J_CR_CACHE );

    int nCRgroup    = 1 + ( GetHitDice( oPC ) / 6 ); //should be ECL

    if ( nCRgroup > 1 ) {

        nCRgroup = nCRgroup + 1 - d2();
    }

    if ( nCRgroup > 5 ) {

        nCRgroup = 5;
    }

    string sCurrentArea = GetResRef( GetArea( oPC ) );
    int nIsUD;

    if ( GetStringLeft( sCurrentArea, 4 ) == "udb_" ){

        nIsUD = 1;
    }

    string sKey     = DS_J_CR_PREFIX + IntToString( nCRgroup );
    int nAreas      = GetLocalInt( oStorage, sKey );

    if ( nAreas > 0 ){

        int nArea    = 1 + Random( nAreas );
        object oArea = GetLocalObject( oStorage, sKey + "_" + IntToString( nArea ) );
        int i;

        for ( i=0; i<10; ++i ){

            if ( !nIsUD ){

                if ( GetStringLeft( GetResRef( oArea ), 4 ) != "udb_" ){

                    return oArea;
                }
            }
            else {

                if ( GetStringLeft( GetResRef( oArea ), 4 ) == "udb_" ){

                    return oArea;
                }
            }

            nArea = 1 + Random( nAreas );
            oArea = GetLocalObject( oStorage, sKey + "_" + IntToString( nArea ) );
        }

        return oArea;
    }

    return OBJECT_INVALID;
}

object ds_j_GetSpawnPoint( object oPC, object oArea ){

    string sTag        = "ds_spwn";
    int nSpawnpoints   = GetLocalInt( oArea, DS_J_SPWNPTS );
    object oAnchor     = GetFirstObjectInArea( oArea );
    object oSpawnpoint;

    if ( !GetIsObjectValid( oAnchor ) ){

        SendMessageToPC( oPC, CLR_RED+"ERROR! Can't find an anchor in "+GetName( oArea )+"!"+CLR_END );
        return OBJECT_INVALID;
    }

    if ( nSpawnpoints == 0 ){

        oSpawnpoint     = GetNearestObjectByTag( sTag, oAnchor );
        nSpawnpoints    = 1;

        if ( !GetIsObjectValid( oSpawnpoint ) ){

            SetLocalInt( oArea, DS_J_SPWNPTS, -1 );

            return OBJECT_INVALID;
        }

        while( GetIsObjectValid( oSpawnpoint ) ){

            ++nSpawnpoints;

            oSpawnpoint = GetNearestObjectByTag( sTag, oAnchor, nSpawnpoints );
        }

        //nSpawnpoints is one higher that the actual number after this loop
        --nSpawnpoints;

        SetLocalInt( oArea, DS_J_SPWNPTS, nSpawnpoints );
    }

    int nDie = 1 + Random( nSpawnpoints );

    return GetNearestObjectByTag( sTag, oAnchor, nDie );
}

void ds_j_SpawnTarget( object oPC, object oArea ){

    string sArea = GetLocalString( oPC, DS_J_AREA );

    if ( sArea != "" ){

        int nJob = GetLocalInt( oPC, DS_J_NPC );

        if ( ( nJob == 51 || nJob == 52 ) && FindSubString( GetName( oArea ), sArea ) > -1 ) {

            //archeologist and prospector
            SetLocalLocation( oPC, DS_J_AREA, GetLocation( oPC ) );

            SendMessageToPC( oPC, CLR_ORANGE+"Debug: You entered an area in the proper region."+CLR_END );
            return;
        }

        if ( GetResRef( oArea ) == sArea ){

            DeleteLocalString( oPC, DS_J_AREA );

            object oSpawnpoint = ds_j_GetSpawnPoint( oPC, oArea );
            object oTarget;

            if ( !GetIsObjectValid( oSpawnpoint ) ){

                SendMessageToPC( oPC, CLR_RED+"ERROR! Can't find a spawnpoint in "+GetName( oArea )+"!"+CLR_END );
                return;
            }

            if ( nJob == 35 || nJob == 36 || nJob == 37 || nJob == 50 ){

                //monsters
                oTarget = ds_spawn_critter( oPC, DS_J_CRITTER, GetLocation( oSpawnpoint ), FALSE, DS_J_CRITTER );
            }
            else if ( nJob == 40 || nJob == 42 ){

                //undead
                oTarget = ds_spawn_critter( oPC, DS_J_UNDEAD, GetLocation( oSpawnpoint ), FALSE, DS_J_UNDEAD );
            }
            else {

                //npc
                oTarget = ds_spawn_critter( oPC, DS_J_NPC, GetLocation( oSpawnpoint ), FALSE, DS_J_NPC );
            }

            SetName( oTarget, CLR_ORANGE + GetLocalString( oPC, DS_J_NPC ) + CLR_END );

            //feedback
            SendMessageToPC( oPC, CLR_ORANGE+"[Debug: Spawned "+GetName( oTarget )+" in "+GetName( GetArea( oTarget ) )+"]"+CLR_END );

            //log
            log_to_exploits( oPC, "ds_j: spawned NPC ("+GetTag( oTarget )+")", sArea, nJob );

            SetLocalString( oTarget, DS_J_USER, GetPCPublicCDKey( oPC, TRUE ) );
            SetLocalObject( oTarget, DS_J_USER, oPC );
            SetLocalInt( oTarget, DS_J_JOB, nJob );

            if ( nJob == 34 || nJob == 43 ){

                ChangeToStandardFaction( oTarget, STANDARD_FACTION_COMMONER );
            }
        }
    }
}

void ds_j_InitialiseTrainer( object oTrainer ){

    if ( GetLocalInt( oTrainer, DS_J_DONE ) > 0 ){

        return;
    }

    string sQuery;
    string sName;
    int nJob = GetLocalInt( oTrainer, DS_J_JOB );

    if ( nJob > 0 ){

        sQuery = "SELECT * FROM ds_j_jobs WHERE id = "+IntToString( nJob );

        SQLExecDirect( sQuery );

        if ( SQLFetch( ) == SQL_SUCCESS ){

            sName = SQLDecodeSpecialChars( SQLGetData( 2 ) );

            //weird formatting, but it makes it easier to spot problems with the db table
            SetLocalString( oTrainer, DS_J_NAME, sName );

            if ( SQLGetData( 4 ) != "" ){

                SetLocalString( oTrainer, DS_J_TITLE+DS_J_LOW,  SQLGetData( 4 ) );
                SetLocalString( oTrainer, DS_J_TITLE+DS_J_MED,  SQLGetData( 5 ) );
                SetLocalString( oTrainer, DS_J_TITLE+DS_J_HIGH, SQLGetData( 6 ) );
            }

            SetLocalInt( oTrainer, DS_J_DONE, 1 );

            SetName( oTrainer, CLR_ORANGE+sName+" - "+DS_J_INSTRUCTOR+CLR_END );

            WriteTimestampedLogEntry( GetName( oTrainer )+";"+GetName(GetArea(oTrainer)));
        }
    }
}


int ds_j_InitialiseSource( object oSource ){

    if ( GetLocalInt( oSource, DS_J_DONE ) > 0 ){

        return TRUE;
    }

    string sTag   = GetTag( oSource );

    // This bit allows cloned job system placeables to work, even though they
    // don't have the proper tag.
    string sCloneTag = GetLocalString( oSource, "clone_tag");
    if ( sCloneTag != "" ) sTag = sCloneTag;

    string sQuery;
    string sName;
    int nResource = GetLocalInt( oSource, DS_J_RESOURCE );
    string sSuffix;
    int i;
    int nAvailability;
    int nJob;
    int nVFX     = GetLocalInt( oSource, DS_J_VFX );

    if ( nResource > 0 ){

        //Creates only one resource, look for resource and tag
        sQuery = "SELECT * FROM ds_j_resources WHERE id = "+IntToString( nResource )+" AND source = '"+sTag+"'";
    }
    else {

        //Converts resource, look for tag
        sQuery = "SELECT * FROM ds_j_resources WHERE source = '"+sTag+"'";
    }

    SQLExecDirect( sQuery );

    SetName( oSource, CLR_ORANGE+GetName( oSource )+CLR_END );

    if ( nVFX ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( nVFX ), oSource );
    }

    if ( nResource > 0 ){

        if ( SQLFetch( ) == SQL_SUCCESS ){

            if ( SQLGetData( 7 ) == sTag ){

                SetLocalString( oSource, DS_J_RESREF, SQLGetData( 3 ) );
                SetLocalInt( oSource, DS_J_ICON, StringToInt( SQLGetData( 4 ) ) );
                SetLocalInt( oSource, DS_J_JOB, StringToInt( SQLGetData( 6 ) ) );
                SetLocalInt( oSource, DS_J_DONE, 1 );
                SetLocalInt( oSource, DS_J_QUANTITY, StringToInt( SQLGetData( 11 ) ) );
                SetLocalString( oSource, DS_J_CATEGORY, SQLGetData( 10 ) );

                return TRUE;
            }
        }
    }
    else {

        while ( SQLFetch( ) == SQL_SUCCESS ){

            if ( SQLGetData( 7 ) == sTag ){

                ++i;

                nJob  = StringToInt( SQLGetData( 6 ) );

                sSuffix = "_" + IntToString( i );

                nResource           = StringToInt( SQLGetData( 1 ) );
                int nAltResource    = StringToInt( SQLGetData( 13 ) );

                if ( nAltResource > 0 ){

                    nResource = nAltResource;
                }

                SetLocalInt( oSource, DS_J_ID+sSuffix, nResource );
                SetLocalString( oSource, DS_J_RESREF+sSuffix, SQLGetData( 3 ) );
                SetLocalInt( oSource, DS_J_ICON+sSuffix, StringToInt( SQLGetData( 4 ) ) );
                SetLocalInt( oSource, DS_J_MATERIAL_PREFIX+sSuffix, StringToInt( SQLGetData( 5 ) ) );
                SetLocalInt( oSource, DS_J_INPUT1+sSuffix, StringToInt( SQLGetData( 8 ) ) );
                SetLocalInt( oSource, DS_J_INPUT2+sSuffix, StringToInt( SQLGetData( 9 ) ) );
                SetLocalInt( oSource, DS_J_TYPE+sSuffix, StringToInt( SQLGetData( 12 ) ) );
                SetLocalInt( oSource, DS_J_JOB+sSuffix, nJob );
            }
        }

        SetLocalInt( oSource, DS_J_DONE, i );

        return TRUE;
    }

    return FALSE;
}


//return values:
// -1: error
//  0: fail
//  1: success
//  2: double success
int ds_j_StandardRoll( object oPC, int nJob ){

    if ( GetIsDM( oPC ) ){

        return 1;
    }

    int nRank      = ds_j_GetJobRank( oPC, nJob );
    int nHitDice   = GetHitDice( oPC );

    //check if job points confirms with character level
    if ( ( nRank == 2 && nHitDice < 6 ) || ( nRank == 3 && nHitDice < 15 ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"You have too many ranks in this job for your level." );
        return -1;
    }

    int nDC1       = 10;

    if ( nRank == 3 ){

        nDC1       = 90;
    }
    else if ( nRank == 2 ){

        nDC1       = 70;
    }

    else if ( nRank == 1 ){

        nDC1       = 50;
    }

    int nFailBonus = GetLocalInt( oPC, DS_J_FAILBONUS );

    int nLastJob   = GetLocalInt( oPC, DS_J_LASTJOB );

    if ( nLastJob == nJob && nFailBonus > 0 ){

        nDC1 += nFailBonus;
        if ( nDC1 > 99 ) nDC1 == 99;

    }

    int nDC2       = nRank * 10;
    int nDie1      = d100();
    int nDie2      = d100();
    int nResult    = 0;

    if ( nDie1 <= nDC1 ){

        nResult = 1;
    }

    if ( nResult && nDie2 <= nDC2 )  {

        nResult = 2;
    }

    SendMessageToPC( oPC, CLR_ORANGE+"Standard Roll "+IntToString( nDie1 ) + " vs " + IntToString( nDC1 ));

    if ( nResult ){

        SendMessageToPC( oPC, CLR_ORANGE+"Bonus Roll "+IntToString( nDie2 ) + " vs " + IntToString( nDC2 ));
    }

    SetLocalInt( oPC, DS_J_LASTJOB, nJob );

    return nResult;
}

//gives oPC standard XP, use nMod to multiply this amount
//returns job rank, you never know what it's good for :D
int ds_j_GiveStandardXP( object oPC, int nJob, int nResult, float fMod=1.0, float fDelay=0.0 ){

    int nRank      = ds_j_GetJobRank( oPC, nJob );


    int nXPTime     = GetServerRunTime() - GetLocalInt( oPC, DS_J_TIME );
    if ( nXPTime < nXPCooldown && GetLocalInt( oPC, DS_J_TIME ) > 0 ){
        SendMessageToPC( oPC, CLR_ORANGE+"You can't get experience from jobs yet."+CLR_END );
        SendMessageToPC( oPC, CLR_ORANGE+"You will be awarded experience from jobs again in "+IntToString( nXPCooldown - nXPTime )+" seconds."+CLR_END );
        return nRank;
    }
    else
        SetLocalInt( oPC, DS_J_TIME, GetServerRunTime());

    int nXP;

    if ( !nRank || nResult == -1 ){

        nXP = 0;
    }
    else if ( nResult ){

        nXP = nResult * nRank * 50;
    }
    else{

        nXP = 50;
    }

    //modify and round by halves
    nXP = FloatToInt( ( fMod * nXP ) + 0.5 );

    GiveCorrectedXP( oPC, nXP, "Job", 0 );

    return nRank;
}

//checks which resource is needed to make nTargetResource
//mind that alloys can be made of two components, so you need to check both
int ds_j_GetInputResource( object oSource, int nTargetResource, int nInput=1 ){

    string sInput = DS_J_INPUT1 + "_" + IntToString( nTargetResource );

    if ( nInput == 2 ){

        sInput = DS_J_INPUT2 + "_" + IntToString( nTargetResource );
    }

    return GetLocalInt( oSource, sInput );
}

void ds_j_CreateAltar( object oPC, location lTarget ){

    string sGod = GetDeity( oPC );
    string sTag = DS_J_ALTAR+"_"+GetPCPublicCDKey( oPC, TRUE );

    if ( sGod == "" ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can't make an altar without having a patron god!" );
        return;
    }

    object oAltar = GetObjectByTag( sTag );

    if ( GetIsObjectValid( oAltar ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"Removing your current altar. Please don't spawn altars often." );

        DestroyObject( oAltar, 0.0 );
        return;
    }

    //try to recreate from DB
    string sQuery = "SELECT * FROM idols WHERE name = '"+sGod+"' LIMIT 1";

    SQLExecDirect( sQuery );

    if ( SQLFetch( ) != SQL_SUCCESS ){

        SendMessageToPC( oPC, sGod+" holds no domain in Amia..." );

        return;
    }

    //rotate 180
    lTarget = Location( GetArea( oPC ), GetPositionFromLocation( lTarget ), ( GetFacingFromLocation( lTarget ) + 180.0 ) );

    oAltar = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_altar", lTarget, FALSE, sTag );

    SetName( oAltar, CLR_ORANGE+"Altar to "+SQLDecodeSpecialChars( SQLGetData( 2 ) )+CLR_END );

    SetLocalString( oAltar, "name", SQLGetData( 5 ) );
    SetLocalString( oAltar, "alignment", SQLGetData( 6 ) );
    SetLocalInt( oAltar, "al_CE", StringToInt( SQLGetData( 7 ) ) );
    SetLocalInt( oAltar, "al_CG", StringToInt( SQLGetData( 8 ) ) );
    SetLocalInt( oAltar, "al_CN", StringToInt( SQLGetData( 9 ) ) );
    SetLocalInt( oAltar, "al_LE", StringToInt( SQLGetData( 10 ) ) );
    SetLocalInt( oAltar, "al_LG", StringToInt( SQLGetData( 11 ) ) );
    SetLocalInt( oAltar, "al_LN", StringToInt( SQLGetData( 12 ) ) );
    SetLocalInt( oAltar, "al_NE", StringToInt( SQLGetData( 13 ) ) );
    SetLocalInt( oAltar, "al_NG", StringToInt( SQLGetData( 14 ) ) );
    SetLocalInt( oAltar, "al_NN", StringToInt( SQLGetData( 15 ) ) );
    SetLocalInt( oAltar, "dom_Air", StringToInt( SQLGetData( 16 ) ) );
    SetLocalInt( oAltar, "dom_Animal", StringToInt( SQLGetData( 17 ) ) );
    SetLocalInt( oAltar, "dom_Death", StringToInt( SQLGetData( 18 ) ) );
    SetLocalInt( oAltar, "dom_Destruction", StringToInt( SQLGetData( 19 ) ) );
    SetLocalInt( oAltar, "dom_Earth", StringToInt( SQLGetData( 20 ) ) );
    SetLocalInt( oAltar, "dom_Evil", StringToInt( SQLGetData( 21 ) ) );
    SetLocalInt( oAltar, "dom_Fire", StringToInt( SQLGetData( 22 ) ) );
    SetLocalInt( oAltar, "dom_Good", StringToInt( SQLGetData( 23 ) ) );
    SetLocalInt( oAltar, "dom_Healing", StringToInt( SQLGetData( 24 ) ) );
    SetLocalInt( oAltar, "dom_Knowledge", StringToInt( SQLGetData( 25 ) ) );
    SetLocalInt( oAltar, "dom_Magic", StringToInt( SQLGetData( 26 ) ) );
    SetLocalInt( oAltar, "dom_Plant", StringToInt( SQLGetData( 27 ) ) );
    SetLocalInt( oAltar, "dom_Protection", StringToInt( SQLGetData( 28 ) ) );
    SetLocalInt( oAltar, "dom_Strength", StringToInt( SQLGetData( 29 ) ) );
    SetLocalInt( oAltar, "dom_Sun", StringToInt( SQLGetData( 30 ) ) );
    SetLocalInt( oAltar, "dom_Travel", StringToInt( SQLGetData( 31 ) ) );
    SetLocalInt( oAltar, "dom_Trickery", StringToInt( SQLGetData( 32 ) ) );
    SetLocalInt( oAltar, "dom_War", StringToInt( SQLGetData( 33 ) ) );
    SetLocalInt( oAltar, "dom_Water", StringToInt( SQLGetData( 34 ) ) );

    SetLocalObject( oAltar, DS_J_USER, oPC );
}

void ds_j_UseAltar( object oPC, object oAltar ){

    object oPriest = GetLocalObject( oAltar, DS_J_USER );

    if ( oPriest == oPC ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can't pray at your own altar!"+CLR_END );
        return;
    }

    if ( !ds_j_MatchAlignment( oPC, oAltar ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can't pray at this altar with that alignment of yours!"+CLR_END );
        return;
    }

    if ( GetLocalInt( oAltar, DS_J_BUSY ) == 1 ){

        SendMessageToPC( oPC, CLR_ORANGE+"Someone is already praying at this altar!"+CLR_END );
        return;
    }

    if ( GetIsObjectValid( oPriest ) ){

        if ( GetDistanceBetween( oAltar, oPriest ) > 5.0 ){

            SendMessageToPC( oPC, CLR_ORANGE+"The Preacher is too far away from the altar!"+CLR_END );
            return;
        }

        float fDelay    = IntToFloat( DS_J_SOURCEDELAY );

        AssignCommand( oPC, ActionPlayAnimation( ANIMATION_LOOPING_MEDITATE, 1.0, fDelay ) );

        AssignCommand( oPC, SpeakString( CLR_ORANGE+"*starts praying*"+CLR_END ) );

        SendMessageToPC( oPC, CLR_ORANGE+"[you need to stay in praying position for "+IntToString( DS_J_SOURCEDELAY )+" seconds to get any xp]"+CLR_END );

        SetLocalInt( oAltar, DS_J_BUSY, 1 );

        DelayCommand( fDelay, DeleteLocalInt( oAltar, DS_J_BUSY ) );

        DelayCommand( fDelay, ds_j_Worship( oPC, oPriest, oAltar ) );
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"The Preacher that spawned this altar can't be found!"+CLR_END );
        DestroyObject( oAltar, 1.0 );
    }
}

void ds_j_Worship( object oPC, object oPriest, object oAltar ){

    if ( GetIsObjectValid( oPriest ) ){

        if ( GetDistanceBetween( oAltar, oPriest ) > 5.0 ){

            SendMessageToPC( oPC, CLR_ORANGE+"The Preacher is too far away from the altar. No XP!"+CLR_END );
            SendMessageToPC( oPriest, CLR_ORANGE+"You are too far away from the altar. No XP!"+CLR_END );
            return;
        }

        if ( GetDistanceBetween( oAltar, oPC ) > 5.0 ){

            SendMessageToPC( oPC, CLR_ORANGE+"You are too far away from the altar. No XP!"+CLR_END );
            SendMessageToPC( oPriest, CLR_ORANGE+"The PC is too far away from the altar. No XP!"+CLR_END );
            return;
        }

        //check if the find is succesful
        int nJob        = 29;
        int nResult     = ds_j_StandardRoll( oPriest, nJob );
        int nRank       = ds_j_GiveStandardXP( oPriest, nJob, nResult );

        if ( nResult == 1 ){

            SendMessageToPC( oPriest, CLR_ORANGE+"Your god is pleased with the worship of the faithful."+CLR_END );
        }
        else if ( nResult == 2 ){

            SendMessageToPC( oPriest, CLR_ORANGE+"Your god is very pleased with the worship of the faithful."+CLR_END );

            effect eVis   = EffectVisualEffect( VFX_IMP_GOOD_HELP );
            effect eBless = EffectSavingThrowIncrease( SAVING_THROW_WILL, nRank );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBless, oPC, TurnsToSeconds( nRank ) );
        }
        else{

            SendMessageToPC( oPriest, CLR_ORANGE+"Your god ignores this worshipper's prayer."+CLR_END );
        }

        GiveCorrectedXP( oPC, ( 10 * nRank ), "Job", 0 );

        AssignCommand( oPC, SpeakString( CLR_ORANGE+"*ends the prayer*"+CLR_END ) );
        AssignCommand( oPC, ActionPlayAnimation( ANIMATION_FIREFORGET_BOW ) );
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"The Preacher that spawned this altar can't be found!"+CLR_END );
        DestroyObject( oAltar, 1.0 );
    }
}

int ds_j_MatchAlignment( object oPC, object oAltar ){

    string sAlignment = ds_j_GetAlignmentName( oPC );

    //match PCs domain with Idol's list
    if ( GetLocalInt( oAltar, "al_"+sAlignment ) == 1 ){

        return TRUE;
    }
    else{

        return FALSE;
    }
}

string ds_j_GetAlignmentName( object oPC ){

    string sAlignment;
    int nLawChaos   = GetAlignmentLawChaos( oPC );
    int nGoodEvil   = GetAlignmentGoodEvil( oPC );

    //get first character of the PC's alignment
    if ( nLawChaos == ALIGNMENT_LAWFUL ){

        sAlignment = "L";
    }
    else if ( nLawChaos == ALIGNMENT_CHAOTIC ){

        sAlignment = "C";
    }
    else{

        sAlignment = "N";
    }

    //get second character
    if ( nGoodEvil == ALIGNMENT_GOOD ){

        sAlignment = sAlignment + "G";
    }
    else if ( nGoodEvil == ALIGNMENT_EVIL ){

        sAlignment = sAlignment + "E";
    }
    else{

        sAlignment = sAlignment + "N";
    }

    return sAlignment;
}

// Returns TRUE if object oBehind is located behind object oInFront as
// determined by the direction oInFront is facing.
// use fMaxDistance to limit the distance between the two objects
int ds_j_GetIsBehind( object oInFront, object oBehind, float fMaxDistance=0.0 ){

    if( !GetIsObjectValid( oInFront) || !GetIsObjectValid( oBehind ) ) {

        return FALSE;
    }

    switch( GetObjectType( oInFront ) ){

        case OBJECT_TYPE_PLACEABLE: break;
        case OBJECT_TYPE_CREATURE: break;

        default: return FALSE;
    }

    switch( GetObjectType( oBehind ) ){

        case OBJECT_TYPE_PLACEABLE: break;
        case OBJECT_TYPE_CREATURE: break;

        default: return FALSE;
    }

    if ( fMaxDistance > 0.0 && GetDistanceBetween( oInFront, oBehind ) > fMaxDistance ){

        return FALSE;
    }

    float fFacing = GetFacing( oInFront);
    float fBehind = VectorToAngle( GetPositionFromLocation( GetLocation( oBehind ) ) - GetPositionFromLocation( GetLocation( oInFront ) ) );
    while( fFacing >  360.0) fFacing -= 360.0;
    while( fFacing <= 0.0)   fFacing += 360.0;
    while( fBehind >  360.0) fBehind -= 360.0;
    while( fBehind <= 0.0)   fBehind += 360.0;

    // "Behind" here is defined as 45 degrees left or right of directly 180
    // degrees from oInFront's facing direction. To narrow the "cone", change
    // the 45.0 to something smaller. Make it larger to widen it. It should
    // not be more than 90.0 or else your getting in front of the guy. 90.0
    // is directly off his left or right shoulder, 0.0 is directly behind him.
    return ( fabs( fBehind - fFacing ) >= ( 180.0 -45.0 ) );
}

void ds_j_FreezePC( object oPC, float fDuration, string sMessage="" ){

    effect eFreeze = EffectCutsceneImmobilize();

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, fDuration );

    if ( sMessage != "" ){

        SendMessageToPC( oPC, sMessage );
    }
}

//caches resource names and prices
void ds_j_CacheResources( int nStart=1, int nEnd=100 ){

    object oStorage         = CacheCache( DS_J_RES_CACHE );

    if ( !GetIsObjectValid( oStorage ) ){

        log_to_exploits( OBJECT_INVALID, "ds_j", "no res cache!" );
        return;
    }

    string sSQL             = "SELECT id, name, price, material_id, weight FROM ds_j_resources WHERE id >= "+IntToString( nStart )+" AND id <= "+IntToString( nEnd ) ;
    string sKey             = "";
    string sName            = "";
    int nCounter            = 0;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        sKey = SQLGetData( 1 );

        ++nCounter;

        //name
        SetLocalString( oStorage, DS_J_RESOURCE_PREFIX + sKey, SQLDecodeSpecialChars( SQLGetData( 2 ) ) );

        //price
        SetLocalInt( oStorage, DS_J_RESOURCE_PREFIX + sKey, StringToInt( SQLGetData( 3 ) ) );

        //weight
        SetLocalInt( oStorage, DS_J_WEIGHT + sKey, StringToInt( SQLGetData( 5 ) ) );

        //material
        SetLocalInt( oStorage, DS_J_ID + sKey, StringToInt( SQLGetData( 4 ) ) );
    }

    SetLocalInt( oStorage, "ds_count", nCounter );

    //descriptions
    oStorage = CacheCache( DS_J_DESCR_CACHE );

    sSQL     = "SELECT id,resource_id FROM ds_j_item_descriptions WHERE description != '' AND resource_id >= "+IntToString( nStart )+" AND resource_id <= "+IntToString( nEnd );
    sKey     = "";
    sName    = "";
    nCounter = 0;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        sKey   = DS_J_RESOURCE_PREFIX + SQLGetData( 2 );

        ++nCounter;

        //description resource id
        //this I will replace with descriptions when first called
        SetLocalInt( oStorage, sKey, StringToInt( SQLGetData( 1 ) ) );
    }

    SetLocalInt( oStorage, "ds_count", nCounter );
}

string ds_j_GetResourceName( int nResource ){

    object oStorage = GetCache( DS_J_RES_CACHE );

    return GetLocalString( oStorage, DS_J_RESOURCE_PREFIX + IntToString( nResource ) );
}

string ds_j_GetResourceDescription( int nResource ){

    object oStorage = GetCache( DS_J_DESCR_CACHE );
    int nDescrID    = GetLocalInt( oStorage, DS_J_RESOURCE_PREFIX + IntToString( nResource ) );

    if ( nDescrID > 0 ){

        string sSQL = "SELECT description FROM ds_j_item_descriptions WHERE id = "+IntToString( nDescrID ) ;
        string sDescription;
        string sKey;

        SQLExecDirect( sSQL );

        if ( SQLFetch( ) == SQL_SUCCESS ){

            sKey         = DS_J_RESOURCE_PREFIX + IntToString( nResource );
            sDescription = SQLDecodeSpecialChars( SQLGetData( 1 ) );

            //replace description resource id with descriptions when first called
            SetLocalString( oStorage, sKey, sDescription );

            SetLocalInt( oStorage, DS_J_RESOURCE_PREFIX + IntToString( nResource ), -1 );

            return sDescription;
        }
        else{

            //error, get rid of id so we don't check again
            SetLocalInt( oStorage, DS_J_RESOURCE_PREFIX + IntToString( nResource ), 0 );
        }
    }
    else if ( nDescrID == -1 ){

        return GetLocalString( oStorage, DS_J_RESOURCE_PREFIX + IntToString( nResource ) );
    }

    return "";
}

int ds_j_GetResourcePrice( int nResource ){

    object oStorage = GetCache( DS_J_RES_CACHE );

    return GetLocalInt( oStorage, DS_J_RESOURCE_PREFIX + IntToString( nResource ) );
}

int ds_j_GetResourceMaterial( int nResource ){

    object oStorage = GetCache( DS_J_RES_CACHE );

    return GetLocalInt( oStorage, DS_J_ID + IntToString( nResource ) );
}

int ds_j_GetResourceWeight( int nResource ){

    object oStorage = GetCache( DS_J_RES_CACHE );

    return GetLocalInt( oStorage, DS_J_WEIGHT + IntToString( nResource ) );
}

//caches resource stocks
void ds_j_CacheStock( string sModule ){

    object oStorage         = CacheCache( DS_J_STOCK_CACHE );

    if ( !GetIsObjectValid( oStorage ) ){

        log_to_exploits( OBJECT_INVALID, "ds_j", "no stock cache!" );
        return;
    }

    string sSQL             = "SELECT resource_id, stock FROM ds_j_stocks WHERE module = "+sModule +" AND stock > 0";
    string sKey             = "";
    string sName            = "";
    int i;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        sKey   = DS_J_RESOURCE_PREFIX + SQLGetData( 1 );

        SetLocalInt( oStorage, sKey, StringToInt( SQLGetData( 2 ) ) );

        //I need to know IF this value has been set, even if the int becomes 0
        SetLocalString( oStorage, sKey, "y" );
    }
}

//moves resource stocks from cache to database
void ds_j_FlushStock( ){

    object oStorage         = GetCache( DS_J_STOCK_CACHE );

    if ( !GetIsObjectValid( oStorage ) ){

        log_to_exploits( OBJECT_INVALID, "ds_j", "no stock cache!" );
        return;
    }

    string sSQL;
    int i;
    int nStock;
    string sModule = IntToString( GetLocalInt( GetModule(), "Module" ) );
    string sResource;
    string sStock;

    for ( i=1; i<=600; ++i ){

        nStock = GetLocalInt( oStorage, DS_J_RESOURCE_PREFIX + IntToString( i ) );

        if ( nStock || GetLocalString( oStorage, DS_J_RESOURCE_PREFIX + IntToString( i ) ) == "y" ){

            sStock    = IntToString( nStock );
            sResource = IntToString( i );
            sSQL      = "INSERT INTO ds_j_stocks VALUES ( "+sResource+", "+sModule+","+sStock+", NOW() ) ON DUPLICATE KEY UPDATE stock="+sStock+", updated=NOW()";

            SQLExecDirect( sSQL );
        }
    }

    SQLExecDirect( "UPDATE ds_j_stocks SET stock = ( CASE WHEN stock < 1 THEN ROUND(1 + RAND()) WHEN stock > 75 THEN ( stock - ROUND(RAND() * 25 ) ) ELSE stock END ) WHERE module = "+sModule );
}

//gets stock amount for nResource from cache
int ds_j_GetStock( int nResource ){

    object oStorage         = GetCache( DS_J_STOCK_CACHE );

    if ( !GetIsObjectValid( oStorage ) ){

        log_to_exploits( OBJECT_INVALID, "ds_j", "no stock cache!" );

        return 0;
    }

    int nStock = GetLocalInt( oStorage, DS_J_RESOURCE_PREFIX + IntToString( nResource ) );

    return nStock;
}

//sets stock amount for nResource in cache, returns current value
int ds_j_ChangeStock( int nResource, int nChange ){

    object oStorage         = GetCache( DS_J_STOCK_CACHE );

    if ( !GetIsObjectValid( oStorage ) ){

        log_to_exploits( OBJECT_INVALID, "ds_j", "no stock cache!" );

        return 0;
    }

    int nStock = GetLocalInt( oStorage, DS_J_RESOURCE_PREFIX + IntToString( nResource ) ) + nChange ;

    SetLocalInt( oStorage, DS_J_RESOURCE_PREFIX + IntToString( nResource ), nStock );

    return nStock;
}

void ds_j_CacheMaterial(){

    object oStorage         = CacheCache( DS_J_MAT_CACHE );
    object oStorage2        = CacheCache( DS_J_RES_CACHE );

    if ( !GetIsObjectValid( oStorage ) ){

        log_to_exploits( OBJECT_INVALID, "ds_j", "no mat cache!" );
        return;
    }

    string sSQL             = "SELECT id, name, resource_id FROM ds_j_materials";
    string sKey             = "";
    string sName            = "";
    int nPrice;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        sKey   = DS_J_MATERIAL_PREFIX + SQLGetData( 1 );

        //name
        SetLocalString( oStorage, sKey, SQLDecodeSpecialChars( SQLGetData( 2 ) ) );

        //price
        if ( SQLGetData( 3 ) != "" && SQLGetData( 3 ) != "0" ){

            nPrice = GetLocalInt( oStorage2, DS_J_RESOURCE_PREFIX + SQLGetData( 3 ) );
            SetLocalInt( oStorage, sKey, nPrice );
        }
    }
}

string ds_j_GetMaterialName( int nMaterial ){

    object oStorage = GetCache( DS_J_MAT_CACHE );

    return GetLocalString( oStorage, DS_J_MATERIAL_PREFIX + IntToString( nMaterial ) );
}

int ds_j_GetMaterialPrice( int nMaterial ){

    object oStorage = GetCache( DS_J_MAT_CACHE );

    return GetLocalInt( oStorage, DS_J_MATERIAL_PREFIX + IntToString( nMaterial ) );
}


//returns the type of material oItem is made of
//returns 0 if no material property can be found
int ds_j_GetMaterialFromItem( object oItem, int nSlot=1 ){

    itemproperty ipLoop = GetFirstItemProperty( oItem );

    while ( GetIsItemPropertyValid( ipLoop ) ){

        //If ipLoop is a true seeing property, remove it
        if ( GetItemPropertyType( ipLoop ) == ITEM_PROPERTY_MATERIAL ){

            if ( nSlot == 1 ){

                return GetItemPropertyCostTableValue( ipLoop );
            }
            else {

                 nSlot = 1;
            }
        }

        //Next itemproperty on the list...
        ipLoop = GetNextItemProperty( oItem );
    }

    return 0;
}

//returns the quality of oItem
//returns 0 if no quality property can be found
int ds_j_GetQualityFromItem( object oItem ){

    itemproperty ipLoop = GetFirstItemProperty( oItem );

    while ( GetIsItemPropertyValid( ipLoop ) ){

        //If ipLoop is a true seeing property, remove it
        if ( GetItemPropertyType( ipLoop ) == ITEM_PROPERTY_QUALITY ){

            return GetItemPropertyCostTableValue( ipLoop );
        }

        //Next itemproperty on the list...
        ipLoop = GetNextItemProperty( oItem );
    }

    return 0;
}

//puts quality and material properties on item
void ds_j_AddMaterialProperties( object oPC, object oItem, int nMaterial1, int nRank, int nResult, int nMaterial2=0, int nNoCreator=0 ){

    if ( nMaterial1 > 0 ){

        itemproperty ipMaterial1 = ItemPropertyMaterial( nMaterial1 );
        IPSafeAddItemProperty( oItem, ipMaterial1 );
    }

    if ( nMaterial2 > 0 ){

        itemproperty ipMaterial2 = ItemPropertyMaterial( nMaterial2 );
        IPSafeAddItemProperty( oItem, ipMaterial2, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
    }

    itemproperty ipQuality  = ItemPropertyQuality( 5 + nRank + nResult );
    IPSafeAddItemProperty( oItem, ipQuality );

    if ( !nNoCreator ) {

        SetDescription( oItem, GetDescription( oItem ) + CLR_ORANGE+"\n\n"+CLR_ORANGE+"This item was created by "+GetName( oPC ) +"."+CLR_END );
    }
}


void ds_j_BuyResource( object oPC, object oInventory, object oMerchant, object oItem, int nEvaluate=0, int nJob=0 ){

    int nResource = ds_j_GetResourceID( oPC, oItem );
    int nPrice    = ds_j_GetResourcePrice( nResource );
    int nDebug    = GetLocalInt( oPC, "debug" );
    int nResult;
    int nRank;
    float fPrice;

    if ( nJob > 0 && !GetLocalInt( oInventory, DS_J_BUY+IntToString( nResource ) ) ){

        SendMessageToPC( oPC, "[" + CLR_ORANGE + GetName( oItem ) + " cannot be traded by you." + CLR_END + "]" );
        return;
    }

    if ( nJob == 0 && !GetLocalInt( oMerchant, DS_J_BUY+IntToString( nResource ) ) ){

        SendMessageToPC( oPC, "[" + CLR_ORANGE + GetName( oItem ) + " is not accepted by this merchant." + CLR_END + "]" );
        SendMessageToPC( oPC, "[" + CLR_ORANGE + GetTag( oItem ) + CLR_END + "]" );
        return;
    }

    if ( nPrice > 0 ){

        //Do not add on GP value of item if a non-zero price has been fetched
        if ( nDebug ) SendMessageToPC( oPC, CLR_RED + "Debug: Listed price is " + IntToString( nPrice ) + " GP" + CLR_END );

    }
    else{

        //jewelry
        nPrice += GetGoldPieceValue( oItem );

        int nMaterial1    = ds_j_GetMaterialFromItem( oItem, 1 );
        int nMaterial2    = ds_j_GetMaterialFromItem( oItem, 2 );

        if ( nMaterial1 ){

            nPrice += ds_j_GetMaterialPrice( nMaterial1 );
        }

        if ( nMaterial2 ){

            nPrice += ds_j_GetMaterialPrice( nMaterial2 );
        }

        if ( nDebug ) SendMessageToPC( oPC, CLR_RED + "Debug: No listed price, so adding value of component materials. Price is now " + IntToString( nPrice ) + " GP" + CLR_END );

    }

    float fQuality    = ds_j_GetQualityFromItem( oItem ) / 7.0;

    if ( fQuality > 0.0 ){

        fPrice = nPrice * fQuality;
        nPrice = FloatToInt( 0.5 + fPrice );
        if ( nDebug ) SendMessageToPC( oPC, CLR_RED + "Debug: Adjusting for quality.  Price is now " + IntToString( nPrice ) + " GP" + CLR_END );

    }

    // Check to see if item is a partial stack
    int nStackSize              = GetItemStackSize( oItem );
    int nBaseItemType           = GetBaseItemType( oItem );
    string s2DAValue            = Get2DAString( "baseitems", "Stacking", nBaseItemType );
    int nMaxStackForItemType    = StringToInt( s2DAValue );

    // If item is a partial stack, offer a fraction of the price that would be
    // paid for a full stack.
    if ( nStackSize < nMaxStackForItemType ){

        nPrice = nPrice * nStackSize / nMaxStackForItemType;

        if ( nDebug ) SendMessageToPC( oPC, CLR_RED + "Debug: Partial item stack detected, price adjusted to " + IntToString( nPrice ) + " GP" + CLR_END );

    }

    if( GetStolenFlag( oItem ) &&
                (   nBaseItemType == BASE_ITEM_BOLT         ||
                    nBaseItemType == BASE_ITEM_ARROW        ||
                    nBaseItemType == BASE_ITEM_DART         ||
                    nBaseItemType == BASE_ITEM_SHURIKEN     ||
                    nBaseItemType == BASE_ITEM_BULLET       ||
                    nBaseItemType == BASE_ITEM_THROWINGAXE  )   ){
        SendMessageToPC( oPC, "[" + CLR_RED + " Duplicated Ammo can not be sold." + CLR_END + "]" );
        return;
    }

    if ( nPrice == 0 ){

        SendMessageToPC( oPC, "[" + CLR_RED + GetName( oItem ) + " is not accepted by this merchant." + CLR_END + "]" );
        return;
    }

    SetLocalInt( oPC, DS_J_TOTAL, ( GetLocalInt( oPC, DS_J_TOTAL ) + nPrice ) );

    if ( nEvaluate ){

        SendMessageToPC( oPC, CLR_ORANGE + GetName( oItem )+": "+IntToString( nPrice )+" gold." + CLR_END );
    }
    else{

        DestroyObject( oItem );

        SendMessageToPC( oPC, CLR_ORANGE + DS_J_MERCHANT + " buys "+GetName( oItem )+"." + CLR_END );

        GiveGoldToCreature( oPC, nPrice );

        ds_j_ChangeStock( nResource, 1 );

        if ( nJob > 0 ){

            SendMessageToPC( oMerchant, CLR_ORANGE + "You buy "+GetName( oItem )+"." + CLR_END );

            nResult = ds_j_StandardRoll( oPC, nJob );
            //nRank   = ds_j_GiveStandardXP( oPC, nJob, nResult, 0.05 );
            nRank   = ds_j_GetJobRank( oPC, nJob );

            if ( nResult > 0 ){

                //give
                nPrice = ( ( nPrice * nRank * nResult ) / 20 );

                GiveGoldToCreature( oMerchant, nPrice );

                SetLocalInt( GetModule(), "JobGP", GetLocalInt( GetModule(), "JobGP" ) + nPrice );
            }
        }
    }
}

void ds_j_BuyInventory( object oPC, object oInventory, object oMerchant, int nEvaluate=0, int nJob=0 ){

    if ( nJob == 0 ){

        oInventory = GetNearestObjectByTag( DS_J_CHEST );
    }
    else{

        oMerchant  = GetLocalObject( oInventory, DS_J_USER );
    }

    if ( !GetIsObjectValid( oMerchant ) ){

        AssignCommand( oInventory, SpeakString( "Take your items out of this chest. You can't sell anything if the chest's owner isn't around." ) );

        return;
    }

    object oItem      = GetFirstItemInInventory( oInventory );
    float fDelay      = 0.3;

    DeleteLocalInt( oPC, DS_J_TOTAL );

    while ( GetIsObjectValid( oItem ) == TRUE ){

        DelayCommand( fDelay, ds_j_BuyResource( oPC, oInventory, oMerchant, oItem, nEvaluate, nJob ) );

        fDelay += 0.3;

        oItem = GetNextItemInInventory( oInventory );
    }

    DelayCommand( fDelay, SendMessageToPC( oPC, CLR_ORANGE + "Total Sum: "+IntToString( GetLocalInt( oPC, DS_J_TOTAL ) )+" gold." + CLR_END ) );

    fDelay += 0.5;

    DelayCommand( fDelay, DeleteLocalInt( oPC, DS_J_TOTAL ) );
}

//create a new item.
//if nIcon > 0 it will take sResref as an item in the template chest
//if sNewtag is given it will create a new tag on the item
object ds_j_CreateItemOnPC( object oPC, string sResRef, int nResource, string sName="", string sNewTag="", int nIcon=0 ){

    object oProduct;
    string sDescription = ds_j_GetResourceDescription( nResource );

    //WriteTimestampedLogEntry( "nIcon = "+IntToString(nIcon) );
    //WriteTimestampedLogEntry( "nResource = "+IntToString(nResource) );
    //WriteTimestampedLogEntry( "sResRef = "+sResRef );

    if ( sName == "" ){

        sName = CLR_ORANGE+ds_j_GetResourceName( nResource )+CLR_END;
    }
    else{

        sName = CLR_ORANGE + sName + CLR_END;
    }

    //WriteTimestampedLogEntry( "sName = "+sName );

    if ( sNewTag == "" ){

        sNewTag = DS_J_RESOURCE_PREFIX + IntToString( nResource );
    }

    //these templates are made for activation so will never have a new tag
    if ( GetStringRight( sResRef, 2 ) == "_a" ){

        sNewTag == "";
    }

    //WriteTimestampedLogEntry( "sNewTag = "+sNewTag );

    if ( nIcon > 0 ){

        object oDestroy;
        object oTemplates = GetLocalObject( GetModule(), DS_J_TEMPLATES );
        object oTemplate  = GetLocalObject( oTemplates, sResRef );
        int nWeight       = ds_j_GetResourceWeight( nResource );


        //WriteTimestampedLogEntry( "oTemplates = "+GetName(oTemplates) );
        //WriteTimestampedLogEntry( "oTemplate = "+GetName(oTemplate) );

        oDestroy = CopyItemAndModify( oTemplate, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nIcon );

        SetName( oDestroy, sName );

        if ( nWeight > 0 ){

            itemproperty ipWeight = ItemPropertyWeightIncrease( nWeight );

            IPSafeAddItemProperty( oDestroy, ipWeight, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        }

        oProduct = CopyObject( oDestroy, GetLocation( oPC ), oPC, sNewTag );

        // Fixes items coming out of chest so that they have the material
        // item property added.
        int nMaterial = ds_j_GetResourceMaterial( nResource );
        ds_j_AddMaterialProperties( oPC, oProduct, nMaterial, 1, 1, 0, 0 );

        DestroyObject( oDestroy, 1.0 );

    }
    else{

        //arrows and such come in stack sizes of max 25
        //not used atm
        oProduct = CreateItemOnObject( sResRef, oPC, 1, sNewTag );

        int nItemType = GetBaseItemType( oProduct );

        if ( nItemType == BASE_ITEM_ARROW
          || nItemType == BASE_ITEM_BOLT
          || nItemType == BASE_ITEM_BULLET
          || nItemType == BASE_ITEM_DART
          || nItemType == BASE_ITEM_SHURIKEN
          || nItemType == BASE_ITEM_THROWINGAXE ){

            SetItemStackSize( oProduct, 25 );
        }

        SetName( oProduct, CLR_ORANGE + sName + CLR_END );
    }

    if ( sDescription != "" ){

        SetDescription( oProduct, CLR_ORANGE+sDescription+CLR_END );
    }

    return oProduct;
}

void ds_j_TrainPC( object oPC, object oTrainer ){

    int nJobNPC      = GetLocalInt( oTrainer, DS_J_JOB );

    if ( !nJobNPC ){

        return;
    }

    if ( !ds_j_CheckBoostJobs( oPC, nJobNPC ) ){

        SendMessageToPC( oPC, CLR_ORANGE+" You can take only one ability boosting job!"+CLR_END );
        return;
    }

    //rest of the variables
    string sJobTag          = DS_J_JOB + "_" + IntToString( nJobNPC );
    int nRankPC             = GetPCKEYValue( oPC, sJobTag );
    int nJobPointsCurrent   = GetHitDice( oPC ) + 3;
    int nJobPointsSpent     = GetPCKEYValue( oPC, DS_J_JOB );
    int nJobPointsAvailable;
    int i;
    string sName            = GetLocalString( oTrainer, DS_J_NAME );
    string sTitle;
    string sDescription;
    object oJobJournal      = GetItemPossessedBy( oPC, DS_J_JOURNAL );  //cache?

    //add journal if PC doesn't have it yet
    if ( !GetIsObjectValid( oJobJournal ) ){

        oJobJournal = CreateItemOnObject( DS_J_JOURNAL, oPC );
    }

    //max 27 job points
    if ( nJobPointsCurrent > 30 ){

        nJobPointsCurrent == 30;
    }

    //see how many points are available
    nJobPointsAvailable = nJobPointsCurrent - nJobPointsSpent;

    if ( nRankPC == DS_J_NONE_ID ){

        //level 0 > 1

        if ( nJobPointsAvailable >= DS_J_LOW_POINTS ){

            //you can always start with the lowest job level as long as you got
            //the required amount of job points
            SetPCKEYValue( oPC, sJobTag, DS_J_LOW_ID );
            SetPCKEYValue( oPC, DS_J_JOB, ( nJobPointsSpent + DS_J_LOW_POINTS ) );

            sTitle = GetLocalString( oTrainer, DS_J_TITLE+DS_J_LOW );

            if ( sTitle == "" ){

                sTitle = "Apprentice";
            }

            SendMessageToPC( oPC, CLR_ORANGE+"You have become "+sTitle+" "+sName+"."+CLR_END );

            sDescription = "\n * "+CLR_ORANGE+sTitle+" "+sName+" "+CLR_END+" ("+IntToString( DS_J_LOW_POINTS )+" pts)" ;
            SetDescription( oJobJournal, GetDescription( oJobJournal )+sDescription ) ;
        }
        else{

            SendMessageToPC( oPC, "["+CLR_RED+" You do not have enough Job Points left."+CLR_END+"]" );
        }
    }
    else if ( nRankPC == DS_J_LOW_ID ){

        //level 1 > 2

        if ( nJobPointsAvailable >= DS_J_MED_POINTS ){

            //you can always start with the lowest job level as long as you got
            //the required amount of job points
            SetPCKEYValue( oPC, sJobTag, DS_J_MED_ID );
            SetPCKEYValue( oPC, DS_J_JOB, ( nJobPointsSpent + DS_J_MED_POINTS  ) );

            sTitle = GetLocalString( oTrainer, DS_J_TITLE+DS_J_MED );

            if ( sTitle == "" ){

                sTitle = "Journeyman";
            }

            SendMessageToPC( oPC, CLR_ORANGE+"You have become "+sTitle+" "+sName+"."+CLR_END );

            sDescription = "\n * "+CLR_ORANGE+sTitle+" "+sName+" "+CLR_END+" ("+IntToString( DS_J_MED_POINTS )+" pts)" ;
            SetDescription( oJobJournal, GetDescription( oJobJournal )+sDescription ) ;
        }
        else{

            SendMessageToPC( oPC, "["+CLR_RED+" You do not have enough Job Points left."+CLR_END+"]" );
        }
    }
    else if ( nRankPC == DS_J_MED_ID ){

        //level 2 > 3

        if ( nJobPointsAvailable >= DS_J_HIGH_POINTS ){

            //you can always start with the lowest job level as long as you got
            //the required amount of job points
            SetPCKEYValue( oPC, sJobTag, DS_J_HIGH_ID );
            SetPCKEYValue( oPC, DS_J_JOB, ( nJobPointsSpent + DS_J_HIGH_POINTS  ) );
            SetPCKEYValue( oPC, DS_J_RANK3, nJobNPC );


            sTitle = GetLocalString( oTrainer, DS_J_TITLE+DS_J_HIGH );

            if ( sTitle == "" ){

                sTitle = "Master";
            }

            SendMessageToPC( oPC, CLR_ORANGE+"You have become "+sTitle+" "+sName+"."+CLR_END );

            sDescription = "\n * "+CLR_ORANGE+sTitle+" "+sName+" "+CLR_END+" ("+IntToString( DS_J_HIGH_POINTS )+" pts)" ;
            SetDescription( oJobJournal, GetDescription( oJobJournal )+sDescription ) ;
        }
        else{

            SendMessageToPC( oPC, "["+CLR_RED+" You do not have enough Job Points left."+CLR_END+"]" );
        }
    }
    else if ( nRankPC == DS_J_HIGH_ID ){

        //level 3
        sTitle = GetLocalString( oTrainer, DS_J_TITLE+DS_J_HIGH );

        if ( sTitle == "" ){

            sTitle = "Master";
        }

        AssignCommand( oTrainer, SpeakString( CLR_ORANGE+"I cannot teach you any further, "+sTitle+"."+CLR_END ) );
    }
}

//returns TRUE if oPC can take (another rank in) this job
int ds_j_CheckBoostJobs( object oPC, int nJob ){

    if ( nJob < 23 || nJob > 28 ){

        return TRUE;
    }

    if ( nJob != 23 && GetPCKEYValue( oPC, DS_J_JOB + "_23" ) ) { return FALSE; };
    if ( nJob != 24 && GetPCKEYValue( oPC, DS_J_JOB + "_24" ) ) { return FALSE; };
    if ( nJob != 25 && GetPCKEYValue( oPC, DS_J_JOB + "_25" ) ) { return FALSE; };
    if ( nJob != 26 && GetPCKEYValue( oPC, DS_J_JOB + "_26" ) ) { return FALSE; };
    if ( nJob != 27 && GetPCKEYValue( oPC, DS_J_JOB + "_27" ) ) { return FALSE; };
    if ( nJob != 28 && GetPCKEYValue( oPC, DS_J_JOB + "_28" ) ) { return FALSE; };

    return TRUE;
}

void ds_j_Scribe( object oPC, string sMessage ){

    //filter ds_j_
    int nLength  = GetStringLength( sMessage );
    sMessage = GetSubString( sMessage, 5, nLength );

    //parse input
    int nSpace = FindSubString( sMessage, " " );

    if ( nSpace == -1 ){

        SendMessageToPC( oPC, "["+CLR_RED+"Error: wrong command."+CLR_END+"]" );
        return;
    }

    string sCommand = GetStringLowerCase( GetStringLeft( sMessage, nSpace ) );
    string sValue   = GetSubString( sMessage, nSpace+1, nLength-2 );

    SetPCChatMessage( CLR_ORANGE+"*writes*"+CLR_END );

    //get the right target
    if ( sCommand == "name" || sCommand == "bio" || sCommand == "append" || sCommand == "break" ){

        object oDesk = GetNearestObjectByTag( "ds_j_desk", oPC );

        if ( !GetIsObjectValid( oDesk ) ){

            SendMessageToPC( oPC, "["+CLR_RED+"Error: Can't find nearby Clerk's desk."+CLR_END+"]" );
            return;
        }
        else{

            object oItem = GetFirstItemInInventory( oDesk );

            if ( !GetIsObjectValid( oItem ) ){

                SendMessageToPC( oPC, "["+CLR_RED+"Error: Can't find item in Clerk's desk."+CLR_END+"]" );
                return;
            }

            if ( GetStringLeft( GetTag( oItem ), 4 ) != "ds_j"){

                SendMessageToPC( oPC, "["+CLR_RED+"Error: You can only change the names of items generated by the job system."+CLR_END+"]" );
                return;
            }

            int nTime   = GetServerRunTime() - GetLocalInt( oDesk, DS_J_TIME );
            int nResult = ds_j_StandardRoll( oPC, 88 );

            if ( nResult < 1 ){

                return;
            }

            if ( nTime > DS_J_SOURCEDELAY ){

                //block for DS_J_SOURCEDELAY seconds
                SetLocalInt( oDesk, DS_J_TIME, GetServerRunTime() );

                int nRank   = ds_j_GiveStandardXP( oPC, 88, nResult );
            }
            else{

                SendMessageToPC( oPC, CLR_ORANGE+"You can only get XP for this once every 2 minutes."+CLR_END );
            }

            if ( sCommand == "name" ){

                SendMessageToPC( oPC, CLR_ORANGE+"Changing "+GetName( oItem )+"'s name to "+sValue+"."+CLR_END );

                SetName( oItem, CLR_ORANGE+sValue+CLR_END );

                return;
            }
            else if ( sCommand == "bio" ){

                SendMessageToPC( oPC, CLR_ORANGE+"Changing "+GetName( oItem )+"'s description."+CLR_END );

                SetDescription( oItem, CLR_ORANGE+sValue+CLR_END );

                return;
            }
            else if ( sCommand == "append" ){

                SendMessageToPC( oPC, CLR_ORANGE+"Adding to "+GetName( oItem )+"'s description."+CLR_END );

                SetDescription( oItem, GetDescription( oItem ) + "\n" + CLR_ORANGE+sValue+CLR_END );

                return;
            }
            else if ( sCommand == "break" ){

                SendMessageToPC( oPC, CLR_ORANGE+"Adding a break to "+GetName( oItem )+"'s description."+CLR_END );

                SetDescription( oItem, GetDescription( oItem ) + "\n" );

                return;
            }
        }
    }
}

void ds_j_CreateRandomGemOnPC( object oPC ){

    int nGem = 172 + Random( 26 );
    int nIcon;

    switch ( nGem ){

        case 172: nIcon=79; break;
        case 173: nIcon=79; break;
        case 174: nIcon=96; break;
        case 175: nIcon=79; break;
        case 176: nIcon=41; break;
        case 177: nIcon=49; break;
        case 178: nIcon=49; break;
        case 179: nIcon=49; break;
        case 180: nIcon=80; break;
        case 181: nIcon=73; break;
        case 182: nIcon=73; break;
        case 183: nIcon=79; break;
        case 184: nIcon=79; break;
        case 185: nIcon=80; break;
        case 186: nIcon=80; break;
        case 187: nIcon=79; break;
        case 188: nIcon=79; break;
        case 189: nIcon=36; break;
        case 190: nIcon=79; break;
        case 191: nIcon=44; break;
        case 192: nIcon=73; break;
        case 193: nIcon=79; break;
        case 194: nIcon=79; break;
        case 195: nIcon=79; break;
        case 196: nIcon=85; break;
        case 197: nIcon=68; break;
        default : nGem = 172; nIcon=79; break;
    }

    object oGem = ds_j_CreateItemOnPC( oPC, "ds_j_small", nGem, "", "", nIcon );

    ds_j_AddMaterialProperties( oPC, oGem, ds_j_GetResourceMaterial( nGem ), d3(), d2(), 0, 1 );
}


//checks if the PLC contains two items that are suitable for copying
//returns > 1 if so and deals with the rest if nConvo == 1
//return values:
// 1 valid combination, color options, probably multiple parts
// 2 valid combination, no color options, simple model
int ds_j_CopyCheck( object oPC, object oPLC, string sPLCTag, int nJob, int nConvo=1 ){

    object oItem2 = GetFirstItemInInventory( oPLC );
    object oItem1 = GetNextItemInInventory( oPLC );
    object oItem0 = GetNextItemInInventory( oPLC );
    int nResult   = FALSE;
    int nRank     = ds_j_GetJobRank( oPC, nJob );

    if ( !GetIsObjectValid( oItem2 ) ){

        return nResult;
    }

    if ( GetIsObjectValid( oItem0 ) ){

        return nResult;
    }

    int nBaseItem1 = GetBaseItemType( oItem1 );
    int nBaseItem2 = GetBaseItemType( oItem2 );

    if ( nBaseItem1 != nBaseItem2 ){

        return nResult;
    }

    if ( sPLCTag == "ds_j_armouranvil" ){

        if ( ( nBaseItem1 == BASE_ITEM_ARMOR ) &&
             ( GetBaseAC( oItem1 ) == GetBaseAC( oItem2 ) ) &&
             ( GetBaseAC( oItem1 ) > 0 ) ){

            nResult = 1;
        }
        else if ( nBaseItem1 == BASE_ITEM_HELMET ){

            nResult = 1;
        }
        else if ( nBaseItem1 == BASE_ITEM_LARGESHIELD ||
                  nBaseItem1 == BASE_ITEM_SMALLSHIELD ||
                  nBaseItem1 == BASE_ITEM_TOWERSHIELD){

            nResult = 2;
        }
        else{

            return nResult;
        }
    }
    else if ( sPLCTag == "ds_j_weaponanvil" ){

        if ( IPGetIsMeleeWeapon( oItem1 ) ){

            nResult = 1;
        }
        else{

            return nResult;
        }
    }
    else if ( sPLCTag == "ds_j_tailorbench" ){

        if ( ( nBaseItem1 == BASE_ITEM_ARMOR ) &&
             ( GetBaseAC( oItem1 ) == 0 ) &&
             ( GetBaseAC( oItem2 ) == 0 ) ){

            nResult = 1;
        }
        else if ( nBaseItem1 == BASE_ITEM_CLOAK ){

            nResult = 1;
        }
        else{

            return nResult;
        }
    }

    if ( nConvo != 1 ){

        return nResult;
    }

    if ( nResult > 0 ){

        //if result == 1 we got an item with colour options
        if ( nResult == 1 ){

            SetLocalInt( oPC, "ds_check_11", 1 );
        }

        if ( nRank > 1 ){

            if ( nResult == 1 ){

                SetLocalInt( oPC, "ds_check_21", 1 );
            }

            SetLocalInt( oPC, "ds_check_20", 1 );
        }

        if ( nRank > 2 ){

            if ( nResult == 1 ){

                SetLocalInt( oPC, "ds_check_31", 1 );
            }

            SetLocalInt( oPC, "ds_check_30", 1 );
        }

        SetLocalString( oPC, "ds_action", "ds_j_copy_act" );
        SetLocalObject( oPC, "ds_target", oPLC );

        SetCustomToken( 7201, GetName( oItem1 ) );
        SetCustomToken( 7202, GetName( oItem2 ) );

        AssignCommand( oPC, ActionStartConversation( oPC, "ds_j_copy", TRUE, FALSE ) );
    }

    return nResult;
}

object ds_j_CopyReplaceItem( object oItem, int nType, int nIndex, int nNewValue ){

    object oTemp = CopyItemAndModifyFixed( oItem, nType, nIndex, nNewValue );

    DestroyObject( oItem );

    return oTemp;
}

//Completely clears the PC's job log
void ds_j_ClearJobLog( object oPC ){

        int i;

        for ( i=1; i<=101; ++i ){

            DeletePCKEYValue( oPC, DS_J_JOB+"_"+IntToString( i ) );
        }

        DeletePCKEYValue( oPC, DS_J_JOB );

        SafeDestroyObject( GetItemPossessedBy( oPC, DS_J_JOURNAL ) );
}

// Boolean. Checks whether the PC's trader slots are occupied by any resources.
int ds_j_GetTraderSlotsOccupied( object oPC ){

    int nReturn     = 0;
    int i;
    string sSlot;

    for ( i=1; i<=30 ; ++i ){
        sSlot       = DS_J_ID + IntToString( i );

        if ( GetPCKEYValue( oPC, sSlot ) > 0 ){
            nReturn = 1;
            break;

        }

    }

    return nReturn;

}
