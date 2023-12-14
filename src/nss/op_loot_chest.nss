// On Open event script for loot chests. Spawns certain loot depending on the variables
// defined on the chest. See onc_loot_chest for the other half of this script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/06/2013 PaladinOfSune    Initial release.
// 03/18/2014 msheeler         Added Radom Loot Level, Fix Random Loot amount
// 12/7/2023 Mav               I reworked this to pull from just the loot table, NO RANDOM LOOT.

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

    // If random loot level isnt set, use nLootLevel
    if(nRandomLevel==0)
    {
     nRandomLevel=nLootLevel;
    }
    // If random loot level determine CR
    if ( nRandomLevel > 0 )
    {
      nRandomLevel = Random(nRandomLevel) + 1;
    }

    // Spawn a fixed amount of loot
    if( nFixedLoot > 0 )
    {
        for ( i = 0; i < nFixedLoot; i++ )
        {
            GenerateStandardLoot(oChest,nLootLevel);
        }
    }

    // Spawn a random amount of loot
    if( nRandomLoot > 0 )
    {
        for ( i = 0; i < nRandomAmount; i++ )
        {
            GenerateStandardLoot(oChest,nRandomLevel);
        }
    }
}

