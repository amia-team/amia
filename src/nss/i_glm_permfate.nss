/* Permute Fate - Custom Ability - Ulrik Valis (Nivo)

This ability applies either a +4 bonus to all Saves and Skills to Friendly or
Neutral targets, or applies a -4 penalty to all Saves and Skills to Hostiles.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
04/19/12 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"
#include "nw_i0_spells"
#include "x2_inc_toollib"

void ActivateItem(){

    object oPC            = GetItemActivator();
    object oTarget        = GetItemActivatedTarget();
    string sFriendly      = "You spin the fate around your ally, bolstering their good fortune.";
    string sHostile       = "You spin the fate around your enemy, drawing bad fortune to them.";
    effect eBonusVFX      = EffectVisualEffect(VFX_DUR_AURA_PULSE_BLUE_WHITE);
    effect ePenaltyVFX    = EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_WHITE);
    effect eBonusSAVES    = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
    effect eBonusSKILLS   = EffectSkillIncrease(SKILL_ALL_SKILLS, 4);
    effect ePenaltySAVES  = EffectSavingThrowDecrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
    effect ePenaltySKILLS = EffectSkillDecrease(SKILL_ALL_SKILLS, 4);
    int    nPillar        = VFX_IMP_MAGICAL_VISION;

    //Apply visual effect to widget activator
    TLVFXPillar( nPillar, GetLocation( oPC ), 5, 0.1f,2.0f, 0.3f);

    //Check if the target is hostile and apply effect
    if (GetIsEnemy(oTarget, oPC) == TRUE){
        SendMessageToPC(oPC, sHostile);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenaltySAVES, oTarget, 24.0f);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenaltySKILLS, oTarget, 24.0f);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenaltyVFX, oTarget, 24.0f);
    }

    //Else check if the target is friendly and apply effect
    else if (GetIsFriend(oTarget, oPC) == TRUE){
        SendMessageToPC(oPC, sFriendly);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonusSAVES, oTarget, 24.0f);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonusSKILLS, oTarget, 24.0f);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonusVFX, oTarget, 24.0f);
    }

    //Else check if the target is neutral and apply effect
    else if (GetIsNeutral(oTarget, oPC) == TRUE){
        SendMessageToPC(oPC, sFriendly);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonusSAVES, oTarget, 24.0f);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonusSKILLS, oTarget, 24.0f);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonusVFX, oTarget, 24.0f);
    }
    //Debug
    else{
        SpeakString("Failed to recognize target.", TALKVOLUME_TALK);
    }

}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
