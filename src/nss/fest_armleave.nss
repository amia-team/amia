void main(){

    object pc    = GetExitingObject();
    object seat1 = GetNearestObjectByTag("arm_seat1");
    object seat2 = GetNearestObjectByTag("arm_seat2");
    int seatSet  = GetLocalInt(OBJECT_SELF, "seat");

    if(seatSet == 1){
        if(GetIsObjectValid(seat1)){
            DeleteLocalInt(seat1, "user_sat");
            DeleteLocalInt(seat1, "player1Name");
            AssignCommand(seat1, ActionSpeakString("*Player left the table.*"));
        }
        else{
            SendMessageToPC(pc, "Game trigger not set correctly. Please report.");
        }
    }
    else if(seatSet == 2){
        if(GetIsObjectValid(seat2)){
            DeleteLocalInt(seat2, "user_sat");
            DeleteLocalInt(seat2, "player1Name");
            AssignCommand(seat2, ActionSpeakString("*Player left the table.*"));
        }
        else{
            SendMessageToPC(pc, "Game trigger not set correctly. Please report.");
        }
    }
}
