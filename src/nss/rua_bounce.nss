//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  rua_bounce
//group:   ruathym areas
//used as: onenter script
//date:    oct 26 2008
//author:  disco

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetEnteringObject();
    object oTarget  = GetNearestObjectByTag( "rua_bounce", oPC );
    object oCenter  = GetObjectByTag( "rua_bounce_center" );
    effect eVis     = EffectVisualEffect( VFX_IMP_SPELL_MANTLE_USE );
    effect eVis2    = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );
    effect eDam     = EffectDamage( d8(), DAMAGE_TYPE_NEGATIVE );
    effect eKD      = EffectKnockdown();

    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eVis, GetLocation( oCenter ), 2.0 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis2, oPC, 2.0 );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oPC );

    AssignCommand( oPC, ClearAllActions( TRUE ) );
    AssignCommand( oPC, JumpToObject( oTarget, FALSE ) );

    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKD, oPC, 5.0 ) );

}

