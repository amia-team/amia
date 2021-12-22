/*  ds_fines

--------
Verbatim
--------
Collects Guard fines

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

    int nGold = GetGold( OBJECT_SELF );

    if ( nGold ){

        object oItem = GetFirstItemInInventory( );

        while ( GetIsObjectValid(oItem) ) {

            if ( GetTag(oItem) == "NW_IT_GOLD001" ){

                DestroyObject( oItem );

                TrackItems( GetLastClosedBy(), OBJECT_SELF, "Fines Box", "Deposit "+IntToString( nGold )+" gold." );

                AssignCommand( GetObjectByTag( "ds_herbert" ), SpeakString( "*notes a deposit of "+IntToString( nGold )+" gold*" ) );

            }
            oItem = GetNextItemInInventory( );
        }
    }
}
