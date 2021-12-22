
int tha_get_area_size(object oArea, string sDirection);

void main(){

    object oArea=GetArea(OBJECT_SELF);
    object oPC=GetLastUsedBy();
    object oObject=GetFirstObjectInArea(oArea);
    int nPlaceables;

    int nDimensionsX=tha_get_area_size(oArea,"x");
    int nDimensionsY=tha_get_area_size(oArea,"y");
    string sDimensions=IntToString(nDimensionsX)+"x"+IntToString(nDimensionsY);

    while(oObject!=OBJECT_INVALID){

        int nObjectType=GetObjectType(oObject);
        string szTag=GetTag(oObject);

        if(nObjectType==OBJECT_TYPE_PLACEABLE){
            ++nPlaceables;
        }
        oObject=GetNextObjectInArea(oArea);
    }
    string sMessage="Area Name - Area Tag - Area Dimensions - Placeables - Placeables/Tile";
    SendMessageToPC(oPC,sMessage);
    sMessage=GetName(oArea)+" - "+GetTag(oArea)+" - "+sDimensions+" - "+IntToString(nPlaceables)+" - "+IntToString(nPlaceables/(nDimensionsX*nDimensionsY));
    SendMessageToPC(oPC,sMessage);
}

//adapted the script from whatshisname
int tha_get_area_size(object oArea, string sDirection){

    //variables
    int nSize;
    int nLight;
    vector vTile;
    location lTile;

    while(nLight!=517){
        if(sDirection=="x"){
            vTile=Vector(IntToFloat(nSize), 0.0);
        }
        else if(sDirection=="y"){
            vTile=Vector(0.0, IntToFloat(nSize));
        }
        lTile=Location(oArea, vTile, 0.0);
        nLight=GetTileMainLight1Color(lTile);
        ++nSize;
    }
    return(nSize-1);    //a while loop always goes 'one too many'
}
