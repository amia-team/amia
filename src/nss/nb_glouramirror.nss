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


//Put this script OnUsed
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

    // Already taken
    if( GetPCKEYValue( oPC, "qst_gloura" ) > 0 ){

        return;

    }

    // Gloura is already nearby, bug out
    if(GetNearestObjectByTag(
        "nb_glouraboss",
        oPC,
        1)!=OBJECT_INVALID){

        return;

    }

    // Already completed
    if (GetItemPossessedBy(oPC, "nb_jhianna")!= OBJECT_INVALID)
        return;

    // Initiate Gloura Quest
    ActionStartConversation(oPC, "c_glouraquest1");

}

