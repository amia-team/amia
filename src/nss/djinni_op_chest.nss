// On Open event script for djinni chests.
//
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2/28/205 Mav                Initial Launch

// includes

#include "inc_ds_ondeath"

void main()
{
   object  oChest = OBJECT_SELF;

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

   switch(Random(3)+1)
   {
     case 1: CreateItemOnObject("djinniweapon",oChest); break;
     case 2: CreateItemOnObject("djinniwand",oChest); break;
     case 3: CreateItemOnObject("djinnibook",oChest); break;
   }


}
