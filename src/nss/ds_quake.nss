/* ds_quake
--------
Verbatim
--------


---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
12-09-06  Disco       Start of header
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void quake( object oTrigger );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------


void main(){

    object oPC = GetEnteringObject();

    if ( GetLocalInt( OBJECT_SELF, "block" ) != 1){

        SendMessageToPC( oPC, "You hear a rumbling sound above you..." );

        DelayCommand( 1.0, quake( OBJECT_SELF ) );

    }

    //set block
    SetLocalInt( OBJECT_SELF, "block", 1 );

    //release block
    DelayCommand( 300.0, SetLocalInt( OBJECT_SELF, "block", 0 ) );


}

void quake( object oTrigger ){

    location lTarget = GetLocation( GetNearestObjectByTag( "ds_quake_focus" ) );

    // Create the visual portion of the effect
    effect e1 = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );
    effect e2 = EffectVisualEffect( VFX_FNF_ICESTORM );

    object oInTrigger = GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_CREATURE );

    while ( GetIsObjectValid( oInTrigger ) ){

        if ( GetIsPC( oInTrigger ) ){

             ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints( oInTrigger ) / 2, DAMAGE_TYPE_COLD ), oInTrigger );

        }

       oInTrigger = GetNextInPersistentObject( oTrigger, OBJECT_TYPE_CREATURE );
    }

    // Apply the visual effect to the target.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, e1, lTarget, 10.0);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, e2, lTarget, 10.0);

}
