// Conversation conditional to check if PC has any rat ears.  Going rate
// is 25 gp and X xp.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/01/2004 jpavelch         Initial release.
//

#include "cs_inc_xp"

int StartingConditional( ){

    object oPC = GetPCSpeaker( );

    object oEar = GetItemPossessedBy( oPC, "rua_rat_ear" );

    if ( !GetIsObjectValid ( oEar ) ){

        return FALSE;
    }

    int nXP = 25 - ( 3 * GetHitDice( oPC ) );

    if ( nXP < 1 ){

        nXP = 1;
    }

    GiveCorrectedXP( oPC, nXP, "Quest", 0 );

    GiveGoldToCreature( oPC, 25 );

    DestroyObject( oEar );

    return TRUE;
}
