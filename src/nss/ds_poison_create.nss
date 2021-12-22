/*  i_ds_customitem2

--------
Verbatim
--------


---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
06-14-06  Disco       Start of header
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
//#include ""

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){


}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


int ds_poison_primary_effect( int nPoison ){

    switch ( nPoison ) {
        case 0:     return 0;                       break;
        case 1:     return ABILITY_CONSTITUTION;    break;
        case 2:     return ABILITY_STRENGTH;        break;
        case 3:     return ABILITY_INTELLIGENCE;    break;
        case 4:     return ABILITY_CONSTITUTION;    break;
        case 5:     return ABILITY_STRENGTH;        break;
        case 6:     return ABILITY_CONSTITUTION;    break;
        default:    return 0;                       break;
    }
    return 0;

}

int ds_poison_secondary_effect( int nPoison ){

    switch ( nPoison ) {
        case 0:     return 0;                       break;
        case 1:     return ABILITY_STRENGTH;        break;
        case 2:     return ABILITY_STRENGTH;        break;
        case 3:     return ABILITY_CONSTITUTION;    break;
        case 4:     return ABILITY_CONSTITUTION;    break;
        case 5:     return ABILITY_STRENGTH;        break;
        case 6:     return ABILITY_CONSTITUTION;    break;
        default:    return 0;                       break;
    }
    return 0;

}


