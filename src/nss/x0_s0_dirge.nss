/* Dirge

    - duration: 1 round per casterlevel
    - creates an aura about the caster that if an enemy enters it she will suffer every round -2 to STR and DEX
    - removes STR and DEX penalties if an enemy exits the caster's aura

*/

// includes
#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

void DirgePulse( object oCaster, int nSpellSaveDC );

void DoDirgePulseDamage( object oVictim, object oCaster );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    // spellhook
    if(X2PreSpellCastCode()==FALSE){

        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // vars
    object oPC          = OBJECT_SELF;
    int nCasterLevel    = GetCasterLevel(oPC);
    float fDuration     = RoundsToSeconds(nCasterLevel);
    int nSpellSaveDC    = GetSpellSaveDC();


    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( oPC, "ds_spell_"+IntToString( SPELL_DIRGE ) );

    if ( GetIsObjectValid( GetSpellCastItem() ) || nTransmutation == 0 ) {

        SetLocalInt( oPC, "dirge", 1 );
    }
    else{

        SetLocalInt( oPC, "dirge", nTransmutation );
    }
    //--------------------------------------------------------------------------

    // stacking check
    SignalEvent( oPC, EventSpellCastAt( oPC, SPELL_DIRGE, FALSE));

    RemoveEffectsFromSpell( oPC, SPELL_DIRGE);

    // candy
    effect eDirgeEnable = EffectVisualEffect(VFX_FNF_PWKILL);
    effect eRedAura     = EffectVisualEffect(VFX_IMP_AURA_NEGATIVE_ENERGY);

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    if ( nTransmutation > 2 ){

        DirgePulse( oPC, nSpellSaveDC );

        return;
    }
    //--------------------------------------------------------------------------

    // double the duration if Extended Metamagic was used
    if(GetMetaMagicFeat()==METAMAGIC_EXTEND){

        fDuration*=2.0;

    }
    // caster aura
    // aura vfx and scriptset
    effect eDirgeVFX=EffectAreaOfEffect(
        AOE_PER_CUSTOM_AOE,
        "cs_dirge_en",
        "cs_dirge_hb",
        "cs_dirge_ex");


    // Dirge aura candy
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        eDirgeVFX,
        oPC,
        fDuration);

    // casting candy
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        eDirgeEnable,
        oPC,
        0.0);

    // red aura candy
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        eRedAura,
        oPC,
        fDuration);

    return;

}

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void DirgePulse( object oCaster, int nSpellSaveDC ){

    location lTarget    = GetLocation( oCaster );
    object oTarget      = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while ( GetIsObjectValid( oTarget ) ) {

        if ( !GetIsReactionTypeFriendly( oTarget ) ) {

            // Victim failed a Spell Resistance Check
            if( MyResistSpell( oCaster, oTarget, 0.0 ) < 1 ){

                // Victim failed a Fortitude Saving Throw
                if ( FortitudeSave( oTarget, nSpellSaveDC + 5, SAVING_THROW_TYPE_SPELL, oCaster ) < 1 ){

                    // twig the Dirge VFX so that stacking occurs
                    DelayCommand( 0.1, DoDirgePulseDamage( oTarget, oCaster ) );
                }
            }
        }

       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }
}


void DoDirgePulseDamage( object oVictim, object oCaster ){

    effect eHit      = EffectVisualEffect( VFX_IMP_REDUCE_ABILITY_SCORE );

    // candy VFX
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHit, oVictim );

    int nDrain1 = ABILITY_STRENGTH;
    int nDrain2 = ABILITY_DEXTERITY;

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( oCaster, "dirge" );

    if ( nTransmutation == 4 ){

        int nDrain1 = ABILITY_INTELLIGENCE;
        int nDrain2 = ABILITY_WISDOM;
    }

    effect eDrain1 = EffectAbilityDecrease( nDrain1, d4() );
    effect eDrain2 = EffectAbilityDecrease( nDrain2, d4() );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectLinkEffects( eDrain1, eDrain2 ), oVictim, 0.0 );

    return;
}
