//::///////////////////////////////////////////////
//:: [DM Tools] Increase Player Size [Amia]
//:://////////////////////////////////////////////
/*
// This is a conversation script is for increasing a player's size by intervals of 2%.
// It is intended for the Precious widget and is uncapped.
*/
//:://////////////////////////////////////////////
//:: Created By: Heartbleed [Zykritch]
//:: Created On: Nov 21 , 2020
//:://////////////////////////////////////////////

void main() {
    // Get player.
    object oPC = GetItemActivatedTarget();
    // Get player's current scaling.
    float fCurrentScaling = GetObjectVisualTransform(oPC, 10);
    // Set target scaling to 0.02 (2%) larger than the current.
    float fTargetScaling = fCurrentScaling + 0.02;
    // Scale player to target size.
    SetObjectVisualTransform(oPC, 10, fTargetScaling);
}
