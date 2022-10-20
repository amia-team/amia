//Generic "mini-quest" to turn in an item for gold and xp without limit.

void main()
{
    object questGiver = OBJECT_SELF;
    object player     = GetPCSpeaker();
    string questIn    = GetLocalString(questGiver, "questitem");
    object pcItem     = GetFirstItemInInventory(player);
    int goldReward    = GetLocalInt(questGiver, "questgold");
    int xpReward      = GetLocalInt(questGiver, "questxp");
    string questDone  = GetLocalString(questGiver, "questdone");
    string questFail  = GetLocalString(questGiver, "questfail");
    int i;

    while ( GetIsObjectValid( pcItem ) == TRUE ) {

        if (GetTag(pcItem) == questIn){
            GiveGoldToCreature(player, goldReward);
            GiveXPToCreature(player, xpReward);
            DestroyObject(pcItem);
            SetLocalInt(player, "miniquest", 1);
        }
        pcItem = GetNextItemInInventory(player);
    }
    if (GetLocalInt(player, "miniquest") == 1){
        SpeakString(questDone);
        SetLocalInt(player, "miniquest", 0);
    }
    else {
        SpeakString(questFail);
    }
}
