/*  ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
2007-11-19  disco       Uses PCKEY system now
    ----------------------------------------------------------------------------
*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

// Gloura Quest :: Check for the Gloura Quest Status, bug out if this is the case
int StartingConditional(){

    // Variables
    object oPC = GetPCSpeaker();

    // Kung, Journal Persistency Hook

    // Gloura Quest done
    if( GetPCKEYValue( oPC, "qst_gloura" ) > 0 ){

        return(FALSE);

    }
    // Gloura Quest not done
    else{

        ds_quest( oPC, "qst_gloura", 1 );

        return(TRUE);

    }

}
