void main(){

    object oPC          = GetPCSpeaker();
    object oModule      = GetModule();

    if ( GetLocalInt( oModule, "singleplayer" ) == 1 ){

        ActivatePortal( oPC, GetLocalString( oModule, "OtherTestServer" ) );
    }
    else{

        ActivatePortal( oPC, GetLocalString( oModule, "OtherServer" ) );
    }
}
