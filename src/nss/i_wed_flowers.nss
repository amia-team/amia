// Nekhkbet's Vase Wand :: Creates a permanent vase with flowers at the designated location.

// Includes
#include "x2_inc_switches"

void main(){

    // Variables
    int nEvent          = GetUserDefinedItemEventNumber( );
    int nResult         = X2_EXECUTE_SCRIPT_END;

    // Which event did the Item trigger ?
    switch( nEvent ){

        // Use: Unique Power
        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC              = GetItemActivator( );
            location lVaseLoc       = GetItemActivatedTargetLocation( );

            // Play a twinkling sound.
            AssignCommand( oPC, PlaySound( "sce_neutral" ) );

            // Create a pixie-dust effect at the targetted location.
            ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_PIXIEDUST ), lVaseLoc, 4.0 );

            // Create a vase (Toolset Blueprint Resref: "x0_vaseflower" at the targetted location.
            CreateObject( OBJECT_TYPE_PLACEABLE, "x0_vaseflower", lVaseLoc );

            break;
        }

        // Bug out on all other events
        default:{

            break;

        }

    }

    SetExecutedScriptReturnValue( nResult );

}
