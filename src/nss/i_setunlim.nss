/////////////////////////////////////////////////////////////////////////////////////////////////
//This script it to replace a x/day unique self to unlimited/day unique self (mainly intended  //
//for use on widgets that are now replaced with unlimited usage, without need to remake them   //
//created by Frozen-ass                                                                        //
//date: 01-11-2022                                                                             //
//                                                                                             //
//	-	11-march-2023	-	Frozen	- Changed script to now cater self and target              //
/////////////////////////////////////////////////////////////////////////////////////////////////

#include "x2_inc_switches"
#include "x2_inc_itemprop"


void main(){

    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:


            object oTarget   = GetItemActivatedTarget();
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated ();
            string sResRef   = GetResRef (oItem);


            if (sResRef == "setunlim_self"){

                 itemproperty iNew = ItemPropertyCastSpell( 335, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE );
                 IPSafeAddItemProperty( oTarget, iNew, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE );

                 AssignCommand( oPC, SpeakString( "<c Û >Changed: ~</c>" +GetName ( oTarget ) + "<c Û >~ to unlimited uses self</c>" ) );
            }
            else if (sResRef == "setunlim_target"){

                 itemproperty iNew = ItemPropertyCastSpell( 329, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE );
                 IPSafeAddItemProperty( oTarget, iNew, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE );

                 AssignCommand( oPC, SpeakString( "<c Û >Changed: ~</c>" +GetName ( oTarget ) + "<c Û >~ to unlimited uses self</c>" ) );
            }
        break;
    }

}
