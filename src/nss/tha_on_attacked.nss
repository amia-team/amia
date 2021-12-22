/*
tha_on_attacked

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
Manages silly reactions when somebody attacks a plotted and immortal NPC

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
------------------------------------------------
*/

void main(){
    int nDie=d12();

    if (nDie==1){SpeakString("Haha! You can't hit me!");}
    else if (nDie==2){SpeakString("Try to hit me with your eyes OPEN!");}
    else if (nDie==3){SpeakString("Whoopsies!");}
    else if (nDie==4){SpeakString("Too slow!");}

}
