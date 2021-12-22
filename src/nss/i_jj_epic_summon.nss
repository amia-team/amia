//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_jj_epic_summon
//description: Used to choose which of the Epic Mummy Dust types will spawn.
//used as: item activation script
//date:    mar 29 2010
//author:  you3507 (James)

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "amia_include"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main() {
 //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName( oItem );
            object oBook     = oItem;

            if (sItemName == "DM Wand of Epic Summon Changing")
            {
                oBook = GetItemByName(oTarget,"Book of Epic Summoning");
            }
                SetLocalObject( oPC, "jj_epic_bookHolder", oTarget );
                SetLocalObject( oPC, "jj_epic_book", oBook );
                SetLocalString( oPC, "ds_action", "jj_book_choose" );
                SetLocalInt( oPC, "ds_check_11", GetIsDM(oPC) );
                AssignCommand(oPC,ActionWait(1.0));
                AssignCommand(oPC,
                   ActionStartConversation(oPC,"c_jj_epic_summon",TRUE));

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

