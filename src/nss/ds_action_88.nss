/*  ds_action_#

    --------
    Verbatim
    --------
    Performs a generic convo action based on the convo tag

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    22-07-06  Disco       Start of header
    ------------------------------------------------------------------


*/


void main(){

    //Convo node number (same as script number)
    int nNode        = 88;

    //Get PC
    object oPC       = GetPCSpeaker();

    //get action script name
    string sScript   = GetLocalString( oPC, "ds_action" );

    //change number to the number of the script
    SetLocalInt( oPC, "ds_node", nNode );

    //run action script
    ExecuteScript( sScript, oPC );

}
