/*  i_ds_customitem3

--------
Verbatim
--------
Arch Druid staves

---------
Changelog
---------

Date    Name        Reason
------------------------------------------------------------------
102206  Disco       Start of header
111106  Disco       Added DM channel tracer
------------------------------------------------------------------

*/
/* Includes */
#include "x2_inc_switches"


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------

void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;
    effect eVis;
    object oPC;
    switch( nEvent ){

        case X2_ITEM_EVENT_EQUIP:

            // Variables.
            oPC       = GetPCItemLastEquippedBy();        // The player who equipped the item

            // Create the visual portion of the effect
            eVis      = EffectVisualEffect( VFX_FNF_NATURES_BALANCE  );
            // Apply the visual portion of the effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

        break;

        default:
            nResult = X2_EXECUTE_SCRIPT_CONTINUE;
        break;


    }

    SetExecutedScriptReturnValue( nResult );

    return;

}

