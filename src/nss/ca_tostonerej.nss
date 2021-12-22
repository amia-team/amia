// Converation action to port a goody-two-shoes PC to the Abyss from
// Stonehold.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/04/2004 jpavelch         Initial release.
//


void JumpToAbyss( object oPC )
{
    object oDest = GetObjectByTag( "wp_stonerej" );

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, ActionJumpToLocation(GetLocation(oDest)) );

    SetCommandable( TRUE, oPC );
}

void main( )
{
    object oDemon = OBJECT_SELF;
    object oPC = GetPCSpeaker( );

//    PlaySound( "vs_nx2mephm_warn" );
//    PlayVoiceChat( VOICE_CHAT_LAUGH );

    SetCommandable( FALSE, oPC );

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_SUMMON_GATE),
        GetLocation(oPC)
    );
    DelayCommand( 3.5, JumpToAbyss(oPC) );
}
