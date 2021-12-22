//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco

// 2008/07/05 disco               new blindness/underwater system
// 2008/07/05 disco               new racial trait system


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //for some reason I don't get anything with GetLastSpellCaster()
    //only the subject and the spell ID matter, so no bother
    object oPC = GetSpellTargetObject();
    int nSpell = GetSpellId();

    //first we clean up effects made by the same spell
    effect eLoop = GetFirstEffect( oPC );

    while ( GetIsEffectValid( eLoop ) ){

        if ( GetEffectSpellId( eLoop ) == nSpell ){

            SendMessageToPC( oPC, "[removing spell #"+IntToString( nSpell )+"]" );
            RemoveEffect( oPC, eLoop );
        }

        eLoop = GetNextEffect( oPC );
    }

    //now we apply the relevant spell effects

    if ( nSpell == SPELL_THE_FALL ){

        if ( GetLevelByClass( CLASS_TYPE_PALADIN, oPC ) > 0 ){

            //We are going to check the Paladin's CHA modifier
            int nCHA = GetAbilityModifier( ABILITY_CHARISMA, oPC );

            //We decrease the saving throws minus CHA Modifier
            effect eSaveDown = EffectSavingThrowDecrease( SAVING_THROW_ALL, nCHA );

            //(re-)apply the effect
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSaveDown, oPC );
        }
    }
    else if ( nSpell == SPELL_THE_RISE ){

        //first we clean up effects made by the same spell
        effect eLoop = GetFirstEffect( oPC );

        while ( GetIsEffectValid( eLoop ) ){

            if ( GetEffectSpellId( eLoop ) == SPELL_THE_FALL ){

                RemoveEffect( oPC, eLoop );
            }

            eLoop = GetNextEffect( oPC );
        }

        effect eVis = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MAJOR );

        //(re-)apply the effect
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oPC, 3.0 );
    }
    else if ( nSpell == DEATH_EFFECTS ){

        //applies the unconsciousness visual effect
        effect eVis = SupernaturalEffect( EffectVisualEffect( VFX_DUR_BARD_SONG ) );

        //(re-)apply the effect
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oPC );
    }
    else if ( nSpell == SHOP_EFFECTS ){

        //applies the unconsciousness visual effect
        effect eVis = SupernaturalEffect( EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR ) );

        //(re-)apply the effect
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oPC );
    }
    else if ( nSpell == ULTRAVISION_ON ){

        //applies the unconsciousness visual effect
        effect eUltravision = MagicalEffect( EffectUltravision( ) );

        //(re-)apply the effect
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eUltravision, oPC );
    }
}



