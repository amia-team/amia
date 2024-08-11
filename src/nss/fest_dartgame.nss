void main(){

    object pc         = GetLastAttacker();
    object pcWeapon   = GetLastWeaponUsed(pc);
    int weaponType    = GetBaseItemType(pcWeapon);
    string hostSet    = GetLocalString(OBJECT_SELF, "host");
    object host       = GetNearestObjectByTag(hostSet);
    int delay         = GetLocalInt(OBJECT_SELF, "delay");
    string yell       = GetLocalString(OBJECT_SELF, "wrong_weapon");
    string winName    = GetLocalString(OBJECT_SELF, "win_name");
    string winBio     = GetLocalString(OBJECT_SELF, "win_bio");
    string winMessage = GetLocalString(OBJECT_SELF, "win_message");

    if(weaponType == BASE_ITEM_DART){
        if(delay == 0){
            int dexMod = GetAbilityModifier(ABILITY_DEXTERITY, pc);

            if(dexMod < 1){
                AssignCommand(host, DelayCommand(2.0, ActionSpeakString("*jumps out of the way of the dart!* ...Zero points!",TALKVOLUME_TALK)));
            }
            else if(dexMod < 6 && dexMod > 0){
                AssignCommand(host, DelayCommand(2.0, ActionSpeakString("*watches the dark clip off the side of the board* Eh. Two points!",TALKVOLUME_TALK)));
            }
            else if(dexMod < 11 && dexMod > 5){
                AssignCommand(host, DelayCommand(2.0, ActionSpeakString("Solid hit! 5 points!",TALKVOLUME_TALK)));
            }
            else if(dexMod > 10){
                AssignCommand(host, DelayCommand(2.0, ActionSpeakString("*jumps excitedly* Wow! That's a bulls-eye! Ten points!",TALKVOLUME_TALK)));
                string voucherTag = GetLocalString(OBJECT_SELF, "voucher");
                object voucher    = GetItemPossessedBy(pc, voucherTag);

                if(!GetIsObjectValid(voucher)){
                    object voucherNew = CreateItemOnObject("fest_voucher", pc);

                    SetTag(voucherNew, voucherTag);
                    if(winName != ""){
                        SetName(voucherNew, winName);
                    }
                    if(winBio != ""){
                        SetDescription(voucherNew, winBio);
                    }
                    SendMessageToPC(pc, winMessage);
                }
            }
            SetLocalInt(OBJECT_SELF, "delay", 1);
            DelayCommand(12.0, DeleteLocalInt(OBJECT_SELF, "delay"));
        }
    }

    else{
        if(delay == 0){
            AssignCommand(host, DelayCommand(2.0, ActionSpeakString(yell,TALKVOLUME_TALK)));
            SetLocalInt(OBJECT_SELF, "delay", 1);
            DelayCommand(12.0, DeleteLocalInt(OBJECT_SELF, "delay"));
        }
    }
}
