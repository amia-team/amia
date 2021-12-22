//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_dm_tool
//group:
//used as: activation script
//date:    apr 02 2007
//author:  disco

// 2008/07/05 disco               new blindness/underwater system
// 2008/07/05 disco               new racial trait system
// 2009/02/23 disco            Updated racial/class/area effects refresher

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_info"
#include "inc_ds_actions"
#include "inc_ds_died"
#include "inc_nwnx_events"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            // item activate variables
            object oDM       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            location lTarget = GetItemActivatedTargetLocation();
            int i;
            string sCheck;

            clean_vars( oDM, 4 );

            if ( GetIsDM(oDM) ){

                SetLocalString( oDM, "ds_action", "ds_dm_tool" );
                SetCustomToken( 4500, GetName( oTarget ) );

                if ( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

                    //show basic info
                    GetItemInfo( oTarget, oDM );

                    //set local vars
                    SetLocalInt( oDM, "ds_check_1", 1 );
                    SetLocalInt( oDM, "ds_section", 1 );
                    SetLocalObject( oDM, "ds_target", oTarget );
                }
                else if ( GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ){

                    //show basic info
                    GetPlaceableInfo( oTarget, oDM );

                    //set local vars
                    SetLocalInt( oDM, "ds_check_2", 1 );
                    SetLocalInt( oDM, "ds_section", 2 );
                    SetLocalObject( oDM, "ds_target", oTarget );
                }
                else if ( GetIsObjectValid( oTarget ) == FALSE ){

                    //show basic info
                    GetAreaInfo( oDM, GetArea( oDM ) );

                    //set local vars
                    SetLocalInt( oDM, "ds_check_3", 1 );
                    SetLocalInt( oDM, "ds_section", 3 );
                    DeleteLocalObject( oDM, "ds_target" );
                    SetLocalLocation( oDM, "ds_target", lTarget );
                    SetCustomToken( 4500, GetName( GetArea( oDM )  ) );
                }
                else if ( GetIsDM( oTarget ) || GetIsDMPossessed( oTarget ) ){

                    //show basic server info

                    //set local vars
                    SetLocalInt( oDM, "ds_check_7", 1 );
                    SetLocalInt( oDM, "ds_section", 7 );
                    DeleteLocalObject( oDM, "ds_target" );
                }
                else if ( GetIsPC( oTarget ) == TRUE && GetIsDead( oTarget ) == FALSE ){

                    //show basic info
                    GetPCInfo( oTarget, oDM );

                    //set local vars
                    SetLocalInt( oDM, "ds_check_4", 1 );
                    SetLocalInt( oDM, "ds_section", 4 );
                    SetLocalObject( oDM, "ds_target", oTarget );
                }
                else if ( GetIsPC( oTarget ) == TRUE && GetIsDead( oTarget ) == TRUE ){

                    int nHealed     = GetMaxHitPoints(oTarget);
                    effect eRaise   = EffectResurrection();
                    effect eHeal    = EffectHeal(nHealed + 10);

                    //Apply the heal, raise dead and VFX impact effect
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);

                    //---------------------------------------------------------
                    //clean death settings
                    //---------------------------------------------------------
                    RemoveDeadStatus( oTarget );

                    return;
                }
                else if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

                    //show basic info
                    GetNpcInfo( oTarget, oDM );

                    //set local vars
                    SetLocalInt( oDM, "ds_check_5", 1 );
                    SetLocalInt( oDM, "ds_section", 5 );
                    SetLocalObject( oDM, "ds_target", oTarget );
                }
                else if ( GetObjectType( oTarget ) == OBJECT_TYPE_DOOR ){

                    //show basic info
                    GetDoorInfo( oTarget, oDM );

                    //set local vars
                    SetLocalInt( oDM, "ds_check_6", 1 );
                    SetLocalInt( oDM, "ds_section", 6 );
                    SetLocalObject( oDM, "ds_target", oTarget );
                }
                else{

                    DeleteLocalObject( oDM, "ds_target" );
                }
            }
            else{

                DestroyObject( oItem );
            }

            AssignCommand( oDM, ActionStartConversation( oDM, "ds_dm_tool", TRUE, FALSE ) );

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
