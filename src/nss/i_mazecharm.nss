/*  Charm Bracelet

    --------
    Verbatim
    --------
    This script will randomly polymorph the user.

    ---------
    Changelog
    ---------
    Date    Name                Reason
    ----------------------------------------------------------------------------
    013122  Jes        Initial & bug tested.
    ----------------------------------------------------------------------------

*/

// Includes
#include "x2_inc_switches"
#include "inc_poly_consts"

void main( ){

    // Variables
    int nEvent              = GetUserDefinedItemEventNumber( );
    int nResult             = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            int nPoly           = POLYMORPH_TYPE_CHAIR;
            int speed           = GetMovementRate(oPC);
            float fSize         = GetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE);

            switch( d8(1) ){

                case 1: nPoly = POLYMORPH_TYPE_TABLE;
                break;
                case 2: nPoly = POLYMORPH_TYPE_CANDELABRA;
                break;
                case 3: nPoly = POLYMORPH_TYPE_CHEST;
                break;
                case 4: nPoly = POLYMORPH_TYPE_BOAT;
                        fSize = 0.2;
                        break;
                case 5: nPoly = POLYMORPH_TYPE_WAGON;
                        break;
                case 6: nPoly = POLYMORPH_TYPE_ICERIDER;
                        fSize = 0.3;
                        break;
                case 7: nPoly = POLYMORPH_TYPE_FLAME;
                        break;

                default:
                break;

            }

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph( nPoly ), oPC, 300.0f);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease( speed ), oPC, 300.0f);
            SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fSize);


            break;

        }

        default:    break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
