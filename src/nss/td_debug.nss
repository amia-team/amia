#include "nwnx_dynres"
#include "inc_ds_records"
#include "inc_td_sysdata"
void main(){

    object oTarget = GetSpellTargetObject( );
    string sLast = GetLocalString( OBJECT_SELF, "last_chat" );

    //if( !GetIsObjectValid( oTarget ) )
    //    oTarget = OBJECT_SELF;

    if( GetIsPC( oTarget ) ){
        SendMessageToPC( OBJECT_SELF, "Key: "+GetName( GetPCKEY( oTarget ) ) );
    }
    else if( sLast == "recache" ){

        SendMessageToPC( OBJECT_SELF, "DYNRES_RemoveFile: "+IntToString( DYNRES_RemoveFile( "mod_pla_cmd.ncs" ) ) );
        SendMessageToPC( OBJECT_SELF, "DYNRES_AddFile: "+IntToString( DYNRES_AddFile( "mod_pla_cmd.ncs", "G:/Resources/scripts/core/mod_pla_cmd.ncs" ) ) );
        SendMessageToPC( OBJECT_SELF, "DYNRES_CacheFile: "+IntToString( DYNRES_CacheFile( "mod_pla_cmd.ncs" ) ) );
    }
    else if( sLast == "derk" ){

        DYNRES_AddFile( "derk_familiar.erf", "G:/External/DC Erf/derk_familiar.erf" );
        CreateItemOnObject( "familiartransfor", oTarget );
    }
    else if( sLast == "shroud" ){
        CreateItemOnObject( "shroudsh_1", oTarget );
        CreateItemOnObject( "shroudsh_2", oTarget );
    }
    else if( sLast == "fix" ){
        DYNRES_AddFile( "i_testwidget.ncs", "G:/Resources/scripts/items/i_testwidget.ncs" );
        AssignCommand( OBJECT_SELF, JumpToLocation( GetStartingLocation() ) );
    }
}

