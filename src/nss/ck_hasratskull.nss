// Conversation conditional to check if PC has any rat skulls.  Going rate
// is 5gp and 3xp.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/01/2004 jpavelch         Initial release.
//

#include "cs_inc_xp"

int StartingConditional( ){

    object oPC = GetPCSpeaker( );

    object oSkull = GetItemPossessedBy( oPC, "shipratskull" );

    if ( !GetIsObjectValid ( oSkull ) ){

        return FALSE;
    }

    int nXP = 25 - ( 3 * GetHitDice( oPC ) );

    if ( nXP < 1 ){

        nXP = 1;
    }

    GiveCorrectedXP( oPC, nXP, "Job" );

    GiveGoldToCreature( oPC, 10 );

    DestroyObject( oSkull );

    return TRUE;
}
