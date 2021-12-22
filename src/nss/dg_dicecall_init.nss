void main(){

    //this script goes in the Rest convo
    object oPC = GetPCSpeaker();

    //the action scrip manages all the stuff that needs to be done
    //it's triggered by the ExecuteScript command in de ds_action_x scripts
    SetLocalString( oPC, "ds_action", "dg_dice_call" );

    //run the convo
    ActionStartConversation( oPC, "dg_dicebag", TRUE, FALSE );

}
