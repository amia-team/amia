void main()
{
    object oPC = GetPCSpeaker( );

    object oBook = GetItemPossessedBy( oPC, "templequestbook" );
    DestroyObject( oBook );
}
