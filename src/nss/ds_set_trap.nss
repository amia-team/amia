//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_set_trap
//description: sets random traps in dungeon
//used as: OnEnter script
//date:    oct 23 2007
//author:  disco
//notes:  make sure you test this on Hardcore rules difficulty!


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //get spawnpoint inside trigger
    object oTrigger   = OBJECT_SELF;
    object oPC        = GetEnteringObject();
    object oTrap      = GetLocalObject( oTrigger, "spt_obj" );
    int nSpawnpoints  = GetLocalInt( oTrigger, "spt_cnt" );

    if ( GetIsBlocked( OBJECT_SELF ) > 0 ){

        return;
    }

    SetBlockTime( OBJECT_SELF, 15 );

    //check if there's a trap set by our trigger
    if ( GetIsObjectValid( oTrap ) ){

        //SendMessageToPC( oPC, GetName( oTrap ) );
        return;
    }

    //probably first encounter with the trigger this session
    if ( !nSpawnpoints ){

        //loop through waypoints in trap set trigger
        object oInTrigger = GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_WAYPOINT );

        while ( GetIsObjectValid( oInTrigger ) ){

            //only use trap spawnpoints
            if ( GetStringLeft( GetTag( oInTrigger ), 7 ) == "ds_trap" ){

                ++nSpawnpoints;

                //store spawnpoints as objects for future reference
                SetLocalObject( oTrigger, "spt_"+IntToString( nSpawnpoints ), oInTrigger );
            }

            oInTrigger = GetNextInPersistentObject( oTrigger, OBJECT_TYPE_WAYPOINT );
        }

        if ( nSpawnpoints > 0 ){

            //store number of spawnpoints on trigger
            SetLocalInt( oTrigger, "spt_cnt", nSpawnpoints );
        }
        else{

            //apparently there are no spawnpoints, destroy trigger
            DestroyObject( oTrigger );
            return;
        }
    }

    //get spawnpoint
    string sSpawnpoint   = "spt_"+IntToString( ( 1 + Random( nSpawnpoints ) ) );
    object oSpawnpoint   = GetLocalObject( oTrigger, sSpawnpoint );
    location lSpawnpoint = GetLocation( oSpawnpoint );

    //determine trap type and strength (set by trigger)
    int nTrapStrength    = GetLocalInt( oTrigger, "spt_str" );
    int nTrapGenType     = GetLocalInt( oTrigger, "spt_type" );
    int nTrapType        = 0;

    if ( nTrapStrength == -1  ){

        //make random strength trap
        nTrapStrength = Random( 5 );
    }

    if ( nTrapGenType == -1 ){

        //random traps
        if ( nTrapStrength > 3 ){

            //epic traps are a bit different (check traps.2da)
            nTrapType        = 44 + Random( 4 );
        }
        else{

            nTrapType        = nTrapStrength + ( Random( 11 ) * 4 );
        }
    }
    else{

        //preset trap types
        if ( nTrapStrength > 3 ){

            //epic traps are a bit different (check traps.2da)
            if ( nTrapGenType == 4 ){

                //epic fire trap
                nTrapType = 45;
            }
            else if ( nTrapGenType == 5 ){

                //epic electrical trap
                nTrapType = 44;
            }
            else if ( nTrapGenType == 7 ){

                //epic frost trap
                nTrapType = 46;
            }
            else if ( nTrapGenType == 9 ){

                //epic sonic trap
                nTrapType = 47;
            }
            else{

                //take deadly version instead if there's no epic trap of this type
                nTrapType = 3 + ( nTrapGenType * 4 );
            }
        }
        else{

            nTrapType        = nTrapStrength + ( nTrapGenType * 4 );
        }
    }

    //determine size from spawnpoint
    float fTrapSize      = GetLocalFloat( oSpawnpoint, "spt_size" );

    if ( fTrapSize == 0.0 ){

        //default size
        fTrapSize = 2.0;
    }

    string sScript = GetLocalString( oTrigger, "spt_script" );
    string sTag    = GetTag( oTrigger );

    //set trap
    oTrap = CreateTrapAtLocation( nTrapType, lSpawnpoint, fTrapSize, sTag, STANDARD_FACTION_HOSTILE, "ds_disarm", sScript );

    //non recoverable if Epic, else recoverable
    if ( nTrapStrength > 3 ){

        SetTrapRecoverable( oTrap, FALSE );
    }
    else{
        SetTrapRecoverable( oTrap, TRUE );
    }

    //store trap on trigger
    SetLocalObject( oTrigger, "spt_obj", oTrap );

    //store trigger on trap
    SetLocalObject( oTrap, "spt_obj", oTrigger );
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

