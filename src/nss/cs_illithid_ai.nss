/*  Illithid :: AI :: OnPerception :: Hostile To Another

    --------
    Verbatim
    --------
    This script will force this illithid to be hostile some other creature.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062306  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "nw_i0_plot"

void main( ){

    // Variables.
    object oSelf                = OBJECT_SELF;
    object oCreature            = GetLastPerceived( );
    string szTag                = GetTag( oCreature );

    // Thata.. illithid present, make it hostile to it and vice versa.
    if( !GetIsEnemy( oCreature ) )
        SetIsEnemy( oCreature );

    // Not in combat, get going!
    if( !GetIsInCombat( ) )
        AssignCommand( oSelf, ActionAttack( oCreature ) );

    ExecuteScript("nw_c2_default2", OBJECT_SELF);

}
