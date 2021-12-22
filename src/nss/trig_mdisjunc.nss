// Babylon's Chambers:: Cast Mordenkainen's Disjunction onTriggerEnter

void main( ){

    // Variables
    object oTrigger         = OBJECT_SELF;
    object oPC              = GetEnteringObject( );
    location lLoc           = GetLocation( oPC );
    object oCaster          = GetNearestObject( OBJECT_TYPE_ALL, oTrigger, 1 );

    if( !GetIsPC( oPC ) )
        return;

    // Make the trigger cast Mordenkainen's Disjunction on the entering PC
    AssignCommand( oCaster, ActionCastSpellAtLocation(
                                SPELL_MORDENKAINENS_DISJUNCTION,
                                lLoc,
                                METAMAGIC_ANY,
                                TRUE,
                                PROJECTILE_PATH_TYPE_DEFAULT,
                                TRUE ) );

    return;

}
