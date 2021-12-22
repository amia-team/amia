//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_toggle_plc
//group:   utilities
//used as: on use script
//date:    apr 22 2008
//author:  disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    string sWP      = GetLocalString( OBJECT_SELF, "ds_wp" );
    string sTag     = GetLocalString( OBJECT_SELF, "ds_tag" );
    string sResRef  = GetLocalString( OBJECT_SELF, "ds_resref" );
    object oWP      = GetWaypointByTag( sWP );
    object oPLC     = GetNearestObjectByTag( sTag, oWP );

    if ( GetIsObjectValid( oPLC ) && GetDistanceBetween( oWP, oPLC ) < 1.0 ){

        PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );
        DestroyObject( oPLC );
    }
    else{

        PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );
        CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, GetLocation( oWP ), FALSE, sTag );
    }
}


