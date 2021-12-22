/*  bh_ass_onhit

--------
Verbatim
--------
Replaced onHit Intelligent Item to activate assassin poison

BH
Moved old x2_s3_intitemijc here so it avoids the spellcraft check

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2010-03-24   James       Start
2016-01-02   BasicHuman  Fix spellcraft
------------------------------------------------------------------

*/

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "jj_asn_include"

void main()
{
  // Get Caster Level
  int nLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF);
  // Assume minimum caster level if variable is not found
  if (nLevel== 0)
  {
     nLevel =1;
  }
  int nBlocked = GetIsBlocked(OBJECT_SELF, "AssassinBlock");
  SendMessageToPC(OBJECT_SELF,IntToString(nBlocked));
  if (nBlocked)
  {
    return;
  }
  SendMessageToPC(OBJECT_SELF, "Attempting tactic");
  object oTarget = GetLocalObject(OBJECT_SELF, "assn_tl_otarget");
  //string textString = ObjectToString(oTarget);
  //FloatingTextStringOnCreature("1. oTarget is " + textString, OBJECT_SELF, FALSE);
  object oTargetEffect = oTarget;
  //string textString2 = ObjectToString(oTargetEffect);
  //FloatingTextStringOnCreature("2. oTargetEffect is " + textString2, OBJECT_SELF, FALSE);
  if (GetIsImmune(oTarget,IMMUNITY_TYPE_SNEAK_ATTACK))
  {
    SendMessageToPC(OBJECT_SELF, "Target immune");
    return;
  }

  SetBlockTime( OBJECT_SELF , ASSASSIN_BLOCK_TIME, 0, "AssassinBlock" );


  int nType = GetLocalInt(OBJECT_SELF,"ASSASSIN_POISON");
  int nDC = 10 + nLevel + GetAbilityModifier(ABILITY_INTELLIGENCE);
  object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
  int nSaveType = SAVING_THROW_TYPE_EVIL;
/*  if (IPGetIsRangedWeapon(oItem)) //Ranged Weapons can work but at a -5 penalty
    nDC = nDC - 5;
*/
  int bSaved = 1;
  int nCurse = d4(); //Doing this here for ease.
  effect eEffect;
  float fDuration;
  switch(nType)
  {
    case ASSASSIN_POISON_IMMOBILZE:
         bSaved = WillSave(oTarget,nDC,nSaveType);
         eEffect = EffectParalyze();
         // creatures immune to paralzation are still prevented from moving
         if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) ||
            GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
         {
            eEffect = EffectCutsceneImmobilize();
         }
         eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED),eEffect);
         fDuration = RoundsToSeconds(nLevel);
    break;
    case ASSASSIN_POISON_STUN:
         bSaved = WillSave(oTarget,nDC,nSaveType);
         eEffect = EffectStunned();
         eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED),eEffect);
         fDuration = RoundsToSeconds(2);
    break;
    case ASSASSIN_POISON_DEAFNESS:
         bSaved = FortitudeSave(oTarget,nDC,nSaveType);
         eEffect = EffectDeaf();
         eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE),eEffect);
         fDuration = RoundsToSeconds(nLevel);
    break;
    case ASSASSIN_POISON_BLINDNESS:
         bSaved = FortitudeSave(oTarget,nDC,nSaveType);
         eEffect = EffectBlindness();
         eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE),eEffect);
         fDuration = RoundsToSeconds(nLevel);
    break;
    case ASSASSIN_POISON_KNOCKDOWN:
         bSaved = ReflexSave(oTarget,nDC,nSaveType);
         eEffect = EffectKnockdown();
         fDuration = RoundsToSeconds(nLevel/3);
    break;
    case ASSASSIN_POISON_SILENCE:
         bSaved = FortitudeSave(oTarget,nDC,nSaveType);
         eEffect = EffectSilence();
         eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE),eEffect);
         fDuration = RoundsToSeconds(nLevel);
    break;
    case ASSASSIN_POISON_CURSE:
         bSaved = WillSave(oTarget,nDC,nSaveType);
         eEffect = EffectCurse(nCurse,nCurse,nCurse,nCurse,nCurse,nCurse);
         eEffect = SupernaturalEffect(eEffect);
         if (bSaved == 0)
         {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);
         }
         bSaved = 3;
    break;
    case ASSASSIN_POISON_LEVELDRAIN:
         bSaved = FortitudeSave(oTarget,nDC,nSaveType);
         eEffect = EffectNegativeLevel(1);
         if (bSaved == 0)
         {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffect,oTarget);
         }
         bSaved = 3;
    break;
    case ASSASSIN_POISON_DEATH:
        bSaved = FortitudeSave(oTarget,nDC,nSaveType);
        eEffect = SupernaturalEffect(EffectDeath(TRUE));
        if (bSaved == 0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffect,oTarget);
        }
        bSaved = 3;
    break;
  }
  if (!bSaved)
  {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEffect,oTargetEffect,fDuration);
    string textString = ObjectToString(oTargetEffect);
    FloatingTextStringOnCreature("3. oTargetEffect is " + textString, OBJECT_SELF, FALSE);
  }
}
