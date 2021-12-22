/*  renamer_listener

--------
Verbatim
--------
Sets listener

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
12-23-06  Disco       Start of header
------------------------------------------------------------------

*/

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------


void main(){

    //sets up which shouts the NPC will listen to.

    SendMessageToPC( GetLastPerceived(), "Renamer spots "+GetName( GetLastPerceived() ) );


    SetListening( OBJECT_SELF, TRUE );          //be sure NPC is listening
    SetListenPattern( OBJECT_SELF, "**", 4545 );

}
