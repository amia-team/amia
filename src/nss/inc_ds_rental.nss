//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: inc_ds_rental
//group: rentable housing
//used as: lib
//date: 2009-09-04
//author: disco
// Editted: Maverick00053, Aug 2017
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// constants
//-------------------------------------------------------------------------------
const int RNT_WEEKHOURS             = 168;
const int RNT_MONTHHOURS            = 672;

//tags & resrefs
const string RNT_DOOR_IN_PREFIX     = "ds_rental_door_";
const string RNT_SHOP_IN_PREFIX     = "ds_shop_door_";
const string RNT_DOOR_OUT_PREFIX    = "ds_rental_house_";
const string RNT_SHOP_OUT_PREFIX    = "ds_shop_house_";
const string RNT_FURNITURE_TAG      = "ds_rental_f";
const string RNT_STAY_TAG           = "ds_rental_stay";
const string RNT_LAYOUT_TAG         = "ds_rental_layout";
const string RNT_F_LAYOUT_TAG       = "ds_f_rent_layout";
const string RNT_DEAL_TAG           = "ds_rental_deal";
const string RNT_DOOR1_TAG          = "ds_rental_door_1";
const string RNT_DOOR2_TAG          = "ds_rental_door_2";
const string RNT_KEY_TAG            = "ds_rental_key";
const string RNT_F_KEY_TAG          = "ds_f_rental_key";

//local vars, values should be short
const string RNT_LAYOUT_APPLIED     = "ds_rnt_a";
const string RNT_TIMESTAMP          = "ds_rnt_t";
const string RNT_FURNITURE_COUNT    = "ds_rnt_f";
const string RNT_OWNER              = "ds_rnt_o";
const string RNT_PCKEY              = "ds_rnt_p";
const string RNT_DOOR               = "ds_rnt_d";
const string RNT_TARGET             = "ds_rnt_t";
const string RNT_UNLOCKED           = "ds_rnt_l";
const string RNT_RENT_TYPE          = "ds_rnt_t";
const string RNT_INITIALISED        = "ds_rnt_i";
const string RNT_PREFIX             = "ds_rnt_";


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//tags closest rental PLC with a visual effect
void ShowPLC( location lTarget );

//rotates closest PLC
void RotatePLC( location lTarget, float fDegrees );

//rotates closest PLC tawards you
void FaceMePLC( location lTarget );

//destroys closest PLC
void DestroyPLC( location lTarget );

//creates house layout from database
void RestoreLayout();

//stores house layout in database
void StoreLayout( object oItem );

//removes house layout from database
void DeleteLayout();

//applies layout via area OnEnter
void ApplyLayout( object oPC, object oArea, string sOwner, int nType );

//create connection between door and house
//checks for available houses etc.
object CreateConnection( object oPC, object oDoorIn, string sOwnerPCKEY="", int nIsOwner=FALSE );

// Faction layout restore
void RestoreFactionLayout();

//Faction storage script - which is independent of the rental system script.
void StoreFactionLayout( object oItem );

// Faction ApplyLayout
void ApplyFactionLayout( object oPC, object oArea, int nType );


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void ShowPLC( location lTarget ){

    object oPC    = OBJECT_SELF;
    object oPLC = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget );

    if ( GetIsObjectValid( oPLC ) ){

        effect eVFX = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );
        effect eGlow = EffectVisualEffect( VFX_DUR_AURA_PULSE_YELLOW_WHITE );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oPLC, 5.0 );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eGlow, oPLC, 5.0 );
    }
    else{

        SendMessageToPC( oPC, "Error: No PLC selected." );
    }
}

//rotates selected PLC
void RotatePLC( location lTarget, float fDegrees ){

    object oPC    = OBJECT_SELF;
    object oPLC   = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget );

    if ( GetIsObjectValid( oPLC ) ){

        float fFacing = GetFacing( oPLC ) + fDegrees;

        AssignCommand( oPLC, SetFacing( fFacing ) );
    }
    else{

        SendMessageToPC( oPC, "Error: No PLC selected." );
    }
}

//rotates selected PLC
void FaceMePLC( location lTarget ){

    object oPC    = OBJECT_SELF;
    object oPLC   = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget );

    if ( GetIsObjectValid( oPLC ) ){

        TurnToFaceObject( oPC, oPLC );
    }
    else{

        SendMessageToPC( oPC, "Error: No PLC selected." );
    }
}

void DestroyPLC( location lTarget ){

    object oPC    = OBJECT_SELF;
    object oArea  = GetArea( oPC );
    object oPLC   = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget );

    if ( GetIsObjectValid( oPLC ) && GetTag( oPLC ) == RNT_FURNITURE_TAG ){

        effect eVFX = EffectVisualEffect( VFX_DUR_PROTECTION_EVIL_MINOR );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oPLC, 2.0 );

        SafeDestroyObject( oPLC );

        SetLocalInt( oArea, RNT_FURNITURE_COUNT, GetLocalInt( oArea, RNT_FURNITURE_COUNT ) - 1 );
    }
    else{

        SendMessageToPC( oPC, "Error: No PLC selected." );
    }
}

void RestoreLayout(){

    object oPC    = OBJECT_SELF;
    object oArea  = GetArea( oPC );
    object oPCKEY = GetPCKEY( oPC );
    float fFacing;
    float fX;
    float fY;
    string sResRef;
    vector vPLC;
    location lPLC;
    int nCounter;

    if ( GetLocalInt( oArea, RNT_FURNITURE_COUNT ) > 0 ){

        SendMessageToPC( oPC, "Error: You cannot restore a setup when you already placed other furniture." );
        return;
    }

    if ( !GetIsObjectValid( oPCKEY ) ){

        SendMessageToPC( oPC, "Error: Can't find your PCKEY." );
        return;
    }

    string sQuery = "SELECT resref, facing, v_x, v_y FROM rental_furniture WHERE pckey='"+GetName( oPCKEY )+"'";

    SQLExecDirect( sQuery );

    while( SQLFetch( ) == SQL_SUCCESS ){

        ++nCounter;

        sResRef  = SQLGetData( 1 );
        fFacing  = StringToFloat( SQLGetData( 2 ) );
        fX       = StringToFloat( SQLGetData( 3 ) );
        fY       = StringToFloat( SQLGetData( 4 ) );
        vPLC     = Vector( fX, fY );
        lPLC     = Location( oArea, vPLC, fFacing );

        CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lPLC, 0, RNT_FURNITURE_TAG );
    }

    SetLocalInt( oArea, RNT_FURNITURE_COUNT, nCounter );
    SetLocalInt( oArea, RNT_LAYOUT_APPLIED, TRUE );
}

// Faction layout restore
void RestoreFactionLayout(){

    object oPC    = OBJECT_SELF;
    object oArea  = GetArea( oPC );
    object oPCKEY = GetPCKEY( oPC );
    float fFacing;
    float fX;
    float fY;
    float fZ;
    string sResRef;
    string nArea     = GetName(GetArea( oPC ));
    string sArea    = GetResRef( GetArea( oPC ) );
    string sFactionID = sArea+"faction";
    string sFactionName = nArea +" Faction";
    vector vPLC;
    location lPLC;
    int nCounter;

    if ( GetLocalInt( oArea, RNT_FURNITURE_COUNT ) > 0 ){

        SendMessageToPC( oPC, "Error: You cannot restore a setup when you already placed other furniture." );
        return;
    }

    /*
    if ( !GetIsObjectValid( oPCKEY ) ){

        SendMessageToPC( oPC, "Error: Can't find your PCKEY." );
        return;
    }
    */

    string sQuery = "SELECT resref, facing, v_x, v_y, v_z FROM faction_furniture WHERE faction_id='"+sFactionID+"'";

    SQLExecDirect( sQuery );

    while( SQLFetch( ) == SQL_SUCCESS ){

        ++nCounter;

        sResRef  = SQLGetData( 1 );
        fFacing  = StringToFloat( SQLGetData( 2 ) );
        fX       = StringToFloat( SQLGetData( 3 ) );
        fY       = StringToFloat( SQLGetData( 4 ) );
        fZ       = StringToFloat( SQLGetData( 5 ) );
        vPLC     = Vector( fX, fY, fZ );
        lPLC     = Location( oArea, vPLC, fFacing );

        CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lPLC, 0, RNT_FURNITURE_TAG );
    }

    SetLocalInt( oArea, RNT_FURNITURE_COUNT, nCounter );
    SetLocalInt( oArea, RNT_LAYOUT_APPLIED, TRUE );
}
//
void StoreLayout( object oItem ){

    object oPC    = OBJECT_SELF;
    object oArea  = GetArea( oPC );
    object oPLC   = GetFirstObjectInArea( oArea );
    object oPCKEY = GetPCKEY( oPC );
    effect eGlow  = EffectVisualEffect( VFX_DUR_AURA_PULSE_RED_YELLOW );
    vector vPLC;
    float fFacing;
    int nCounter;

    if ( !GetIsObjectValid( oPCKEY ) ){

        SendMessageToPC( oPC, "Error: Can't find your PCKEY." );
        return;
    }

    string sQuery = "DELETE FROM rental_furniture WHERE pckey='"+GetName( oPCKEY )+"'";

    SQLExecDirect( sQuery );

    int nLimit = FloatToInt( 1.5 * GetItemCharges( oItem ) );

    while ( GetIsObjectValid( oPLC ) ){

        if ( nCounter > nLimit ){

            SendMessageToPC( oPC, "Only "+IntToString( nLimit )+" pieces of furniture can be stored. The one that are ignore have been higlighted." );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eGlow, oPLC, 10.0 );
        }
        else if ( GetTag( oPLC ) == RNT_FURNITURE_TAG ){

            ++nCounter;

            vPLC    = GetPosition( oPLC );
            fFacing = GetFacing( oPLC );

            sQuery = "INSERT INTO rental_furniture VALUES ( "
                   + "NULL, "
                   + "'" + GetName( oPCKEY ) + "', "
                   + "'" + GetResRef( oPLC ) + "', "
                   + "'" + FloatToString( fFacing, 3, 1 ) + "', "
                   + "'" + FloatToString( vPLC.x, 3, 2 ) + "', "
                   + "'" + FloatToString( vPLC.y, 3, 2 ) + "')";

            SQLExecDirect( sQuery );
        }

        oPLC = GetNextObjectInArea( oArea );
    }
}


//Faction storage script - which is independent of the rental system script.
void StoreFactionLayout( object oItem ){

    object oPC    = OBJECT_SELF;
    object oArea  = GetArea( oPC );
    object oPLC   = GetFirstObjectInArea( oArea );
    object oPCKEY = GetPCKEY( oPC );
    effect eGlow  = EffectVisualEffect( VFX_DUR_AURA_PULSE_RED_YELLOW );
    vector vPLC;
    float fFacing;
    int nCounter;
    string nArea     = GetName(GetArea( oPC ));
    string sArea    = GetResRef( GetArea( oPC ) );
    string sFactionID = sArea+"faction";
    string sFactionName = nArea +" Faction";

 /*
    if ( !GetIsObjectValid( oPCKEY ) ){

        SendMessageToPC( oPC, "Error: Can't find your PCKEY." );
        return;
    }
 */
    SendMessageToPC( oPC, "Phase 1" );
    string sQuery = "DELETE FROM faction_furniture WHERE faction_id='"+sFactionID+"'";

    SQLExecDirect( sQuery );
    SendMessageToPC( oPC, "Phase 2" );
    int nLimit = 200;

    while ( GetIsObjectValid( oPLC ) ){

        if ( nCounter > nLimit ){

            SendMessageToPC( oPC, "Only "+IntToString( nLimit )+" pieces of furniture can be stored. The one that are ignore have been highlighted." );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eGlow, oPLC, 10.0 );
        }
        else if ( GetTag( oPLC ) == RNT_FURNITURE_TAG ){

            ++nCounter;

            vPLC    = GetPosition( oPLC );
            fFacing = GetFacing( oPLC );

            sQuery = "INSERT INTO faction_furniture VALUES ( "
                   + "NULL, "
                   + "'" + sFactionID + "', "
                   + "'" + GetResRef( oPLC ) + "', "
                   + "'" + FloatToString( fFacing, 3, 1 ) + "', "
                   + "'" + FloatToString( vPLC.x, 3, 2 ) + "', "
                   + "'" + FloatToString( vPLC.y, 3, 2 ) + "', "
                   + "'" + FloatToString( vPLC.z, 3, 2 ) + "')";

            SQLExecDirect( sQuery );
            SendMessageToPC( oPC, "Phase 3" );



        }

        oPLC = GetNextObjectInArea( oArea );
    }
}

void DeleteLayout(){

    object oPC     = OBJECT_SELF;
    object oArea   = GetArea( oPC );
    object oObject = GetFirstObjectInArea( oArea );

    while ( GetIsObjectValid( oObject ) ){

        if ( GetObjectType( oObject ) == OBJECT_TYPE_PLACEABLE && GetTag( oObject ) != RNT_STAY_TAG ){

            SafeDestroyObject( oObject );
        }
        else if ( GetObjectType( oObject ) == OBJECT_TYPE_ITEM ){

            DestroyObject( oObject );
        }

        oObject = GetNextObjectInArea( oArea );
    }

    DeleteLocalInt( oArea, RNT_FURNITURE_COUNT );
    DeleteLocalInt( oArea, RNT_LAYOUT_APPLIED );

    object oPCKEY = GetPCKEY( oPC );

    if ( !GetIsObjectValid( oPCKEY ) ){

        SendMessageToPC( oPC, "Error: Can't find your PCKEY." );
        return;
    }

    string sQuery = "DELETE FROM rental_furniture WHERE pckey='"+GetName( oPCKEY )+"'";

    SQLExecDirect( sQuery );
}

// Faction Delete Layout
void DeleteFactionLayout(){

    object oPC     = OBJECT_SELF;
    object oArea   = GetArea( oPC );
    object oObject = GetFirstObjectInArea( oArea );
    string nArea     = GetName(GetArea( oPC ));
    string sArea    = GetResRef( GetArea( oPC ) );
    string sFactionID = sArea+"faction";
    string sFactionName = nArea +" Faction";


    while ( GetIsObjectValid( oObject ) ){

        if ( GetObjectType( oObject ) == OBJECT_TYPE_PLACEABLE && GetTag( oObject ) != RNT_STAY_TAG ){

            SafeDestroyObject( oObject );
        }
        else if ( GetObjectType( oObject ) == OBJECT_TYPE_ITEM ){

            DestroyObject( oObject );
        }

        oObject = GetNextObjectInArea( oArea );
    }

    DeleteLocalInt( oArea, RNT_FURNITURE_COUNT );
    DeleteLocalInt( oArea, RNT_LAYOUT_APPLIED );

    string sQuery = "DELETE FROM faction_furniture WHERE faction_id='"+sFactionID+"'";

    SQLExecDirect( sQuery );
}

void ApplyLayout( object oPC, object oArea, string sOwner, int nType ){

    float fFacing;
    float fX;
    float fY;
    string sResRef;
    vector vPLC;
    location lPLC;
    int nCounter;
    int nLimit = nType * 15;

    if ( GetLocalInt( oArea, RNT_FURNITURE_COUNT ) > 0 ){

        SendMessageToPC( oPC, "Debug: ApplyLayout: You cannot restore a setup when you already placed other furniture." );
        return;
    }

    if ( sOwner == "" ){

        SendMessageToPC( oPC, "Debug: ApplyLayout: Can't find your PCKEY." );
        return;
    }

    object oObject = GetFirstObjectInArea( oArea );

    while ( GetIsObjectValid( oObject ) ){

         if ( GetTag( oObject ) == RNT_DOOR1_TAG ){

            if ( nType == 1 ){

                AssignCommand( oObject,  PlayAnimation( ANIMATION_DOOR_CLOSE ) );

                SetLocked( oObject, TRUE );
            }
            else{

                SetLocked( oObject, FALSE );
            }
        }
        else if ( GetTag( oObject ) == RNT_DOOR2_TAG ){

            if ( nType == 2 ){

                AssignCommand( oObject,  PlayAnimation( ANIMATION_DOOR_CLOSE ) );

                SetLocked( oObject, TRUE );
            }
            else{

                SetLocked( oObject, FALSE );
            }
        }

         oObject = GetNextObjectInArea( oArea );
    }

    string sQuery = "SELECT resref, facing, v_x, v_y FROM rental_furniture WHERE pckey='"+sOwner+"'";

    SQLExecDirect( sQuery );

    while( SQLFetch( ) == SQL_SUCCESS ){

        ++nCounter;

        if ( nCounter > nLimit ){

            SendMessageToPC( oPC, "Warning: Your layout has more items than your rent package allows for. Create a new layout or upgrade your rent package." );
            break;
        }

        sResRef  = SQLGetData( 1 );
        fFacing  = StringToFloat( SQLGetData( 2 ) );
        fX       = StringToFloat( SQLGetData( 3 ) );
        fY       = StringToFloat( SQLGetData( 4 ) );
        vPLC     = Vector( fX, fY );
        lPLC     = Location( oArea, vPLC, fFacing );

        CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lPLC, 0, RNT_FURNITURE_TAG );
    }

    SetLocalInt( oArea, RNT_FURNITURE_COUNT, nCounter );
    SetLocalInt( oArea, RNT_LAYOUT_APPLIED, TRUE );
}

// Faction ApplyLayout
void ApplyFactionLayout( object oPC, object oArea, int nType ){

    float fFacing;
    float fX;
    float fY;
    float fZ;
    string sResRef;
    vector vPLC;
    location lPLC;
    int nCounter;
    string nArea     = GetName(GetArea( oPC ));
    string sArea    = GetResRef( GetArea( oPC ) );
    string sFactionID = sArea+"faction";
    string sFactionName = nArea +" Faction";

    int nLimit = nType * 15;

    if ( GetLocalInt( oArea, RNT_FURNITURE_COUNT ) > 0 ){

        SendMessageToPC( oPC, "Debug: ApplyLayout: You cannot restore a setup when you already placed other furniture." );
        return;
    }

/*
    if ( sOwner == "" ){

        SendMessageToPC( oPC, "Debug: ApplyLayout: Can't find your PCKEY." );
        return;
    }
*/

    object oObject = GetFirstObjectInArea( oArea );

    while ( GetIsObjectValid( oObject ) ){

         if ( GetTag( oObject ) == RNT_DOOR1_TAG ){

            if ( nType == 1 ){

                AssignCommand( oObject,  PlayAnimation( ANIMATION_DOOR_CLOSE ) );

                SetLocked( oObject, TRUE );
            }
            else{

                SetLocked( oObject, FALSE );
            }
        }
        else if ( GetTag( oObject ) == RNT_DOOR2_TAG ){

            if ( nType == 2 ){

                AssignCommand( oObject,  PlayAnimation( ANIMATION_DOOR_CLOSE ) );

                SetLocked( oObject, TRUE );
            }
            else{

                SetLocked( oObject, FALSE );
            }
        }

         oObject = GetNextObjectInArea( oArea );
    }

    string sQuery = "SELECT resref, facing, v_x, v_y, v_z FROM faction_furniture WHERE faction_id='"+sFactionID+"'";

    SQLExecDirect( sQuery );

    while( SQLFetch( ) == SQL_SUCCESS ){

        ++nCounter;

        if ( nCounter > nLimit ){

            SendMessageToPC( oPC, "Warning: Your layout has more items than your rent package allows for. Create a new layout.." );
            break;
        }

        sResRef  = SQLGetData( 1 );
        fFacing  = StringToFloat( SQLGetData( 2 ) );
        fX       = StringToFloat( SQLGetData( 3 ) );
        fY       = StringToFloat( SQLGetData( 4 ) );
        fZ       = StringToFloat( SQLGetData( 5 ) );
        vPLC     = Vector( fX, fY, fZ );
        lPLC     = Location( oArea, vPLC, fFacing );

        CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lPLC, 0, RNT_FURNITURE_TAG );
    }

    SetLocalInt( oArea, RNT_FURNITURE_COUNT, nCounter );
    SetLocalInt( oArea, RNT_LAYOUT_APPLIED, TRUE );
}

object CreateConnection( object oPC, object oDoorIn, string sOwnerPCKEY="", int nIsOwner=FALSE ){

    string sDoorOut = RNT_DOOR_OUT_PREFIX+"1";
    int nIsShop     = FALSE;

    //shop addition
    if ( FindSubString( GetTag( oDoorIn ), RNT_SHOP_IN_PREFIX ) != -1 ){

        nIsShop = TRUE;
        sDoorOut = RNT_SHOP_OUT_PREFIX+"1";

    }

    object oDoorOut = GetObjectByTag( sDoorOut );
    object oCreature;
    object oHouse;
    int i = 1;
    int nResult;
    int nTimestamp;
    int nTimestamped;

    while ( GetIsObjectValid( oDoorOut ) ){

        oHouse     = GetArea( oDoorOut );
        oCreature  = GetNearestObject( OBJECT_TYPE_CREATURE, oDoorOut );
        nTimestamp = GetLocalInt( oHouse, RNT_TIMESTAMP );

        if ( GetIsObjectValid( oCreature ) ){

            SendMessageToPC( oPC, "Debug: CreateConnection: Skip house #"+IntToString( i )+": Not Empty." );

            ++i;
        }
        else if ( nTimestamp && GetRunTime() < nTimestamp ){

            SendMessageToPC( oPC, "Debug: CreateConnection: Skip house #"+IntToString( i )+": Empty, but time locked." );

            nTimestamped = TRUE;

            ++i;
        }
        else {

            SendMessageToPC( oPC, "Debug: CreateConnection: Using house #"+IntToString( i )+"." );

            SetLocalString( oDoorIn, RNT_PCKEY, sOwnerPCKEY );

            nResult = 1;

            break;
        }

        if ( nIsShop ){

            sDoorOut = RNT_SHOP_OUT_PREFIX+IntToString( i );
        }
        else{

            sDoorOut = RNT_DOOR_OUT_PREFIX+IntToString( i );
        }

        oDoorOut = GetObjectByTag( sDoorOut );
    }

    if ( nResult ){

        SendMessageToPC( oPC, "Debug: CreateConnection: Creating links." );

        //remove old link from front door
        object OldDoorIn = GetLocalObject( oDoorOut, RNT_TARGET );

        if ( GetIsObjectValid( OldDoorIn ) ){

            SendMessageToPC( oPC, "Debug: CreateConnection: Disconnecting "+GetTag( OldDoorIn )+" in "+GetName( GetArea( OldDoorIn ) ) );

            DeleteLocalObject( OldDoorIn, RNT_TARGET );
            DeleteLocalString( OldDoorIn, RNT_OWNER );
        }

        //set link from front door to interior door
        SetLocalObject( oDoorIn, RNT_TARGET, oDoorOut );
        SetLocalString( oDoorIn, RNT_OWNER, sOwnerPCKEY );

        //set link from interior door to front door
        SetLocalObject( oDoorOut, RNT_TARGET, oDoorIn );
        SetLocalString( oDoorOut, RNT_OWNER, sOwnerPCKEY );

        SendMessageToPC( oPC, "Debug: CreateConnection: Cleaning up." );

        //remove previously spawned PLCs
        object oObject = GetFirstObjectInArea( oHouse );

        while ( GetIsObjectValid( oObject ) ){

            if ( GetObjectType( oObject ) == OBJECT_TYPE_PLACEABLE && GetTag( oObject ) != RNT_STAY_TAG ){

                 SafeDestroyObject( oObject );
            }
            else if ( GetObjectType( oObject ) == OBJECT_TYPE_ITEM ){

                 DestroyObject( oObject );
            }

            oObject = GetNextObjectInArea( oHouse );
        }

        DeleteLocalInt( oHouse, RNT_FURNITURE_COUNT );
        DeleteLocalInt( oHouse, RNT_LAYOUT_APPLIED );

        SendMessageToPC( oPC, "Debug: CreateConnection: Storing "+GetTag( oDoorOut )+" on "+GetName( oHouse )+"." );

        //set door object on area for easy retrieval
        SetLocalObject( oHouse, RNT_DOOR, oDoorOut );

        //keep this house connected for at least 5 minutes
        SetLocalInt( oHouse, RNT_TIMESTAMP, GetRunTime( 5 ) );

        //store door owner on the house
        SetLocalString( oHouse, RNT_OWNER, sOwnerPCKEY );
        SendMessageToPC( oPC, "Debug: CreateConnection: Storing "+GetName( oPC )+" on "+GetName( oHouse )+"." );

        return oHouse;
    }
    else{

        SendMessageToPC( oPC, "Alas, I can't find an available area at this moment." );

        if ( nTimestamped ){

            SendMessageToPC( oPC, "However, at least one house is currently empty and it will be available for use in less than 5 minutes (if it stays empty, of course)." );
        }
    }

    return OBJECT_INVALID;
}


