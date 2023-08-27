//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_plc_cloner
//group:   utilities
//used as: activation script
//date:    apr 02 2007
//author:  disco

//-----------------------------------------------------------------------------
// changelog
//-----------------------------------------------------------------------------
// 02 July 2011 - Selmak added support for cloned job system alchemy lab in
//                RestorePLC function
// 2014 03 30   - Terrah; y u no rotate, pls stp. Added Z.
// 2022 oct 25  - Frozen; removed relics, set limit to 30 plcs stored (was 99)

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x0_i0_position"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void SetWidget( object oPC, object oItem, location lTarget );
object StorePLC( object oPC, object oItem, location lTarget, int nNth );
void SpawnGroup( object oPC, object oItem, location lTarget );
object RestorePLC( object oPC, object oItem, location lTarget, int nNth );
void FlushWidget( object oItem );
float GetAngle( location lOne, location lTwo );
void Circle( location lOrigo, string sResRef, float fResolution, float fRadius, float fDuration );
void RemoveAll( object oItem );
float ZNeutralDistance(location a, location b);

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

float GetSetRadius( object oPC ){

    float fRadius = StringToFloat( GetLocalString( oPC, "last_chat" ) );

    if( fRadius <= 0.01 ){
        fRadius = 5.0;
    }

    return fRadius;
}

void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
    object oPC;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
                   oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            location lTarget = GetItemActivatedTargetLocation();
            string sLast = GetLocalString( oPC, "last_chat" );

            if( oTarget == oItem ){

                string s = GetSubString( sLast, 0, 1 );

                if( FindSubString( "0123456789", s ) == -1 ){
                    SendMessageToPC( oPC, "Removing PLCs..." );
                    RemoveAll( oItem );
                    return;
                }

                float fOffset = StringToFloat( sLast );
                SendMessageToPC( oPC, "Applied rotation: " + FloatToString( fOffset ) );
                SetLocalFloat( oItem, "offsetrotation", fOffset );
            }
            else if ( oTarget == oPC && ( GetIsDM( oPC ) ) ){

                if( GetStringLeft( sLast, 3 ) == "vfx" ){

                    string sRef = GetSubString( sLast, 3, GetStringLength( sLast )-3 );
                    SetLocalInt( oItem, "vfx", StringToInt( sRef ) );
                    SendMessageToPC( oPC, "PLCs will now be spawned with vfx " + IntToString( StringToInt( sRef ) ) );
                    return;
                }
                else if( GetStringLeft( sLast, 6 ) == "single" ){

                    int nNumb = StringToInt( GetSubString( sLast, 7, GetStringLength( sLast )-7 ) );
                    SetLocalInt( oItem, "plcs_allowed", nNumb );
                    SendMessageToPC( oPC, "You set this widget to allow " + IntToString( nNumb ) + " plcs!" );
                    return;
                }

                FlushWidget( oItem );
                SendMessageToPC( oPC, "Widget Flushed!" );
            }
            else if( oTarget == oPC ){

                string s = GetSubString( sLast, 0, 1 );

                if( FindSubString( "0123456789", s ) == -1 ){
                    SendMessageToPC( oPC, "Removing PLCs..." );
                    RemoveAll( oItem );
                    return;
                }

                float fOffset = StringToFloat( sLast );
                SendMessageToPC( oPC, "Applied rotation: " + FloatToString( fOffset ) );
                SetLocalFloat( oItem, "offsetrotation", fOffset );
            }
            else if ( GetName( oItem ) != "PLC group cloner" && oTarget != OBJECT_INVALID ){

                SendMessageToPC( oPC, "You can't place this group on top of something or someone!" );
            }
            else if ( GetName( oItem ) == "PLC Group Cloner" ){

                SetWidget( oPC, oItem, lTarget );
            }
            else{
                SpawnGroup( oPC, oItem, lTarget );
            }


        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void SetWidget( object oPC, object oItem, location lTarget ){

    int i;
    int nFlag = 32;

    if( GetLocalInt( oItem, "plcs_allowed" ) > 0 )
        nFlag = 2;

    for ( i=1; i<nFlag; ++i ){

        object oPLC = StorePLC( oPC, oItem, lTarget, i );

        if ( oPLC == OBJECT_INVALID ){

            SendMessageToPC( oPC, "Stored " + IntToString( i-1 ) + " PLCs!" );
            Circle( lTarget, "plc_solblue", 20.0, GetSetRadius( oPC )-0.1, 6.0 );
            return;
        }
        else if ( i == 1 ){

            SetName( oItem, "Spawn "+GetName( oPLC )+" group" );
        }
    }
}

object StorePLC( object oPC, object oItem, location lTarget, int nNth ){

    object oPLC = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget, nNth );

    if ( oPLC == OBJECT_INVALID ){

        return OBJECT_INVALID;
    }

    location lPLC = GetLocation( oPLC );
    //location lPC  = GetLocation( oPC );

    if ( GetDistanceBetweenLocations( lPLC, lTarget ) <= GetSetRadius( oPC ) ){

        string sStoreVar = "ds_plc_"+IntToString( nNth );

        SetLocalString( oItem, sStoreVar, GetResRef( oPLC ) );
        SetLocalFloat( oItem, sStoreVar+"_a", GetAngle( lTarget, lPLC ) );
        SetLocalFloat( oItem, sStoreVar+"_o", GetFacing( oPLC ) );

        vector vOri = GetPositionFromLocation( lTarget );
        vector vTrg = GetPositionFromLocation( lPLC );

        SetLocalFloat( oItem, sStoreVar+"_z", vTrg.z - vOri.z );

        SetLocalFloat( oItem, sStoreVar+"_d", ZNeutralDistance( lTarget, lPLC ) );

        SendMessageToPC( oPC, "Stored "+GetName( oPLC ) );

        return oPLC;
    }

    return OBJECT_INVALID;
}

void RemoveAll( object oItem ){

    string sTag = "ds_plc_"+ObjectToString( oItem );
    int nNth = 0;
    object oCnt = GetObjectByTag( sTag, nNth );
    while( GetIsObjectValid( oCnt ) ){

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_STARBURST_RED ), GetLocation( oCnt ) );
        DestroyObject( oCnt, 1.0 );
        oCnt = GetObjectByTag( sTag, ++nNth );
    }
}

void SpawnGroup( object oPC, object oItem, location lTarget ){

    string sTag = "ds_plc_"+ObjectToString( oItem );
    int nDestroy = 0;

    if ( GetObjectByTag( sTag ) != OBJECT_INVALID ){

        if( GetLocalInt( oItem, "plcs_allowed" ) > 0 ){

            int nNth = 0;
            object oCnt = GetObjectByTag( sTag, nNth );
            while( GetIsObjectValid( oCnt ) ){
                oCnt = GetObjectByTag( sTag, ++nNth );
            }

            nDestroy = ( nNth >= GetLocalInt( oItem, "plcs_allowed" ) );
        }
        else
            nDestroy = 1;
    }
    else if( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) )
        SendMessageToPC( oPC, "Did you know: using the PLC spawner on yourself will apply your last said message (degrees) to the rotation of your PLC group." );

    int i;
    int nFlag = 32;

    for ( i=1; i<nFlag; ++i ){

        if ( nDestroy ){

            object oPLC =GetObjectByTag( sTag, (i-1) );

            if ( oPLC == OBJECT_INVALID ){

                return;
            }
            else{

                ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_STARBURST_RED ), GetLocation( oPLC ) );
                DestroyObject( oPLC, 1.0 );
            }
        }
        else{

            object oPLC = RestorePLC( oPC, oItem, lTarget, i );

            if ( oPLC == OBJECT_INVALID ){

                return;
            }
        }
    }
}

object RestorePLC( object oPC, object oItem, location lTarget, int nNth ){

    string sStoreVar = "ds_plc_"+IntToString( nNth );
    string sResRef   = GetLocalString( oItem, sStoreVar );

    if ( sResRef == "" ){

        return OBJECT_INVALID;
    }

    float fAngle         = GetLocalFloat( oItem, sStoreVar+"_a" );
    float fDistance      = GetLocalFloat( oItem, sStoreVar+"_d" );
    float fOrientation   = GetLocalFloat( oItem, sStoreVar+"_o" );
    float fRotation      = GetAngle( lTarget, GetLocation( oPC ) ) + GetLocalFloat( oItem, "offsetrotation" );
    //location lPLC = GenerateNewLocationFromLocation( lTarget, fDistance, fAngle, fOrientation );

    //Dunno but I'll do it myself here for added rotation
    vector vOrigo = GetPositionFromLocation( lTarget );
    vector vNew;

    vNew.x = vOrigo.x + ( fDistance * cos( fAngle+fRotation ) );
    vNew.y = vOrigo.y + ( fDistance * sin( fAngle+fRotation ) );
    vNew.z = vOrigo.z + GetLocalFloat( oItem, sStoreVar+"_z" );

    location lPLC = Location( GetAreaFromLocation( lTarget ), vNew, fOrientation+fRotation );

    string sTag = "ds_plc_"+ObjectToString( oItem );

    object oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lPLC, FALSE, sTag );

    if ( GetStringLeft( sResRef, 5 ) == "ds_j_" ){
        string sCloneTag;
        if ( sResRef == "ds_j_alchemy" ) sCloneTag = "ds_j_alchemist";


        SetLocalString( oPLC, "clone_tag", sCloneTag );


    }

    if( GetLocalInt( oItem, "vfx" ) > 0 ){
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect(  GetLocalInt( oItem, "vfx" ) ), oPLC );
    }

    SendMessageToPC( oPC, "Spawned "+GetName( oPLC ) );

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_STARBURST_GREEN ), lPLC );

    return oPLC;
}

void FlushWidget( object oItem ){

    int i;

    for ( i=1; i<100; ++i ){

        string sStoreVar = "ds_plc_"+IntToString( i );

        DeleteLocalString( oItem, sStoreVar );
        DeleteLocalFloat( oItem, sStoreVar+"_a" );
        DeleteLocalFloat( oItem, sStoreVar+"_d" );
        DeleteLocalFloat( oItem, sStoreVar+"_o" );
    }

    SetName( oItem, "PLC Group Cloner" );

}

// this actually works, the BioWare function is crap
float GetAngle( location lOrigin, location lTarget ){

    vector v1 = GetPositionFromLocation(lOrigin);
    vector v2 = GetPositionFromLocation(lTarget);
    return VectorToAngle(v2 - v1);

}


void Circle( location lOrigo, string sResRef, float fResolution, float fRadius, float fDuration ){

    vector v = GetPositionFromLocation( lOrigo );
    vector new;
    location l;
    float n=0.0;
    object oArea = GetAreaFromLocation( lOrigo );
    object oObj;
    int nTag = 0;

    while( n<360.0 ){

        new.x = fRadius * cos( n ) + v.x;
        new.y = fRadius * sin( n ) + v.y;
        new.z = v.z;
        oObj = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, Location( oArea, new, n ), FALSE, sResRef+IntToString( nTag ) );
        if( fDuration > 0.0 )
            DestroyObject( oObj, fDuration );
        n+=fResolution;
        nTag++;
    }
}

float ZNeutralDistance(location a, location b){

    vector v = GetPositionFromLocation( a );
    v.z = 0.0;
    location newa = Location( GetAreaFromLocation( a ), v, GetFacingFromLocation( a ) );

    v = GetPositionFromLocation( b );
    v.z = 0.0;

    location newb = Location( GetAreaFromLocation( b ), v, GetFacingFromLocation( b ) );

    return GetDistanceBetweenLocations( newa, newb );
}
