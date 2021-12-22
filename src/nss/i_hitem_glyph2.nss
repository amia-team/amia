/*  Item : Harper Scouts :: Glyph : Warning

    --------
    Verbatim
    --------
    This script sets a Warning Glyph on a successful Set Trap skill check.

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
            if( !GetIsSkillSuccessful( oPC, SKILL_SET_TRAP, 30 ) ){
                SendMessageToPC( oPC, "- You failed a DC 30 Set Trap skill check, Trap not set! -" );
                break;
            }

            // Candy.
            ApplyEffectAtLocation(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect( VFX_IMP_MAGICAL_VISION ),
                lOrigin );

            // Set Trap.
            AssignCommand(
                oPC,
                ApplyEffectAtLocation(
                    DURATION_TYPE_TEMPORARY,
                    EffectAreaOfEffect( AOE_PER_CUSTOM_AOE, "cs_glyph_warn1" ),
                    lOrigin,
                    NewHoursToSeconds( 24 ) ) );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
