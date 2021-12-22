void main(){

    //get user
    object oPC       = GetLastUsedBy();
    object oWaypoint = GetWaypointByTag(GetTag(OBJECT_SELF));

    //check for size
    if(GetCreatureSize(oPC) == CREATURE_SIZE_TINY || GetCreatureSize(oPC) == CREATURE_SIZE_SMALL){

        AssignCommand(oPC, SpeakString("*disappears into the hole*") );
        DelayCommand(1.0, AssignCommand(oPC, JumpToObject(oWaypoint,0) ) );

    }
    else {
        //message failure
        SendMessageToPC( oPC, "You are too big to fit in this hole" );
    }


}
