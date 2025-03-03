//::///////////////////////////////////////////////
//:: [Endurance]
//:: [NW_S0_Endurce.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Gives the target 1d4+1 Constitution.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "amia_include"
void AoE( int nAbility, object oTarget, float fDur, int nMeta, int nSpell ){

    int nModify = 2;

    /*if( nMeta == METAMAGIC_EMPOWER )
        nModify = 3;

    else if( nMeta == METAMAGIC_MAXIMIZE )
        nModify = 4;*/

    effect eDur     = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
    effect eBoost   = EffectAbilityIncrease( nAbility, nModify );
    effect eLink    = EffectLinkEffects( eBoost, eDur );

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PDK_GENERIC_PULSE ), GetLocation( oTarget ) );

    object oAOE = GetFirstObjectInShape( SHAPE_SPHERE, 20.0, GetLocation( oTarget ) );
    while( GetIsObjectValid( oAOE ) ){

        if( GetIsReactionTypeFriendly( oAOE ) && !GetHasSpellEffect( nSpell, oAOE ) ){

            SignalEvent( oAOE, EventSpellCastAt( OBJECT_SELF, nSpell, FALSE ) );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_IMPROVE_ABILITY_SCORE ), oAOE );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oAOE, fDur );
        }
        oAOE = GetNextObjectInShape( SHAPE_SPHERE, 20.0, GetLocation( oTarget ) );
    }
}
void main()
{
    /*
      Spellcast Hook Code
      Added 2004-03-08 by Jon (should have been added much sooner, but we somehow missed this one...)
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
    effect eCon;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nModify = d4() + 1;
    float fDuration = NewHoursToSeconds(nCasterLvl);
    int nMetaMagic = GetMetaMagicFeat();
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_BULLS_STRENGTH ) );

    if ( GetIsObjectValid( GetSpellCastItem() ) ) {

        nTransmutation = 1;
    }

    if( nTransmutation == 2 ){
        AoE( ABILITY_CONSTITUTION, oTarget, fDuration, nMetaMagic, SPELL_ENDURANCE );
        return;
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENDURANCE, FALSE));
    //Check for metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nModify = 5;
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nModify = FloatToInt( IntToFloat(nModify) * 1.5 );
    }
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration * 2.0;
    }
    //Set the ability bonus effect
    eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,nModify);
    effect eLink = EffectLinkEffects(eCon, eDur);

    //Appyly the VFX impact and ability bonus effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
