//::///////////////////////////////////////////////
//:: [Inflict Wounds]
//:: [X0_S0_Inflict.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: This script is used by all the inflict spells
//::
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

#include "X0_I0_SPELLS" // * this is the new spells include for expansion packs

#include "x2_inc_spellhook"

void main()
{
    int cantripCheck = GetSpellId();
if (cantripCheck == 431){
    CantripRefresh();
}
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

int nIMWBonus = 0;

    //check for foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_NECROMANCY, OBJECT_SELF))
    {
        nIMWBonus = 2;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_NECROMANCY, OBJECT_SELF))
    {
        nIMWBonus = 4;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_NECROMANCY, OBJECT_SELF))
    {
        nIMWBonus = 6;
    }

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    int nDice = 0;
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_NECROMANCY, OBJECT_SELF)) {
        nDice = 3;
    } else if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_NECROMANCY, OBJECT_SELF)) {
        nDice = 2;
    } else if (GetHasFeat (FEAT_SPELL_FOCUS_NECROMANCY, OBJECT_SELF)) {
        nDice = 1;
    }

    int nSpellID = GetSpellId();
    switch (nSpellID)
    {

// spellsInflictTouchAttack(Damage, CLCap, MaximizeSpellDamage (idiotic coding it this way), VFX damage, VFX heal, Spell ID);

/*Minor*/     case 431: spellsInflictTouchAttack(4 + nIMWBonus, 0, 4 + nIMWBonus , 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Light*/     case 432: case 609: spellsInflictTouchAttack(d8(1+nDice), 5, 8+(nDice*8), 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Moderate*/  case 433: case 610: spellsInflictTouchAttack(d8(2+nDice), 10, 16+(nDice*8), 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Serious*/   case 434: case 611: spellsInflictTouchAttack(d8(3+nDice), 15, 24+(nDice*8), 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Critical*/  case 435: case 612: spellsInflictTouchAttack(d8(4+nDice), 20, 32+(nDice*8), 246, VFX_IMP_HEALING_G, nSpellID); break;

    }
}