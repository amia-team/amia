// Plays a specific voiceset on use.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/29/2011 PaladinOfSune    Initial Release
//

#include "x2_inc_switches"

void ActivateItem()
{
    // Major variables.
    object oPC          = GetItemActivator();

    // Play the voice, speak a little emote.
    AssignCommand( oPC, PlaySound( "vs_nx0headm_atk1" ) );
    AssignCommand( oPC, ActionSpeakString( "*Deep breath*", TALKVOLUME_TALK ) );
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
