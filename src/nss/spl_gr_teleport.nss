/*
    Custom Spell: (NPC ONLY)
    Teleport Without Error (Phane Boss)
    - Teleports the Phane to a random location up to 20 meters out from the
    central waypoint in its lair, leaving behind a Time Duplicate for 1 round
    as a diversionary tactic. Resets Phane's targetting.
*/

#include "x0_i0_spells"
#include "amia_include"

void main()
{
    //Gather spell details
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject( );
    location lTarget = GetSpellTargetLocation( );

    //Run normally if cast by a PC
    if( GetIsPC( oCaster ) && !GetIsDMPossessed( oCaster ) )
    {
        SendMessageToPC( oCaster, "This spell is not permitted for PC use." );
        return;
    }
    //Otherwise generate custom attributes for NPCs
    else
    {

    }

    effect eInvis = EffectInvisibility( INVISIBILITY_TYPE_NORMAL );
    effect eSanc = EffectSanctuary( 999 );
    location lCritter = GetLocation( oCaster );
    object oWaypoint = GetWaypointByTag( "Phane_Teleport" );
    location lPort = GetRandomLocation( GetArea( oCaster ), oWaypoint, 30.0 );

    AssignCommand( oCaster, ClearAllActions() );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eInvis, oCaster );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSanc, oCaster, 1.0 );
    CreateObject( OBJECT_TYPE_CREATURE, "phane2", lCritter );
    AssignCommand( oCaster, ActionJumpToLocation( lPort ) );
    DelayCommand( 0.5, AssignCommand( oCaster, ActionAttack( oTarget ) ) );
}
