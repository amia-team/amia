// Conversation conditional to see if PC has swamp gator skin.  Going rate
// is 50gp and 25xp.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/01/2004 jpavelch         Initial release.
//

#include "cs_inc_xp"

int StartingConditional( ){

    object oPC = GetPCSpeaker( );

    SpeakString( "Lemme see what ye got..." );

    object oItem = GetFirstItemInInventory( oPC );
    int nResult  = FALSE;

    while ( GetIsObjectValid( oItem ) == TRUE ){

        if ( GetTag( oItem ) == "SwampGatorSkin" ){

            GiveCorrectedXP( oPC, 25, "Job" );
            GiveGoldToCreature( oPC, 50 );
            DestroyObject( oItem, 1.0 );



            nResult = TRUE;
        }

        oItem = GetNextItemInInventory( oPC );
    }

    return TRUE;
}
