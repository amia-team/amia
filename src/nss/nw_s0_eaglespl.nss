//::///////////////////////////////////////////////
//:: Eagles Splendor
//:: NW_S0_EagleSpl
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Raises targets Chr by 1d4+1
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
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
    effect eRaise;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nMetaMagic = GetMetaMagicFeat();
    int nRaise = d4(1) + 1;
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_BULLS_STRENGTH ) );

    if ( GetIsObjectValid( GetSpellCastItem() ) ) {

        nTransmutation = 1;
    }

    if( nTransmutation == 2 ){
        AoE( ABILITY_CHARISMA, oTarget, NewHoursToSeconds( nDuration ), nMetaMagic, SPELL_EAGLE_SPLEDOR );
        return;
    }
    //Fire cast spell at event for the specified target
        //SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EAGLES_SPLENDOR));

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nRaise = 5;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nRaise = nRaise + (nRaise/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Set Adjust Ability Score effect
    eRaise = EffectAbilityIncrease(ABILITY_CHARISMA, nRaise);
    effect eLink = EffectLinkEffects(eRaise, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EAGLE_SPLEDOR, FALSE));
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, NewHoursToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);


}
