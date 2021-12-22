#include "x2_inc_switches"

void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oWaypoint = GetObjectByTag( "WP_straightjacket" );
            object oArea     = GetArea( oPC );

            if ( GetTag( oArea ) == "amia_entry" ){
                AssignCommand( oPC, JumpToObject( oWaypoint ) );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

