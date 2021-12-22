//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_grove_hallow
//group:   grove/bark scripts
//used as: OnEnter trigger script around Duir
//date:    aug 11 2007
//author:  disco



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC          = GetEnteringObject( );
    int nHallowed       = GetLocalInt( oPC, "nHallowed" );
    int nRegenerating   = 0;

    if ( !nHallowed ){

        SetLocalInt( oPC, "nHallowed", 1 );

        effect eEffect = GetFirstEffect( oPC );

        while ( GetIsEffectValid( eEffect ) ) {

            if ( GetEffectType( eEffect ) == EFFECT_TYPE_INVISIBILITY ||
                GetEffectType( eEffect ) == EFFECT_TYPE_IMPROVEDINVISIBILITY ) {

                RemoveEffect( oPC, eEffect );
                FloatingTextStringOnCreature( "The healing glow negates your invisibility.", oPC, FALSE );
            }

            if ( GetEffectType( eEffect ) == EFFECT_TYPE_REGENERATE ) {

                nRegenerating = 1;
            }

            eEffect = GetNextEffect( oPC );
        }

        if ( nRegenerating != 1 ){

            int nAmount    = GetMaxHitPoints( oPC ) - GetCurrentHitPoints( oPC );

            if ( nAmount < 1 ){

                return;
            }
            else{

                nAmount = ( nAmount / 30 ) + 1;
            }

            effect eRegen = EffectRegenerate( nAmount, 1.0 );
            effect eVis   = EffectVisualEffect( VFX_DUR_BLUR );
            effect eLink  = EffectLinkEffects( eRegen, eVis );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, 31.0f );

            FloatingTextStringOnCreature( GetName(OBJECT_SELF)+": Your wounds heal in close proximity to the Great Duir", oPC, FALSE);
        }

        DelayCommand( 60.0, DeleteLocalInt( oPC, "nHallowed" ) );
    }
}


