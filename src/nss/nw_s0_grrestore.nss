/*  Spell :: Greater Restoration

    --------
    Verbatim
    --------
    This spellscript removes ill effects according to the spell Greater Restoration.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    072206  kfw         Initial release.
    080806  kfw         Effect removal revision.
// 2008/07/05 disco               new blindness/underwater system
// 2008/07/05 disco               new racial trait system
// 2009/02/23 disco            Updated racial/class/area effects refresher
// 2011/04/16 PoS       Fixed polymorphed monks being deshifted
// 2023/12/07 Mav - Added Lycan Infection Removal
    ----------------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_spellhook"
#include "cs_inc_xp"
#include "amia_include"
#include "lycan_removal"

int GetEffectIsPolyEffect( effect eEffect, object oTarget ){

    int n = GetEffectSpellId( eEffect );
    int nLast = GetLocalInt( oTarget, "LAST_POLY_EFFECT" );

    if( n <= 0 || nLast <= 0 )
        return FALSE;

    return n==nLast;
}

int WhiteListedSpells(int nSpell){

    //KC Charge
    if(nSpell == 897)
        return TRUE;

    return FALSE;
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){


    // Call spell-hook code first.
    if( !X2PreSpellCastCode( ) )
        return;


    // Variables.
    object oPC          = GetSpellTargetObject( );
    effect eEffect      = GetFirstEffect( oPC );
    int nHealAmount     = GetMaxHitPoints( oPC ) - GetCurrentHitPoints( oPC );
    int nMonkLevel      = GetLevelByClass( CLASS_TYPE_MONK, oPC );

    //Remove extra Age variable from Time Leach, even if no penalties were applied
    DeleteLocalInt( oPC, "AgeDrain" );

    RemoveLycanInfection(oPC);

    // Void if of undead type.
    if( GetRacialType( oPC ) == RACIAL_TYPE_UNDEAD ){

        nHealAmount     = 0;
    }

    // If the PC is polymorphed and has monk levels, don't remove the AC decrease... it breaks the polymorph.
    if( GetIsPolymorphed( oPC ) && nMonkLevel > 0 ) {

        // Cycle the player's effects.
        while( GetIsEffectValid( eEffect ) ){

            // Variables.
            int nEffectType = GetEffectType( eEffect );

            switch( nEffectType ){

                // Ill effects.
                case EFFECT_TYPE_ABILITY_DECREASE:
                case EFFECT_TYPE_ATTACK_DECREASE:
                case EFFECT_TYPE_DAMAGE_DECREASE:
                case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
                case EFFECT_TYPE_SAVING_THROW_DECREASE:
                case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
                case EFFECT_TYPE_SKILL_DECREASE:
                case EFFECT_TYPE_BLINDNESS:
                case EFFECT_TYPE_DEAF:
                case EFFECT_TYPE_CURSE:
                case EFFECT_TYPE_DISEASE:
                case EFFECT_TYPE_POISON:
                case EFFECT_TYPE_PARALYZE:
                case EFFECT_TYPE_CHARMED:
                case EFFECT_TYPE_DOMINATED:
                case EFFECT_TYPE_DAZED:
                case EFFECT_TYPE_CONFUSED:
                case EFFECT_TYPE_FRIGHTENED:
                case EFFECT_TYPE_NEGATIVELEVEL:
                case EFFECT_TYPE_SLOW:
                case EFFECT_TYPE_STUNNED:{

                    //remove if it isn't a custom spell effect
                    if ( GetName( GetEffectCreator( eEffect ) ) != "ds_norestore" && !GetEffectIsPolyEffect( eEffect, oPC ) && !WhiteListedSpells(GetEffectSpellId(eEffect)) ){

                        RemoveEffect( oPC, eEffect );
                    }

                    break;

                }

                default:
                    break;

            }

            // Get the next effect on the player.
            eEffect         = GetNextEffect( oPC );
        }
    }
    else {

        // Cycle the player's effects.
        while( GetIsEffectValid( eEffect ) ){

            // Variables.
            int nEffectType = GetEffectType( eEffect );

            switch( nEffectType ){

                // Ill effects.
                case EFFECT_TYPE_ABILITY_DECREASE:
                case EFFECT_TYPE_AC_DECREASE:
                case EFFECT_TYPE_ATTACK_DECREASE:
                case EFFECT_TYPE_DAMAGE_DECREASE:
                case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
                case EFFECT_TYPE_SAVING_THROW_DECREASE:
                case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
                case EFFECT_TYPE_SKILL_DECREASE:
                case EFFECT_TYPE_BLINDNESS:
                case EFFECT_TYPE_DEAF:
                case EFFECT_TYPE_CURSE:
                case EFFECT_TYPE_DISEASE:
                case EFFECT_TYPE_POISON:
                case EFFECT_TYPE_PARALYZE:
                case EFFECT_TYPE_CHARMED:
                case EFFECT_TYPE_DOMINATED:
                case EFFECT_TYPE_DAZED:
                case EFFECT_TYPE_CONFUSED:
                case EFFECT_TYPE_FRIGHTENED:
                case EFFECT_TYPE_NEGATIVELEVEL:
                case EFFECT_TYPE_SLOW:
                case EFFECT_TYPE_STUNNED:{

                    //remove if it isn't a custom spell effect
                    if ( (GetName( GetEffectCreator( eEffect ) ) != "ds_norestore") && (GetEffectTag(eEffect) == "") ){

                        RemoveEffect( oPC, eEffect );
                    }

                    break;

                }

                default:
                    break;

            }

            // Get the next effect on the player.
            eEffect         = GetNextEffect( oPC );
        }
    }


    //racial traits & area effects
    //ApplyAreaAndRaceEffects( oPC );


    // Give the player full health.
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectLinkEffects(
            EffectVisualEffect( VFX_IMP_RESTORATION_GREATER ),
            EffectHeal( nHealAmount ) ),
        oPC );

    // Signal the spell event on the player.
    SignalEvent( oPC, EventSpellCastAt( OBJECT_SELF, SPELL_GREATER_RESTORATION, FALSE ) );

    return;

}
