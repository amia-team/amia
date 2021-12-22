//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_set_waresign
//group:   market
//used as: OnUse
//date:    march 22 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetPCSpeaker();
    object oArea    = GetArea( oPC );
    string sChest   = "mkt_chest_"+GetLocalString( OBJECT_SELF, "number" );
    string sUser    = "mkt_user_"+GetLocalString( OBJECT_SELF, "number" );
    object oChest   = GetNearestObjectByTag( sChest );
    int i;

    if ( GetName( OBJECT_SELF ) == "Closed" ){

        for ( i=1; i<20; ++i ){

            if ( GetLocalObject( oArea, "mkt_user_"+IntToString( i ) ) == oPC ){

                SendMessageToPC( oPC, "You can only have one shop in use!" );
                return;
            }
        }

        SetName( OBJECT_SELF, GetName( oPC )+"'s Shoppe" );
        SetName( oChest, GetName( oPC )+"'s Wares" );
        SetLocalObject( oChest, "mkt_user", oPC );
        SetLocalObject( oArea, sUser, oPC );
        SetLocked( oChest, FALSE );

        //vfx
        AssignCommand( OBJECT_SELF, ActionCastSpellAtObject( SHOP_EFFECTS, OBJECT_SELF, 1, TRUE, 0, 1, TRUE ) );

        SendMessageToPC( oPC, "Opened shop!" );

        RecomputeStaticLighting( oArea );
    }
    else {

        object oUser = GetLocalObject( oChest, "mkt_user" );

        if ( oUser == oPC || GetArea( OBJECT_SELF ) != GetArea( oUser ) ){

            SetName( OBJECT_SELF, "Closed" );
            SetName( oChest, "Closed" );
            DeleteLocalObject( oChest, "mkt_user" );
            DeleteLocalObject( oArea, sUser );

            object oItem = GetFirstItemInInventory( oChest );

            while ( GetIsObjectValid( oItem ) == TRUE ){

                SetPlotFlag( oItem, FALSE );

                DestroyObject( oItem );

                oItem = GetNextItemInInventory( oChest );
            }

            SetLocked( oChest, TRUE );

            //vfx
            RemoveEffectsBySpell( OBJECT_SELF, SHOP_EFFECTS );

            SendMessageToPC( oPC, "Closed shop!" );

            RecomputeStaticLighting( oArea );
        }
    }
}
