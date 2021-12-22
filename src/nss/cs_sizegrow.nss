//::///////////////////////////////////////////////
//:: Increase Player Size [Amia]
//:://////////////////////////////////////////////
/*
// This is a conversation script is for increasing a player's size.
// It is intended for usage with a Size Changer NPC.
// It allows players to scale up by intervals of 0.02 (2%) up to a maximum of 1.1 (+10%) scaling.
*/
//:://////////////////////////////////////////////
//:: Created By: Heartbleed [Zykritch]
//:: Created On: Nov 19 , 2020
//:://////////////////////////////////////////////

void main() {
    // Get player.
    object oPC = GetPCSpeaker();
    // Get player's current scaling.
    float fCurrentScaling = GetObjectVisualTransform(oPC, 10);
    // Set target scaling to 0.02 (2%) larger than the current.
    float fTargetScaling = fCurrentScaling + 0.02;
    // If the player's target scaling won't exceed 1.1 (+10%)
    if ( !(fTargetScaling > 1.1) ) {
        // Scale player to target size.
        SetObjectVisualTransform(oPC, 10, fTargetScaling);
    }
    else {
        SendMessageToPC(oPC, "Maximum sized reached.");
    }
}
