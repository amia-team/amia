/*  ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
2007-11-19  disco       Uses PCKEY system now
    ----------------------------------------------------------------------------
*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//Put this on action taken in the conversation editor
void main(){

    object oPC = GetPCSpeaker();

    GiveCorrectedXP( oPC, 500, "Quest", 0 );

    GiveGoldToCreature( oPC, 2000 );

    UpdateModuleVariable( "QuestGold", 2000 );

    CreateItemOnObject( "nb_jhianna", oPC );

    ds_quest( oPC, "qst_gloura", 2 );

}

