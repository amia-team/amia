void main()
{
    object oPC=GetPCSpeaker();

    // get current level
    int nCharacterLevel=GetHitDice(oPC);

    // calculate PC's surplus xp for current level
    int nCurrentXP=GetXP(oPC);
    int nSurplusXP=nCurrentXP - ((500+(500*(nCharacterLevel-1)))*(nCharacterLevel-1));

    // we dun want the PC to lose a level when crafting the Belladonna
    if(nSurplusXP<50){
        FloatingTextStringOnCreature(
            "OOC - You must be at least 50 XP into your current level to prepare Belladonna",
            oPC,
            FALSE);
        return;
    }

    // PC must also have sufficient gold
    if(GetGold(oPC)<200){
        FloatingTextStringOnCreature(
            "OOC - Insufficient gold, you need 200 gold pieces to prepare Belladonna",
            oPC,
            FALSE);
        return;
    }

    // take XP from the PC
    nCurrentXP-=50;
    SetXP(
        oPC,
        nCurrentXP);

    // take GP from the PC
    TakeGoldFromCreature(
        200,
        oPC,
        TRUE);

    // sound anim
    AssignCommand(
        oPC,
        PlaySound("sce_neutral"));

    // create 10 leaves of Belladonna
    int nCounter=0;
    for(nCounter;nCounter<10;nCounter++){
        CreateItemOnObject(
            "nw_it_msmlmisc23",
            oPC,
            1);
    }

}
