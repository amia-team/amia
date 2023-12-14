/*  Potion of Pixie Polymorph

    --------

    --------
    This script will randomly polymorph the potion user into one of the Pixie shapes.

    ---------
    Changelog
    ---------
    Date    Name                Reason
    ----------------------------------------------------------------------------
   06-12-2023   Frozen          Script created
    ----------------------------------------------------------------------------

*/

// Includes
#include "x2_inc_switches"

void main( ){

    // Variables
    int nEvent              = GetUserDefinedItemEventNumber( );
    int nResult             = X2_EXECUTE_SCRIPT_END;
    int nAppearance;
    int nSwitch;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC      = GetItemActivator( );

            int nPoly       = 6 ; //pixie

            switch( d3(1) ){
                case 1 : nSwitch = 1 ;    break;
                case 2 : nSwitch = 2 ;    break;
                case 3 : nSwitch = 3 ;    break;
                default:                                        break;
            }
                if (nSwitch == 1){
                    switch( d10(1) ){

                        case 1 : nAppearance = 55   ;    break; //   Fairy, green
                        case 2 : nAppearance = 971  ;    break; //   Fairy, Blue
                        case 3 : nAppearance = 972  ;    break; //   Fairy, Red
                        case 4 : nAppearance = 1528 ;    break; //  "Fairy, Butterfly Female, green"
                        case 5 : nAppearance = 1529 ;    break; //  "Fairy, Butterfly Male, green"
                        case 6 : nAppearance = 1530 ;    break; //  "Fairy, Dragonfly Female, green"
                        case 7 : nAppearance = 1531 ;    break; //  "Fairy, Dragonfly Male, green"
                        case 8 : nAppearance = 1532 ;    break; //  "Fairy, Butterfly Female, blue"
                        case 9 : nAppearance = 1533 ;    break; //  "Fairy, Butterfly Male, blue"
                        case 10: nAppearance = 1534 ;    break; //  "Fairy, Butterfly Female, brown 1"
                        default:                                        break;
                    }
                }
                else if (nSwitch == 2){
                    switch( d10(1) ){
                        case 1 : nAppearance = 1535 ;    break; //  "Fairy, Butterfly Male, brown 1"
                        case 2 : nAppearance = 1536 ;    break; //  "Fairy, Butterfly Female, red"
                        case 3 : nAppearance = 1537 ;    break; //  "Fairy, Butterfly Male, red"
                        case 4 : nAppearance = 1538 ;    break; //  "Fairy, Butterfly Female, monarch"
                        case 5 : nAppearance = 1539 ;    break; //  "Fairy, Butterfly Male, monarch"
                        case 6 : nAppearance = 1540 ;    break; //  "Fairy, Butterfly Female, pink"
                        case 7 : nAppearance = 1541 ;    break; //  "Fairy, Butterfly Male, pink"
                        case 8 : nAppearance = 1542 ;    break; //  "Fairy, Butterfly Female, dark blue"
                        case 9 : nAppearance = 1543 ;    break; //  "Fairy, Butterfly Male, dark blue"
                        case 10: nAppearance = 1544 ;    break; //  "Fairy, Butterfly Female, yellow"
                        default:                                        break;
                    }
                }
                else if (nSwitch == 3){
                    switch( d10(1) ){
                        case 1 : nAppearance = 1545 ;    break; //  "Fairy, Butterfly Male, yellow"
                        case 2 : nAppearance = 1546 ;    break; //  "Fairy, Butterfly Female, purple"
                        case 3 : nAppearance = 1547 ;    break; //  "Fairy, Butterfly Male, purple"
                        case 4 : nAppearance = 1548 ;    break; //  "Fairy, Butterfly Female, white"
                        case 5 : nAppearance = 1549 ;    break; //  "Fairy, Butterfly Male, white"
                        case 6 : nAppearance = 1550 ;    break; //  "Fairy, Butterfly Female, black"
                        case 7 : nAppearance = 1551 ;    break; //  "Fairy, Butterfly Male, black"
                        case 8 : nAppearance = 1552 ;    break; //  "Fairy, Butterfly Female, brown 2"
                        case 9 : nAppearance = 1553 ;    break; //  "Fairy, Butterfly Male, brown 2"
                        case 10: nAppearance = 374  ;    break; //   Faerie Dragon
                        default:                                        break;
                    }

            }

            AssignCommand( oPC, SpeakString( "<cwþþ>*</c><cÈ È>P</c><c ÈÈ>I</c><cËÐØ>X</c><cµ}H>I</c><c È >E</c><cPPÿ>F</c><c´$$>I</c><cÿÓ'>E</c><cÈ È>D</c><c ÈÈ>!</c><cwþþ>*</c>" ) );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT,EffectPolymorph( nPoly ),oPC);
            SetCreatureAppearanceType( oPC, nAppearance );

            break;

        }

        default:    break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
