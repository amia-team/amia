//Lord-Jyssev - generic PLC spell casting script: "us_cast_spell"
//
// Simple OnUse script for a placeable to cast a spell when used.
// Variables set on the PLC:
// int Spell        = Spell constant # from spells.2da
// int Gold         = Optional: gold required per casting
// float Cooldown   = Optional: cooldown for usage

#include "amia_include"

void main()
{
    object oPC      = GetLastUsedBy();
    int nSpell      = GetLocalInt(OBJECT_SELF, "Spell");
    int nGoldCost   = GetLocalInt(OBJECT_SELF, "Gold");
    int nCooldown   = GetLocalInt(OBJECT_SELF, "Cooldown");

    if(nGoldCost != 0 && GetGold(oPC) < nGoldCost)
    {
        SendMessageToPC( oPC, IntToString(nGoldCost) + " gold is required.");
        return;
    }
    else if(GetIsBlocked())
    {
        SendMessageToPC( oPC, "You must wait to use this again.");
        return;
    }
    else
    {
        TakeGoldFromCreature(nGoldCost, oPC, TRUE);
        ActionCastSpellAtObject(nSpell, oPC, METAMAGIC_ANY, TRUE);
        if (nCooldown != 0)
        {
            SetBlockTime(OBJECT_SELF, 0, nCooldown);
        }
    }
}
