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
int poison_ingredient( int nPoison, object oPC, int nRemove );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    // Variables
    object oPC      = GetPCSpeaker();
    int i           = 0;

    for ( i=1; i<7; ++i ){

        poison_ingredient( i, oPC, 0 );

    }

    SetLocalString( oPC, "ds_action", "ds_poi_actions" );

}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int poison_ingredient( int nPoison, object oPC, int nRemove ){

    string sIngredientTag = "poi_ing_00" + IntToString( nPoison );
    object oIngredient    = GetItemPossessedBy( oPC, sIngredientTag ) ;


    if ( oIngredient != OBJECT_INVALID ){

        if (nRemove ){

            DestroyObject( oIngredient );
            SetLocalInt( oPC, "ds_check_" + IntToString( nPoison ), 0 );
            return 1;

        }
        else{

            SetLocalInt( oPC, "ds_check_" + IntToString( nPoison ), 1 );
            return 1;

        }

    }
    else {

        SetLocalInt( oPC, "ds_check_" + IntToString( nPoison ), 0 );
        return 0;

    }

}

