/*  dg_mt_belhp_init

    --------
    Verbatim
    --------
    Initializes the dg_mt_belhp script in OnConv of the NPC

    ---------
    Changelog
    ---------

    Date        Name        Reason
    ------------------------------------------------------------------
    032008      dg          Initial Release
    ------------------------------------------------------------------


*/

void main(){

    //this script goes in the OnConversation event
    //primary reason to do this is to silence the convo for others
    object oPC = GetLastSpeaker();

    //the action scrip manages all the stuff that needs to be done
    //it's triggered by the ExecuteScript command in de ds_action_x scripts
    SetLocalString( oPC, "ds_action", "dg_mt_belhp" );

    //run the convo
    ActionStartConversation( oPC, "mt_bellhop", TRUE, FALSE );

}
