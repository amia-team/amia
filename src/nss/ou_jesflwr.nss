// Authors: Jes
// Edit of ou_tarflr (Tarnus and Angelis96)
// 2019
// This script is meant to apply a Level Drain and Blind effect on a PC through interaction with a PLC

// Includes
#include "cs_inc_xp"
#include "amia_include"

// main
void main()
{
    //Get the person who clicked the PLC
    object oTarget = GetLastUsedBy();

    // Create Level Drain effect
    effect eLDrain = EffectNegativeLevel(1);
           eLDrain = SupernaturalEffect(eLDrain);

    effect eBlind = EffectBlindness();

    //Create VFX
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);

    // Message sent to PC
    string sMessage = "A deep sense of sorrow fills you as the defiled flower attempts to sap your energy. For a moment, all you can see is the darkness surrounding you...";

    // Apply VFX
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    // Apply Level Drain/Blind
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLDrain, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, 6.0f);
    // Send Message to PC
    SendMessageToPC(oTarget, sMessage);

}
