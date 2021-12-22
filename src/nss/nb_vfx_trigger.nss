//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  nb_vfx_trigger
//group:   utilities
//used as: onEnter trigger script
//date:    july 08 2007
//author:  kung/nekhbet


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    // Variables
    object oTrigger     = OBJECT_SELF;
    object oPC          = GetEnteringObject( );
    int nDestroy        = GetLocalInt( oTrigger, "destroy_plc" );
    int nVFX            = GetLocalInt( oTrigger, "vfx" );
    string sTag         = GetLocalString( oTrigger, "plc" );
    object oObject      = GetObjectByTag( sTag );
    int i;

    // Verify PC, VFX and C
    if( GetIsPC( oPC ) && nVFX && GetIsObjectValid( oObject ) ){

        while ( GetIsObjectValid( oObject ) ){

            if ( nDestroy ){

                ApplyEffectAtLocation( DURATION_TYPE_PERMANENT, EffectVisualEffect( nVFX ), GetLocation( oObject ) );

                DestroyObject( oObject, 1.0 );

            }
            else{

               ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( nVFX ), oObject );
            }


            //find next object
            ++i;
            oObject = GetObjectByTag( sTag, i );
        }
    }

    //use once
    DestroyObject( OBJECT_SELF );

    return;
}

