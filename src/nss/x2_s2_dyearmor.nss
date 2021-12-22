//:: Dye Item Spellscript
//:: x2_s2_dyearmor
//:: stripped for 1.69, Disco

#include "x2_inc_itemprop"

void main(){

    // declare major variables
    object oItem   = GetSpellCastItem();                  // The "dye" item that cast the spell
    object oPC     = OBJECT_SELF;                         // the user of the item

    //remove old pots
    DestroyObject( oItem );


    SendMessageToPC( oPC, "Dye pots can no longer be used in Amia. Your can use the crafting menu to apply them for free." );
}


