/*
---------------------------------------------------------------------------------
NAME: fw_portraitchang
Description: This is a simple script that can be used to change portrait.
LOG:
    Faded Wings [12/31/2015 - Born!]
----------------------------------------------------------------------------------
*/

/* includes */
#include "inc_lua"

void main()
{
    object oPC = GetLastSpeaker();
    object oPortraitChanger = OBJECT_SELF;
    int scriptState = GetLocalInt( oPC, "fw_portraitchang" );
    string sLast = GetLocalString( oPC, "last_chat" );

    if( scriptState == FALSE ) {
        SetLocalInt( oPC, "fw_portraitchang", TRUE );
        string sPortrait = GetPortraitResRef( oPC );
        SetCustomToken( 6128, sPortrait );
        DelayCommand( 0.1, ActionStartConversation( oPC, "portraitchanger", TRUE, FALSE ) );
    }

    else if ( scriptState == TRUE ) {
        if( sLast != "" ) {

            DeleteLocalInt( oPC, "fw_portraitchang" );

            if( GetStringLength( sLast ) > 24  ) {
                SendMessageToPC( oPC, "The File Length of this portrait name is too long!" );
                return;
            }
            if( FindSubString( " ", sLast, 0 ) >= 0 )  {
                SendMessageToPC( oPC, "Spaces not allowed in the filename!" );
                return;
            }
            SetPortraitResRef( oPC, sLast );
        }
        else {
            SendMessageToPC( oPC, "You have not entered anything to change the portrait into!" );
            return;
        }
    }
}
