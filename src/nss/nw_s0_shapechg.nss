//::///////////////////////////////////////////////
//:: Shapechange
//:: NW_S0_ShapeChg.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

#include "amia_include"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int EpicTrans = GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION,OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Terra: Drown check
    int nDrown = ds_check_uw_items ( OBJECT_SELF ) ;

    //Determine Polymorph subradial type
    if(nSpell == 392)
    {
        if( EpicTrans == 1)
        nPoly = 242;
        else
        nPoly = 237;
    }
    else if (nSpell == 393)
    {
        if( EpicTrans == 1)
        nPoly = 243;
        else
        nPoly = 238;
    }
    else if (nSpell == 394)
    {
        if( EpicTrans == 1)
        nPoly = 244;
        else
        nPoly = 239;
    }
    else if (nSpell == 395)
    {
        if( EpicTrans == 1)
        nPoly = 245;
        else
        nPoly = 240;
    }
    else if (nSpell == 396)
    {
        if( EpicTrans == 1)
        nPoly = 246;
        else
        nPoly = 241;
    }
    ePoly = EffectPolymorph(nPoly);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SHAPECHANGE, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
    DelayCommand(0.4, AssignCommand(oTarget, ClearAllActions())); // prevents an exploit
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, TurnsToSeconds(nDuration)));

    DelayCommand(0.6,SetLocalInt( OBJECT_SELF, "CannotDrown", nDrown ) );
}
