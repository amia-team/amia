//::///////////////////////////////////////////////
//:: x2_s2_whirl.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Performs a whirlwind or improved whirlwind
    attack.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-20
//:://////////////////////////////////////////////
//:: Updated By: GZ, Sept 09, 2003
//:: Updated By: Glim, July 20, 2012
//:: Updated By: Maverick, 12/8/21 Added in some special abyssal ability functionality (See abyssal_ability)


#include "X0_I0_SPELLS"
#include "inc_td_shifter"
#include "x2_inc_spellhook"

void main()
{
    int bImproved = (GetSpellId() == 645);// improved whirlwind
    object oPC = OBJECT_SELF;
    object oWidget = GetItemPossessedBy(oPC,"ds_pckey");
    string sBodyPart = GetLocalString(oWidget, "abyssalBodyPart");
    effect eTrip = EffectKnockdown();
    effect eExplode = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDamage;
    int nAbyssalLevel = GetLevelByClass(55,oPC);

    /* Play random battle cry, unless target it dancing! */
    if (GetItemPossessedBy(OBJECT_SELF, "glm_discofever") == OBJECT_INVALID)
    {
        int nSwitch = d10();
        switch (nSwitch)
        {
            case 1: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
            case 2: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
            case 3: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
        }
    }

    // * GZ, Sept 09, 2003 - Added dust cloud to improved whirlwind
    if (bImproved)
    {
      effect eVis = EffectVisualEffect(460);
      DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,OBJECT_SELF));
    }

    /* If normal feat use, give Feedback, otherwise if dancing, no feedback */
    if ((sBodyPart == "tail") && (GetItemPossessedBy(OBJECT_SELF, "glm_discofever") == OBJECT_INVALID)) // Abyssal Ability
    {
        DoWhirlwindAttack(FALSE, TRUE);
        effect eVis2 = EffectVisualEffect(460);
        DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis2,OBJECT_SELF));

     location lTarget = GetLocation(oPC);
     object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
     FloatingTextStringOnCreature("*You whirl around swinging your tail at your foes*",oPC);

     while(GetIsObjectValid(oTarget))
     {
       if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && (oTarget != oPC))
       {
          //Get the distance between the explosion and the target to calculate delay
          float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
          if (d20() + GetAbilityModifier(ABILITY_STRENGTH, oTarget) <= 3*nAbyssalLevel + d20() )
          {
            int nRandom = Random(4*nAbyssalLevel)+1;
            eDamage = EffectDamage(nRandom,DAMAGE_TYPE_BLUDGEONING);
            // Apply effects to the currently selected target.
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 6.0));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
          }
       }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     }

    }
    else if (GetItemPossessedBy(OBJECT_SELF, "glm_discofever") == OBJECT_INVALID)
    {
        DoWhirlwindAttack(TRUE,bImproved);
    }
    if (GetItemPossessedBy(OBJECT_SELF, "glm_discofever") != OBJECT_INVALID)
    {
        DoWhirlwindAttack(FALSE, FALSE);
    }
    // * make me resume combat

}
