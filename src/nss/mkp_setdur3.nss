// Make placeables.  Conversation to set the duration.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/25/2004 jpavelch         Initial release.
//

void main( )
{
    object oWand = GetLocalObject( GetPCSpeaker(), "MKP_Wand" );
    SetLocalFloat( oWand, "MKP_Duration", 180.0 );
}
