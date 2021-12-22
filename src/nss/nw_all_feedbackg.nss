//::///////////////////////////////////////////////
//:: nw_all_feedbackg
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Transports you to the party leader.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:
//:://////////////////////////////////////////////


// 2007-03-12   disco   Added PreventPortToLeader support

void PortPC( object oPC, object oLeader );

void main(){

    object oLeader = GetFactionLeader( GetPCSpeaker() );

    if ( GetIsObjectValid( oLeader ) == TRUE ){

        PortPC( GetPCSpeaker(), oLeader );
    }
}

void PortPC( object oPC, object oLeader ){

    int nPrevent = GetLocalInt( GetArea( oLeader ), "PreventPortToLeader" );

    if ( nPrevent == TRUE ){

        int nDie = d10();

        if ( nDie < 6 ){

            SendMessageToPC( oPC, "Portal Failure: you cannot port into that area!" );
            DestroyObject( OBJECT_SELF );
        }
        else if ( nDie < 9 ){

            object oDest = GetObjectByTag( "wp_misfire", Random( 20 ) );
            SendMessageToPC( oPC, "Portal Failure: you are ported to the wrong destination!" );
        }
        else {

            effect eHit   = EffectDamage( d8( GetHitDice( oPC ) ) );
            effect eVis   = EffectVisualEffect( VFX_FNF_BLINDDEAF );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

            DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eHit, oPC ) );

            AssignCommand( oPC, SpeakString( "Aiiieeeeiieee!!!!!" ) );

            SendMessageToPC( oPC, "Portal Failure: you are suffering some inter-planar backlash!" );
        }

    }
    else{

        AssignCommand( oPC, JumpToObject( oLeader ) );
    }
}
