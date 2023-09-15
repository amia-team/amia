#include "x2_inc_switches"
#include "X0_I0_PARTYWIDE"
#include "nw_i0_plot"

const string REST_SYSTEM_COLOUR_TAG          = "";
//creature info functions
void GetNpcInfo(object oTarget,object oDM,int nToggle);

//other objects
void GetItemInfo(object oTarget, object oDM);
void GetAreaInfo(object oDM, location lTarget);
void GetPlaceableInfo(object oTarget, object oDM);
void GetDoorInfo(object oTarget, object oDM);

void main(){

    int nEvent = GetUserDefinedItemEventNumber();

    int nToggle;
    object oDM;
    object oItem;
    object oTarget;
    location lTarget;

    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            oDM     = GetItemActivator();
            oItem   = GetItemActivated();
            oTarget = GetItemActivatedTarget();
            lTarget = GetItemActivatedTargetLocation();

    int nRunTime = GetRunTime();
    int nReload  = GetAutoReload() + nRunTime;

    int resetTime = ((nReload - nRunTime) - (GetRunTime() - GetStartTime())) / 60;

    SendMessageToPC( oDM, REST_SYSTEM_COLOUR_TAG+"Estimated reset time: " + IntToString(resetTime) + " minutes." );


            if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

                if ( GetIsPC(oTarget) == FALSE ){

                    GetNpcInfo( oTarget, oDM, nToggle );
                }
                if( oTarget == oDM ){

                    if ( GetLocalInt( oDM, "tester") == 0 ){

                        SetLocalInt( oDM, "tester", 1 );
                    }
                    else{

                        SetLocalInt( oDM, "tester", 0 );
                    }
                }
            }
            else if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM){
                GetItemInfo(oTarget,oDM);
            }
            else if (GetObjectType(oTarget)==OBJECT_TYPE_DOOR){
                GetDoorInfo(oTarget, oDM);
            }
            else if (GetObjectType(oTarget)==OBJECT_TYPE_PLACEABLE){
                GetPlaceableInfo(oTarget, oDM);
            }
            else {
                GetAreaInfo(oDM,lTarget);
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

void GetNpcInfo(object oTarget,object oDM,int nToggle){
    SendMessageToPC(oDM,GetName(oTarget));
    SendMessageToPC(oDM,"  Type: NPC");
    SendMessageToPC(oDM,"  Tag: "+GetTag(oTarget));
    SendMessageToPC(oDM,"  ResRef: "+GetResRef(oTarget));
    SendMessageToPC(oDM,"  Plot flag: "+IntToString(GetPlotFlag(oTarget)));
    SendMessageToPC(oDM,"  Immortal flag: "+IntToString(GetImmortal(oTarget)));
}

void GetItemInfo(object oTarget,object oDM){

    SendMessageToPC(oDM,GetName(oTarget));
    SendMessageToPC(oDM,"  Type: Item");
    SendMessageToPC(oDM,"  Tag: "+GetTag(oTarget));
    SendMessageToPC(oDM,"  ResRef: "+GetResRef(oTarget));
    SendMessageToPC(oDM,"  Plot flag: "+IntToString(GetPlotFlag(oTarget)));
    SendMessageToPC(oDM,"  Undrop flag: "+IntToString(GetItemCursedFlag(oTarget)));
    SendMessageToPC(oDM,"  Stolen flag: "+IntToString(GetStolenFlag(oTarget)));
}

void GetAreaInfo(object oDM, location lTarget){
    object oArea=GetArea(oDM);
    object oObject = GetFirstObjectInArea(oArea);
    object oNearestPlaceable = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE,lTarget);
    string sImmortal="";
    string sPlotNPCs="\n-------------\nPLOT NPCs (tag, immortal)\n-------------";
    string sNonPlotNPCs="\n-------------\nNON-PLOT NPCs (tag, immortal)\n-------------";
    string sPlotPLCs="\n-------------\nPLOT PLCs (tag)\n-------------";
    string sNonPlotPLCs="\n-------------\nNON-PLOT PLCs (tag)\n-------------";
    int iPlayers=0;
    int iCreatures=0;
    int iPlaceables=0;

    if (oNearestPlaceable!=OBJECT_INVALID && (GetDistanceBetweenLocations(lTarget,GetLocation(oNearestPlaceable))<1.0)){
        GetPlaceableInfo(oNearestPlaceable, oDM);
        return;
    }

    while (GetIsObjectValid(oObject)){
        if (GetIsPC(oObject)) {
            ++iPlayers;
        }
        else if (GetObjectType(oObject)==OBJECT_TYPE_CREATURE && !GetIsEnemy(oObject, oDM)){
            ++iCreatures;

            if(GetPlotFlag(oObject)){
                sPlotNPCs=sPlotNPCs+"\n"+GetName(oObject)+" ("+GetTag(oObject)+", "+IntToString(GetImmortal(oObject))+")";
            }
            else{
                sNonPlotNPCs=sNonPlotNPCs+"\n"+GetName(oObject)+" ("+GetTag(oObject)+", "+IntToString(GetImmortal(oObject))+")";
            }
        }
        else if (GetObjectType(oObject)==OBJECT_TYPE_PLACEABLE){
            ++iPlaceables;
            if(GetPlotFlag(oObject)){
                sPlotPLCs=sPlotPLCs+"\n"+GetName(oObject)+" ("+GetTag(oObject)+")";
            }
            else{
                sNonPlotPLCs=sNonPlotPLCs+"\n"+GetName(oObject)+" ("+GetTag(oObject)+")";
            }        }
        oObject = GetNextObjectInArea(oArea);
    }
    SendMessageToPC(oDM,GetName(oArea));
    SendMessageToPC(oDM,"  Type: Area");
    SendMessageToPC(oDM,"  Tag: "+GetTag(oArea));
    SendMessageToPC(oDM,"  ResRef: "+GetResRef(oArea));
    SendMessageToPC(oDM,"  Area size: x="+IntToString(GetAreaSize(AREA_WIDTH, oArea))+", y="+IntToString(GetAreaSize(AREA_HEIGHT, oArea)));
    SendMessageToPC(oDM,"  NPCs in area: "+IntToString(iCreatures));
    SendMessageToPC(oDM,"  Placeables in area: "+IntToString(iPlaceables));

    if ( GetIsAreaNatural( oArea ) == AREA_NATURAL ){

        SendMessageToPC(oDM,"  Natural Area");
    }
    else{

        SendMessageToPC(oDM,"  Artificial Area");

    }

    if ( GetIsAreaAboveGround( oArea ) == AREA_ABOVEGROUND ){

        SendMessageToPC(oDM,"  Surface Area");
    }
    else{

        SendMessageToPC(oDM,"  Underground Area");

    }
    if ( GetIsAreaInterior( oArea ) ){

        SendMessageToPC(oDM,"  Interior Area");
    }
    else{

        SendMessageToPC(oDM,"  Exterior Area");

    }

    SendMessageToPC(oDM,sPlotNPCs);
    SendMessageToPC(oDM,sNonPlotNPCs);
    SendMessageToPC(oDM,sPlotPLCs);
    SendMessageToPC(oDM,sNonPlotPLCs);

    // tileset information
    SendMessageToPC(oDM, "  Tileset ResRef: " + GetTilesetResRef(oArea));

    // dynamic area information
    int areaType = GetLocalInt(oArea, "area_type");
    SendMessageToPC(oDM,"  Dynamic Area Type: " + IntToString(areaType));

    if(GetLocalInt(oArea, "NoDestroy") == 0)
    {
        SendMessageToPC(oDM,"  Area Status: default");
    }
    else
    {
        SendMessageToPC(oDM,"  Area Status: permanent");
    }
}

void GetPlaceableInfo(object oTarget, object oDM){
    SendMessageToPC(oDM,GetName(oTarget));
    SendMessageToPC(oDM,"  Type: Placeable Object");
    SendMessageToPC(oDM,"  Tag: "+GetTag(oTarget));
    SendMessageToPC(oDM,"  ResRef: "+GetResRef(oTarget));
    SendMessageToPC(oDM,"  Plot flag: "+IntToString(GetPlotFlag(oTarget)));
    SendMessageToPC(oDM,"  Useable flag: "+IntToString(GetUseableFlag(oTarget)));
}

void GetDoorInfo(object oTarget, object oDM){
    SendMessageToPC(oDM,GetName(oTarget));
    SendMessageToPC(oDM,"  Type: Door");
    SendMessageToPC(oDM,"  Tag: "+GetTag(oTarget));
    SendMessageToPC(oDM,"  ResRef: "+GetResRef(oTarget));
    SendMessageToPC(oDM,"  Lock DC: "+IntToString(GetLockUnlockDC(oTarget)));
    SendMessageToPC(oDM,"  Lock flag: "+IntToString(GetLocked(oTarget)));
    SendMessageToPC(oDM,"  Key tag: "+GetLockKeyTag(oTarget));
}


