// Flight feat.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/10/2011 PaladinOfSune    Initial release.
//

#include "amia_include"

void main( ){

    // Declare variables
    object oPC          = OBJECT_SELF;
    object oArea        = GetArea( oPC );
    object oTarget      = GetSpellTargetObject( );

    location lTarget    = GetSpellTargetLocation();
    effect eFly         = EffectDisappearAppear( lTarget );

    if(GetIsInsideTrigger(oPC,"deny_flight")==1)
    {
      SendMessageToPC( oPC, "You cannot use flight in this specific zone inside this area! This doesn't mean you cannot fly in the rest of the area.");
      return;
    }

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
