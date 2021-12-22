//::///////////////////////////////////////////////
//:: NW_RECALL_PORTAL.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Starts conversation with last user
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

// 2007-03-10   disco   No convo above level 5
// 2007-03-12   disco   Added PreventPortToLeader support


void PortPC( object oPC, object oLeader );

void main(){

    object oPC     = GetLastUsedBy();

    if ( GetHitDice( oPC ) < 6 ){

        ActionStartConversation( oPC );
    }
    else{

        object oLeader = GetFactionLeader( oPC );

        if ( GetIsObjectValid( oLeader ) == TRUE ){

            PortPC( oPC, oLeader );
        }
    }
}

void PortPC( object oPC, object oLeader ){

    int nPrevent = GetLocalInt( GetArea( oLeader ), "PreventPortToLeader" );

    if ( nPrevent == TRUE ){

        int nDie = d10();

        if ( nDie < 6 ){

            SendMessageToPC( oPC, "Portal Failure: you cannot port into that area!" );
        }
        else if ( nDie < 9 ){

            object oDest = GetObjectByTag( "wp_misfire", Random( 20 ) );
            SendMessageToPC( oPC, "Portal Failure: you are ported to the wrong destination!" );
        }
        else {

            effect eHit   = EffectDamage( d8( GetHitDice( oPC ) ) );
            effect eVis   = EffectVisualEffect( VFX_FNF_BLINDDEAF );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

            DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eHit, oPC ) );

            AssignCommand( oPC, SpeakString( "Aiiieeeeiieee!!!!!" ) );

            SendMessageToPC( oPC, "Portal Failure: you are suffering some inter-planar backlash!" );
        }

    }
    else{

        AssignCommand( oPC, JumpToObject( oLeader ) );
    }
}
