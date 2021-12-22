//::///////////////////////////////////////////////
//:: [Control Undead]
//:: [NW_S0_ConUnd.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A single undead with up to 3 HD per caster level
    can be dominated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: Last Updated On: April 6, 2001

//-------------------------------------------------------------------------------
// updates
//-------------------------------------------------------------------------------
// 20080216     Disco       Added GS nerf when a level 22+ summon/domination is detected
//2011/10/23    PoS         Added PM levels to caster level and SR calculation

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "NW_I0_SPELLS"
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
    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;

    if ( GetIsPC( oTarget ) || GetIsPossessedFamiliar( oTarget ) || GetIsDMPossessed( oTarget ) ){

        SendMessageToPC( OBJECT_SELF, "You cannot Dominate PCs or possessed creatures!" );
        return;
    }

    //--------------------------------------------------------------------------------
    //GS + dominate nerf
    //--------------------------------------------------------------------------------

    if ( GetHitDice( oTarget ) > 22 && GetHasSpellEffect( SPELL_ETHEREALNESS ) ){

        RemoveEffectsBySpell( oCaster, SPELL_ETHEREALNESS );
        SendMessageToPC( oCaster, "Dominating level 23+ monsters removes GS." );
    }

    effect eControl = EffectDominated();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eLink = EffectLinkEffects(eMind, eControl);
    eLink = EffectLinkEffects(eLink, eDur);

    int nDC             = GetSpellSaveDC( );
    int nPMLevel        = GetLevelByClass( CLASS_TYPE_PALEMASTER, OBJECT_SELF );
    int nCasterLevel    = GetCasterLevel(OBJECT_SELF) + nPMLevel;
    int nIgnoreSR       = FALSE;

    int nSR = 0;

    if( GetLocalInt( OBJECT_SELF, "pm_override_dc" ) > 0 ){

        nDC             = GetLocalInt( OBJECT_SELF, "pm_override_dc" );
        nCasterLevel    = GetLocalInt( OBJECT_SELF, "pm_override_cl" );
        SetLocalInt( OBJECT_SELF, "pm_override_dc", 0 );
        SetLocalInt( OBJECT_SELF, "pm_override_cl", 0 );
        nIgnoreSR = TRUE;
    }

    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = nCasterLevel;
    int nHD = nCasterLevel * 2;

    //Make meta magic
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nCasterLevel * 2;
    }
    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && GetHitDice(oTarget) <= nHD)
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTROL_UNDEAD));
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSpellResistanceDecrease( nPMLevel ), oTarget, 0.5 );
            if( nIgnoreSR || !MyResistSpell( OBJECT_SELF, oTarget ) ){

                //Make a Will save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, 1.0))
                {
                    //Apply VFX impact and Link effect
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, NewHoursToSeconds(nDuration)));
                    //Increment HD affected count
                }
            }
        }
    }
}
