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


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = OBJECT_SELF;
    object oNPC     = GetLocalObject( oPC, "ds_target" );
    object oArea    = GetArea( oPC );
    int nNode       = GetLocalInt( oPC, "ds_node" );
    string sTag     = GetTag( oNPC );
    int nGold;

    if  ( sTag == "bf_rat_racer" ){

        string sRat;


        switch ( nNode ) {

            case 1:     nGold = 10;  sRat = "bf_rat_1";     break;
            case 2:     nGold = 50;  sRat = "bf_rat_1";     break;
            case 3:     nGold = 100;  sRat = "bf_rat_1";    break;
            case 4:     nGold = 10;  sRat = "bf_rat_2";     break;
            case 5:     nGold = 50;  sRat = "bf_rat_2";     break;
            case 6:     nGold = 100;  sRat = "bf_rat_2";    break;
            default:    nGold = 0;  sRat = "";      break;
        }

        if ( nGold > 0 ){

            if ( nGold > GetGold( oPC ) ){

                SendMessageToPC( oPC, "You don't have enough cash." );
                return;
            }

            SetLocalInt( oArea, "bf_rats", 1 );
            SetLocalInt( oArea, "bf_rats_gp", nGold );
            SetLocalString( oArea, "bf_rat", sRat );
            SetLocalObject( oArea, "bf_racer", oPC );

            TakeGoldFromCreature( nGold, oPC, TRUE );

            object oRat1;
            object oRat2;
            object oStart1 = GetLocalObject( oArea, "bf_rat_s1" );
            object oStart2 = GetLocalObject( oArea, "bf_rat_s2" );
            object oEnd = GetLocalObject( oArea, "bf_rat_end" );

            if ( !GetIsObjectValid( oStart1 ) ){

                oStart1 = GetWaypointByTag( "bf_rat_1" );
                SetLocalObject( oArea, "bf_rat_s1", oStart1 );
            }

            if ( !GetIsObjectValid( oStart2 ) ){

                oStart2 = GetWaypointByTag( "bf_rat_2" );
                SetLocalObject( oArea, "bf_rat_s2", oStart2 );
            }

            if ( !GetIsObjectValid( oEnd ) ){

                oEnd = GetWaypointByTag( "bf_rat_end" );
                SetLocalObject( oArea, "bf_rat_end", oEnd );
            }

            if ( d2() == 1 ){

                oRat1 = CreateObject( OBJECT_TYPE_CREATURE, "bf_rat_1", GetLocation( oStart1 ) );
                oRat2 = CreateObject( OBJECT_TYPE_CREATURE, "bf_rat_2", GetLocation( oStart2 ) );
            }
            else{

                oRat1 = CreateObject( OBJECT_TYPE_CREATURE, "bf_rat_1", GetLocation( oStart2) );
                oRat2 = CreateObject( OBJECT_TYPE_CREATURE, "bf_rat_2", GetLocation( oStart1 ) );
            }

            SetLocalObject( oArea, "bf_rat_2", oPC );
            SetLocalObject( oArea, "bf_rat_1", oPC );

            DelayCommand( 3.0, AssignCommand( oRat1, ActionForceMoveToObject( oEnd, TRUE ) ) );
            DelayCommand( 3.0, AssignCommand( oRat2, ActionForceMoveToObject( oEnd, TRUE ) ) );

        }
    }
    else if ( sTag == "bf_roulette" ){

        int nSpin = d100();
        int nGold;
        float fMod;

        if ( nNode >= 10 && nNode <= 15 ){

            nGold = 10;
        }
        else if ( nNode >= 20 && nNode <= 25 ){

            nGold = 50;
        }
        else if ( nNode >= 30 && nNode <= 35 ){

            nGold = 100;
        }

        if ( ( nNode == 10 || nNode == 20 || nNode == 30 ) && nSpin >= 1 && nSpin <= 50 ){

            fMod = 1.5;
        }
        else if ( ( nNode == 11 || nNode == 21 || nNode == 31 ) && nSpin >= 51 && nSpin <= 100 ){

            fMod = 1.5;
        }
        else if ( ( nNode == 12 || nNode == 22 || nNode == 32 ) && ( nSpin % 2 ) != 0 ){

            fMod = 1.5;
        }
        else if ( ( nNode == 13 || nNode == 23 || nNode == 33 ) && ( nSpin % 2 ) == 0 ){

            fMod = 1.5;
        }
        else if ( ( nNode == 14 || nNode == 24 || nNode == 34 ) && ( nSpin == 1 || nSpin == 100 ) ){

            fMod = 5.0;
        }
        else if ( ( nNode == 15 || nNode == 25 || nNode == 35 ) && nSpin == 13 ){

            fMod = 13.0;
        }

        if ( nGold > GetGold( oPC ) ){

            SendMessageToPC( oPC, "You don't have enough cash." );
            return;
        }

        TakeGoldFromCreature( nGold, oPC, TRUE );

        AssignCommand( oNPC, SpeakString( "... and we have a ... "+IntToString( nSpin )+"!" ) );

        if ( fMod > 0.0 ){

            nGold = FloatToInt( nGold * fMod );

            DelayCommand( 4.0, AssignCommand( oNPC, SpeakString( "You have won "+IntToString( nGold )+" gold!" ) ) );

            DelayCommand( 4.0, GiveGoldToCreature( oPC, nGold ) );
        }
        else{

            DelayCommand( 4.0, AssignCommand( oNPC, SpeakString( "Alas, that's how the wheel turns!" ) ) );
        }
    }
    else if ( sTag == "bf_fatarse" ){

        int nGold = GetGold( oPC );

        if ( nNode == 1 ){

            if ( nGold >= 500 ){

                // Give the speaker the items
                CreateItemOnObject( "ds_furniture_002" );

                // Remove some gold from the player
                TakeGoldFromCreature( 500, oPC, TRUE );
            }
            else{

                SendMessageToPC( oPC, "You don't have enough cash." );
            }
        }
        else if ( nNode == 2 ){

            if ( nGold >= 5 ){

                SetLocalInt( oPC, "isling", 1 );

                // Give the speaker the items
                CreateItemOnObject( "nw_wbwsl001" );

                // Remove some gold from the player
                TakeGoldFromCreature( 5, oPC, TRUE );
            }
            else{

                SendMessageToPC( oPC, "You don't have enough cash." );
            }
        }
        else if ( nNode == 3 ){

            if ( nGold >= 5 ){

                // Give the speaker the items
                CreateItemOnObject( "nw_wammbu007" );

                // Remove some gold from the player
                TakeGoldFromCreature( 5, oPC, TRUE );
            }
            else{

                SendMessageToPC( oPC, "You don't have enough cash." );
            }
        }
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

