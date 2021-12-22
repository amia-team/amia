//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  Gers_Eili_Beds_Info
//group:   utility
//used as: OnEnter script
//date:    aug 05 2007
//author:  disco, modified by Gers

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){
    object oPC          = GetEnteringObject();
    string sMessage     = "This entry appears to be collapsed and cannot be used.";

    SendMessageToPC( oPC, sMessage );
}
