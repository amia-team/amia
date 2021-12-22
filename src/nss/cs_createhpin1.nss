void main()
{
    object oPC=GetPCSpeaker();

    // get current level
    int nCharacterLevel=GetHitDice(oPC);

    // calculate PC's surplus xp for current level
    int nCurrentXP=GetXP(oPC);
    int nSurplusXP=nCurrentXP - ((500+(500*(nCharacterLevel-1)))*(nCharacterLevel-1));

    // we dun want the PC to lose a level when crafting the Harper Pin
    if(nSurplusXP<778){
        FloatingTextStringOnCreature(
            "OOC - You must be at least 778 XP into your current level to craft the Harper Pin",
            oPC,
            FALSE);
        return;
    }

    // PC must also have sufficient gold
    if(GetGold(oPC)<9735){
        FloatingTextStringOnCreature(
            "OOC - Insufficient gold, you need 9735 gold pieces to craft the Harper Pin",
            oPC,
            FALSE);
        return;
    }

    // take XP from the PC
    nCurrentXP-=778;
    SetXP(
        oPC,
        nCurrentXP);

    // take GP from the PC
    TakeGoldFromCreature(
        9735,
        oPC,
        TRUE);

    // sound anim
    AssignCommand(
        oPC,
        PlaySound("sce_neutral"));

    // create Harper Pin
    object oHarperPin=CreateItemOnObject(
        "x0_it_mneck006",
        oPC,
        1);

    // ID it
    SetIdentified(
        oHarperPin,
        TRUE);

    // make it plot so it cannot be sold or exploited etcs.
    SetPlotFlag(
        oHarperPin,
        TRUE);
}
