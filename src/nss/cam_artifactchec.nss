void main()
{
    object oPC = GetPCSpeaker();
    object oItem;
    int nTrade = GetLocalInt(oPC, "epictrade");

    oItem = GetItemPossessedBy(oPC, "epic_artifact");

    // Abort if the player does not have the required item
    if (!GetIsObjectValid(oItem))
    {
        SpeakString("You do not possess the required artifact.", TALKVOLUME_TALK);
        return;
    }

    // Remove one epic artifact
    DestroyObject(oItem);

    // Pick le reward
    switch (nTrade)
    {
        case 1:
            GiveGoldToCreature(oPC, 750000);
            break;

        case 2:
            CreateItemOnObject("epx_base_claw", oPC);
            break;

        case 3:
            CreateItemOnObject("epx_base_glyp", oPC);
            break;

        case 4:
            CreateItemOnObject("epx_base_obsd", oPC);
            break;

        case 5:
            CreateItemOnObject("epx_base_fabr", oPC);
            break;

        case 6:
            CreateItemOnObject("epx_base_blod", oPC);
            break;

        case 7:
            CreateItemOnObject("epx_base_eqip", oPC);
            break;

        case 8:
            CreateItemOnObject("epx_comp_safbc", oPC);
            break;

        case 9:
            CreateItemOnObject("epx_base_bone", oPC);
            break;

        case 10:
            CreateItemOnObject("epx_base_ioun", oPC);
            break;

        case 11:
            CreateItemOnObject("nep_largemagical", oPC);
            break;

        default:
            SpeakString("The trade value is invalid. Please contact a DM.", TALKVOLUME_TALK);
            break;
    }
}
