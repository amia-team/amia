/*
    Custom NPC Aura:
    Orcwort Entangle
        - Standard Entangle effect.
        - Spawns 1 new Wortling every Turn.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
//::Updated Aug 14, 2003 Georg: removed some artifacts
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void RipeWortling( object oCreator );

void main()
{
    //Declare major variables
    effect eHold = EffectEntangle();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    //Link Entangle and Hold effects
    effect eLink = EffectLinkEffects(eHold, eEntangle);
    object oCreator = GetAreaOfEffectCreator( OBJECT_SELF );

    object oTarget = GetFirstInPersistentObject();

    while(GetIsObjectValid(oTarget))
    {  // SpawnScriptDebugger();
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, GetAreaOfEffectCreator()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENTANGLE));
                //Make SR check
                if(!GetHasSpellEffect(SPELL_ENTANGLE, oTarget))
                {
                    //Make reflex save
                    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, 18))
                    {
                       //Apply linked effects
                       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
                    }
                }
            }
        }
        //Get next target in the AOE
        oTarget = GetNextInPersistentObject();
    }

    //check if it's time to spawn a wortling
    int nBlock = GetLocalInt( oCreator, "WortBlock" );
    if( nBlock == 0 )
    {
        DelayCommand( TurnsToSeconds( 1 ), RipeWortling( oCreator ) );
        SetLocalInt( oCreator, "WortBlock", 1 );
    }
}

void RipeWortling( object oCreator )
{
    if( GetIsObjectValid( oCreator ) )
    {
        CreateObject( OBJECT_TYPE_CREATURE, "tmb_wortling", GetLocation( oCreator ), TRUE );
        SetLocalInt( oCreator, "WortBlock", 0 );
    }
}
