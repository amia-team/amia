//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"



void main(){


    if ( GetIsBlocked() ){

        return;
    }

    SetBlockTime();

    effect eFX     = EffectVisualEffect( VFX_IMP_LIGHTNING_M );
    object oPylon  = GetNearestObjectByTag( "mt_roof_pylon", OBJECT_SELF, d4() );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eFX, oPylon );
}
