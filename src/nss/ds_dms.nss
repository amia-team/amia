//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_dms
//group:   DMS
//used as: action script
//date:    20080930
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_dms"


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    location lTarget = GetLocalLocation( oPC, "ds_target" );
    string sQuery;
    string sPC       = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sCustom;
    int nCustom      = 4250;
    int i;
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nSection     = GetLocalInt( oPC, "ds_section" );

    /*
    if ( !GetIsObjectValid( oTarget ) ){

        oTarget = oPC;
        lTarget = GetLocalLocation( oPC, "ds_target" );
    }
    else{

        lTarget = GetLocation( oTarget );
    }
    */

    for ( i=1; i<20; ++i ){

        SetCustomToken( (nCustom+i), "" );
    }

    if ( nNode == 1 || nNode == 11 ){

        sQuery = "SELECT (4250+slot), GROUP_CONCAT( title ) FROM dm_settings WHERE account='"+sPC+"' AND TYPE=1 GROUP BY slot";
    }
    else if ( nNode == 2 ){

        sQuery = "SELECT (4250+slot), LEFT( title, 40 ) FROM dm_settings WHERE account='"+sPC+"' AND TYPE="+IntToString( nNode );
    }
    else if ( nNode == 3 ){

        sQuery = "SELECT (4250+slot), LEFT( title, 40 ) FROM dm_settings WHERE account='"+sPC+"' AND TYPE="+IntToString( nNode )+" AND message != ''";
    }
    else if ( nNode == 4 ){

        sQuery = "SELECT (4250+slot), LEFT( title, 40 ) FROM dm_settings WHERE account='"+sPC+"' AND TYPE="+IntToString( nNode )+" AND reference > -1";
    }
    else if ( nNode == 5 || nNode == 15 ){

        sQuery = "SELECT (4250+slot), LEFT( title, 40 ) FROM dm_settings WHERE account='"+sPC+"' AND TYPE=5 AND reference > -1";
    }
    else if ( nNode == 6 ){

        sQuery = "SELECT (4250+slot), LEFT( title, 40 ) FROM dm_settings WHERE account='"+sPC+"' AND TYPE="+IntToString( nNode )+" AND reference > -1";
    }
    else if ( nNode == 7 ){

        sQuery = "SELECT (4250+slot), LEFT( message, 40 ) FROM dm_settings WHERE account='"+sPC+"' AND TYPE=7 AND message != ''";
    }
    else if ( nNode == 8 ){

        sQuery = "SELECT (4260+slot), title, reference FROM dm_settings WHERE account='"+sPC+"' AND TYPE=8 AND reference > -1";
    }
    else if ( nNode == 10 ){

        sQuery = "SELECT (4250+slot), title FROM dm_settings WHERE account='"+sPC+"' AND TYPE=10 AND message != ''";
    }

    if ( sQuery != "" ){

        SetLocalInt( oPC, "ds_section", nNode );

        object oCache = GetCache( "ds_bindpoint_storage" );

        SQLExecDirect( sQuery );

        while ( SQLFetch() == SQL_SUCCESS ){

            if ( nNode == 8 && !GetIsObjectValid( GetLocalObject( oCache, "b_"+SQLGetData(3) ) ) ){

                SetCustomToken( StringToInt( SQLGetData(1) ), "<cþ  >"+SQLDecodeSpecialChars( SQLGetData(2) )+"</c>" );
            }
            else{

                SetCustomToken( StringToInt( SQLGetData(1) ), "<cþþ >"+SQLDecodeSpecialChars( SQLGetData(2) )+"</c>" );
            }
        }

        return;
    }

    if ( nNode > 20 && nNode < 41 && nSection > 0 ){

        SetLocalInt( oPC, "ds_dms_node", nNode );
        SetLocalInt( oPC, "ds_dms_section", nSection );

        if ( nSection == 1 ){

            SpawnCritters( oPC, lTarget, IntToString( nNode-30 ) );
        }
        else if ( nSection == 2 ){

            SpawnItems( oPC, oTarget, lTarget, IntToString( nNode-30 ) );
        }
        else if ( nSection == 3 ){

            CastSpells( oPC, oTarget, IntToString( nNode-30 ) );
        }
        else if ( nSection == 4 ){

            ApplyAppearance( oPC, oTarget, IntToString( nNode-30 ) );
        }
        else if ( nSection == 5 ){

            ApplyVFX( oPC, oTarget, lTarget, IntToString( nNode-30 ) );
        }
        else if ( nSection == 6 ){

            CreateSound( oPC, lTarget, IntToString( nNode-30 ) );
        }
        else if ( nSection == 7 ){

            SpeakText( oPC, oTarget, IntToString( nNode-30 ) );
        }
        else if ( nSection == 8 ){

            PortPC( oPC, oTarget, IntToString( nNode-20 ) );
        }
        else if ( nSection == 10 ){

            if ( nNode == 30 ){

                SetArea( oPC, "", 1 );
            }
            else{

                SetArea( oPC, IntToString( nNode-30 ) );
            }
        }
        else if ( nSection == 11 ){

            SpawnCritters( oPC, lTarget, IntToString( nNode-30 ), 0 );
        }
        else if ( nSection == 15 ){

            ApplyVFX( oPC, oTarget, lTarget, IntToString( nNode-30 ), 1 );
        }
    }
}
