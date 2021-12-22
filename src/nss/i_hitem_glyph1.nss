/*  Item : Harper Scouts :: Glyph : Lightning

    --------
    Verbatim
    --------
    This script sets a Lightning Glyph on a successful Set Trap skill check.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080406  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "amia_include"

void KillInvis( object oPC ){

    effect eEff = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEff ) ){
        nType=GetEffectType( eEff );

        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY )
            RemoveEffect( oPC, eEff );

        eEff = GetNextEffect( oPC );
    }
}

void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables.
            object oPC          = GetItemActivator( );
            location lOrigin    = GetItemActivatedTargetLocation( );

            KillInvis( oPC );

            // Roll Set Trap skill check.
            if( !GetIsSkillSuccessful( oPC, SKILL_SET_TRAP, 40 ) ){
                SendMessageToPC( oPC, "- You failed a DC 40 Set Trap skill check, Trap not set! -" );
                break;
            }

            // Candy.
            ApplyEffectAtLocation(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect( VFX_IMP_LIGHTNING_S ),
                lOrigin );

            // Set Trap.
            AssignCommand(
                oPC,
                ApplyEffectAtLocation(
                    DURATION_TYPE_TEMPORARY,
                    EffectAreaOfEffect( AOE_PER_CUSTOM_AOE, "cs_glyph_light1" ),
                    lOrigin,
                    NewHoursToSeconds( 3 ) ) );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
