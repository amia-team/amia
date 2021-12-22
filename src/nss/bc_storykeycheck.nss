/*  Bardic College :: Remove keys from unbound characters

    --------
    Verbatim
    --------
    This script will remove Storyweaver keys from unbound characters.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    012607  kfw         Initial.
    ----------------------------------------------------------------------------

*/
#include "inc_ds_records"


void main( ){

    // Variables.
    object oPC          = GetEnteringObject( );
    object oKey         = GetItemPossessedBy( oPC, "cs_triumvir_key1" );

    // Filter: PC's only.
    if( !GetIsPC( oPC ) )
        return;

    // Storyweaver key present, but quill isn't, remove it.
    // 37 is the bindpoint index of the Triumvir
    if( GetIsObjectValid( oKey ) && !HasBindPoint( oPC, 37 ) ){

        SendMessageToPC( oPC, "- Your Storyweaver's Key slides into itself like a telescope before vanishing from all sight!" );

        SetPlotFlag( oKey, FALSE );

        DestroyObject( oKey );
    }

    return;
}
