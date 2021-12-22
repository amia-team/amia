/*  NPC :: Bardic College Pink Man : Conversation : Action 1 - Binding

    --------
    Verbatim
    --------
    This will bind the player to the Bardic College.

    ---------
    Changelog
    ---------
    Date        Name        Reason
    ----------------------------------------------------------------------------
    012607      kfw         Initial.
    ----------------------------------------------------------------------------
*/

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"



void main( ){

    // Variables.
    object oPC          = GetPCSpeaker( );



    // Issue their Storyweaver key.
    ds_create_item( "cs_triumvir_key1", oPC );


    return;

}
