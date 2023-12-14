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
    int nAppearance;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC      = GetItemActivator( );

            int nPoly       = 310 ; //1391 Unicorn_White_Mare

            switch( d6(1) ){

                case 1: nAppearance = 1362 ;    break; //Unicorn_White
                case 2: nAppearance = 1360 ;    break; //Unicorn_Celestial_Charger_White
                case 3: nAppearance = 1361 ;    break; //Unicorn_Celestial_Charger_White
                case 4: nAppearance = 1389 ;    break; //Unicorn_Celestial_Charger_White_Mare
                case 5: nAppearance = 1390 ;    break; //Unicorn_Celestial_Charger_White_Mare
                case 6: nAppearance = 1391 ;    break; //Unicorn_White_Mare

                default:                                        break;

            }

            AssignCommand( oPC, SpeakString( "<cwþþ>*Drinks a</c> <cÈ È>U</c><c ÈÈ>n</c><cËÐØ>i</c><cµ}H>c</c><c È >o</c><cPPÿ>r</c><c´$$>n</c> <cÿÓ'>P</c><cÈ È>o</c><c ÈÈ>t</c><cËÐØ>i</c><cµ}H>o</c><c È >n</c><cwþþ>*</c>" ) );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT,EffectPolymorph( nPoly ),oPC);
            SetCreatureAppearanceType( oPC, nAppearance );

            break;

        }

        default:    break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
