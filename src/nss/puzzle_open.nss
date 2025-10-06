void main(){
    object pc = GetLastOpenedBy();
    string message = GetLocalString(OBJECT_SELF, "open_message");
    if (GetIsObjectValid(pc) && message != "") FloatingTextStringOnCreature(message, pc, FALSE);
}

