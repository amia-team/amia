// Hybrid Rage. Applies bonuses, and then applies a penalty 1 turn later.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/18/2011 PoS              Initial Release

#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "x2_inc_toollib"

void ActivateItem()
{
    object oTarget      = GetItemActivatedTarget();
    object oItem        = GetItemActivated();
    object oPC          = GetItemActivator();

    int nSTRMod        = GetAbilityModifier( ABILITY_STRENGTH, oPC );
    int nDEXMod        = GetAbilityModifier( ABILITY_DEXTERITY, oPC );

    if( oTarget == oItem ) {
        string sMessage = "<c þ >[?] <c fþ>Strength Check</c> = D20: </c><cþ  >20</c><c þ > + Modifier ( <cþ  > " +IntToString( nSTRMod ) +"</c><c þ > ) = <cþ  >" +IntToString( 20 + nSTRMod ) +"</c><c þ > [?]</c>";
        AssignCommand ( oPC, ActionSpeakString( sMessage ) );
        return;
    }

    if( oTarget == oPC ) {
        string sMessage = "<c þ >[?] <c fþ>Dexterity Check</c> = D20: </c><cþ  >20</c><c þ > + Modifier ( <cþ  > " +IntToString( nDEXMod ) +"</c><c þ > ) = <cþ  >" +IntToString( 20 + nDEXMod ) +"</c><c þ > [?]</c>";
        AssignCommand ( oPC, ActionSpeakString( sMessage ) );
        return;
    }

    if( GetLocalInt( oPC, "hybrid_raging" ) == 1 ) {
        FloatingTextStringOnCreature( "You are already raging!", oPC, FALSE );
        return;
    }

    int    nPillar      = VFX_COM_CHUNK_RED_SMALL;

    // Bonus effects.
    effect eHaste       = EffectHaste();
    effect eRegen       = EffectRegenerate( 12, 6.0 );
    effect eAttack      = EffectAttackIncrease( 5 );
    effect eDamage      = EffectDamageIncrease( DAMAGE_BONUS_5 );
    effect eSaves       = EffectSavingThrowIncrease( SAVING_THROW_ALL, 5 );
    effect eImmunity1   = EffectDamageImmunityIncrease( DAMAGE_TYPE_PIERCING, 20 );
    effect eImmunity2   = EffectDamageImmunityIncrease( DAMAGE_TYPE_BLUDGEONING, 20 );
    effect eImmunity3   = EffectDamageImmunityIncrease( DAMAGE_TYPE_SLASHING, 20 );

    // Fear aura.
    effect eAOE         = EffectAreaOfEffect( AOE_MOB_FEAR, "i_hybrid_rage1", "****", "****" );

    // Visual.
    effect eDur         = EffectVisualEffect( VFX_DUR_AURA_PULSE_RED_ORANGE );

    // Link it all together.
    effect eLink        = EffectLinkEffects( eHaste, eRegen );
    eLink               = EffectLinkEffects( eAttack, eLink );
    eLink               = EffectLinkEffects( eDamage, eLink );
    eLink               = EffectLinkEffects( eSaves, eLink );
    eLink               = EffectLinkEffects( eImmunity1, eLink );
    eLink               = EffectLinkEffects( eImmunity2, eLink );
    eLink               = EffectLinkEffects( eImmunity3, eLink );
    eLink               = EffectLinkEffects( eAOE, eLink );
    eLink               = EffectLinkEffects( eDur, eLink );

    // Penalty effects.
    effect eMovement    = EffectMovementSpeedDecrease( 50 );
    effect eAttack2     = EffectAttackDecrease( 5 );
    effect eDamage2     = EffectDamageDecrease( DAMAGE_BONUS_5 );
    effect eSaves2      = EffectSavingThrowDecrease( SAVING_THROW_ALL, 5 );

    // Visual.
    effect eDur2        = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );

    // Link it all together.
    effect eLink2       = EffectLinkEffects( eAttack2, eMovement );
    eLink2              = EffectLinkEffects( eDamage2, eLink2 );
    eLink2              = EffectLinkEffects( eSaves2, eLink2 );
    eLink2              = EffectLinkEffects( eDur2, eLink2 );

    // Apply visuals.
    TLVFXPillar( nPillar, GetLocation( oPC ), 3, 0.1f, 0.0, 0.3 );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_IMPROVE_ABILITY_SCORE ), oPC );
    PlayVoiceChat( VOICE_CHAT_BATTLECRY3, oPC );

    // Apply bonus.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( eLink ), oPC, TurnsToSeconds( 1 ) );
    SetLocalInt( oPC, "hybrid_raging", 1 );

    // Apply penalty a turn later.
    DelayCommand( TurnsToSeconds( 1 ), ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( eLink2 ), oPC, 90.0 ) );
    DelayCommand( TurnsToSeconds( 1 ), ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints( oPC ) / 2 ), oPC ) );
    DelayCommand( TurnsToSeconds( 1 ), DeleteLocalInt( oPC, "hybrid_raging" ) );
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
