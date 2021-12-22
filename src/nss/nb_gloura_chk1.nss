// Gloura Quest :: Check for the presence of Miss Gloura, bug out if this is the case
int StartingConditional(){

    // Variables
    object oPC = GetPCSpeaker();

    // Gloura is nearby
    if( GetNearestObjectByTag( "nb_glouraboss", oPC, 1 ) != OBJECT_INVALID ){

        return( FALSE );
    }
    // Gloura is not nearby
    else{

        return( TRUE );
    }
}
