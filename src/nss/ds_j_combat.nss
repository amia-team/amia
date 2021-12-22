//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_combat
//group:   Jobs & crafting
//used as: OnCombatRoundEnd NPC event script
//date:    january 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_j_lib"

void ds_j_DispenseLoot( object oPC, object oTarget, int nJob, int nRank, int nResult ){

    int nDrop;

    if ( nResult < 1 ){

        return;
    }
    else if ( nResult == 1 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You kill your enemy!"+CLR_END );
    }
    else{

        nDrop = 1;

        CreateItemOnObject( "nw_it_gold001", oTarget, ( d20( nRank * 10 ) ) );

        SendMessageToPC( oPC, CLR_RED+"[debug: Generating "+IntToString( ( d20( nRank * 10 ) ) )+" GP]"+CLR_END );
        SendMessageToPC( oPC, CLR_RED+"[debug: Job="+IntToString( nJob )+"]"+CLR_END );
    }

    //some jobs get a fee
    if ( nJob == 41 || nJob == 37 || nJob == 45 ){

        SendMessageToPC( oPC, CLR_ORANGE+"Your fee for slaying this target:"+CLR_END );

        GiveGoldToCreature( oPC, d100() + ( 250 * nRank * nResult ) );
    }
    else if ( nJob == 38 ){

        SendMessageToPC( oPC, CLR_ORANGE+"you find a fat wallet on the dead body"+CLR_END );

        GiveGoldToCreature( oPC, d100() + ( 250 * nRank * nResult ) );
    }
    else {

        int nResource = GetLocalInt( oTarget, DS_J_RESOURCE );

        if ( nResource ){

            SendMessageToPC( oPC, CLR_RED+"[debug: Generating item #"+IntToString( nResource )+"]"+CLR_END );
            SendMessageToPC( oPC, CLR_RED+"[debug: Job="+IntToString( nJob )+"]"+CLR_END );
            nDrop = 1;

            string sQuery = "SELECT name, resref, icon FROM ds_j_resources WHERE id = '"+IntToString( nResource )+"'";

            SQLExecDirect( sQuery );

            if ( SQLFetch( ) == SQL_SUCCESS ){

                string sName   = SQLDecodeSpecialChars( SQLGetData( 1 ) );
                string sResRef = SQLGetData( 2 );
                int nIcon      = StringToInt( SQLGetData( 3 ) );
                //string sTag    = DS_J_RESOURCE_PREFIX + IntToString( nResource );
                object oItem   = ds_j_CreateItemOnPC( oPC, sResRef, nResource, sName, "", nIcon );

                //SetDroppableFlag( oItem, TRUE );
                SendMessageToPC( oPC, CLR_RED+"[debug: ResRef="+sResRef+"]"+CLR_END );
                SendMessageToPC( oPC, CLR_RED+"[debug: Icon="+IntToString( nIcon )+"]"+CLR_END );
                SendMessageToPC( oPC, CLR_RED+"[debug: Item="+GetName( oItem )+"]"+CLR_END );
            }
        }
    }

    if ( nDrop ){

        SendMessageToPC( oPC, CLR_ORANGE+"Your vanguished enemy drops something!"+CLR_END );
    }
}

void ds_j_FinishTarget( object oPC, object oTarget, int nJob ){

    //target processed
    DeleteLocalString( oPC, DS_J_NPC );

    //check if the find is succesful and deal with XP
    int nResult     = ds_j_StandardRoll( oPC, nJob );
    int nRank       = ds_j_GiveStandardXP( oPC, nJob, nResult, 2.0, 5.0 );

    //check type of critter
    string sTag     = GetTag( oTarget );

    if ( nResult <= 0 ){

        if ( sTag == DS_J_NPC ){

            ActionPlayAnimation( ANIMATION_FIREFORGET_GREETING );

            SendMessageToPC( oPC, CLR_ORANGE+"Your target makes an obscure sign with two fingers and vanishes in thin air..."+CLR_END );

            SpeakString( "Ciao, loser!" );
        }
        else{

            SendMessageToPC( oPC, CLR_ORANGE+"Your target manages to escape..."+CLR_END );
        }

        log_to_exploits( oPC, "ds_j: escapes "+GetTag( oTarget ), GetResRef( GetArea( oPC ) ), nJob );

        SafeDestroyObject( oTarget );

        return;
    }

    log_to_exploits( oPC, "ds_j: killed NPC ("+GetTag( oTarget )+")", GetResRef( GetArea( oPC ) ), nJob );

    effect eVFX = EffectVisualEffect( VFX_COM_CHUNK_RED_SMALL );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );

    //AssignCommand( oPC,
    ds_j_DispenseLoot( oPC, oTarget, nJob, nRank, nResult );

    //finish the target
    SetImmortal( oTarget, FALSE );
    SetPlotFlag( oTarget, FALSE );
    PlayVoiceChat( VOICE_CHAT_DEATH, oTarget );
    KillPC( oTarget );
}


void main(){

    object oPC          = GetLastHostileActor();
    object oNPC         = OBJECT_SELF;
    string sKey         = GetPCPublicCDKey( oPC, TRUE );
    string sLocalKey    = GetLocalString( oNPC, DS_J_USER );

    //not a target NPC
    if ( GetLocalInt( oNPC, "ds_j_nocombat" ) && !GetIsPC( oPC ) ){

        //remove spawn block on oUser
        string sTag  = GetTag( oNPC );
        object oUser = GetLocalObject( oNPC, DS_J_USER );
        SetLocalInt( oPC, sTag, ( GetLocalInt( oPC, sTag ) - 1 ) );

        //set new time
        effect eGore = EffectVisualEffect( VFX_COM_CHUNK_RED_LARGE );

        ApplyEffectToObject ( DURATION_TYPE_INSTANT, eGore, oNPC );

        DestroyObject( oNPC, 0.5 );
        return;
    }

    //stop if this isn't the proper PC
    if ( sKey != sLocalKey ){

        AssignCommand( oPC, ClearAllActions( TRUE ) );
        return;
    }

    if ( GetPlotFlag( oNPC ) ){

        return;
    }

    SetPlotFlag( oNPC, TRUE );

    ActionAttack( oPC );

    int nJob    = GetLocalInt( oNPC, DS_J_JOB );

    //stop if this isn't the proper Job
    //Men-at-arms, Archer, Mercenary, Outlaw, Vigilante, Templar, Hired Killer
    //Undead Hunter, Tunnel Fighter, Big Game Hunter, 5x reserved
    if ( nJob < 35 || nJob > 50 || nJob == 43 ){

        SafeDestroyObject( oNPC );
    }
    else{

        DelayCommand( 5.0, ds_j_FinishTarget( oPC, oNPC, nJob ) );
    }
}
