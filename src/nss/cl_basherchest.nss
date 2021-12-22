// OnClose event of the Basher chest.  It will create a new orc key in its
// inventory five minutes after closing.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/03/2004 jpavelch         Initial Release.
//


// Returns TRUE if the chest is currently creating a key.
//
int GetIsCreatingKey( object oChest )
{
    return GetLocalInt( oChest, "CreatingKey" );
}

// Sets whether or not the chest is currently creating a key.
//
void SetIsCreatingKey( object oChest, int isCreatingKey )
{
    SetLocalInt( oChest, "CreatingKey", isCreatingKey );
}

// Creates a key in this chest.
//
void CreateKey( object oChest )
{
    object oKey = GetItemPossessedBy( oChest, "OrcPass" );
    if ( !GetIsObjectValid(oKey) )
        CreateItemOnObject( "orckey", oChest );

    SetIsCreatingKey( oChest, FALSE );
}


void main( )
{
    object oChest = OBJECT_SELF;

    if ( GetIsCreatingKey(oChest) ) return;

    object oKey = GetItemPossessedBy( oChest, "OrcPass" );
    if ( !GetIsObjectValid(oKey) ) {
        SetIsCreatingKey( oChest, TRUE );
        DelayCommand( 300.0, CreateKey(oChest) );   // Five Minutes
    }
}
