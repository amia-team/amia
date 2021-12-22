/*  Amia :: Area :: Functions

    --------
    Verbatim
    --------
    This script handles Area Player Counts and Events.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    013005  jek         Initial release.
    021405  jek         Refactored inc_userdefconst.
    080806  kfw         Optimization.
    ----------------------------------------------------------------------------

*/


/* Includes. */
#include "inc_userdefconst"
//#include "m_variables"



// Get the current PC count - used by ud_attackseas after
// running the standard hook.
//
int GetPlayerCountInSpecificArea(object oArea){

    return( GetLocalInt( oArea, "PlayerCount" ) );

}

int GetPlayerCountInArea( ){

    // Variables.
    object oArea        = OBJECT_SELF;

    return( GetPlayerCountInSpecificArea( oArea ) );

}

// Adds one to the player count.
//
void IncrementPlayerCountInArea( object oArea ){

    // Variables.
    int nCount = GetLocalInt( oArea, "PlayerCount" );
    if( nCount < 0 )
        nCount = 0;

    // Increment.
    ++nCount;
    SetLocalInt( oArea, "PlayerCount", nCount );

    return;

}

// Subtracts one from the player count and despawns all creatures
// if it becomes zero.
//
void DecrementPlayerCountInArea( object oArea ){

    // Variables.
    int nCount = GetLocalInt( oArea, "PlayerCount" );
    if( nCount < 1 )
        nCount = 1;

    // Decrement.
    --nCount;
    SetLocalInt( oArea, "PlayerCount", nCount );

    return;

}


// Add this to the end of any custom OnUsedDefined area default script.
void AreaHandleUserDefinedEventDefault( int nEvent ){

    // Variables.
    object oArea            = OBJECT_SELF;

    // Determine event.
    switch( nEvent ){

        case AREA_PCENTER:  IncrementPlayerCountInArea( oArea );    break;
        case AREA_PCEXIT:   DecrementPlayerCountInArea( oArea );    break;
        default:                                                    break;

    }

    return;

}

// Add this to the end of any custom OnEnter area default script.
void AreaHandleOnEnterEventDefault( object oArea ){

    SignalEvent( oArea, EventUserDefined( AREA_PCENTER ) );

    return;

}

// Add this to the end of any custom OnExit area default script.
void AreaHandleOnExitEventDefault( object oArea ){

    SignalEvent( oArea, EventUserDefined( AREA_PCEXIT ) );

    return;

}
