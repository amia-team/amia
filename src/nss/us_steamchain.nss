// OnUsed event of Cordor Bathhouse steam chain.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/01/2004 jpavelch         Initial release.
// 2009-11-14 disco            added oWP caching

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
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_FNF_DISPEL_GREATER),
            GetLocation(oWP)
        )
    );

    SetIsInactive( TRUE );
    DelayCommand( 60.0, SetIsInactive(FALSE) );
}
