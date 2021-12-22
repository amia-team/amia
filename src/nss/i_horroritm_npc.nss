/* Antediluvian Horror - NPC Custom OnHit Weapon Properties

Produces the "hostile targets only" Custom OnHit AoEs for the
weapons used by the Antediluvian Horror boss mobs for the Labyrinth dungeon.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
06/27/12 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"
#include "nw_i0_spells"

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch ( nEvent )
    {
        case X2_ITEM_EVENT_ONHITCAST:
        {
            object oCritter = OBJECT_SELF;
            object oVictim = GetSpellTargetObject();
            location lVictim = GetLocation( oVictim );

            //Check to make sure it's only being used once per round max
            if( GetLocalInt( oCritter, "NovaUsed" ) >= 1 )
            {
                return;
            }

            string sItem = GetResRef( GetSpellCastItem() );

            if( sItem == "horrorswrd_npc" )
            {
                effect eNova = EffectVisualEffect( VFX_FNF_FIREBALL );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eNova, oVictim );

                object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                while( GetIsObjectValid( oTarget ) )
                {
                    if( GetIsEnemy( oTarget, oCritter ) )
                    {
                        int nDamage = GetReflexAdjustedDamage( d6(10), oTarget, 28, SAVING_THROW_TYPE_FIRE, oCritter );
                        effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
                    }
                    oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                }
                SetLocalInt( oCritter, "NovaUsed", 1 );
                DelayCommand( 6.0, SetLocalInt( oCritter, "NovaUsed", 0 ) );
            }
            else if( sItem == "horroraxe_npc" )
            {
                effect eNova = EffectVisualEffect( VFX_IMP_PULSE_COLD );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eNova, oVictim );

                object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                while( GetIsObjectValid( oTarget ) )
                {
                    if( GetIsEnemy( oTarget, oCritter ) )
                    {
                        int nDamage = GetReflexAdjustedDamage( d6(10), oTarget, 28, SAVING_THROW_TYPE_COLD, oCritter );
                        effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
                    }
                    oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                }
                SetLocalInt( oCritter, "NovaUsed", 1 );
                DelayCommand( 6.0, SetLocalInt( oCritter, "NovaUsed", 0 ) );
            }
            if( sItem == "horrorhamr_npc" )
            {
                effect eNova = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_ACID );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eNova, oVictim );

                object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                while( GetIsObjectValid( oTarget ) )
                {
                    if( GetIsEnemy( oTarget, oCritter ) )
                    {
                        int nDamage = GetReflexAdjustedDamage( d6(10), oTarget, 28, SAVING_THROW_TYPE_ACID, oCritter );
                        effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_ACID, DAMAGE_POWER_ENERGY );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
                    }
                    oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                }
                SetLocalInt( oCritter, "NovaUsed", 1 );
                DelayCommand( 6.0, SetLocalInt( oCritter, "NovaUsed", 0 ) );
            }
            else if( sItem == "horrorbolt_npc" )
            {
                effect eBeam1 = EffectBeam( VFX_BEAM_LIGHTNING, oCritter, BODY_NODE_CHEST );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam1, oVictim, 1.0 );

                object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                while( GetIsObjectValid( oTarget ) )
                {
                    if( GetIsEnemy( oTarget, oCritter ) )
                    {
                        int nDamage = GetReflexAdjustedDamage( d6(10), oTarget, 28, SAVING_THROW_TYPE_ELECTRICITY, oCritter );
                        effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
                        effect eBeam2 = EffectBeam( VFX_BEAM_LIGHTNING, oVictim, BODY_NODE_CHEST );
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam2, oTarget, 1.0 );
                    }
                    oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                }
                SetLocalInt( oCritter, "NovaUsed", 1 );
                DelayCommand( 6.0, SetLocalInt( oCritter, "NovaUsed", 0 ) );
            }
            else if( sItem == "horrorscyt_npc" )
            {
                effect eNova = EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION );
                effect eShake = EffectVisualEffect(356);
                eNova = EffectLinkEffects( eShake, eNova );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eNova, oVictim );

                effect eVis  = EffectVisualEffect(VFX_IMP_SONIC);
                effect eVis2 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
                effect eVis3 = EffectVisualEffect(VFX_IMP_STUN);
                effect eDeaf = EffectDeaf();
                effect eKnock = EffectKnockdown();
                effect eStun = EffectStunned();

                object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                while( GetIsObjectValid( oTarget ) )
                {
                    if( GetIsEnemy( oTarget, oCritter ) )
                    {
                        if( !MySavingThrow( SAVING_THROW_FORT, oTarget, 31, SAVING_THROW_TYPE_SONIC ) )
                        {
                            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDeaf, oTarget, 60.0 );
                            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oTarget );
                        }
                        if( !MySavingThrow( SAVING_THROW_WILL, oTarget, 28, SAVING_THROW_TYPE_SONIC ) )
                        {
                            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0 );
                            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
                        }
                        if( !MySavingThrow( SAVING_THROW_REFLEX, oTarget, 28, SAVING_THROW_TYPE_SONIC ) )
                        {
                            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0 );
                            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis3, oTarget,4.0 );
                        }
                    }
                    oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lVictim, TRUE, OBJECT_TYPE_CREATURE );
                }
                SetLocalInt( oCritter, "NovaUsed", 1 );
                DelayCommand( 6.0, SetLocalInt( oCritter, "NovaUsed", 0 ) );
            }
            break;
        }
        default:
        {
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
