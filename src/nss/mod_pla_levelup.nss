// header
//-----------------------------------------------------------------------------
//script: mod_pla_levelup
//group: module events
//used as: OnPlayerLevelup
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)


// 2009/02/23 disco            Updated racial/class/area effects refresher
// 2019/06/25  Maverick00053  -  Added in PRC updates
// 2020/10/28 Raphel Gray       Added Epic Dragon Knight item on levelup

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_func_classes"
#include "inc_ds_records"
#include "nwnx_creature"


// A check for the DwD and AA prereq
void CheckPrereq(object oPC);

void main( ){

    // Variables.
    object oPC        = GetPCLevellingUp( );
    object oModule    = GetModule( );
    string szRace     = GetSubRace( oPC );
    int nClassCav     = GetLevelByClass(45,oPC);
    int nClassLord    = GetLevelByClass(54,oPC);
    int nClassAbyssal = GetLevelByClass(55,oPC);
    int nClassMonkPrc = GetLevelByClass(50,oPC);
    int nClassMonk    = GetLevelByClass(5,oPC);
    int nClassDuelist = GetLevelByClass(52,oPC);
    int nClassWarlock = GetLevelByClass(57,oPC);
    int nXP           = GetXP( oPC );
    int nHD           = GetHitDice( oPC );
    int nPrevLevel;
    int nPrevLevelXP;
    string sQuery;

    object oWidget = GetItemPossessedBy(oPC,"ds_pckey");
    string sBodyPart = GetLocalString(oWidget, "abyssalBodyPart");
    object oGrandfather = GetItemPossessedBy(oPC,"dd_grandfather");
    int nClassRDD = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);
    string sSubrace = GetSubRace(oPC);

    // Checking to make sure RDD and Outsider race cant be together
    if(((nClassRDD >= 1) && ((sSubrace == "Aasimar") || (sSubrace == "Feytouched") || (sSubrace == "Tiefling") ||
     (sSubrace == "Air Genasi") || (sSubrace == "Earth Genasi") || (sSubrace == "Fire Genasi") || (sSubrace == "Water Genasi"))))
    {
        if(!GetIsObjectValid(oGrandfather))
        {
        SendMessageToPC( oPC, "You can't level up RDD since you have another bloodline subrace!" );
        SendMessageToAllDMs( GetName( oPC ) + " tried to level up with RDD while having another bloodline subrace!" );

        nPrevLevelXP = ( ( ( nHD * ( nHD - 1 ) ) / 2 ) * 1000 ) - 1;

        SetXP( oPC, nPrevLevelXP );

        GetECL( oPC );

        DelayCommand( 5.0, SetXP( oPC, nXP ) );

        return;
        }
    }

    //Check DwD and AA prereq
    CheckPrereq( oPC );


    // Prevent people from taking monk after Duelist
    if ( (nClassDuelist >= 1) && (nClassMonk >= 1))
    {

        SendMessageToPC( oPC, "You can't level up monk since you have the duelist class!" );
        SendMessageToAllDMs( GetName( oPC ) + " tried to level up with monk while having the duelist class!" );

        nPrevLevelXP    = ( ( ( nHD * ( nHD - 1 ) ) / 2 ) * 1000 ) - 1;

        SetXP( oPC, nPrevLevelXP );

        GetECL( oPC );

        DelayCommand( 5.0, SetXP( oPC, nXP ) );

        return;
    }


    if ( GetIsPolymorphed( oPC ) ){

        SendMessageToPC( oPC, "You can't level up while being Polymorphed!" );
        SendMessageToAllDMs( GetName( oPC ) + " tried to level up while being Polymorphed!" );

        nPrevLevelXP    = ( ( ( nHD * ( nHD - 1 ) ) / 2 ) * 1000 ) - 1;

        SetXP( oPC, nPrevLevelXP );

        GetECL( oPC );

        DelayCommand( 5.0, SetXP( oPC, nXP ) );

        return;
    }

    // Racial System refresh.
    struct _ECL_STATISTICS strECL = GetECL( oPC );
    int nECL                      = FloatToInt( strECL.fLevelAdjustment );
    nHD                           = GetHitDice( oPC );

    if ( nHD == 10 ){

        sQuery  = "INSERT INTO player_authentication VALUES ( NULL, ";
        sQuery += "'"+SQLEncodeSpecialChars( GetPCPlayerName( oPC ) )+"', ";
        sQuery += "'"+ GetPCPublicCDKey( oPC, TRUE )+"', NOW() ) ";
        sQuery += "ON DUPLICATE KEY UPDATE insert_at=NOW()";

        SQLExecDirect( sQuery );
    }


    // If necessary, modify the Character to meet Amia's Specific Class Level Feat Requirements.
    ResolvePrereqFeats( oPC );

    //give level items if needed
    if ( GetHasSkill( SKILL_SET_TRAP, oPC ) && !GetIsObjectValid( GetItemByName( oPC, "Trap Tool" ) ) ) {

        CreateItemOnObject( "ds_trap_widget", oPC );
    }

    if ( GetLevelByClass( CLASS_TYPE_PALADIN, oPC ) ){

        ds_create_item( "itm_book_pcode1", oPC );
    }
    if (GetHasFeat( FEAT_EPIC_SPELL_MUMMY_DUST, oPC ) ){

        ds_create_item( "jj_thin_book", oPC, 1, "jj_epic_summon" );
    }
    if (GetHasFeat( FEAT_EPIC_SPELL_DRAGON_KNIGHT, oPC ) ){

        ds_create_item( "epicdragonknight", oPC, 1, "edk_choice" );
    }
    if ( GetLevelByClass( CLASS_TYPE_ASSASSIN, oPC ) > 1){
        ds_create_item( "jj_asn_tool", oPC );
    }

     if (GetHasFeat( 1220, oPC ) && (nClassCav == 1)){

        if(!GetIsObjectValid(GetItemPossessedBy(oPC,"r_mountwidget")))
        {
        object oMount = CreateItemOnObject( "r_mountwidget", oPC,1,"r_mountwidget");
        if(GetRacialType(oPC) == 38)
        {
          SetLocalInt(oMount,"horse",308);
          SetName(oMount,"Mount: Worg");
        }
        }

        if(!GetIsObjectValid(GetItemPossessedBy(oPC,"r_mountbc")))
        {
        object oMountBC = CreateItemOnObject( "r_mountbc", oPC,1,"r_mountbc");
        }

    }

     if (GetHasFeat( 1227, oPC ) && (nClassMonkPrc == 1)){

        ds_create_item( "mo_elewidget", oPC);
    }
     // Peerage Class
    if ((nClassLord == 1)){
        if(!GetIsObjectValid(GetItemPossessedBy(oPC,"l_vassal")))
        {
        object oVassal = CreateItemOnObject( "l_vassal", oPC,1,"l_vassal");

        }
    }

    // Abyssal Corrupted Class
     if ((nClassAbyssal == 1) && (sBodyPart == ""))
     {
       string sAbyssalBodyPart = GetLocalString(oWidget, "abyssalBodyPart");

       if(sAbyssalBodyPart=="wings")
       {
         int nRandWing = Random(3)+1;
         if(nRandWing == 1)
         {
          SetCreatureWingType(1,oPC);
         }
         else if(nRandWing == 2)
         {
          SetCreatureWingType(93,oPC);
         }
         else if(nRandWing == 3)
         {
          SetCreatureWingType(99,oPC);
         }
         FloatingTextStringOnCreature("*Filthy demonic wings painfully sprout from your backside*",oPC);
       }
       else if(sAbyssalBodyPart=="tail")
       {
         int nRandTail = Random(4)+1;
         if(nRandTail == 1)
         {
          SetCreatureTailType(1,oPC);
         }
         else if(nRandTail == 2)
         {
          SetCreatureTailType(3,oPC);
         }
         else if(nRandTail == 3)
         {
          SetCreatureTailType(491,oPC);
         }
         else if(nRandTail == 4)
         {
          SetCreatureTailType(993,oPC);
         }
         FloatingTextStringOnCreature("*A powerful but clearly demonic tail sprouts from your tail bone*",oPC);
       }
       else if(sAbyssalBodyPart=="horns")
       {
         FloatingTextStringOnCreature("*Your forehead hurts as you feel a constant pressure in two locations, opposite of eachother on your forehead.*",oPC);
       }
       else if(sAbyssalBodyPart=="legs")
       {
         SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,197,oPC);
         SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT,197,oPC);
         SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,197,oPC);
         SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,197,oPC);
         SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,27,oPC);
         SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,27,oPC);
         SetLocalString(oWidget, "abyssalBodyPart","legs");
         FloatingTextStringOnCreature("*Your legs twist, and snap painfully into demonic like positions*",oPC);
         SendMessageToPC(oPC,"// Your new legs might not be visable in your current armor. Remove your armor to see them and/or modify your armor legs to display your legs properly");
       }
       else
       {
         SendMessageToPC(oPC,"Error: Your Body Part Variable wasn't set properly. Please report to Dev/DM team.");
       }
     }

    // Warlock Class
    if ((nClassWarlock == 1)){
        if(!(GetHasFeat(1314, oPC) || GetHasFeat(1315, oPC) || GetHasFeat(1316, oPC) || GetHasFeat(1317, oPC) || GetHasFeat(1318, oPC) || GetHasFeat(1319, oPC)))
        {
          ds_create_item( "wlk_pactchoose", oPC, 1);
        }
    }

    if ((nClassWarlock == 4)){
        if(!(GetHasFeat(1314, oPC) || GetHasFeat(1315, oPC) || GetHasFeat(1316, oPC) || GetHasFeat(1317, oPC) || GetHasFeat(1318, oPC) || GetHasFeat(1319, oPC)))
        {
          SendMessageToPC(oPC,"You have not chosen a Pact Feat yet! You will be unable to take another Warlock level until you do so. Use your 'Warlock: Pact Chooser' item to do this.");
          SendMessageToAllDMs( GetName( oPC ) + " tried to take multiple Warlock levels without choosing a Pact first!" );

          nPrevLevelXP    = ( ( ( nHD * ( nHD - 1 ) ) / 2 ) * 1000 ) - 1;

          SetXP( oPC, nPrevLevelXP );

          GetECL( oPC );

          DelayCommand( 5.0, SetXP( oPC, nXP ) );

          return;
        }
    }


    //area effects
    ApplyAreaAndRaceEffects( oPC, 1 );

    // Save the character modifications.
    AR_ExportPlayer( oPC );

    //log level up
    RecordPC( oPC );

    ExecuteScript("heritage_setup", oPC);
    ExecuteScript("race_effects", oPC);
    ExecuteScript("subrace_effects", oPC);

    return;
}

// A check for the DwD and AA prereq
void CheckPrereq(object oPC)
{

   int nBAB = GetBaseAttackBonus(oPC); // 8+ for DwD
   int nFeatDodge = GetHasFeat(FEAT_DODGE,oPC);
   int nFeatToughness = GetHasFeat(FEAT_TOUGHNESS,oPC);
   int nFeatSkillFocusDisc = GetHasFeat(FEAT_SKILL_FOCUS_DISCIPLINE,oPC);
   int nAlignmentLawful = GetAlignmentLawChaos(oPC);

   int nFeatPBS = GetHasFeat(FEAT_POINT_BLANK_SHOT,oPC);
   int nFeatWFShortbow = GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,oPC);
   int nFeatWFLongbow = GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,oPC);
   int nFeatRapidShot = GetHasFeat(FEAT_RAPID_SHOT,oPC);
   int nFeatMartialProf = GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL,oPC);

   int nBardLevel = GetLevelByClass(CLASS_TYPE_BARD,oPC);
   int nSorcLevel = GetLevelByClass(CLASS_TYPE_SORCERER,oPC);
   int nWizLevel = GetLevelByClass(CLASS_TYPE_WIZARD,oPC);
   int nAssLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC);

   int nRacePC = GetRacialType(oPC); // Dwarf = 0, Elf = 1, Halfelf = 4, Invalid = 28

   if((nBAB >= 8) && (nFeatDodge == 1) && (nFeatToughness == 1) && (nFeatSkillFocusDisc == 1))
   {
     SetLocalInt(oPC,"Prereq_DwD",1);
   }

   if((nBAB >= 7) && (nFeatDodge == 1) && (nFeatToughness == 1) && ((nRacePC == 0) || (nRacePC == 30 ) || (nRacePC == 31)) && (nAlignmentLawful == ALIGNMENT_LAWFUL))
   {
     SetLocalInt(oPC,"Prereq_DwD",1);
   }

   if((nBAB >= 7) && (nFeatPBS == 1) && (nFeatRapidShot == 1) && (nFeatMartialProf == 1) && ((nFeatWFShortbow == 1) || (nFeatWFLongbow == 1)) && ((nBardLevel >= 1) || (nSorcLevel >= 1) || (nWizLevel >= 1) || (nAssLevel >= 1)))
   {
     SetLocalInt(oPC,"Prereq_AA",1);
   }

   if((nBAB >= 6) && (nFeatPBS == 1) && ((nRacePC == 1) || (nRacePC == 4) || (nRacePC == 32) || (nRacePC == 33) || (nRacePC == 34) || (nRacePC == 35) || (nRacePC == 54) || (nRacePC == 41)) && ((nFeatWFShortbow == 1) || (nFeatWFLongbow == 1)) && ((nBardLevel >= 1) || (nSorcLevel >= 1) || (nWizLevel >= 1) || (nAssLevel >= 1)))
   {
     SetLocalInt(oPC,"Prereq_AA",1);
   }
}
