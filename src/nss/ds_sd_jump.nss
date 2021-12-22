// Shadow Jump feat.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/10/2011 PaladinOfSune    Initial release.
//


void main( ) {

    // Declare variables
    object oPC = OBJECT_SELF;
    object oArea = GetArea( oPC );
    object oTarget=GetSpellTargetObject();

    location lTarget = GetSpellTargetLocation();

    // Check if they can Shadow Jump here
    if( GetLocalInt( oArea, "CS_NO_SHADOWJUMP" ) == 1 ) {
        FloatingTextStringOnCreature( "- You are unable to Shadow Jump in this area! -", oPC, FALSE );
        return;
    }

    // Apply visual candy
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_WARD ), GetLocation( oPC ) );
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_WARD ), lTarget );

    // Jump PC to location and clear all actions afterward to prevent any weirdness
    AssignCommand( oPC, ActionJumpToLocation( lTarget ) );
    DelayCommand( 0.8, AssignCommand( oPC, ClearAllActions( ) ) );
}
