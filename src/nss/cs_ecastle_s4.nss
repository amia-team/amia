// Electric Castle :: Check the PC has 7 unique color keys

void main( ){

    // Variables
    object oPC              = GetPCSpeaker( );

    /* Check each color is present */

    // Blue
    if( GetIsObjectValid( GetItemPossessedBy( oPC, "cor_bluespark" ) ) )
        SetLocalInt( oPC, "cor_bluespark", 1 );
    // Cyan
    if( GetIsObjectValid( GetItemPossessedBy( oPC, "cor_cyanspark" ) ) )
        SetLocalInt( oPC, "cor_cyanspark", 1 );
    // Green
    if( GetIsObjectValid( GetItemPossessedBy( oPC, "cor_greenspark" ) ) )
        SetLocalInt( oPC, "cor_greenspark", 1 );
    // Orange
    if( GetIsObjectValid( GetItemPossessedBy( oPC, "cor_orangespark" ) ) )
        SetLocalInt( oPC, "cor_orangespark", 1 );
    // Red
    if( GetIsObjectValid( GetItemPossessedBy( oPC, "cor_redspark" ) ) )
        SetLocalInt( oPC, "cor_redspark", 1 );
    // White
    if( GetIsObjectValid( GetItemPossessedBy( oPC, "cor_whitespark" ) ) )
        SetLocalInt( oPC, "cor_whitespark", 1 );
    // Yellow
    if( GetIsObjectValid( GetItemPossessedBy( oPC, "cor_yellowspark" ) ) )
        SetLocalInt( oPC, "cor_yellowspark", 1 );

    return;

}
