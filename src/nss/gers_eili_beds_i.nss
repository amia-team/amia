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
    string sMessage     = "Through the doorway to your side, you can see quite a few other rooms down a long hallway. Apparently, this is where the majority of the Shrine's residents live.";

    SendMessageToPC( oPC, sMessage );
}
