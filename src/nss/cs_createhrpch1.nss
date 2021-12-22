void main()
{
    object oPC=GetPCSpeaker();

    // get current level
    int nCharacterLevel=GetHitDice(oPC);

    // calculate PC's surplus xp for current level
    int nCurrentXP=GetXP(oPC);
    int nSurplusXP=nCurrentXP - ((500+(500*(nCharacterLevel-1)))*(nCharacterLevel-1));

    // we dun want the PC to lose a level when crafting the Chime of Interruption
    if(nSurplusXP<600){
        FloatingTextStringOnCreature(
            "OOC - You must be at least 600 XP into your current level to craft the Chime of Interruption",
            oPC,
            FALSE);
        return;
    }

    // PC must also have sufficient gold
    if(GetGold(oPC)<8400){
        FloatingTextStringOnCreature(
            "OOC - Insufficient gold, you need 8400 gold pieces to craft the Chime of Interruption",
            oPC,
            FALSE);
        return;
    }

    // take XP from the PC
    nCurrentXP-=600;
    SetXP(
        oPC,
        nCurrentXP);

    // take GP from the PC
    TakeGoldFromCreature(
        8400,
        oPC,
        TRUE);

    // sound anim
    AssignCommand(
        oPC,
        PlaySound("sce_neutral"));

    // create Chime of Interruption
    CreateItemOnObject(
        "cs_hrp_chimi1",
        oPC,
        1);

}
