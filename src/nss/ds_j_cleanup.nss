//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_cleanup
//group:   jobs
//used as: ExecuteScript() script that cleans up unused NPCs
//date:    feb 02 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_j_lib"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oTarget = OBJECT_SELF;
    object oPC     = GetLocalObject( oTarget, DS_J_USER );

    if ( GetArea( oTarget ) != GetArea( oPC ) ){

        if ( GetLocalInt( oTarget, DS_J_DELETE ) ){

            //remove spawn block on oUser
            string sTag  = GetTag( oTarget );
            DeleteLocalInt( oPC, sTag );

            //feedback
            SendMessageToPC( oPC, CLR_ORANGE+"[Debug: Removed "+GetName( oTarget )+" from "+GetName( GetArea( oTarget ) )+"]"+CLR_END );

            log_to_exploits( oPC, "ds_j: despawned NPC ("+GetTag( oTarget )+")", GetResRef( GetArea( oPC ) ), 0 );

            SafeDestroyObject( oTarget );
        }
        else{

            SetLocalInt( oTarget, DS_J_DELETE, 1 );

            DelayCommand( 300.0, ExecuteScript( "ds_j_cleanup", oTarget ) );
        }
    }
    else{

        DeleteLocalInt( oTarget, DS_J_DELETE );
    }
}


