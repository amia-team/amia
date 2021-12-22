//::///////////////////////////////////////////////
//:: Mimic Script
//:: t1k_mimic
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 10/12/2021
//:://////////////////////////////////////////////

// Explanation:
// Sometimes chests will be a mimic instead. This script will despawn the
// treasure chest and instead spawn a mimic monster. It's keyed to ensure that
// the mimic spawned is either level appropriate, or set by a local variable.

string MIMIC_LOCAL_SET = "MimicCR";
string MIMIC_CR_5 = "am_mimic_cr5";
string MIMIC_CR_10 = "am_mimic_cr10";
string MIMIC_CR_15 = "am_mimic_cr15";
string MIMIC_CR_20 = "am_mimic_cr20";
string MIMIC_CR_25 = "am_mimic_cr25";
string MIMIC_CR_30 = "am_mimic_cr30";
int iDebug = FALSE;

int GetLevel(object oPC) {
    int iXP = GetXP(oPC);
    int iAmt = 1000;
    int iLvl = 0;
    while (iXP > 0) {
        iXP = iXP - iAmt;
        iLvl++;
        iAmt = iAmt + 1000;
    }
    if (iDebug == TRUE) {
        SendMessageToPC(oPC, "PC level is: " + IntToString(iLvl));
    }
    return iLvl;
}

string GetMimicType(object oChest, object oPC) {
    int iCR = GetLocalInt(oChest, MIMIC_LOCAL_SET);
    if (iDebug == TRUE) {
        SendMessageToPC(oPC, "Local set Level is: " + IntToString(iCR));
    }
    if (iCR == 0) {
        iCR = GetLevel(oPC);
    }
    string sMimic = MIMIC_CR_5;
    if (iCR > 25) {
        sMimic = MIMIC_CR_30;
    } else if (iCR > 20) {
        sMimic = MIMIC_CR_25;
    } else if (iCR > 15) {
        sMimic = MIMIC_CR_20;
    } else if (iCR > 10) {
        sMimic = MIMIC_CR_15;
    } else if (iCR > 5) {
        sMimic = MIMIC_CR_10;
    } else {
        sMimic = MIMIC_CR_5;
    }
    return sMimic;
}

void main()
{
    object oChest = OBJECT_SELF;
    location lLoc = GetLocation(oChest);
    object oPC = GetNearestCreatureToLocation(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lLoc );
    string sMimic = GetMimicType(oChest, oPC);

    CreateObject(OBJECT_TYPE_CREATURE, sMimic, lLoc, TRUE);
    DestroyObject(oChest);

}
