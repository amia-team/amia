//::///////////////////////////////////////////////
//:: Cat's Grace
//:: NW_S0_CatGrace
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// The transmuted creature becomes more graceful,
// agile, and coordinated. The spell grants an
// enhancement  bonus to Dexterity of 1d4+1
// points, adding the usual benefits to AC,
// Reflex saves, Dexterity-based skills, etc.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: Last Updated On: April 5th, 2001


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
    effect eDex;
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
        AoE( ABILITY_DEXTERITY, oTarget, fDuration, nMetaMagic, SPELL_CATS_GRACE );
        return;
    }
    //Signal spell cast at event to fire on the target.
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CATS_GRACE, FALSE));
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nModify = 5;//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nModify = FloatToInt( IntToFloat(nModify) * 1.5 ); //Damage/Healing is +50%
    }
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration * 2.0;    //Duration is +100%
    }
    //Create the Ability Bonus effect with the correct modifier
    eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,nModify);
    effect eLink = EffectLinkEffects(eDex, eDur);

    //Apply visual and bonus effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
