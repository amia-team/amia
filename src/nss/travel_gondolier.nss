/*  travel_coaches

    --------
    Verbatim
    --------
    Amian Carts transport script

    ---------
    Changelog
    ---------

    Date        Name        Reason
    ------------------------------------------------------------------
    07-28-06    Disco       Start of header
    11-10-06    Disco       Fix
    2007-07-22  disco       Can't use the boat while in combat
    ------------------------------------------------------------------


*/

void main(){

    //Get PC
    object oPC = GetPCSpeaker();

    if (  GetIsInCombat( oPC ) ){

        SendMessageToPC( oPC, "[you cannot use this boat while you are in combat!]" );
        return;

    }

    SetLocalString(OBJECT_SELF, "WP_destination", GetScriptParam("Destination"));
    SetLocalObject( oPC, "travel_npc", OBJECT_SELF  );
    FadeToBlack( oPC );
    DelayCommand( 1.0, AssignCommand( oPC, ActionStartConversation( oPC, "travel_gondola", TRUE, FALSE) ) );

}
