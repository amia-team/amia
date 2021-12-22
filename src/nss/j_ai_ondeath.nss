/*  Amia :: Monster :: OnDeath

    --------
    Verbatim
    --------
    This script executes when the monster dies. It handles XP Reward & Loot.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    ??????  JAI         Initial release.
    080806  kfw         Optimization.
  20070412  disco       Ammo removal hack
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "j_inc_constants"
#include "inc_ds_ondeath"

void main( ){

    // Variables.
    object oMonster         = OBJECT_SELF;
    object oKiller          = GetLastKiller( );
    int nXPResult;

    // If we are set to, don't fire this script at all
    if( GetAIInteger( I_AM_TOTALLY_DEAD ) )
        return;

    // Pre-death-event.
    if( FireUserEvent( AI_FLAG_UDE_DEATH_PRE_EVENT, EVENT_DEATH_PRE_EVENT ) )
        // We may exit if it fires
        if( ExitFromUDE( EVENT_DEATH_PRE_EVENT ) )
            return;

    // Stops if we just applied EffectDeath to ourselves.
    if( GetLocalTimer( AI_TIMER_DEATH_EFFECT_DEATH ) )
        return;

    // Special: To stop giving out multiple amounts of XP, we use EffectDeath
    // to change the killer, so the XP systems will NOT award MORE XP.
    // - Even the default one suffers from this!
    if( GetAIInteger( WE_HAVE_DIED_ONCE ) ){

        if( !GetLocalTimer( AI_TIMER_DEATH_EFFECT_DEATH ) ){
            // Don't apply effect death to self more then once per 2 seconds.
            SetLocalTimer( AI_TIMER_DEATH_EFFECT_DEATH, f2 );
            // This should make the last killer us.
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection( ), OBJECT_SELF );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetMaxHitPoints( ) ), OBJECT_SELF );
        }
    }

    else if( oKiller != OBJECT_SELF ){
        // Set have died once, stops giving out mulitple amounts of XP.
        SetAIInteger( WE_HAVE_DIED_ONCE, TRUE );
        // Reward XP.
        nXPResult = RewardXPForKill( );
    }

    //delete certain items
    object oItem        = GetItemPossessedBy( oMonster, "ds_delete" );
    if ( oItem != OBJECT_INVALID ){

        DestroyObject( oItem );
    }

    // Note: Here we do a simple way of checking how many times we have died.
    // Nothing special. Debugging most useful aspect.
    int iDeathCounterNew = GetAIInteger( AMOUNT_OF_DEATHS );
    iDeathCounterNew++;
    SetAIInteger( AMOUNT_OF_DEATHS, iDeathCounterNew );

    // Here is the last time (in game seconds) we died. It is used in the executed script
    // to make sure we don't prematurly remove areselves.

    // We may want some sort of visual effect - like implosion or something, to fire.
    int iDeathEffect = GetAIConstant( AI_DEATH_VISUAL_EFFECT );

    // Valid constants from 0 and up. Apply to our location (not to us, who will go!)
    if( iDeathEffect >= i0 )
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( iDeathEffect ), GetLocation( OBJECT_SELF ) );

    // Always shout when we are killed. Reactions - Morale penalty, and attack the killer.
    AISpeakString( I_WAS_KILLED );

    // Last words.
    SpeakArrayString( AI_TALK_ON_DEATH );

    // Generate treasure.
    GenerateLoot( oMonster, nXPResult );


    // Signal the death event.
    FireUserEvent( AI_FLAG_UDE_DEATH_EVENT, EVENT_DEATH_EVENT );

    return;

}
