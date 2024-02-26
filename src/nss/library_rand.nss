//------------------------------------------------------------------------------
// header
//------------------------------------------------------------------------------
//script: library_rand
//used as: on use
//date: 02252024
//author: jes


//------------------------------------------------------------------------------
// includes
//------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "amia_include"


//------------------------------------------------------------------------------
// main
//------------------------------------------------------------------------------


void main(){

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

    int nBlockTime      = GetLocalInt( OBJECT_SELF, "BlockTime" );
    int nBooks          = GetLocalInt( OBJECT_SELF, "NumberOfBooks" );
    object oPLC;
    object oPC          = GetLastUsedBy();
    string sTarget      = GetLocalString( OBJECT_SELF, "target" );
    string sSpawnpoint  = GetLocalString( OBJECT_SELF, "spawnpoint" );
    string sResref;
    string bksTag       = GetTag( OBJECT_SELF );

//------------------------------------------------------------------------------

        if ( GetIsBlocked( ) > 0 ){
            SendMessageToPC( oPC, "You find nothing new.");
            return;
        }
         SetBlockTime( OBJECT_SELF, 0, nBlockTime );
         clean_vars( oPC, 4 );
         int bk_index = GetLocalInt ( OBJECT_SELF, "Book_" + IntToString( Random ( nBooks ) +1 ) );

            switch ( bk_index ) {

                case 1: sResref = "book_arc_001"; break;
                case 2: sResref = "book_arc_002"; break;
                case 3: sResref = "book_soc_006"; break;
                case 4: sResref = "book_arts_001"; break;
                case 5: sResref = "book_relg_001"; break;
                case 6: sResref = "book_nat_001"; break;
                case 7: sResref = "book_milt_001"; break;
                case 8: sResref = "book_tale_001"; break;
                case 9: sResref = "book_geog_001"; break;
                case 10: sResref = "book_arts_002"; break;
                case 11: sResref = "book_geog_002"; break;
                case 12: sResref = "book_hist_001"; break;
                case 13: sResref = "book_arts_003"; break;
                case 14: sResref = "book_geog_003"; break;
                case 15: sResref = "book_hist_002"; break;
                case 16: sResref = "book_arc_003"; break;
                case 17: sResref = "book_arc_004"; break;
                case 18: sResref = "book__arc_005"; break;
                case 19: sResref = "book__hist_003"; break;
                case 20: sResref = "book_soc_001"; break;
                case 21: sResref = "book_relg_002"; break;
                case 22: sResref = "book_arc_006"; break;
                case 23: sResref = "book__arc_007"; break;
                case 24: sResref = "book__arc_008"; break;
                case 25: sResref = "book_tale_002"; break;
                case 26: sResref = "book_arc_009"; break;
                case 27: sResref = "book_nat_002"; break;
                case 28: sResref = "book_hist_004"; break;
                case 29: sResref = "book_bist_005"; break;
                case 30: sResref = "book_hist_006"; break;
                case 31: sResref = "book_soc_002"; break;
                case 32: sResref = "book_hist_007"; break;
                case 33: sResref = "book_arc_010"; break;
                case 34: sResref = "book_hist_008"; break;
                case 35: sResref = "book_relg_003"; break;
                case 36: sResref = "book_arc_011"; break;
                case 37: sResref = "book_arts_004"; break;
                case 38: sResref = "book_relg_004"; break;
                case 39: sResref = "book_hist_009"; break;
                case 40: sResref = "book_hist_010"; break;
                case 41: sResref = "book_arc_012"; break;
                case 42: sResref = "book_arc_013"; break;
                case 43: sResref = "book_relg_005"; break;
                case 44: sResref = "book_arc_014"; break;
                case 45: sResref = "book_arc_015"; break;
                case 46: sResref = "book_arc_016"; break;
                case 47: sResref = "book_nat_003"; break;
                case 48: sResref = "book_relg_006"; break;
                case 49: sResref = "book_relg_007"; break;
                case 50: sResref = "book_arts_005"; break;
                case 51: sResref = "book_nat_004"; break;
                case 52: sResref = "book_arc_017"; break;
                case 53: sResref = "book_soc_003"; break;
                case 54: sResref = "book_soc_004"; break;
                case 55: sResref = "book_arts_006"; break;
                case 56: sResref = "book_hist_011"; break;
                case 57: sResref = "book_hist_012"; break;
                case 58: sResref = "book_nat_005"; break;
                case 59: sResref = "book_relg_008"; break;
                case 60: sResref = "book_plan_001"; break;
                case 61: sResref = "book_relg_009"; break;
                case 62: sResref = "book_relg_010"; break;
                case 63: sResref = "book_relg_011"; break;
                case 64: sResref = "book_arts_007"; break;
                case 65: sResref = "book_acr_018"; break;
                case 66: sResref = "book_hist_013"; break;
                case 67: sResref = "book_soc_005"; break;
                case 68: sResref = "book_relg_012"; break;
                case 69: sResref = "book_milt_002"; break;
                case 70: sResref = "book_plan_002"; break;
                case 71: sResref = "book_geog_004"; break;
                case 72: sResref = "book_geog_005"; break;
                case 73: sResref = "book_arc_019"; break;
                case 74: sResref = "book_arc_020"; break;
                case 75: sResref = "book_arc_021"; break;
                case 76: sResref = "book_hist_014"; break;
                case 77: sResref = "book_relg_013"; break;
                case 78: sResref = "book_arc_022"; break;
                case 79: sResref = "book_relg_014"; break;
                case 80: sResref = "book_hist_015"; break;
                case 81: sResref = "book_arc_023"; break;
                case 82: sResref = "book_arts_008"; break;
                case 83: sResref = "book_relg_015"; break;
                case 84: sResref = "book_hist_016"; break;
                //case 85: sResref = "book_nat_007"; break;
                case 86: sResref = "book_arc_024"; break;
                case 87: sResref = "book_arc_025"; break;
                case 88: sResref = "book_arc_026"; break;
                case 89: sResref = "book_geog_006"; break;
                case 90: sResref = "book_hist_017"; break;
                case 91: sResref = "book_geog_007"; break;
                case 92: sResref = "book_geog_008"; break;
                //case 93: sResref = "book_arts_008"; break;
                //case 94: sResref = "book_hist_"; break;
                case 95: sResref = "book_hist_018"; break;
                case 96: sResref = "book_hist_019"; break;
                case 97: sResref = "book_hist_020"; break;
                case 98: sResref = "book_hist_021"; break;
                case 99: sResref = "book_hist_022"; break;
                case 100: sResref = "book_plan_003"; break;
                case 101: sResref = "book_relg_017"; break;
                case 102: sResref = "book_hist_026"; break;
                //case 103: sResref = "book_hist_"; break;
                case 104: sResref = "book_hist_023"; break;
                case 105: sResref = "book_geog_026"; break;
                case 106: sResref = "book_relg_018"; break;
                case 107: sResref = "book_hist_024"; break;
                case 108: sResref = "book_hist_025"; break;
                case 109: sResref = "book_relg_019"; break;
                case 110: sResref = "book_relg_020"; break;
                case 111: sResref = "book_re;g_021"; break;
            }
            SendMessageToPC( oPC, "You locate an interesting looking book." );
            oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResref, GetLocation( GetWaypointByTag( sSpawnpoint ) ), FALSE, sTarget );
            DestroyObject( oPLC, nBlockTime - 1.0 );
}
