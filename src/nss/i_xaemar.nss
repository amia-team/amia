/*  Xaemar [Laban Oni's sowrd] :: On Equip

    --------
    Verbatim
    --------
    This script will execute whenever Xaemar is equipped.
    Specifically it dominates the wielder on a failed will save.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    052106  Aleph       Initial Release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"


void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ONHITCAST:{

            // Variables.
            object oPC          = OBJECT_SELF;
            object oVictim      = GetSpellTargetObject( );

            // On Hit: Fear DC 20, Hold Monster DC 20.
            if( WillSave( oVictim, 20, SAVING_THROW_TYPE_MIND_SPELLS, oPC ) < 1 )

                ApplyEffectToObject(
                    DURATION_TYPE_TEMPORARY,
                    EffectLinkEffects(
                        EffectLinkEffects( EffectFrightened( ), EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR ) ),
                        EffectLinkEffects( EffectParalyze( ), EffectVisualEffect( VFX_DUR_PARALYZE_HOLD ) ) ),
                    oVictim,
                    18.0 );

            // Flame Weapon damage.
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                EffectLinkEffects( EffectVisualEffect( VFX_IMP_FLAME_M ), EffectDamage( 10 + d4( ), DAMAGE_TYPE_FIRE ) ),
                oVictim );

            break;

        }

        case X2_ITEM_EVENT_EQUIP:{

            // Variables.
            object oPC          = GetPCItemLastEquippedBy( );
            object oItem        = GetPCItemLastEquipped( );

            int iWill           = GetWillSavingThrow(oPC);
            int iDice           = d20(1);
            effect eDom1        = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
            effect eDom2        = EffectDominated();
            effect eLink        = EffectLinkEffects(eDom1, eDom2);

            if (iDice != 20 && iWill < 35 && GetIsImmune(oPC,IMMUNITY_TYPE_MIND_SPELLS) == FALSE && GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL,oPC) == FALSE)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(3));
                FloatingTextStringOnCreature("* The sword has taken control of your mind! *", oPC, TRUE);
            }
            else if (iDice != 20 && iWill < 35 && GetIsImmune(oPC,IMMUNITY_TYPE_MIND_SPELLS) == FALSE && GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL,oPC) == FALSE)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(3));
                FloatingTextStringOnCreature("* The sword has taken control of your mind! *", oPC, TRUE);
            }
            else
            {
                FloatingTextStringOnCreature("* You've resisted the sword's domination. *", oPC, TRUE);
            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
