// Make placeables.  Conversation action to set the state of the wand to
// create a shaft of light.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/25/2004 jpavelch         Initial release.
//

void main( )
{
    object oWand = GetLocalObject( GetPCSpeaker(), "MKP_Wand" );
    SetLocalInt( oWand, "MKP_State", 1 );
}
