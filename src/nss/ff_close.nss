//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ff_close
//group:   frozenfar
//used as: OnClose script
//date:    dec 02 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC          = GetLastClosedBy();
    object oPLC         = OBJECT_SELF;
    string sTag         = GetTag( oPLC );

    if ( sTag == "ff_dw_scale_l" || sTag == "ff_dw_scale_r" ) {

        string sOtherTag = "ff_dw_scale_l";

        if ( sTag == "ff_dw_scale_l"){

            sOtherTag = "ff_dw_scale_r";
        }

        int nGold = GetGold( oPLC );

        if ( nGold > 0 ){

            object oOtherScale = GetObjectByTag( sOtherTag );
            int nOtherGold     = GetGold( oOtherScale );

            if ( nGold == nOtherGold ){

                ds_take_item( oPLC, "NW_IT_GOLD001" );
                ds_take_item( oOtherScale, "NW_IT_GOLD001" );

                object oDoor = GetObjectByTag( "ff_minesofbt_to_hallsofbt" );

                AssignCommand( oDoor, ActionPlayAnimation( ANIMATION_DOOR_OPEN1 ) );
                DelayCommand( 20.0, AssignCommand( oDoor, ActionPlayAnimation( ANIMATION_DOOR_CLOSE ) ) );
            }
        }
    }
}

