//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_spawneffects
//group:   eye candy
//used as: OnSpawn script
//date:    may 17 2007
//author:  disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    int nEffect1     = GetLocalInt( OBJECT_SELF, "effect1" );
    int nEffect2     = GetLocalInt( OBJECT_SELF, "effect2" );
    int nPetrify     = GetLocalInt( OBJECT_SELF, "petrify" );

    if ( nEffect1 ){

        effect eEffect1  = SupernaturalEffect( EffectVisualEffect( nEffect1 ) );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEffect1, OBJECT_SELF ) );
    }

    if ( nEffect2 ){

        effect eEffect2  = SupernaturalEffect( EffectVisualEffect( nEffect2 ) );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEffect2, OBJECT_SELF ) );
    }

    if ( nPetrify ){

        effect eEffect3  = SupernaturalEffect( EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION ) );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEffect3, OBJECT_SELF ) );
    }




}



