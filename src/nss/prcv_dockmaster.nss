//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT2
/*
  Default OnPerception event handler for NPCs.

  Handles behavior when perceiving a creature for the
  first time.
 */
//:://////////////////////////////////////////////////

#include "nw_i0_generic"

void main()
{
    object oPC = GetLastPerceived( );
    if ( GetIsPC(oPC) && GetHitDice(oPC) <= 2 ) {
        TurnToFaceObject( oPC );
        PlayVoiceChat( VOICE_CHAT_TALKTOME );
    }
}
