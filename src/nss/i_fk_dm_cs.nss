/*  i_fk_dm_cs
--------
Verbatim
--------
Pools custom item request scripts
---------
Changelog
---------
Date         Name        Reason
------------------------------------------------------------------
2010-11-08   Bruce       Start
------------------------------------------------------------------
A DM item to set a custom spell ID to active for testing

*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------

#include "x2_inc_switches"
#include "x0_i0_position"

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

          AssignCommand( oPC, ClearAllActions(TRUE));
          AssignCommand( oPC, ActionStartConversation( oPC, "fk_cust_spell", TRUE, FALSE ) );
          break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//Definitions
//-------------------------------------------------------------------------------


