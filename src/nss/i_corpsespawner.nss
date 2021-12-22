//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_corpsespawner
//group:
//date: 2012-09-01
//author: The1Kobra

#include "x2_inc_switches"

// Marked targets may be collected as corpses. This undoes that.
void unmark_target(object oPC, object oTarget) {
    SetLocalInt(oTarget, "corpsemarked", 0)';
    SendMessageToPC(oPC, "Target has been unmarked for corpse collection.");
    return;
}
// Recursive method to check if a target is dead and ready for collection.
//void check_target_dead(object oTarget, int count, object oPC, int size, int tail, int wing, string name, int phenotype, int appearance) {
void check_target_dead(object oTarget, int count, object oPC, string resref, string name, int size) {
    if (count == 20) {
        SetLocalInt(oTarget, "corpsemarked", 0)';
        SendMessageToPC(oPC, "Target has been unmarked for corpse collection.");
        return;
    } else {
        if (GetIsDead(oTarget)) {
            // Okay, everything checks out. Create the item
            SendMessageToPC(oPC, "Corpse Collected!");
            object oCorpse = CreateItemOnObject("spawnedcorpse", oPC, 1, "");
            SetName(oCorpse, "Collected Corpse of " + name);
            /*SetDescription(oCorpse, "This is the harvested corpse of a " + name + "\n"
                + "Corpse Information: \n" +
                "Size: " + IntToString(size) + "\n" +
                "Tail: " + IntToString(tail) + "\n" +
                "Wing: " + IntToString(wing) + "\n" +
                "Phenotype: " + IntToString(phenotype) + "\n" +
                "Appearance: " + IntToString(appearance) + "\n", TRUE);*/
            SetDescription(oCorpse, "This is the harvested corpse of a " + name + "\n"
                + "Corpse Information: \n" +
                "Resref: " + resref, TRUE);
                // Set weight by size
            if (size == CREATURE_SIZE_TINY) {
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_5_LBS), oCorpse,0.0f);
            } else if (size == CREATURE_SIZE_SMALL) {
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_15_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_15_LBS), oCorpse,0.0f);
            } else if (size == CREATURE_SIZE_MEDIUM) {
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
            } else if (size == CREATURE_SIZE_LARGE) {
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
            } else if (size == CREATURE_SIZE_HUGE) {
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
                AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oCorpse,0.0f);
            } else if (size == CREATURE_SIZE_INVALID) {
            }
        } else {
            //DelayCommand(6.0, check_target_dead(oTarget, (count + 1), oPC, size, tail, wing, name, phenotype, appearance));
            DelayCommand(6.0, check_target_dead(oTarget, (count + 1), oPC, resref, name, size));
            //void check_target_dead(object oTarget, int count, object oPC, string resref, string name, int size) {
        }
    }
}
void create_inv_corpse() {
    // Check to see that it's not a PC
    // item activate variables
    object oPC       = GetItemActivator();
    object oItem     = GetItemActivated();
    object oTarget   = GetItemActivatedTarget();
    string sItemName = GetName(oItem);
    location lTarget = GetItemActivatedTargetLocation();

    //SendMessageToPC(oPC, "Running script");
    //if ( sItemName == "Corpse Maker" ){
    if (GetIsPC(oTarget)) {
        SendMessageToPC(oPC, "This item may not be used on PCs!");
        return;
    }
    if (!GetIsEnemy(oTarget, oPC)) {
        SendMessageToPC(oPC, "This item may only be used on hostile monsters!");
        return;
    }
    //if (!GetIsDead(oTarget)) {
    //    SendMessageToPC(oPC, "This item may only be used on dead targets!");
    //}
    // Get some information to store on the corpse object.
    int size = GetCreatureSize(oTarget);
    int tail = GetCreatureTailType(oTarget);
    int wing = GetCreatureWingType(oTarget);
    string name = GetName(oTarget, FALSE);
    int phenotype = GetPhenoType(oTarget);
    int appearance = GetAppearanceType(oTarget);
    string resref = GetResRef(oTarget);
    if (appearance == APPEARANCE_TYPE_INVALID) {
        SendMessageToPC(oPC, "Invalid target, target must be a creature.");
        return;
    }
    if (GetLocalInt(oTarget, "corpsemarked") == 0) {
        //DelayCommand(120.0, unmark_target(oPC, oTarget));
        SetLocalInt(oTarget, "corpsemarked", 1);
        //DelayCommand(6.0, check_target_dead(oTarget, 0, oPC, size, tail, wing, name, phenotype, appearance));
        DelayCommand(6.0, check_target_dead(oTarget, 0, oPC, resref, name, size));
        SendMessageToPC(oPC, "Target has been marked for corpse collection.");
    } else {
        // Commented out because the unmarking doesn't work, since the mark is
        // on a recursive timer. AKA: Doesn't work.
        //unmark_target(oPC, oTarget);
    }
}

void main()
{

    int nEvent  = GetUserDefinedItemEventNumber();
    //int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:
            create_inv_corpse();
            break;
    }
}
