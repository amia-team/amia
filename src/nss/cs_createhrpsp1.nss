void main()
{
    object oPC=GetPCSpeaker();

    // get current level
    int nCharacterLevel=GetHitDice(oPC);

    // calculate PC's surplus xp for current level
    int nCurrentXP=GetXP(oPC);
    int nSurplusXP=nCurrentXP - ((500+(500*(nCharacterLevel-1)))*(nCharacterLevel-1));

    // we dun want the PC to lose a level when crafting the Harper's Scarab of Protection
    if(nSurplusXP<700){
        FloatingTextStringOnCreature(
            "OOC - You must be at least 700 XP into your current level to craft the Harper's Scarab of Protection",
            oPC,
            FALSE);
        return;
    }

    // PC must also have sufficient gold
    if(GetGold(oPC)<20000){
        FloatingTextStringOnCreature(
            "OOC - Insufficient gold, you need 20000 gold pieces to craft the Harper's Scarab of Protection",
            oPC,
            FALSE);
        return;
    }

    // take XP from the PC
    nCurrentXP-=700;
    SetXP(
        oPC,
        nCurrentXP);

    // take GP from the PC
    TakeGoldFromCreature(
        20000,
        oPC,
        TRUE);

    // sound anim
    AssignCommand(
        oPC,
        PlaySound("sce_neutral"));

    // create Harper's Scarab of Protection
    CreateItemOnObject(
        "cs_harp_scprot1",
        oPC,
        1);

}
