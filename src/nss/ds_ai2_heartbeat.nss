//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai2_heartbeat
//group:   ds_ai2
//used as: AI
//date:    dec 23 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

void main(){

    object oCritter     = OBJECT_SELF;
    int nCount          = GetLocalInt( oCritter, L_INACTIVE );
    int nSunkill        = GetLocalInt( oCritter, F_SUNKILL );

    SetLocalInt( oCritter, L_INACTIVE, (nCount + 1) );

    if ( nSunkill ){

        object oArea = GetArea( oCritter );

        if ( GetIsDay() &&
            !GetIsAreaInterior( oArea )  &&
            GetIsAreaAboveGround( oArea ) ){

            effect eVis    = EffectVisualEffect( VFX_IMP_FLAME_M );
            effect eDamage = EffectDamage( d10( 10 ), DAMAGE_TYPE_FIRE );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oCritter );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oCritter );

            SpeakString( "*gets sunburned*" );
        }
    }

    if ( nCount == 50 && GetLocalInt( oCritter, "CS_DSPWN" ) == 1 ){

        //Warn a DM about inactive spawns
        //SendMessageToAllDMs( "DS AI message: "+GetName( oCritter )+" in "+GetName( GetArea( oCritter ) )+ " has been inactive for 5 minutes now and will be deleted." );

        SafeDestroyObject2( oCritter );
    }
}
