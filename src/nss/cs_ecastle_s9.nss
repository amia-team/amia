// Electric Castle :: Sanity Check, Removes sparks.

void main( ){

    // Variables
    object oPC          = GetEnteringObject( );

    // Dix door and gate keys
    if( GetIsObjectValid( oPC ) ){

        // Sparks
        DestroyObject( GetItemPossessedBy( oPC, "cor_bluespark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_cyanspark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_greenspark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_orangespark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_redspark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_whitespark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_yellowspark" ) );

    }

    return;

}
