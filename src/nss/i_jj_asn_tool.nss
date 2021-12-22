/*  i_jj_asn_tool

--------
Verbatim
--------
Used for the item activation script for the Assassin Secret Guide. It opens the conversation which applies the poison it a weapon.

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2010-03-24   James       Start
2011-01-21   James       Changed the level requirments and script names
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"
//#include "x2_inc_spellhook"
//#include "X0_I0_SPELLS"



//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

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
            location lTarget = GetItemActivatedTargetLocation();
            int nAsnLevels   = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);

            SetLocalString( oPC, "ds_action", "jj_asn_tool" );
            SetLocalInt( oPC, "ds_check_1", nAsnLevels > 1 );
            SetLocalInt( oPC, "ds_check_2", nAsnLevels > 3 );
            SetLocalInt( oPC, "ds_check_3", nAsnLevels > 5 );
            SetLocalInt( oPC, "ds_check_4", nAsnLevels > 7 );
            SetLocalInt( oPC, "ds_check_5", nAsnLevels > 9 );
            SetLocalInt( oPC, "ds_check_6", nAsnLevels > 11 );
            SetLocalInt( oPC, "ds_check_7", nAsnLevels > 13 );
            SetLocalInt( oPC, "ds_check_8", nAsnLevels > 15 );
            SetLocalInt( oPC, "ds_check_9", nAsnLevels > 17 );
            AssignCommand(oPC,ActionWait(1.0));
            AssignCommand(oPC,
               ActionStartConversation(oPC,"c_jj_asn_tool",TRUE));

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
//Definitions
//-------------------------------------------------------------------------------



