void main(){

    object pc  = GetLastAttacker(OBJECT_SELF);
    int strMod = GetAbilityModifier(ABILITY_STRENGTH, pc);

    if(strMod < 1){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*pip*</c> <cþ  >Score: 0.</c> <cwþþ>*The weight does not budge. Why are you playing this game?*</c>",TALKVOLUME_TALK));
    }

    if(strMod < 6 && strMod > 0){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*thump*</c> <cÿÌr>Score: 2.</c> <cwþþ>*The weight moves. Kind of. It's a terrible score.*</c>",TALKVOLUME_TALK));
    }

    if(strMod < 11 && strMod > 5){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*Thunk!*</c> <c¹­ÿ>Score: 7.</c> <cwþþ>*The weight rises and almost seems capable of reaching the bell, but falls just short. Not a bad score, though.*</c>",TALKVOLUME_TALK));
    }

    if(strMod < 16 && strMod > 10){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*DING!*</c> <c4ÿ~>Score: 10!</c> <cwþþ>*The weight slams into the bell, making it vibrate loudly. You got the top score!*</c>",TALKVOLUME_TALK));
    }

    if(strMod >= 16){
        AssignCommand(OBJECT_SELF, ActionSpeakString("<cwþþ>*DI-CRAAACK! The weight smacks into the bell and breaks it in half, and then flies off into the stratosphere, never to be seen again.*</c>",TALKVOLUME_TALK));
    }
}
