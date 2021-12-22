//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_seatravel_act
//group: travel
//used as: convo action script
//date: 2008-09-13
//author: disco

// 10/09/19  Jes  Modified Line 77, Added: || ( nModule == 1 && nWaypoint == 7 )


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_porting"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = OBJECT_SELF;
    object oNPC     = GetLocalObject( oPC, "ds_target" );
    int nNode       = GetLocalInt( oPC, "ds_node" );
    int nModule     = GetLocalInt( GetModule(), "Module" );
    int nGold;
    int nWaypoint;
    string sWaypoint;

    if ( nNode > 0 && nNode < 11 ){

        nGold       = 200;
        nWaypoint   = nNode;
    }
    else if ( nNode > 10 && nNode < 21 ){


        nGold       = 400;
        nWaypoint   = nNode-10;
    }
    else if ( nNode > 20 && nNode < 31 ){


        nGold       = 600;
        nWaypoint   = nNode-20;
    }
    else if ( nNode > 30 && nNode < 35 ){

        nGold       = 100;
        nWaypoint   = nNode;
    }
    else if ( nNode == 35 ){

        nGold       = 600;
        nWaypoint   = nNode;
    }
    else if ( nNode > 35 && nNode < 41 ){

        nGold       = 200;
        nWaypoint   = nNode;
    }
    else{

        return;
    }

    sWaypoint   = "st_"+IntToString( nWaypoint );


    //SendMessageToPC( oPC, "<c¥  >Test: WP="+sWaypoint+"</c>" );


    if ( nModule == 1 && nWaypoint < 6 || ( nModule == 1 && nWaypoint == 35 ) || ( nModule == 1 && nWaypoint == 7 ) ){

        if ( GetGold( oPC ) >= nGold ){

            //target location is on the other server
            server_jump( oPC, sWaypoint, nGold );
        }
        else{

            PlaySound( "gui_cannotequip" );
            SendMessageToPC( oPC, "<cþ  >You need "+IntToString( nGold )+" gold to travel with this boat.</c>" );
        }
    }
    else{

        //target location is on this server

        object oDest    = GetWaypointByTag( sWaypoint );

        if ( GetIsDM( oPC ) ){

            AssignCommand( oPC, ClearAllActions( TRUE ) );
            AssignCommand( oPC, JumpToObject( oDest, FALSE ) );

            return;
        }

        //load/store party trigger
        object oTrigger = GetLocalObject( oNPC, "party_trigger" );

        if ( !GetIsObjectValid( oTrigger ) ){

            oTrigger = GetNearestObjectByTag( "party_trigger" );
            SetLocalObject( oNPC, "party_trigger", oTrigger );
        }

        //transport party
        object oObject  = GetFirstInPersistentObject( oTrigger );

        while ( GetIsObjectValid( oObject ) ) {

            if ( ds_check_partymember( oPC, oObject ) ) {

                if ( GetIsPC( oObject ) && GetGold( oObject ) >= nGold ){

                    TakeGoldFromCreature( nGold, oObject, TRUE );
                    AssignCommand( oObject, ClearAllActions( TRUE ) );
                    AssignCommand( oObject, JumpToObject( oDest, FALSE ) );
                }
                else if ( GetIsPC( oObject ) ){

                    PlaySound( "gui_cannotequip" );
                    SendMessageToPC( oObject, "<cþ  >You need "+IntToString( nGold )+" gold to travel with this boat.</c>" );
                }
                else{

                    AssignCommand( oObject, ClearAllActions( TRUE ) );
                    AssignCommand( oObject, JumpToObject( oDest, FALSE ) );
                }
            }

            oObject = GetNextInPersistentObject( oTrigger );
        }
    }
}
