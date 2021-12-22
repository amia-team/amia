// Just a little fun script to spawn a badger when an object is sat upon.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/28/2013 PoS              Initial Release.
//

void BadgerSpawn( )
{
    location lLocation = GetLocation( GetNearestObjectByTag( "oakmist_badger_spawn" ) );

    object oBadger = CreateObject( OBJECT_TYPE_CREATURE, "oakmist_badger", lLocation );

    DelayCommand( 2.0, AssignCommand( oBadger, ActionSpeakString( "*A snarling badger crawls from out under the cushions, growling!*" ) ) );
}


void main()
{
    ExecuteScript("x2_plc_used_sit", OBJECT_SELF);

    int nBlocked = GetLocalInt( OBJECT_SELF, "blocked" );

    if( nBlocked == 1 )
    {
    }
    else
    {
        DelayCommand( 5.0, BadgerSpawn() );
        SetLocalInt( OBJECT_SELF, "blocked", 1 );
    }
}
