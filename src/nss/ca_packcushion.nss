// Conversation action to pack-up the portable cushions.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/14/2004 jpavelch         Initial release.
//


void Packup( object oPC )
{
    CreateItemOnObject(
        "portcushion",
        oPC
    );
}

void main( )
{
    object oPC = GetLastUsedBy( );
    if ( !GetIsPC(oPC) ) return;

    object oSelf = OBJECT_SELF;

    AssignCommand(
        oPC,
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0)
    );
    DestroyObject( oSelf, 3.0 );
    DelayCommand( 3.0, Packup(oPC) );
}
