/*  Dirge spell: onHeartBeat
        -   Fortitude Saving Throw
        -   Spell Resistance Check
        -   Every round do STR and DEX -2 penalty to enemy

    ---------
    Changelog
    ---------
    Date        Name        Reason
    ----------------------------------------------------------------------------
    20080216    Disco       Added Transmutation option
    ----------------------------------------------------------------------------
*/

// includes
#include "x2_i0_spells"

// prototype declarations
void DoDirgeDamage( object oVictim, object oCaster );

void main(){

    // vars
    object oPC          = GetAreaOfEffectCreator();
    int nCasterLevel    = GetCasterLevel(oPC);
    int nSpellSaveDC    = GetSpellSaveDC();

    // cycle through all enemies within Dirge Aura, resolve their status, determine SR, saving throw, apply penalty
    object oVictims=GetFirstInPersistentObject();

    while(oVictims!=OBJECT_INVALID){

        // resolve Victim status [not a creature, not an enemy -> do nothing]
        if( (GetObjectType(oVictims)!=OBJECT_TYPE_CREATURE) ||
            (GetIsEnemy(
                oVictims,
                oPC)==FALSE)                                ){

            oVictims=GetNextInPersistentObject();

            continue;

        }

        // Victim failed a Spell Resistance Check
        if(MyResistSpell(
            oPC,
            oVictims,
            0.0)<1){

            // Victim failed a Fortitude Saving Throw
            if(FortitudeSave(
                oVictims,
                nSpellSaveDC,
                SAVING_THROW_TYPE_SPELL,
                oPC)<1){

                // twig the Dirge VFX so that stacking occurs
                DelayCommand(
                    0.1,
                    DoDirgeDamage(oVictims, oPC ));

                // candy VFX
                ApplyEffectToObject(
                    DURATION_TYPE_INSTANT,
                    EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE),
                    oVictims,
                    0.0);

            }

        }

        oVictims=GetNextInPersistentObject();

    }

    return;

}

// prototype definitions
void DoDirgeDamage( object oVictim, object oCaster ){


    int nDrain1 = ABILITY_STRENGTH;
    int nDrain2 = ABILITY_DEXTERITY;

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( oCaster, "dirge" );

    SendMessageToPC( oCaster, "[Dirge HB: BoT option = "+IntToString( nTransmutation )+"]" );

    if ( nTransmutation == 2 ){

        nDrain1 = ABILITY_INTELLIGENCE;
        nDrain2 = ABILITY_WISDOM;
    }
    //--------------------------------------------------------------------------

    effect eDrain1 = EffectAbilityDecrease( nDrain1, 2 );
    effect eDrain2 = EffectAbilityDecrease( nDrain2, 2 );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectLinkEffects( eDrain1, eDrain2 ), oVictim, 0.0 );

    return;
}
