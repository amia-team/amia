// Tactical Approach
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
// 02/10/2013 PoS              Fix for summons.
//

#include "x2_inc_spellhook"

void main(){

    // Variables.
    object oCreature    = GetEnteringObject( );
    object oPC          = GetAreaOfEffectCreator( );
    object oArmor;

    // Prevent stacking.
    if ( GetHasSpellEffect( 930, oCreature ) )
        return;

    // Apply strength bonus to allies.
    effect eSTR    = EffectAbilityIncrease( ABILITY_STRENGTH, 3 );

    itemproperty eFeat1 = ItemPropertyBonusFeat( 440 );
    itemproperty eFeat2 = ItemPropertyBonusFeat( 841 );

    if( GetAssociateType( oCreature ) == ASSOCIATE_TYPE_NONE )
    {
        oArmor = GetItemInSlot( INVENTORY_SLOT_CHEST, oCreature );
    }
    else
    {
        oArmor = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oCreature );
    }

    // Link the AOE and the effect to apply to the PC directly.
    eSTR = ExtraordinaryEffect( eSTR );

    // Apply if creature is friendly to the aura creator.
    if( GetIsReactionTypeFriendly( oCreature, oPC ) )
    {
        // Apply the VFX impact and effects.
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSTR, oCreature ) );
        DelayCommand( 0.1, IPSafeAddItemProperty( oArmor, eFeat1, 1000000.0f ) );
        DelayCommand( 0.1, IPSafeAddItemProperty( oArmor, eFeat2, 1000000.0f ) );
    }
}
