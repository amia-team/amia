// Boneyard Bite Ability Drain
#include "x2_inc_switches"
#include "ds_ai2_include"

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

            if( FortitudeSave( oTarget, 30, SAVING_THROW_TYPE_NONE, oCritter ) == 0 )
            {
                //Ability Drain on each slam attack
                effect eSTR = EffectAbilityDecrease( ABILITY_STRENGTH, d4(2) );
                effect eDEX = EffectAbilityDecrease( ABILITY_DEXTERITY, d4(2) );
                effect eCON = EffectAbilityDecrease( ABILITY_CONSTITUTION, d4(2) );
                effect eLink = EffectLinkEffects( eSTR, eDEX );
                       eLink = EffectLinkEffects( eLink, eCON );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget );
            }
        }
        default:
        {
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
