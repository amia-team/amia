// includes
#include "x2_inc_switches"

void ResetDeck( object oPC, object oItem );
int GetCardNumber( object oItem, int nNumber );
void DrawCard( object oPC, object oTarget, object oItem );


void main(){

    // vars
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch(nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object oPC        = GetItemActivator();
            object oTarget    = GetItemActivatedTarget();
            object oItem      = GetItemActivated();

            //test
            SendMessageToPC( oPC, "script activated" );
            SendMessageToPC( oPC, "target: "+GetName( oTarget ) );

            if ( oTarget == oItem ){

                ResetDeck( oPC, oItem );

            }
            else if ( GetIsPC( oTarget ) ){

                DrawCard( oPC, oTarget, oItem );
            }
            else {

                return;

            }

            break;

        }

        default:{

            break;

        }

    }

    SetExecutedScriptReturnValue(nResult);

}

void ResetDeck( object oPC, object oItem ){

    //test
    SendMessageToPC( oPC, "ResetDeck" );

    int i;

    for (i=1; i<23; ++i ){

        SetLocalInt( oItem, "deck_" + IntToString( i ), 0 );

    }

    SendMessageToPC( oPC, "*You reshuffle your Tarot deck...*" );

}

int GetCardNumber( object oItem, int nNumber ){

    int nRandom = Random(22)+1;
    int nStop;
    int nCount;

    while ( nStop != 1 ){

        ++nCount;

        if (GetLocalInt( oItem, "deck_" + IntToString( nRandom ) ) != 1 ){

            nStop = 1;
            SetLocalInt( oItem, "deck_" + IntToString( nRandom ), 1 );

        }
        else if ( nCount < 23 ){

            nRandom = Random(22)+1;

        }
        else{

            nStop = 1;
            return 0;

        }
    }

    return nRandom;

}


void DrawCard( object oPC, object oTarget, object oItem ){

    //test
    SendMessageToPC( oPC, "DrawCard" );

    string sName;
    string sDescription;
    string sMeaning1;
    string sMeaning2;

    int nNumber = GetCardNumber( oItem, nNumber );

    //test
    SendMessageToPC( oPC, "Card number: "+IntToString( nNumber ) );


    switch (nNumber) {

        case 0:
             sName         = "";
             sDescription  = "";
             sMeaning1     = "Your deck is empty.";
             sMeaning2     = "Your deck is empty.";
        break;

        case 1:
             sName         = "The Fool";
             sDescription  = "a young jester in bright clothing walking forwards, his eyes covered with a blindfold, and a trail of goldcoins dropping from his pockets after him.";
             sMeaning1     = "Folly. Enthusiasm. Immaturity. Passion. Exhibitionism. Frenzy.";
             sMeaning2     = "Indecision. Apathy. Bad decision. Lack of confidence.";
        break;

        case 2:
             sName         = "I The Magician";
             sDescription  = "an old wizard in his studyroom, concentrated on the book in front of him. Multiple magical tools are on the table and a potion cauldron bubbles behind him.";
             sMeaning1     = "Creativity. Skill. Trickery. Craft. Willpower. Influence.";
             sMeaning2     = "Weakness of will. Ineptitude. Delay. Unsavoury means.";
        break;

        case 3:
             sName         = "II The High Priestess";
             sDescription  = "a beautiful woman standing in the middle of a ring of people, the full moon behind her, her hands raised in prayer, a silvery scepter in her right hand.";
             sMeaning1     = "Wisdom. Serene knowledge. Understanding. Emotionless or hidden emotion. Platonic relationships. Cruelty.";
             sMeaning2     = "Ignorance. Selfishness. Improper judgement. Shallowness.";
        break;

        case 4:
             sName         = "III The Empress";
             sDescription  = "a crowned mother on a throne, wearing royal red robes and golden jewelry. Her face bears a kind, warm smile. She holds a scepter in her left hand, and a replica of the world in her right.";
             sMeaning1     = "Developement. Accomplishment. Fertility. Mother. Practical. Loyality. Nagging. Intuition.";
             sMeaning2     = "Vacillation. Indecision. Anxiety. Infidelity.";
        break;

        case 5:
             sName         = "IV The Emperor";
             sDescription  = "an elder man sitting on a throne, wearing purple robes, golden crown on his head, and the sun behind him. He holds a scepter in his right hand and a volcanic planet replica in his left.";
             sMeaning1     = "Worldly power. Leadership. Confidence. Father. Strength.";
             sMeaning2     = "Immaturity. Inability. Weak character. Feebleness.";
        break;

        case 6:
             sName         = "V Hierophant";
             sDescription  = "a Genie-like bald and bearded man on a stone. He holds a bird in his hand, while a kitten sleeps in his lap.";
             sMeaning1     = "Ritualism. Mercy. Patience. Timidity. Servitude.";
             sMeaning2     = "Overkindness. Vulnerability. Frailty. Unorthodoxy.";
        break;

        case 7:
             sName         = "VI The Lovers";
             sDescription  = "a naked couple embracing eachother in a lush garden, standing on a bed of vines and roses.";
             sMeaning1     = "Love. Beauty. Trust. Companionship. Yearning. Freedom of emotion. Infatuation.";
             sMeaning2     = "Unreliability. Separation. Unwise plans. Fickleness.";
        break;

        case 8:
             sName         = "VII The Chariot";
             sDescription  = "a warrior standing in his chariot, pulled by a black and a white horse. He holds a spear and a shield.";
             sMeaning1     = "Turmoil. Vengeance. Conquest. Escape. Determination.";
             sMeaning2     = "Defeat. Failure. Collapse. Failure to face reality.";
        break;

        case 9:
             sName         = "VIII Justice";
             sDescription  = "a blindfolded woman, holding balanced scales in her left hand, and a sword on her right.";
             sMeaning1     = "Fairness. Justice. Harmony. Good intentions. Honor. Virtue. Equilibrium.";
             sMeaning2     = "Bias. False accusations. Abuse. Intolerance.";
        break;

        case 10:
             sName         = "IVX The Hermit";
             sDescription  = "an old hermit alone on a rock, on a small isle. Next to him is a plate of steaming food, but he ignores it, concentrating on his study.";
             sMeaning1     = "Counsel. Knowledge. Prudence. Desertion. Self-denial. Misguided. Expressionless.";
             sMeaning2     = "Hastiness. Prematurity. Foolish acts. Immaturity.";
        break;

        case 11:
             sName         = "X Wheel of Fortune";
             sDescription  = "a wheel of Fortune standing deserted and alone, with various symbols painted on its surface. It is turning slowly, about to stop. A crow sits on a nearby tree's trench, waiting.";
             sMeaning1     = "Destiny. Outcome. Felicity. Culmination. Progress for the better or worse.";
             sMeaning2     = "Failure. Ill luck. Unexpected bad fate.";
        break;

        case 12:
             sName         = "XI Strenght";
             sDescription  = "a tattoed Hercules in his animal-skin suit, ripping apart the book of knowledge, his feet sturdily buried two feet into the ground.";
             sMeaning1     = "Courage. Fortitude. Energy. Zeal. Liberation. Matter over mind.";
             sMeaning2     = "Weakness. Impotency. Abuse of power. Lack of faith.";
        break;

        case 13:
             sName         = "XII Hanged Man";
             sDescription  = "a man hanging from a tree upside down, tied from his feet. He seems indifferent to his condition, yet unable to help himself out of it.";
             sMeaning1     = "Transition. Change. Pause. Sacrifice. Passive. Apathy.";
             sMeaning2     = "Lack of sacrifice. Failure to give one's self. Futile sacrifice.";
        break;

        case 14:
             sName         = "XIII Death";
             sDescription  = "a skeleton holding a scythe in his both hands, reaping the lifeless field beneath him.";
             sMeaning1     = "Transformation. Loss. Ending. Death. A new beginning.";
             sMeaning2     = "Stagnation. Immobility. Inertia. Narrow escape.";
        break;

        case 15:
             sName         = " XIV Temperance";
             sDescription  = "a winged woman who holds two cups in her hands. From both cups, rainbow-liquid pours out, without one drop spilling on the ground.";
             sMeaning1     = "Moderation. Compromise. Patience. Fusion. Good influence. Worldly image.";
             sMeaning2     = "Discord. Hostility. Sterility. Inability to work with others.";
        break;

        case 16:
             sName         = "XV The Devil";
             sDescription  = "a horned devil sitting on his throne, hideous to look at for the humans. His eyes taunt the beholder, and his pitchfork glows red from the flames that reach from beneath.";
             sMeaning1     = "Bondage. Malevolence. Downfall. Violence. Disaster. Temptation to evil.";
             sMeaning2     = "Release from bondage. Respite. Overcoming handicaps. Overcoming fears.";
        break;

        case 17:
             sName         = "XVI The Tower";
             sDescription  = "a tower struck by lightning bursting from the dark skies. Only the top of the tower seems damaged, while the base holds strong.";
             sMeaning1     = "Sudden change. Disruption. Adversity. Havoc. Setback. Calamity. Downfall.";
             sMeaning2     = "Following old ways. Living in a rut. Continued oppression.";
        break;

        case 18:
             sName         = "XVII The Star";
             sDescription  = "a young, poetic face in the surface of a white star looking down from the sky. She tosses smaller stars down to the earth, smiling.";
             sMeaning1     = "Hope. Faith. Inspiration. Love. Happiness. Opportunity.";
             sMeaning2     = "Disappointment. Bad luck. Stubborness. Imbalance.";
        break;

        case 19:
             sName         = "XVIII The Moon";
             sDescription  = "a large, crescent moon hovering in the sky. Only one side is visible, the other being hidden by shadow.";
             sMeaning1     = "Deception. Dishonesty. Error. Double dealing. Disgrace. Trickery.";
             sMeaning2     = "Overcoming bad temptations. Gain without paying the price. Taking advantage of someone.";
        break;

        case 20:
             sName         = "XIV The Sun";
             sDescription  = "a brilliant and bright sun shining on the sky, over the moon and the stars. The rays reach down to every creature on earth.";
             sMeaning1     = "Accomplishment. Joy. Devotion. Love. Liberation. Sincerity. Success.";
             sMeaning2     = "Unhappiness. Loneliness. Clouded future. Cancelled plans.";
        break;

        case 21:
             sName         = "XX Judgement";
             sDescription  = "a blind angel blowing her horn of judgement over a necropolis. Red roses rise below, from the earth, are tangling around the tombstones.";
             sMeaning1     = "Atonement. Rebirth. Development. Promotion. Forgiveness. Confession. Redemption.";
             sMeaning2     = "Delay. Divorce. Procrastination. Disappointment.";
        break;

        case 22:
             sName         = "XXI The World";
             sDescription  = "the earth bearing a calm expression, a slight smile and a tear in the corner of her eye. The stars, the moon and the sun encircle the earth.";
             sMeaning1     = "Completion. Perfection. End result. Synthesis. Ultimate change.";
             sMeaning2     = "Imperfection. Failure. Lack of vision. Vain efforts.";
        break;

    }




    if ( d2() == 1 ){

        AssignCommand ( oPC, SpeakString( "*Draws "+sName+". The card is turned away from "+GetName(oTarget)+".*" ) );
        AssignCommand ( oPC, SpeakString( "*The card shows "+sDescription+"*", TALKVOLUME_WHISPER ) );
        DelayCommand ( 1.0, SendMessageToPC ( oPC, sName+" deals with: "+sMeaning1) );

    }
    else{

        AssignCommand ( oPC, SpeakString( "*Draws "+sName+". The card is facing "+GetName(oTarget)+".*" ) );
        AssignCommand ( oPC, SpeakString( "*The card shows "+sDescription+"*", TALKVOLUME_WHISPER ) );
        DelayCommand ( 1.0, SendMessageToPC ( oPC, sName+" deals with: "+sMeaning2) );

    }

}
