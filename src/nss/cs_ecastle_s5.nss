// Electric Castle :: Spawn gate key

void main( ){

    // Variables
    object oPC              = GetPCSpeaker( );

    // Zip through each color
    if( GetLocalInt( oPC, "cor_bluespark" ) )
        if( GetLocalInt( oPC, "cor_cyanspark" ) )
            if( GetLocalInt( oPC, "cor_greenspark" ) )
                if( GetLocalInt( oPC, "cor_orangespark" ) )
                    if( GetLocalInt( oPC, "cor_redspark" ) )
                        if( GetLocalInt( oPC, "cor_whitespark" ) )
                            if( GetLocalInt( oPC, "cor_yellowspark" ) ){

                                // Remove sparks, and their corresponding indicators
                                DestroyObject( GetItemPossessedBy( oPC, "cor_bluespark" ) );
                                SetLocalInt( oPC, "cor_bluespark", 0 );
                                DestroyObject( GetItemPossessedBy( oPC, "cor_cyanspark" ) );
                                SetLocalInt( oPC, "cor_cyanspark", 0 );
                                DestroyObject( GetItemPossessedBy( oPC, "cor_greenspark" ) );
                                SetLocalInt( oPC, "cor_greenspark", 0 );
                                DestroyObject( GetItemPossessedBy( oPC, "cor_orangespark" ) );
                                SetLocalInt( oPC, "cor_orangespark", 0 );
                                DestroyObject( GetItemPossessedBy( oPC, "cor_redspark" ) );
                                SetLocalInt( oPC, "cor_redspark", 0 );
                                DestroyObject( GetItemPossessedBy( oPC, "cor_whitespark" ) );
                                SetLocalInt( oPC, "cor_whitespark", 0 );
                                DestroyObject( GetItemPossessedBy( oPC, "cor_yellowspark" ) );
                                SetLocalInt( oPC, "cor_yellowspark", 0 );

                                // Spawn the gate key.
                                CreateItemOnObject( "cor_ecmainkey", oPC );

                                // Candy
                                ApplyEffectToObject(
                                                    DURATION_TYPE_INSTANT,
                                                    EffectVisualEffect( VFX_FNF_ELECTRIC_EXPLOSION ),
                                                    oPC );

                            }

    return;

}
