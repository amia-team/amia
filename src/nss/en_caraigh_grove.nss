//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  en_caraigh_grove
//group:   utility
//used as: OnEnter script
//date:    aug 05 2007
//author:  disco, modified by PoS... should probably make a local variable-based version of this

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){
    object oPC          = GetEnteringObject();
    string sMessage     = "Upon entering the stone circle, a faint sense of peacefulness washes over you. You feel safe and welcome here, so long as you cause no harm.";

    SendMessageToPC( oPC, sMessage );
}
