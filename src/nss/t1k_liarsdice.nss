//::///////////////////////////////////////////////
//:: Liar's Dice
//:: t1k_liardice
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 09/16/2021
//:://////////////////////////////////////////////

// Explanation:
// Players using the liar's dice roll 5 dice. The results of the dice are
// Sent specifically to them. They can use it again to reveal the results
// Of their dice rolls to any PCs around them.
// Used for the game Liar's Dice

string HOLDING_DICE = "LiarsDicePlaying";
string LIARS_DICE_ONES = "LiarsDiceOnes";
string LIARS_DICE_TWOS = "LiarsDiceTwos";
string LIARS_DICE_THREES = "LiarsDiceThrees";
string LIARS_DICE_FOURS = "LiarsDiceFours";
string LIARS_DICE_FIVES = "LiarsDiceFives";
string LIARS_DICE_SIXES = "LiarsDiceSixes";

void main()
{
    object oPC = GetLastUsedBy();

     if (GetLocalInt(oPC, HOLDING_DICE) == TRUE) {
        DeleteLocalInt(oPC, HOLDING_DICE);
        int ones=GetLocalInt(oPC, LIARS_DICE_ONES);
        int twos=GetLocalInt(oPC, LIARS_DICE_TWOS);
        int threes=GetLocalInt(oPC, LIARS_DICE_THREES);
        int fours=GetLocalInt(oPC, LIARS_DICE_FOURS);
        int fives=GetLocalInt(oPC, LIARS_DICE_FIVES);
        int sixes=GetLocalInt(oPC, LIARS_DICE_SIXES);
        DeleteLocalInt(oPC, LIARS_DICE_ONES);
        DeleteLocalInt(oPC, LIARS_DICE_TWOS);
        DeleteLocalInt(oPC, LIARS_DICE_THREES);
        DeleteLocalInt(oPC, LIARS_DICE_FOURS);
        DeleteLocalInt(oPC, LIARS_DICE_FIVES);
        DeleteLocalInt(oPC, LIARS_DICE_SIXES);

        string sName = GetName(oPC);
        string dicestring = sName + " reveals their dice! " + IntToString(ones) + " ones, "
            + IntToString(twos) + " twos, " + IntToString(threes) + " threes, "
            + IntToString(fours) + " fours, " + IntToString(fives) + " fives, and "
            + IntToString(sixes) + " sixes.";
        //FloatingTextStringOnCreature Does NOT broadcast as advertised. Find alternative
        //FloatingTextStringOnCreature(dicestring,oPC, FALSE);
        SpeakString(dicestring, TALKVOLUME_TALK);

    } else {
        SetLocalInt(oPC, HOLDING_DICE, TRUE);
        int idice = 5;
        int ones = 0;
        int twos = 0;
        int threes = 0;
        int fours = 0;
        int fives = 0;
        int sixes = 0;
        int rolls = 0;

        int loop = 0;
        for (loop = 0; loop < idice; loop++) {
            int roll = Random(6)+1;
            if (roll == 1) {
                ones++;
            } else if (roll == 2) {
                twos++;
            } else if (roll == 3) {
                threes++;
            } else if (roll == 4) {
                fours++;
            } else if (roll == 5) {
                fives++;
            } else if (roll == 6) {
                sixes++;
            }
            //rolls = rolls + FloatToInt(pow(10.0f, (roll-1.0f)));
        }
        string dicestring = "You have rolled: " + IntToString(ones) + " ones, "
            + IntToString(twos) + " twos, " + IntToString(threes) + " threes, "
            + IntToString(fours) + " fours, " + IntToString(fives) + " fives, and "
            + IntToString(sixes) + " sixes.";
        SetLocalInt(oPC,LIARS_DICE_ONES,ones);
        SetLocalInt(oPC,LIARS_DICE_TWOS,twos);
        SetLocalInt(oPC,LIARS_DICE_THREES,threes);
        SetLocalInt(oPC,LIARS_DICE_FOURS,fours);
        SetLocalInt(oPC,LIARS_DICE_FIVES,fives);
        SetLocalInt(oPC,LIARS_DICE_SIXES,sixes);

        SendMessageToPC(oPC,dicestring);
    }
    /*
    SendMessageToPC(oPC,"You have rolled: " + IntToString(rolls) + "");
    ones = rolls % 10;
    twos = rolls / 10 % 10;
    threes = rolls / 100 % 10;
    fours = rolls / 1000 % 10;
    fives = rolls / 10000 % 10;
    sixes = rolls / 100000 % 10;
    SendMessageToPC(oPC,"You have rolled: " + IntToString(ones) + " ones, "
        + IntToString(twos) + " twos, " + IntToString(threes) + " threes, "
        + IntToString(fours) + " fours, " + IntToString(fives) + " fives, and "
        + IntToString(sixes) + " sixes.");
    */
}
