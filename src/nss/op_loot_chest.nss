// On Open event script for loot chests. Spawns certain loot depending on the variables
// defined on the chest. See onc_loot_chest for the other half of this script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/06/2013 PaladinOfSune    Initial release.
// 03/18/2014 msheeler         Added Radom Loot Level, Fix Random Loot amount

// includes
#include "inc_ds_ondeath"

void main()
{
    // Declare variables.
    object  oChest      = OBJECT_SELF;

    int     nLootLevel      = GetLocalInt( oChest, "LootLevel" );
    int     nFixedLoot      = GetLocalInt( oChest, "FixedLoot" );
    int     nRandomLoot     = GetLocalInt( oChest, "RandomLoot" );
    int     nRandomLevel    = GetLocalInt( oChest, "RandomLevel");

    int     nRandomAmount   = Random(nRandomLoot);
    int     i;

    // Don't do anything if there's already loot in this chest
    if( GetIsObjectValid( GetFirstItemInInventory( oChest ) ) )
    {
        return;
    }

    // Check if the chest is on cooldown
    if( GetLocalInt( oChest, "Blocker" ) )
    {
        return;
    }
    // If random loot level determine CR
    if ( nRandomLevel > 0 )
    {
        nLootLevel = Random(nRandomLevel) + 1; }

    // Initialize the chest so it can work properly with the loot system
    if( !GetLocalInt( oChest, "CR" ) )
    {
        if( nLootLevel == 0 || nLootLevel > 5 )
        {
            SpeakString( "OOC Warning: this chest is not initialized properly. Please report this on the forums!", TALKVOLUME_WHISPER );
        }
        else if( nLootLevel == 1 )
        {
            SetLocalInt( oChest, "CR", 1 );
        }
        else if( nLootLevel == 2 )
        {
            SetLocalInt( oChest, "CR", 9 );
        }
        else if( nLootLevel == 3 )
        {
            SetLocalInt( oChest, "CR", 17 );
        }
        else if( nLootLevel == 4 )
        {
            SetLocalInt( oChest, "CR", 26 );
        }
        else if( nLootLevel == 5 )
        {
            SetLocalInt( oChest, "CR", 41 );
        }
    }

    // Spawn a fixed amount of loot
    if( nFixedLoot > 0 )
    {
        for ( i = 0; i < nFixedLoot; i++ )
        {
            GenerateLoot( oChest, 1, 1 );
        }
    }

    // Spawn a random amount of loot
    if( nRandomLoot > 0 )
    {
        for ( i = 0; i < nRandomAmount; i++ )
        {
            GenerateLoot( oChest, 1, 1 );
        }
    }
}

