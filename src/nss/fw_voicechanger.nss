/*
---------------------------------------------------------------------------------
NAME: fw_voicechanger
Description: This is a simple script that can be used to change portrait.
LOG:
    Faded Wings [12/31/2015 - Born!]
----------------------------------------------------------------------------------
*/

/* includes */
#include "nwnx_creature"

void main()
{
    object oPC = GetLastSpeaker();
    object oPortraitChanger = OBJECT_SELF;
    int scriptState = GetLocalInt( oPC, "fw_voicechanger" );
    string sLast = GetLocalString( oPC, "last_chat" );
    int iVoiceSet = NWNX_Creature_GetSoundset ( oPC );

    if( scriptState == FALSE ) {
        SetLocalInt( oPC, "fw_voicechanger", TRUE );
        SetCustomToken( 6129, IntToString( iVoiceSet ) );
        SendMessageToPC( oPC, "Debug: You are using voice set #"+ IntToString( iVoiceSet )+"." );
    }

    else if ( scriptState == TRUE ) {
        if( sLast != "" ) {

            DeleteLocalInt( oPC, "fw_voicechanger" );

            int newVoice = StringToInt( sLast );

            if ( newVoice > 1000 ) {
                SendMessageToPC( oPC, "Invalid voiceset id selection." );
                return; // no more than 1000 voices for now
            }

            if( GetStringLength( sLast ) > 4  ) {
                SendMessageToPC( oPC, "The length of this voiceset id is too long!" );
                return;
            }
            if( FindSubString( " ", sLast, 0 ) >= 0 )  {
                SendMessageToPC( oPC, "Spaces not allowed in the voiceset id!" );
                return;
            }
            NWNX_Creature_SetSoundset ( oPC , newVoice );
        }
        else {
            SendMessageToPC( oPC, "You have not entered anything to change the voiceset into!" );
            return;
        }
    }
}
