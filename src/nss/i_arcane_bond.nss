// Arcane Bond

// Activates an user when cast on self which drains from a pool of energy.
// Targeting a mythal destroys it and restores this energy.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 30/09/2012 PaladinOfSune    Initial Release
//

#include "x2_inc_switches"

void AsOne( object oPC, object oItem );
void AsOneHeartbeat( object oPC, object oItem );
void Subsume( object oPC, object oTarget, object oItem );

void ActivateItem()
{
    // Variables.
    object oPC          = GetItemActivator();
    object oTarget      = GetItemActivatedTarget();
    object oItem        = GetItemActivated();

    int nPoints     = GetLocalInt( oItem, "mythal_points" );

    if( oPC == oTarget )
    {
        AsOne( oPC, oItem ); // Activate the aura
    }
    else if( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM )
    {
        Subsume( oPC, oTarget, oItem ); // Absorb the mythal
    }
    else
    {
        FloatingTextStringOnCreature( "You have " +IntToString( nPoints )+ " Mythal points. Target yourself to activate As One or target a mythal to Subsume it.", oPC, FALSE );
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

void AsOne( object oPC, object oItem )
{
    // Main effect variables.
    int nPoints     = GetLocalInt( oItem, "mythal_points" );
    effect eAOE     = EffectAreaOfEffect( AOE_MOB_DRAGON_FEAR, "cs_asone_a", "****", "****" );
    effect eBonus1  = EffectSkillIncrease( SKILL_DISCIPLINE, 6 );
    effect eBonus2  = EffectSkillIncrease( SKILL_CONCENTRATION, 6 );
    effect eBonus3  = EffectHaste();
    effect eBonus4  = EffectDamageImmunityDecrease( DAMAGE_TYPE_MAGICAL, 25 );

    // For storing who activated the aura...
    object oModule = GetModule();

    // Visual variables.
    effect eVFX1    = EffectVisualEffect( VFX_IMP_KNOCK );
    effect eVFX2    = EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION );
    effect eVFX3    = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );
    effect eDUR1    = EffectVisualEffect( VFX_DUR_AURA_CYAN );
    effect eDUR2    = EffectVisualEffect( VFX_DUR_PDK_FEAR );
    effect eDUR3    = EffectVisualEffect( VFX_EYES_GREEN_ELF_MALE );

    // Link the AOE and the effects.
    effect eLink = EffectLinkEffects( eBonus1, eAOE );
    eLink = EffectLinkEffects( eBonus2, eLink );
    eLink = EffectLinkEffects( eBonus3, eLink );
    eLink = EffectLinkEffects( eBonus4, eLink );
    eLink = EffectLinkEffects( eDUR1, eLink );
    eLink = EffectLinkEffects( eDUR2, eLink );
    eLink = EffectLinkEffects( eDUR3, eLink );

    // No dispels please!
    eLink = ExtraordinaryEffect( eLink );

    // To prevent stacking
    if( GetLocalInt( oPC, "As_One" ) == 1 )
    {
        FloatingTextStringOnCreature( "You are already in this powerful state As One!", oPC, FALSE );
        return;
    }

    // Takes up 5 points to activate, so only start if the user possesses that much
    if( nPoints >= 5 )
    {
        // Apply the VFX impact and effects.
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
        DelayCommand( 1.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC ) );
        DelayCommand( 1.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX3, oPC ) );
        DelayCommand( 1.6, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0 ) );
        DelayCommand( 1.6, SetLocalObject( oModule, "asone_user", oPC ) );
        DelayCommand( 1.6, SetLocalInt( oItem, "mythal_points", nPoints - 5 ) );
        DelayCommand( 1.6, SetLocalInt( oPC, "As_One", 1 ) );
        DelayCommand( 1.6, FloatingTextStringOnCreature( "You become As One!", oPC, FALSE ) );
        DelayCommand( 7.6, AsOneHeartbeat( oPC, oItem ) );
    }
    else
    {
        DelayCommand( 0.1, FloatingTextStringOnCreature( "You have " +IntToString( nPoints )+ " Mythal points. 5 is required to become As One.", oPC, FALSE ) );
    }
}

void AsOneHeartbeat( object oPC, object oItem )
{
    // Main variables.
    int nPoints     = GetLocalInt( oItem, "mythal_points" );
    effect eAOE     = EffectAreaOfEffect( AOE_MOB_DRAGON_FEAR, "cs_asone_a", "****", "****" );
    effect eBonus1  = EffectSkillIncrease( SKILL_DISCIPLINE, 6 );
    effect eBonus2  = EffectSkillIncrease( SKILL_CONCENTRATION, 6 );
    effect eBonus3  = EffectHaste();
    effect eBonus4  = EffectDamageImmunityDecrease( DAMAGE_TYPE_MAGICAL, 25 );

    // For storing who activated the aura...
    object oModule = GetModule();

    // Visual variables.
    effect eDUR1    = EffectVisualEffect( VFX_DUR_AURA_BLUE_DARK );
    effect eDUR2    = EffectVisualEffect( VFX_DUR_PDK_FEAR );
    effect eVFX1    = EffectVisualEffect( VFX_FNF_SCREEN_BUMP );
    effect eVFX2    = EffectVisualEffect( VFX_IMP_LIGHTNING_M );
    effect eVFX3    = EffectVisualEffect( VFX_IMP_MAGIC_PROTECTION );

    // Link the AOE and the effects.
    effect eLink = EffectLinkEffects( eBonus1, eAOE );
    eLink = EffectLinkEffects( eBonus2, eLink );
    eLink = EffectLinkEffects( eBonus3, eLink );
    eLink = EffectLinkEffects( eBonus4, eLink );
    eLink = EffectLinkEffects( eDUR1, eLink );
    eLink = EffectLinkEffects( eDUR2, eLink );

    // No dispels please!
    eLink = ExtraordinaryEffect( eLink );

    // Takes 1 point per round... this pseudo-heartbeat checks and consumes 1 point every six seconds.
    if( nPoints >= 1 )
    {
        SetLocalInt( oItem, "mythal_points", nPoints - 1 );
        FloatingTextStringOnCreature( IntToString( nPoints )+ " Mythal points remaining.", oPC, FALSE );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0 );
        DelayCommand( 6.0, AsOneHeartbeat( oPC, oItem ) );
    }
    else
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX3, oPC );
        DeleteLocalObject( oModule, "asone_user" );
        SetLocalInt( oPC, "As_One", 0 );
        FloatingTextStringOnCreature( "You have 0 Mythal points remaining... you are no longer As One.", oPC, FALSE );
    }
}

void Subsume( object oPC, object oTarget, object oItem )
{
    // Main variables.
    int nPoints     = GetLocalInt( oItem, "mythal_points" );
    string sResRef  = GetResRef( oTarget );
    effect eVFX     = EffectVisualEffect( VFX_IMP_MAGIC_PROTECTION );
    effect eVFX2    = EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION );

    if( GetStringLeft( sResRef, 6 ) == "mythal" )
    {
        if( sResRef == "mythal1" ) // Minor
        {
            SetLocalInt( oItem, "mythal_points", nPoints + 1 );
        }
        else if( sResRef == "mythal2" ) // Lesser
        {
            SetLocalInt( oItem, "mythal_points", nPoints + 2 );
        }
        else if( sResRef == "mythal3" ) // Intermediate
        {
            SetLocalInt( oItem, "mythal_points", nPoints + 3 );
        }
        else if( sResRef == "mythal4" ) // Greater
        {
            SetLocalInt( oItem, "mythal_points", nPoints + 4 );
        }
        else if( sResRef == "mythal5" ) // Flawless
        {
            SetLocalInt( oItem, "mythal_points", nPoints + 5 );
        }
        else if( sResRef == "mythal6" ) // Perfect
        {
            SetLocalInt( oItem, "mythal_points", 30 );
        }
        else if( sResRef == "mythal7" ) // Divine
        {
            SetLocalInt( oItem, "mythal_points", 60 );
            nPoints = GetLocalInt( oItem, "mythal_points" );
            DelayCommand( 0.1, FloatingTextStringOnCreature( "You absorb the raw magical energy from the mythal! And the magical energy contained in this mythal is... overwhelming! Your body trembles and quakes under the sheer amount of force contained within. You are at " +IntToString( nPoints )+ " Mythal points... for now.", oPC, FALSE ) );
            DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC ) );
            DestroyObject( oTarget );
            return; // this if statement will probably never get touched, but just for fun.
        }

        // Maximum cap is 60 (save for Divine).
        if( GetLocalInt( oItem, "mythal_points" ) > 30 )
        {
            SetLocalInt( oItem, "mythal_points", 30 );
        }

        // Play pretty visuals and destroy the mythal.
        nPoints = GetLocalInt( oItem, "mythal_points" );
        DelayCommand( 0.1, FloatingTextStringOnCreature( "You absorb the raw magical energy from the mythal! You are now at " +IntToString( nPoints )+ " Mythal points.", oPC, FALSE ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC ) );
        DestroyObject( oTarget );
    }
    else // Not a mythal
    {
        DelayCommand( 0.1, FloatingTextStringOnCreature( "Invalid target.", oPC, FALSE ) );
    }
}
