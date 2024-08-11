void main(){

    object pc  = GetLastAttacker(OBJECT_SELF);
    int strMod = GetAbilityModifier(ABILITY_STRENGTH, pc);
    int delay         = GetLocalInt(OBJECT_SELF, "delay");
    string winName    = GetLocalString(OBJECT_SELF, "win_name");
    string winBio     = GetLocalString(OBJECT_SELF, "win_bio");
    string winMessage = GetLocalString(OBJECT_SELF, "win_message");
    string hostSet    = GetLocalString(OBJECT_SELF, "host");
    object host       = GetNearestObjectByTag(hostSet);

    if(!delay == 1){
        if(strMod < 1){
            AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*pip*</c> <cþ  >Score: 0.</c> <cwþþ>*The weight does not budge. Why are you playing this game?*</c>",TALKVOLUME_TALK));
        }

        else if(strMod < 6 && strMod > 0){
            AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*thump*</c> <cÿÌr>Score: 2.</c> <cwþþ>*The weight moves. Kind of. It's a terrible score.*</c>",TALKVOLUME_TALK));
        }

        else if(strMod < 11 && strMod > 5){
            AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*Thunk!*</c> <c¹­ÿ>Score: 7.</c> <cwþþ>*The weight rises and almost seems capable of reaching the bell, but falls just short. Not a bad score, though.*</c>",TALKVOLUME_TALK));
        }

        else if(strMod < 16 && strMod > 10){
            AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*DING!*</c> <c4ÿ~>Score: 10!</c> <cwþþ>*The weight slams into the bell, making it vibrate loudly. You got the top score!*</c>",TALKVOLUME_TALK));
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

        else if(strMod >= 16){
            AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*DI-CRAAACK! The weight smacks into the bell and breaks it in half, and then flies off into the stratosphere, never to be seen again.*</c>",TALKVOLUME_TALK));
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
                SendMessageToPC(pc, winMessage+" You did technically earn it.");
                SetLocalInt(OBJECT_SELF, "delay", 1);
                DelayCommand(12.0, DeleteLocalInt(OBJECT_SELF, "delay"));
                AssignCommand(host, DelayCommand(2.0, ActionSpeakString("*Goes about fixing the bell with a Mending spell and replacing the weight - as if they'd seen this coming.*",TALKVOLUME_TALK)));
            }
            else{
                SendMessageToPC(pc, "You already have a voucher. You cannot win this game again. Turn the voucher in for a prize!");
            }
        }
        SetLocalInt(OBJECT_SELF, "delay", 1);
        DelayCommand(12.0, DeleteLocalInt(OBJECT_SELF, "delay"));
    }
}
