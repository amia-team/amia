//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  nb_vfx_trigger
//group:   utilities
//used as: onEnter trigger script
//date:    aug 12 2007
//author:  disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    // Variables
    object oLever       = OBJECT_SELF;
    string sTrigger     = GetLocalString( oLever, "trigger_tag" );
    object oTrigger     = GetObjectByTag( GetLocalString( oLever, "trigger_tag" ) );
    object oPC          = GetFirstInPersistentObject( oTrigger );
    int nVFX            = GetLocalInt( oLever, "vfx_id" );
    effect eVFX         = EffectVisualEffect( nVFX );


    // Verify PC, VFX and C
    if( GetIsPC( oPC ) ){

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oPC, 90.0 );
    }


    //check toggle status
    if( GetLocalInt( oLever, "activate" ) == 1 ){

        SetLocalInt( oLever, "activate", 0 );
        PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );
    }
    else{

        SetLocalInt( oLever, "activate", 1 );
        PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );
    }

    return;

}
