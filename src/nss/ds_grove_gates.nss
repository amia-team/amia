//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  grove_duir_gates
//group:   grove
//used as: OnUse script
//date:    aug 30 2007
//author:  disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------


void main(){

    string sNumber       = GetLocalString( OBJECT_SELF, "number" );

    location lEntryPoint = GetLocation( GetObjectByTag( "ds_root_entry_"+sNumber ) );
    location lExitPoint  = GetLocation( GetObjectByTag( "ds_root_exit_"+sNumber ) );

    object oEntryPortal  = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_grove_portal", lEntryPoint );
    object oExitPortal   = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_grove_portal", lExitPoint );

    DelayCommand( 0.1, SetLocalLocation( oEntryPortal, "ds_destination", lExitPoint ) );
    DelayCommand( 0.1, SetLocalLocation( oExitPortal, "ds_destination", lEntryPoint ) );

    effect eVis         = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR  );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oEntryPortal, 20.0 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oExitPortal, 20.0 );

    DestroyObject( oEntryPortal, 11.0 );
    DestroyObject( oExitPortal, 11.0 );

}
