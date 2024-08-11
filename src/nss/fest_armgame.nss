void main(){

    int animation = GetLocalInt(OBJECT_SELF, "animation");

    if(animation > 0){
        object pc    = GetLastUsedBy();
        float facing = GetFacing(OBJECT_SELF);
        location plc = GetLocation(OBJECT_SELF);

        if(facing <= 180.0){
            facing = facing + 180.0;
        }
        else{
            facing = facing - 180.0;
        }

        AssignCommand(pc, ActionMoveToLocation(plc, FALSE));
        AssignCommand(pc, ActionPlayAnimation(animation, 1.0, 3600.0));
        DelayCommand(2.5, AssignCommand(pc, SetFacing(facing)));
    }
    else{
        ExecuteScript("x2_plc_used_sit", OBJECT_SELF);
    }

    SetLocalInt(OBJECT_SELF, "user_sat", 1);

    if(GetTag(OBJECT_SELF) == "arm_seat1"){
        object pc = GetLastUsedBy();
        SetLocalInt(OBJECT_SELF, "strMod",GetAbilityModifier(ABILITY_STRENGTH, pc));
        SetLocalInt(OBJECT_SELF, "conMod",GetAbilityModifier(ABILITY_CONSTITUTION, pc));
        SetLocalString(OBJECT_SELF, "player1Name",GetName(pc));

        object opponent = GetNearestObjectByTag("arm_seat2");
        int opponentSat = GetLocalInt(opponent, "user_sat");
        int player1STR  = GetLocalInt(OBJECT_SELF, "strMod");
        int player1CON  = GetLocalInt(OBJECT_SELF, "conMod");
        int player2STR  = GetLocalInt(opponent, "strMod");
        int player2CON  = GetLocalInt(opponent, "conMod");
        if(opponentSat == 1){
            int player1Score = player1STR + player1CON;
            int player2Score = player2STR + player2CON;

            if(player1Score > player2Score){
                object table       = GetNearestObjectByTag("arm_table");
                string player1Name = GetLocalString(OBJECT_SELF,"player1Name");

                AssignCommand(table,(DelayCommand(1.0, ActionSpeakString("<cwþþ>*You begin to wrestle...*</c>"))));
                AssignCommand(table,(DelayCommand(3.0, ActionSpeakString("<cwþþ>*There is some back and forth... a bit of grunting...*</c>"))));
                AssignCommand(table,(DelayCommand(6.0, ActionSpeakString("<cwþþ>*With a triumphant thud,</c> "+player1Name+" <cwþþ>wins!*</c>"))));
            }
            else if(player2Score > player1Score){
                object table       = GetNearestObjectByTag("arm_table");
                string player2Name = GetLocalString(opponent, "player2Name");

                AssignCommand(table,(DelayCommand(1.0, ActionSpeakString("<cwþþ>*You begin to wrestle...*</c>"))));
                AssignCommand(table,(DelayCommand(3.0, ActionSpeakString("<cwþþ>*There is some back and forth... a bit of grunting...*</c>"))));
                AssignCommand(table,(DelayCommand(6.0, ActionSpeakString("<cwþþ>*With a triumphant thud,</c> "+player2Name+" <cwþþ>wins!*</c>"))));
            }
            else{
                object table   = GetNearestObjectByTag("arm_table");

                AssignCommand(table,(DelayCommand(1.0, ActionSpeakString("<cwþþ>*You begin to wrestle...*</c>"))));
                AssignCommand(table,(DelayCommand(3.0, ActionSpeakString("<cwþþ>*There is some back and forth... a bit of grunting...*</c>"))));
                AssignCommand(table,(DelayCommand(5.0, ActionSpeakString("<cwþþ>*The struggle continues for some time...*</c>"))));
                AssignCommand(table,(DelayCommand(8.0, ActionSpeakString("<cwþþ>*The players eventually break away, unable to budge the other. It's a tie!*</c>"))));
            }
        }
        else{
            AssignCommand(OBJECT_SELF,ActionSpeakString("<cwþþ>*Waiting for opponent...*</c>", TALKVOLUME_TALK));
        }
    }
    else if(GetTag(OBJECT_SELF) == "arm_seat2"){
        object pc = GetLastUsedBy();
        SetLocalInt(OBJECT_SELF, "strMod",GetAbilityModifier(ABILITY_STRENGTH, pc));
        SetLocalInt(OBJECT_SELF, "conMod",GetAbilityModifier(ABILITY_CONSTITUTION, pc));
        SetLocalString(OBJECT_SELF, "player2Name",GetName(pc));

        object opponent = GetNearestObjectByTag("arm_seat1");
        int opponentSat = GetLocalInt(opponent, "user_sat");
        int player2STR  = GetLocalInt(OBJECT_SELF, "strMod");
        int player2CON  = GetLocalInt(OBJECT_SELF, "conMod");
        int player1STR  = GetLocalInt(opponent, "strMod");
        int player1CON  = GetLocalInt(opponent, "conMod");
        if(opponentSat == 1){
            int player1Score = player1STR + player1CON;
            int player2Score = player2STR + player2CON;

            if(player1Score > player2Score){
                object table       = GetNearestObjectByTag("arm_table");
                string player1Name = GetLocalString(opponent,"player1Name");

                AssignCommand(table,(DelayCommand(1.0, ActionSpeakString("<cwþþ>*You begin to wrestle...*</c>"))));
                AssignCommand(table,(DelayCommand(3.0, ActionSpeakString("<cwþþ>*There is some back and forth... a bit of grunting...*</c>"))));
                AssignCommand(table,(DelayCommand(6.0, ActionSpeakString("<cwþþ>*With a triumphant thud,</c> "+player1Name+" <cwþþ>wins!*</c>"))));
            }
            else if(player2Score > player1Score){
                object table       = GetNearestObjectByTag("arm_table");
                string player2Name = GetLocalString(OBJECT_SELF, "player2Name");

                AssignCommand(table,(DelayCommand(1.0, ActionSpeakString("<cwþþ>*You begin to wrestle...*</c>"))));
                AssignCommand(table,(DelayCommand(3.0, ActionSpeakString("<cwþþ>*There is some back and forth... a bit of grunting...*</c>"))));
                AssignCommand(table,(DelayCommand(6.0, ActionSpeakString("<cwþþ>*With a triumphant thud,</c> "+player2Name+" <cwþþ>wins!*</c>"))));
            }
            else{
                object table   = GetNearestObjectByTag("arm_table");

                AssignCommand(table,(DelayCommand(1.0, ActionSpeakString("<cwþþ>*You begin to wrestle...*</c>"))));
                AssignCommand(table,(DelayCommand(3.0, ActionSpeakString("<cwþþ>*There is some back and forth... a bit of grunting...*</c>"))));
                AssignCommand(table,(DelayCommand(5.0, ActionSpeakString("<cwþþ>*The struggle continues for some time...*</c>"))));
                AssignCommand(table,(DelayCommand(8.0, ActionSpeakString("<cwþþ>*The players eventually break away, unable to budge the other. It's a tie!*</c>"))));
            }
        }
        else{
            AssignCommand(OBJECT_SELF,ActionSpeakString("<cwþþ>*Waiting for opponent...*</c>", TALKVOLUME_TALK));
        }
    }
}

