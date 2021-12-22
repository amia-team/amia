// Automatic Loot Generation [30 minute respawn] :: Forgotten Library

/* Function Prototypes */

// Create nItemQuantity pieces of loot
void CreateXLoot( object oDest, string szItemResRef, int nItemQuantity );

// Actual Loot Creator
void CreateLoot( object oDest, string szItemResRef );

void main(){

    // Variables
    object oBookShelf       =   OBJECT_SELF;
    object oPC              =   GetLastOpenedBy( );
    string szItemResRef     =   "";
    int nItemQuantity       =   1;

    // Resolve Opener Status
    if( !GetIsPC( oPC ) )
        return;

    // Unspawned
    if( !GetLocalInt( oBookShelf, "spawned" ) ){

        // Refresh Respawn Status
        SetLocalInt( oBookShelf, "spawned", 1 );

        DelayCommand( 1800.0, SetLocalInt( oBookShelf, "spawned", 0 ) );

        // Randomize Loot on a D6 dice
        switch( d8( 1 ) ){

            // Scroll of Minor Invulnerability
            case 1:{
                // szItemResRef    = "x2_it_cfm_bscrl";  // Blanks removed
                szItemResRef    = "nw_it_sparscr401";
                break;
            }
            // Bone Wands
            case 2:{
                szItemResRef    = "x2_it_cfm_wand";
                nItemQuantity   = 2;
                break;
            }
            // Scroll of Protection from Alignment
            case 3:{
                szItemResRef    = "x2_it_sparscral";
                nItemQuantity   = 3;
                break;
            }
            // Scroll of Raise Dead
            case 4:{
                szItemResRef    = "it_spdvscr502";
                break;
            }
            // Scroll of Scintillating Sphere
            case 5:{
                szItemResRef    = "x2_it_sparscr302";
                break;
            }
            // Scroll of Slow
            case 6:{
                szItemResRef    = "nw_it_sparscr313";
                break;
            }
            // Scroll of Black Staff
            case 7:{
                szItemResRef    = "x2_it_sparscr801";
                break;
            }
            // Scroll of Mordenkainen's Disjunction
            case 8:{
                szItemResRef    = "nw_it_sparscr901";
                break;
            }
            // Error
            default:{
                szItemResRef    = "";
                break;
            }

        }

        // Candy
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_PIXIEDUST ), oBookShelf, 6.0 );

        CreateXLoot( oBookShelf, szItemResRef, nItemQuantity );

    }

    return;

}

/* Function Definitions */

// Create nItemQuantity pieces of loot
void CreateXLoot( object oDest, string szItemResRef, int nItemQuantity ){

    // Variables
    int nCounter    = 0;
    float fDelay    = 0.0;

    for( nCounter; nCounter < nItemQuantity; nCounter++ ){

        DelayCommand( fDelay, CreateLoot( oDest, szItemResRef ) );

        fDelay += 0.1;

    }

    return;

}

// Actual Loot Creator
void CreateLoot( object oDest, string szItemResRef ){

    CreateItemOnObject( szItemResRef, oDest, 1 );

    return;

}
