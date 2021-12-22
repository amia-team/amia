/*  Blackguard's Aura of Despair Spell :: OnExit Aura.

    --------
    Verbatim
    --------
    This spellscript links from bg_despair script
    and will remove the creature's universal saving throw penalty
    when they exit the Blackguard's Aura of Despair.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    051506  Aleph       Initial release.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oCreature    = GetExitingObject( );
    object oPC          = GetAreaOfEffectCreator( );

    effect eEffects     = GetFirstEffect( oCreature );


    if( GetLocalInt( oCreature, "CS_BGD_STACKING_AOD" ) ){

        while( GetIsEffectValid( eEffects ) ){

            if( GetEffectType( eEffects ) == EFFECT_TYPE_SAVING_THROW_DECREASE ) {
                RemoveEffect( oCreature, eEffects );
                break;
            }
            eEffects = GetNextEffect( oCreature );
        }
    }

    DeleteLocalInt( oCreature, "CS_BGD_STACKING_AOD" );

    return;

}
