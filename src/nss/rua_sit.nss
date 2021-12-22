void main()
{
    ActionSit( GetNearestObjectByTag( "rua_chair" ) );

    DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( ), OBJECT_SELF ) );
}
