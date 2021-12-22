/* Random Dialog

    --------
    Verbatim
    --------
    This script will randomly trigger, and randomly pull a string from the
    MySQL database and make the NPC speak it.

    Variables stored on the trigger:
    1. "table" : Which table in the MySQL DB to query.

    Other notes:
    1. Create a column in this table called "dialog" and put your text there.
    2. This trigger will randomly speak it then.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    010907  kfw         Initial release.
    ----------------------------------------------------------------------------
*/

// Includes.
#include "aps_include"

void main( ){

    // Variables.
    object oTrigger     = OBJECT_SELF;
    string sDBTable     = GetLocalString( oTrigger, "table" );
    string sText        = "Goober!";
    object oNPC         = GetNearestObjectByTag( "random_npc" );


    // Randomly determine whether the dialog should trigger.
    if( Random( 101 ) > 50 )
        return;

    // Randomly determine which dialog to speak.
    SQLExecDirect( "select dialog from " + sDBTable + " order by rand( ) limit 1;" );
    if( SQLFetch( ) )
        sText = SQLGetData( 1 );

    // Make the NPC speak the dialog.
    AssignCommand( oNPC, SpeakString( sText ) );

    return;

}
