/*  Blackguard's Aura of Despair Spell :: OnEnter Aura.

    --------
    Verbatim
    --------
    This spellscript links from bg_despair script
    and will reduce any hostile creature's universal saving throws by 2
    when they enter the Blackguard's Aura of Despair.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    051506  Aleph       Initial release.
    070713  PoS         Removed visual.
    ----------------------------------------------------------------------------

*/


void main(){

    // Variables.
    object oCreature        = GetEnteringObject( );
    object oPC              = GetAreaOfEffectCreator( );

    // Prevent stacking.
    if( GetLocalInt( oCreature, "CS_BGD_STACKING_AOD" ) )
        return;
    else
        SetLocalInt( oCreature, "CS_BGD_STACKING_AOD", 1 );

    // Creature is hostile to the Blackguard.
    if( GetIsEnemy( oCreature, oPC ) ){

        // Apply saving throw curse.
        ApplyEffectToObject(    DURATION_TYPE_PERMANENT, EffectSavingThrowDecrease( SAVING_THROW_ALL, 2 ),
                                oCreature );

    }

    return;

}

