// Speedy Messenger Quest.  Conversation action to give PC gold/xp for
// delivering parcel to Gypsy.
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
    GiveExactXP( oPC, 143, "Quest" );

    object oItem = GetItemPossessedBy( oPC, "parcelgypsy" );
    if ( GetIsObjectValid(oItem) )
        DestroyObject( oItem );
}
