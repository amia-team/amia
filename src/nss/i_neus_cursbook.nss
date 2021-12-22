// Book of Infinite Knowledge, curses the reader with a Feeblemind spell

/* Includes */
#include "x2_inc_switches"
#include "amia_include"

void main( ){

    // Variables
    int nEvent              = GetUserDefinedItemEventNumber( );
    object oBook            = GetItemActivated( );
    object oReader          = GetItemActivator( );

    // Item->Activate
    if( nEvent == X2_ITEM_EVENT_ACTIVATE )

        // Curse the reader with a Feeblemind spell.
        ApplyEffectToObject(
                            DURATION_TYPE_TEMPORARY,
                            EffectLinkEffects(  EffectAbilityDecrease( ABILITY_INTELLIGENCE, d4( 2 ) ),
                                                EffectVisualEffect( VFX_IMP_REDUCE_ABILITY_SCORE ) ),
                            oReader,
                            NewHoursToSeconds( 24 ) );

    SetExecutedScriptReturnValue( );

    return;

}
