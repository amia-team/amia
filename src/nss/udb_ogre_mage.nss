/* ds_spawn_boss

dummy
*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

void DoOrbDamage( object oOrb ){

    if ( !GetIsObjectValid( oOrb ) ){

        return;
    }

    object oTarget = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC );
    effect eDamage = EffectDamage( d8(2) );
    effect eBeam   = EffectBeam( VFX_BEAM_EVIL, oOrb, BODY_NODE_CHEST );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 3.0 );

    DelayCommand( 10.0, DoOrbDamage( oOrb ) );
}


void main(){

    if ( GetIsBlocked() ){

        return;
    }

    SetBlockTime( OBJECT_SELF, 15 );

    object oPC  = GetEnteringObject();
    object oWP1 = GetLocalObject( OBJECT_SELF, "WP1" );
    object oWP2 = GetLocalObject( OBJECT_SELF, "WP2" );

    if ( !GetIsObjectValid( oWP1 ) ){

        oWP1 = GetNearestObjectByTag( "WP1" );

        SetLocalObject( OBJECT_SELF, "WP1", oWP1 );
    }

    if ( !GetIsObjectValid( oWP2 ) ){

        oWP2 = GetNearestObjectByTag( "WP2" );

        SetLocalObject( OBJECT_SELF, "WP2", oWP2 );
    }

    object oMage = ds_spawn_critter( oPC, "udb_ogre_mage", GetLocation( oWP1 ) );
    object oOrb  = GetNearestObjectByTag( "udb_glowingorb" );

    if ( !GetIsObjectValid( oOrb ) ){

        oOrb  = CreateObject( OBJECT_TYPE_PLACEABLE, "udb_glowingorb", GetLocation( oWP2 ) );
    }

    DoOrbDamage( oOrb );
}
