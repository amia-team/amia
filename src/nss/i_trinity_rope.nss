// Entangles a target on a failed reflex save.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 22/10/2011 PaladinOfSune    Initial Release
//

#include "x2_inc_switches"

void DoEntangle( object oTarget );

void ActivateItem()
{
    // Variables.
    object oPC          = GetItemActivator();
    object oTarget      = GetItemActivatedTarget();

    // Remove any invisibility effects
    effect eEff = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEff ) )
    {
        nType=GetEffectType( eEff );

        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY )
            RemoveEffect( oPC, eEff );

        eEff = GetNextEffect( oPC );
    }

    // Hostile PC or NPCs only
    if( ( GetObjectType( oPC )!= OBJECT_TYPE_CREATURE ) || ( GetIsEnemy( oTarget, oPC ) == FALSE ) )
    {
        FloatingTextStringOnCreature( "<cþ  >Entangle only works on enemy NPCs or PCs.</c>", oPC, FALSE );
        return;
    }

   // Perform it
   AssignCommand( oPC, DoEntangle( oTarget ) );
}

void DoEntangle( object oTarget ){

    // Variables
    object oPC      = OBJECT_SELF;

    int nInt        = GetAbilityModifier( ABILITY_INTELLIGENCE, oPC );
    int nHD         = GetHitDice( oPC ) / 2;
    int nDC         = 10 + nInt + nHD;
    float fDur      = RoundsToSeconds( 11 );

    effect eVFX1    = EffectVisualEffect( VFX_DUR_PARALYZE_HOLD );
    effect eVFX2    = EffectVisualEffect( VFX_IMP_SLOW );

    effect eFail    = EffectEntangle();
    effect eSave    = EffectSlow();

    effect eLink    = EffectLinkEffects( eVFX1, eFail );

    effect eRay = EffectBeam( VFX_BEAM_FIRE_LASH, oPC, BODY_NODE_HAND );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7 );

    // Entangle if failed
    if( ReflexSave( oTarget, nDC, SAVING_THROW_TYPE_NONE ) == 0 ) {
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur ) );
    }
    // Slow if saved
    else {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSave, oTarget, fDur ) );
    }

}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
