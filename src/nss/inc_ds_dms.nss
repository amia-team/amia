//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_dms
//group:   DMS
//used as: lib
//date:    20080930
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "inc_ds_porting"
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void StoreCritters( object oPC, string sSlot );

void StoreCritter( object oPC, object oCritter, string sSlot );

void SpawnCritters( object oPC, location lTarget, string sSlot, int nHostile=1 );

void SpawnCritter( object oPC, location lTarget, string sID, int nHostile=1  );

void StoreItems( object oPC, string sSlot );

void StoreItem( object oPC, object oItem, string sSlot );

void SpawnItems( object oPC, object oTarget, location lTarget, string sSlot );

void SpawnItem( object oPC, object oTarget, location lTarget, string sID );

void CastSpells( object oPC, object oTarget, string sSlot );

void ApplyAppearance( object oPC, object oTarget, string sSlot );

void ApplyVFX( object oPC, object oTarget, location lTarget, string sSlot, int nPermanent=0 );

void CreateSound( object oPC, location lTarget, string sSlot );

void SpeakText( object oPC, object oTarget, string sSlot );

void PortPC( object oPC, object oTarget, string sSlot );

void SetArea( object oPC, string sSlot, int nReset=0 );

void SetAreaLights( object oArea, string sPacked );

//utility function
//takes a tokenised string and returns the item on nPosition
//example: ExplodeString( "1234_5678_9_10", "_", 3 ) returns "9"
string ExplodeString( string sString, string sToken, int nPosition );


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void StoreCritters( object oPC, string sSlot ){

    object oObject = GetFirstObjectInArea();
    string sPC          = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sCritter     = SQLEncodeSpecialChars( GetName( oPC ) );
    string sQuery       = "";
    float fDelay;
    int nCount = 3;

    //------------------------------------------------------------------
    //clean old records
    //------------------------------------------------------------------
    sQuery       = "DELETE FROM dm_settings WHERE account = '"+sPC+"' AND type=1 AND slot="+sSlot;

    SQLExecDirect( sQuery );

    SendMessageToPC( oPC, "[Cleaning up slot "+sSlot+"]" );

    //------------------------------------------------------------------
    //find critters
    //------------------------------------------------------------------
    while ( GetIsObjectValid( oObject ) ){

        if ( GetObjectType( oObject ) == OBJECT_TYPE_CREATURE && !GetIsPC( oObject ) ){

            ++nCount;

            fDelay = nCount/3.0;

            DelayCommand( fDelay, StoreCritter( oPC, oObject, sSlot ) );
        }

        oObject = GetNextObjectInArea();
    }
}


void StoreCritter( object oPC, object oCritter, string sSlot ){

    string sPC          = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sCritter     = SQLEncodeSpecialChars( GetName( oCritter ) );
    string sQuery       = "";

    //------------------------------------------------------------------
    //store
    //------------------------------------------------------------------
    sQuery       = "INSERT INTO dm_settings VALUES ( NULL, '"+
                    sPC+"', 1, "+sSlot+", '"+sCritter+"', NULL, %s, NULL, NOW() )";
    //execute
    SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

    //sql hooks into BioWare campaign DB stuff
    StoreCampaignObject ( "NWNX", "-", oCritter );

    SendMessageToPC( oPC, "["+GetName( oCritter )+" stored in slot "+sSlot+"]" );

    DestroyObject( oCritter, 2.0 );
}


void SpawnCritters( object oPC, location lTarget, string sSlot, int nHostile=1  ){

    string sPC    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sQuery = "SELECT id FROM dm_settings WHERE account = '"+sPC+"' AND type=1 AND slot="+sSlot;
    float fDelay;
    int nCount;
    string sID;


    SendMessageToPC( oPC, "[Spawning critters from slot "+sSlot+"]" );

    //execute
    SQLExecDirect( sQuery );

    while ( SQLFetch() == SQL_SUCCESS ){

        ++nCount;

        fDelay = nCount/3.0;

        sID = SQLGetData(1);

        DelayCommand( fDelay, SpawnCritter( oPC, lTarget, sID, nHostile ) );
    }
}

void SpawnCritter( object oPC, location lTarget, string sID, int nHostile=1  ){

    string sQuery = "SELECT content FROM dm_settings WHERE id = " + sID + " LIMIT 1";

    //execute
    SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

    //sql hooks into BioWare campaign DB stuff
    object oCritter = RetrieveCampaignObject ("NWNX", "-", lTarget );

    if ( nHostile == 1 ){

        ChangeToStandardFaction( oCritter, STANDARD_FACTION_HOSTILE );
        //SetName( oCritter, "<cþ  >"+GetName( oCritter )+"</c>" );
    }
    else{

        ChangeToStandardFaction( oCritter, STANDARD_FACTION_COMMONER );
        //SetName( oCritter, "<c þ >"+GetName( oCritter )+"</c>" );
    }

    ExecuteScript( "ds_ai2_spawn", oCritter );
}

void StoreItems( object oPC, string sSlot ){

    object oObject      = GetFirstObjectInArea();
    string sPC          = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sCritter     = SQLEncodeSpecialChars( GetName( oPC ) );
    string sQuery       = "";
    float fDelay;
    int nCount = 3;

    //------------------------------------------------------------------
    //clean old records
    //------------------------------------------------------------------
    sQuery       = "DELETE FROM dm_settings WHERE account = '"+sPC+"' AND type=2 AND slot="+sSlot;

    SQLExecDirect( sQuery );

    SendMessageToPC( oPC, "[Cleaning up slot "+sSlot+"]" );

    //------------------------------------------------------------------
    //find items
    //------------------------------------------------------------------
    while ( GetIsObjectValid( oObject ) ){

        if ( GetObjectType( oObject ) == OBJECT_TYPE_ITEM ){

            ++nCount;

            fDelay = nCount/3.0;

            DelayCommand( fDelay, StoreItem( oPC, oObject, sSlot ) );
        }

        oObject = GetNextObjectInArea();
    }
}

void StoreItem( object oPC, object oItem, string sSlot ){

    string sPC          = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sItem        = SQLEncodeSpecialChars( GetName( oItem ) );
    string sQuery       = "";


    //------------------------------------------------------------------
    //store
    //------------------------------------------------------------------
    sQuery       = "INSERT INTO dm_settings VALUES ( NULL, '"+
                    sPC+"', 2, "+sSlot+", '"+sItem+"', NULL, %s, NULL, NOW() )";
    //execute
    SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

    //sql hooks into BioWare campaign DB stuff
    StoreCampaignObject ( "NWNX", "-", oItem );

    SendMessageToPC( oPC, "["+GetName( oItem )+" stored in slot "+sSlot+"]" );

    DestroyObject( oItem, 2.0 );
}

void SpawnItems( object oPC, object oTarget, location lTarget, string sSlot ){

    string sPC    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sQuery = "SELECT id FROM dm_settings WHERE account = '"+sPC+"' AND type=2 AND slot="+sSlot;
    float fDelay;
    int nCount;
    string sID;

    SendMessageToPC( oPC, "[Spawning items from slot "+sSlot+"]" );

    //execute
    SQLExecDirect( sQuery );

    while ( SQLFetch() == SQL_SUCCESS ){

        ++nCount;

        fDelay = nCount/3.0;

        sID = SQLGetData(1);

        DelayCommand( fDelay, SpawnItem( oPC, oTarget, lTarget, sID ) );
    }
}

void SpawnItem( object oPC, object oTarget, location lTarget, string sID ){

    string sQuery = "SELECT content FROM dm_settings WHERE id = " + sID + " LIMIT 1";

    //execute
    SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

    RetrieveCampaignObject ("NWNX", "-", lTarget, oTarget );
}

void CastSpells( object oPC, object oTarget, string sSlot ){

    AssignCommand( oPC, ActionPauseConversation() );

    string sPC    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sQuery = "SELECT message, title FROM dm_settings WHERE account = '"+sPC+"' AND type=3 AND slot="+sSlot;
    float fDelay;

    //execute
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ){

        //start parsing if there's a spell list
        string sSpellList   = SQLGetData(1);
        int nPointer1       = FindSubString( sSpellList, "_" ) + 1;
        string sSpellID     = GetSubString( sSpellList, nPointer1, 65 );

        while ( sSpellID != "" && sSpellID != "_" ){

            DelayCommand( fDelay, AssignCommand( oPC, ActionCastSpellAtObject( StringToInt( sSpellID ), oTarget, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE ) ) );

            nPointer1   = FindSubString( sSpellList, "_", nPointer1 ) + 1;
            sSpellID    = GetSubString( sSpellList, nPointer1, 65 );
            fDelay     += 0.3;
        }

        SendMessageToPC( oPC, "[Casting spells "+SQLGetData(2)+" from slot "+sSlot+"]" );

        fDelay     += 0.3;

        DelayCommand( fDelay, AssignCommand( oPC, ActionResumeConversation( ) ) );
    }
}

void ApplyAppearance( object oPC, object oTarget, string sSlot ){

    string sPC    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sQuery = "SELECT reference FROM dm_settings WHERE account = '"+sPC+"' AND type=4 AND slot="+sSlot;
    string sMessage;

    if ( GetIsPC( oTarget ) && !GetIsDM( oTarget ) && !GetIsDMPossessed( oTarget ) ){

        SendMessageToPC( oPC, "You can't change the appearance of a PC!" );
        return;
    }

    //execute
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ){

        SetCreatureAppearanceType( oTarget, StringToInt( SQLGetData(1) ) );
    }
}

void ApplyVFX( object oPC, object oTarget, location lTarget, string sSlot, int nPermanent=0 ){

    string sPC    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sQuery = "SELECT reference FROM dm_settings WHERE account = '"+sPC+"' AND type=5 AND slot="+sSlot;
    effect eVis;

    //execute
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ){

        eVis = SupernaturalEffect( EffectVisualEffect( StringToInt( SQLGetData(1) ) ) );

        if ( !GetIsObjectValid( oTarget ) ){

            if ( nPermanent ){

                ApplyEffectAtLocation( DURATION_TYPE_PERMANENT, eVis, lTarget );
            }
            else{

                ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eVis, lTarget, 60.0 );
            }
        }
        else{

            if ( nPermanent ){

                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oTarget );
            }
            else{

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oTarget, 60.0 );
            }
        }
    }
}

void CreateSound( object oPC, location lTarget, string sSlot ){

    string sPC    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sQuery = "SELECT message FROM dm_settings WHERE account = '"+sPC+"' AND type=6 AND slot="+sSlot;
    string sMessage;

    //execute
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ){

        sMessage = SQLGetData(1);

        if ( sMessage != "" ){

            object oSound = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_invisobj", lTarget );

            DelayCommand( 1.0, AssignCommand( oSound, PlaySound( sMessage ) ) );

            DelayCommand( 20.0, DestroyObject( oSound ) );
        }
    }
}


void SpeakText( object oPC, object oTarget, string sSlot ){

    string sPC    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sQuery = "SELECT message FROM dm_settings WHERE account = '"+sPC+"' AND type=7 AND slot="+sSlot;
    string sMessage;

    //execute
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ){

        sMessage = DecodeSpecialChars( SQLGetData(1) );

        AssignCommand( oTarget, SpeakString( sMessage ) );
    }
}

void PortPC( object oPC, object oTarget, string sSlot ){

    string sPC    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sQuery = "SELECT reference FROM dm_settings WHERE account = '"+sPC+"' AND type=8 AND slot="+sSlot;
    string sWP;
    object oWP;
    object oCache = GetCache( "ds_bindpoint_storage" );

    //execute
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ){

        sWP = "b_"+SQLGetData(1);
        oWP = GetLocalObject( oCache, sWP );

        if ( GetIsObjectValid( oWP ) ){

            AssignCommand( oTarget, ClearAllActions() );
            AssignCommand( oTarget, JumpToObject( oWP, 0 ) );
        }
        else{

            server_jump( oTarget, sWP, 0 );
        }
    }
}

void SetArea( object oPC, string sSlot, int nReset=0 ){

    object oArea  = GetArea( oPC );

    if ( nReset == 1 && GetLocalInt( oArea, "dms_org" ) == 1 ){

        SetLocalInt( oArea, "dms_org", 0 );
        SetSkyBox( GetLocalInt( oArea, "dms_sky" ), oArea );
        SetWeather( oArea, GetLocalInt( oArea, "dms_wth" ) );
        MusicBackgroundChangeDay( oArea, GetLocalInt( oArea, "dms_msd" ) );
        MusicBackgroundChangeNight( oArea, GetLocalInt( oArea, "dms_msn" ) );
        SetFogAmount( FOG_TYPE_ALL, GetLocalInt( oArea, "dms_fa" ), oArea );
        SetFogColor( FOG_TYPE_ALL, GetLocalInt( oArea, "dms_fc" ), oArea );

        return;
    }

    string sPC    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sQuery = "SELECT message FROM dm_settings WHERE account = '"+sPC+"' AND type=10 AND slot="+sSlot;
    string sPacked;

    //execute
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ){

        if ( GetLocalInt( oArea, "dms_org" ) != 1 ){

            SetLocalInt( oArea, "dms_org", 1 );
            SetLocalInt( oArea, "dms_sky", GetSkyBox( oArea ) );
            SetLocalInt( oArea, "dms_wth", GetWeather( oArea ) );
            SetLocalInt( oArea, "dms_msd", MusicBackgroundGetDayTrack( oArea ) );
            SetLocalInt( oArea, "dms_msn", MusicBackgroundGetNightTrack( oArea ) );
            SetLocalInt( oArea, "dms_fa", GetFogAmount( FOG_TYPE_ALL, oArea ) );
            SetLocalInt( oArea, "dms_fc", GetFogColor( FOG_TYPE_ALL, oArea ) );
        }

        sPacked = SQLGetData( 1 );

        SetSkyBox( StringToInt( ExplodeString( sPacked, "_", 1 ) ), oArea );
        SetWeather( oArea, StringToInt( ExplodeString( sPacked, "_", 2 ) ) );

        SetAreaLights( oArea, sPacked );

        AmbientSoundChangeDay( oArea, StringToInt( ExplodeString( sPacked, "_", 7 ) ) );
        AmbientSoundChangeNight( oArea, StringToInt( ExplodeString( sPacked, "_", 7 ) ) );
        AmbientSoundPlay( oArea );

        MusicBackgroundChangeDay( oArea, StringToInt( ExplodeString( sPacked, "_", 8 ) ) );
        MusicBackgroundChangeNight( oArea, StringToInt( ExplodeString( sPacked, "_", 8 ) ) );
        MusicBackgroundPlay( oArea );

        SetFogAmount( FOG_TYPE_ALL, StringToInt( ExplodeString( sPacked, "_", 9 ) ), oArea );
        SetFogColor( FOG_TYPE_ALL, StringToInt( ExplodeString( sPacked, "_", 10 ) ), oArea );

        RecomputeStaticLighting( oArea );
    }
}

//set the mainlights or the sourcelights
void SetAreaLights( object oArea, string sPacked ){

    //variables
    vector vLocation;
    location lTile;
    int i;
    int j;
    int nAreaX = GetAreaSize( AREA_WIDTH, oArea );
    int nAreaY = GetAreaSize( AREA_HEIGHT, oArea );
    float fX;
    float fY;

    string sTile1      = ExplodeString( sPacked, "_", 3 );
    string sTile2      = ExplodeString( sPacked, "_", 4 );
    string sSource1    = ExplodeString( sPacked, "_", 5 );
    string sSource2    = ExplodeString( sPacked, "_", 6 );

    for ( i=0; i<nAreaX; i++ ){

        for ( j=0; j<nAreaY; j++ ){

            //walk through the area and set lights tile by tile
            fX = IntToFloat(i);
            fY = IntToFloat(j);

            //Make a location a tile
            vLocation = Vector(fX, fY, 0.0);
            lTile     = Location(oArea, vLocation, 0.0);

             if ( sTile1 != "x" && sTile2 != "x" ){

                //set both types of mainlight colours in one go
                SetTileMainLightColor( lTile, StringToInt( sTile1 ), StringToInt( sTile2 ) );
            }

            if ( sSource1 != "x" && sSource2 != "x" ){

                //set both types of sourcelight colours in one go
                SetTileSourceLightColor( lTile, StringToInt( sSource1 ), StringToInt( sSource2 ) );
            }
        }
    }
}

//utility function
//takes a tokenised string and returns the item on nPosition
//example: ExplodeString( "1234_5678_9_10", "_", 3 ) returns "9"
string ExplodeString( string sString, string sToken, int nPosition ){

    int nStart;
    int nCount;
    int i;
    string sReturn = "NULL";

    if ( GetSubString( sString, 0, 1 ) != sToken ){

        sString = sToken + sString;
    }

    while ( i < nPosition ){

        nStart  = nStart + nCount + 1;

        nCount  = FindSubString( sString, sToken, nStart ) - nStart;

        sReturn = GetSubString( sString, nStart, nCount );

        ++i;
    }

    return sReturn;
}



