// OnUsed event of the personal campfire.  Destroys the campfire object
// and creates a tinder box item in the PCs inventory.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/16/2004 jpavelch         Initial Release.
//


void CreateTinderBox( object oPC )
{
    CreateItemOnObject( "tinderbox", oPC );
}

void main( )
{
    object oPC = GetLastUsedBy( );
    if ( !GetIsPC(oPC) ) return;

    object oCampfire = OBJECT_SELF;

    AssignCommand(
        oPC,
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0)
    );

    DestroyObject( oCampfire, 3.0 );
    DelayCommand( 3.0, CreateTinderBox(oPC) );
}
