//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_in
//group: rentable housing
//used as: door entering script
//date: 2009-09-04
//author: disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
//#include "inc_ds_rental"
//#include "nwnx_areas"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    /*object oPC   = GetClickingObject();
    object oDoor = GetLocalObject( OBJECT_SELF, RNT_TARGET );
    object oArea = GetArea(OBJECT_SELF);

    int iReturnSet = GetLocalInt(oPC, "fw_rental_in");
    if(iReturnSet == 0)
    {
        SetLocalInt( oPC, "fw_rental_in", 1);
        int iAreaType = GetLocalInt( oArea, "area_type" );
        SetLocalString(oPC, "fw_last_rr", GetResRef(oArea));
        SetLocalInt(oPC, "fw_last_type", iAreaType);
        vector vReturn = GetPosition(oPC);
        SetLocalFloat(oPC, "fw_return_x", vReturn.x);
        SetLocalFloat(oPC, "fw_return_y", vReturn.y);
        SetLocalFloat(oPC, "fw_return_z", vReturn.z);
        AssignCommand( oPC, JumpToObject( oDoor ) );
    }
    else
    {
        vector vDestPosition = Vector(GetLocalFloat(oPC,"fw_return_x"),GetLocalFloat(oPC,"fw_return_y"),GetLocalFloat(oPC,"fw_return_z"));
        int iArea = 0;
        object oDestArea = AREAS_GetArea(iArea);
        string sDestResRef = GetLocalString(oPC, "fw_last_rr");
        while(GetIsObjectValid(oDestArea))
        {
            if(GetResRef(oDestArea)==sDestResRef)
            {
                DeleteLocalInt(oPC,"fw_rental_in");
                DeleteLocalFloat(oPC, "fw_return_x");
                DeleteLocalFloat(oPC, "fw_return_y");
                DeleteLocalFloat(oPC, "fw_return_z");
                location oLoc = Location(oDestArea, vDestPosition, 90.0);
                AssignCommand( oPC, JumpToLocation( oLoc ) );
                return;
            }
            iArea++;
            oDestArea = AREAS_GetArea(iArea);
        }
        DeleteLocalInt(oPC,"fw_rental_in");
        SendMessageToAllDMs(GetName(oPC)+" is stuck in a rental house.");
    }*/
}
