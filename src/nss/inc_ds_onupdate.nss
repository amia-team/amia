//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_onupdate
//group:   core, used to update db on module update
//used as: lib
//date:    apr 22 2011
//author:  disco


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------

//updates database when a module update is detected
void UpdateDatabase( object oModule );

//helper function, don't use by itself
void upd_ProcessAreas( int nModule );

//helper function, don't use by itself
void upd_GetSpawnPoints( object oArea, int nModule, object oAreaMarker );

//helper function, don't use by itself
void upd_GetDoors( object oArea, int nModule, object oAreaMarker );

//helper function, don't use by itself
void upd_GetTriggers( object oArea, int nModule, object oAreaMarker );

//helper function, don't use by itself
void upd_GetNPCs( object oArea, int nModule, object oAreaMarker );

//helper function, don't use by itself
void upd_GetPLCs( object oArea, int nModule, object oAreaMarker );



//todo




//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------

void UpdateDatabase( object oModule ){

    //check server log for last version number
    //NB: this function needs to be called before the version number is updated!

    int nModule         = GetLocalInt( oModule, "Module" );
    string sPeriod      = GetLocalString( oModule, "ds_period" );
    string sVersion     = GetLocalString( oModule, "CurrentVersion" );
    string sCore        = GetLocalString( oModule, "CurrentCore" );
    string sQuery       = "SELECT value_1 FROM server_log WHERE module="+IntToString( nModule )+" ORDER BY id DESC limit 1";

    SQLExecDirect( sQuery );

    if ( SQLFetch( ) == SQL_SUCCESS ){

        if ( SQLGetData( 1 ) != sVersion ){

            //different version, probably updated module
            upd_ProcessAreas( nModule );
        }
    }

    //update module version etc
    sQuery       = "INSERT INTO server_log VALUES ( NULL, '"+IntToString( nModule )+"', 'Server Start', '"+sPeriod+"', '"+sVersion+"', '"+sCore+"', 'n.a', NOW() )";

    SQLExecDirect( sQuery );
}


void upd_ProcessAreas( int nModule ){

    // item activate variables
    object oAreaMarker = GetObjectByTag( "is_area" );
    object oArea       = GetArea( oAreaMarker );
    float fDelay;
    int i;

    SQLExecDirect( "DELETE FROM area_spawnpoint WHERE module="+IntToString( nModule ) );
    SQLExecDirect( "DELETE FROM area_door WHERE module="+IntToString( nModule ) );
    SQLExecDirect( "DELETE FROM area_transition WHERE module="+IntToString( nModule ) );
    SQLExecDirect( "DELETE FROM area_trap WHERE module="+IntToString( nModule ) );
    SQLExecDirect( "DELETE FROM area_plc WHERE module="+IntToString( nModule ) );
    SQLExecDirect( "DELETE FROM area_npc WHERE module="+IntToString( nModule ) );
    SQLExecDirect( "DELETE FROM area_spawnsystem WHERE module="+IntToString( nModule ) );
    SQLExecDirect( "DELETE FROM area_no_isarea WHERE module="+IntToString( nModule ) );

    while ( GetIsObjectValid( oAreaMarker ) ){

        if ( GetObjectType( oAreaMarker ) == OBJECT_TYPE_WAYPOINT ){

            oArea = GetArea( oAreaMarker );

            fDelay += 0.025;

            DelayCommand( fDelay, upd_GetSpawnPoints( oArea, nModule, oAreaMarker ) );

            fDelay += 0.025;

            DelayCommand( fDelay, upd_GetDoors( oArea, nModule, oAreaMarker ) );

            fDelay += 0.025;

            DelayCommand( fDelay, upd_GetTriggers( oArea, nModule, oAreaMarker ) );

            fDelay += 0.025;

            DelayCommand( fDelay, upd_GetNPCs( oArea, nModule, oAreaMarker ) );

            fDelay += 0.025;

            DelayCommand( fDelay, upd_GetPLCs( oArea, nModule, oAreaMarker ) );
        }

        ++i;

        oAreaMarker = GetObjectByTag( "is_area", i );
    }
}

void upd_GetSpawnPoints( object oArea, int nModule, object oAreaMarker ){

    object oSpawnpoint = GetNearestObjectByTag( "ds_spwn", oAreaMarker );
    int i = 1;
    string sResref = GetResRef( oArea );
    string sSQL;
    string sX;
    string sY;
    vector vPos;

    while ( GetIsObjectValid( oSpawnpoint ) ){

        if ( GetObjectType( oSpawnpoint ) == OBJECT_TYPE_WAYPOINT ){

            vPos = GetPosition( oSpawnpoint );
            sX = FloatToString( vPos.x, 3, 2 );
            sY = FloatToString( vPos.y, 3, 2 );

            if ( sSQL == "" ){

                sSQL += "INSERT INTO area_spawnpoint VALUES ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"' )";
            }
            else{

                sSQL += ", ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"' )";
            }
        }

        ++i;

        oSpawnpoint = GetNearestObjectByTag( "ds_spwn", oAreaMarker, i );
    }

    if ( sSQL != "" ){

        SQLExecDirect( sSQL );
    }
}

void upd_GetDoors( object oArea, int nModule, object oAreaMarker ){

    object oDoor = GetNearestObject( OBJECT_TYPE_DOOR, oAreaMarker );
    int i = 1;
    string sResref = GetResRef( oArea );
    string sSQL;
    string sX;
    string sY;
    vector vPos;
    string sTarget;

    while ( GetIsObjectValid( oDoor ) ){

        sTarget = GetResRef( GetArea( GetTransitionTarget( oDoor ) ) );

        if ( sTarget == "" ){

            sTarget = GetResRef( oDoor );

            if ( sTarget != "ud_corridor" ){

                sTarget = "";
            }
            else{

                sTarget = "Underdark Corridor";
            }
        }

        if ( sTarget != "" ){

            vPos = GetPosition( oDoor );
            sX = FloatToString( vPos.x, 3, 2 );
            sY = FloatToString( vPos.y, 3, 2 );

            if ( sSQL == "" ){

                sSQL += "INSERT INTO area_door VALUES ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+sTarget+"' )";
            }
            else{

                sSQL += ", ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+sTarget+"' )";
            }
        }

        ++i;

        oDoor = GetNearestObject( OBJECT_TYPE_DOOR, oAreaMarker, i );
    }

    if ( sSQL != "" ){

        SQLExecDirect( sSQL );
    }
}

void upd_GetTriggers( object oArea, int nModule, object oAreaMarker ){

    object oTrigger = GetNearestObject( OBJECT_TYPE_TRIGGER, oAreaMarker );
    int i = 1;
    string sResref = GetResRef( oArea );
    string sSQL;
    string sSQL2;
    string sSQL3;
    string sX;
    string sY;
    vector vPos;
    string sTarget;
    int nHasSpawnTriggers = 0;


    while ( GetIsObjectValid( oTrigger ) ){

        sTarget = GetResRef( GetArea( GetTransitionTarget( oTrigger ) ) );

        vPos = GetPosition( oTrigger );
        sX = FloatToString( vPos.x, 3, 2 );
        sY = FloatToString( vPos.y, 3, 2 );

        if ( sTarget != "" ){

            if ( sSQL == "" ){

                sSQL += "INSERT INTO area_transition VALUES ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+sTarget+"' )";
            }
            else{

                sSQL += ", ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+sTarget+"' )";
            }
        }
        else if ( GetIsTrapped( oTrigger ) ){

            if ( sSQL2 == "" ){

                sSQL2 += "INSERT INTO area_trap VALUES ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+IntToString( GetTrapBaseType( oTrigger ) )+"' )";
            }
            else{

                sSQL2 += ", ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+IntToString( GetTrapBaseType( oTrigger ) )+"' )";
            }
        }
        else if ( GetTag( oTrigger ) == "db_spawntrigger" ){

            ++nHasSpawnTriggers;
        }
        else if ( GetTag( oTrigger ) == "ds_trg_chat" ){

            //detects chat triggers
            sSQL3 = "INSERT INTO npc_messages VALUES ( NULL, 2, '"+sResref+"', "+IntToString( nModule )+", '', NOW() ) ON DUPLICATE KEY UPDATE detected=NOW()";

            SQLExecDirect( sSQL3 );
        }
        else if ( GetTag( oTrigger ) == "ds_trg_herald" ){

            //detects chat triggers
            sSQL3 = "INSERT INTO npc_messages VALUES ( NULL, 3, '"+sResref+"', "+IntToString( nModule )+", '', NOW() ) ON DUPLICATE KEY UPDATE detected=NOW()";

            SQLExecDirect( sSQL3 );
        }

        ++i;

        oTrigger = GetNearestObject( OBJECT_TYPE_TRIGGER, oAreaMarker, i );
    }

    if ( sSQL != "" ){

        SQLExecDirect( sSQL );
    }
    if ( sSQL2 != "" ){

        SQLExecDirect( sSQL2 );
    }

    SQLExecDirect( "INSERT INTO area_spawnsystem VALUES ( '"+sResref+"', "+IntToString( nModule )+", '"+IntToString( nHasSpawnTriggers )+"' )" );
}

void upd_GetNPCs( object oArea, int nModule, object oAreaMarker ){

    object oNPC = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oAreaMarker );
    int i = 1;
    string sResref = GetResRef( oArea );
    string sSQL;
    string sSQL2;
    string sX;
    string sY;
    vector vPos;
    string sName;
    string sWP;
    string sTarget;
    string sType;

    while ( GetIsObjectValid( oNPC ) ){

        if ( GetStandardFactionReputation( STANDARD_FACTION_HOSTILE, oNPC ) < 90 ){

            vPos = GetPosition( oNPC );
            sX = FloatToString( vPos.x, 3, 2 );
            sY = FloatToString( vPos.y, 3, 2 );

            sName = SQLEncodeSpecialChars( GetName( oNPC ) );

            sWP   = GetLocalString( oNPC, "ds_wp" );

            if ( sWP != "" ){

                sTarget = GetResRef( GetArea( GetWaypointByTag( sWP ) ) );
            }
            else{

                sWP   = GetLocalString( oNPC, "WP_destination" );

                if ( sWP != "" ){

                    sTarget = GetResRef( GetArea( GetWaypointByTag( sWP ) ) );
                }
                else{

                    sTarget = "";
                }
            }

            if ( GetLocalInt( oNPC, "st_1_index" ) > 0 ){

                sTarget = "Ferry Line";
            }

            if ( FindSubString( GetTag( oNPC ), "ds_j_" ) == 0 ){

                sType = "1";
            }
            else{

                sType = "0";
            }

            if ( sSQL == "" ){

                sSQL += "INSERT INTO area_npc VALUES ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+sName+"', "+sType+", '"+sTarget+"' )";
            }
            else{

                sSQL += ", ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+sName+"', "+sType+", '"+sTarget+"' )";
            }

            if ( GetTag( oNPC ) == "ds_trg_talk" ){

                //detects chat triggers
                sSQL2 = "INSERT INTO npc_messages VALUES ( NULL, 1, '"+sResref+"', "+IntToString( nModule )+", '', NOW() ) ON DUPLICATE KEY UPDATE detected=NOW()";

                SQLExecDirect( sSQL2 );
            }
        }

        ++i;

        oNPC = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oAreaMarker, i );
    }

    if ( sSQL != "" ){

        SQLExecDirect( sSQL );
    }
}

void upd_GetPLCs( object oArea, int nModule, object oAreaMarker ){

    object oPLC = GetNearestObject( OBJECT_TYPE_PLACEABLE, oAreaMarker );
    int i = 1;
    string sResref = GetResRef( oArea );
    string sSQL;
    string sX;
    string sY;
    vector vPos;
    string sTarget;
    string sTag;

    while ( GetIsObjectValid( oPLC ) ){

        sTarget = GetResRef( oPLC );
        sTag    = GetTag( oPLC );

        if ( sTarget == "ff_signpost" || sTarget == "ds_crystal_node" ){

            vPos = GetPosition( oPLC );
            sX = FloatToString( vPos.x, 3, 2 );
            sY = FloatToString( vPos.y, 3, 2 );

            if ( sSQL == "" ){

                sSQL += "INSERT INTO area_plc VALUES ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+sTarget+"', '' )";
            }
            else{

                sSQL += ", ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', '"+sTarget+"', '' )";
            }
        }
        else if ( FindSubString( sTag, "ds_j_" ) != -1 ){

            vPos = GetPosition( oPLC );
            sX = FloatToString( vPos.x, 3, 2 );
            sY = FloatToString( vPos.y, 3, 2 );

            if ( sSQL == "" ){

                sSQL += "INSERT INTO area_plc VALUES ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', 'ds_j', '"+SQLEncodeSpecialChars( GetName( oPLC ) )+"' )";
            }
            else{

                sSQL += ", ( '"+sResref+"', "+IntToString( nModule )+", '"+sX+"', '"+sY+"', 'ds_j', '"+SQLEncodeSpecialChars( GetName( oPLC ) )+"' )";
            }
        }

        ++i;

        oPLC = GetNearestObject( OBJECT_TYPE_PLACEABLE, oAreaMarker, i );
    }

    if ( sSQL != "" ){

        SQLExecDirect( sSQL );
    }
}


