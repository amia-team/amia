//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_triggers
//group:   triggers
//used as: this script acts as an universal trigger handler
//date:    may 19 2007
//author:  disco


//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void ds_trigger_message( object oPC, string sTrigger, string sMessage );
void ds_chitchat( object oPC, object oTrigger );
string ds_gossipsA( int nCategory, int nNumber );
string ds_commentsA( int nCategory, int nNumber );
string ds_gossipsB( int nCategory, int nNumber );
string ds_commentsB( int nCategory, int nNumber );
void ds_dimminglight( object oArea );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //variables
    object oPC       = GetEnteringObject();     //who triggers the trigger?
    object oArea     = GetArea(oPC);            //I can't imagine I won't need this soon
    object oTarget;                             //Most of the time the target of the script
    string sEnterTag = GetTag(OBJECT_SELF);     //The name of the trigger, to be used in the if/then
    string sMessage;                            //The message that is send to or spoken by oTarget
    location lTarget;                           //location of oTarget

    //Quit if the entering object isn't a PC
    if ( GetIsPC( oPC ) == FALSE ){

        return;
    }

    if( sEnterTag == "ds_chitchat" ){

        ds_chitchat( oPC, OBJECT_SELF );
    }
    else if ( sEnterTag == "ds_dimminglight" ){

        ds_dimminglight( oArea );
    }
}


//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------

//This function sends a message and makes sure the same trigger isn't saying this until another message has been received
void ds_trigger_message(object oPC, string sTrigger, string sMessage){

    if ( GetLocalString(oPC,"tha_last_message")!=sTrigger){

        SendMessageToPC(oPC,sMessage);
        SetLocalString(oPC,"tha_last_message",sTrigger);
    }
}

//makes each waypoint deliver a story/prayer once a minute, if triggered.
void ds_chitchat(object oPC, object oTrigger){

    //variables
    object oTarget;     //NPC that starts gossip
    object oTarget2;    //NPC that comments
    object oModule =    GetModule();     //module
    int nCategory;      //gossips/comments are sorted into categories
    string sGossip;     //Gossip line
    string sComment;    //Comment line
    int nSelection;     //Selection with in each catagory

    //exit on hidden PCs
    if ( GetStealthMode( oPC ) == STEALTH_MODE_ACTIVATED ){

        return;
    }

    //don't fire if the trigger has been used less than a minute ago
    if ( GetLocalInt( oTrigger, "used" ) == 0 && d20() == 5 ){

        //get the right NPCs
        oTarget  = GetNearestObjectByTag( "ds_npc", oPC );
        oTarget2 = GetNearestObjectByTag( "ds_npc", oTarget );

        if ( oTarget == OBJECT_INVALID || oTarget2 == OBJECT_INVALID ){

            oTarget  = GetNearestObjectByTag( "ds_npc_guard", oPC );
            oTarget2 = GetNearestObjectByTag( "ds_npc_guard", oTarget );

        }
    if(GetLocalInt( oModule, "Module" )==2)
    {
        //get random oneliners
            nCategory   = 1 + Random( 4 );
            sGossip     = ds_gossipsB( nCategory, ( 1 + Random( 20 ) ) );
            sComment    = ds_commentsB( nCategory, ( 1 + Random( 15 ) ) );
    }
    else
    {
            //get random oneliners
            nCategory   = 1 + Random( 4 );
            nSelection  = 1 + Random( 16 );
            sGossip     = ds_gossipsA( nCategory, nSelection );
            sComment    = ds_commentsA( nCategory, nSelection );
    }


    if ( sGossip != "" ){
            AssignCommand( oTarget, SpeakString( sGossip ) );
    }
        if (  sComment != "" ){
            DelayCommand( 3.0, AssignCommand( oTarget2, SpeakString( sComment ) ) );
        }

        //makes sure this trigger isn't delivering a message every enter
        SetLocalInt( oTrigger, "used", 1 );
        DelayCommand( 60.0, SetLocalInt( oTrigger, "used", 0 ) );
    }
}

string ds_gossipsA( int nCategory, int nNumber ){

    if ( nCategory == 1 ){

        switch ( nNumber ){

            case 1: return "Thank the gods for adventurers! They finally did something about those damned kobolds in the Frontier! "; break;
            case 2: return "We buried my father on Moribund. I'm still afraid to go there even though it's Hallowed now. Will he still be in his grave?"; break;
            case 3: return "If we don't send adventurers to cull those orcs in the Frontier, they'll cull us first."; break;
            case 4: return "You can find anything you need at the Merchant's Hall!"; break;
            case 5: return "My cousin was chopping down a tree in Amia Forest until he was chased out by a pack of wild badgers!"; break;
            case 6: return "Never forget the destruction the Arcanum has wrought."; break;
            case 7: return "Haulfest finally made Nurse Hatchett an honest woman!"; break;
            case 8: return "You know Griff at the Nomad's Return? He used to be an adventurer!"; break;
            case 9: return "When's the next festival in Bendir Dale?"; break;
            case 10: return "A grubby urchin nicked my coinpurse!"; break;
            case 11: return "Any word on when Ostland will start exporting their exotic fruit?"; break;
            case 12: return "I had a nice cushy job stamping paperwork half the day in the Commonwealth Center. Then the Amnish came."; break;
            case 13: return "I'm fresh off the boat from the mainland, and I must say, I expected there to be a lot more seagulls in Southport."; break;
            case 14: return "Who has fresher fish at market, Southport or Moonpier?"; break;
            case 15: return "Look at some of these adventurers, walking around wearing their coin on their sleeves. They're the new noble caste."; break;
            case 16: return "How can we hope to protect ourselves against evil magicians who employ blood ma-"; break;
        }
    }
    else if ( nCategory == 2 ){

        switch ( nNumber ){

            case 1: return "I miss throwing rotten fruit at lawless adventurers on the rack."; break;
            case 2: return "If we keep shipping overland, we're just arming the orcish hordes. We need smaller, faster seaworthy vessels!"; break;
            case 3: return "Locksmiths: never go adventuring without one."; break;
            case 4: return "Pinky's Pawns moved to the seedy side of town. Suits the grubby little half-pint."; break;
            case 5: return "There are a lot more elves in Southport these days than there used to be."; break;
            case 6: return "I used to be an adventurer, but then I-"; break;
            case 7: return "All of my holdings in Helmsport were ruined when the natives attacked! It's only a matter of time before the debt collectors come for me...'"; break;
            case 8: return "What's a word that rhymes with Forrstakkr?"; break;
            case 9: return "I hope the Lathandran healers can get rid of this rash. It burns like the hells!"; break;
            case 10: return "Ridgewood is part of Cetha. Now I don't have to negotiate with those dimwits for a good bulk rate on lumber."; break;
            case 11: return "Before you criticize someone, you should walk a mile in their shoes."; break;
            case 12: return "...and so the tiefling tells me he's ready to settle down and start a family while the aasimar's just out to have a little fun, no strings attached. My mind was blown!"; break;
            case 13: return "Another long night at The Gentlemen's Club?"; break;
            case 14: return "So I was thinking of running for public office..."; break;
            case 15: return "The island of Caraigh is cursed! The undead roam at night! You'd have to be crazy to live there."; break;
            case 16: return "Did you know that Tuigans eat horses?"; break;
        }
    }
    else if ( nCategory == 3 ){

        switch ( nNumber ){

            case 1: return "If there's one thing I wanna do before I go, it's see a real live dragon!"; break;
            case 2: return "For the sake of our farmlands, speak no ill of Talos."; break;
            case 3: return "How can I become a Roadwarden?"; break;
            case 4: return "That middlin' child of yours in trouble with Oleg again?"; break;
            case 5: return "Everything in Moonpier tastes like fish."; break;
            case 6: return "No matter whether you think you can or think you can't, you're right."; break;
            case 7: return "Dad's sending me on a two year apprenticeship in Barak Runedar before I take over the jeweler's store."; break;
            case 8: return "Southport used to be called the City of Tolerance back in the Duke's day."; break;
            case 9: return "Did you find any treasure at the rainbow's terminus?"; break;
            case 10: return "Galverson's a traitor! First the whole drow debacle and then trying to depose the Commonwealth?"; break;
            case 11: return "Amia has fallen prey to so many wars. The Horde, the Dark Flight, the Arcanum..."; break;
            case 12: return "Oh Chauntea, it's the cutest thing! In the Dale, they grow these little baby carrots and new potatoes! Little food for little people!"; break;
            case 13: return "How long you think it's going to be until Ruathym and Luskan finally have it out?"; break;
            case 14: return "Where can a mercenary find work on this island?"; break;
            case 15: return "Kohlingen jumped into bed with Waterdeep. Gods save us, we're gonna have Waterdhavian nobility gatecrashing Amia before you know it."; break;
            case 16: return "She was there when he lost his foot to the devilfish, when his boatbuilding business sank, when his brother was hanged, when he fell off the roof and broke his back and now she's at his deathbed every day as he gets sicker. What a dedicated wife."; break;
        }
    }
    else if ( nCategory == 4 ){

        switch ( nNumber ){

            case 1: return "Justicar Marinsbane was a great spiritual leader. He will be missed."; break;
            case 2: return "Adventurers, you'll not find goods any better than the ones you can find in Southport!"; break;
            case 3: return "What's going on with the price of zinc? It was booming for a while there."; break;
            case 4: return "If you aren't wearing Arwen, you aren't Amian."; break;
            case 5: return "What's the one place in Southport where you can get clean and dirty at the same time?"; break;
            case 6: return "I'll never go back to the Gentleman's Club! I was hustled!"; break;
            case 7: return "Forrstakkr's a lucrative marketplace if you can earn the trust of the locals. The fur trade is especially profitable."; break;
            case 8: return "She told them that naughty children wind up in the Manor, a bleak and lonely castle in a frozen wasteland."; break;
            case 9: return "The Roadwardens try to maintain signage on the roads to warn travelers about dangerous paths."; break;
            case 10: return "Where there's a will, I want to be in it!"; break;
            case 11: return "I miss the clockworks from the old days. It costs far less to maintain a clockwork than to pay living wages for a grousing Westie layabout who does half the job in twice the time."; break;
            case 12: return "Rogues do it from behind!"; break;
            case 13: return "The Seven Stars Academy is a conspiracy, taking all of the magically talented youth from Southport and brainwashing them. They'll come back to us as nothing more than pious overseers!"; break;
            case 14: return "You've been restless lately. What's wrong?"; break;
            case 15: return "If not for the Amian Recorder, I wouldn't have a clue about what's going down!"; break;
            case 16: return "Crime doesn't pay."; break;
        }
    }
    return "";
}

string ds_commentsA( int nCategory, int nNumber ){

    if ( nCategory == 1 ){

        switch ( nNumber ){

            case 1: return "Yeah, thanks a lot. Now the stinking greenskins have moved in. If it isn't one pest, it's another."; break;
            case 2: return "Maybe best you never know."; break;
            case 3: return "Yes, but can the adventurers be trusted?"; break;
            case 4: return "Damn, and here I blew all my Monties in dragon dice..."; break;
            case 5: return "Your cousin should know better. We have an agreement with the druids who live there to leave the trees be."; break;
            case 6: return "After the things I saw, I couldn't even if I wanted to."; break;
            case 7: return "I know, I was at the wedding! The Temple of the Triad in Kohlingen is a beautiful place for a ceremony."; break;
            case 8: return "There's hope for them after all!"; break;
            case 9: return "Every day's a festival in the Dale!"; break;
            case 10: return "Probably a West Southport brat. I hear the criminals there exploit children all the time."; break;
            case 11: return "Soon, I hope!"; break;
            case 12: return "A pox on Amn!"; break;
            case 13: return "Long story, outlander."; break;
            case 14: return "You ever smelled a fish market? Nothing fresh about it!"; break;
            case 15: return "Makes 'em easier marks for a West Southport thug."; break;
            case 16: return "-shhh! Don't even say it aloud! Let that taboo be forgot to all tongues, 'lest its promise of power corrupt even more."; break;
        }
    }
    else if ( nCategory == 2 ){

        switch ( nNumber ){

            case 1: return "Catch a boat to Wiltun! They let you throw all the wormy apples you want at tax evaders."; break;
            case 2: return "A preposterous proposal, what with all the pirates parading about the bay! If you stick to Roadwarden protected roads, shipping by cart is perfectly safe."; break;
            case 3: return "Good luck finding ones what work on the cheap."; break;
            case 4: return "Aye, he be following the coin."; break;
            case 5: return "Bloody knife ears are gettin' too big for Elftown."; break;
            case 6: return "-please, you've told that story a thousand times."; break;
            case 7: return "Tsk tsk. Never put all your Helmites in one temple."; break;
            case 8: return "*Blank stare*"; break;
            case 9: return "You've been kissing Gypsy again, haven't you?"; break;
            case 10: return "Well, that's the price of freedom."; break;
            case 11: return "Oh, no, I would never speak ill of the dead."; break;
            case 12: return "Polygamy is the answer!"; break;
            case 13: return "Hurgh, yar. Went to bed with an elf and woke up with a dwarf."; break;
            case 14: return "It would be wiser to run from it."; break;
            case 15: return "I hear there's an asylum for the deranged there, so you're probably right!"; break;
            case 16: return "Take a look at all the horses around here and you'd think the same thing about Amians."; break;
        }
    }
    else if ( nCategory == 3 ){

        switch ( nNumber ){

            case 1: return "I was there at Wyrmfall and I'd be happy to ne'er see another so long as I live."; break;
            case 2: return "When the Minister blasphemed, I saw his hand reach down from the clouds, his fingers roaring funnels of wind."; break;
            case 3: return "I hear it's invitation only. Secret handshake and hidden lodges and all that guff."; break;
            case 4: return "Yes, kicking chickens on the farm. Calls it chickenball. There's something wrong with that boy."; break;
            case 5: return "Even the ale, blech."; break;
            case 6: return "...where'd you read that, in one of those Kara-Turan crackers?"; break;
            case 7: return "Dress warm and learn to love mead."; break;
            case 8: return "Seemed a good business model at the time til you accounted for the vampires, necromancers, tieflings, Harpers and other monsters that ran amok."; break;
            case 9: return "Just a haunted castle in the Forest of Despair. I treasure my life, so I got outta there!"; break;
            case 10: return "Say that again and I'll break your teeth on the cobblestones."; break;
            case 11: return "Unless the settlements cooperate and militarize, the adventurers alone may not be enough to save us."; break;
            case 12: return "Adorable!"; break;
            case 13: return "The moment Lord Wiltun figures he's got something to prove. Hear he's working on building the biggest war vessel what anyone ever built."; break;
            case 14: return "Just about anywhere, really. Everyone's got something they need done and don't wanna get their hands dirty doing it."; break;
            case 15: return "There goes all the waterfront property."; break;
            case 16: return "She sounds more like bad luck to me."; break;
        }
    }
    else if ( nCategory == 4 ){

        switch ( nNumber ){

            case 1: return "He will be. Not sure how I feel about a woman being the spiritual backbone of the community."; break;
            case 2: return "*Stage aside* Indeed. And we've made sure of that."; break;
            case 3: return "A dwarven miner found a healthy deposit east of here in a hillside, but dealers say he's gone off his keg and collapsed the mine."; break;
            case 4: return "*Looks down at own wardrobe in shame*"; break;
            case 5: return "The Temple of Love! Bless Sharess!"; break;
            case 6: return "Hey, who coulda known he was a cleric of Savras?"; break;
            case 7: return "But a man can only take so much whale blubber and salty bread."; break;
            case 8: return "Some nerve, that governess, filling my children's heads with horror stories! And here I always thought dwarven women were level-headed."; break;
            case 9: return "And to lure adventurers to their doom, I'd wager."; break;
            case 10: return "Why aren't you a regular chuckle factory?"; break;
            case 11: return "Clockwork constructs cannot be trusted. Too many golems in their gears, especially when one tinkerer goes sour. You remember why we dismantled them in the first place, don't you?"; break;
            case 12: return "And while you're flanked, pinned, unconscious or completely helpless. So, not really a girl's ideal love interest."; break;
            case 13: return "Remember the Arcanum taking over the entire Ministry of Magic? Maybe a little oversight ain't such a bad thing."; break;
            case 14: return "I've grown weary of this rat race. The Lemur Monastery in the Skull Crags promises a simpler, easier life. Maybe it is time I broaden my horizons."; break;
            case 15: return "I've had a subscription for years and I still have no idea."; break;
            case 16: return "Yeah, it steals."; break;
        }
    }
    return "";
}

string ds_gossipsB( int nCategory, int nNumber ){

    if ( nCategory == 1 ){

        switch ( nNumber ){

            case  1: return "I was walkin' out of towns and me swears with me own eyes, 'es goblins out there!"; break;
            case  2: return "I saw some stranger headed toward Southport's Graveyard, but I swear, he had a tail!"; break;
            case  3: return "I 'eard that some bad Orcs were gonna choose a leader to come bust up Southport."; break;
            case  4: return "I heard that Moonpier has an extensive line of melee weapons."; break;
            case  5: return "Those darned druids can sure come up with some great cloaks."; break;
            case  6: return "I was warned to be wary of wild animals in the wilderness, for some may actually be shifters."; break;
            case  7: return "Haulfest and Nurse Hatchett? You'd have to be blind not to notice!"; break;
            case  8: return "A bartender is just a pharmacist with a limited inventory."; break;
            case  9: return "Generally speaking, you aren't learning much when your mouth is moving."; break;
            case 10: return "Good judgment comes from bad experience and a lot of that comes from bad judgment."; break;
            case 11: return "I didn't say it was your fault. I said I was going to blame you."; break;
            case 12: return "Never underestimate the power of stupid people in large groups."; break;
            case 13: return "The more you complain, the longer the Gods make you live."; break;
            case 14: return "Things are more like they are now than they ever were before."; break;
            case 15: return "Well if it ain't another bloody stu-- oh, hello mi'lord!"; break;
            case 16: return "I'd rather spend eternity in hell than one moment in heaven with him!"; break;
            case 17: return "Did you hear about old hermit Glovers? They say he wandered off into the forest and made a she-bear his wife!"; break;
            case 18: return "What's the difference between a farmer an' an adventurer?"; break;
            case 19: return "You know that old hag in the woods selling potions?"; break;
            case 20: return "I'd swear those Nibblers are breeding like mice!"; break;
        }
    }
    else if ( nCategory == 2 ){

        switch ( nNumber ){

            case  1: return "There are two theories to arguing with women. Neither one works."; break;
            case  2: return "An' so he says to her, real soldiers don't keep it in their sheath lass! Har har!"; break;
            case  3: return "There's a lot of places to find, only if one searches for them, I guess."; break;
            case  4: return "He told her it was a real diamond, but when she took it to Pinky's she found it was glass!"; break;
            case  5: return "... and they ran those adventurers right out of town!"; break;
            case  6: return "So after the judge had talked with the pixie, he turned to the wizard "; break;
            case  7: return "and said 'Just because you're polymorphed doesn't make it legal!'"; break;
            case  8: return "She can get moonweed from the old witch in the forest. It worked for me an the parents never even knew!"; break;
            case  9: return "I'm telling you, that gypsy was the best kisser in Southport!"; break;
            case 10: return "Well if I don't, I'll have to deal with her and I make it a point never to 'deal' with her again..."; break;
            case 11: return "I even fancied a piece on the side with a doxy, but figured I'd stand high."; break;
            case 12: return "I dunnot care rather ya wanna beat each other or bed one another says I, but ye make darned sure ye be doin' it yer own time an not on me coin!!!"; break;
            case 13: return "She looked wonderful after a few mugs of ale. He didn't expect her to be ugly by dawn!"; break;
            case 14: return "There there, what's the use of a heart if it's not meant to be broken?"; break;
            case 15: return "A diplomat is someone who can tell you to go to hell in such a way that you will look forward to the trip."; break;
            case 16: return "Always remember you're unique, just like everyone else."; break;
            case 17: return "Before you criticize someone, you should walk a mile in their shoes. "; break;
            case 18: return "That way, when you criticize them, you're a mile away and you have their shoes."; break;
            case 19: return "Friends help you move. Real friends help you move bodies."; break;
            case 20: return "I went up the Crags to visit the Lemur Monastery... you know, those monks are such a BORE!"; break;
        }
    }
    else if ( nCategory == 3 ){

        switch ( nNumber ){

            case  1: return "This island is overrun by dragons and their foul kind... It's their fault everything is going wrong! I wish we had some brave knights who would slay them all."; break;
            case  2: return "The harvest was poor this year, it aint going to be enough to feed all hungry mouths. Many will be starving, unless something is done."; break;
            case  3: return "The roads are very unsafe to ambushes, so I hear."; break;
            case  4: return "Only way I'd work for him again is if Igor paid me to dig his grave!"; break;
            case  5: return "That's not the only thing in Moonpier that smells like rotten fish... you should try the ale."; break;
            case  6: return "If you get to it and you can't do it, well there you jolly well are, aren't you."; break;
            case  7: return "Never ask a barber if he thinks you need a haircut."; break;
            case  8: return "City of tolerance my foot! The next time I see one of those vampiric drow necromancers I'll take out my old cudgel and slay it myself!"; break;
            case  9: return "There are dark secrets hidden in that haunted forest. I heard my wife's brothers friend walked in there and never came back. It must be those mages in that tower, they are up to something, I am sure!"; break;
            case 10: return "Did you know that Galverson is really a demon prince in disguise? You didn't hear it from me though, I don't need the wrath of the Abyss upon me!"; break;
            case 11: return "This island has no end of wars! If it isn't the Horde, then it's the drow or the living dead! It's all those adventurers fault, they attract trouble like flies to horse dung!"; break;
            case 12: return "Those damned druids! Their wolves always come down to feed on the cattle. Soon there will be nothing left for us."; break;
            case 13: return "I got a letter from my brother who lives on the mainland... Seems there is trouble brewing there, an army of orcs I heard! We best stock up on supplies, because soon there will no trade."; break;
            case 14: return "Hells, that lass I had my eyes on ran off with some adventurer woman... Girls in love with girls, its just wrong mate... They're all wytches I tell you!"; break;
            case 15: return "It is far more impressive when others discover your good qualities without your help."; break;
            case 16: return "Give a man a fish and he will eat for a day. Teach him how to fish, and he will sit in a boat and drink beer all day."; break;
            case 17: return "They married over the broomstick at midwinter, but he had a drab by Spring!"; break;
            case 18: return "Some people are only alive because it is illegal to kill them."; break;
            case 19: return "It's lonely at the top, but you eat better."; break;
            case 20: return "Poor sod! And what will happen with his wife and 16 children?"; break;
        }
    }
    else if ( nCategory == 4 ){

        switch ( nNumber ){

            case  1: return "Did you hear about the child that was using rotten fruit as sling ammunition?"; break;
            case  2: return "How DARE they sell better items everywhere else than here in Southport!"; break;
            case  3: return "My friend says that there's an imp in Wyrmhold which sells some items, but he's very unfair in his prices."; break;
            case  4: return "Can you believe she actually wore white to the wedding?"; break;
            case  5: return "Last tenday, her and all of her sisters spent the entire day at the bathouse!"; break;
            case  6: return "You know what Uncle Sam caught today?! A fish as big as me leg! I swear it with me own two eyes!"; break;
            case  7: return "Cats big enough to kill a man!"; break;
            case  8: return "Be nice to your kids. They'll choose your nursing home."; break;
            case  9: return "It may be that your sole purpose in life is simply to serve as a warning to others."; break;
            case 10: return "When there's a will, I want to be in it."; break;
            case 11: return "Women who seek to be equal to men lack ambition."; break;
            case 12: return "You're just jealous because the voices are talking to me and not you!"; break;
            case 13: return "Your kid may be a mage, but you're still an idiot."; break;
            case 14: return "Experience is what you get when you didn't get what you wanted."; break;
            case 15: return "Wear short sleeves! Support your right to bare arms!"; break;
            case 16: return "Aye lads, a finer lookin' strumpet ye cannot lay eyes upon!"; break;
            case 17: return "Despite the cost of living, have you noticed how popular it remains?"; break;
            case 18: return "He'll NEVER be able to pay for it, not in a million years!"; break;
            case 19: return "You know what I heard about Roger? He's been with that harlot from you know who!"; break;
            case 20: return "Yer just a scared little person! Put yer money where yer mouth is!"; break;
        }
    }
    return "";
}

string ds_commentsB( int nCategory, int nNumber ){

    if ( nCategory == 1 ){

        switch ( nNumber ){

            case  1: return "Lords of the Nine!"; break;
            case  2: return "Well, you can't really tarnish a rusted blade."; break;
            case  3: return "Huh?"; break;
            case  4: return "Oh! Thank you!"; break;
            case  5: return "I'd like to help, but I can't."; break;
            case  6: return "Hmmm.... yes... I see."; break;
            case  7: return "Hmmm.... no... sorry."; break;
            case  8: return "Sorry, I'm not a druid, so I cannot speak to a dog."; break;
            case  9: return "What did you say? Free gold? Sure! *Holds out hand*"; break;
            case 10: return "Well, it's a strange world, isn't it?"; break;
            case 11: return "Aww..."; break;
            case 12: return "Uhm...?"; break;
            case 13: return "Oooh....!"; break;
            case 14: return "Uh... huh..."; break;
            case 15: return "O dear!"; break;
            case 16: return "You really think so?"; break;
        }
    }
    else if ( nCategory == 2 ){

        switch ( nNumber ){

            case  1: return "Really? Tha's amazin'!"; break;
            case  2: return "Of course!"; break;
            case  3: return "I suppose so?"; break;
            case  4: return "Hah! Impressive!"; break;
            case  5: return "Thanks a million!"; break;
            case  6: return "You know what I heard?!"; break;
            case  7: return "Sure!"; break;
            case  8: return "Woo hoo!"; break;
            case  9: return "Ha ha! Yeah!"; break;
            case 10: return "Heh heh heh..."; break;
            case 11: return "Ha ha ha..."; break;
            case 12: return "Yeah! Alright!"; break;
            case 13: return "I'd hug you for this if I wasn't shy."; break;
            case 14: return "By the prophet's unkempt moustache!"; break;
            case 15: return "Yer crackin' me up!"; break;
            case 16: return "*Chuckles* That's just grand!"; break;
        }
    }
    else if ( nCategory == 3 ){

        switch ( nNumber ){

            case  1: return "Couldn't have said it better myself!"; break;
            case  2: return "That's just not proper."; break;
            case  3: return "You'd expect that, if you knew the family."; break;
            case  4: return "I'm not surprised."; break;
            case  5: return "Thats what YOU think!"; break;
            case  6: return "Tha's interestin' an' all, but when's we get to the part when you gives "; break;
            case  7: return "the gold away?"; break;
            case  8: return "I don't believe it."; break;
            case  9: return "Bleh."; break;
            case 10: return "Argh! The pain!"; break;
            case 11: return "No way!"; break;
            case 12: return "You really think so?"; break;
            case 13: return "They should putta stop on that!"; break;
            case 14: return "That's just horrible!"; break;
            case 15: return "Yeah, I wish someone would take care of it."; break;
            case 16: return "These are tough times, mate."; break;
        }
    }
    else if ( nCategory == 4 ){

        switch ( nNumber ){

            case  1: return "Tha's a load of crap."; break;
            case  2: return "No, never, and nein!"; break;
            case  3: return "Go away!"; break;
            case  4: return "Leave me alone."; break;
            case  5: return "I have no time to waste on idiots."; break;
            case  6: return "Hey, don't be pointin' that morningstar at me, pal!"; break;
            case  7: return "Sorrys, mate. I don't buy that crap."; break;
            case  8: return "Nope. No. Definetly not."; break;
            case  9: return "Oh sure, NOW you need my help."; break;
            case 10: return "I'd hit you for this if I wasn't a coward."; break;
            case 11: return "Aww... just shuttup, will you?"; break;
            case 12: return "I ent a fool, so dunt treat me like one!"; break;
            case 13: return "Everything was better in the old days."; break;
            case 14: return "Aye? Well, your mother was an orc!"; break;
            case 15: return "Get out of here, you old sod!"; break;
            case 16: return "Certainly you jest!"; break;
        }
    }
    return "";
}

void ds_dimminglight( object oArea ){

    object oPlate  = GetObjectByTag( "ds_shadow_plate" );
    effect eShadow = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eShadow, oPlate );

}
