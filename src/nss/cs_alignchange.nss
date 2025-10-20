void resetAlignment(object oPC) {

    AdjustAlignment(oPC,ALIGNMENT_GOOD,-100,FALSE);
    AdjustAlignment(oPC,ALIGNMENT_LAWFUL,-100,FALSE);
}

void main() {
    object oPC = GetPCSpeaker();
    string alignment  = GetPCChatMessage();

    SendMessageToPC(oPC, "You picked: " + alignment);
    switch (HashString(alignment))
    {
        // N for Neutral
        case "N":
            resetAlignment(oPC);
            AdjustAlignment(oPC,ALIGNMENT_GOOD,50,FALSE);
            AdjustAlignment(oPC,ALIGNMENT_LAWFUL,50,FALSE);
            break;

        // LN for Lawful neutral
        case "LN":
            resetAlignment(oPC);
            AdjustAlignment(oPC,ALIGNMENT_GOOD,50,FALSE);
            AdjustAlignment(oPC,ALIGNMENT_LAWFUL,100,FALSE);
            break;

        // CN for chaotic neutral
        case "CN":
            resetAlignment(oPC);
            AdjustAlignment(oPC,ALIGNMENT_GOOD,50,FALSE);
            AdjustAlignment(oPC,ALIGNMENT_LAWFUL,0,FALSE);
            break;

        // NG for neutral good
        case "NG":
            resetAlignment(oPC);
            AdjustAlignment(oPC,ALIGNMENT_GOOD,100,FALSE);
            AdjustAlignment(oPC,ALIGNMENT_LAWFUL,50,FALSE);
            break;

        //LG For lawful good
        case "LG":
            resetAlignment(oPC);
            AdjustAlignment(oPC,ALIGNMENT_GOOD,100,FALSE);
            AdjustAlignment(oPC,ALIGNMENT_LAWFUL,100,FALSE);
            break;

        //CG For chaotic good
        case "CG":
            resetAlignment(oPC);
            AdjustAlignment(oPC,ALIGNMENT_GOOD,100,FALSE);
            AdjustAlignment(oPC,ALIGNMENT_LAWFUL,0,FALSE);
            break;

        //NE For neutral evil
        case "NE":
            resetAlignment(oPC);
            AdjustAlignment(oPC,ALIGNMENT_GOOD,0,FALSE);
            AdjustAlignment(oPC,ALIGNMENT_LAWFUL,50,FALSE);
            break;

        //LE For lawful evil
        case "LE":
            resetAlignment(oPC);
            AdjustAlignment(oPC,ALIGNMENT_GOOD,0,FALSE);
            AdjustAlignment(oPC,ALIGNMENT_LAWFUL,100,FALSE);
            break;

        //CE For lawful evil
        case "CE":
            resetAlignment(oPC);
            AdjustAlignment(oPC,ALIGNMENT_GOOD,0,FALSE);
            AdjustAlignment(oPC,ALIGNMENT_LAWFUL,0,FALSE);
            break;
        default:
         SendMessageToPC(oPC, "Invalid input. Try again.");
         break;
    }


}
