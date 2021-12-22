//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  Gers_Eili_Jail_Info
//group:   utility
//used as: OnEnter script
//date:    aug 05 2007
//author:  disco, modified by Gers

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){
    object oPC          = GetEnteringObject();
    string sMessage     = "You've entered a very well-lit jail area. A somewhat-comfortable looking cell is at one end, and a heavily reinforced door is at the other. The whole area is brightly lit, seemingly designed with thwarting escapees in mind.";

    SendMessageToPC( oPC, sMessage );
}
