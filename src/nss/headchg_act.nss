/*
--------------------------------------------------------------------------------
NAME: headchg_act
Description: This is a simple script that can be used to change head model.
LOG:
    Jes 12/10/24 - Simplified for item activation, for class features.
--------------------------------------------------------------------------------
*/

/* protypes */
int emptyHead(object oPC, int iHead);

void main()
{
    object oPC   = GetItemActivator();
    string sLast = GetLocalString(oPC, "last_chat");

    if(sLast != "") {
        int newHead = StringToInt(sLast);
        if (!emptyHead(oPC, newHead)) {
            SendMessageToPC(oPC, "This head is empty! Choose a different number!");
            return;
        }
        SetCreatureBodyPart(CREATURE_PART_HEAD, newHead, oPC);
        return;
    }
}

int emptyHead(object oPC, int newHead) {
    int iBaseRace = GetAppearanceType(oPC);
    int iGender   = GetGender(oPC);

        //Dwarf male
        if(iGender == GENDER_MALE && iBaseRace == 0) {
                if((newHead > 33) && (newHead < 101)) return FALSE;
                if((newHead > 101) && (newHead < 131)) return FALSE;
                if((newHead > 132) && (newHead < 138)) return FALSE;
                if((newHead > 138) && (newHead < 155)) return FALSE;
                if(newHead > 156) return FALSE;
}
        //Elf male
        else if(iGender == GENDER_MALE && iBaseRace == 1) {
                if((newHead > 49) && (newHead < 103)) return FALSE;
                if(newHead == 105) return FALSE;
                if(newHead == 116) return FALSE;
                if(newHead == 117) return FALSE;
                if(newHead == 118) return FALSE;
                if((newHead > 123) && (newHead < 130)) return FALSE;
                if(newHead == 131) return FALSE;
                if((newHead > 132) && (newHead < 150)) return FALSE;
                if((newHead > 50) && (newHead < 155)) return FALSE;
                if((newHead > 155) && (newHead < 179)) return FALSE;
                if((newHead > 181) && (newHead < 189)) return FALSE;
                if(newHead > 193) return FALSE;
}
        //Gnome male
        else if(iGender == GENDER_MALE && iBaseRace == 2) {
                if(newHead == 78) return FALSE;
                if(newHead == 111) return FALSE;
                if((newHead > 112) && (newHead < 130)) return FALSE;
                if(newHead == 131) return FALSE;
                if((newHead > 132) && (newHead < 145)) return FALSE;
                if((newHead > 146) && (newHead < 155)) return FALSE;
                if(newHead == 156) return FALSE;
                if(newHead == 157) return FALSE;
                if((newHead > 168) && (newHead < 179)) return FALSE;
                if((newHead > 181) && (newHead < 189)) return FALSE;
                if(newHead > 193) return FALSE;
}
        //Halfling male
        else if(iGender == GENDER_MALE && iBaseRace == 3) {
                if(newHead == 78) return FALSE;
                if(newHead == 111) return FALSE;
                if((newHead > 112) && (newHead < 130)) return FALSE;
                if(newHead == 131) return FALSE;
                if((newHead > 132) && (newHead < 145)) return FALSE;
                if((newHead > 146) && (newHead < 155)) return FALSE;
                if(newHead == 156) return FALSE;
                if(newHead == 157) return FALSE;
                if((newHead > 168) && (newHead < 179)) return FALSE;
                if((newHead > 181) && (newHead < 189)) return FALSE;
                if(newHead > 193) return FALSE;
}
        //Half-elf male
        else if(iGender == GENDER_MALE && iBaseRace == 4) {
                if((newHead > 49) && (newHead < 82)) return FALSE;
                if(newHead == 140) return FALSE;
                if(newHead == 200) return FALSE;
                if(newHead == 202) return FALSE;
                if(newHead == 222) return FALSE;
                if(newHead == 223) return FALSE;
                if(newHead > 240) return FALSE;
}
        //Half-orc male
        else if(iGender == GENDER_MALE && iBaseRace == 5) {
                if((newHead > 44) && (newHead < 101)) return FALSE;
                if((newHead > 101) && (newHead < 130)) return FALSE;
                if((newHead > 135) && (newHead < 138)) return FALSE;
                if((newHead > 138) && (newHead < 149)) return FALSE;
                if(newHead == 157) return FALSE;
                if((newHead > 159) && (newHead < 194)) return FALSE;
                if((newHead > 194) && (newHead < 198)) return FALSE;
                if(newHead > 199) return FALSE;
}
        //Human male
        else if(iGender == GENDER_MALE && iBaseRace == 6) {
                if((newHead > 49) && (newHead < 82)) return FALSE;
                if(newHead == 140) return FALSE;
                if(newHead == 200) return FALSE;
                if(newHead == 202) return FALSE;
                if(newHead == 222) return FALSE;
                if(newHead == 223) return FALSE;
                if(newHead > 240) return FALSE;
}
        //Dwarf female
        else if(iGender == GENDER_FEMALE && iBaseRace == 0) {
                if((newHead > 27) && (newHead < 153)) return FALSE;
                if(newHead > 156) return FALSE;
}
        //Elf female
        else if(iGender == GENDER_FEMALE && iBaseRace == 1) {
                if((newHead > 70) && (newHead < 100)) return FALSE;
                if(newHead == 114) return FALSE;
                if(newHead == 123) return FALSE;
                if(newHead == 137) return FALSE;
                if((newHead > 141) && (newHead < 154)) return FALSE;
                if(newHead == 156) return FALSE;
                if((newHead > 163) && (newHead < 179)) return FALSE;
                if((newHead > 179) && (newHead < 191)) return FALSE;
                if(newHead > 196) return FALSE;
}
        //Gnome female
        else if(iGender == GENDER_FEMALE && iBaseRace == 2) {
                if((newHead > 63) && (newHead < 139)) return FALSE;
                if((newHead > 139) && (newHead < 155)) return FALSE;
                if(newHead == 156) return FALSE;
                if(newHead == 157) return FALSE;
                if(newHead == 159) return FALSE;
                if((newHead > 160) && (newHead < 168)) return FALSE;
                if((newHead > 168) && (newHead < 179)) return FALSE;
                if((newHead > 179) && (newHead < 193)) return FALSE;
                if(newHead > 194) return FALSE;
}
        //Halfling female
        else if(iGender == GENDER_FEMALE && iBaseRace == 3) {
                if((newHead > 63) && (newHead < 139)) return FALSE;
                if((newHead > 139) && (newHead < 155)) return FALSE;
                if(newHead == 156) return FALSE;
                if(newHead == 157) return FALSE;
                if(newHead == 159) return FALSE;
                if((newHead > 160) && (newHead < 168)) return FALSE;
                if((newHead > 168) && (newHead < 179)) return FALSE;
                if((newHead > 179) && (newHead < 193)) return FALSE;
                if(newHead > 194) return FALSE;
}
        //Half-elf female
        else if(iGender == GENDER_FEMALE && iBaseRace == 4) {
                if(newHead == 58) return FALSE;
                if(newHead == 78) return FALSE;
                if(newHead == 94) return FALSE;
                if((newHead > 129) && (newHead < 135)) return FALSE;
                if(newHead == 139) return FALSE;
                if(newHead == 176) return FALSE;
                if(newHead == 177) return FALSE;
                if(newHead > 215) return FALSE;
}
        //Half-orc female
        else if(iGender == GENDER_FEMALE && iBaseRace == 5) {
                if((newHead > 22) && (newHead < 133)) return FALSE;
                if((newHead > 134) && (newHead < 150)) return FALSE;
                if((newHead > 154) && (newHead < 163)) return FALSE;
                if(newHead > 163) return FALSE;
}
        //Human female
        else if(iGender == GENDER_FEMALE && iBaseRace == 6) {
                if(newHead == 58) return FALSE;
                if(newHead == 78) return FALSE;
                if(newHead == 94) return FALSE;
                if((newHead > 129) && (newHead < 135)) return FALSE;
                if(newHead == 139) return FALSE;
                if(newHead == 176) return FALSE;
                if(newHead == 177) return FALSE;
                if(newHead > 215) return FALSE;
}
    return TRUE;
}
