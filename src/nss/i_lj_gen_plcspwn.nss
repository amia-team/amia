//Lord-Jyssev's generic PLC spawner script: "i_lj_gen_plcspwn"
//
// Keyed to an item, this script will spawn a PLC based on the variables
// set on the triggering item. The item should have the lj_gen_plcspwn tag.
// By default, the PLC will share the item name and description but this can
// be customized with optional variables. Using the widget again will despawn
// the PLC.
//
// Required variables:
// string Resref = resref of the palette plc to spawn
//
// Optional variables:
// string Name          = sets name of the spawned PLC
// string Description   = sets description of the spawned PLC
// string Useable       = sets PLC to useable
// int PLCAppearance    = customizes the PLC's appearance with NWNX from index in placeables.2da
//
// The following items are mutually exclusive (Only the first set will apply):
// string Item          = sets useable and gives PLC an item-giving script set to this resref
// string Destination   = sets useable and gives PLC a teleport destination to this waypoint tag
// int Spell            = sets useable and gives PLC an on-use spell casting from index in spells.2da
//
// int GoldCost         = sets price for item, spell, or destination functions
// int Cooldown         = sets a cooldown on the item and spell scripts

#include "nwnx_object"

void main()
{
    object oPC       = GetItemActivator();
    object oWidget   = GetItemActivated();
    location lTarget = GetItemActivatedTargetLocation();
    string sPLC      = GetLocalString(oWidget,"Resref");
    int sActivePLC   = GetLocalInt(oWidget,"Active");
    location lPLC    = GetLocalLocation(oWidget, "SpawnedPLCLocation");


    // Optional Variables
    string sName = GetLocalString(oWidget, "Name"); if ( sName == ""){ sName = GetName(oWidget); }
    string sDescription = GetLocalString(oWidget, "Description"); if ( sDescription == ""){ sDescription = GetDescription(oWidget); }
    int nUseable = GetLocalInt(oWidget, "Useable");
    int nPLCAppearance = GetLocalInt(oWidget, "PLCAppearance");
    string sItem = GetLocalString(oWidget, "Item");
    string sDestination = GetLocalString(oWidget, "Destination");
    int nSpell = GetLocalInt(oWidget, "Spell");
    int nGoldCost = GetLocalInt(oWidget, "GoldCost");
    int nCooldown = GetLocalInt(oWidget, "Cooldown");


    if(sActivePLC == 1)
    {
        object oPLC = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lPLC);
        string sPLCRes = GetResRef(oPLC);
        if(sPLCRes == sPLC)
        {
            DestroyObject(oPLC);
        }
        FloatingTextStringOnCreature("Removing "+sName,oPC);
        DeleteLocalInt(oWidget,"Active");
    }
    else
    {
        FloatingTextStringOnCreature("Spawning PLC "+sName,oPC);
        object oPlacedPLC = CreateObject(OBJECT_TYPE_PLACEABLE,sPLC,lTarget,FALSE);
        float fRotation = GetFacing(oPlacedPLC) + GetLocalFloat(oPlacedPLC, "SpawnRotation");
        AssignCommand(oPlacedPLC, SetFacing(fRotation));
        NWNX_Object_SetPlaceableIsStatic(oPlacedPLC, 0);
        SetPlotFlag(oPlacedPLC, 1);

        if (nPLCAppearance != 0) { NWNX_Object_SetAppearance(oPlacedPLC, nPLCAppearance); }
        if (sItem != "" )
        {
            SetUseableFlag(oPlacedPLC, 1);
            SetEventScript(oPlacedPLC, EVENT_SCRIPT_PLACEABLE_ON_USED, "us_give_item");
            SetLocalString(oPlacedPLC, "ds_item", sItem);
            SetLocalInt(oPlacedPLC, "Gold", nGoldCost);
            SetLocalInt(oPlacedPLC, "Cooldown", nCooldown);
        }
        else if (sDestination != "")
        {
            SetUseableFlag(oPlacedPLC, 1);
            SetEventScript(oPlacedPLC, EVENT_SCRIPT_PLACEABLE_ON_USED, "us_jump_to_tag");
            SetLocalInt(oPlacedPLC, "gold", nGoldCost);
            SetTag(oPlacedPLC, sDestination);
        }
        else if (nSpell != 0)
        {
            SetUseableFlag(oPlacedPLC, 1);
            SetEventScript(oPlacedPLC, EVENT_SCRIPT_PLACEABLE_ON_USED, "us_cast_spell");
            SetLocalInt(oPlacedPLC, "Spell", nSpell);
            SetLocalInt(oPlacedPLC, "Gold", nGoldCost);
            SetLocalInt(oPlacedPLC, "Cooldown", nCooldown);
        }
        if( nUseable == 1) {SetUseableFlag(oPlacedPLC, nUseable); }
        SetName(oPlacedPLC,sName);
        SetDescription(oPlacedPLC,sDescription);
        SetLocalInt(oWidget,"Active",1);
        SetLocalLocation(oWidget, "SpawnedPLCLocation",lTarget);
    }

}
