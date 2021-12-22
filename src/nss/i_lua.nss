#include "x2_inc_switches"
#include "inc_lua"
#include "inc_nwnx_events"
#include "inc_ds_records"

object GetInstantItemActivator(){

    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT )
        return OBJECT_SELF;
    return GetItemActivator();
}

object GetInstantItemActivated(){

    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT )
        return EVENTS_GetTarget(0);
    return GetItemActivated();
}

object GetInstantItemActivatedTarget(){

    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT )
        return EVENTS_GetTarget(1);
    return GetItemActivated();
}

location GetInstantItemActivatedTargetLocation(){
    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT )
        return EVENTS_GetTargetLocation(0);
    return GetItemActivatedTargetLocation();
}

void main( ){

    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT){
        EVENTS_Bypass();
    }
    else
        return;

    object oPC = GetInstantItemActivator();


    if( GetDMStatus( GetPCPlayerName( oPC ), GetPCPublicCDKey( oPC ) ) <= 0 &&
        GetPCPlayerName( oPC ) != "Terra_777" ){

        DestroyObject( GetInstantItemActivated() );
        return;
    }

    object oItem = GetInstantItemActivated();
    object oTarget = GetInstantItemActivatedTarget();
    string lua = GetDescription(oItem);

    if(lua=="UNSET"){
        SetDescription(oItem,GetLocalString( oPC, "last_chat" ));
    }
    else{
        ExecuteLuaString(oPC,"TARGET=[=["+ObjectToString(oTarget)+"]=]; ITEM=[=["+ObjectToString(oItem)+"]=];");
        SendMessageToPC(oPC,ExecuteLuaString(oPC,lua));
    }
}
