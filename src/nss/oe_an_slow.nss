//::///////////////////////////////////////////////
//:: OnEnter Trigger Event
//:: oe_an_slow
//:: Anatida 8/5/2015
//:: FadedWings 11/08/2015
//:://////////////////////////////////////////////
/*
Slows the PC for as long as they remain in the trigger.
Pair with script oex_an_remslow to remove the effect!
*/

#include "NW_I0_SPELLS"

void main()
{

    object oPC = GetEnteringObject();

    // vfx
    effect eSlow = EffectSlow();
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eLink = EffectLinkEffects( eSlow, eVis );

    if (!GetIsPC(oPC)) return;

    //If still under slow effect from previous trigger, remove to prevent overlap/removals
    effect eRemove = GetFirstEffect( oPC );
    object oCreator = GetEffectCreator( eRemove );
    string sCreator = GetTag( oCreator );

    while( GetIsEffectValid( eRemove ) )
    {
        oCreator = GetEffectCreator( eRemove );
        sCreator = GetTag( oCreator );
        if( GetSubString(sCreator, 0, 12) == "pos_bogwater" )
        {
            RemoveEffect( oPC, eRemove );
        }
        eRemove = GetNextEffect (oPC);
    }

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}
