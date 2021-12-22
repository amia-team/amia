/*

OnExit script for the Graveyard Sludge to remove beneficial aura effects from
friendly targets that exit.

*/

void main()
{
    object oCritter = GetAreaOfEffectCreator( OBJECT_SELF );
    object oTarget = GetExitingObject();

    if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD && !GetIsEnemy( oTarget, oCritter ) && !GetIsDead( oTarget ) )
    {
        effect eRemove = GetFirstEffect( oTarget );
        while( GetIsEffectValid( eRemove ) )
        {
            if( GetEffectCreator( eRemove ) == oCritter )
            {
                RemoveEffect( oTarget, eRemove );
            }
            eRemove = GetNextEffect( oTarget );
        }
    }
}
