#include "x2_inc_switches"



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
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();


            // Create the effect to apply
            effect eDeath = EffectDeath();

            // Create the visual portion of the effect. This is instantly
            // applied and not persistant with wether or not we have the
            // above effect.
            effect eVis = EffectVisualEffect(VFX_IMP_DEATH);

            // Apply the visual effect to the target
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            // Apply the effect to the object
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);



        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}





