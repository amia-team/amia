void main(){

    object pc  = GetLastAttacker(OBJECT_SELF);
    int strMod = GetAbilityModifier(ABILITY_STRENGTH, pc);

    if(strMod < 1){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cw��>*pip*</c> <c�  >Score: 0.</c> <cw��>*The weight does not budge. Why are you playing this game?*</c>",TALKVOLUME_TALK));
    }

    if(strMod < 6 && strMod > 0){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cw��>*thump*</c> <c��r>Score: 2.</c> <cw��>*The weight moves. Kind of. It's a terrible score.*</c>",TALKVOLUME_TALK));
    }

    if(strMod < 11 && strMod > 5){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cw��>*Thunk!*</c> <c���>Score: 7.</c> <cw��>*The weight rises and almost seems capable of reaching the bell, but falls just short. Not a bad score, though.*</c>",TALKVOLUME_TALK));
    }

    if(strMod < 16 && strMod > 10){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cw��>*DING!*</c> <c4�~>Score: 10!</c> <cw��>*The weight slams into the bell, making it vibrate loudly. You got the top score!*</c>",TALKVOLUME_TALK));
    }

    if(strMod >= 16){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cw��>*DI-CRAAACK! The weight smacks into the bell and breaks it in half, and then flies off into the stratosphere, never to be seen again.*</c>",TALKVOLUME_TALK));
    }
}
