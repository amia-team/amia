//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  Gers_Eili_Hall_I
//group:   utility
//used as: OnEnter script
//date:    aug 05 2007
//author:  disco, modified by Gers

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){
    object oPC          = GetEnteringObject();
    string sMessage     = "Before you seems to be the main hall of the Eilistraeen residence. A fountain splashes merrily ahead, while other areas seem to branch off in all directions. It's softly lit by shimmering faerie-fire 'torches,' and seems quite comfortable, rather than cave-like.";

    SendMessageToPC( oPC, sMessage );
}
