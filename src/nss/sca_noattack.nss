void main()
{
    object oCaster = GetLastSpellCaster( );

    SetIsTemporaryFriend( oCaster, OBJECT_SELF, FALSE, 0.01 );
    DelayCommand( 0.01, SetIsTemporaryEnemy(oCaster) );
}
