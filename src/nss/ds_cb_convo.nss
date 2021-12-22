//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   ds_cb_
//group:    chickenball
//used as:  OnConversation
//date:     2009-07-10
//author:   Disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_cb"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPlayer   = GetLastSpeaker();
    object oCreature = OBJECT_SELF;
    string sTag      = GetTag( oCreature );

    /*
    clean_vars( oPlayer );

    SetLocalObject( oPlayer, "ds_target", oCreature );
    SetLocalString( oPlayer, "ds_action", "ds_cb_shop" );

    if ( !GetLocalInt( oPlayer, DS_CB_ACTIVE_TRICK ) ){

        SetLocalInt( oPlayer, "ds_check_1", 1 );
    }

    if ( !GetLocalInt( oPlayer, DS_CB_PASSIVE_TRICK ) ){

        SetLocalInt( oPlayer, "ds_check_2", 1 );
    }

    int nAlignment = GetAlignmentGoodEvil( oPlayer );

    if ( nAlignment == ALIGNMENT_EVIL ){

        SetLocalInt( oPlayer, "ds_check_3", 1 );
    }
    else if ( nAlignment == ALIGNMENT_NEUTRAL ){

        SetLocalInt( oPlayer, "ds_check_4", 1 );
    }
    else {

        SetLocalInt( oPlayer, "ds_check_5", 1 );
    }
    */

    ActionStartConversation( oPlayer, CB_SHOP, TRUE, FALSE );
}
