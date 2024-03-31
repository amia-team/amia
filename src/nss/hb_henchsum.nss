//:://////////////////////////////////////////////////
//:: X0_CH_HEN_HEART
/*

  OnHeartbeat event handler for Summon-like Henchmen.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////
#include "X0_INC_HENAI"
#include "inc_ds_died"



void main()
{    // SpawnScriptDebugger();
    string resRef = GetResRef(OBJECT_SELF);

    if(GetTag(OBJECT_SELF) == "cust_summon"){
        object pc       = GetMaster(OBJECT_SELF);
        effect unsummon = EffectVisualEffect(99);
        location hench  = GetLocation(OBJECT_SELF);

        if (GetIsObjectValid(GetAssociate(4, pc, 1))){
            SendMessageToPC(pc, "You cannot have this summon alongside another summon.");
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,unsummon,hench);
            DestroyObject(OBJECT_SELF);
        }
    }

    if(GetSubString(resRef, 0, 13) == "summon_vassal"){
        object pc       = GetMaster(OBJECT_SELF);
        effect unsummon = EffectVisualEffect(99);
        location hench  = GetLocation(OBJECT_SELF);

        if(GetIsObjectValid(GetHenchman(pc, 1)) || GetIsObjectValid(GetAssociate(4, pc, 1))){
            if(GetHenchman(pc, 1) != OBJECT_SELF && GetTag(GetHenchman(pc, 1)) != "swarm_summon" && GetSubString(GetTag(GetHenchman(pc, 1)),0,11) != "undead_hen_"){
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, unsummon, hench);
                DestroyObject(OBJECT_SELF, 0.1);
                SendMessageToPC(pc, "You cannot use your Vassal with another summon.");
                IncrementRemainingFeatUses(pc, 1255);
            }
        }
    }

    if(GetLocalInt( GetMaster(OBJECT_SELF), DIED_IS_DEAD) == 1 ){
        effect unsummon = EffectVisualEffect(99);
        location hench  = GetLocation(OBJECT_SELF);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, unsummon, hench);
        DestroyObject(OBJECT_SELF, 0.1);
    }
    // If the henchman is in dying mode, make sure
    // they are non commandable. Sometimes they seem to
    // 'slip' out of this mode
    int bDying = GetIsHenchmanDying();

    if (bDying == TRUE)
    {
        int bCommandable = GetCommandable();
        if (bCommandable == TRUE)
        {
            // lie down again
            ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,
                                          1.0, 65.0);
           SetCommandable(FALSE);
        }
    }

    // If we're dying or busy, we return
    // (without sending the user-defined event)
    if(GetAssociateState(NW_ASC_IS_BUSY) ||
       bDying)
        return;






    // Check to see if should re-enter stealth mode
    if (GetIsInCombat() == FALSE)
    {
        int nStealth=GetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE");
        if((nStealth == 1 || nStealth == 2)
            && GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == FALSE)
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
            }
    }

    // * checks to see if a ranged weapon was being used
    // * if so, it equips it back
    if (GetIsInCombat() == FALSE)
    {        //   SpawnScriptDebugger();
        object oRight = GetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND");
        if (GetIsObjectValid(oRight) == TRUE)
        {    // * you always want to blank this value, if it not invalid
            SetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND", OBJECT_INVALID);
            if (GetWeaponRanged(oRight) == TRUE)
            {
                ClearAllActions();
                bkEquipRanged(OBJECT_INVALID, TRUE, TRUE);
                //ActionEquipItem(
                return;

            }
        }
    }



    ExecuteScript("nw_ch_ac1", OBJECT_SELF);
}
