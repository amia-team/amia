
void main( ){

    object oTarget = GetNearestObjectByTag( "ds_seat" );

    if ( GetIsObjectValid( oTarget ) ) {

        if(GetLocalString(OBJECT_SELF, "ds_speak") != "" || GetLocalInt(OBJECT_SELF, "ds_speak") != 0){
            AssignCommand(OBJECT_SELF, ExecuteScript("ds_speak", OBJECT_SELF));
        }
        ClearAllActions();
        ActionSit( oTarget );
    }
}
