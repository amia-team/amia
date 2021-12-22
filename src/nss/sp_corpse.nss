// Spawns in dead with persistant body but no invis corpse object.

void KillSelf( )
{
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectDeath(),
        OBJECT_SELF
    );
}

void main( )
{
    SetIsDestroyable( FALSE, FALSE, TRUE );
    DelayCommand( 1.0, KillSelf() );
}
