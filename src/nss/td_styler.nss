//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  td_styler
//group:   Appearance changing
//used as: conversation initilazation
//date:    08/06/08
//author:  Terra


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
void main()
{

            //int iPrice = 0;
            //SetCustomToken(7002, IntToString(0));
            object oPC = GetLastSpeaker();
            clean_vars( oPC, 4 );

            int iOk = 1;
            {
            SetLocalInt( oPC, "ds_check_20", 1 );
            }

            //set action script
            SetLocalString( oPC, "ds_action", "td_action_styler" );
            SetLocalObject( oPC, "ds_target", OBJECT_SELF );

            string sFirstLine = "";

                //Its a hair dyer
                if ( GetLocalInt( OBJECT_SELF, "td_dyer_type" ) == 1 )
                {
                SetLocalInt( oPC, "ds_check_1", iOk );

                switch( d3() )
                {
                case 1:sFirstLine = "Greetings, would you fancy your hair dyed? I'll do it for free!";break;
                case 2:sFirstLine = "Hello! Looking to get your hair dyed? I'll dye it for you.";break;
                case 3:sFirstLine = "Hey and welcome! Can dye your hair here!";break;
                }

                SetCustomToken(7000, sFirstLine);
                }

                // Tattooist
                if ( GetLocalInt( OBJECT_SELF, "td_dyer_type" ) == 2 )
                {
                SetLocalInt( oPC, "ds_check_2", iOk );

                switch( d3() )
                {
                case 1:sFirstLine = "Greetings! And welcome to my tattoo shop, I can modify your tattoos!";break;
                case 2:sFirstLine = "Hello! Professional tattooist, I'll fix your tattoos free! Nice deal indeed!";break;
                case 3:sFirstLine = "Hey and welcome! What can I do for you today? I can modify your tattoos!";break;
                }
                SetCustomToken(7000, sFirstLine);
                }

                // Default both
                if ( GetLocalInt( OBJECT_SELF, "td_dyer_type" ) == 0 )
                {
                SetLocalInt( oPC, "ds_check_3", iOk );

                switch( d3() )
                {
                case 1:sFirstLine = "Greetings! And welcome to my styling shop, what can I do for you? Dyes and tattoos are all free!";break;
                case 2:sFirstLine = "Hello! Professional stylist, what can I do for you this fine day? I can change your hair and tattoos if you like!";break;
                case 3:sFirstLine = "Hey and welcome! I can remake your tattoos or dye your hair if you wish!";break;
                }
                SetCustomToken(7000, sFirstLine);
                }
    AssignCommand( OBJECT_SELF, ActionStartConversation( oPC, "td_styler", TRUE, FALSE ) );
}

