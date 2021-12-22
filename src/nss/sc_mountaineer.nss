//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  sc_mountaineer
//group:   travel
//used as: conversation script
//date:    oct 29 2007
//author:  disco



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetPCSpeaker();
    string sNPCtag  = GetTag( OBJECT_SELF );

    if ( sNPCtag == "travel_amiaforest" ){

        SetLocalInt( oPC, "ds_check_1", 1 );
        SetLocalInt( oPC, "ds_check_2", 0 );
    }
    else if( sNPCtag == "travel_windingroad" ){

        SetLocalInt( oPC, "ds_check_1", 0 );
        SetLocalInt( oPC, "ds_check_2", 1 );
    }


}
