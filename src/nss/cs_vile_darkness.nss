#include "amia_include"

// Actual spawning script for the Book of Vile Darkness [i_bookvilerit2]
void main( ){

    // Variables
    object oPC      = OBJECT_SELF;

    effect eSummon  = EffectSummonCreature( "cs_shdflmfnd1", 464, 2.0 );

    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, GetLocation( oPC ) , NewHoursToSeconds( 24 ) );

    DelayCommand(
        3.0,
        ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            SupernaturalEffect( EffectVisualEffect( VFX_DUR_ANTI_LIGHT_10 ) ),
            GetNearestObjectByTag( "cs_shdflmfnd1" ) ) );

    return;

}
