//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_journal_act
//group:   Jobs & crafting
//used as: convo action script
//date:    december 2008
//author:  disco


//-------------------------------------------------------------------------------
// changelog
//-------------------------------------------------------------------------------
// 08 March 2011 - Selmak added void ds_j_ToggleDeletion so that DMs can toggle
//                 deletion of resources from slots using the journal, and
//                 node 36 which uses that function.
// 18 June 2012  - Glim added functionality to void ds_j_PlantCrop to allow non
//                 underdark areas with the local int of Shroom to be able to
//                 plant Mushroom Farmer crops in.
// 20 Aug  2012  - Glim added new tileset options to Trapper job
// 17 Oct  2017  - Jes added new tileset options to Trapper and Market Garderner
//                 jobs.

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_j_lib"

void ds_j_DoorAction( object oPC, int nJob, object oTarget );

void ds_j_PlantCrop( object oPC, location lTarget, int nNode, int nUD=0 );

void ds_j_SetTrap( object oPC, location lTarget );

void ds_j_SpawnAnimal( object oPC, location lTarget, string sTag, int nJob );

void ds_j_DoJob( object oPC, object oTarget, object oStool, int nJob, int nCount=0 );

//creates a stool and starts one of the service jobs
void ds_j_SetupBusiness( object oPC, object oTarget, int nJob );

void ds_j_ProcessTarget( object oPC, object oTarget, int nJob );

void ds_j_SearchArea( object oPC, location lTarget, int nJob );

void ds_j_StartDigging( object oPC, location lTarget, int nJob );

void ds_j_SetupStore( object oPC, location lTarget, int nJob );

void ds_j_Announcer( object oPC );

//beggar's bowl
void ds_j_SetBowl( object oPC, location lTarget, int nJob );

void ds_j_SetDiceMat( object oPC, location lTarget, int nJob );

void ds_j_Paint( object oPC, object oTarget, object oEasel=OBJECT_INVALID, int nRound=0 );

void ds_j_Observe( object oPC, object oTarget );

void ds_j_EraseSettings( object oDM, object oPC );

void ds_j_CreateMap( object oPC );

void ds_j_ToggleDeletion( object oDM, object oPC );

void ds_j_DoorAction( object oPC, int nJob, object oTarget ){

    string sBlock = DS_J_BUSY + "_" + IntToString( nJob );
    int nCaught   = GetIsBlocked( oPC, sBlock );
    int nTime     = GetIsBlocked( oTarget, sBlock );
    //check if the find is succesful and deal with XP
    int nResult;
    int nRank;

    if ( nCaught > 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need to lay low for "+IntToString( nCaught )+" more seconds!" );
        return;
    }
    else if ( nTime > 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need to wait "+IntToString( nTime )+" seconds to make use of this door!" );
        return;
    }
    else{

        SetBlockTime( oTarget, 0, DS_J_SOURCEDELAY, sBlock );
        //SetBlockTime( oPC, 0, 1, sBlock );
    }


    if ( nJob == 67 ){

        //check if the find is succesful and deal with XP
        nResult     = ds_j_StandardRoll( oPC, nJob );
        nRank       = ds_j_GiveStandardXP( oPC, nJob, nResult );

        //burglar, generate money
        if ( nResult > 0 ){

            GiveGoldToCreature( oPC, ( d100() + ( 25 * nRank * nResult ) ) );

            if ( nResult > 1 ){

                int nDie = d6();
                object oItem;

                if ( nDie == 1 ){

                    oItem = ds_j_CreateItemOnPC( oPC, "ds_j_thin", 440, "Table Silver", "", 33 );

                    ds_j_AddMaterialProperties( oPC, oItem, 13, d3(), d2() );
                }
                else if ( nDie == 2 ){

                    oItem = ds_j_CreateItemOnPC( oPC, "ds_j_thin", 441, "Golden Cup", "", 13 );

                    ds_j_AddMaterialProperties( oPC, oItem, 8, d3(), d2() );
                }
                else if ( nDie == 3 ){

                    oItem = ds_j_CreateItemOnPC( oPC, "ds_j_thin", 442, "Bronze Statuette", "", 11 );

                    ds_j_AddMaterialProperties( oPC, oItem, 3, d3(), d2() );
                }
                else if ( nDie == 4 ){

                    oItem = ds_j_CreateItemOnPC( oPC, "ds_j_thin", 443, "Mithral Glass", "", 45 );

                    ds_j_AddMaterialProperties( oPC, oItem, 11, d3(), d2() );
                }
                else{

                    ds_j_CreateRandomGemOnPC( oPC );
                }
            }

            SendMessageToPC( oPC, CLR_ORANGE+"You break into the house and escape with the spoils!" );
        }
        else{

            SetName( oTarget, "Upset House Owner" );

            SendMessageToPC( oPC, CLR_RED+"You have to lay low for 10 minutes!" );

            SetBlockTime( oPC, 10, 0, sBlock );

            DelayCommand( 1.0, AssignCommand( oTarget, SpeakString( CLR_ORANGE + "Grab that rotten piece of "+GetRaceName( GetRaceInteger( GetRacialType( oPC ), GetSubRace( oPC ) ) )+" scum over there! Thief, filthy thief!" + CLR_END ) ) );

            DelayCommand( 2.0, SetName( oTarget, "Door" ) );
        }
    }
    else if ( nJob == 68 ){

        if ( GetPCKEYValue( oPC,  "ds_j_emotes" ) != 1 ){

            //gravedigger, generate corpse and call
            SpeakString( CLR_ORANGE+"Bring out yer dead! Bring out yer dead!"+CLR_END );

            //sound
            PlaySound( "as_cv_bell1" );
        }

        if ( GetLocalInt( oPC, DS_J_CORPSES ) ) {

            SendMessageToPC( oPC, CLR_ORANGE+"Bury your collected corpse(s) first." );
        }
        else {

            //check if the find is succesful and deal with XP
            nResult     = ds_j_StandardRoll( oPC, nJob );
            nRank       = ds_j_GiveStandardXP( oPC, nJob, nResult );

            if ( nResult > 0 ){

                object oItem = CreateItemOnObject( "ds_j_corpse", oPC );

                SetName( oItem, CLR_ORANGE + RandomName( NAME_FIRST_HUMAN_MALE ) + CLR_END );

                SendMessageToPC( oPC, CLR_ORANGE+"You collect a corpse." );

                SetLocalInt( oPC, DS_J_CORPSES, 1 );
            }
        }
    }
}

void ds_j_PlantCrop( object oPC, location lTarget, int nNode, int nUD=0 ){

    int nCrop;
    string sCrop;
    string sTileSet = GetTilesetResRef( GetArea( oPC ) );
    string sResRef  = DS_J_CROP;
    string sKey     = GetPCPublicCDKey( oPC, TRUE );
    string sTag     = sResRef+"_"+sKey;
    int nJob        = 8;
    object oArea = GetArea(oPC);

    //ugly, but alas
    if ( !nUD ){

        if ( sTileSet != TILESET_RESREF_RURAL
          && sTileSet != TILESET_RESREF_RURAL_WINTER
          && sTileSet != "ttz01"           //tropical!
          && sTileSet != "tcr10"           //City & Rural
          && sTileSet != "ttr01"           //Rural Summer
          && sTileSet != "tts01"           //Rural Winter expanded
          && sTileSet != "twl01"           //Rural Wildlands
          && sTileSet != "wsf10"           //WoRm Forest, Summer
          && sTileSet != "tno01"           //Castle Exterior, Rural
          && sTileSet != "ttw01"           //Wild Woods
          && sTileSet != "zts01" ){        //Rural Winter, Grass

            SendMessageToPC( oPC, CLR_ORANGE+"You cannot plant crops in this area."+CLR_END );
            return;
        }

        switch ( nNode ) {

            case 0:     return;
            case 1:     nCrop = 39;  sCrop = "Barley";     break;
            case 2:     nCrop = 38;  sCrop = "Cabbage";    break;
            case 3:     nCrop = 47;  sCrop = "Carrots";    break;
            case 4:     nCrop = 82;  sCrop = "Fine Herbs"; break;
            case 5:     nCrop = 65;  sCrop = "Onions";     break;
            case 6:     nCrop = 40;  sCrop = "Turnips";    break;
            case 7:     nCrop = 101; sCrop = "Cotton";     break;
            case 8:     nCrop = 207; sCrop = "Sugar Cane"; break;
            case 9:     nCrop = 417; sCrop = "Papyrus";    break;
            case 10:    nCrop = 418; sCrop = "Flowers";    break;
            case 11:    nCrop = 480; sCrop = "Tobacco";    break;
        }
    }
    else{

        if ( sTileSet != TILESET_RESREF_MINES_AND_CAVERNS
          && sTileSet != TILESET_RESREF_UNDERDARK
          && sTileSet != TILESET_RESREF_UNDERDARK
          && sTileSet != "scv01"                       //UD Mines and Caverns
          && sTileSet != "tdm01"                       //Mines and Caverns Expanded
          && sTileSet != "ttu01"                       //UD Expanded
          && GetLocalInt(oArea, "Shroom") != 1 ){      //Allows for UD crops in special areas

            SendMessageToPC( oPC, CLR_ORANGE+"You cannot plant mushrooms in this area."+CLR_END );
            return;
        }

        switch ( nNode ) {

            case 0:     return;
            case 1:     nCrop = 289;  sCrop = "Barrelstalk";      break;
            case 2:     nCrop = 290;  sCrop = "Bluecap";          break;
            case 3:     nCrop = 291;  sCrop = "Fire Lichen";      break;
            case 4:     nCrop = 313;  sCrop = "Jeran's Puffball"; break;
            case 5:     nCrop = 292;  sCrop = "Ripplebark";       break;
            case 6:     nCrop = 301;  sCrop = "Spice Trumpet";    break;
            case 7:     nCrop = 293;  sCrop = "Zurstalk";         break;
        }

        sResRef = "ds_j_crop_2";
        nJob    = 94;
    }

    int nCrops    = GetLocalInt( oPC, DS_J_CROP );

    if ( nCrops < ds_j_GetJobRank( oPC, nJob ) ){

        //keep track of number of crops
        SetLocalInt( oPC, DS_J_CROP, nCrops + 1 );

        object oCrop = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lTarget, FALSE, sTag );

        SetName( oCrop, CLR_ORANGE+sCrop+CLR_END );

        SetLocalInt( oCrop, DS_J_TIME, GetServerRunTime() );
        SetLocalInt( oCrop, DS_J_CROP, nCrop );
        SetLocalString( oCrop, DS_J_CROP, sCrop );
        SetLocalString( oCrop, DS_J_USER, GetPCPublicCDKey( oPC, TRUE ) );
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"Removing your crops..."+CLR_END );

        int i;

        for ( i=0; i<nCrops; ++i ){

            DestroyObject( GetObjectByTag( sTag, i ) );
        }

        DeleteLocalInt( oPC, DS_J_CROP );
    }
}

void ds_j_SetTrap( object oPC, location lTarget ){

    string sTileSet = GetTilesetResRef( GetArea( oPC ) );

    if ( sTileSet != TILESET_RESREF_FOREST
      && sTileSet != TILESET_RESREF_RURAL
      && sTileSet != TILESET_RESREF_UNDERDARK
      && sTileSet != TILESET_RESREF_MINES_AND_CAVERNS
      && sTileSet != TILESET_RESREF_RURAL_WINTER
      && sTileSet != "tcr10" // City/Rural Base Set
      && sTileSet != "twl01" // Rural Wildlands
      && sTileSet != "ttz01" // Tropical
      && sTileSet != "ttw01" // Wild Woods
      && sTileSet != "tts01" // Rural Winter, Expanded
      && sTileSet != "zts01" // Rural Winter, Grass
      && sTileSet != "wsf10" // WoRm Forest, Summer
      && sTileSet != "tno01" ) // Castle Exterior, Rural
    {
        SendMessageToPC( oPC, CLR_ORANGE+"You cannot set traps in this area."+CLR_END );
        return;
    }

    int nTraps = GetLocalInt( oPC, DS_J_TRAP );
    int nRank  = ds_j_GetJobRank( oPC, 5 );

    if ( nTraps < nRank ){

        //keep track of number of traps
        SetLocalInt( oPC, DS_J_TRAP, ( nTraps + 1 ) );

        object oTrap = CreateObject( OBJECT_TYPE_PLACEABLE, DS_J_TRAP, lTarget );

        SetLocalInt( oTrap, DS_J_TIME, GetServerRunTime() );
        SetLocalString( oTrap, DS_J_USER, GetPCPublicCDKey( oPC, TRUE ) );
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"You can only set as many traps at a time as you have ranks in this job."+CLR_END );
    }
}


void ds_j_SpawnAnimal( object oPC, location lTarget, string sResRef, int nJob ){

    int nAnimals  = GetLocalInt( oPC, sResRef );
    string sKey   = GetPCPublicCDKey( oPC, TRUE );
    string sTag   = sResRef+"_"+sKey;

    if ( nAnimals < ds_j_GetJobRank( oPC, nJob ) ){

        //keep track of number of animals
        SetLocalInt( oPC, sResRef, nAnimals + 1 );

        object oAnimal = CreateObject( OBJECT_TYPE_CREATURE, sResRef, lTarget, FALSE, sTag );

        SetLocalInt( oAnimal, DS_J_TIME, GetServerRunTime() );
        //SetLocalString( oAnimal, DS_J_USER, sKey );
        SetLocalObject( oAnimal, DS_J_USER, oPC );
    }
    else {

        SendMessageToPC( oPC, CLR_ORANGE+"Removing your animals..."+CLR_END );

        int i;

        for ( i=0; i<nAnimals; ++i ){

            DestroyObject( GetObjectByTag( sTag, i ) );
        }

        DeleteLocalInt( oPC, sResRef );
    }
}

void ds_j_DoJob( object oPC, object oTarget, object oStool, int nJob, int nCount=0 ){


    if ( !GetIsObjectValid( oTarget ) ){

        oTarget = GetSittingCreature( oStool );
    }

    if ( !GetIsObjectValid( oTarget ) ){

        DeleteLocalInt( oPC, DS_J_BUSY );
        DestroyObject( oStool );

        SendMessageToPC( oPC, CLR_ORANGE+"Can't find a valid target. Removing stool."+CLR_END );
        return;
    }

    if ( GetDistanceBetween( oPC, oTarget ) > 5.0 ){

        DeleteLocalInt( oTarget, DS_J_BUSY );
        DeleteLocalInt( oPC, DS_J_BUSY );
        DestroyObject( oStool );

        AssignCommand( oTarget, PlayAnimation( ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD ) );

        SendMessageToPC( oPC, CLR_ORANGE+"Distance between you and target to great. Removing stool."+CLR_END );
        return;
    }

    string sEmote;
    int nAnimation;

    if ( GetPCKEYValue( oPC,  "ds_j_emotes" ) == 1 ){

        nAnimation = ANIMATION_LOOPING_TALK_PLEADING;
    }
    else if ( nJob == 23 ){

        if ( nCount == 0 ){ sEmote = CLR_ORANGE + "*Bows down and peers into your eyes* It is said that your foes hold you in scant regard...isn't it?"; }
        if ( nCount == 1 ){ sEmote = CLR_ORANGE + "This is a mistake they often make, being arrogant and ale-sodden in equal manner. *takes a deep breath*"; }
        if ( nCount == 2 ){ sEmote = CLR_ORANGE + "*raises his voice* However! They are nothing more than sway-backed, leprous, pox-ridden children of she-wolves!"; }
        if ( nCount == 3 ){ sEmote = CLR_ORANGE + "So all you need to do is to put your trust in your gods, and your fellows, and in good steel too. *puts his hands on your shoulders and inserts a dramatic pause*"; }
        if ( nCount == 4 ){ sEmote = CLR_ORANGE + "And now... just go and kill those arse-nibbling, merkin-grabbing, loon-faced, idiot goblin-fondlers, will you? *releases his grip and nods you away*"; }

        nAnimation = ANIMATION_LOOPING_TALK_FORCEFUL;
    }
    else if ( nJob == 24 ){

        if ( nCount == 0 ){ sEmote = CLR_ORANGE + "*Invites you into a seat and immediately begins to burn small green herbs over a tiny brazier. Soon the medicated scent fills the air and opens the sinuses for easier breathing, a necessity to keep the bloodstream oxygen-rich and the body relaxed. The massage therapist then begins with a standard deep tissue massage around the neck*"; }
        if ( nCount == 1 ){ sEmote = CLR_ORANGE + "*Once the deepest muscles have been numbed into a malleable putty by skilled hands, the massage artist begins a myofascial release session, quietly moving from limb to limb and stretching them all to just a point that they begin to burn, ultimately increasing your physical range of motion*"; }
        if ( nCount == 2 ){ sEmote = CLR_ORANGE + "*Reflexology comes next; with your shoes and gloves completely removed, the massage artist rubs knuckles deep into the soft soles of both feet and the meaty palms of both hands, the primary barrier between external pressures and their impacts on the body* "; }
        if ( nCount == 3 ){ sEmote = CLR_ORANGE + "*Dunk, hiss; steam fills the air as the glowing hot stones are removed from the brazier and dropped into a bucket of warm water. The massage artist then places each strategically along the tightest muscle groups. Not only does it truly loosen all the pent-up pressures from the massage work, but it also feels wonderful*"; }
        if ( nCount == 4 ){ sEmote = CLR_ORANGE + "*With a warning to be sure to stretch liberally before any physical activity, the massage artist finishes you off with an oil or powder skin roll and pat-down, a rejuvenating form of massage that kneads you right back up, feeling loose, limber, and most importantly, unstressed*"; }
        nAnimation = ANIMATION_LOOPING_TALK_PLEADING;
    }
    else if ( nJob == 25 ){

        if ( nCount == 0 ){ sEmote = CLR_ORANGE + "*Invites you into a seat and casually explains the process of your check-up: an examination of basic vital stats, followed by a diagnosis of any illnesses, diseases, or poor health habits and the administration of a physic to start you on the road to wellness*"; }
        if ( nCount == 1 ){ sEmote = CLR_ORANGE + "*The physician's tools are primarily the knowledge of your body and how it should operate; the physician tests reflexes, diet, eyesight, hearing, blood pressure, pulse, and even conducts an examination of your oral cavity or any sensitive areas that suffer unusual itching or burning*"; }
        if ( nCount == 2 ){ sEmote = CLR_ORANGE + "*After the physical, a diagnosis is made and a solution worked out: cut out fatty foods, drink less alcohol or eat more vegetables. Stop sleeping around with unclean partners. Perhaps that soreness in your arm is a hairline fracture; your bad breath, a clear sign of halitosis, acid reflux or a rotten tooth. Or maybe you need a regimen of vitamins, stat.*"; }
        if ( nCount == 3 ){ sEmote = CLR_ORANGE + "*Now the physician breaks out the stranger tools of the trade: nibbled herbs and unguents, oils and incense, mortar, pestil, cauldron and scalpel, clamp, sterilizing alcohol and gauzy cotton swab. Whatever you need - ruptured appendix removed, a bone reset, a tooth pulled, a laceration sewn, a bloodletting - the physician has it prepared and administered*"; }
        if ( nCount == 4 ){ sEmote = CLR_ORANGE + "*There you have it. Your clean bill of health. Not only do you feel generally feel better after quaffing that bubbling tonic or leaning face down over a pot of boiling gingko biloba, but you feel enabled to lead a healthier life, secure in your constitution*"; }
        nAnimation = ANIMATION_LOOPING_TALK_PLEADING;
    }
    else if ( nJob == 26 ){

        if ( nCount == 0 ){ sEmote = CLR_ORANGE + "*Invites you into a seat to begin today's lesson. First, the trivium: a test in grammar, logic, and rhetoric. For grammar and rhetoric, if you, at the very least, use the proper pronouns 'I' and 'me' when referring to yourself and can elegantly request to use the outhouse, you pass*"; }
        if ( nCount == 1 ){ sEmote = CLR_ORANGE + "*The teacher must, however, make a test of your logic: imagine a frog resting on a lily pad in the middle of a pond. If it continues to leap half distances towards the shore, will it ever reach the shore? If you say never, you pass! The teacher will also accept frogs are good eats, yum*"; }
        if ( nCount == 2 ){ sEmote = CLR_ORANGE + "*With that prep work out of the way, the teacher can move on to the quadrivium: arithmetic, geometry, music, and astronomy. This is where the wheat is cut from the chaff. In a few short minutes, your head is swimming with numbers, shapes, notes, and contellations*"; }
        if ( nCount == 3 ){ sEmote = CLR_ORANGE + "*If the quadrivium proves to be beyond your grasp, the teacher gives you a flat board with holes in it: a square, a circle, a triangle, a rectangle, and a star! And also some very pretty colored wooden blocks! If you can get the right blocks into the holes without breaking anything, you pass!*"; }
        if ( nCount == 4 ){ sEmote = CLR_ORANGE + "*Congratulations, you've completed today's lesson! Retaining what you've learned is important, and that is your new assignment. However, until you forget everything you've been taught in this session, you feel like you can tackle any problem*"; }
        nAnimation = ANIMATION_LOOPING_TALK_PLEADING;
    }
    else if ( nJob == 27 ){

        if ( nCount == 0 ){ sEmote = CLR_ORANGE + "*Invites you into a seat, and in doing so begs the question, is this the ideal seat? Do better seats exist? Worse seats? What is a seat, and is there such a thing as a perfect seat? No, you are told, for perfection exists not as a state of being, but as a goal to which all should strive*"; }
        if ( nCount == 1 ){ sEmote = CLR_ORANGE + "*The spiritualist opens by helping you give your earthly woes up to the gods, to release those things that trouble you the most. If there are no problems, merely speak of your dreams; in the speaking, there is hearing, and in the hearing, there is knowing*"; }
        if ( nCount == 2 ){ sEmote = CLR_ORANGE + "*O what is man, that you should be mindful of him? So asks the sage, to the spirits, to the winds, to the pantheon. The mortal concerns that weigh us down are a burden that may be shared by or surrendered to greater powers, themselves the ideals of the perfection we seek*"; }
        if ( nCount == 3 ){ sEmote = CLR_ORANGE + "*Ultimately, the spiritualist, through careful listening, open communication, and wise words, guides you carefully towards epiphany, realization, revelation, gnosis or apotheosis, and in this brilliant flash, it is as though you have caught a glimpse of something greater, within you or from without*"; }
        if ( nCount == 4 ){ sEmote = CLR_ORANGE + "*The spiritualist's work is done, and you are free to walk away from this seat to find your own path, or to forge your own destiny. The route should be clearer now, if you just remember: know thyself, and never doubt what you believe*"; }
        nAnimation = ANIMATION_LOOPING_TALK_PLEADING;
    }
    else if ( nJob == 28 ){

        if ( nCount == 0 ){ sEmote = CLR_ORANGE + "*Invites you into a seat and squeezes warm water from a lambskin cloth through the hair before working in a lather to make it nice and clean for a quick trim or a full styling* "; }
        if ( nCount == 1 ){ sEmote = CLR_ORANGE + "*Opens a professional hairdresser's kit and removes several implements of the trade: a fine-toothed ivory comb, clippers, a razor with a smooth leather whet strap, a canister of greasy pomade, a gold-backed mirror and an assortment of fine colognes and perfumes.*"; }
        if ( nCount == 2 ){ sEmote = CLR_ORANGE + "*Snip snip, scrape, buff; give an adventurer a sea salt scrub, a mani-pedi, a full body oil rubdown, pluck gray hairs, give a shave and a haircut and what do they do? Run out and get roughed up. And they're back the next day with split ends and broken nails.*"; }
        if ( nCount == 3 ){ sEmote = CLR_ORANGE + "*Works busily and diligently, transforming you into a lady with an attitude, or a fella that is in the mood. Your stylist doesn't just stand there, but gets right to it, and helps you strike a pose like there's nothing to it. Vogue.*"; }
        if ( nCount == 4 ){ sEmote = CLR_ORANGE + "*Undrapes the apron and allows you to choose from the selection of fragrances: rich, dark low notes in woods and wines and subtle high notes in flowers and fruit, and applies your combination with a sprinke around the neck, head and shoulders. A quick dab of pomade in the right spot and the beautification is complete*"; }
        nAnimation = ANIMATION_LOOPING_GET_MID;
    }

    if ( nCount > 4 ){

        effect eBoost;
        effect eVFX    = EffectVisualEffect( VFX_IMP_FORTITUDE_SAVING_THROW_USE );

        //check if the find is succesful and deal with XP
        int nResult     = ds_j_StandardRoll( oPC, nJob );
        int nRank       = ds_j_GiveStandardXP( oPC, nJob, nResult );

        if ( nResult ){

            if ( nJob == 23 ){ eBoost = EffectAbilityIncrease( ABILITY_STRENGTH, nResult ); }
            if ( nJob == 24 ){ eBoost = EffectAbilityIncrease( ABILITY_DEXTERITY, nResult ); }
            if ( nJob == 25 ){ eBoost = EffectAbilityIncrease( ABILITY_CONSTITUTION, nResult ); }
            if ( nJob == 26 ){ eBoost = EffectAbilityIncrease( ABILITY_INTELLIGENCE, nResult ); }
            if ( nJob == 27 ){ eBoost = EffectAbilityIncrease( ABILITY_WISDOM, nResult ); }
            if ( nJob == 28 ){ eBoost = EffectAbilityIncrease( ABILITY_CHARISMA, nResult ); }

            float fDuration = 180.0 * nRank;

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBoost, oTarget, fDuration );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );

            SpeakString( CLR_ORANGE + "There you go!" );

            SetLocalInt( oTarget, DS_J_JOB+"_"+IntToString( nJob ), 1 );
        }
        else{

            SpeakString( CLR_ORANGE + "Hmmm... didn't really work as expected." );
            SendMessageToPC( oPC, CLR_ORANGE+"Your services do not improve your client's condition."+CLR_END );
        }

        DestroyObject( oStool );

        AssignCommand( oTarget, PlayAnimation( ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD ) );

        //unlock
        DeleteLocalInt( oPC, DS_J_BUSY );
        DeleteLocalInt( oTarget, DS_J_BUSY );

        return;
    }

    ++nCount;

    PlayAnimation( nAnimation );

    if ( sEmote != "" ){

        SpeakString( sEmote );
    }

    DelayCommand( 15.0, ds_j_DoJob( oPC, oTarget, oStool, nJob, nCount ) );
}

//creates a stool and starts one of the service jobs
void ds_j_SetupBusiness( object oPC, object oTarget, int nJob ){

    if ( !GetIsPC( oTarget ) ){

        return;
    }

    if ( GetLocalInt( oTarget, DS_J_BUSY ) || GetLocalInt( oPC, DS_J_BUSY ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"One of you is already being served."+CLR_END );
        return;
    }

    if ( GetLocalInt( oTarget, DS_J_JOB+"_"+IntToString( nJob ) ) == 1 ){

        SendMessageToPC( oPC, CLR_ORANGE+"A player can only have one application a reset."+CLR_END );
        return;
    }

    if ( GetDistanceBetween( oPC, oTarget ) > 5.0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need to get closer to your client."+CLR_END );
        return;
    }

    location lStool = GetLocation( oTarget );
    string sTag     = "ds_j_stool_"+GetPCPublicCDKey( oPC, TRUE );
    object oStool   = GetObjectByTag( sTag );

    if ( GetIsObjectValid( oStool ) ){

        oTarget = GetSittingCreature( oStool );

        AssignCommand( oTarget, PlayAnimation( ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD ) );

        DestroyObject( oStool );

        DeleteLocalInt( oTarget, DS_J_BUSY );
        DeleteLocalInt( oPC, DS_J_BUSY );

        SendMessageToPC( oPC, CLR_ORANGE+"You already had a stool spawned. Removing stool and releasing target."+CLR_END );

        return;
    }

    oStool = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_stool", lStool, 0, sTag );

    AssignCommand( oTarget, ActionSit( oStool ) );

    ActionUnlockObject( oStool );

    //lock
    SetLocalInt( oPC, DS_J_BUSY, 1 );
    SetLocalInt( oTarget, DS_J_BUSY, 1 );

    DelayCommand( 3.0, ds_j_DoJob( oPC, oTarget, oStool, nJob ) );
}

void ds_j_ProcessTarget( object oPC, object oTarget, int nJob ){

    //target processed
    DeleteLocalString( oPC, DS_J_NPC );
    DeleteLocalInt( oPC, DS_J_NPC );

    int nBlockEmotes = 0;

    if ( GetPCKEYValue( oPC,  "ds_j_emotes" ) == 1 ){

        nBlockEmotes = 1;
    }

    //some of these tasks only work if you are behind your target
    if ( nJob == 31 || nJob == 32 ){

        if ( ds_j_GetIsBehind( oTarget, oPC, 5.0 ) == FALSE ){

            SendMessageToPC( oPC, CLR_ORANGE+"Your target spots you and disappears in thin air!"+CLR_END );

            SafeDestroyObject( oTarget );

            return;
        }
    }

    //check if the find is succesful and deal with XP
    int nResult     = ds_j_StandardRoll( oPC, nJob );
    int nRank       = ds_j_GiveStandardXP( oPC, nJob, nResult, 2.0, 5.0 );

    if ( nResult <= 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"Your target disappears before your eyes!"+CLR_END );
        DelayCommand( 1.0, SafeDestroyObject( oTarget ) );
        return;
    }

    if ( nJob == 30 && nResult > 0 ){

        //exorcist
        if ( !nBlockEmotes ){

            SpeakString( CLR_ORANGE+"Foulest of demonspawn.. begone from this man!" );
        }

        effect eVFX  = EffectVisualEffect( VFX_DUR_PROTECTION_EVIL_MAJOR );
        effect eVFX2 = EffectVisualEffect( VFX_FNF_WAIL_O_BANSHEES );

        DelayCommand( 1.0, AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_LOOPING_SPASM, 1.0, 4.0 ) ) );
        DelayCommand( 1.0, AssignCommand( oTarget, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX, oTarget ) ) );
        DelayCommand( 3.0, AssignCommand( oTarget, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget ) ) );
        DelayCommand( 5.0, SetIsTemporaryFriend( oPC, oTarget ) );

        if ( nResult == 1 ){

            DelayCommand( 5.0, AssignCommand( oTarget, SpeakString( CLR_ORANGE+"YOU MAY HAVE WON NOW BUT WE WILL BE BACK!"+CLR_END ) ) );
        }
        else{

            DelayCommand( 5.0, AssignCommand( oTarget, SpeakString( CLR_ORANGE+"O dear gods.... what happened to me?!"+CLR_END ) ) );
        }

        DelayCommand( 10.0, SafeDestroyObject( oTarget ) );
    }
    else if ( nJob == 31 && nResult > 0 ){

        //spy
        ds_j_FreezePC( oPC, 15.0, CLR_ORANGE+"You start observing your target..."+CLR_END );

        DelayCommand( 5.0, AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_FIREFORGET_READ, 1.0, 6.0 ) ) );
        DelayCommand( 11.0, AssignCommand( oTarget, ActionMoveAwayFromObject( oPC ) ) );

        if ( nResult == 1 ){

            DelayCommand( 13.0, SendMessageToPC( oPC, CLR_ORANGE+"You manage to read a few bits from his letter."+CLR_END ) );
        }
        else{

            DelayCommand( 13.0, SendMessageToPC( oPC, CLR_ORANGE+"You manage to read most of his letter!"+CLR_END ) );
        }

        DelayCommand( 13.0, GiveGoldToCreature( oPC, ( 150 * nRank * nResult ) ) );
        DelayCommand( 20.0, SafeDestroyObject( oTarget ) );
    }
    else if ( nJob == 32 && nResult > 0 ){

        //thief
        ds_j_FreezePC( oPC, 15.0, CLR_ORANGE+"You start observing your target..."+CLR_END );

        DelayCommand( 5.0, AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_FIREFORGET_READ, 1.0, 6.0 ) ) );
        DelayCommand( 11.0, AssignCommand( oTarget, ActionMoveAwayFromObject( oPC ) ) );

        if ( nResult == 1 ){

            DelayCommand( 13.0, SendMessageToPC( oPC, CLR_ORANGE+"You manage to steal the papers your target was reading."+CLR_END ) );
        }
        else{

            DelayCommand( 13.0, SendMessageToPC( oPC, CLR_ORANGE+"You manage to steal the papers your target was reading, and you nick his wallet as well!"+CLR_END ) );
            DelayCommand( 13.0, GiveGoldToCreature( oPC, d20( 10 ) ) );
        }

        DelayCommand( 13.0, GiveGoldToCreature( oPC, ( 150 * nRank * nResult ) ) );
        DelayCommand( 20.0, SafeDestroyObject( oTarget ) );
    }
    else if ( nJob == 33 && nResult > 0 ){

        //witchhunter
        if ( !nBlockEmotes ){

            SpeakString( CLR_ORANGE+"Your life ends here, blasphemer!" );
        }

        effect eVFX = EffectVisualEffect( VFX_DUR_INFERNO );

        DelayCommand( 1.0, AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_LOOPING_SPASM, 1.0, 10.0 ) ) );
        DelayCommand( 1.0, AssignCommand( oTarget, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX, oTarget ) ) );

        if ( nResult == 1 ){

            DelayCommand( 5.0, AssignCommand( oTarget, SpeakString( CLR_ORANGE+"Aaaaiieee! Your efforts are in vain... we will crush you in the end!"+CLR_END ) ) );
        }
        else{

            DelayCommand( 5.0, AssignCommand( oTarget, SpeakString( CLR_ORANGE+"O dear gods.... have mercy on my wicked soul!"+CLR_END ) ) );
        }

        DelayCommand( 10.0, SafeDestroyObject( oTarget ) );
    }
    else if ( nJob == 34 && nResult > 0 ){

        //courier
        if ( !nBlockEmotes ){

            SpeakString( CLR_ORANGE+"I have a letter from your wife, Sir." );
        }

        DelayCommand( 1.0, TurnToFaceObject( oPC, oTarget ) );
        DelayCommand( 1.0, AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_FIREFORGET_GREETING, 1.0 ) ) );

        if ( nResult == 1 ){

            DelayCommand( 2.0, AssignCommand( oTarget, SpeakString( CLR_ORANGE+"Gods, can't that woman leave me alone for a while?!"+CLR_END ) ) );
        }
        else{

            DelayCommand( 2.0, AssignCommand( oTarget, SpeakString( CLR_ORANGE+"O, thank you so much. Here, a tip for the effort!"+CLR_END ) ) );
            DelayCommand( 2.0, GiveGoldToCreature( oPC, d20( 10 ) ) );
        }

        DelayCommand( 2.0, GiveGoldToCreature( oPC, ( 50 * nRank * nResult ) ) );
        DelayCommand( 5.0, SafeDestroyObject( oTarget ) );
    }
    else if ( nJob == 43 && nResult > 0 ){

        //diplomat
        if ( !nBlockEmotes ){

            SpeakString( CLR_ORANGE+"I'd like to discuss this proposal with you, Sir." );
        }

        AssignCommand( oPC, ActionPlayAnimation( ANIMATION_FIREFORGET_GREETING, 1.0 ) );

        DelayCommand( 1.0, TurnToFaceObject( oPC, oTarget ) );

        if ( !nBlockEmotes ){

            DelayCommand( 3.0, AssignCommand( oPC, SpeakString( CLR_ORANGE+"*you inform him about the proposal and do your best to make it sound like a very generous offer...*"+CLR_END ) ) );
        }
        DelayCommand( 3.0, AssignCommand( oPC, ActionPlayAnimation( ANIMATION_FIREFORGET_READ, 1.0, 6.0 ) ) );

        DelayCommand( 3.0, AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0, 6.0 ) ) );

        if ( nResult == 1 ){

            DelayCommand( 10.0, AssignCommand( oTarget, SpeakString( CLR_ORANGE+"Very well, tell your Lord that I will contact him when I return to my house."+CLR_END ) ) );
        }
        else{

            DelayCommand( 10.0, AssignCommand( oTarget, SpeakString( CLR_ORANGE+"This is a brilliant proposal! Tell your Lord that I accept his offer and conditions."+CLR_END ) ) );
            DelayCommand( 12.0, GiveGoldToCreature( oPC, d20( 10 ) ) );
        }

        DelayCommand( 10.0, GiveGoldToCreature( oPC, ( 50 * nRank * nResult ) ) );
        DelayCommand( 15.0, SafeDestroyObject( oTarget ) );
    }
}

void ds_j_SearchArea( object oPC, location lTarget, int nJob ){

    //check tiles first
    object oArea = GetArea( oPC );
    string sArea = GetLocalString( oPC, DS_J_AREA );

    if ( FindSubString( GetName( oArea ), sArea ) < 0 ) {

        SendMessageToPC( oPC, CLR_ORANGE+"This is not the region you were sent to."+CLR_END );
        return;
    }

    string sTileset = GetTilesetResRef( GetArea( oPC ) );

    if ( sTileset != TILESET_RESREF_DESERT &&
         sTileset != TILESET_RESREF_FOREST &&
         sTileset != TILESET_RESREF_FROZEN_WASTES &&
         sTileset != TILESET_RESREF_MINES_AND_CAVERNS &&
         sTileset != TILESET_RESREF_RURAL &&
         sTileset != TILESET_RESREF_RURAL_WINTER &&
         sTileset != "ttz01" &&    //tropical
         sTileset != TILESET_RESREF_UNDERDARK ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can only find resources in natural areas."+CLR_END );
        return;
    }

    object oWP   = GetNearestObjectByTag( "ds_spwn", oPC );

    if ( !GetIsObjectValid( oWP ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can only find resources in hunting areas."+CLR_END );
        return;
    }

    location lWP        = GetLocation( oWP );
    location lAreaEntry = GetLocalLocation( oPC, DS_J_AREA );
    float fDistance     = GetDistanceBetweenLocations( lTarget, lAreaEntry );
    int nSpawnTree;

    if ( fDistance < 10.0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need to go deeper into this area to find any resources."+CLR_END );
        SendMessageToPC( oPC, CLR_ORANGE+FloatToString( fDistance )+CLR_END );
        return;
    }

    //target processed
    DeleteLocalInt( oPC, DS_J_NPC );
    DeleteLocalString( oPC, DS_J_AREA );

    //check if the find is succesful and deal with XP
    int nResult     = ds_j_StandardRoll( oPC, nJob );
    int nRank       = ds_j_GiveStandardXP( oPC, nJob, nResult );

    if ( nResult <= 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You don't find anything"+CLR_END );
        return;
    }

    if ( sTileset == TILESET_RESREF_FOREST ){

        nSpawnTree = 1;
    }
    else if ( sTileset == TILESET_RESREF_RURAL || sTileset == TILESET_RESREF_RURAL_WINTER ){

        if ( d2() == 1 ){

            nSpawnTree = 1;
        }
    }

    int nDie;
    object oSource;

    if ( nSpawnTree == 1 ){

        nDie = 1 + Random( 7 ); //7 trees

        oSource = CreateObject( OBJECT_TYPE_PLACEABLE, DS_J_TREE+"_"+IntToString( nDie ), lWP );
        SendMessageToPC( oPC, CLR_ORANGE+"You spot some valuable timber close by."+CLR_END );
        return;
    }
    else if ( d4() == 3 ){

        nDie = 10 + Random( 13 ); //I pick one of gem 10-22

        oSource = CreateObject( OBJECT_TYPE_PLACEABLE, DS_J_GEM+"_0"+IntToString( nDie ), lWP );
        SendMessageToPC( oPC, CLR_ORANGE+"You spot a valuable gem deposit close by."+CLR_END );
        return;
    }
    else{

        nDie = 1 + Random( 13 ); //13 ores

        oSource = CreateObject( OBJECT_TYPE_PLACEABLE, DS_J_ORE+"_"+IntToString( nDie ), lWP );
        SendMessageToPC( oPC, CLR_ORANGE+"You spot a valuable ore deposit close by."+CLR_END );
        return;
    }

    SendMessageToPC( oPC, CLR_RED+"Error: You shouldn't reach this part of the script."+CLR_END );
}

void ds_j_StartDigging( object oPC, location lTarget, int nJob ){


    //check tiles first
    object oArea = GetArea( oPC );
    string sArea = GetLocalString( oPC, DS_J_AREA );

    if ( FindSubString( GetName( oArea ), sArea ) < 0 ) {

        SendMessageToPC( oPC, CLR_ORANGE+"This is not the region you were sent to."+CLR_END );
        return;
    }

    string sTileset = GetTilesetResRef( GetArea( oPC ) );

    if ( sTileset != TILESET_RESREF_DESERT &&
         sTileset != TILESET_RESREF_FOREST &&
         sTileset != TILESET_RESREF_FROZEN_WASTES &&
         sTileset != TILESET_RESREF_MINES_AND_CAVERNS &&
         sTileset != TILESET_RESREF_RURAL &&
         sTileset != TILESET_RESREF_RURAL_WINTER &&
         sTileset != "ttz01" &&    //tropical
         sTileset != TILESET_RESREF_UNDERDARK ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can only find resources in natural areas."+CLR_END );
        return;
    }

    object oWP   = GetNearestObjectByTag( "ds_spwn", oPC );

    if ( !GetIsObjectValid( oWP ) ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can only find resources in hunting areas."+CLR_END );
        return;
    }

    location lWP        = GetLocation( oWP );
    location lAreaEntry = GetLocalLocation( oPC, DS_J_AREA );
    float fDistance     = GetDistanceBetweenLocations( lTarget, lAreaEntry );
    int nSpawnTree;

    if ( fDistance < 10.0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need to go deeper into this area to find any resources."+CLR_END );
        SendMessageToPC( oPC, CLR_ORANGE+FloatToString( fDistance )+CLR_END );
        return;
    }

    //target processed
    DeleteLocalInt( oPC, DS_J_NPC );
    DeleteLocalString( oPC, DS_J_AREA );

    //check if the find is succesful and deal with XP
    int nResult     = ds_j_StandardRoll( oPC, nJob );
    int nRank       = ds_j_GiveStandardXP( oPC, nJob, nResult );

    if ( nResult <= 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You don't find anything"+CLR_END );
        return;
    }

    int nResource;

    switch ( d10() ) {

        case 1:     nResource = 352;   break;
        case 2:     nResource = 283;   break;
        case 3:     nResource = 284;   break;
        case 4:     nResource = 285;   break;
        case 5:     nResource = 338;   break;
        case 6:     nResource = 339;   break;
        case 7:     nResource = 340;   break;
        case 8:     nResource = 352;   break;
        case 9:     nResource = 361;   break;
        case 10:    nResource = 365;   break;
    }

    object oDig  = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_dig", lWP );

    SetLocalInt( oDig, DS_J_RESOURCE, nResource );

    SendMessageToPC( oPC, CLR_ORANGE+"You spot some interesting digging site close by."+CLR_END );
}

void ds_j_SetupStore( object oPC, location lTarget, int nJob ){

    string sTag       = DS_J_CHEST + GetPCPublicCDKey( oPC );
    object oChest     = GetObjectByTag( sTag );

    if ( oChest == OBJECT_INVALID ){

        oChest = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_trader", lTarget, 0, sTag );

        SetLocalObject( oChest, DS_J_USER, oPC );
        SetLocalInt( oChest, DS_J_JOB, nJob );


    }
    else {

        DestroyObject( oChest );
    }

    string sCategory;

    switch ( nJob ) {

        case 60:     sCategory = "Alchemy";             break;
        case 61:     sCategory = "Metal";               break;
        case 62:     sCategory = "Building Materials";  break;
        case 63:     sCategory = "Ingredients";         break;
        case 64:     sCategory = "Textile";             break;
        case 65:     sCategory = "Gem";                 break;
        case 66:     sCategory = "Herb";                break;
        case 99:     sCategory = "Food";                break;
        case 100:    sCategory = "Drinks";              break;
        default:     return;
    }

    SetName( oChest, CLR_ORANGE + GetName( oPC ) + "'s " + sCategory + " Trade Chest" + CLR_END );

    string sQuery;
    string sResource;
    string sName;
    string sDescription;
    int nAvailability;
    int i;
    int nCount;
    int nPrice;

    if ( sCategory != "" ){

        sQuery = "SELECT id, resref, icon FROM ds_j_resources WHERE category = '"+sCategory+"' AND price > 0 ORDER BY name";

        SQLExecDirect( sQuery );

        while ( SQLFetch( ) == SQL_SUCCESS ){

            ++nCount;

            sResource       = SQLGetData( 1 );
            sName           = ds_j_GetResourceName( StringToInt( sResource ) );
            nPrice          = ds_j_GetResourcePrice( StringToInt( sResource ) );

            SetLocalInt( oChest, DS_J_ID + sResource, StringToInt( SQLGetData( 3 ) ) );
            SetLocalString( oChest, DS_J_ID + sResource, SQLGetData( 2 ) );
            SetLocalInt( oChest, DS_J_RESOURCE_PREFIX+SQLGetData( 1 ), 1 );

            //WriteTimestampedLogEntry( DS_J_ID + sResource+"="+SQLGetData( 2 ) );

            sDescription += "\n * "+sName + ": " + IntToString( nPrice )+" GP";
        }

        SetLocalInt( oChest, DS_J_DONE, nCount );

        SetDescription( oChest, CLR_ORANGE+"-------------------------\nBuy Rates\n-------------------------"+CLR_END + sDescription );
    }
}


void ds_j_Announcer( object oPC ){

    if ( GetIsBlocked( oPC, DS_J_JOB+"_91" ) <= 0 ){

        SetBlockTime( oPC, 2, 0, DS_J_JOB+"_91" );
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"You can only announce once every 2 minutes!"+CLR_END );
        return;
    }

    object oArea      = GetArea( oPC );
    string sAnnouncer = GetLocalString( GetArea( oPC ), "ds_announcer" );
    string sVariable;
    string sMessage;
    int nMessages     = GetLocalInt( oArea, "m_cnt" );
    int nMessage;
    int i;

    if ( !nMessages ){

        SQLExecDirect( "SELECT message FROM messages WHERE caller_tag='"+sAnnouncer+"' AND active = 'yes'" );

        while ( SQLFetch( ) == SQL_SUCCESS ) {

            sMessage  = SQLGetData( 1 );

            if ( sMessage != "" ){

                ++i;

                sVariable = "m_"+IntToString(i);

                SetLocalString( oArea, sVariable, sMessage );
            }
        }

        SetLocalInt( oArea, "m_cnt", i );

        SendMessageToPC( oPC, CLR_ORANGE+"[debug: storing "+IntToString( i )+" messages on area]"+CLR_END );

        nMessages = i;
    }

    nMessage  = GetLocalInt( oArea, "m_i" ) + 1;

    if ( nMessage > nMessages ){

        nMessage = 1;
    }

    SetLocalInt( oArea, "m_i", nMessage );

    SendMessageToPC( oPC, CLR_ORANGE+"[debug: using message "+IntToString( nMessage )+" out of "+IntToString( nMessages )+"]"+CLR_END );

    sVariable = "m_"+IntToString( nMessage );

    sMessage  = GetLocalString( oArea, sVariable );

    if ( sMessage != "" ){

        AssignCommand( oPC, SpeakString( sMessage ) );
    }

    int nResult     = ds_j_StandardRoll( oPC, 91 );
    int nRank       = ds_j_GiveStandardXP( oPC, 91, nResult );

    GiveGoldToCreature( oPC, ( 25 * nRank * nResult ) );
}

//beggar's bowl
void ds_j_SetBowl( object oPC, location lTarget, int nJob ){

    string sTag  = DS_J_BOWL + GetPCPublicCDKey( oPC, TRUE );
    object oBowl = GetObjectByTag( sTag );

    if ( GetIsObjectValid( oBowl ) ){

        SendMessageToPC( oPC, CLR_ORANGE + "You removed your box." );

        DestroyObject( oBowl );
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"Spawning box. It can be used in two minutes." );

        oBowl = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_beggar", lTarget, 0, sTag );

        SetLocalObject( oBowl, DS_J_USER, oPC );
        SetLocalInt( oBowl, DS_J_JOB, nJob );
        SetLocalInt( oBowl, DS_J_TIME, GetServerRunTime() );
    }
}

//gambler's dicemat
void ds_j_SetDiceMat( object oPC, location lTarget, int nJob ){

    string sTag  = DS_J_MAT + GetPCPublicCDKey( oPC, TRUE );
    object oMat  = GetObjectByTag( sTag );

    if ( GetIsObjectValid( oMat ) ){

        SendMessageToPC( oPC, CLR_ORANGE + "You removed your dice mat." );

        DestroyObject( oMat );
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"Spawning dice mat. It can be used in two minutes." );

        SetLocalInt( oPC, DS_J_MAT, 1 );

        oMat = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_gambler", lTarget, 0, sTag );

        SetLocalObject( oMat, DS_J_USER, oPC );
        SetLocalInt( oMat, DS_J_JOB, nJob );
        SetLocalInt( oMat, DS_J_TIME, GetServerRunTime() );

        SetName( oMat, CLR_ORANGE+GetName( oPC )+"'s Dice Mat"+CLR_END );
    }
}

void ds_j_Paint( object oPC, object oTarget, object oEasel=OBJECT_INVALID, int nRound=0 ){

    string sTag;

    if ( GetDistanceBetween( oPC, oTarget ) > 7.0 || GetDistanceBetween( oPC, oEasel ) > 5.0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You need to stay close to your client and easel."+CLR_END );

        DeleteLocalInt( oPC, DS_J_BUSY );
        DeleteLocalInt( oTarget, DS_J_BUSY );

        SpeakString( CLR_ORANGE + "*stops painting and throws away brush*" + CLR_END );

        DestroyObject( oEasel );

        return;
    }

    if ( nRound > 10 ){

        DeleteLocalInt( oPC, DS_J_BUSY );
        DeleteLocalInt( oTarget, DS_J_BUSY );

        DestroyObject( oEasel );

        SpeakString( CLR_ORANGE + "*finishes painting*" + CLR_END );

        int nResult      = ds_j_StandardRoll( oPC, 72 );
        int nRank        = ds_j_GiveStandardXP( oPC, 72, nResult, 2.0, 5.0 );
        object oPainting = ds_j_CreateItemOnPC( oPC, "ds_j_painting",  999, "Painting of "+GetName( oTarget ) );

        ds_j_AddMaterialProperties( oPC, oPainting, 33, nRank, nResult, 37 );

        return;
    }

    if ( nRound == 0 ){

        if ( GetLocalInt( oTarget, DS_J_BUSY ) || GetLocalInt( oPC, DS_J_BUSY ) ){

            SendMessageToPC( oPC, CLR_ORANGE+"Both characters must concentrate during the creation of a masterpiece!"+CLR_END );
            return;
        }

        sTag     = "ds_j_easel_"+GetPCPublicCDKey( oPC, TRUE );
        oEasel   = GetObjectByTag( sTag );

        if ( GetIsObjectValid( oEasel ) ){

            SendMessageToPC( oPC, CLR_ORANGE+"You can only have one easel out at any time. Removing the current one!"+CLR_END );

            DestroyObject( oEasel );

            return;
        }

        oEasel = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_easel", GetLocation( oPC ), 0, sTag );

        SpeakString( CLR_ORANGE + "*starts painting*" + CLR_END );
    }
    else{

        if ( GetPCKEYValue( oPC,  "ds_j_emotes" ) == 1 ){

             PlayAnimation( ANIMATION_LOOPING_GET_MID, 1.0, 6.0 );
        }
        else{

            string sMessage = "";

            int nDie = d8();

            switch ( nDie ) {

                case 1:     sMessage += "*a dash of "; break;
                case 2:     sMessage += "*a spot of "; break;
                case 3:     sMessage += "*a touch of "; break;
                case 4:     sMessage += "*a bit of "; break;
                case 5:     sMessage += "*a modest amount of "; break;
                case 6:     sMessage += "*a flamboyant blot of "; break;
                case 7:     sMessage += "*some "; break;
                case 8:     sMessage += "*just the right amount of "; break;
            }

            nDie = d8();

            switch ( nDie ) {

                case 1:     sMessage += "pink "; break;
                case 2:     sMessage += "black "; break;
                case 3:     sMessage += "blue "; break;
                case 4:     sMessage += "white "; break;
                case 5:     sMessage += "green "; break;
                case 6:     sMessage += "violet "; break;
                case 7:     sMessage += "brown "; break;
                case 8:     sMessage += "crimson "; break;
            }

            switch ( nRound ) {

                case 1:     sMessage += "follows a quick sketch*"; break;
                case 2:     sMessage += "makes a solid foundation*"; break;
                case 3:     sMessage += "is sculpted with the back of a brush*"; break;
                case 4:     sMessage += "is worked into the background*"; break;
                case 5:     sMessage += "here and there ... and THERE!*"; break;
                case 6:     sMessage += "to highlight your noble features!*"; break;
                case 7:     sMessage += "is applied with the finest brush!*"; break;
                case 8:     sMessage += "... this will be a masterpiece!*"; break;
                case 9:     sMessage += "- o so delicate...*"; break;
                case 10:    sMessage += "as a finishing touch*"; break;
            }


            SpeakString( CLR_ORANGE + sMessage + CLR_END );

            PlayAnimation( ANIMATION_LOOPING_GET_MID, 1.0, 6.0 );
        }
    }

    ++nRound;

    //lock
    SetLocalInt( oPC, DS_J_BUSY, 1 );
    SetLocalInt( oTarget, DS_J_BUSY, 1 );

    DelayCommand( 12.0, ds_j_Paint( oPC, oTarget, oEasel, nRound ) );
}

void ds_j_Observe( object oPC, object oTarget ){

    int nJob      = 0;
    int nResource = 0;
    string sName;

    if ( GetIsBlocked( oPC, DS_J_OBSERVE ) > 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can only observe once every 5 minutes!"+CLR_END );
        return;
    }

    if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

        if ( GetIsPC( GetMaster( oTarget ) ) || GetIsPC( oTarget ) || GetIsPossessedFamiliar( oPC )){

            //bug out on PCs or associates
            SendMessageToPC( oPC, CLR_ORANGE+"You cannot use this ability on PC's or associates."+CLR_END );
            return;
        }

        //observe
        if ( GetRacialType( oTarget ) == RACIAL_TYPE_ANIMAL ){

            nJob      = 74;
            nResource = 387;
        }
        else if ( GetRacialType( oTarget ) == RACIAL_TYPE_HUMANOID_GOBLINOID ){

            nJob = 78;
            nResource = 383;
        }
        else if ( GetRacialType( oTarget ) == RACIAL_TYPE_CONSTRUCT ){

            nJob = 80;
            nResource = 381;
        }
        else if ( GetRacialType( oTarget ) == RACIAL_TYPE_MAGICAL_BEAST ){

            nJob = 81;
            nResource = 382;
        }
        else if ( GetRacialType( oTarget ) == RACIAL_TYPE_HUMANOID_ORC
               || GetRacialType( oTarget ) == RACIAL_TYPE_HALFORC ){

            nJob = 82;
            nResource = 380;
        }
        else if ( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD ){

            nJob = 83;
            nResource = 379;
        }
        else if ( GetRacialType( oTarget ) == RACIAL_TYPE_OUTSIDER
               && GetAlignmentGoodEvil( oTarget ) == ALIGNMENT_EVIL ){

            nJob = 84;
            nResource = 378;
        }
    }
    else if ( GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ){

        if ( GetTag( oTarget ) == "ds_j_herb" ){

            nJob = 75;
            nResource = 385;
        }
        else if ( GetResRef( oTarget ) == "ds_idol"
               && GetResRef( GetArea( oTarget ) ) == "khm_ds_temple" ){

            nJob = 76;
            nResource = 384;
        }
        else if ( GetResRef( oTarget ) == "ds_idol" ){

            nJob = 82;
            nResource = 482;
            sName = "Tenets of Faith: "+GetLocalString( oTarget, "name" );
        }
        else if ( GetLocalInt( oTarget, DS_J_RESOURCE ) > 150
               && GetLocalInt( oTarget, DS_J_RESOURCE ) < 154 ){

            nJob = 77;
            nResource = 386;
        }
    }

    if ( nJob > 0 ){

        if ( ds_j_GetJobRank( oPC, nJob ) < 1 ){

            SendMessageToPC( oPC, CLR_ORANGE+"You don't have the proper job to observe this creature!"+CLR_END );
            return;
        }

        object oPaper = GetItemByName( oPC, CLR_ORANGE + "Empty Pages" + CLR_END );

        if ( !GetIsObjectValid( oPaper ) ){

            //no paper
            SendMessageToPC( oPC, CLR_ORANGE+"You don't have any paper to write on!"+CLR_END );
            return;
        }

        SetBlockTime( oPC, 5, 0, DS_J_OBSERVE );

        DestroyObject( oPaper );

        int nResult  = ds_j_StandardRoll( oPC, nJob );
        int nRank    = ds_j_GiveStandardXP( oPC, nJob, nResult, 1.0, 5.0 );
        string sTag  = DS_J_RESOURCE_PREFIX + IntToString( nResource );

        if ( nResult <= 0 ){

            SendMessageToPC( oPC, CLR_ORANGE+"You have no clue..." );
        }
        else {

            object oItem = ds_j_CreateItemOnPC( oPC, "ds_j_book", nResource, sName, "", d10() );

            ds_j_AddMaterialProperties( oPC, oItem, 0, nRank, nResult );
        }
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"There's nothing to observe here." );
    }
}

void ds_j_EraseSettings( object oDM, object oPC ){

    if ( ds_j_GetTraderSlotsOccupied( oPC ) ){

        ds_j_ClearJobLog( oPC );
        SendMessageToPC( oPC, CLR_ORANGE+"Erasing Job settings..." );
        SendMessageToPC( oDM, CLR_ORANGE+"Erasing Job settings..." );
    }
    else
    {
        SendMessageToPC( oPC, CLR_ORANGE+"Erasing Job settings..." );
        SendMessageToPC( oDM, CLR_ORANGE+"Erasing Job settings..." );
    }


}

void ds_j_CreateMap( object oPC ){

    if ( GetIsBlocked( oPC, "ds_j_map" ) > 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can only make a map once every 2 minutes!"+CLR_END );
        return;
    }

    object oArea = GetArea( oPC );
    int nJob     = 101;
    int nRank    = ds_j_GetJobRank( oPC, nJob );

    string sSubRace = GetStringLowerCase( GetSubRace( oPC ) );
    int nIsUDRace;

    if ( sSubRace == "svirfneblin" ||
         sSubRace == "shadow elf" ||
         sSubRace == "drow" ||
         sSubRace == "half-drow" ||
         sSubRace == "duergar" ||
         sSubRace == "orog" ||
         sSubRace == "goblin" ||
         sSubRace == "kobold" ){

         nIsUDRace =  1;
    }

    if ( GetIsAreaAboveGround( oArea ) == FALSE && GetIsAreaInterior( oArea ) == FALSE ){

        if ( ( !nIsUDRace && nRank < 3 ) || ( nIsUDRace && nRank < 2 ) ){

            SendMessageToPC( oPC, CLR_ORANGE+"You are not skilled enough to create an underground map." );
            return;
        }
    }

    if ( GetIsAreaAboveGround( oArea ) == TRUE && GetIsAreaInterior( oArea ) == FALSE ){

        if ( ( !nIsUDRace && nRank < 2 ) || ( nIsUDRace && nRank < 3 ) ){

            SendMessageToPC( oPC, CLR_ORANGE+"You are not skilled enough to create a surface map." );
            return;
        }
    }

    object oPaper = GetItemByName( oPC, CLR_ORANGE + "Empty Pages" + CLR_END );

    if ( !GetIsObjectValid( oPaper ) ){

        //no paper
        SendMessageToPC( oPC, CLR_ORANGE+"You don't have any paper to paint a map on!"+CLR_END );
        return;
    }

    SetBlockTime( oPC, 2, 0, "ds_j_map" );

    DestroyObject( oPaper );

    int nResult  = ds_j_StandardRoll( oPC, nJob );
    nRank        = ds_j_GiveStandardXP( oPC, nJob, nResult );

    if ( nResult <= 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+"Your map looks like a work of modern art. Alas, try again." );
    }
    else {

        string sModule = IntToString( GetLocalInt( GetModule(), "Module" ) );
        string sArea   = GetResRef( oArea );
        object oItem   = CreateItemOnObject( "ds_j_map", oPC, 1, "ds_j_map_"+sModule+"_"+sArea );

        SetName( oItem, CLR_ORANGE+"Map of "+GetName( oArea ) );

        ds_j_AddMaterialProperties( oPC, oItem, 0, nRank, nResult );
    }


}

void ds_j_ToggleDeletion( object oDM, object oPC ){
    int nToggle = GetLocalInt( oPC, "ds_j_trade_deletion");
    nToggle = !nToggle;
    SetLocalInt( oPC, "ds_j_trade_deletion", nToggle );
    string sMessage = "Deleting from slots is ";

    if ( nToggle ){
        sMessage += "enabled.";
    }
    else {
        sMessage += "disabled.";
    }

    SendMessageToPC( oDM, sMessage );
    SendMessageToPC( oPC, sMessage );

}



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    location lTarget = GetLocalLocation( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nSection     = GetLocalInt( oPC, "ds_section" );
    string sTileSet  = GetTilesetResRef( GetArea( oPC ) );
    int nToggle      = 0;

    if ( nSection == 3 ){

        ds_j_PlantCrop( oPC, lTarget, nNode );
    }
    else if ( nSection == 4 ){

        //trader
        if ( nNode >= 1 && nNode <= 7 ){

            ds_j_SetupStore( oPC, lTarget, 59 + nNode );
        }
        else  if ( nNode >= 8 && nNode <= 9 ){

            ds_j_SetupStore( oPC, lTarget, 91 + nNode );
        }
    }
    else if ( nSection == 5 ){

        //mushroom farmer
        ds_j_PlantCrop( oPC, lTarget, nNode, 1 );
    }
    else if ( nNode == 2 ){

        //hunter
        ds_j_SetTrap( oPC, lTarget );
    }
    else if ( nNode == 3 ){

        //hunter
        SetLocalInt( oPC, "ds_section", 3 );
    }
    else if ( nNode == 4 ){

        if ( sTileSet != TILESET_RESREF_RURAL && sTileSet != "ttz01" ){

            SendMessageToPC( oPC, CLR_ORANGE+"You cannot spawn an animal in this area."+CLR_END );
            return;
        }

        //dairy farmer
        ds_j_SpawnAnimal( oPC, lTarget, "ds_j_cow", 20 );
    }
    else if ( nNode == 5 ){

        if ( sTileSet != TILESET_RESREF_RURAL ){

            SendMessageToPC( oPC, CLR_ORANGE+"You cannot spawn an animal in this area."+CLR_END );
            return;
        }

        //pig farmer
        ds_j_SpawnAnimal( oPC, lTarget, "ds_j_pig", 21 );
    }
    else if ( nNode == 6 ){

        if ( sTileSet != TILESET_RESREF_RURAL_WINTER && sTileSet != TILESET_RESREF_RURAL ){

            SendMessageToPC( oPC, CLR_ORANGE+"You cannot spawn an animal in this area."+CLR_END );
            return;
        }

        //shepherd
        ds_j_SpawnAnimal( oPC, lTarget, "ds_j_muskox", 14 );
    }
    else if ( nNode == 7 ){

        if ( sTileSet != TILESET_RESREF_RURAL && sTileSet != TILESET_RESREF_DESERT ){

            SendMessageToPC( oPC, CLR_ORANGE+"You cannot spawn an animal in this area."+CLR_END );
            return;
        }

        //poultry farmer
        ds_j_SpawnAnimal( oPC, lTarget, "ds_j_chicken", 22 );
    }
    else if ( nNode == 8 ){

        //preacher
        ds_j_CreateAltar( oPC, lTarget );
    }
    else if ( nNode >= 9 && nNode <= 13 ){

        //exorcist, spy, thief, witchhunter, courier
        ds_j_ProcessTarget( oPC, oTarget, ( nNode + 21 ) );
    }
    else if ( nNode == 14 ){

        //prospector
        ds_j_SearchArea( oPC, lTarget, 51 );
    }
    else if ( nNode == 15 ){

        //Archeologist
        ds_j_StartDigging( oPC, lTarget, 52 );
    }
    else if ( nNode == 16 ){

        //trader
        SetLocalInt( oPC, "ds_section", 4 );

        if ( ds_j_GetJobRank( oPC, 60 ) > 0 ){

            SetLocalInt( oPC, "ds_check_1", 1 );
        }
        else{

            SetLocalInt( oPC, "ds_check_1", 0 );
        }

        if ( ds_j_GetJobRank( oPC, 60 ) > 0 ){ SetLocalInt( oPC, "ds_check_1", 1 ); } else { SetLocalInt( oPC, "ds_check_1", 0 ); }
        if ( ds_j_GetJobRank( oPC, 61 ) > 0 ){ SetLocalInt( oPC, "ds_check_2", 1 ); } else { SetLocalInt( oPC, "ds_check_2", 0 ); }
        if ( ds_j_GetJobRank( oPC, 62 ) > 0 ){ SetLocalInt( oPC, "ds_check_3", 1 ); } else { SetLocalInt( oPC, "ds_check_3", 0 ); }
        if ( ds_j_GetJobRank( oPC, 63 ) > 0 ){ SetLocalInt( oPC, "ds_check_4", 1 ); } else { SetLocalInt( oPC, "ds_check_4", 0 ); }
        if ( ds_j_GetJobRank( oPC, 64 ) > 0 ){ SetLocalInt( oPC, "ds_check_5", 1 ); } else { SetLocalInt( oPC, "ds_check_5", 0 ); }
        if ( ds_j_GetJobRank( oPC, 65 ) > 0 ){ SetLocalInt( oPC, "ds_check_6", 1 ); } else { SetLocalInt( oPC, "ds_check_6", 0 ); }
        if ( ds_j_GetJobRank( oPC, 66 ) > 0 ){ SetLocalInt( oPC, "ds_check_7", 1 ); } else { SetLocalInt( oPC, "ds_check_7", 0 ); }
        if ( ds_j_GetJobRank( oPC, 99 ) > 0 ){ SetLocalInt( oPC, "ds_check_8", 1 ); } else { SetLocalInt( oPC, "ds_check_8", 0 ); }
        if ( ds_j_GetJobRank( oPC, 100 ) > 0 ){ SetLocalInt( oPC, "ds_check_9", 1 ); } else { SetLocalInt( oPC, "ds_check_9", 0 ); }
    }
    else if ( nNode == 17 ){

        //burglar
        ds_j_DoorAction( oPC, 67, oTarget );
    }
    else if ( nNode == 18 ){

        //gravedigger
        ds_j_DoorAction( oPC, 68, oTarget );
    }
    else if ( nNode == 19 ){

        //towncrier
        ds_j_Announcer( oPC );
    }
    else if ( nNode == 20 ){

        //beggar
        ds_j_SetBowl( oPC, lTarget, 92 );
    }
    else if ( nNode == 21 ){

        //diplomat
        ds_j_ProcessTarget( oPC, oTarget, 43 );
    }
    else if ( nNode == 22 ){

        //painter
        ds_j_Paint( oPC, oTarget );
    }
    else if ( nNode > 22 && nNode < 29 ){

        //ability booster
        ds_j_SetupBusiness( oPC, oTarget, nNode );
    }
    else if ( nNode == 29 ){

        //mushroom farmer
        SetLocalInt( oPC, "ds_section", 5 );
    }
    else if ( nNode == 30 ){

        //rothe shepherd
        if ( sTileSet != TILESET_RESREF_MINES_AND_CAVERNS && sTileSet != TILESET_RESREF_UNDERDARK ){

            SendMessageToPC( oPC, CLR_ORANGE+"You cannot spawn an animal in this area."+CLR_END );
            return;
        }

        ds_j_SpawnAnimal( oPC, lTarget, "ds_j_rothe", 98 );
    }
    else if ( nNode == 31 ){

        //academic
        ds_j_Observe( oPC, oTarget );
    }
    else if ( nNode == 32 ){

        //performer
        ds_j_SetBowl( oPC, lTarget, 13 );
    }
    else if ( nNode == 33 ){

        //gambler
        ds_j_SetDiceMat( oPC, lTarget, 90 );
    }
    else if ( nNode == 34 ){

        //spider keeper
        if ( sTileSet != TILESET_RESREF_MINES_AND_CAVERNS && sTileSet != TILESET_RESREF_UNDERDARK ){

            SendMessageToPC( oPC, CLR_ORANGE+"You cannot spawn an animal in this area."+CLR_END );
            return;
        }

        ds_j_SpawnAnimal( oPC, lTarget, "ds_j_spider", 89 );
    }
    else if ( nNode == 35 ){

        //explorer
        ds_j_CreateMap( oPC );
    }
    else if ( nNode == 39 ){

        //toggle emotes
        if ( GetPCKEYValue( oPC, "ds_j_emotes" ) == 1 ){

            DeletePCKEYValue( oPC,  "ds_j_emotes" );
            SendMessageToPC( oPC, CLR_ORANGE+"Job system emotes are now switched ON (default)" );
        }
        else{

            SetPCKEYValue( oPC,  "ds_j_emotes", 1 );
            SendMessageToPC( oPC, CLR_ORANGE+"Job system emotes are now switched OFF" );
        }
    }
    else if ( nNode == 40 ){

        //DM
        ds_j_EraseSettings( oPC, oTarget );
    }
    else if ( nNode == 36 ){

        //DM can enable or disable deletion of items from slots
        ds_j_ToggleDeletion( oPC, oTarget );
    }
    else{


    }

}
