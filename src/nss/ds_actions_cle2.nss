/*  ds_action_cle2

    --------
    Verbatim
    --------
    Cleans up the generic convo action system after a convo has finished

    Unlike ds_actions_clean, this version actually works properly, but... can't fix the bug in the original script
    without 'breaking' a load of other things.

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    04-15-13  PoS       Start of header
    ------------------------------------------------------------------


*/

void main(){

    //Get PC
    object oPC       = GetPCSpeaker();
    int i;
    string sCheck;

    DeleteLocalInt( oPC, "ds_node" );
    DeleteLocalString( oPC, "ds_action" );
    DeleteLocalInt( oPC, "ds_target" );
    //DeleteLocalObject( oPC, "ds_target" );

    for ( i=1; i<41; ++i ){

        sCheck = "ds_check_" + IntToString( i );

        DeleteLocalInt( oPC, sCheck );

    }

}
