// Conversation action to port PC to Beastman Caves level 5.  If PC fails
// a DC 16 reflex save then takes 1d20 damage.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/02/2004 jpavelch         Initial release.
//
//obsolete?
//
//

void main( )
{
    object oPC = GetPCSpeaker( );

    object oTarget = GetWaypointByTag("wp_beast5");
    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, ActionJumpToLocation(GetLocation(oTarget)) );

    if ( ReflexSave(oPC, 28) == 0 ) {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage(d20()), oPC );
        AssignCommand( oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 2.0) );
        SendMessageToPC( oPC, "Your hands slip from the rope and you fall with a loud thud to the ground." );
    }
}

