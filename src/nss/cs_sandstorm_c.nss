// Sandstorm (OnExit Aura)
//
// Creates an area of effect that blinds, slows and confuses targets inside.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 30/09/2012 PoS              Initial Release.
//


void main()
{
    // Variables.
    object oTarget    = GetExitingObject( );
    object oPC        = GetAreaOfEffectCreator( );

    DeleteLocalInt( oTarget, "sandstorm_skill" );
}
