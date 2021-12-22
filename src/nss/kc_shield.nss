// Knight Commander feat: Shield Ally
//
// Applies a +4 Dodge AC bonus to an ally in exchange for -4 AB to the caster.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
//

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nBonus = 4;

    // Security checks.
    if ( GetLocalInt( oPC, "PDKHeroicTracking" ) )
    {
        FloatingTextStringOnCreature("You can only use this ability once every five rounds", oPC, FALSE );
        return;
    }
    if( GetArea( oTarget ) != GetArea( oPC ) )
    {
        FloatingTextStringOnCreature("You must be within 20 feet to protect an ally", oPC, FALSE );
        return;
    }
    if ( oPC == oTarget )
    {
        FloatingTextStringOnCreature("You cannot aid yourself using this ability", oPC, FALSE );
        return;
    }
    if ( !GetIsFriend( oTarget ) )
    {
        FloatingTextStringOnCreature("You cannot aid an enemy using this ability", oPC, FALSE );
        return;
    }
    if( GetDistanceToObject( oTarget ) > 6.096 )
    {
        FloatingTextStringOnCreature("You must be within 20 feet to protect an ally", oPC, FALSE );
        return;
    }

    // Declare effect variables.
    effect eAC = EffectACIncrease( nBonus );
    effect eABMalus = EffectAttackDecrease( nBonus );
    effect eVFX1 = EffectVisualEffect( VFX_IMP_PDK_HEROIC_SHIELD );
    effect eVFX2 = EffectVisualEffect( VFX_IMP_AC_BONUS );

    // Apply bonus/penalty to the appropriate targets.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eAC, oTarget, RoundsToSeconds( 5 ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eABMalus, oPC, RoundsToSeconds( 5 ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget );
    DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget ) );

    // Used to prevent stacking.
    SetLocalInt( oPC, "PDKHeroicTracking", TRUE );
    DelayCommand( 29.0, DeleteLocalInt( oPC, "PDKHeroicTracking" ) );
}
