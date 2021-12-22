void main(){

    object oPC = GetLastUnlocked();

    SetLocked( OBJECT_SELF, TRUE );

    SendMessageToPC( oPC, "You cannot pick this lock the standard way." );

}
