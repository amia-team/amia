/////////////////////////////////////////////////
// Bull's Strength
//-----------------------------------------------
// Created By: Brenon Holmes
// Created On: 10/12/2000
// Description: This script changes someone's strength
// Updated 2003-07-17 to fix stacking issue with blackguard
/////////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nw_i0_spells"
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
    effect eStr;
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
        AoE( ABILITY_STRENGTH, oTarget, fDuration, nMetaMagic, SPELL_BULLS_STRENGTH );
        return;
    }
    //Signal the spell cast at event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BULLS_STRENGTH, FALSE));
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
    nModify = 5;//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
    nModify = nModify + (nModify/2);
    }
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration * 2.0;    //Duration is +100%
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    // This code was there to prevent stacking issues, but programming says thats handled in code...
/*    if (GetHasSpellEffect(SPELL_GREATER_BULLS_STRENGTH))
    {
        return;
    }

    //Apply effects and VFX to target
    RemoveSpellEffects(SPELL_BULLS_STRENGTH, OBJECT_SELF, oTarget);
    RemoveSpellEffects(SPELLABILITY_BG_BULLS_STRENGTH, OBJECT_SELF, oTarget);
*/
    eStr = EffectAbilityIncrease(ABILITY_STRENGTH,nModify);
    effect eLink = EffectLinkEffects(eStr, eDur);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

}
