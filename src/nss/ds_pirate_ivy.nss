void main(){

    //get user
    object oPC       = GetLastUsedBy();
    object oWaypoint = GetWaypointByTag(GetTag(OBJECT_SELF));

    //check for size
    if(GetWeight(oPC) < 2001){

        AssignCommand(oPC, SpeakString("*climbs the ivy*") );
        DelayCommand(1.0, AssignCommand(oPC, JumpToObject(oWaypoint,0) ) );

    }
    else {
        //message failure
        SendMessageToPC( oPC, "You are too heavy. The ivy obviously can't take your weight." );
    }


}
