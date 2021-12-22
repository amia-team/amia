//set a journal entry with the areas resref


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetEnteringObject();
    string sRefRef  = GetResRef( GetArea( OBJECT_SELF ) );
    int nVariable   = GetPCKEYValue( oPC, sRefRef );

    if ( !nVariable ){

        SetPCKEYValue( oPC, sRefRef, 1 );
    }
}
