// Item event script for Sunder Aorta. Kills the target if under 100 HP on a successful
// touch attack, otherwise applies a custom wounding effect of 10d4 damage for ten turns.
// It can healed with a successful save when at full HP.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/19/2012 PaladinOfSune    Initial release.
//

#include "x2_inc_switches"
#include "inc_ds_records"
#include "amia_include"

void DoSunderAorta( object oTarget );
void WoundingDamage( object oTarget );

void ActivateItem( )
{
    // Major variables.
    object oPC      = GetItemActivator();
    object oTarget  = GetItemActivatedTarget();

    // Remove three Ki Damage uses.
    int x;
    for ( x = 0; x < 3; x++ ) {
        if( !GetHasFeat( FEAT_KI_DAMAGE, oPC ) ) {
            FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
            return;
        }
        DecrementRemainingFeatUses( oPC, FEAT_KI_DAMAGE );
    }

    // Return if PC has an inappropriate target.
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE || !GetIsEnemy( oTarget, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You must target an enemy creature! -</c>", oPC, FALSE );
        return;
    }

    // Remove any invisibility effects.
    effect eEffect = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEffect ) )
    {
        nType=GetEffectType( eEffect );

        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY )
            RemoveEffect( oPC, eEffect );

        eEffect = GetNextEffect( oPC );
    }

    // Onto the main bulk of the script!
    AssignCommand( oPC, DoSunderAorta( oTarget ) );
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent )
    {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:
            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}

void DoSunderAorta( object oTarget )
{
    object oPC = OBJECT_SELF;

    // Make sure it hits.
    if( TouchAttackMelee( oTarget, TRUE ) > 0 ) {

        // Effect variables.
        effect eVis1        = EffectVisualEffect( VFX_COM_BLOOD_SPARK_MEDIUM );
        effect eVis2        = EffectVisualEffect( VFX_COM_HIT_NEGATIVE );
        effect eVis3        = EffectVisualEffect( 491 );
        effect eDeathVis    = EffectVisualEffect( VFX_COM_CHUNK_RED_MEDIUM );

        // Bypasses death immunity.
        effect eDeath       = EffectDeath();
        eDeath              = SupernaturalEffect( eDeath );

        // 10d4 wounding damage.
        effect eDamage      = EffectDamage( d4( 10 ), DAMAGE_TYPE_MAGICAL );

        // Doesn't work on those without functional organs.
        if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD || GetRacialType( oTarget ) == RACIAL_TYPE_CONSTRUCT || GetRacialType( oTarget ) == RACIAL_TYPE_OOZE ) {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_BLOOD_LRG_WIMP ), oTarget );
            SendMessageToPC( oPC, "Target is immune to this ability." );
            return;
        }

        // Fancy visuals.
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis3, oTarget );

        // Blood placeables for more visual fluff.
        object oPLC;
        location lTarget = GetLocation( oTarget );
        oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_aorta_1", lTarget );
        DestroyObject( oPLC, 120.0 );

        if( d2() == 1 )
        {
            oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_aorta_2", lTarget ); // add a bit of randomness to the blood placeable.
        }
        else
        {
            oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_aorta_3", lTarget );
        }

        // This blood disappears after a round.
        DestroyObject( oPLC, 120.0 );

        // Kill instantly if they're 100 HP or under.
        if( GetCurrentHitPoints( oTarget ) <= 100 )
        {
            DelayCommand( 0.7, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDeathVis, oTarget ) );
            DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDeath, oTarget ) );
        }
        else
        {
            if ( GetIsBlocked( oTarget, "Aorta_Sundered" ) > 0 )
            {
                SendMessageToPC( oPC, "Target is already under this effect." ); // Prevent stacking
                return;
            }

            // Add the wounding effect.
            DelayCommand( 0.3, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget ) );
            DelayCommand( 6.0, WoundingDamage( oTarget ) );
            SetBlockTime( oTarget, 10, 0, "Aorta_Sundered" );
        }
    }
}

void WoundingDamage( object oTarget )
{
    // Variables.
    location lTarget    = GetLocation( oTarget );
    effect eDamage      = EffectDamage( d4( 10 ), DAMAGE_TYPE_MAGICAL );
    effect eVis1        = EffectVisualEffect( 491 );
    effect eVis2        = EffectVisualEffect( VFX_IMP_HEALING_S );

    // Make sure it stops if they die.
    if( GetIsDead( oTarget ) )
    {
        DeleteLocalInt( oTarget, "Aorta_Sundered" );
        return;
    }

    // Stop when the duration is up.
    if ( GetIsBlocked( oTarget, "Aorta_Sundered" ) > 0 )
    {
        if( GetCurrentHitPoints( oTarget ) >= GetMaxHitPoints( oTarget ) ) //  They have a chance to recover if at full HP.
        {
            if( FortitudeSave( oTarget, 39 ) == 1 ) // Roll versus the PC's Devastating Critical DC
            {
                // If saved, they recover.
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oTarget );
                FloatingTextStringOnCreature( "You have recovered from the bleeding effect.", oTarget, FALSE );
                DeleteLocalInt( oTarget, "Aorta_Sundered" );
                return;
            }
        }

        // Add more blood visuals.
        object oPLC;

        if( d2() == 1 )
        {
            oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_aorta_1", lTarget );
        }
        else
        {
            oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_aorta_4", lTarget );
        }

        DestroyObject( oPLC, 120.0 ); // Delete in two minutes this time, to serve as a trail of blood.

        // Apply the damage and visual.
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oTarget );
        FloatingTextStringOnCreature( "You have taken bleeding damage! Heal yourself to full hit points to attempt a recovery.", oTarget, FALSE );

        // Do this again next round.
        DelayCommand( 6.0, WoundingDamage( oTarget ) );
    }
    else
    {
        // Stop since the duration is over.
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oTarget );
        FloatingTextStringOnCreature( "You have recovered from the bleeding effect.", oTarget, FALSE );
        return;
    }
}
