//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Originally by: BitRaiser
//:: Additional refinements by: Alex Moskwa
//:://////////////////////////////////////////////

// 2010-04-21      jehran   refixed unlimited HP exploit
// 2010-04-11      msheeler merged fix by disco with new script

// 2007-03-02      disco    fixed unlimited HP exploit


/*
PnP description:
Transmutation
Level: Sor/Wiz 6
Components: V, S, M
Casting Time: 1 action
Range: Personal
Target: The character
Duration: 1 round/level
The character gains 1d6 temporary hit points per caster level,
a +4 natural armor bonus to AC, a +2d4 Strength enhancement bonus,
a +2d4 Dexterity enhancement bonus,
a +1 base attack bonus per two caster levels
(which may give the character an extra attack),
a +5 competence bonus on Fortitude saves,
and proficiency with all simple and martial weapons.
The character attacks opponents with melee or ranged weapons if the character
can, even resorting to unarmed attacks if that’s all the character can do.
The character can’t cast spells, even from magic items.
Material Component: A potion of Strength,
which the character drinks (and whose effects are subsumed by the spell effects).
*/
#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "x2_inc_shifter"
//The following function tells you how many attacks you have given a Base Attack Bonus Value.
int Attacks (int BAB)
{
  if (BAB%5)
  {
    return BAB/5 + 1;

  }
  else {
    return BAB/5;;
  }
}

void main()
{
  // Added to kill the multi-spell chain expoit associated with polymorph spells
  AssignCommand(GetSpellTargetObject(),ClearAllActions());
  //----------------------------------------------------------------------------
  // GZ, Nov 3, 2003
  // There is a serious problems with creatures turning into unstoppable killer
  // machines when affected by tensors transformation. NPC AI can't handle that
  // spell anyway, so I added this code to disable the use of Tensors by any
  // NPC.
  //----------------------------------------------------------------------------
  if (!GetIsPC(OBJECT_SELF))
  {
      //WriteTimestampedLogEntry(GetName(OBJECT_SELF) + "[" + GetTag (OBJECT_SELF) +"] tried to cast Tensors Transformation. Bad! Remove that spell from the creature");
      return;
  }
  /*
    Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    //Declare major variables
    int nLevel = GetCasterLevel(OBJECT_SELF);
    int nCnt, nDuration, nSTR, nDEX, nCON;
    nDuration = GetCasterLevel(OBJECT_SELF);
    nSTR = d4(1);
    nDEX = d4(1);
    nCON = d4(1);

    int nMeta = GetMetaMagicFeat();
    //Metamagic
    if(nMeta == METAMAGIC_MAXIMIZE)
    {
        nCON = 4;
        nSTR = 4;
        nDEX = 4;
    }
    else if(nMeta == METAMAGIC_EMPOWER)
    {
        nCON += nCON/2;
        nSTR += nSTR/2;
        nDEX += nDEX/2;
    }
    else if(nMeta == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    //Add temporary proficiency feats to the currently equipped armor for Transformation
    itemproperty ipAdd1 = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE);
    itemproperty ipAdd2 = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL);
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
    if (GetIsObjectValid(oItem)) {
    IPSafeAddItemProperty(oItem, ipAdd1, RoundsToSeconds(nDuration));
    IPSafeAddItemProperty(oItem, ipAdd2, RoundsToSeconds(nDuration));
    }

  //The following is the unfortunately rather involved logic it takes to add the proper number of attacks for the spell.
  int oBAB, nBAB, AddAttacks, n, cLevel;
  oBAB = GetBaseAttackBonus(OBJECT_SELF);
  cLevel=0;
  //Determine if the character is epic and adjust oBAB accordingly to determine # of attacks.
  for (n = 1;n <= 3; n++) {
    cLevel += GetLevelByPosition(n,OBJECT_SELF);
  }
  if (cLevel > 20) {
    oBAB -= ((cLevel - 19)/2);
  }
  //Figure out your new spell modified BAB and derive how many extra attacks it should give you.
  nBAB = oBAB + (nLevel/2);
  if (nBAB>20)
    AddAttacks = 4 - Attacks(oBAB);
  else
    AddAttacks = Attacks(nBAB) - Attacks(oBAB);
  if (Attacks(oBAB)>=4) {
    AddAttacks=0;
  }

    //Declare effects
    effect eSpellFail = EffectSpellFailure(100, SPELL_SCHOOL_GENERAL);
    effect eAttack = EffectAttackIncrease( nLevel/2 > 10 ? 10 : nLevel/2 );
    //effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    //effect eSwing = EffectModifyAttacks(AddAttacks);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nSTR);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nDEX);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, nCON );
    effect eDis = EffectSkillIncrease(SKILL_DISCIPLINE, 10 );
    //effect ePoly = EffectPolymorph(POLYMORPH_TYPE_HEURODIS);
    //Link effects
    effect eLink = EffectLinkEffects(eAttack, eCon);
    eLink = EffectLinkEffects(eLink, eDis);
    eLink = EffectLinkEffects(eLink, eDex);
    eLink = EffectLinkEffects(eLink, eStr);
    eLink = EffectLinkEffects(eLink, eDur);
    //if (AddAttacks > 0)
    //  eLink = EffectLinkEffects(eLink, eSwing);
    eLink = EffectLinkEffects(eLink, eSpellFail);
    //eLink = EffectLinkEffects(eLink, ePoly);
    effect eHP = EffectTemporaryHitpoints( d6( nLevel ) );
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));

    ClearAllActions(); // prevents an exploit

    //foolproofing
    RemoveEffectsBySpell( OBJECT_SELF, SPELL_DIVINE_POWER );
    RemoveEffectsBySpell( OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION );

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));

    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration));


}
