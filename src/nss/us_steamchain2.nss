// OnUsed event of Cordor Bathhouse steam chain.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/01/2004 jpavelch         Initial release.
// 2009-11-14 disco            added oWP caching
// 2012-02-28 Mathias          Changed effect to VFX_PER_FOGBEWILDERMENT

float   fDuration   = 30.0; // duration of the steam effect
effect  eSteam      = EffectAreaOfEffect(AOE_PER_FOG_OF_BEWILDERMENT, "****", "****", "****");
void SetIsInactive( int state )
{
    object oChain = OBJECT_SELF;
    SetLocalInt( oChain, "AR_IsInactive", state );
}

int GetIsInactive( )
{
    object oChain = OBJECT_SELF;
    return ( GetLocalInt(oChain, "AR_IsInactive") == TRUE );
}


void main( )
{
    object oChain = OBJECT_SELF;

    if ( GetIsInactive() )
        return;

    PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );
    PlaySound( "as_na_steamlong2" );
    DelayCommand( 6.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE) );

    object oWP = GetLocalObject( OBJECT_SELF, "wp" );

    if ( oWP == OBJECT_INVALID ){

        oWP = GetNearestObjectByTag( "wp_saunasteam" );
        SetLocalObject( OBJECT_SELF, "wp", oWP );
    }

    DelayCommand(
        3.0,
        ApplyEffectAtLocation(
            DURATION_TYPE_TEMPORARY,
            eSteam,
            GetLocation(oWP),
            fDuration
        )
    );

    SetIsInactive( TRUE );
    DelayCommand( fDuration, SetIsInactive(FALSE) );
}
