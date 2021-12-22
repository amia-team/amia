//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  Gers_Eili_Cave_Farm
//group:   utility
//used as: OnEnter script
//date:    aug 05 2007
//author:  disco, modified by Gers

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){
    object oPC          = GetEnteringObject();
    string sMessage     = "Looking inside the cave, you notice that it appears to hold a small subterranean farm. There's several varieties of edible mushrooms growing, as well as a small pond that looks to be stocked with fish. Several Dark Elves are going about tending things, and a golem watches over the area within.";

    SendMessageToPC( oPC, sMessage );
}
