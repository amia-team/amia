/*  ds_fines

--------
Verbatim
--------
Transports Guard

---------
Changelog
---------

Date    Name        Reason
------------------------------------------------------------------
120306  disco       Start of header
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "nw_i0_plot"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------

void main(){

    object oPC     = GetLastUsedBy();
    object oKey    = GetItemPossessedBy( oPC, "jailkey" );
    object oGuards = GetObjectByTag( "ds_guardhouse" );


    if ( oKey != OBJECT_INVALID ){

        AssignCommand( oPC, ActionJumpToObject( oGuards ) );

    }
    else{

        AssignCommand( oPC, SpeakString( "*The portal only works for Guards*" ) );

    }

}
