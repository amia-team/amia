// Electric Castle :: Lightning portal, teleports and removes door and gate key

void main( ){

    // Variables
    object oPC          = GetEnteringObject( );
    object oDest        = GetWaypointByTag( "wp_cor_end" );
    location lDest      = GetLocation( oDest );

    // Dix door and gate keys
    if( GetIsObjectValid( oDest ) ){

        // Sparks
        DestroyObject( GetItemPossessedBy( oPC, "cor_bluespark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_cyanspark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_greenspark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_orangespark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_redspark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_whitespark" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_yellowspark" ) );
        // Doors
        DestroyObject( GetItemPossessedBy( oPC, "cor_eckeyevil" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_eckeygood" ) );
        DestroyObject( GetItemPossessedBy( oPC, "cor_eckeyneutral" ) );
        // Gate
        DestroyObject( GetItemPossessedBy( oPC, "cor_ecmainkey" ) );

        // Teleport
        AssignCommand( oPC, JumpToLocation( lDest ) );

        // Candy
        ApplyEffectToObject(
                            DURATION_TYPE_INSTANT,
                            EffectVisualEffect( VFX_FNF_SUMMON_MONSTER_1 ),
                            oPC );

    }

    return;

}
