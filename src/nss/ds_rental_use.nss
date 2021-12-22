//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_use
//group: rentable housing
//used as: PLC use scripts in rentable houses
//date: 2009-09-04
//author: disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_rental"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC   = GetLastUsedBy();
    object oPLC  = OBJECT_SELF;
    object oTarget;
    string sName = GetName( oPLC );

    if ( sName == "Fireplace" ){

        oTarget = GetNearestObjectByTag( "ds_rental_fireplace" );

        if ( GetLocalInt( oPLC, "fire" ) != 1 ){

            object oFire = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_flamemedium", GetLocation( oTarget ), FALSE, RNT_STAY_TAG );

            SetLocalInt( oPLC, "fire", 1 );
            SetLocalObject( oPLC, "fire", oFire );
        }
        else{

            DestroyObject(GetLocalObject( oPLC, "fire" ) );

            DeleteLocalInt( oPLC, "fire" );
            DeleteLocalObject( oPLC, "fire" );
        }

        RecomputeStaticLighting( GetArea( oPC ) );
    }
    else if ( sName == "Lock" ){

        oTarget = GetNearestObject( OBJECT_TYPE_DOOR );

        if ( GetLocalInt( oTarget, RNT_UNLOCKED ) != 1 ){

            SendMessageToPC( oPC, "Your front door is now unlocked." );

            SetLocalInt( oTarget, RNT_UNLOCKED, 1 );

            AssignCommand( GetLocalObject( oTarget, RNT_TARGET ) , PlayAnimation( ANIMATION_DOOR_CLOSE ) );
        }
        else{

            SendMessageToPC( oPC, "Your front door is now locked." );

            DeleteLocalInt( oTarget, RNT_UNLOCKED );
        }
    }
}

