void main()
{
    object oPC = GetPCSpeaker();
    string sMessage = GetPCChatMessage();
    int nLevel = StringToInt(sMessage);

    SendMessageToPC(oPC, "You said: " + sMessage);

    switch (nLevel)
    {
    case 1:
         SetXP(oPC, 0);
         break;
    case 2:
         SetXP(oPC, 1000);
         break;
    case 3:
         SetXP(oPC, 3000);
         break;
    case 4:
         SetXP(oPC, 6000);
         break;
    case 5:
         SetXP(oPC, 10000);
         break;
    case 6:
         SetXP(oPC, 15000);
         break;
    case 7:
         SetXP(oPC, 21000);
         break;
    case 8:
         SetXP(oPC, 28000);
         break;
    case 9:
         SetXP(oPC, 36000);
         break;
    case 10:
         SetXP(oPC, 45000);
         break;
    case 11:
         SetXP(oPC, 55000);
         break;
    case 12:
         SetXP(oPC, 66000);
         break;
    case 13:
         SetXP(oPC, 78000);
         break;
    case 14:
         SetXP(oPC, 91000);
         break;
    case 15:
         SetXP(oPC, 105000);
         break;
    case 16:
         SetXP(oPC, 120000);
         break;
    case 17:
         SetXP(oPC, 136000);
         break;
    case 18:
         SetXP(oPC, 153000);
         break;
    case 19:
         SetXP(oPC, 171000);
         break;
    case 20:
         SetXP(oPC, 190000);
         break;
    case 21:
         SetXP(oPC, 210000);
         break;
    case 22:
         SetXP(oPC, 231000);
         break;
    case 23:
         SetXP(oPC, 253000);
         break;
    case 24:
         SetXP(oPC, 276000);
         break;
    case 25:
         SetXP(oPC, 300000);
         break;
    case 26:
         SetXP(oPC, 325000);
         break;
    case 27:
         SetXP(oPC, 351000);
         break;
    case 28:
         SetXP(oPC, 378000);
         break;
    case 29:
         SetXP(oPC, 406000);
         break;
    case 30:
         SetXP(oPC, 435000);
         break;
    default:
         SendMessageToPC(oPC, "Invalid input. Try again.");
         break;
    }
}
