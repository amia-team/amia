/*  Potion of unicorn Polymorph

    --------

    --------
    This script will randomly polymorph the potion user into one of the unicorn shapes.

    ---------
    Changelog
    ---------
    Date    Name                Reason
    ----------------------------------------------------------------------------
   29-04-2023   Frozen          Script created
    ----------------------------------------------------------------------------

*/

// Includes
#include "x2_inc_switches"

void main( ){

    // Variables
    int nEvent              = GetUserDefinedItemEventNumber( );
    int nResult             = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC      = GetItemActivator( );
            object oItem    = GetItemActivated( );
            int nPoly       = GetLocalInt (oItem, "poly");
            int nAppearance = GetLocalInt (oItem, "skin");
            int nPortrait   = GetLocalInt (oItem, "potrait");


            ApplyEffectToObject( DURATION_TYPE_PERMANENT,EffectPolymorph( nPoly ),oPC);
            if (nAppearance >= 7){
                SetCreatureAppearanceType( oPC, nAppearance );
                SetPortraitId( oPC, nPortrait );
                }

            break;

        }

        default:    break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
