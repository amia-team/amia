// Darkhold :: Intro Tome - Player interface to read the tome contents

void main( ){

    // Variables
    object oTome        = OBJECT_SELF;
    object oPC          = GetLastUsedBy( );

    // Action :: Read Tome
    AssignCommand( oPC, ActionExamine( oTome ) );

    return;

}
