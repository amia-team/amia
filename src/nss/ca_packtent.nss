// Conversation action to pack-up the PC tent.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/22/2004 jpavelch         Initial release.
//


void PackupTent( object oPC )
{
    CreateItemOnObject(
        "porttent",
        oPC
    );
}

void main( )
{
    object oPC = GetLastUsedBy( );
    if ( !GetIsPC(oPC) ) return;

    object oTent = OBJECT_SELF;

    AssignCommand(
        oPC,
        ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0)
    );
    DestroyObject( oTent, 3.0 );
    DelayCommand( 3.0, PackupTent(oPC) );
}
