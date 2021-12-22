/*  Spell :: Lesser Restoration

    --------
    Verbatim
    --------
    This spellscript removes ill effects according to the spell Lesser Restoration.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    072206  kfw         Initial release.
    080806  kfw         Effect removal revision.
 2008/07/05 disco       new blindness/underwater system
 2008/07/05 disco       new racial trait system
 2009/02/23 disco       Updated racial/class/area effects refresher
    ----------------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_spellhook"
#include "cs_inc_xp"
#include "amia_include"

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

    //Remove extra Age variable from Time Leach, even if no penalties were applied
    DeleteLocalInt( oPC, "AgeDrain" );


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
            case EFFECT_TYPE_SKILL_DECREASE:{

                //remove if it isn't a custom spell effect
                if ( GetName( GetEffectCreator( eEffect ) ) != "ds_norestore" && !GetEffectIsPolyEffect( eEffect, oPC ) && !WhiteListedSpells(GetEffectSpellId(eEffect))){

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

    //racial traits & area effects
    //ApplyAreaAndRaceEffects( oPC );


    // Give the player full health.
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect( VFX_IMP_RESTORATION_LESSER ),
        oPC );

    // Signal the spell event on the player.
    SignalEvent( oPC, EventSpellCastAt( OBJECT_SELF, SPELL_LESSER_RESTORATION, FALSE ) );

    return;

}
