// Conversation action to give the PC a melee magthere token.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/20/2003 jpavelch         Initial Release.
//

void main( )
{
    CreateItemOnObject( "meleemagthereins", GetPCSpeaker() );
}
