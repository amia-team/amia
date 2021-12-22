void main(){

    object oPC     = GetPCSpeaker();
    string sAction = GetLocalString( OBJECT_SELF, "ds_action" );

    SetLocalString( oPC, "ds_action", sAction );

}
