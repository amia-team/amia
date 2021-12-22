//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  gers_eili_librar
//group:   utility
//used as: OnEnter script
//date:    aug 05 2007
//author:  disco, modified by Gers

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){
    object oPC          = GetEnteringObject();
    string sMessage     = "Looking about, you find yourself in a well-appointed library. Numerous artifacts and objects d'art from the Underdark and other strange places adorn the shelves and walls.";

    SendMessageToPC( oPC, sMessage );
}
