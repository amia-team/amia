/*  Merchant :: Panthalo :: Issue Kit :: Iron Gauntlet

    --------
    Verbatim
    --------
    Panthalo will issue the player Iron Gauntlet's kit.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    070606  kfw         Initial release.
  20071118  disco       uses PCKEY now
    ----------------------------------------------------------------------------

*/
#include "inc_ds_records"

/* Constants. */
const int GOLD          = 300000;
const string KIT_REF_0  = "robesoftheironga";
const string KIT_REF_1  = "bootsoftheironga";
const string KIT_REF_2  = "masterglovesofth";
const string KIT_DONE   = "cs_panthalo_done";

void main( ){

    // Variable.
    object oPC          = GetPCSpeaker( );
    int nGP             = GetGold( oPC );

    if( nGP >= GOLD ){

        // Take GP.
        TakeGoldFromCreature( GOLD, oPC, TRUE );
        // Issue kit.
        CreateItemOnObject( KIT_REF_0, oPC );
        CreateItemOnObject( KIT_REF_1, oPC );
        CreateItemOnObject( KIT_REF_2, oPC );
        // Cannot buy again from Panthalo.
        SetPCKEYValue( oPC, KIT_DONE, TRUE );

    }

    return;

}
