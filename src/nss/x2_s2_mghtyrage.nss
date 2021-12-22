/*  Feat :: Barbarian Rage : Mighty

    This now just calls the barbrage script. To give 3 extra rage attempts.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082706  kfw         Initial release.
    062307  kfw         See Amia release 1.37 for changes.
    071910  Jehran      See nw_s1_barbrage
    010911  PoS         Gives a usage back if done while recovering.
    ----------------------------------------------------------------------------

*/

#include "amia_include"

void main()
{
    object oPC                  = OBJECT_SELF;

    // Prevent stacking.
    if( GetHasFeatEffect( FEAT_BARBARIAN_RAGE, oPC ) || GetHasFeatEffect( FEAT_MIGHTY_RAGE, oPC ) ) {

        FloatingTextStringOnCreature( "<cþ>- You're already raging! -</c>", oPC, FALSE );
        return;
    }

    // Cooldown of a turn between rages.
    if ( GetIsBlocked( oPC, "is_raging" ) > 0 ) {

        FloatingTextStringOnCreature( "<cþ>- You must recover for a turn before raging again! -</c>", oPC, FALSE );
        IncrementRemainingFeatUses( oPC, FEAT_MIGHTY_RAGE );
        return;
    }

    ExecuteScript( "nw_s1_barbrage", OBJECT_SELF );
}
