//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_js_transign
//group:
//used as: item activation script
//date: 12/08/2021
//author: Jes
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_j_lib"
#include "X0_I0_SPELLS"

void ds_j_SpawnItem( object oPC, object oItem, string sResRef, string sTagPrefix, location lTarget, string sName="", string sDescription="" ){

    //create a tag for each object that consists of the PC name and the item
    string sTag       = GetLocalString( oItem, "tag" );

    if ( sTag == "" ){

        //create and store new tag
        sTag = GetPCPublicCDKey( oPC ) + "_" + IntToString( GetCurrentSecond( ) );
        SetLocalString( oItem, "tag", sTag );
    }

    object oPlaceable = GetObjectByTag( sTag );

    if ( oPlaceable == OBJECT_INVALID ){

        object oNearestPC   = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
        location lNearestPC = GetLocation( oNearestPC );
        location lPC        = GetLocation( oPC );

        //if a PC tries to place the item at his own feet
        if ( GetDistanceBetweenLocations( lTarget, lPC ) < 1.5 ){

            SendMessageToPC( oPC, CLR_RED+"You should not place this item on your own feet, my friend." );
        }
        //if a PC tries to place the item at another PC's feet
        else if ( GetDistanceBetweenLocations( lTarget, lNearestPC ) < 1.5 && oNearestPC != OBJECT_INVALID ){

            SendMessageToPC( oPC, CLR_RED+"You should not place this item on another person's feet, my friend." );
        }
        //create object
        else{

            object oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lTarget, FALSE, sTag );
            SetPlotFlag( oPLC, FALSE );

            SendMessageToPC( oPC, CLR_ORANGE+"Placed your prop. Use this item again to remove it." );

            if ( sName != "" ){

                SetName( oPLC, sName );
            }
            else{

                SetName( oPLC, GetName( oPC )+"'s "+GetName( oPLC ) );
            }

            if ( sDescription != "" ){

                SetDescription( oPLC, sDescription );
            }
        }
    }
    else{

             SendMessageToPC( oPC, CLR_ORANGE+"You removed your "+GetName(oPlaceable)+"." );
            DestroyObject( oPlaceable );
        }
}
void main(){

            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            location lTarget   = GetItemActivatedTargetLocation();

            if (GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE || GetObjectType( oTarget ) == OBJECT_TYPE_DOOR ||
                GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ){
                SendMessageToPC(oPC,"You can only use this item on the ground to place/remove the sign PLC.");
                return;
            }
            else {
                ds_j_SpawnItem( oPC, oItem, "ds_sign_widget", "lala", lTarget, GetName( oItem ), GetDescription( oItem ) );
            }
}
