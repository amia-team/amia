//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_isboundhere
//group: porting
//used as: checks if person is already bound to this location
//date: 2008-09-28
//author: disco
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"


int StartingConditional(){

    //find nearest crystal or WP
    object oPC      = GetPCSpeaker();
    int nBindpoint  = GetLocalInt( OBJECT_SELF, "ds_bindpoint" );

    if ( !nBindpoint ){

        object oCrystal = GetNearestObjectByTag( "ds_crystal_node" );

        if ( GetIsObjectValid( oCrystal ) ){

            nBindpoint = GetLocalInt( oCrystal, "ds_bindpoint" );
        }
    }

    return HasBindPoint( oPC, nBindpoint );
}
