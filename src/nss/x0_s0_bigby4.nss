//::///////////////////////////////////////////////
//:: Bigby's Clenched Fist
//:: [x0_s0_bigby4]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does an attack EACH ROUND for 1 round/level.
    If the attack hits does
     1d8 +12 points of damage

    Any creature struck must make a FORT save or
    be stunned for one round.

    GZ, Oct 15 2003:
    Changed how this spell works by adding duration
    tracking based on the VFX added to the character.
    Makes the spell dispellable and solves some other
    issues with wrong spell DCs, checks, etc.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller October 15, 2003
//:: Update By: jpavelch
//:: Upated On: May 25, 2004
//:: Notes: Added concentration check.
// msheeler 7/1/2016    changed duration to 5 rounds and added checks for spell foci

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"


int nSpellID = 462;


int ConcentrationCheck( object oVictim )
{
    if ( !GetIsObjectValid(oVictim) )
        return FALSE;

    object oCaster = GetLocalObject( oVictim, "AR_Bigby4_Caster" );
    if ( !GetIsObjectValid(oCaster) ) return FALSE;

    int nAction = GetCurrentAction( oCaster );
    // Caster doing anything that requires attention and breaks concentration.
    if ( nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT
        || nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT
        || nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP
        || nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL ) {

        return FALSE;
    }

    return TRUE;
}


void RunHandImpact(object oTarget, object oCaster, int nFirstRun )
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if ( nFirstRun == FALSE && ConcentrationCheck(oTarget) == FALSE ) {
        FloatingTextStringOnCreature(
            "* Concentration broken, Bigby dispelled *",
            oCaster
        );
        oCaster = OBJECT_INVALID;
    }

    if (GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster))
    {
        return;
    }

    int nCasterModifiers = GetCasterAbilityModifier(oCaster) + GetCasterLevel(oCaster);
    int nCasterRoll = d20(1) + nCasterModifiers + 11 + -1;
    int nTargetRoll = GetAC(oTarget);
    if (nCasterRoll >= nTargetRoll)
    {
       int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID));

       int nDam  = MaximizeOrEmpower(8, 1, GetMetaMagicFeat(), 11);
       //check for damage bonus for foci
       if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, oCaster))
       {
           int nDam = MaximizeOrEmpower(8,1,GetMetaMagicFeat(), 13);
       }

       if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCaster))
       {
           int nDam = MaximizeOrEmpower(8,1,GetMetaMagicFeat(), 15);
       }

       effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
       effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);

       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

       if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
       {
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(1));
       }

       DelayCommand(6.0f,RunHandImpact(oTarget,oCaster,FALSE));
   }
}



void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook

    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(463,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    int nDuration = 5;
    // check for epic spell focus
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nDuration = nDuration + 1;
    }

    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, TRUE));
        int nResult = MyResistSpell(OBJECT_SELF, oTarget);

        if(nResult  == 0)
        {
            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand, oTarget, RoundsToSeconds(nDuration));

            //----------------------------------------------------------
            // GZ: 2003-Oct-15
            // Save the current save DC on the character because
            // GetSpellSaveDC won't work when delayed
            //----------------------------------------------------------
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID), GetSpellSaveDC());
            object oSelf = OBJECT_SELF;
            SetLocalObject( oTarget, "AR_Bigby4_Caster", oSelf );
            RunHandImpact(oTarget,OBJECT_SELF,TRUE );

        }
    }
}

