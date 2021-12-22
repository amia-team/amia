//::///////////////////////////////////////////////
//:: x2_inc_compon
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    This include file has routines to handle the
    distribution of components requried for the
    XP2 crafting system.

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  July 30, 2003
//:://////////////////////////////////////////////
const int MIN_SKILL_LEVEL = 15;

#include "logger"

// * Drops craft items if killed or bashed
void craft_drop_items(object oSlayer);
// * handles dropping crafting items if a placeable is bashed
void craft_drop_placeable();


void craft_drop_items(object oSlayer){

    //this function seems to be triggered now and then...
    return;

    // * only drop components if the player has some decent skill level
    // * the reason is to prevent clutter for players who have no interest
    // * in the crafting system
    if ( GetSkillRank(SKILL_CRAFT_ARMOR, oSlayer) > MIN_SKILL_LEVEL || GetSkillRank(SKILL_CRAFT_WEAPON, oSlayer) > MIN_SKILL_LEVEL ) {
        object oSelf = OBJECT_SELF;

        object oDropMgr = GetLocalObject( GetModule(), "CraftDrop_Manager" );
        if ( !GetIsObjectValid(oDropMgr) ) {
            LogError("x2_inc_compon", "Could not find craft drop manager!" );
            return;
        }

        int nAppearance = GetAppearanceType( oSelf );
        string sResRef = GetLocalString( oDropMgr, "AR_" + IntToString(nAppearance) );

        // Crafting drop available.
        if ( sResRef != "" ){

            // Spawn craft drop.
            object oCraftingItem = CreateItemOnObject( sResRef, oSelf );

            // Make the craft drop destroyable.
            DelayCommand( 0.1, AssignCommand( oCraftingItem, SetIsDestroyable( TRUE, FALSE, FALSE ) ) );

        }

    }
}

// * handles dropping crafting items if a placeable is bashed
void craft_drop_placeable()
{
/*
    object oKiller = GetLastKiller();
    // * I was bashed!
    if (GetIsObjectValid(oKiller) == TRUE)
    {
        craft_drop_items(oKiller);
    }
*/
    int a = 0;
}
