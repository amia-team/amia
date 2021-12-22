/*  ds_action_clean

    --------
    Verbatim
    --------
    Cleans up the generic convo action system after a convo has finished

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    22-10-06  Disco       Start of header
    ------------------------------------------------------------------


*/

void main(){

    //Get PC
    object oPC       = GetPCSpeaker();
    int i;
    string sCheck;

    DeleteLocalInt( oPC, "ds_node" );
    DeleteLocalInt( oPC, "ds_action" );
    DeleteLocalInt( oPC, "ds_target" );
    //DeleteLocalObject( oPC, "ds_target" );

    for ( i=1; i<112; ++i ){

        sCheck = "ds_check_" + IntToString( i );

        DeleteLocalInt( oPC, sCheck );

    }

}
