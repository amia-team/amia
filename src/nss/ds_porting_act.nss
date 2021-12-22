//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_porting_bind
//group: core stuff
//used as: activation script
//date:  2008-06-06
//author: Disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_porting"
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC      = OBJECT_SELF;
    object oObject  = GetLocalObject( oPC, "ds_target" );
    object oMythal  = GetLocalObject( oPC, "ds_mythal" );
    int nNode       = GetLocalInt( oPC, "ds_node" );
    int nSection    = GetLocalInt( oPC, "ds_section" );

    if ( nNode == 1 ){

        SetLocalInt( oPC, "ds_section", 1 );
        return;
    }
    else if ( nNode == 2 ){

        SetLocalInt( oPC, "ds_section", 2 );
        return;
    }
    else{

        DeleteLocalInt( oPC, "ds_section" );
    }

    if ( nNode == 4 ){

        port_mythal_upgrade( oPC, oObject, oMythal );
    }
    else if ( nNode == 5 ){

        port_mythal_charge( oPC, oObject, oMythal );
    }
    else if ( nNode > 10 && nNode < 21 ){

        port_porting( oPC, nNode-10 );
    }
    else if ( nNode > 22 && nNode < 31 ){

        port_binding( oPC, oObject, nNode-20 );
    }
    else if ( nNode > 30 && nNode < 41 ){

        port_set_home( oPC, nNode-30, nSection );
    }
    else if ( nNode == 10 ){

        port_back( oPC );
    }

    //strip any remaining action variables
    clean_vars( oPC, 4 );
}
