//
//obsolete?
//
void main()
{
    object oPC=GetPCSpeaker();

    // get current level
    int nCharacterLevel=GetHitDice(oPC);

    // calculate PC's surplus xp for current level
    int nCurrentXP=GetXP(oPC);
    int nSurplusXP=nCurrentXP - ((500+(500*(nCharacterLevel-1)))*(nCharacterLevel-1));

    // we dun want the PC to lose a level when crafting the Thieves' Tools +10
    if(nSurplusXP<62){
        FloatingTextStringOnCreature(
            "OOC - You must be at least 62 XP into your current level to craft the Thieves' Tools +10",
            oPC,
            FALSE);
        return;
    }

    // PC must also have sufficient gold
    if(GetGold(oPC)<781){
        FloatingTextStringOnCreature(
            "OOC - Insufficient gold, you need 781 gold pieces to craft the Thieves' Tools +10",
            oPC,
            FALSE);
        return;
    }

    // take XP from the PC
    nCurrentXP-=62;
    SetXP(
        oPC,
        nCurrentXP);

    // take GP from the PC
    TakeGoldFromCreature(
        781,
        oPC,
        TRUE);

    // sound anim
    AssignCommand(
        oPC,
        PlaySound("sce_neutral"));

    // create Thieves' Tools +10
    CreateItemOnObject(
        "nw_it_picks004",
        oPC,
        1);

}
