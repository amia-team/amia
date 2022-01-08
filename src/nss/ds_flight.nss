// Flight feat.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/10/2011 PaladinOfSune    Initial release.
//

void main( ){

    // Declare variables
    object oPC          = OBJECT_SELF;
    object oArea        = GetArea( oPC );
    object oTarget      = GetSpellTargetObject( );

    location lTarget    = GetSpellTargetLocation();
    effect eFly         = EffectDisappearAppear( lTarget );

    // Check if they can fly here
    if( GetLocalInt( oArea, "CS_NO_FLY" ) == 1 ) {
        FloatingTextStringOnCreature( "- You are unable to fly in this area! -", oPC, FALSE );
        return;
    }
    //check block time
    if ( GetLocalInt(oPC,"flight_cooldown") == 1 ){
        SendMessageToPC( oPC, "Your flight capabilities are still recovering.");
        return;
    }
    else
    {
    // New cooldown
    int nCooldown = 12;

    //apply the cooldown time
    SetLocalInt( oPC, "flight_cooldown", 1);
    SendMessageToPC( oPC, "Your flight capabilities will recover in " + IntToString(nCooldown) + " seconds.");
    DelayCommand( IntToFloat( nCooldown ),SetLocalInt( oPC, "flight_cooldown", 0));
    // The duration of porting the PC takes four seconds.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFly, oPC, 4.0 );
    }
}
