//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_onspell
//group:   jobs
//used as: ExecuteScript() script that cleans up unused NPCs
//date:    feb 02 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_j_lib"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){


    object oPC       = GetLastSpellCaster();
    object oNPC      = OBJECT_SELF;
    int nSpell       = GetLastSpell();
    int nJob         = GetLocalInt( oNPC, DS_J_JOB );
    location lAnchor = GetLocation( oPC );
    int nRank;
    int nResult;

    if ( nJob == 71 ){

        //performer
        int nBusy = GetLocalInt( oPC, DS_J_BUSY );

        if ( GetIsBlocked() > 0 ){

            SendMessageToPC( oPC, CLR_ORANGE+"You need to perform 5 minutes after you started the performance." );
            return;
        }
        else if ( nBusy == 1 ){

            SendMessageToPC( oPC, CLR_ORANGE+"Performance ended." );

            DeleteLocalInt( oPC, DS_J_BUSY);
        }
        else{

            SendMessageToPC( oPC, CLR_ORANGE+"Performance started. Use Bard Song again to end it. You must wait at least 5 minutes." );

            SetLocalInt( oPC, DS_J_BUSY, 1 );

            SetBlockTime();

            return;
        }

        object oAudience = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lAnchor );

        while( GetIsObjectValid( oAudience ) ){

            //if ( GetIsPC( oAudience ) && oAudience != oPC ){

                if ( GetLocalInt( oAudience, DS_J_JOB+"_"+IntToString( nJob ) ) == 1 ){

                    SendMessageToPC( oAudience, CLR_ORANGE+"You only count as an XP worthy audience once a reset." );
                    SendMessageToPC( oPC, CLR_ORANGE+GetName( oAudience )+" already listened to a performance." );
                }
                else{

                    SendMessageToPC( oPC, CLR_ORANGE+"Checking "+GetName( oAudience )+"." );

                    //check if succesful and deal with XP
                    nResult = ds_j_StandardRoll( oPC, nJob );
                    nRank   = ds_j_GiveStandardXP( oPC, nJob, nResult, 1.0 );

                    //give fee
                    GiveGoldToCreature( oPC, d20( nResult + nRank ) );

                    //give audience a bit of XP
                    GiveCorrectedXP( oAudience, ( 10 * nRank ), "Job", 0 );

                    //block oAudience this session
                    SetLocalInt( oAudience, DS_J_JOB+"_"+IntToString( nJob ), 1 );
                }
            //}

            oAudience = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lAnchor );
        }
    }
}
