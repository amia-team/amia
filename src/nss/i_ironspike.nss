//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   i_ironspike
//author:   msheeler
//date:     4/12/2016

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int nCheckTargetLocation( object oPC, location lTarget ){


    vector vPC          = GetPosition( oPC );
    vector vTarget      = GetPositionFromLocation( lTarget );
    float fDifferenceX  = vTarget.x - vPC.x;
    float fDifferenceY  = vTarget.y - vPC.y;
    float fDifferenceZ  = vTarget.z - vPC.z;

    SendMessageToPC( oPC, "[debug: X difference: "+ FloatToString( fDifferenceX, 3, 1 ) + "]" );
    SendMessageToPC( oPC, "[debug: Y difference: "+ FloatToString( fDifferenceY, 3, 1 ) + "]" );
    SendMessageToPC( oPC, "[debug: Z difference: "+ FloatToString( fDifferenceZ, 3, 1 ) + "]" );

    if ( fDifferenceZ < -1.5 || fDifferenceZ > 1.5 ){

        SendMessageToPC( oPC, "You can only place this at your feet." );
        return FALSE;
    }

    if ( fabs( fDifferenceX ) > 1.5 || fabs( fDifferenceY ) > 1.5 ){

        SendMessageToPC( oPC, "You can't set the hook that far away form yourself." );
        return FALSE;
    }


    return TRUE;
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{

//event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            location lTarget = GetItemActivatedTargetLocation();
            string sTag       = "ms_ironSpike" + GetPCPublicCDKey( oPC);
            object oPlaceable = GetNearestObjectByTag ( sTag, oPC );


        if( oPlaceable == OBJECT_INVALID ){
            if ( nCheckTargetLocation( oPC, lTarget ) ){
                AssignCommand( oPC, SpeakString( "*sets a grappling hook into the ground and secures it*" ) );
                CreateObject( OBJECT_TYPE_PLACEABLE, "ms_ironSpike", lTarget, FALSE, sTag );
                SetName( GetNearestObjectByTag ( sTag, oPC), GetName( oPC )+"'s Grappling Hook");
                }
            }
        else {
            SendMessageToPC( oPC,"You removed the grappling hook.");
            DestroyObject(oPlaceable);
        }

    break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
    }


