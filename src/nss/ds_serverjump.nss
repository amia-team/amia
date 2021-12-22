//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_serverjump
//group:  porting
//used as: convo action
//date: 2008-07-30
//author:Disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oModule  = GetModule();
    object oPC      = GetPCSpeaker();
    object oPCKEY   = GetPCKEY( oPC );

    string sTarget  = GetLocalString( OBJECT_SELF, "p_target" );

    if ( sTarget == "" ){

        return;
    }

    //store info on PCKEY
    SetLocalString( oPCKEY, "p_target", sTarget );
    SetLocalInt( oPCKEY, "p_time", GetCurrentSecond( TRUE ) );
    SetLocalInt( oPCKEY, "p_module", GetLocalInt( oModule, "Module" ) );
    SetLocalInt( oPCKEY, "p_gold", 0 );

    //create server portal
    DelayCommand( 1.0, ActivatePortal( oPC, GetLocalString( GetModule(), "SisterServer" ), "n.a.", "", FALSE ) );
}


