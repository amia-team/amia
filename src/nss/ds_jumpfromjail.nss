/*  ds_jumpfromjail

--------
Verbatim
--------
Ports guards to Watchhouse

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
12-24-06  Disco       Start of header
------------------------------------------------------------------

*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "nw_i0_plot"



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC = GetLastUsedBy();

    if ( HasItem( oPC, "jailkey" ) ){

        AssignCommand( oPC, JumpToObject( GetObjectByTag( "ds_jumpfromjail" ) ) );

    }

}
