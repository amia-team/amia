void main()
{
    object oPC=GetPCSpeaker();

    // get current level
    int nCharacterLevel=GetHitDice(oPC);

    // calculate PC's surplus xp for current level
    int nCurrentXP=GetXP(oPC);
    int nSurplusXP=nCurrentXP - ((500+(500*(nCharacterLevel-1)))*(nCharacterLevel-1));

    // we dun want the PC to lose a level when crafting the Garlic
    if(nSurplusXP<10){
        FloatingTextStringOnCreature(
            "OOC - You must be at least 10 XP into your current level to prepare Garlic",
            oPC,
            FALSE);
        return;
    }

    // PC must also have sufficient gold
    if(GetGold(oPC)<50){
        FloatingTextStringOnCreature(
            "OOC - Insufficient gold, you need 50 gold pieces to prepare Garlic",
            oPC,
            FALSE);
        return;
    }

    // take XP from the PC
    nCurrentXP-=10;
    SetXP(
        oPC,
        nCurrentXP);

    // take GP from the PC
    TakeGoldFromCreature(
        50,
        oPC,
        TRUE);

    // sound anim
    AssignCommand(
        oPC,
        PlaySound("sce_neutral"));

    // create 10 leaves of Garlic
    int nCounter=0;
    for(nCounter;nCounter<10;nCounter++){
        object oGarlic=CreateItemOnObject(
            "nw_it_msmlmisc24",
            oPC,
            1);

        SetIdentified(
            oGarlic,
            TRUE);
    }

}
