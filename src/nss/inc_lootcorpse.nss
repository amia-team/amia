// Include file for creature corpses.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/01/2003 jpavelch         Initial Release.
// 11/25/2003 jpavelch         All items in non-slot inventory now drop.
// 20050214   jking            Refactored
// 20030410   jking            Instead of destroying inventory items we now
//                             mark them SetDroppable(FALSE) because the
//                             object destroys may be causing crashes.  Plus
//                             write a log entry when gold is taken.
//
#include "inc_userdefconst"
#include "logger"

const string LOOTCORPSE_HOST_BODY_VAR = "HostBody";
const string LOOTCORPSE_RESREF        = "lootcorpse";
const string LOOTCORPSE_DECAY                = "LootCorpseDecay";
const int    LOOTCORPSE_DECAY_DEFAULT        = 300;


int GetDefaultModuleInt(string sVarName, int iDefault)
{
    int iVal = GetLocalInt(GetModule(), sVarName);
    if (!iVal) iVal = iDefault;
    return iVal;
}


// Creates a loot corpse if the creature has any inventory items.  Destroys
// all equipped items to take care of memory leaks due to creature items
// not properly being destroyed by the NWN engine.
//
void LootCheckInventory( object oCreature );

// Creates a loot corpse if the creature has any inventory items.  Destroys
// all equipped items to take care of memory leaks due to creature items
// not properly being destroyed by the NWN engine.
//
void CreateLootableCorpse( object oCreature = OBJECT_SELF );

// Destroys host body and self, including all remaining inventory items.
//
void DestroyLootableCorpse( object oCorpse = OBJECT_SELF );

//
// Implementation
//

// Creates a loot corpse if the creature has any inventory items.  Destroys
// all equipped items to take care of memory leaks due to creature items
// not properly being destroyed by the NWN engine.
//
void LootCheckInventory( object oCreature )
{
    int i;
    object oItem;

    for ( i=0; i < NUM_INVENTORY_SLOTS; ++i ) {
        oItem = GetItemInSlot( i, oCreature );
        if ( GetIsObjectValid(oItem) )
            SetDroppableFlag(oItem, FALSE);
    }

    oItem = GetFirstItemInInventory( oCreature );
    if ( GetIsObjectValid(oItem) ) {
        AssignCommand( oCreature, SetIsDestroyable(FALSE, FALSE, FALSE) );
        object oCorpse = CreateObject(
                             OBJECT_TYPE_PLACEABLE,
                             LOOTCORPSE_RESREF,
                             GetLocation(oCreature)
                         );
        SetLocalObject( oCorpse, LOOTCORPSE_HOST_BODY_VAR, oCreature );

        while ( GetIsObjectValid(oItem) ) {

            string szTag = GetTag( oItem );
            // Prevent DM tools dropping.
            if( GetSubString( szTag, 0, 4 ) == "dmfi" )
                DestroyObject( oItem );
            else
                AssignCommand( oCorpse, ActionTakeItem(oItem, oCreature) );

            oItem = GetNextItemInInventory( oCreature );
        }

        float fDecay = IntToFloat(GetDefaultModuleInt(LOOTCORPSE_DECAY, LOOTCORPSE_DECAY_DEFAULT));
        DelayCommand( fDecay, SignalEvent(oCorpse, EventUserDefined(CORPSE_DESTROY)) );

    } else {
        AssignCommand( oCreature, SetIsDestroyable(TRUE, FALSE, FALSE) );
        // Bioware engine will destroy the creature
    }
}

//
void CreateLootableCorpse( object oCreature )
{
    int nAmtGold = GetGold( oCreature );
    if ( nAmtGold > 0 ) {
        LogWarn("inc_lootcorpse", "OnDeath processing is removing " +
                                 IntToString(nAmtGold) + " from " +
                                 GetName(oCreature) + " [" + GetTag(oCreature) + "]");
        AssignCommand( oCreature, TakeGoldFromCreature(nAmtGold, oCreature, TRUE) );
    }

    LootCheckInventory( oCreature );
}

// Destroys host body and self, including all remaining inventory items.
//
void DestroyLootableCorpse( object oCorpse )
{
    if (!GetIsObjectValid(oCorpse))
        return;

    object oItem = GetFirstItemInInventory( oCorpse );
    while ( GetIsObjectValid(oItem) ) {
        SetDroppableFlag(oItem, FALSE);
        oItem = GetNextItemInInventory( oCorpse );
    }

    object oHost = GetLocalObject( oCorpse, LOOTCORPSE_HOST_BODY_VAR );
    DestroyObject( oCorpse );

    if (GetIsObjectValid(oHost)) {
        AssignCommand( oHost, SetIsDestroyable(TRUE, FALSE, FALSE) );
        DestroyObject( oHost );
    }
}


