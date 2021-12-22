// Dragon strike, spawns a dragon with a fancy entrance
//  20071119  disco       Removed CS_ tags

/* Includes. */
#include "amia_include"


// function prototypes
void SpawnFancyDragon(object oPC, string szDragon,location lDest);

void main(){

    // vars
    object oTrigger = OBJECT_SELF;
    object oPC      = GetEnteringObject();

    // resolve respawn status
    if ( GetIsBlocked( oTrigger ) < 1 ){

        SetBlockTime( oTrigger, 15 );

        // encounter failure
        if( d100() < 40 ){

            //testing
            //SendMessageToPC( oPC, "[test: you failed your spawn chance roll.]" );

            return;
        }
    }
    else{

        //testing
        //SendMessageToPC( oPC, "[test: trigger is still time blocked.]" );

        return;
    }

    string szDragon = GetLocalString( oTrigger, "cs_dragon" );

    // seek out the dragon waypoint destination
    object oDest = GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_WAYPOINT );

    while( oDest != OBJECT_INVALID ){

        if ( GetTag( oDest ) == "cs_dragon_wp" ){

            break;
        }

        oDest = GetNextInPersistentObject( oTrigger, OBJECT_TYPE_WAYPOINT );
    }

    int nDragonVfx = GetLocalInt( oTrigger, "cs_dragon_vfx" );

    // resolve dragon and vfx status
    if( ( szDragon == "" )  || ( oDest == OBJECT_INVALID )  || ( nDragonVfx < 0 ) ){

        //testing
        SendMessageToPC( oPC, "[test: missing variables.]" );

        return;
    }

    location lDest          = GetLocation( oDest );
    effect eShake           = EffectVisualEffect( 356 );
    effect eDebris          = EffectVisualEffect(nDragonVfx);
    effect eDragonStrike    = EffectLinkEffects( eShake, eDebris );

    // cycle for 6 objects within the trigger, and apply candy vfx to them
    int nLimit      = 0;
    float fDelay    = 0.0;
    object oCandy   = GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_PLACEABLE );

    while ( oCandy != OBJECT_INVALID ){

        // exit after 6th object
        if ( nLimit > 6 ){

            break;
        }

        // display vfxs for 2 seconds
        DelayCommand( fDelay, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eDragonStrike, GetLocation(oCandy), 2.0));

        nLimit++;
        fDelay += 1.0;

        oCandy = GetNextInPersistentObject( oTrigger, OBJECT_TYPE_PLACEABLE );
    }

    //testing
    SendMessageToPC( oPC, "[test: spawning creature.]" );

    // spawn the dragon in 6 seconds
    DelayCommand( 6.0, SpawnFancyDragon( oPC, szDragon, lDest ) );

    return;
}

// function definitions
void SpawnFancyDragon( object oPC, string szDragon,location lDest ){

    object oCritter = ds_spawn_critter( oPC, szDragon, lDest, TRUE );

    log_to_exploits( oPC, "Spawned "+GetName( oCritter ), GetName( GetArea( oPC ) ) );

    return;

}
