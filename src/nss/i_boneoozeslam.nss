// OnHit Draining and Wounding effects for Bone Ooze attack
#include "x2_inc_switches"

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {
        case X2_ITEM_EVENT_ONHITCAST:
        {
            // vars
            object oTarget = GetSpellTargetObject();
            object oCritter = OBJECT_SELF;
            effect eVis = EffectVisualEffect( VFX_COM_CHUNK_BONE_MEDIUM );

            if( FortitudeSave( oTarget, 35, SAVING_THROW_TYPE_NONE, oCritter ) == 0 )
            {
                //Ability Drain on each slam attack
                effect eSTR = EffectAbilityDecrease( ABILITY_STRENGTH, d6(1) );
                effect eDEX = EffectAbilityDecrease( ABILITY_DEXTERITY, d6(1) );
                effect eCON = EffectAbilityDecrease( ABILITY_CONSTITUTION, d6(1) );
                effect eLink = EffectLinkEffects( eSTR, eDEX );
                       eLink = EffectLinkEffects( eLink, eCON );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget );

                //And heal the ooze each time (or give temp HP if at full health)
                int nCurrent = GetCurrentHitPoints( oCritter );
                int nMax = GetMaxHitPoints( oCritter ) - 4;
                effect eHeal;
                if( nCurrent >= nMax )
                {
                    eHeal = EffectTemporaryHitpoints( 5 );
                }
                else
                {
                    eHeal = EffectHeal( 5 );
                }
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oCritter );
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eHeal, oCritter );
            }
        }
        default:
        {
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
