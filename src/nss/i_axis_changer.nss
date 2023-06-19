/*  i_axis_changer

--------
Verbatim
--------
Changes the axis of the target (currently only Z and set for pc, assosiates, bc's)

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2023-06-19   Frozen      created
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void change_axis(object oPC, object oItem, object oTarget);

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

            if ( GetResRef( oItem ) == "axis_changer" ){

                change_axis( oPC, oItem, oTarget );
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void change_axis(object oPC, object oItem, object oTarget){

    int    nLogic;
    int    nLock     = GetLocalInt   ( oItem, "zaxis_lock" );
    int    nZset     = GetLocalInt   ( oItem, "zaxis_setting"  );
    float  fZdefault = 0.0;
    float  fZSet;
    float  fZcurrent = GetObjectVisualTransform  (oTarget, 33);
    string sTag      = GetTag ( oTarget );

        // Defining hight to set
        if ( nZset == 0 ) { SetLocalInt ( oItem, "zaxis_setting", 1 ); }
        if ( nZset == 1 ) {fZSet = GetLocalFloat ( oItem, "zaxis_set1" );
            if ( fZSet == 0.0 ) { fZSet = 0.5; } }
        if ( nZset == 2 ) {fZSet = GetLocalFloat ( oItem, "zaxis_set2" );
            if ( fZSet == 0.0 ) { fZSet = 1.0; } }
        if ( nZset == 3 ) {fZSet = GetLocalFloat ( oItem, "zaxis_set3" );
            if ( fZSet == 0.0 ) { fZSet = 1.5; } }
					
        // Logic part, to assigne right function
        if ( oTarget == oItem )                             { nLogic = 1; } // Changing hight setting
        else if ( oTarget == oPC )                          { nLogic = 2; } // PC
        else if ( sTag == "ds_npc_"+GetPCPublicCDKey( oPC )){ nLogic = 2; } // Bottled companion
        else if ( oTarget == GetAssociate(1, oPC, 1))       { nLogic = 2; } // Henchman
        else if ( oTarget == GetAssociate(2, oPC, 1))       { nLogic = 2; } // Animal Companion
        else if ( oTarget == GetAssociate(3, oPC, 1))       { nLogic = 2; } // Familiar
        else if ( oTarget == GetAssociate(4, oPC, 1))       { nLogic = 2; } // Summon
        else if ( oTarget == GetAssociate(5, oPC, 1))       { nLogic = 2; } // Dominated
        else                                                { nLogic = 3; FloatingTextStringOnCreature(( "<cÉ  >You only use this on yourself, the widget, or an associate..</c>" ), oPC, FALSE ); return; }

    // Changing Hight setting
    if ( nLogic == 1 ) {
        if (nLock == 1 ) { FloatingTextStringOnCreature(( "<cÉ  >You can not change the hight settings on this widget.</c>" ), oPC, FALSE ); return; }
        else {
            if ( nZset == 0 || nZset == 1 ) { SetLocalInt ( oItem, "zaxis_setting", 2 ); FloatingTextStringOnCreature(( "<c Û >Hight Set to medium,</c>" ), oPC, FALSE ); return; }
            else if ( nZset == 2 )          { SetLocalInt ( oItem, "zaxis_setting", 3 ); FloatingTextStringOnCreature(( "<c Û >Hight Set to High,</c>" ), oPC, FALSE ); return; }
            else if ( nZset == 3 )          { SetLocalInt ( oItem, "zaxis_setting", 1 ); FloatingTextStringOnCreature(( "<c Û >Hight Set to low,</c>" ), oPC, FALSE ); return; }
        }
    }
    else if ( nLogic == 2 ) {
        if ( fZcurrent != 0.0 ) { SetObjectVisualTransform ( oTarget, 33, fZdefault ); } //Changes you to defaut if your already afloat
        else { SetObjectVisualTransform( oTarget, 33, fZSet ); } //Changes the set hight
    }
}
