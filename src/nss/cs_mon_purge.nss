/*  Amia :: Corpse :: OnClose :: Purge [Self]

    --------
    Verbatim
    --------
    This scriptfile purges itself, monster corpse.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080906  kfw         Initial Release.
    081006  kfw         Bugfix, not despawning.
    ----------------------------------------------------------------------------

*/


/* Constants. */
const string MONSTER_LOOTCORPSE     = "lootcorpse";


void main( ){

    // Variables.
    object oMonsterCorpse       = OBJECT_SELF;
    object oMonster             = GetLocalObject( oMonsterCorpse, MONSTER_LOOTCORPSE );

    // Not item(s) left in the lootable corpse, purge it, as well as the monster itself.
    if( !GetIsObjectValid( GetFirstItemInInventory( oMonsterCorpse ) ) ){
        // Purge monster.
        AssignCommand( oMonster, SetIsDestroyable( TRUE, FALSE ) );
        DestroyObject( oMonster );
        // Purge corpse.
        AssignCommand( oMonsterCorpse, SetIsDestroyable( TRUE, FALSE ) );
        DestroyObject( oMonsterCorpse );
    }

    return;

}
