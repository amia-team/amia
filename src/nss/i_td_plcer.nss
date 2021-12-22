#include "x2_inc_switches"
#include "inc_nwnx_events"

string GetRef( object oItem );
void SetRef( object oItem, string sRef );
object GetPLCObj( object oItem );
object SpawnObj( object oItem, string sRef, location lTarget );

void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            // item activate variables
            object oPC       = InstantGetItemActivator();
            object oItem     = InstantGetItemActivated();
            object oTarget   = InstantGetItemActivatedTarget();
            location lTarget = InstantGetItemActivatedTargetLocation();
            object oExisting = GetPLCObj( oItem );
            string sRef = GetRef( oItem );

            if( GetIsObjectValid( oExisting ) ){

                DestroyObject( oExisting );
            }
            else if( oTarget == oPC && ( GetIsDM( oPC ) || GetPCPlayerName( oPC ) == "Terra_777" ) ){

                oTarget = CopyItem( oItem, oPC, TRUE );
                SetRef( oTarget, GetRef( oItem ) );
                SendMessageToPC( oPC, "Widget copied!" );
            }
            else if( sRef == "" && !GetIsObjectValid( oTarget ) && ( GetIsDM( oPC ) || GetPCPlayerName( oPC ) == "Terra_777" ) ){

                oTarget = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget );

                if( GetIsObjectValid( oTarget ) ){
                    SetRef( oItem, GetResRef( oTarget ) );
                    SetName( oItem, "PLC: " + GetName( oTarget ) );
                    SendMessageToPC( oPC, "Widget tuned: " + GetRef( oTarget ) );
                }
                else
                    SendMessageToPC( oPC, "No suitable PLC found" );
            }
            else if( sRef == "" ){
                SendMessageToPC( oPC, "This widget isnt tuned, a DM needs to fix this." );
            }
            else if( GetIsObjectValid( oTarget ) ){
                SendMessageToPC( oPC, "Can't spawn PLC on other objects!" );
            }
            else{

                vector v1 = GetPositionFromLocation( GetLocation( oPC ) );
                vector v2 = GetPositionFromLocation( lTarget );
                float fAngle = VectorToAngle(v2 - v1);

                lTarget = Location( GetAreaFromLocation( lTarget ), v2, fAngle-180.0 );

                oTarget = SpawnObj( oItem, sRef, lTarget );
                if( !GetIsObjectValid( oTarget ) )
                    SendMessageToPC( oPC, "Failed to spawn: " + sRef );
            }

        break;
    }

    SetExecutedScriptReturnValue(nResult);
}

string GetRef( object oItem ){

    string sRef = GetDescription( oItem, FALSE, FALSE );

    if( sRef == "!" )
        return "";

    return sRef;
}

void SetRef( object oItem, string sRef ){

    SetDescription( oItem, sRef, FALSE );
}

object GetPLCObj( object oItem ){

    return GetObjectByTag( ObjectToString( oItem )+"_td_plc" );
}

object SpawnObj( object oItem, string sRef, location lTarget ){

    string sTag = ObjectToString( oItem )+"_td_plc";

    return CreateObject( OBJECT_TYPE_PLACEABLE, sRef, lTarget, FALSE, sTag );
}
