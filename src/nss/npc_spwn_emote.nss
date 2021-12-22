// Script: npc_spwn_emote
// By: Anatida
// Makes an NPC perform animation OnSpawn
// Constant intergers taken from http://www.nwnlexicon.com/index.php?title=Animation
// ---------- ---------------- ---------------------------------------------
// 1/12/2016   Anatida
//

void main()
{
    object oTarget = OBJECT_SELF;
    int iAnimation = GetLocalInt(OBJECT_SELF, "Animation");

        AssignCommand(OBJECT_SELF,
            ActionPlayAnimation(iAnimation, 0.8, 28800.0));
}
