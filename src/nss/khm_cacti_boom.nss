//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  khm_cacti_boom
//group:   traps
//used as: ExectuteScript from khm_cacti_trap
//date:    aug 02 2008
//author:  disco



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPLC = OBJECT_SELF;

    //create vfx location
    vector vLocation = GetPosition( oPLC );
    vLocation.z = vLocation.z + 1.0;
    location lLocation = Location( GetArea( oPLC ), vLocation, 33.0 );

    //create effects
    effect eExplode1 = EffectVisualEffect( VFX_COM_CHUNK_GREEN_MEDIUM  );
    effect eExplode2 = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_NATURE   );
    effect eSpike    = EffectVisualEffect( 359 );
    effect eDamage;

    //other vars
    float fDelay;
    int nSpikes;
    int i;

    DelayCommand( 1.0, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eExplode1, lLocation, 2.0 ) );
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eExplode2, lLocation, 3.0 );

    //loop critters
    object oCritter = GetFirstObjectInShape( SHAPE_SPHERE, 15.0, lLocation );

    while ( GetIsObjectValid( oCritter ) ) {

        nSpikes = d3() + 1;

        for ( i=0; i<nSpikes; ++i ){

            fDelay = d6() * 0.10;

            eDamage = EffectDamage( d10( 3 ), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_PLUS_TWO );

            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eSpike, oCritter ) );
            DelayCommand( ( 1.0 + fDelay ), ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oCritter ) );
        }

        oCritter = GetNextObjectInShape( SHAPE_SPHERE, 15.0, lLocation );
    }

    //remove this cactus
    DestroyObject( oPLC, 3.0 );

}
