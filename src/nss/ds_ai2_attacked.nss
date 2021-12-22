//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai2_attacked
//group:   ds_ai2
//used as: OnAttack
//date:    dec 23 2007
//author:  disco

//2009-01-01  disco  added archer fix

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter     = OBJECT_SELF;
    object oAttacker    = GetLastAttacker();
    object oTarget      = GetLocalObject( oCritter, L_CURRENTTARGET );
    int nCount          = GetLocalInt( oCritter, L_INACTIVE );
    int nResult;
    int nReputation     = GetReputation( oAttacker, oCritter );
    int nConfused       = GetHasEffect( EFFECT_TYPE_CONFUSED, oAttacker );
    int nDominated      = GetHasEffect( EFFECT_TYPE_DOMINATED, oAttacker );
    //set reputation, or set temporary enemy
    if ( GetIsPC( oAttacker ) || GetIsPC( GetMaster( oAttacker ) ) ){

        if ( nReputation >= REPUTATION_TYPE_FRIEND ){
            if ( nDominated ){

                SetIsTemporaryEnemy( oAttacker, oCritter, TRUE, RoundsToSeconds(10) );

            }
            else{

                AdjustReputation( oAttacker, oCritter, -100 );

            }
        }
        else if ( !nDominated ){

            AdjustReputation( oAttacker, oCritter, -100 );

        }
    }
    else{

        if ( nConfused && ( nReputation >= REPUTATION_TYPE_FRIEND ) ){

            SetIsTemporaryEnemy( oAttacker, oCritter, TRUE, RoundsToSeconds(10) );

        }
        else{

            AdjustReputation( oAttacker, oCritter, -100 );

        }
    }

    if ( nCount > 0 ){

        SetLocalObject( oCritter, L_CURRENTTARGET, oAttacker );

        nResult = PerformAction( OBJECT_SELF, "ds_ai2_attacked" );

        if ( nResult == -1 && GetIsObjectValid( oAttacker ) ){

            ActionMoveToObject( oAttacker, TRUE, 10.0 );
        }

        SpeakString( M_ATTACKED, TALKVOLUME_SILENT_TALK );
    }
    else if ( oTarget != oAttacker ){

        if ( GetObjectSeen( oAttacker, oCritter ) && d100() < 25 ){

            SetLocalObject( oCritter, L_CURRENTTARGET, oAttacker );
        }
    }
}
