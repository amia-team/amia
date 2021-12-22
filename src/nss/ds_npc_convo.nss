void main(){

    object oArea=GetArea(OBJECT_SELF);
    int nDie=d10();

    if(FindSubString(GetName(oArea),"Cordor: South")>-1){
        if(nDie == 1){SpeakString("Hallo! Would you care to fetch my undergarments for me?");}
        if(nDie == 2){SpeakString("I have hat! Yes. I do.");}
        if(nDie == 3){SpeakString("Ah, Cordor. Splendid little hamlet, aye?");}
        if(nDie == 4){SpeakString("The Reconstruction Project went well, aye!");}
        if(nDie == 5){SpeakString("'Ey! Er... Uh... Who are you?");}
        if(nDie == 6){SpeakString("I can smell the flowers! What fun!");}
        if(nDie == 7){SpeakString("Did you see that fish the boy down the lane caught? Won't put the dead thing down...");}
        if(nDie == 8){SpeakString("I found some seagull eggs the other day. Wicked creatures! I squashed them all!");}
        if(nDie == 9){SpeakString("What's your name?");}
        if(nDie == 10){SpeakString("I don't have any gold! I swear!");}
    }
    else{
        if(nDie == 1){SpeakString("Aren't you... *snaps fingers* ..."+RandomName()+"?!");}
        if(nDie == 2){SpeakString("Do I owe you something?");}
        if(nDie == 3){SpeakString("What are you looking at?");}
        if(nDie == 4){SpeakString("Hello! Such a long time!");}
        if(nDie == 5){SpeakString("Hmm... have you been drinking again?");}
        if(nDie == 6){SpeakString("Welcome to Cordor!");}
        if(nDie == 7){SpeakString("Greetings, stranger!");}
        if(nDie == 8){SpeakString("Waukeen's blessings!");}
        if(nDie == 9){SpeakString("Hey there!");}
        if(nDie == 10){SpeakString("Hello there!");}
    }

}
