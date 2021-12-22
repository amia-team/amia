// On Close event script for loot chests. Handles the time limit before it may be
// looted again.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/06/2013 PaladinOfSune    Initial release.
//


void main()
{
    // Declare variables,
    object  oChest      = OBJECT_SELF;
    float   fTimeLimit  = GetLocalFloat( oChest, "TimeLimit" );

    // If a time limit hasn't been defined, we give it a default one here.
    if( fTimeLimit == 0.0 )
    {
        fTimeLimit = 1200.0;
    }

    // If everything's been looted, give it a cooldown.
    if( !GetIsObjectValid( GetFirstItemInInventory( oChest ) ) )
    {
        if( !GetLocalInt( oChest, "Blocker" ) )
        {
            SetLocalInt( oChest, "Blocker", 1 );
            DelayCommand( fTimeLimit, DeleteLocalInt( oChest, "Blocker" ) );
        }
    }
}
