/*  Amia :: Monster :: Despawn

    --------
    Verbatim
    --------
    This scriptfile executes periodically, to purge the monster caller.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080806  kfw         Initial Release.
    021607  kfw         Line 55: Added check in for PC masters (repoll for despawn).
    033107  kfw         Adjusted despawn timers.
    ----------------------------------------------------------------------------

*/


/* Constants. */
const string MONSTER_LOOTCORPSE     = "lootcorpse";
const string MONSTER_LOOTABLE       = "lootable";
const float LOOT_DESPAWN_TIME       = 600.0;    // 10 minutes.
const float MONSTER_DESPAWN_TIME    = 300.0;    // 5 minutes.
const string DESPAWN_SCRIPT         = "cs_monstr_despwn";
const string MONSTER_TAG            = "CS_DSPWN";


/* Prototype Declarations. */

// This function removes any item's from the designated lootable corpse.
void PurgeLootableCorpse( object oLootableCorpse );


void main( ){

    // Variables.
    object oMonster         = OBJECT_SELF;
    string szTag            = GetTag( oMonster );
    int nDead               = GetIsDead( oMonster );
    int nCombat             = GetIsInCombat( );


    // Non-spawn, exit immediately.
    if( GetLocalInt( oMonster, MONSTER_TAG ) != 1  ){

        return;
    }

    // Verify status.

    // Not dead, but in combat, or belonging to a player master atm :: check again in another MONSTER_DESPAWN_TIME minutes.
    if( ( !nDead && nCombat ) || GetIsPC( GetMaster( ) ) ){

        DelayCommand( MONSTER_DESPAWN_TIME, ExecuteScript( DESPAWN_SCRIPT, oMonster ) );
    }
    else{

        // Variables.
        object oLootableCorpse      = OBJECT_INVALID;
        int nLootable               = GetLocalInt( oMonster, MONSTER_LOOTABLE );

        // Purge looting corpse in 5 minutes time.
        if( nDead && nLootable ){

            // Variables.
            oLootableCorpse         = GetLocalObject( oMonster, MONSTER_LOOTCORPSE );

            // Purge corpse.
            DelayCommand( LOOT_DESPAWN_TIME - 2.0, PurgeLootableCorpse( oLootableCorpse ) );
            DelayCommand( LOOT_DESPAWN_TIME - 1.0, AssignCommand( oLootableCorpse, SetIsDestroyable( TRUE, FALSE ) ) );
            DestroyObject( oLootableCorpse, LOOT_DESPAWN_TIME );
            // Purge monster.
            DelayCommand( LOOT_DESPAWN_TIME, AssignCommand( oMonster, SetIsDestroyable( TRUE, FALSE ) ) );
            DestroyObject( oMonster, LOOT_DESPAWN_TIME + 1.0 );

        }

        // Non-looting, but purge monster corpse.
        else{

            // Purge the monster corpse.
            AssignCommand( oMonster, SetIsDestroyable( TRUE, FALSE ) );
            DestroyObject( oMonster );

        }

    }

    return;

}


/* Prototype Definitions. */

// This function removes any item's from the designated lootable corpse.
void PurgeLootableCorpse( object oLootableCorpse ){

    // Variables.
    object oItem        = GetFirstItemInInventory( oLootableCorpse );

    // Cycle the Monster's inventory and purge it.
    while( GetIsObjectValid( oItem ) ){
        // Purge.
        DestroyObject( oItem );
        // Get next.
        oItem           = GetNextItemInInventory( oLootableCorpse );
    }

    return;

}
