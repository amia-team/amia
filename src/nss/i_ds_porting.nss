//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_mod_portal
//group: core stuff
//used as: activation script
//date:  2008-06-06
//author: Disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_porting"
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
    object oPC;
    object oItem;
    object oTarget;
    location lTarget;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            oPC       = GetItemActivator();
            oItem     = GetItemActivated();
            oTarget   = GetItemActivatedTarget();

            // Check if this area prevents use of the Rod of Porting.
            object oArea = GetArea( oPC );

            //strip any remaining action variables
            clean_vars( oPC, 4 );

            //fix old wands
            if ( GetLocalInt( oItem, "p_fixed" ) != 1 ){

                itemproperty iNew = ItemPropertyCastSpell( 335, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE );

                IPSafeAddItemProperty( oItem, iNew, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE );

                SetItemCharges( oItem, ( GetItemCharges( oItem ) + 1 ) );

                SetLocalInt( oItem, "p_fixed", 1 );
            }

            // resolve area porting status
            if ( GetLocalInt( oArea, "PreventRodOfPorting" ) == 1 &&
                !GetIsDM( oPC ) &&
                 GetLocalInt( GetModule(), "testserver" ) != 1 ){

                // warn the player
                SendMessageToPC( oPC, "You cannot use the Rod of Porting in this area!" );

                return;
            }
            else{

                SetLocalObject( oPC, "p_wand", oItem );

                port_init_porting( oPC );
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
