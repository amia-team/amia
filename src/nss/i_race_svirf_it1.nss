// Svirfneblin: Spell-like Ability: Blindness/Deafness
#include "x2_inc_switches"
void DoBlindnessDeafness(object oPC,object oVictim);
void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:{

            object oPC=GetItemActivator( );
            object oVictim=GetItemActivatedTarget( );

            AssignCommand(oPC,DoBlindnessDeafness(oPC,oVictim));

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}

void DoBlindnessDeafness(object oPC,object oVictim)
{
            float fDuration=RoundsToSeconds( GetHitDice( oPC ) );   // 1 round per level
            effect eBlindDeaf=EffectLinkEffects( EffectDeaf( ), EffectBlindness( ) );

            // candy
            eBlindDeaf=EffectLinkEffects( eBlindDeaf, EffectVisualEffect( VFX_IMP_BLIND_DEAF_M ) );

            int nDC= 10 + GetHitDice(oPC) + GetAbilityModifier( ABILITY_CHARISMA, oPC);

            int nRace=GetRacialType(oVictim);

            // resolve target status
            if( (oVictim==OBJECT_INVALID) || (GetIsEnemy( oVictim, oPC)==FALSE) ){

                FloatingTextStringOnCreature(
                "- Svirfneblin Spell-like Ability may only be cast on a hostile creature! -", oPC, FALSE);

                return;

            }

            // fortitude save to negate
            if(FortitudeSave( oVictim, nDC, SAVING_THROW_TYPE_SPELL, oPC)<1)
            {
                // cupid em!
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBlindDeaf, oVictim, fDuration);
            }
}
