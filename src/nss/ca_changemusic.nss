// Plays some happy bard music..
//
// Revision History
// Date        Name               Description
// ----------  ------------------ ------------------------------------------
// 07/31/2003  Artos              Initial Release
//


// Prototypes
void PlayBardMusic( object oPC, int nTrack );



void PlayBardMusic( object oPC, int nTrack )
{
    if ( !GetIsPC(oPC) ) return;

    // Takes 1 gold from pc to pay the piper!
    TakeGoldFromCreature( 1, oPC, TRUE );

    object oArea = GetArea( oPC );

    MusicBackgroundChangeDay( oArea, nTrack );
    MusicBackgroundChangeNight( oArea, nTrack );
}
