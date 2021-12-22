// Item event script for Devouring Silence
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/29/2013 PaladinOfSune    Initial release.
//

#include "x2_inc_switches"
#include "inc_ds_records"
#include "amia_include"
#include "x0_I0_SPELLS"
#include "x2_inc_itemprop"


void ActivateItem( )
{
    // Major variables.
    object oPC      = GetItemActivator();

    if( !GetHasFeat( FEAT_INFLICT_SERIOUS_WOUNDS, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
        return;
    }

    if( !GetHasFeat( FEAT_INFLICT_CRITICAL_WOUNDS, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
        return;
    }

    DecrementRemainingFeatUses( oPC, FEAT_INFLICT_SERIOUS_WOUNDS );
    DecrementRemainingFeatUses( oPC, FEAT_INFLICT_CRITICAL_WOUNDS );

    int nClass  = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
    int nDrainCount;
    int nSilenceCount;

    // Cycles through effects and remove invisibility, if applicable.
    effect eEffect = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEffect ) ) {

        nType = GetEffectType( eEffect );

        if( nType == EFFECT_TYPE_INVISIBILITY ||
            nType == EFFECT_TYPE_ETHEREAL ||
            nType == EFFECT_TYPE_SANCTUARY )

            RemoveEffect( oPC, eEffect );

        eEffect = GetNextEffect( oPC );
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( 686 ), oPC );

    // Wrap through targets in a colossal radius.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE );
    while( oTarget != OBJECT_INVALID )
    {
        if( oTarget != oPC && GetIsReactionTypeHostile( oTarget, oPC )) // Can't target yourself!
        {
            if( !MySavingThrow( SAVING_THROW_FORT, oTarget, 10 + nClass + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ), SAVING_THROW_TYPE_NEGATIVE, oPC ) )
            {
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectAbilityDecrease( ABILITY_CONSTITUTION, d4() + 2 ), oTarget, RoundsToSeconds( 10 ) );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_TENTACLE ), oTarget, 3.0 );

                if( nDrainCount < 5 ) {
                    nDrainCount++;
                }
            }

            if( !MySavingThrow( SAVING_THROW_WILL, oTarget, 10 + nClass + GetAbilityModifier( ABILITY_CHARISMA, OBJECT_SELF ), SAVING_THROW_TYPE_NEGATIVE, oPC ) )
            {
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSilence(), oTarget, RoundsToSeconds( 10 ) );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_TENTACLE ), oTarget, 3.0 );

                if( nSilenceCount < 5 ) {
                    nSilenceCount++;
                }
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), FALSE,  OBJECT_TYPE_CREATURE );
    }

    if( nDrainCount ) {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease( SAVING_THROW_WILL, nDrainCount ), oPC, TurnsToSeconds( 10 ) );
    }

    object oWeapon = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    if( nSilenceCount && GetIsObjectValid( oWeapon ) ) {
        IPSafeAddItemProperty( oWeapon, ItemPropertyVampiricRegeneration( nSilenceCount ), TurnsToSeconds( 10 ), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
    }

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
