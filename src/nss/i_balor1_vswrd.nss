// Completed by Kungfoowiz on the 24th September 2005. PaladinOfSune halved the
// DC on the vorpal - 10 base was too high.

// Version 1.0

// This script handles the OnHit of the Summoned Balor Lord's sword.


#include "x2_inc_switches"
void main()
{

    int nEvent=GetUserDefinedItemEventNumber();
    int nReturn=X2_EXECUTE_SCRIPT_END;

    switch(nEvent){
        case X2_ITEM_EVENT_ONHITCAST:{

            // vars
            object oVictim=GetSpellTargetObject();

            int nAttackerSTRMod=GetAbilityModifier(
                ABILITY_STRENGTH,
                OBJECT_SELF);

            int nVorpalDC   =   5                          +
                                GetHitDice(OBJECT_SELF)/2   +
                                nAttackerSTRMod;

            // mortal?
            if(GetIsImmune(
                oVictim,
                IMMUNITY_TYPE_CRITICAL_HIT)==TRUE){
                break;
            }

            /* 25% chance vorpal on every hit
                since the vorpal DCs are hardcoded (an are too low),
                an also no way to check for critical hits =(   */
            if(d20(1)<15){
                break;
            }
            // threat roll
            if(     (   d20(1)                              +
                        GetBaseAttackBonus(OBJECT_SELF)     +
                        nAttackerSTRMod )   <   GetAC(oVictim)  ){

                        break;

            }

            // failed the vorpal dc
            if(ReflexSave(
                oVictim,
                nVorpalDC,
                SAVING_THROW_TYPE_DEATH)==0){

                // reduce victim's hitpoints below -10 to slay them
                int nVorpalDmg=GetCurrentHitPoints(oVictim)+50;

                // dmg vfx
                effect eVorpalDmg=EffectDamage(
                    nVorpalDmg,
                    DAMAGE_TYPE_MAGICAL);

                // death vfx
                effect eVorpalVis=EffectVisualEffect(VFX_IMP_DEATH);

                // pull it together
                effect eVorpal=EffectLinkEffects(
                    eVorpalDmg,
                    eVorpalVis);

                // slap it on
                ApplyEffectToObject(
                    DURATION_TYPE_INSTANT,
                    eVorpal,
                    oVictim,
                    0.0);

            }

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nReturn);
}
