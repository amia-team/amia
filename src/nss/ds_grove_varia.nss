//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
string MakeMonth( int month );
string MakeHour( int hour );
string MakeMinute( int minute );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetLastUsedBy();
    string sPLCname = GetName( OBJECT_SELF );


    if ( sPLCname == "Telescope" ){

        if ( GetIsDay() ){

            FloatingTextStringOnCreature( "The telescope is useless during the day.", oPC, TRUE );
        }
        else{

            FloatingTextStringOnCreature( "You see a myriad of stars.", oPC, TRUE );
        }
    }
    else if ( sPLCname == "Sundial" ){

        int    iHour   = GetTimeHour();
        int    iMinute = GetTimeMinute();
        int    iMonth  = GetCalendarMonth();

        if ( GetIsDay() ) {

            string result = "The various instruments on the dial tell you that it is the month of " + MakeMonth(iMonth) + ", at " + MakeHour(iHour) + ":" + MakeMinute(iMinute) + ".";
            ActionSpeakString( result );
        }
        else {

            ActionSpeakString( "It is impossible to use the sundial at night." );
        }
    }

}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

string MakeMonth( int month ){

    switch ( month ) {

        case 1: return "Llianth, The Poet's Moon";
        case 2: return "Carmoil, The Waking Moon";
        case 3: return "Haemgild, The Planting Moon";
        case 4: return "Gidhet, The Flower Moon";
        case 5: return "Duharkat, The Cattle Moon";
        case 6: return "Rodlima, The Bird Moon";
        case 7: return "Bemgusith, The Battle Moon";
        case 8: return "Culendom, The Harvest Moon";
        case 9: return "Alverci, The Artist Moon";
        case 10: return "Shar'tanog: The Dying Moon";
        case 11: return "Oveanh: The Sleeping Moon";
        case 12: return "Hunlidh: The Dreaming Moon";
    }

    return "Unknown month.";
}

string MakeHour( int hour ){

    string v = IntToString( hour );

    if ( hour < 10 )
        return "0" + v;
    else
        return v;
}

string MakeMinute( int minute ){

    string v = IntToString( minute );

    if ( minute < 10 )
        return "0" + v;
    else
        return v;
}
