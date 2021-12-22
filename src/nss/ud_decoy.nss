// User-defined events for decoy.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/15/2004 jpavelch         Initial release.
// 20050214   jking            Refactored constants.

#include "inc_userdefconst"


// All enemies within 10 meters of decoy have a 50% chance of attacking it.
//
void InitDecoy( )
{
    object oSelf = OBJECT_SELF;
    object oCreator = GetLocalObject( oSelf, "Creator" );

    location lSelf = GetLocation( oSelf );
    object oCreature = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lSelf, TRUE );
    while ( GetIsObjectValid(oCreature) ) {
        if ( GetIsEnemy(oCreator, oCreature) ) {
            if ( d100 () <= 50 ) {
                SetIsTemporaryEnemy( oSelf, oCreature );
                AssignCommand( oCreature, ClearAllActions() );
                AssignCommand( oCreature, ActionAttack(oSelf) );
            }
        }
        oCreature = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lSelf, TRUE );
    }
}

void main( )
{
    int nEvent = GetUserDefinedEventNumber( );
    switch ( nEvent ) {
        case INITIALIZE:  InitDecoy( ); break;
    }
}
