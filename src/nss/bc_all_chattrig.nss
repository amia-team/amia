/*  Bardic College - Trigger based ambient chatter script.

    --------
    Verbatim
    --------
    Walk on the trigger, local NPCs spout out a random line.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    101206  Aleph       Initial release.
    012307  Aleph       Twilight Stage revision.
    012607  kfw         Grammar correction.
    2007-02-06 disco    Indentation, censoring and lowering of firing chance
    ----------------------------------------------------------------------------

*/


void main(){

    int iChance = d10();

    if (iChance > 9){

        object oPC = GetEnteringObject();

        string sTrigger = GetTag(OBJECT_SELF);

        int iChatter = d3();

        ////////////////////////////////////
        //  Kitty trio chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_kitty" && GetLocalInt(OBJECT_SELF, "nc_npc_kitty") == 0){

            switch(iChatter){

                case 1:

                SetLocalInt(OBJECT_SELF, "nc_npc_kitty", 1);
                AssignCommand(GetObjectByTag("bc_npc_lordkitty"), SpeakString ("And don't you become blackguards without asking your mother first!"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_kitt"), SpeakString ("We won't, daddy.  *Grins mischievously.*")));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_katt"), SpeakString ("We won't, daddy.  *Grins mischievously.*")));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "nc_npc_kitty", 0));
                break;

                case 2:

                SetLocalInt(OBJECT_SELF, "nc_npc_kitty", 1);
                AssignCommand(GetObjectByTag("bc_npc_lordkitty"), SpeakString ("And don't even think about dropping out after three semesters to become arcane archers!"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_kitt"), SpeakString ("Yes, daddy.  *Frowns*")));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_katt"), SpeakString ("Yes, daddy.  *Frowns*")));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "nc_npc_kitty", 0));
                break;

                case 3:

                SetLocalInt(OBJECT_SELF, "nc_npc_kitty", 1);
                AssignCommand(GetObjectByTag("bc_npc_lordkitty"), SpeakString ("And I swear, if you ever come home with a boney arm..."));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_kitt"), SpeakString ("We won't, daddy.  *Frowns*")));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_katt"), SpeakString ("We won't, daddy.  *Frowns*")));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "nc_npc_kitty", 0));
                break;

            }
        }

        ////////////////////////////////////
        //  Arguing bards chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_bards" && GetLocalInt(OBJECT_SELF, "nc_npc_bards") == 0){

            switch(iChatter){

                case 1:
                SetLocalInt(OBJECT_SELF, "nc_npc_bards", 1);
                AssignCommand(GetObjectByTag("bc_npc_purebard"), SpeakString ("Yes but what about the most exquisite art of masterful communication?!"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_rdd"), SpeakString ("Whos needs tos talk whens yous got kukris...?")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_purebard"), SpeakString ("Oh my gods!  *Faints!*")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_purebard"), ActionPlayAnimation (ANIMATION_LOOPING_DEAD_FRONT, 1.0, 5.0)));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "nc_npc_bards", 0));
                break;

                case 2:
                SetLocalInt(OBJECT_SELF, "nc_npc_bards", 1);
                AssignCommand(GetObjectByTag("bc_npc_purebard"), SpeakString ("But...  but...   to be a virtuoso!  What of the love of melodic versification?"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_rdd"), SpeakString ("Mes not knows much abouts singing...  mes just came for wings!")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_purebard"), SpeakString ("Oh heavens!  *Faints!*")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_purebard"), ActionPlayAnimation (ANIMATION_LOOPING_DEAD_FRONT, 1.0, 5.0)));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "nc_npc_bards", 0));
                break;

                case 3:
                SetLocalInt(OBJECT_SELF, "nc_npc_bards", 1);
                AssignCommand(GetObjectByTag("bc_npc_purebard"), SpeakString ("Then...  *surely* you understand that the persuit of knowledge is by far the grandest of all struggles!"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_rdd"), SpeakString ("Me too dumbs tos open a door on my owns, buts me can kersplode you wits one hits!  HAH!")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_purebard"), SpeakString ("Oghma, take me away!  *Faints!*")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_purebard"), ActionPlayAnimation (ANIMATION_LOOPING_DEAD_FRONT, 1.0, 5.0)));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "nc_npc_bards", 0));
                break;

            }
        }

        ////////////////////////////////////
        //  Portal guy chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_portal" && GetLocalInt(OBJECT_SELF, "nc_npc_portal") == 0){

            switch(iChatter){

                case 1:
                SetLocalInt(OBJECT_SELF, "nc_npc_portal", 1);
                AssignCommand(GetObjectByTag("bc_npc_puffy"), SpeakString ("Oh I get so absolutely giddy when semesters start!  I just want to FLY!"));
                DelayCommand(2.0, AssignCommand(GetObjectByTag("bc_npc_puffy"), ActionUseFeat(FEAT_WHIRLWIND_ATTACK, OBJECT_SELF)));
                DelayCommand(6.0, AssignCommand(GetObjectByTag("bc_npc_puffy"), SpeakString ("*Coughs *  Nothing to see here!  Move along!")));
                DelayCommand(6.0, SetLocalInt(OBJECT_SELF, "nc_npc_portal", 0));
                break;

                case 2:
                SetLocalInt(OBJECT_SELF, "nc_npc_portal", 1);
                AssignCommand(GetObjectByTag("bc_npc_puffy"), SpeakString ("My my...  Look at all the beautiful young WOMEN.  Why, I hardly know what to do with you lovely LADIES!  Because...  it's...   you know, LADIES I'm into."));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "nc_npc_portal", 0));
                break;

                case 3:
                SetLocalInt(OBJECT_SELF, "nc_npc_portal", 1);
                AssignCommand(GetObjectByTag("bc_npc_puffy"), SpeakString ("I don't care what you all might have heard...  I assure you I am quite happily married to a woman!  And yet, I vigorously pursue more women by the day!  Yes sirrie...  I'm all about the LASSES."));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "nc_npc_portal", 0));
                break;

            }

        }

        ////////////////////////////////////
        //  Tiefling and aasimar chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_tiefaas" && GetLocalInt(OBJECT_SELF, "nc_npc_tiefaas") == 0){

            switch(iChatter){

                case 1:
                SetLocalInt(OBJECT_SELF, "nc_npc_tiefaas", 1);
                AssignCommand(GetObjectByTag("bc_npc_tief"), SpeakString ("And I was like, 'But I want to be a bard!' and he was like 'Bard!?  You're not even a half orc!  I'm leaving!'  Then he left to join a monestary!"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_aas"), SpeakString ("Druids can be real jerks...")));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "nc_npc_tiefaas", 0));
                break;

                case 2:
                SetLocalInt(OBJECT_SELF, "nc_npc_tiefaas", 1);
                AssignCommand(GetObjectByTag("bc_npc_aas"), SpeakString ("And he was like, 'But you're not evil!  How can you be an aasimar?'"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_tief"), SpeakString ("No!  He didn't!  And then what happened?")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_aas"), SpeakString ("I killed him and ate his heart.")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_tief"), ActionPlayAnimation (ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 3.0)));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "nc_npc_tiefaas", 0));
                break;

                case 3:
                SetLocalInt(OBJECT_SELF, "nc_npc_tiefaas", 1);
                AssignCommand(GetObjectByTag("bc_npc_tief"), SpeakString ("And she was like, 'Tiefling bard?  Puh-lease.  You're not even a real tiefling.  You just tell people that so they think you're overcoming adversity!'"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_aas"), SpeakString ("That harlot!  I'll bet she's not even a real half dracolich.")));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "nc_npc_tiefaas", 0));
                break;

            }

        }

        ////////////////////////////////////
        //  Perv chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_pervcon" && GetLocalInt(OBJECT_SELF, "bc_npc_pervcon") == 0){

            switch(iChatter){

                case 1:
                SetLocalInt(OBJECT_SELF, "bc_npc_pervcon", 1);
                AssignCommand(GetObjectByTag("bc_npc_perv"), SpeakString ("*Mutters* Let's see... N...  N-e... N-e-c... N-e-c-r..."));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_pervbot"), SpeakString ("The books on *cough* reincarnation are on the bottom shelf, sir. ")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_perv"), SpeakString ("Wha-what?  No!  I w-was looking for a book on...   Necreba!  Yeah... Necreba, that ... uhhh.. exotic queen! ")));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "bc_npc_pervcon", 0));
                break;

                case 2:
                SetLocalInt(OBJECT_SELF, "bc_npc_pervcon", 1);
                AssignCommand(GetObjectByTag("bc_npc_perv"), SpeakString ("*Mutters* D...  D-e...  D-e-m... D-e-m-o..."));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_pervbot"), SpeakString ("We don't sell that trash here!")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_perv"), SpeakString ("What?!  No!  I'm, just looking for a book on, um...   Demonstrations... you know for .. urr.. teaching!!")));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "bc_npc_pervcon", 0));
                break;

                case 3:
                SetLocalInt(OBJECT_SELF, "bc_npc_pervcon", 1);
                AssignCommand(GetObjectByTag("bc_npc_perv"), SpeakString ("*Mutters* How to Club a Seal...  How to Knit a Mitten..."));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_pervbot"), SpeakString ("How to Rule The Universe in Three Days is on the top shelf, sir.")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_perv"), SpeakString ("I hate you...")));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "bc_npc_pervcon", 0));
                break;

            }

        }

        ////////////////////////////////////
        //  Darklore chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_darkfeed" && GetLocalInt(OBJECT_SELF, "bc_npc_darkfeed") == 0) {

            switch(iChatter){

                case 1:
                SetLocalInt(OBJECT_SELF, "bc_npc_darkfeed", 1);
                AssignCommand(GetObjectByTag("bc_npc_feeder"), SpeakString ("'The Complete Book of Women Who Still Love Men on Amia'?  Book?  It's a bloody pamphlet!  Eat it, Bloop."));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_darklore"), SpeakString ("*Bloop*")));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "bc_npc_darkfeed", 0));
                break;

                case 2:
                SetLocalInt(OBJECT_SELF, "bc_npc_darkfeed", 1);
                AssignCommand(GetObjectByTag("bc_npc_feeder"), SpeakString ("'The Cleric Who Heals'  Hah!  Whoever heard of such rubbish? Eat it, Bloop."));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_darklore"), SpeakString ("*Bloop*")));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "bc_npc_darkfeed", 0));
                break;

                case 3:
                SetLocalInt(OBJECT_SELF, "bc_npc_darkfeed", 1);
                AssignCommand(GetObjectByTag("bc_npc_feeder"), SpeakString ("'Killing in Eldath's Name'  Sweet feathery Torm!  Eat it at once, Bloop!"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_darklore"), SpeakString ("*Bloop*")));
                DelayCommand(5.0, SetLocalInt(OBJECT_SELF, "bc_npc_darkfeed", 0));
                break;

            }

        }

        ////////////////////////////////////
        //  Loreghost chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_seek" && GetLocalInt(OBJECT_SELF, "bc_npc_seek") == 0){

            switch(iChatter){

                case 1:
                SetLocalInt(OBJECT_SELF, "bc_npc_seek", 1);
                AssignCommand(GetObjectByTag("bc_npc_seeker"), SpeakString ("I am an ageless spirit, child, drifting through eternity in an endless pursuit of knowledge and-"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_loregirl1"), SpeakString ("Does this robe make me look fat?")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_seeker"), SpeakString ("There are some questions that I dare not attempt to answer...")));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "bc_npc_seek", 0));
                break;

                case 2:
                SetLocalInt(OBJECT_SELF, "bc_npc_seek", 1);
                AssignCommand(GetObjectByTag("bc_npc_loregirl1"), SpeakString ("And she was like, 'Duh, it's a Harper pendant' and I was like 'Oh puh-lease, that is so an symbol of Cyric.'"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_seeker"), SpeakString ("But...  they look nothing alike...")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_loregirl1"), SpeakString ("Cyric plays lyre, right?")));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "bc_npc_seek", 0));
                break;

                case 3:
                SetLocalInt(OBJECT_SELF, "bc_npc_seek", 1);
                AssignCommand(GetObjectByTag("bc_npc_loregirl1"), SpeakString ("*Sighs* How come I always get stuck carrying the books?"));
                DelayCommand(5.0, AssignCommand(GetObjectByTag("bc_npc_seeker"), SpeakString ("I am an incorporeal being.")));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_loregirl1"), SpeakString ("Oh that's real convenient. *Rolls eyes*")));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "bc_npc_seek", 0));
                break;

            }

        }


        ////////////////////////////////////
        //  Halifast chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_halifast" && GetLocalInt(OBJECT_SELF, "bc_npc_halifast") == 0){

            switch(iChatter){

                case 1:
                SetLocalInt(OBJECT_SELF, "bc_npc_halifast", 1);
                AssignCommand(GetObjectByTag("bc_npc_bigjon"), SpeakString ("Why....  in my day, we didn't have any of those fancy portals and portal wands... If I wanted to go to the Abyss, I took out a shovel and started diggin!"));
                AssignCommand(GetObjectByTag("bc_npc_bigjon"), ActionPlayAnimation (ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 10.0));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_oshi"), SpeakString ("*Squawk!*  Took him a hundred years!  Took him a hundred years!")));
                DelayCommand(15.0, AssignCommand(GetObjectByTag("bc_npc_bigjon"), SpeakString ("And it took me a hundred years, it did!  And by the time you reached the first layer you were an old fart who couldn't fight and you got skinned by an incubus and you liked it, you liked it just fine!")));
                DelayCommand(20.0, SetLocalInt(OBJECT_SELF, "bc_npc_halifast", 0));
                break;

                case 2:
                SetLocalInt(OBJECT_SELF, "bc_npc_halifast", 1);
                AssignCommand(GetObjectByTag("bc_npc_bigjon"), SpeakString ("Bah...  In my day, we didn't have any scantily clad warrior women in chainmail bikinis!"));
                AssignCommand(GetObjectByTag("bc_npc_bigjon"), ActionPlayAnimation (ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 10.0));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_oshi"), SpeakString ("*Squawk!*  Hairy chested chickens!  Hairy chested chickens!")));
                DelayCommand(15.0, AssignCommand(GetObjectByTag("bc_npc_bigjon"), SpeakString ("They could crush a man's skull with their thighs and grind it to diamonds and we liked it!  We liked it just fine!")));
                DelayCommand(20.0, SetLocalInt(OBJECT_SELF, "bc_npc_halifast", 0));
                break;

                case 3:
                SetLocalInt(OBJECT_SELF, "bc_npc_halifast", 1);
                AssignCommand(GetObjectByTag("bc_npc_bigjon"), SpeakString ("In my day...  Ye were a bard and a bard forever and if you didn't like it, too bloody bad!  Ye should've been born a damned fighter if you wanted to swing a sword!  Ye were *supposed* to stand around in battle and sing yer lungs bloody and run and run some more until ye died!"));
                AssignCommand(GetObjectByTag("bc_npc_bigjon"), ActionPlayAnimation (ANIMATION_LOOPING_TALK_FORCEFUL, 1.0, 10.0));
                DelayCommand(10.0, AssignCommand(GetObjectByTag("bc_npc_oshi"), SpeakString ("*Squawk!*  Boney arse tail!  Boney arse tail!")));
                DelayCommand(15.0, AssignCommand(GetObjectByTag("bc_npc_bigjon"), SpeakString ("There was none of this 'Oh I think I'll take up Pale Mastery today and grow a bone out my ... and fight Torm himself with one hand tied behind my back to my boney you-know-whats!'  And we liked it, we liked it just fine!")));
                DelayCommand(20.0, SetLocalInt(OBJECT_SELF, "bc_npc_halifast", 0));
                break;

            }

        }

        ////////////////////////////////////
        //  Inkeep chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_innk" && GetLocalInt(OBJECT_SELF, "bc_npc_innk") == 0){

            switch(iChatter){

                case 1:
                SetLocalInt(OBJECT_SELF, "bc_npc_innk", 1);
                AssignCommand(GetObjectByTag("bc_npc_innkeeper"), SpeakString ("The finest inns and waterin' holes on all the isle!  I've got rooms in every one of them, perfect for escapin a pryin wife!"));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "bc_npc_innk", 0));
                break;

                case 2:
                SetLocalInt(OBJECT_SELF, "bc_npc_innk", 1);
                AssignCommand(GetObjectByTag("bc_npc_innkeeper"), SpeakString ("We've got inns for tall folk, inns for short folk, inns for equally short but stubbier folk...  we even got inns for ya tailed and winged freaks!"));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "bc_npc_innk", 0));
                break;

                case 3:
                SetLocalInt(OBJECT_SELF, "bc_npc_innk", 1);
                AssignCommand(GetObjectByTag("bc_npc_innkeeper"), SpeakString ("We've got doors to all yer favorite inns 'round the isle!  Why?  Because we're a bunch of pansies who don't like walkin!  Hah!"));
                DelayCommand(10.0, SetLocalInt(OBJECT_SELF, "bc_npc_innk", 0));
                break;

            }

        }


        ////////////////////////////////////
        //  Muse chatter
        ////////////////////////////////////

        if(sTrigger == "bc_npc_muse1" && GetLocalInt(OBJECT_SELF, "bc_npc_muse1") == 0){

            SetLocalInt(OBJECT_SELF, "bc_npc_muse1", 1);
            AssignCommand(GetObjectByTag("bc_npc_muse"), ActionJumpToObject(GetObjectByTag("bc_twilight_muse_wp1")));
            DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), GetObjectByTag("bc_npc_muse")));
            DelayCommand(2.0, AssignCommand(GetObjectByTag("bc_npc_muse"), SpeakString ("Absorb thyself in this great sea of the waters of life. Dive deep in it-- until thou hast lost thyself. And having lost thyself, then thou shalt find thyself again. Even as it is written, 'She had her dwelling in the great sea-- and was a fish therein.'")));
            DelayCommand(15.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), GetObjectByTag("bc_npc_muse")));
            DelayCommand(15.5, AssignCommand(GetObjectByTag("bc_npc_muse"), ActionJumpToObject(GetObjectByTag("bc_twilight_muse_wp4"))));
            DelayCommand(16.0, SetLocalInt(OBJECT_SELF, "bc_npc_muse1", 0));
        }

        if(sTrigger == "bc_npc_muse2" && GetLocalInt(OBJECT_SELF, "bc_npc_muse2") == 0){
            SetLocalInt(OBJECT_SELF, "bc_npc_muse2", 1);
            AssignCommand(GetObjectByTag("bc_npc_muse"), ActionJumpToObject(GetObjectByTag("bc_twilight_muse_wp2")));
            DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), GetObjectByTag("bc_npc_muse")));
            DelayCommand(2.0, AssignCommand(GetObjectByTag("bc_npc_muse"), SpeakString ("From mine unfathomable will, the universe hath its beginning. In my boundless wisdom are the types and patterns of all things.")));
            DelayCommand(15.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), GetObjectByTag("bc_npc_muse")));
            DelayCommand(15.5, AssignCommand(GetObjectByTag("bc_npc_muse"), ActionJumpToObject(GetObjectByTag("bc_twilight_muse_wp4"))));
            DelayCommand(16.0, SetLocalInt(OBJECT_SELF, "bc_npc_muse2", 0));
        }

        if(sTrigger == "bc_npc_muse3" && GetLocalInt(OBJECT_SELF, "bc_npc_muse3") == 0){
            SetLocalInt(OBJECT_SELF, "bc_npc_muse3", 1);
            AssignCommand(GetObjectByTag("bc_npc_muse"), ActionJumpToObject(GetObjectByTag("bc_twilight_muse_wp3")));
            DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), GetObjectByTag("bc_npc_muse")));
            DelayCommand(2.0, AssignCommand(GetObjectByTag("bc_npc_muse"), SpeakString ("Changeless, this great deep of elemental water remaineth forever pure. Because of this, it possesseth the quality of stability. From water do all forms have their beginning.")));
            DelayCommand(15.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), GetObjectByTag("bc_npc_muse")));
            DelayCommand(15.5, AssignCommand(GetObjectByTag("bc_npc_muse"), ActionJumpToObject(GetObjectByTag("bc_twilight_muse_wp4"))));
            DelayCommand(16.0, SetLocalInt(OBJECT_SELF, "bc_npc_muse3", 0));
        }
    }
}
