/*  ds_spawnrod

--------
Verbatim
--------
Utility functions for database spawner

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
20070317  Disco       Start
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_onupdate"
#include "inc_ds_spawns"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void UpdateAreaName( object oPC, object oArea );
void SpawnCritters( object oPC, object oArea );
void StoreCritters( object oPC, object oArea );
void StoreSimpleCritters( object oPC, object oArea );
void CreateCrittersFromTst( object oPC, object oTst );
void CreateCritterFromResRef( object oPC, string sResRef, string sType );
void StoreCritter( object oPC, object oCritter, object oArea, string sType );
void StoreSimpleCritter( object oPC, object oCritter );
void DeleteCritter( object oCritter );
void show_groups( object oPC, object oArea );
void LoopThroughAreas( int nAction );
void FindIdols( object oArea );
void StoreIdol( object oIdol, object oArea );



//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){


    object oPC       = OBJECT_SELF;
    object oArea     = GetArea( oPC );
    int nNode        = GetLocalInt( oPC, "ds_node" );


    if ( nNode == 1 ){
        //update area name
        UpdateAreaName( oPC, oArea );
    }
    else if( nNode == 2 ){

        //add area spawns
        SpawnCritters( oPC, oArea );
        DelayCommand( 5.0, StoreCritters( oPC, oArea ) );

    }
    else if( nNode == 3 ){

        //reload area settings
        SetCrittersOnArea( oPC, oArea );
    }
    else if( nNode == 4 ){

        //create spawngroup 1
    }
    else if( nNode == 5 ){

        //create spawngroup 2
    }
    else if( nNode == 6 ){

        //create spawngroup 3
    }
    else if( nNode == 7 ){

        //show groups
        show_groups( oPC, oArea );
    }
    else if( nNode == 8 ){

        //add nearby critters
        StoreSimpleCritters( oPC, oArea );
    }
    else if( nNode == 10 ){

        FlushKeyBanCache( );
    }
    else if( nNode == 11 ){

        FlushIPBanCache( );
    }
    else if( nNode == 12 ){
        FlushDMCache( );
    }
    else if( nNode == 13 ){

        FlushContrabandCache( );
    }
    else if( nNode == 14 ){

        LoopThroughAreas( 14 );
    }
    else if( nNode == 15 ){

        upd_ProcessAreas( GetLocalInt( GetModule(), "Module" ) );
    }
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void UpdateAreaName( object oPC, object oArea ){

    string sName    = SQLEncodeSpecialChars( GetName( oArea ) );
    string sResRef  = SQLEncodeSpecialChars( GetResRef( oArea ) );
    int nModule     = GetLocalInt( GetModule(), "Module" );

    if ( nModule == 2 ){

        //update area name
        SQLExecDirect( "INSERT INTO area_visits_2 VALUES ( '"+sName+"', '"+sResRef+"', NOW(), 1, 0 ) ON DUPLICATE KEY UPDATE name='"+sName+"'" );
    }
    else{

        //update area name
        SQLExecDirect( "INSERT INTO area_visits VALUES ( '"+sName+"', '"+sResRef+"', NOW(), 1, 0 ) ON DUPLICATE KEY UPDATE name='"+sName+"'" );
    }
}

void SpawnCritters( object oPC, object oArea ){

    //vars
    object oTrigger             = OBJECT_INVALID;
    object oTst                 = OBJECT_INVALID;
    string sResRef              = "";
    string sTst                 = "";
    string sQuery               ="";
    int nTst                    = 0;
    int i                       = 0;
    int j                       = 0;
    int nResult                 = 0;
    float fDelay                = 0.0;

    //check for boss trigger.
    //Update trigger!
    oTrigger = GetNearestObjectByTag( "boss_trigger", oPC );

    i = 1;

    while ( oTrigger != OBJECT_INVALID ){

        SendMessageToPC( oPC, "Bosstrigger found." );

        //get boss resref
        sResRef = GetName( oTrigger );

        ++i;

        fDelay = i/2.0;

        DelayCommand( fDelay, CreateCritterFromResRef( oPC, sResRef, "trace_boss" ) );

        oTrigger = GetNearestObjectByTag( "boss_trigger", oPC, i );

        nResult  = 1;

    }

    i = 0;

    //check for tst template
    nTst = GetLocalInt( oArea, "tst" );

    if ( nTst > 0 ){

        //loop through all templates
        for ( i=1; i<=nTst; ++i ){

            fDelay = i/2.0;

            sTst = "tst_" + IntToString( i );
            oTst = GetNearestObjectByTag( GetLocalString( oArea, sTst ), oPC );

            SendMessageToPC( oPC, "Spawn template ("+sTst+") found." );

            sResRef = GetLocalString( oTst, "tst_resref_boss" );

            CreateCritterFromResRef( oPC, sResRef, "trace_boss" );

            DelayCommand( fDelay, CreateCrittersFromTst( oPC, oTst ) );
        }

        nResult  = 1;
    }

    //get boss from area
    sResRef = GetLocalString( oArea, "boss" );

    if( sResRef != "" ){

        SendMessageToPC( oPC, "Boss ResRef found on Area object." );

        CreateCritterFromResRef( oPC, sResRef, "trace_boss" );

        nResult  = 1;
    }

    //get normal spawns from area
    i       = 0;
    sResRef = GetLocalString( oArea, "monster"+IntToString( i ) );

    while ( sResRef != "" ) {

        SendMessageToPC( oPC, "Critter ResRef found on Area object." );

        ++i;

        fDelay = i/2.0;

        DelayCommand( fDelay, CreateCritterFromResRef( oPC, sResRef, "trace_critter" ) );

        sResRef = GetLocalString( oArea, "monster"+IntToString( i ) );

        nResult  = 1;
    }

    if ( nResult != 1){

        SendMessageToPC( oPC, "No critter references found in this area." );
        SetLocalInt( oPC, "ct_state", 0 );
    }
    else{

        //delayed set state
        SendMessageToPC( oPC, "Critters spawning. Use the rod again to add them to the database. This will also remove the critters." );

    }
}

void StoreCritters( object oPC, object oArea  ){

    int i                       = 0;
    float fDelay                = 0.0;
    string sTableSuffix     = "";
    int nModule             = GetLocalInt( GetModule(), "Module" );

    if ( nModule == 2 ){

        sTableSuffix = "_2";
    }

    //delete old area_critters records on area resref
    string sQuery = "DELETE FROM area_critters"+sTableSuffix+" WHERE area_resref ='"+GetResRef( oArea )+"'";

    //run query
    SQLExecDirect( sQuery );

    //find critters
    object oObject = GetFirstObjectInArea( oArea );

    while( GetIsObjectValid( oObject ) ){

        //store into database
        if ( GetTag( oObject ) == "trace_critter" ){

            ++i;

            fDelay = i/2.0;

            DelayCommand( fDelay, StoreCritter( oPC, oObject, oArea, "Grunt" ) );
        }
        else if ( GetTag( oObject ) == "trace_boss" ){

            ++i;

            fDelay = i/2.0;

            DelayCommand( fDelay, StoreCritter( oPC, oObject, oArea, "Boss" ) );
        }

        oObject = GetNextObjectInArea( oArea );
    }
}

void StoreSimpleCritters( object oPC, object oArea  ){

    int i                       = 0;
    float fDelay                = 0.0;

    //find critters
    object oObject = GetFirstObjectInArea( oArea );

    while( GetIsObjectValid( oObject ) ){

        //store into database
        if ( GetObjectType( oObject ) == OBJECT_TYPE_CREATURE && !GetIsPC( oObject ) && !GetIsDM( oObject ) ){

            //message PC
            SendMessageToPC( oPC, "Detected "+GetName( oObject )+"." );

            ++i;

            fDelay = i/2.0;

            DelayCommand( fDelay, StoreSimpleCritter( oPC, oObject ) );
        }

        oObject = GetNextObjectInArea( oArea );
    }
}

void CreateCrittersFromTst( object oPC, object oTst ){

    string sResRef               = "";
    int i                        = 0;
    int nCritters                = GetLocalInt( oTst, "tst_spawntypes" );
    effect eStop                 = EffectCutsceneParalyze();

    for ( i=1; i<=nCritters; ++i ){

        sResRef = GetLocalString( oTst, "tst_resref_"+IntToString( i ) );

        object oCritter = CreateObject( OBJECT_TYPE_CREATURE, sResRef, GetLocation( oPC ), FALSE, "trace_critter" );

        if ( !GetIsDM( oPC ) ){

            DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eStop, oCritter ) );
        }
    }
}

void CreateCritterFromResRef( object oPC, string sResRef, string sType ){

    effect eStop                = EffectCutsceneParalyze();

    if ( sResRef == "" ){

        return;
    }
    else{

        object oCritter = CreateObject( OBJECT_TYPE_CREATURE, sResRef, GetLocation( oPC ), FALSE, sType );

        if ( !GetIsDM( oPC ) ){

            DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eStop, oCritter ) );
        }
    }
}

void StoreCritter( object oPC, object oCritter, object oArea, string sType ){

    string sAC              = IntToString( GetAC( oCritter ) );
    string sHP              = IntToString( GetCurrentHitPoints( oCritter ) );
    string sCR              = FloatToString( GetChallengeRating( oCritter ), 3, 1 );
    string sRace            = IntToString( GetRacialType( oCritter ) );
    string sTableSuffix     = "";
    int nModule             = GetLocalInt( GetModule(), "Module" );

    if ( nModule == 2 ){

        sTableSuffix = "_2";
    }

    string sAbilities       = IntToString( GetAbilityScore( oCritter, ABILITY_STRENGTH, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_DEXTERITY, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_CONSTITUTION, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_INTELLIGENCE, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_WISDOM, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_CHARISMA, TRUE ) );

    string sClasses         = IntToString( GetClassByPosition( 1, oCritter ) )+","
                            + IntToString( GetLevelByPosition( 1, oCritter ) )+","
                            + IntToString( GetClassByPosition( 2, oCritter ) )+","
                            + IntToString( GetLevelByPosition( 2, oCritter ) )+","
                            + IntToString( GetClassByPosition( 3, oCritter ) )+","
                            + IntToString( GetLevelByPosition( 3, oCritter ) );

    string sHide            = GetName( GetItemInSlot( INVENTORY_SLOT_CARMOUR,   oCritter ) );
    string sClaw            = GetName( GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oCritter ) );
    string sBite            = GetName( GetItemInSlot( INVENTORY_SLOT_CWEAPON_B, oCritter ) );
    string sWeapon          = GetName( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oCritter ) );
    string sShield          = GetName( GetItemInSlot( INVENTORY_SLOT_LEFTHAND,  oCritter ) );
    string sArmour          = GetName( GetItemInSlot( INVENTORY_SLOT_CHEST,     oCritter ) );



    string sQuery1          = "DELETE FROM critters"+sTableSuffix+" WHERE critter_resref='"+GetResRef( oCritter )+"'";

    string sQuery2          = "INSERT INTO critters"+sTableSuffix+" VALUES ( '"
                            + SQLEncodeSpecialChars( GetName( oCritter ) ) + "', '"
                            + GetResRef( oCritter ) + "', '"
                            + sType + "', '"
                            + sAC + "', '"
                            + sHP + "', '"
                            + sCR + "', '"
                            + sRace + "', '"
                            + sAbilities + "', '"
                            + sClasses + "', '"
                            + SQLEncodeSpecialChars( sHide ) + "', '"
                            + SQLEncodeSpecialChars( sClaw ) + "', '"
                            + SQLEncodeSpecialChars( sBite ) + "', '"
                            + SQLEncodeSpecialChars( sWeapon ) + "', '"
                            + SQLEncodeSpecialChars( sShield ) + "', '"
                            + SQLEncodeSpecialChars( sArmour ) + "', '"
                            + GetPortraitResRef( oCritter ) + "', NOW() )";

    string sQuery3          = "INSERT INTO area_critters"+sTableSuffix+" VALUES ( '"
                            + SQLEncodeSpecialChars( GetName(  oArea ) ) + "', '"
                            + GetResRef( oArea ) + "', '"
                            + GetResRef( oCritter ) + "', NOW() )";

    //run queries with delay
    DelayCommand( 0.0, SQLExecDirect( sQuery1 ) );
    DelayCommand( 0.2, SQLExecDirect( sQuery2 ) );
    DelayCommand( 0.4, SQLExecDirect( sQuery3 ) );



    //message PC
    SendMessageToPC( oPC, GetName( oCritter )+" added to database." );

    //delete critter
    DelayCommand( 0.6, DeleteCritter( oCritter ) );

}


void StoreSimpleCritter( object oPC, object oCritter ){

    string sAC              = IntToString( GetAC( oCritter ) );
    string sHP              = IntToString( GetCurrentHitPoints( oCritter ) );
    string sCR              = FloatToString( GetChallengeRating( oCritter ), 3, 1 );
    string sRace            = IntToString( GetRacialType( oCritter ) );
    string sTableSuffix     = "";
    int nModule             = GetLocalInt( GetModule(), "Module" );

    if ( nModule == 2 ){

        sTableSuffix = "_2";
    }

    string sAbilities       = IntToString( GetAbilityScore( oCritter, ABILITY_STRENGTH, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_DEXTERITY, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_CONSTITUTION, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_INTELLIGENCE, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_WISDOM, TRUE ) )+","
                            + IntToString( GetAbilityScore( oCritter, ABILITY_CHARISMA, TRUE ) );

    string sClasses         = IntToString( GetClassByPosition( 1, oCritter ) )+","
                            + IntToString( GetLevelByPosition( 1, oCritter ) )+","
                            + IntToString( GetClassByPosition( 2, oCritter ) )+","
                            + IntToString( GetLevelByPosition( 2, oCritter ) )+","
                            + IntToString( GetClassByPosition( 3, oCritter ) )+","
                            + IntToString( GetLevelByPosition( 3, oCritter ) );

    string sHide            = GetName( GetItemInSlot( INVENTORY_SLOT_CARMOUR,   oCritter ) );
    string sClaw            = GetName( GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oCritter ) );
    string sBite            = GetName( GetItemInSlot( INVENTORY_SLOT_CWEAPON_B, oCritter ) );
    string sWeapon          = GetName( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oCritter ) );
    string sShield          = GetName( GetItemInSlot( INVENTORY_SLOT_LEFTHAND,  oCritter ) );
    string sArmour          = GetName( GetItemInSlot( INVENTORY_SLOT_CHEST,     oCritter ) );



    string sQuery1          = "DELETE FROM critters"+sTableSuffix+" WHERE critter_resref='"+GetResRef( oCritter )+"'";

    string sQuery2          = "INSERT INTO critters"+sTableSuffix+" VALUES ( '"
                            + SQLEncodeSpecialChars( GetName( oCritter ) ) + "', '"
                            + GetResRef( oCritter ) + "', '"
                            + "n.a." + "', '"
                            + sAC + "', '"
                            + sHP + "', '"
                            + sCR + "', '"
                            + sRace + "', '"
                            + sAbilities + "', '"
                            + sClasses + "', '"
                            + SQLEncodeSpecialChars( sHide ) + "', '"
                            + SQLEncodeSpecialChars( sClaw ) + "', '"
                            + SQLEncodeSpecialChars( sBite ) + "', '"
                            + SQLEncodeSpecialChars( sWeapon ) + "', '"
                            + SQLEncodeSpecialChars( sShield ) + "', '"
                            + SQLEncodeSpecialChars( sArmour ) + "', '"
                            + GetPortraitResRef( oCritter ) + "', NOW() )";


    //run queries with delay
    DelayCommand( 0.0, SQLExecDirect( sQuery1 ) );
    DelayCommand( 0.2, SQLExecDirect( sQuery2 ) );

    //message PC
    SendMessageToPC( oPC, GetName( oCritter )+" added to database." );

    //delete critter
    DelayCommand( 0.6, DeleteCritter( oCritter ) );

}


void DeleteCritter( object oCritter ){

    DestroyObject( oCritter );

}

void show_groups( object oPC, object oArea ){

    //testing
    SendMessageToPC( oPC, "spw_grps="+IntToString( GetLocalInt( oArea, "spw_grps" ) ) );
    SendMessageToPC( oPC, "spw_grp_1="+GetLocalString( oArea, "spw_grp_1" ) );
    SendMessageToPC( oPC, "spw_grp_2="+GetLocalString( oArea, "spw_grp_2" ) );
    SendMessageToPC( oPC, "spw_grp_3="+GetLocalString( oArea, "spw_grp_3" ) );
    SendMessageToPC( oPC, "spw_grp_1_time="+IntToString( GetLocalInt( oArea, "spw_grp_1_time" ) ) );
    SendMessageToPC( oPC, "spw_grp_2_time="+IntToString( GetLocalInt( oArea, "spw_grp_2_time" ) ) );
    SendMessageToPC( oPC, "spw_grp_3_time="+IntToString( GetLocalInt( oArea, "spw_grp_3_time" ) ) );
    SendMessageToPC( oPC, "spw_grp_1_size="+IntToString( GetLocalInt( oArea, "spw_grp_1_size" ) ) );
    SendMessageToPC( oPC, "spw_grp_2_size="+IntToString( GetLocalInt( oArea, "spw_grp_2_size" ) ) );
    SendMessageToPC( oPC, "spw_grp_3_size="+IntToString( GetLocalInt( oArea, "spw_grp_3_size" ) ) );
}

void LoopThroughAreas( int nAction ){

    object oAreaList = GetCache( "ds_area_storage" );
    object oArea;
    float fDelay;
    int nAreas = GetLocalInt( oAreaList, "ds_count" );
    int i=0;

    if ( nAction == 14 ){

        SQLExecDirect( "DELETE FROM idols" );
    }

    for ( i=1; i<=nAreas; ++i ){

        oArea   = GetNthArea( i, oAreaList );

        fDelay = 3.0 + i/10.0;

        if ( nAction == 14 ){

            DelayCommand( fDelay, FindIdols( oArea ) );
        }
    }
}

void FindIdols( object oArea ){

    object oObject = GetFirstObjectInArea( oArea );

    while ( GetIsObjectValid( oObject ) ){

        if ( GetResRef( oObject ) == "ds_idol" ){

            StoreIdol( oObject, oArea );
        }

        oObject = GetNextObjectInArea( oArea );
    }
}

void StoreIdol( object oIdol, object oArea ){

    string sArea        = SQLEncodeSpecialChars( GetName( oArea ) );
    string sIdol        = SQLEncodeSpecialChars( GetSubString( GetName( oIdol ), 8, 99 ) );
    string sTag         = GetTag( oIdol );
    string sName        = SQLEncodeSpecialChars( GetLocalString( oIdol, "name" ) );
    string sAlign       = GetLocalString( oIdol, "alignment" );
    string sCE          = IntToString( GetLocalInt( oIdol, "al_CE" ) );
    string sCG          = IntToString( GetLocalInt( oIdol, "al_CG" ) );
    string sCN          = IntToString( GetLocalInt( oIdol, "al_CN" ) );
    string sLE          = IntToString( GetLocalInt( oIdol, "al_LE" ) );
    string sLG          = IntToString( GetLocalInt( oIdol, "al_LG" ) );
    string sLN          = IntToString( GetLocalInt( oIdol, "al_LN" ) );
    string sNE          = IntToString( GetLocalInt( oIdol, "al_NE" ) );
    string sNG          = IntToString( GetLocalInt( oIdol, "al_NG" ) );
    string sNN          = IntToString( GetLocalInt( oIdol, "al_NN" ) );
    string sAir         = IntToString( GetLocalInt( oIdol, "dom_Air" ) );
    string sAnimal      = IntToString( GetLocalInt( oIdol, "dom_Animal" ) );
    string sDeath       = IntToString( GetLocalInt( oIdol, "dom_Death" ) );
    string sDestruction = IntToString( GetLocalInt( oIdol, "dom_Destruction" ) );
    string sEarth       = IntToString( GetLocalInt( oIdol, "dom_Earth" ) );
    string sEvil        = IntToString( GetLocalInt( oIdol, "dom_Evil" ) );
    string sFire        = IntToString( GetLocalInt( oIdol, "dom_Fire" ) );
    string sGood        = IntToString( GetLocalInt( oIdol, "dom_Good" ) );
    string sHealing     = IntToString( GetLocalInt( oIdol, "dom_Healing" ) );
    string sKnowledge   = IntToString( GetLocalInt( oIdol, "dom_Knowledge" ) );
    string sMagic       = IntToString( GetLocalInt( oIdol, "dom_Magic" ) );
    string sPlant       = IntToString( GetLocalInt( oIdol, "dom_Plant" ) );
    string sProtection  = IntToString( GetLocalInt( oIdol, "dom_Protection" ) );
    string sStrength    = IntToString( GetLocalInt( oIdol, "dom_Strength" ) );
    string sSun         = IntToString( GetLocalInt( oIdol, "dom_Sun" ) );
    string sTravel      = IntToString( GetLocalInt( oIdol, "dom_Travel" ) );
    string sTrickery    = IntToString( GetLocalInt( oIdol, "dom_Trickery" ) );
    string sWar         = IntToString( GetLocalInt( oIdol, "dom_War" ) );
    string sWater       = IntToString( GetLocalInt( oIdol, "dom_Water" ) );
    string sModule      = IntToString( GetLocalInt( GetModule(), "Module" ) );

    string sQuery = "INSERT INTO idols VALUES ( NULL, '"+sIdol+"', '"+sArea+"', '"+sTag+"', '"+sName+"', "
                   +"'"+sAlign+"', '"+sCE+"', '"+sCG+"', '"+sCN+"', '"+sLE+"', '"+sLG+"', '"+sLN+"', "
                   +"'"+sNE+"', '"+sNG+"', '"+sNN+"', '"+sAir+"', '"+sAnimal+"', '"+sDeath+"', '"+sDestruction+"', "
                   +"'"+sEarth+"', '"+sEvil+"', '"+sFire+"', '"+sGood+"', '"+sHealing+"', '"+sKnowledge+"', "
                   +"'"+sMagic+"', '"+sPlant+"', '"+sProtection+"', '"+sStrength+"', '"+sSun+"', '"+sTravel+"', "
                   +"'"+sTrickery+"', '"+sWar+"', '"+sWater+"', '"+sModule+"', NOW() )";

    SQLExecDirect( sQuery );
}




