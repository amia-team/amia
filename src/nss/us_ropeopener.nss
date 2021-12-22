         // OnUsed event of the rope.  Opens and closes a particular
// portcullis.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/03/2005 bbillington      Initial Release
//


// Starting Declaration.

//obsolete

void main( )
{

// If the rope is used by a PC, activate the script. Otherwise, end(return).

    object oPC = GetLastUsedBy( );
    if ( !GetIsPC(oPC) ) return;

// Check for the nearest object with the tag of TestDoor and name it oPortcullis.
// If a door is required instead of a portcullis, don't forget to change
// the oPortcullis variable to suit the change.

    object oPortcullis = GetNearestObjectByTag( "TestDoor" );

// If an object named TestDoor can't be found, timestamp an entry into the
// database(Amia database) and inform the player.

    if ( !GetIsObjectValid(oPortcullis) ) {
        SendMessageToPC( oPC, "This rope does not appear to be working "
                            + "correctly.  Please notify a DM." );
        WriteTimestampedLogEntry( "ERROR! Test rope cannot find portcullis!" );
        return;
    }

// If oPortcullis is open, close it. Otherwise, open it.

    if ( GetIsOpen(oPortcullis) )
        AssignCommand( oPortcullis, ActionCloseDoor(oPortcullis) );
    else
        AssignCommand( oPortcullis, ActionOpenDoor(oPortcullis) );



    object PC=GetLastUsedBy();
    FloatingTextStringOnCreature("You pull the rope, and hear a creaking noise in the distance...",PC,FALSE);

}

