/*  Area :: On Enter2 :: Executes with OBJECT_SELF As Player Character

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    ??????  shir'le     SEI Initial Release [Deprecated].
    011004  jpevelch    Added user-defined event call.
    013005  jking       Hook standard call.
    040205  jking       Added Connections Management.
    121005  kfw         Gutted SEI. Added True Races vulnerability handling.
    122205  kfw         Map Reveal: Checks Integer variabl: CS_MAP_REVEAL equal to 1, to unfog.
    031906  kfw         Code optimization.
    052006  kfw         Code optimization and bug fix: Improved Effect precision.
    062206  kfw         Bug fix. Bioware functions not working correctly.
    082206  kfw         Added light sensitivity support for Shadow Elf.
  20070822  Disco       Added functions for testing
  20071118  Disco       Libbed
  20090506  Disco       Added job system
    ----------------------------------------------------------------------------

    --------
    Verbatim
    --------
    This script executes whenever a player enters an area.
    Specifically this script will check and verify any light penalties due to player characters.

*/

/* Includes. */
#include "area_constants"
#include "inc_ds_records"
#include "inc_ds_j_lib"


void main( ){

    // Variables.
    object oArea        = OBJECT_SELF;
    object oPC          = GetEnteringObject( );

    // Bug out on non-PC
    if( !GetIsPC( oPC ) ){

        return;
    }

    DelayCommand( 1.0, ds_j_SpawnTarget( oPC, oArea ) );

    /* Area Management. */
    db_onTransition( oPC, oArea );

    AreaHandleOnEnterEventDefault( oArea );

    return;

}
