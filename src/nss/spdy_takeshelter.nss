// Speedy Messenger Quest.  Conversation action to give PC gold/xp for
// delivering parcel to Plague Shelter.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/25/2003 jpavelch         Initial release.
//
#include "cs_inc_xp"

void main()
{
    object oPC = GetPCSpeaker( );

    GiveGoldToCreature( oPC, 143 );
    GiveExactXP( oPC, 143 );

    object oItem = GetItemPossessedBy( oPC, "parcelshelter" );
    if ( GetIsObjectValid(oItem) )
        DestroyObject( oItem );
}
