/*  Potion of Polymorph

    --------
    Verbatim
    --------
    This script will randomly polymorph the potion user.

    ---------
    Changelog
    ---------
    Date    Name                Reason
    ----------------------------------------------------------------------------
    050106  kfw/Neus/Discosux   Initial & bug tested.
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

            int nPoly       = POLYMORPH_TYPE_COW;

            switch( d8(1) ){

                case 1: nPoly = POLYMORPH_TYPE_PANTHER;         break;
                case 2: nPoly = POLYMORPH_TYPE_PENGUIN;         break;
                case 3: nPoly = POLYMORPH_TYPE_GARGOYLE;        break;
                case 4: nPoly = POLYMORPH_TYPE_CHICKEN;         break;
                case 5: nPoly = POLYMORPH_TYPE_BASILISK;        break;
                case 6: nPoly = POLYMORPH_TYPE_TROLL;           break;
                case 7: nPoly = POLYMORPH_TYPE_WYRMLING_RED;    break;

                default:                                        break;

            }

            ApplyEffectToObject(
                                DURATION_TYPE_TEMPORARY,
                                EffectPolymorph( nPoly ),
                                oPC,
                                200.0f);

            break;

        }

        default:    break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
