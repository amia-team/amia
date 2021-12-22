// Creature ability: Charm Person
#include "x2_inc_switches"
void Charm(object oPC,object oVictim);
void main(){

    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables.
            object oVictim          = GetItemActivatedTarget( );
            object oPC              = GetItemActivator( );

            AssignCommand(oPC,Charm(oPC,oVictim));

            break;

        }

        default:break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}

void Charm(object oPC,object oVictim)
{
            float fDuration         = RoundsToSeconds( 2 + GetHitDice( oPC ) / 3 );

            effect eCharm           = EffectLinkEffects( EffectCharmed( ), EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED ) );
            int nDC                 = 10 + GetHitDice( oPC )/2 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
            int nRace               = GetRacialType( oVictim );

            // Resolve target status : ( Player OR Non-plot Creature ) AND ( Humanoid Type ).
            if( ( GetIsPC( oVictim )    ||
                ( GetObjectType( oVictim ) == OBJECT_TYPE_CREATURE && !GetPlotFlag( oVictim ) ) ) &&

                (   nRace == RACIAL_TYPE_DWARF              ||
                    nRace == RACIAL_TYPE_HUMAN              ||
                    nRace == RACIAL_TYPE_ELF                ||
                    nRace == RACIAL_TYPE_GNOME              ||
                    nRace == RACIAL_TYPE_HUMANOID_GOBLINOID ||
                    nRace == RACIAL_TYPE_HALFLING           ||
                    nRace == RACIAL_TYPE_HALFELF            ||
                    nRace == RACIAL_TYPE_HALFORC            ||
                    nRace == RACIAL_TYPE_HUMANOID_MONSTROUS ||
                    nRace == RACIAL_TYPE_HUMANOID_ORC       ||
                    nRace == RACIAL_TYPE_HUMANOID_REPTILIAN )   ){

                // will save to negate
                if( WillSave( oVictim, nDC, SAVING_THROW_TYPE_SPELL, oPC ) < 1){
                    // cupid em!
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eCharm, oVictim, fDuration);
                    }
                }

}
