//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_patrol
//group:   caraigh
//used as: action script
//date:    apr 10 2011
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC  = GetLastUsedBy();
    object oPLC = OBJECT_SELF;

    if ( GetLocalInt( oPLC, "blocked" ) != 1 ){

        //block
        SetLocalInt( oPLC, "blocked", 1 );

        //get PLC vars
        string sPatrol  = GetLocalString( oPLC, "ds_patrol" );
        object oTrigger = GetLocalObject( oPLC, "trigger" );
        object oArea    = GetArea( oPLC );
        int nPartyMembers;
        int nPatrollers;
        int nRuns;
        object oBadge;
        string sRegion;

        //check partymembers
        object oPartyMember = GetFirstFactionMember( oPC, TRUE );

        while( GetIsObjectValid( oPartyMember ) == TRUE ){

            if ( GetArea( oPartyMember ) == oArea ){

                if ( GetLocalString( oPartyMember, "ds_patrol" ) == sPatrol ){

                    ++nPatrollers;

                    oBadge   = GetLocalObject( oPartyMember, "ds_patrol" );
                    nRuns    = GetLocalInt( oBadge, "ds_patrol" ) + 1;
                    sRegion  = GetLocalString( oBadge, "ds_name" );

                    if ( sRegion == "" ){

                        sRegion = GetTag( oBadge );
                    }

                    SetDescription( oBadge, "You have patrolled "+IntToString( nRuns / 2 )+" miles in "+sRegion+"." );

                    SetLocalInt( oBadge, "ds_patrol", nRuns );
                }
                else{

                    ++nPartyMembers;
                }
            }

            oPartyMember = GetNextFactionMember( oPC, TRUE );
        }

        int nTime = 5 * ( ( 2 * nPatrollers ) + nPartyMembers );

        SetBlockTime( oTrigger, nTime, 0, "ds_patrol" );

        SpeakString( "OOC: This trigger is now blocked for "+IntToString( nTime )+" minutes." );

        DestroyObject( oPLC, 1.0 );

    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

