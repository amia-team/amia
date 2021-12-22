// Converstaion action to take the surface food bundle from a PC.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/12/2004 Artos            Initial release.
//

void main()
{
    object oPC = GetPCSpeaker( );
    object oItem = GetItemPossessedBy( oPC, "FoodBundle" );

    if ( GetIsObjectValid(oItem) )
        DestroyObject( oItem );
}
