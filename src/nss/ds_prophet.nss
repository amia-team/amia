int GetGameDays();
void divine_wrath(object oTarget);
void fall(object oTarget);
void excuses(object oTarget);


void main(){

    object oArea=GetArea(OBJECT_SELF);
    int nDaysRunning = GetGameDays();
    int nDaysDelay=GetLocalInt(OBJECT_SELF,"Delay");
    int nDie=d12();

    if(nDaysRunning>nDaysDelay){

        SetLocalInt(OBJECT_SELF,"Delay",(nDaysRunning+10));

        if(nDie == 1){SpeakString("I seeeeee that ....Mask will bless your honesty!");}
        if(nDie == 2){SpeakString("I am afraid Ilmater will torture your carcass till death follows, friend!");}
        if(nDie == 3){SpeakString("I tell you, those highwaymen are Lathander's working!");}
        if(nDie == 4){SpeakString("Praise Kelemvor for all those fabulous raise scrolls!");}
        if(nDie == 5){SpeakString("Tempus will certainly bless you with a peaceful life and old age!");}
        if(nDie == 6){SpeakString("Waukeen has teached us to live an ascetic life! Give your money to the poor!");}
        if(nDie == 7){SpeakString("I see... Kohlingen is truly blessed by Bane!");}
        if(nDie == 8){SpeakString("In Lloth's name: come together and be happy!");}
        if(nDie == 9){SpeakString("Lovitar and Salandra... a perfect match!");}
        if(nDie == 10){SpeakString("Worship Shar like the moon and you will find true happiness!");}
        if(nDie == 11){SpeakString("Umberlee... she truly smiles upon you, sailor!");}
        if(nDie == 12){SpeakString("Selune should have aborted you, imputent dimwit!");}

        DelayCommand(1.0,divine_wrath(OBJECT_SELF));

    }
    else{
        if(nDie == 1){SpeakString("No! I don't say a WORD!");}
        if(nDie == 2){SpeakString("I learned! I learned!");}
        if(nDie == 3){SpeakString("I don't know ANY of those names!");}
        if(nDie == 4){SpeakString("Ilma- Who?!");}
        if(nDie == 5){SpeakString("Pweep!");}
        if(nDie == 6){SpeakString("No comments!");}
        if(nDie == 7){SpeakString("There's prophecy, and there's lightning!");}
        if(nDie == 8){SpeakString("Pity on me... pity!");}
        if(nDie == 9){SpeakString("Prophecy? Never heard of him!");}
        if(nDie == 10){SpeakString("I don't know ANYTHING!");}
        if(nDie == 11){SpeakString("Go away!");}
        if(nDie == 12){SpeakString("No, no and ...NO!");}
    }

}

void divine_wrath(object oTarget){

    // Create the effects
    effect eLightning = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    effect eSmoke = EffectVisualEffect(VFX_DUR_GHOST_SMOKE);
    effect eKnockDown=EffectKnockdown();

    //smoke and lightning
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget,2.5);


    DelayCommand(0.0,SetCreatureAppearanceType(oTarget,APPEARANCE_TYPE_SKELETON_PRIEST));
    DelayCommand(1.0,excuses(oTarget));
    DelayCommand(1.5,SetCreatureAppearanceType(oTarget,APPEARANCE_TYPE_HUMAN));
    DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockDown, oTarget,6.0));
    DelayCommand(2.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSmoke, oTarget,5.0));

}




void excuses(object oTarget){

    //random oneliner
    int nDie=d12();

    //speak it
    if(nDie == 1){AssignCommand(oTarget,SpeakString("Awww... don't do THAT!"));}
    if(nDie == 2){AssignCommand(oTarget,SpeakString("AARGHHHHHH!"));}
    if(nDie == 3){AssignCommand(oTarget,SpeakString("What did I do wrong THIS TIME?"));}
    if(nDie == 4){AssignCommand(oTarget,SpeakString("No! Not AGAIN!"));}
    if(nDie == 5){AssignCommand(oTarget,SpeakString("Please? Don't do that again?"));}
    if(nDie == 6){AssignCommand(oTarget,SpeakString("HELP!"));}
    if(nDie == 7){AssignCommand(oTarget,SpeakString("OUCH!"));}
    if(nDie == 8){AssignCommand(oTarget,SpeakString("Pardon your servant!"));}
    if(nDie == 9){AssignCommand(oTarget,SpeakString("No! No! No!"));}
    if(nDie == 10){AssignCommand(oTarget,SpeakString("Save me!"));}
    if(nDie == 11){AssignCommand(oTarget,SpeakString("I am doomed!"));}
    if(nDie == 12){AssignCommand(oTarget,SpeakString("Why can't I shut my mouth?!"));}

}

int GetGameDays(){
    int nCurrentDay = GetCalendarDay();
    int nCurrentMonth = GetCalendarMonth();
    int nCurrentYear = GetCalendarYear();
    int nDaysRunning = nCurrentDay + ((nCurrentMonth-1)*28) + ((nCurrentMonth-1)*28*12);

    return nDaysRunning;
}
