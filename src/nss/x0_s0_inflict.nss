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
#include "amx_infwnds"

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


    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    int nMetaMagic = GetMetaMagicFeat();
    object oCaster = OBJECT_SELF;
    object oSpecificTarget = GetSpellTargetObject();
    int nCL = GetCasterLevel(OBJECT_SELF);
    int nSpellID = GetSpellId();

    if( GetIsObjectValid( GetSpellCastItem( ))) {
        switch (nSpellID) {
/*Minor*/     case 431: HarmTarget(oSpecificTarget, 0, 4, VFX_IMP_HEALING_G, VFX_IMP_HARM, TRUE); break;
/*Light*/     case 432: case 609:
                if (nCL > 5) {
                    nCL = 5;
                }
                HarmTarget(oSpecificTarget, 1, nCL, VFX_IMP_HEALING_G, VFX_IMP_HARM, TRUE);
                break;
/*Moderate*/  case 433: case 610:
                if (nCL > 10) {
                    nCL = 10;
                }
                HarmTarget(oSpecificTarget, 2, nCL, VFX_IMP_HEALING_G, VFX_IMP_HARM, TRUE);
                break;
/*Serious*/   case 434: case 611:
                if (nCL > 15) {
                    nCL = 15;
                }
                HarmTarget(oSpecificTarget, 3, nCL, VFX_IMP_HEALING_G, VFX_IMP_HARM, TRUE);
                break;
/*Critical*/  case 435: case 612:
                if (nCL > 20) {
                    nCL = 20;
                }
                HarmTarget(oSpecificTarget, 4, nCL, VFX_IMP_HEALING_G, VFX_IMP_HARM, TRUE);
                break;
        }
        return;
    }

// End of Spell Cast Hook
    int nAoE = FALSE;
    int nDice = 0;
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oCaster)) {
        nAoE = TRUE;
        nDice = 3;
        nIMWBonus = 6;
    } else if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster)) {
        nDice = 2;
        nIMWBonus = 4;
    } else if (GetHasFeat (FEAT_SPELL_FOCUS_NECROMANCY, oCaster)) {
        nDice = 1;
        nIMWBonus = 2;
    }

    if (nAoE == TRUE) {
        if (nSpellID == 431) {
            spellsInflictTouchAttack(4 + nIMWBonus, 0, 4 + nIMWBonus , 246, VFX_IMP_HEALING_G, nSpellID);
            return;
        }
        switch (nSpellID) {

/*Light*/     case 432: case 609:
                if (nCL > 5) {
                    nCL = 5;
                }
                AoEHarm(1+nDice, nCL, nMetaMagic, VFX_IMP_HEALING_G, VFX_IMP_HARM, oSpecificTarget); break;
/*Moderate*/  case 433: case 610:
                if (nCL > 10) {
                    nCL = 10;
                }
                AoEHarm(2+nDice, nCL, nMetaMagic, VFX_IMP_HEALING_G, VFX_IMP_HARM, oSpecificTarget); break;
/*Serious*/   case 434: case 611:
                if (nCL > 15) {
                    nCL = 15;
                }
                AoEHarm(3+nDice, nCL, nMetaMagic, VFX_IMP_HEALING_G, VFX_IMP_HARM, oSpecificTarget); break;
/*Critical*/  case 435: case 612:
                if (nCL > 20) {
                    nCL = 20;
                }
                AoEHarm(4+nDice, nCL, nMetaMagic, VFX_IMP_HEALING_G, VFX_IMP_HARM, oSpecificTarget); break;
        }
    } else {
        switch (nSpellID) {
              switch (nSpellID) {
/*Minor*/     case 431: HarmTarget(oSpecificTarget, 0, 4+nIMWBonus, VFX_IMP_HEALING_G, VFX_IMP_HARM, FALSE); break;
/*Light*/     case 432: case 609:
                if (nCL > 5) {
                    nCL = 5;
                }
                HarmTarget(oSpecificTarget, 1+nDice, nCL, VFX_IMP_HEALING_G, VFX_IMP_HARM, FALSE);
                break;
/*Moderate*/  case 433: case 610:
                if (nCL > 10) {
                    nCL = 10;
                }
                HarmTarget(oSpecificTarget, 2+nDice, nCL, VFX_IMP_HEALING_G, VFX_IMP_HARM, FALSE);
                break;
/*Serious*/   case 434: case 611:
                if (nCL > 15) {
                    nCL = 15;
                }
                HarmTarget(oSpecificTarget, 3+nDice, nCL, VFX_IMP_HEALING_G, VFX_IMP_HARM, FALSE);
                break;
/*Critical*/  case 435: case 612:
                if (nCL > 20) {
                    nCL = 20;
                }
                HarmTarget(oSpecificTarget, 4+nDice, nCL, VFX_IMP_HEALING_G, VFX_IMP_HARM, FALSE);
                break;
        }
        return;
// spellsInflictTouchAttack(Damage, CLCap, MaximizeSpellDamage (idiotic coding it this way), VFX damage, VFX heal, Spell ID);

/*Minor*///     case 431: spellsInflictTouchAttack(4 + nIMWBonus, 0, 4 + nIMWBonus , 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Light*///     case 432: case 609: spellsInflictTouchAttack(d8(1+nDice), 5, 8+(nDice*8), 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Moderate*///  case 433: case 610: spellsInflictTouchAttack(d8(2+nDice), 10, 16+(nDice*8), 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Serious*///   case 434: case 611: spellsInflictTouchAttack(d8(3+nDice), 15, 24+(nDice*8), 246, VFX_IMP_HEALING_G, nSpellID); break;
/*Critical*///  case 435: case 612: spellsInflictTouchAttack(d8(4+nDice), 20, 32+(nDice*8), 246, VFX_IMP_HEALING_G, nSpellID); break;
        }
    }
}