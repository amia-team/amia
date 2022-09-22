/*
  Job Journal On Use Script

- Maverick00053
*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "ds_ai2_include"

const int RESOURCE_XP    = 100;

const int MAX_CROPS = 3; // Sets the max amount of crops one player can grow at at time
const int MAX_ANIMALS = 3; // Sets the max amount of animals one player can grow at at time
const int MAX_TRAPS = 2; // Sets the max amount of traps one player can have out

void LaunchConvo( object oPC); // launches journal convo

void DS_CHECK_SET( object oPC, object oJobJournal, object oTargeted); // Runs a check and sets the ds_check variables on PC for the dialogue

void JobJournal( object oPC, object oJobJournal, int nNode, location lTargeted, object oTargeted); // Main journal function

void DS_CLEAR_ALL(object oPC); // Function to clear all saved variables

void DS_CLEAR_CHECK(object oPC); // Function to clear all saved variables for ds_check

void main()
{

    object oPC          = GetItemActivator();
    object oJobJournal      = GetItemActivated();
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");
    location lTargeted = GetItemActivatedTargetLocation();
    object oTargeted = GetItemActivatedTarget();

    DS_CHECK_SET(oPC,oJobJournal,oTargeted);

    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "i_js_jobjournal")
    {
       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);
    }
    else if(nNode > 0)
    {
      if( 99 >= nNode >= 1)
      {
         JobJournal(oPC,oJobJournal,nNode,lTargeted,oTargeted);
         return;
      }
    }
    else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
    {
       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);
    }
}


void LaunchConvo( object oPC){
    SetLocalString(oPC,"ds_action","i_js_jobjournal");
    AssignCommand(oPC, ActionStartConversation(oPC, "c_js_jobjournal", TRUE, FALSE));
}


void DS_CHECK_SET( object oPC, object oJobJournal, object oTargeted)
{
  int nFarmland = GetLocalInt(oPC,"onfarmland");
  int nUD = GetLocalInt(oPC,"underdark");
  int nOnSite = GetLocalInt(oPC,"onsite");
  int nPCLevel = GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC);
  string sPrimaryJob = GetLocalString(oJobJournal,"primaryjob");
  string sSecondaryJob = GetLocalString(oJobJournal,"secondaryjob");


  // Clearing everything to be safe
  DS_CLEAR_CHECK(oPC);


  // If they are on farmland
  if((nFarmland == 1) && ((sPrimaryJob == "Farmer") || (sSecondaryJob == "Farmer")))
  {
    SetLocalInt(oPC,"ds_check_1",1);
    if(nUD == 1)
    {
      SetLocalInt(oPC,"ds_check_3",1);
    }
    else
    {
      SetLocalInt(oPC,"ds_check_2",1);
    }
  }

  // If they are on scholar sites
  if((nOnSite == 1) && ((sPrimaryJob == "Scholar") || (sSecondaryJob == "Scholar")))
  {
    SetLocalInt(oPC,"ds_check_4",1);
  }


  // Check to see if they are a hunter or not
  if(((sPrimaryJob == "Hunter") || (sSecondaryJob == "Hunter")))
  {
    SetLocalInt(oPC,"ds_check_5",1);
    if(nPCLevel >= 5)
    {
      SetLocalInt(oPC,"ds_check_18",1);
    }
  }

  // Check to see if they are a rancher or not
  if(((sPrimaryJob == "Rancher") || (sSecondaryJob == "Rancher")))
  {
    SetLocalInt(oPC,"ds_check_6",1);
  }

  // Check to see if they are a soldier
  if((sPrimaryJob == "Soldier"))
  {
    SetLocalInt(oPC,"ds_check_7",1);
    SetLocalInt(oPC,"ds_check_8",1);
    SetLocalInt(oPC,"ds_check_9",1);
  }
  else if((sSecondaryJob == "Soldier"))
  {
    SetLocalInt(oPC,"ds_check_7",1);
    SetLocalInt(oPC,"ds_check_8",1);
  }

  // Scholar writing script - Lets them set the painting name and description
  if(((sPrimaryJob == "Scholar") || (sSecondaryJob == "Scholar")) && (GetIsObjectValid(oTargeted)))
  {
    if((GetResRef(oTargeted) == "js_sch_embo") || (GetResRef(oTargeted) == "js_sch_emto"))
    {
      SetLocalInt(oPC,"ds_check_10",1);
    }
  }


  // Check to see if they are a Scoundrel and Target is valid
  if(((sPrimaryJob == "Scoundrel") || (sSecondaryJob == "Scoundrel")) && (GetIsObjectValid(oTargeted)))
  {
    if(GetObjectType(oTargeted) == OBJECT_TYPE_ITEM)
    {
      SetLocalInt(oPC,"ds_check_11",1);
    }
  }


  // Check to see if they are a Physician and Target is valid
  if(((sPrimaryJob == "Physician") || (sSecondaryJob == "Physician")) && (GetIsObjectValid(oTargeted)))
  {
    if((GetObjectType(oTargeted) == OBJECT_TYPE_CREATURE) && (oTargeted != oPC))
    {
      SetLocalInt(oPC,"ds_check_12",1);
      SetLocalInt(oPC,"ds_check_14",1);
    }

    if(oTargeted == oPC)
    {
      SetLocalInt(oPC,"ds_check_15",1);
    }

  }

  // Check to see if they are a Devout
  if(((sPrimaryJob == "Devout") || (sSecondaryJob == "Devout")))
  {
      SetLocalInt(oPC,"ds_check_13",1);
  }

  // Artist writing script - Lets them set the painting name and description
  if(((sPrimaryJob == "Artist") || (sSecondaryJob == "Artist")) && (GetIsObjectValid(oTargeted)))
  {
    if((GetResRef(oTargeted) == "js_plcspawner") && (GetLocalString(oTargeted,"plc") == "js_art_pain"))
    {
      SetLocalInt(oPC,"ds_check_10",1);
    }
  }

  // Check to see if they are a Merchant
  if(sPrimaryJob == "Merchant")
  {
      SetLocalInt(oPC,"ds_check_16",1);
      SetLocalInt(oPC,"ds_check_17",1);
      SetLocalInt(oPC,"ds_check_11",1); // Price checking

      if((GetResRef(oTargeted) == "js_chest_kit"))
      {
       SetLocalInt(oPC,"ds_check_18",1);
      }

      if((GetResRef(oTargeted) == "js_mini_merchest"))
      {
       SetLocalInt(oPC,"ds_check_19",1);
      }
  }
  else if(sSecondaryJob == "Merchant")
  {
      SetLocalInt(oPC,"ds_check_16",1);
      SetLocalInt(oPC,"ds_check_11",1); // Price checking

      if((GetResRef(oTargeted) == "js_chest_kit"))
      {
       SetLocalInt(oPC,"ds_check_18",1);
      }

      if((GetResRef(oTargeted) == "js_mini_merchest"))
      {
       SetLocalInt(oPC,"ds_check_19",1);
      }
  }

  // Smith writing script - Lets them set the weapon/armor names
  if(((sPrimaryJob == "Smith") || (sSecondaryJob == "Smith")) && (GetIsObjectValid(oTargeted)))
  {
    if((GetResRef(oTargeted) == "js_bla_wega") || (GetResRef(oTargeted) == "js_bla_wedw")  || (GetResRef(oTargeted) == "js_bla_weha")
        || (GetResRef(oTargeted) == "js_bla_weba")  || (GetResRef(oTargeted) == "js_bla_webs")  || (GetResRef(oTargeted) == "js_bla_weda")
        || (GetResRef(oTargeted) == "js_bla_wegs")  || (GetResRef(oTargeted) == "js_bla_wels")  || (GetResRef(oTargeted) == "js_bla_weka")
        || (GetResRef(oTargeted) == "js_bla_wera")  || (GetResRef(oTargeted) == "js_bla_wesc")  || (GetResRef(oTargeted) == "js_bla_wess")
        || (GetResRef(oTargeted) == "js_bla_wecl")  || (GetResRef(oTargeted) == "js_bla_wehf")  || (GetResRef(oTargeted) == "js_bla_welf")
        || (GetResRef(oTargeted) == "js_bla_welh")  || (GetResRef(oTargeted) == "js_bla_wewa")  || (GetResRef(oTargeted) == "js_bla_wema")
        || (GetResRef(oTargeted) == "js_bla_wemo")  || (GetResRef(oTargeted) == "js_bla_wedm")  || (GetResRef(oTargeted) == "js_bla_wedb")
        || (GetResRef(oTargeted) == "js_bla_wequ")  || (GetResRef(oTargeted) == "js_bla_we2b")  || (GetResRef(oTargeted) == "js_bla_wekm")
        || (GetResRef(oTargeted) == "js_bla_weku")  || (GetResRef(oTargeted) == "js_bla_wesi")  || (GetResRef(oTargeted) == "js_bla_wewh")
        || (GetResRef(oTargeted) == "js_bla_wems")  || (GetResRef(oTargeted) == "js_bla_wehb")  || (GetResRef(oTargeted) == "js_bla_wesy")
        || (GetResRef(oTargeted) == "js_bla_wesp")  || (GetResRef(oTargeted) == "js_bla_wetr")  || (GetResRef(oTargeted) == "js_bla_arcs")
        || (GetResRef(oTargeted) == "js_bla_arbp")  || (GetResRef(oTargeted) == "js_bla_arch")  || (GetResRef(oTargeted) == "js_bla_arsc")
        || (GetResRef(oTargeted) == "js_bla_arbm")  || (GetResRef(oTargeted) == "js_bla_arfp")  || (GetResRef(oTargeted) == "js_bla_arhp")
        || (GetResRef(oTargeted) == "js_bla_arsp")  || (GetResRef(oTargeted) == "js_bla_shsm")  || (GetResRef(oTargeted) == "js_bla_shlg")
        || (GetResRef(oTargeted) == "js_bla_shto")  || (GetResRef(oTargeted) == "js_bla_helm")  || (GetResRef(oTargeted) == "js_bla_grea")
        || (GetResRef(oTargeted) == "js_bla_brac"))
    {
      SetLocalInt(oPC,"ds_check_10",1);
    }
  }

  // tailor writing script - Lets them set the name and description
  if(((sPrimaryJob == "Tailor") || (sSecondaryJob == "Tailor")) && (GetIsObjectValid(oTargeted)))
  {
    if((GetResRef(oTargeted) == "js_tai_arcl") || (GetResRef(oTargeted) == "js_tai_arle") || (GetResRef(oTargeted) == "js_tai_arpa")
     || (GetResRef(oTargeted) == "js_tai_arst") || (GetResRef(oTargeted) == "js_tai_arha") || (GetResRef(oTargeted) == "js_tai_hood")
     || (GetResRef(oTargeted) == "js_tai_cloa") || (GetResRef(oTargeted) == "js_tai_boot") || (GetResRef(oTargeted) == "js_tai_belt"))
    {
      SetLocalInt(oPC,"ds_check_10",1);
    }
  }

  // Jeweler writing script - Lets them set the name and description
  if(((sPrimaryJob == "Jeweler") || (sSecondaryJob == "Jeweler")) && (GetIsObjectValid(oTargeted)))
  {
    if((GetResRef(oTargeted) == "js_jew_amul") || (GetResRef(oTargeted) == "js_jew_ring"))
    {
      SetLocalInt(oPC,"ds_check_10",1);
    }
  }

  // Ranged Craftsman writing script - Lets them set the name and description
  if(((sPrimaryJob == "RCraftsman") || (sSecondaryJob == "RCraftsman")) && (GetIsObjectValid(oTargeted)))
  {
    if((GetResRef(oTargeted) == "js_arch_sling") || (GetResRef(oTargeted) == "js_arch_bow") || (GetResRef(oTargeted) == "js_arch_cbow")
     || (GetResRef(oTargeted) == "js_arch_lbow") || (GetResRef(oTargeted) == "js_arch_sbow"))
    {
      SetLocalInt(oPC,"ds_check_10",1);
    }
  }

}

void JobJournal( object oPC, object oJobJournal, int nNode, location lTargeted, object oTargeted)
{
    object oResource;
    object oPartyCheck;
    object oPLC;
    int nCrops = GetLocalInt(oPC,"crops");
    int nSiteType = GetLocalInt(oPC,"sitetype");
    int nTraps = GetLocalInt(oPC,"traps");
    int nAnimals = GetLocalInt(oPC,"animals");
    int nRandom = Random(100)+1;
    int nRank;
    int nPCLevel = GetHitDice(oPC);
    int nTempHp = nPCLevel*2;
    int eLoopSpellID;
    int sWrittenAlready;
    string sTalkCustom;
    string sResource;
    string sPrimaryJob = GetLocalString(oJobJournal,"primaryjob");
    string sSecondaryJob = GetLocalString(oJobJournal,"secondaryjob");
    string sSuccessOrFailure;
    effect eVFX;
    effect ePrimaryEffect;
    effect eSecondaryEffect;
    effect eLink;
    effect eLoop;

    int nXP = RESOURCE_XP;

    // Level 30 XP blocker
    if(nPCLevel == 30)
    {
      nXP = 1;
    }

   switch(nNode)
   {
     case 1: sResource = "js_farm_cot"; break;
     case 2: sResource = "js_farm_pap"; break;
     case 3: sResource = "js_farm_tob"; break;
     case 4: sResource = "js_farm_car"; break;
     case 5: sResource = "js_farm_pot"; break;
     case 6: sResource = "js_farm_oat"; break;
     case 7: sResource = "js_farm_sug"; break;
     case 8: sResource = "js_farm_mus"; break;
     case 9: sResource = "js_farm_dee"; break;
     case 10: sResource = "js_farm_tun"; break;
     case 11: sResource = "js_farm_bla"; break;
     case 12: sResource = "js_farm_bar"; break;
     case 13: sResource = "js_farm_fir"; break;
     case 14: sResource = "js_farm_zur"; break;
     case 15: break; // Scholar Search - LEAVE BLANK
     case 16: sResource = "js_hunt_tra"; break; // Hunter's Pelt Trap
     case 17: sResource = "js_ran_cam"; break;
     case 18: sResource = "js_ran_chi1"; break;
     case 19: sResource = "js_ran_chi2"; break;
     case 20: sResource = "js_ran_cow"; break;
     case 21: sResource = "js_ran_rot1"; break;
     case 22: sResource = "js_ran_rot2"; break;
     case 23: sResource = "js_ran_rot3"; break;
     case 24: break; // Empty atm
     case 25: break; // Empty atm
     case 26: break; // Empty atm
     case 27: break; // Empty atm
     case 28: sResource = "js_ran_pig"; break;
     case 29: sResource = "js_ran_she1"; break;
     case 30: sResource = "js_ran_she2"; break;
     case 31: sResource = "js_ran_she3"; break;
     case 32: sResource = "js_ran_spi"; break;
     case 33: sResource = "js_ran_ste"; break;
     case 34: sResource = "js_ran_pea1"; break;
     case 35: sResource = "js_ran_pea2"; break;
     case 36: break; // Soldier Buff - LEAVE BLANK
     case 37: break; // Soldier Combat Dummy - LEAVE BLANK
     case 38: break; // Soldier Combat Dummy - LEAVE BLANK
     case 39: break; // Soldier Combat Dummy - LEAVE BLANK
     case 40: break; // Soldier Combat Dummy - LEAVE BLANK
     case 41: break; // Writing script - LEAVE BLANK
     case 42: break; // Writing script - LEAVE BLANK
     case 43: break; // Scoundrel/Merchant cost script - LEAVE BLANK
     case 44: break; // Physician script - LEAVE BLANK
     case 45: break; // Devout Buff script - LEAVE BLANK
     case 46: sResource = "js_dev_alta"; break; // Devout PLC script
     case 47: sResource = "js_dev_lect"; break; // Devout PLC script
     case 48: break; // Physician script - LEAVE BLANK
     case 49: break; // Physician script - LEAVE BLANK
     case 50: break; // Merchant script - LEAVE BLANK
     case 51: break; // Merchant script - LEAVE BLANK
     case 52: break; // Merchant script - LEAVE BLANK
     case 53: break; // Merchant script - LEAVE BLANK
     case 54: break; // Merchant script - LEAVE BLANK
     case 55: break; // Merchant script - LEAVE BLANK
     case 56: break; // Merchant script - LEAVE BLANK
     case 57: break; // Merchant script - LEAVE BLANK
     case 58: break; // Merchant script - LEAVE BLANK
     case 59: break; // Merchant script - LEAVE BLANK
     case 60: break; // Merchant script - LEAVE BLANK
     case 61: break; // Merchant script - LEAVE BLANK
     case 62: break; // Merchant script - LEAVE BLANK
     case 63: break; // Merchant script - LEAVE BLANK
     case 64: break; // Merchant script - LEAVE BLANK
     case 65: break; // Merchant script - LEAVE BLANK
     case 66: break; // Merchant script - LEAVE BLANK
     case 67: break; // Merchant script - LEAVE BLANK
     case 68: break; // Merchant script - LEAVE BLANK
     case 69: break; // Merchant script - LEAVE BLANK
     case 70: break; // Merchant script - LEAVE BLANK
     case 71: break; // Merchant script - LEAVE BLANK
     case 72: break; // Merchant script - LEAVE BLANK
     case 73: break; // Merchant script - LEAVE BLANK
     case 74: break; // Merchant script - LEAVE BLANK
     case 75: break; // Merchant script - LEAVE BLANK
     case 76: break; // Merchant script - LEAVE BLANK
     case 77: break; // Merchant script - LEAVE BLANK
     case 78: break; // Merchant script - LEAVE BLANK
     case 79: break; // Merchant script - LEAVE BLANK
     case 80: sResource = "js_hunt_tra2"; break; // Hunter's Meat Trap
     case 81: break; // Hunter script - LEAVE BLANK
     case 82: break; // Merchant Chest Creation Script
     case 83: break; // Merchant Chest Transfer Resource Script
   }

   // Farming/Planting
   if((nNode >= 1) && (nNode <= 14))
   {
     // Make sure they aren't at their max crops out
     if(nCrops >= MAX_CROPS)
     {
       SendMessageToPC(oPC,"*You have the maximum amount of crops out already*");
       DS_CLEAR_ALL(oPC);
       return;
     }

     oResource = CreateObject(OBJECT_TYPE_PLACEABLE,sResource,GetLocation(oPC));
     SetName(oResource, GetName(oPC)+"'s "+GetName(oResource));
     DelayCommand(GetLocalFloat(oResource,"growrate"),DeleteLocalInt(oResource,"blocker"));
     SetLocalInt(oResource,"PreviousHarvestTime",GetRunTimeInSeconds());
     DelayCommand(GetLocalFloat(oResource,"growrate"),DeleteLocalInt(oResource,"PreviousHarvestTime"));
     AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,1.0));
     SendMessageToPC(oPC,"*You plant a crop it will take: " +FloatToString(GetLocalFloat(oResource,"growrate"),0,1)+ " seconds to grow*");
     SetLocalInt(oPC,"crops",nCrops+1);
   }


   // Scholar sites
   if((nNode == 15))
   {

     // Make sure they aren't on site cool down
     if(GetLocalInt(oPC,"siteblocker") == 1)
     {
       SendMessageToPC(oPC,"*You need to rest for a while before searching again*");
       DS_CLEAR_ALL(oPC);
       return;
     }

     switch(nSiteType)
     {
     case 1: sResource = "js_scho_anc"; break;
     case 2: sResource = "js_gem_ivor"; break;
     case 3: sResource = "js_corpse"; break;
     }

     // Figure out if the job is primary or secondary
     if(sPrimaryJob == "Scholar")
     {
      nRank = 2;
     }
     else if(sSecondaryJob == "Scholar")
     {
      nRank = 1;
     }

     // Based on job being primary/secondary roll to get item
     if(nRank == 2)
     {
        if(nRandom <= 90)
        {
          sSuccessOrFailure = "SUCCESS";
          GiveExactXP(oPC,nXP);
          CreateItemOnObject(sResource,oPC);
        }
        else
        {
          sSuccessOrFailure = "FAILURE";
          GiveExactXP(oPC,nXP/2);
        }
        SendMessageToPC(oPC,"Rolled "+IntToString(nRandom)+" vs 90 or less. "+sSuccessOrFailure);

     }
     else if(nRank == 1)
     {

        if(nRandom <= 60)
        {
          sSuccessOrFailure = "SUCCESS";
          GiveExactXP(oPC,nXP);
          CreateItemOnObject(sResource,oPC);
        }
        else
        {
          sSuccessOrFailure = "FAILURE";
          GiveExactXP(oPC,nXP/2);
        }
        SendMessageToPC(oPC,"Rolled "+IntToString(nRandom)+" vs 60 or less. "+sSuccessOrFailure);

     }
     SetLocalInt(oPC,"siteblocker",1);
     DelayCommand(300.0,DeleteLocalInt(oPC,"siteblocker"));
     AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,3.0));
   }


   // Hunter trapping
   if((nNode == 16) || (nNode == 80))
   {
     // Make sure they aren't at their max traps out
     if(nTraps >= MAX_TRAPS)
     {
       SendMessageToPC(oPC,"*You have the maximum amount of traps out already*");
       DS_CLEAR_ALL(oPC);
       return;
     }

     oResource = CreateObject(OBJECT_TYPE_PLACEABLE,sResource,GetLocation(oPC));
     SetName(oResource, GetName(oPC)+"'s "+GetName(oResource));
     DelayCommand(GetLocalFloat(oResource,"traprate"),DeleteLocalInt(oResource,"blocker"));
     SetLocalInt(oResource,"PreviousHarvestTime",GetRunTimeInSeconds());
     DelayCommand(GetLocalFloat(oResource,"traprate"),DeleteLocalInt(oResource,"PreviousHarvestTime"));
     AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,1.0));
     SendMessageToPC(oPC,"*You lay down a trap it will take: " +FloatToString(GetLocalFloat(oResource,"traprate"),0,1)+ " seconds to catch something*");
     SetLocalInt(oPC,"traps",nTraps+1);
   }

   if(nNode == 81)
   {
      AssignCommand(oPC,ActionStartConversation(oPC,"c_hunter_bgh",TRUE,FALSE));
   }


   // Rancher's animal raising
   if((nNode >= 17) && (nNode <= 35))
   {
     // Make sure they aren't at their max animals out
     if(nAnimals >= MAX_ANIMALS)
     {
       SendMessageToPC(oPC,"*You have the maximum amount of animals out already*");
       DS_CLEAR_ALL(oPC);
       return;
     }

     oResource = CreateObject(OBJECT_TYPE_CREATURE,sResource,GetLocation(oPC));
     SetName(oResource, GetName(oPC)+"'s "+GetName(oResource));
     DelayCommand(GetLocalFloat(oResource,"growrate"),DeleteLocalInt(oResource,"blocker"));
     SetLocalInt(oResource,"PreviousHarvestTime",GetRunTimeInSeconds());
     DelayCommand(GetLocalFloat(oResource,"growrate"),DeleteLocalInt(oResource,"PreviousHarvestTime"));
     AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,1.0));
     SendMessageToPC(oPC,"*You begin to raise an animal and it will take: " +FloatToString(GetLocalFloat(oResource,"growrate"),0,1)+ " seconds to grow*");
     SetLocalInt(oPC,"animals",nAnimals+1);
   }


   // Soldier Combat Dummies and Buffs
   if((nNode == 36))   // Party Buff
   {

     eLoop = GetFirstEffect(oPC);
     // Checks for the buff on the caster PC. If present stops casting.
     while(GetIsEffectValid(eLoop))
     {
       eLoopSpellID = GetEffectSpellId(eLoop);

       if ((GetEffectTag(eLoop) == "soldierbuff"))
       {
         FloatingTextStringOnCreature("*You cannot motivate the party again till your current speech's effects fade*",oPC);
         DS_CLEAR_ALL(oPC);
         return;
       }
         eLoop=GetNextEffect(oPC);
      }
     //

     if(sPrimaryJob == "Soldier")
     {
       ePrimaryEffect = EffectTemporaryHitpoints(nTempHp);
       eSecondaryEffect = EffectSavingThrowIncrease(SAVING_THROW_FORT,2);
     }
     else if(sSecondaryJob == "Soldier")
     {
       ePrimaryEffect = EffectTemporaryHitpoints(nTempHp/2);
       eSecondaryEffect = EffectSavingThrowIncrease(SAVING_THROW_FORT,1);
     }
     eVFX = EffectVisualEffect(VFX_DUR_BARD_SONG);
     // Buffs based on if soldier is primary or secondary
     eLink = EffectLinkEffects(eVFX,ePrimaryEffect);
     eSecondaryEffect = TagEffect(eSecondaryEffect,"soldierbuff");
     eLink = TagEffect(eLink,"soldierbuff");

     // Applying the buff to PCs
     oPartyCheck = GetFirstPC();

     while(GetIsObjectValid(oPartyCheck))
     {

       if(ds_check_partymember(oPC, oPartyCheck)) // Checking to see if they are a party member
       {
         if(GetDistanceBetween(oPC,oPartyCheck) < 30.0)// Making sure they are nearby
         {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPartyCheck,600.0);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSecondaryEffect, oPartyCheck,600.0);
         }
       }

       oPartyCheck = GetNextPC();
     }
     FloatingTextStringOnCreature("*You give a motivating and inspiring speech*",oPC);
     //

   }
   else if((nNode >= 37) && (nNode <= 40))// Training Dummies
   {

     oPLC = GetLocalObject(oJobJournal, "spawnedplc"+IntToString(nNode));

     if(GetIsObjectValid(oPLC))
     {
       SendMessageToPC(oPC,"*Removing PLC*");
       DestroyObject(oPLC);
       DeleteLocalObject(oJobJournal,"spawnedplc");
     }
     else
     {
       SendMessageToPC(oPC,"*Spawning PLC*");
       oPLC = CreateObject(OBJECT_TYPE_PLACEABLE,"js_s_combatd",lTargeted,FALSE);
       SetLocalInt(oPLC,"level",nPCLevel);
       SetLocalObject(oPLC,"trainer",oPC);
       SetLocalObject(oJobJournal,"spawnedplc"+IntToString(nNode),oPLC);
     }

   }
   //


   // Scholar / Artist / Smith / RCraftsman / Tailor / Jeweler Writing Script
   if(nNode == 41)// Set Name
   {
     sWrittenAlready = GetLocalInt(oTargeted,"scholarnameset");
     if(sWrittenAlready == 0) // Only lets it be set once
     {
       sTalkCustom = GetLocalString(oPC,"setcustomtoken");
       SetName(oTargeted,"<c~Îë>"+sTalkCustom+"</c>");
       DeleteLocalString(oPC,"setcustomtoken");
       SetLocalInt(oTargeted,"scholarnameset",1);
       SetCustomToken(92308831,"");
       DeleteLocalString(oPC,"last_chat");
     }
     else if(sWrittenAlready == 1)
     {
       SendMessageToPC(oPC,"The name has already been set for this item.");
     }
   }
   else if(nNode == 42)// Set Description
   {
     sWrittenAlready = GetLocalInt(oTargeted,"scholardescriptionset");
     if(sWrittenAlready == 0) // Only lets it be set once
     {
       sTalkCustom = GetLocalString(oPC,"setcustomtoken");
       SetDescription(oTargeted,"<c~Îë>"+sTalkCustom+"</c>",TRUE);
       DeleteLocalString(oPC,"setcustomtoken");
       SetLocalInt(oTargeted,"scholardescriptionset",1);
       SetCustomToken(92308831,"");
       DeleteLocalString(oPC,"last_chat");
     }
     else if(sWrittenAlready == 1)
     {
       SendMessageToPC(oPC,"The descrption has already been set for this item.");
     }
   }
   //


   // Scoundrel / Merchant Cost Checking Script
   if(nNode == 43)
   {
     SendMessageToPC(oPC,"This item appears to be worth: "+IntToString(GetGoldPieceValue(oTargeted))+" Gold Pieces.");
   }
   //


   // Physician Script
   if(nNode == 44)        // Self buff for Heal
   {
     eLoop = GetFirstEffect(oPC);
     // Checks for the buff on the caster PC. If present stops casting.
     while(GetIsEffectValid(eLoop))
     {
       eLoopSpellID = GetEffectSpellId(eLoop);

       if ((GetEffectTag(eLoop) == "physicianselfbuff"))
       {
         FloatingTextStringOnCreature("*You cannot buff yourself again till the old effects fade*",oPC);
         DS_CLEAR_ALL(oPC);
         return;
       }
         eLoop=GetNextEffect(oPC);
      }
     //

     if(sPrimaryJob == "Physician")
     {
       ePrimaryEffect = EffectSkillIncrease(SKILL_HEAL,10);
     }
     else if(sSecondaryJob == "Physician")
     {
       ePrimaryEffect = EffectSkillIncrease(SKILL_HEAL,5);
     }
     eVFX = EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_WHITE);
     // Buffs based on if physician is primary or secondary
     eLink = EffectLinkEffects(eVFX,ePrimaryEffect);
     eLink = TagEffect(eLink,"physicianselfbuff");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC,600.0);
     FloatingTextStringOnCreature("*You pull out some material and refresh yourself on healing methods*",oPC);


   }
   else if(nNode == 48)   //  Physican buff
   {
     eLoop = GetFirstEffect(oTargeted);
     // Checks for the buff on the caster PC. If present stops casting.
     while(GetIsEffectValid(eLoop))
     {
       eLoopSpellID = GetEffectSpellId(eLoop);

       if ((GetEffectTag(eLoop) == "physicianbuff"))
       {
         FloatingTextStringOnCreature("*You cannot buff again till the old effects fade*",oPC);
         DS_CLEAR_ALL(oPC);
         return;
       }
         eLoop=GetNextEffect(oTargeted);
      }
     //

     if(sPrimaryJob == "Physician")
     {
       ePrimaryEffect = EffectAbilityIncrease(ABILITY_CONSTITUTION,3);
       eSecondaryEffect = EffectRegenerate(1,6.0);
     }
     else if(sSecondaryJob == "Physician")
     {
       ePrimaryEffect = EffectAbilityIncrease(ABILITY_CONSTITUTION,1);
       eSecondaryEffect = EffectRegenerate(1,6.0);
     }
     eVFX = EffectVisualEffect(VFX_DUR_AURA_YELLOW_LIGHT);
     // Buffs based on if physician is primary or secondary
     eLink = EffectLinkEffects(eVFX,ePrimaryEffect);
     eLink = EffectLinkEffects(eSecondaryEffect,eLink);
     eLink = TagEffect(eLink,"physicianbuff");
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTargeted,600.0);
     FloatingTextStringOnCreature("*You begin to work on your patient to make them feel better*",oPC);
   }
   else if(nNode == 49)   //  Currently blank for later development
   {
   }
   //


   // Devout Spirtual Buff and PLC Spawn Ins
   if((nNode == 45))   // Party Buff
   {

     eLoop = GetFirstEffect(oPC);
     // Checks for the buff on the caster PC. If present stops casting.
     while(GetIsEffectValid(eLoop))
     {
       eLoopSpellID = GetEffectSpellId(eLoop);

       if ((GetEffectTag(eLoop) == "devoutbuff"))
       {
         FloatingTextStringOnCreature("*You cannot motivate the party again till your current speech's effects fade*",oPC);
         DS_CLEAR_ALL(oPC);
         return;
       }
         eLoop=GetNextEffect(oPC);
      }
     //

     if(sPrimaryJob == "Devout")
     {
       ePrimaryEffect = EffectTemporaryHitpoints(nTempHp);
       eSecondaryEffect = EffectSavingThrowIncrease(SAVING_THROW_WILL,2);
     }
     else if(sSecondaryJob == "Devout")
     {
       ePrimaryEffect = EffectTemporaryHitpoints(nTempHp/2);
       eSecondaryEffect = EffectSavingThrowIncrease(SAVING_THROW_WILL,1);
     }
     eVFX = EffectVisualEffect(VFX_DUR_BARD_SONG);
     // Buffs based on if devout is primary or secondary
     eLink = EffectLinkEffects(eVFX,ePrimaryEffect);
     eSecondaryEffect = TagEffect(eSecondaryEffect,"devoutbuff");
     eLink = TagEffect(eLink,"devoutbuff");

     // Applying the buff to PCs
     oPartyCheck = GetFirstPC();

     while(GetIsObjectValid(oPartyCheck))
     {

       if(ds_check_partymember(oPC, oPartyCheck)) // Checking to see if they are a party member
       {
         if(GetDistanceBetween(oPC,oPartyCheck) < 30.0)// Making sure they are nearby
         {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPartyCheck,600.0);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSecondaryEffect, oPartyCheck,600.0);
         }
       }

       oPartyCheck = GetNextPC();
     }
     FloatingTextStringOnCreature("*You give a motivating and inspiring speech*",oPC);
     //

   }
   else if((nNode == 46) || (nNode == 47))// Lectrum / Altar Spawning      sResource
   {


     oPLC = GetLocalObject(oJobJournal, "spawnedplc"+IntToString(nNode));

     if(GetIsObjectValid(oPLC))
     {
       FloatingTextStringOnCreature("*Removing PLC*",oPC);
       DestroyObject(oPLC);
       DeleteLocalObject(oJobJournal,"spawnedplc");
     }
     else
     {
       FloatingTextStringOnCreature("*Spawning PLC*",oPC);
       oPLC = CreateObject(OBJECT_TYPE_PLACEABLE,sResource,lTargeted,FALSE);
       SetLocalObject(oJobJournal,"spawnedplc"+IntToString(nNode),oPLC);
     }

   }
   //


  // Merchant Script
  if((nNode >= 50) && (nNode <= 79))
  {
    if(GetLocalInt(oPC,"merchantchestisout") == 0)
    {
      oPLC = CreateObject(OBJECT_TYPE_PLACEABLE,"js_merchantbox",lTargeted);
      SetLocalInt(oPC,"merchantchestisout",1);
      SetLocalInt(oPLC,"storageboxnumber",nNode-49);
      if(GetLocalString(oJobJournal,"storagename"+IntToString(nNode-49)) != "")
      {
        SetName(oPLC,"<c~Îë>"+GetLocalString(oJobJournal,"storagename"+IntToString(nNode-49))+" Storage Box"+"</c>");
      }
      else
      {
        SetName(oPLC,"<c~Îë>Empty Storage Box</c>");
      }
    }
    else
    {
      SendMessageToPC(oPC,"Only one chest is allowed out at a time");
    }
  }

  if(nNode == 82) // Create Chest
  {
     if((GetResRef(oTargeted) == "js_chest_kit") && (GetGold(oPC) >= 10000))
     {
        CreateItemOnObject("js_mini_merchest",oPC);
		TakeGoldFromCreature(10000, oPC, TRUE);
		DestroyObject(oTargeted) == "js_chest_kit");
        SendMessageToPC(oPC,"Merchant Chest created!");
     }
     else if((GetResRef(oTargeted) == "js_chest_kit"))
     {
        SendMessageToPC(oPC,"Not enough gold! You require 10k!");
     }
     else
     {
        SendMessageToPC(oPC,"You must target a Merchant Chest Kit to complete it!");
     }
  }

  if(nNode == 83) // Transfer Resources
  {
     if((GetResRef(oTargeted) == "js_mini_merchest"))
     {
       int nChestNumber = 1;
       int nStoredAmount;
       int nTransferAmount = StringToInt(GetLocalString(oPC,"setcustomtoken"));
       int nMiniChestAmount = GetLocalInt(oTargeted,"storageboxcount");
       string sStoredItem;
       string sMiniChestStoredItem = GetLocalString(oTargeted,"storagebox");

       if(nTransferAmount == 0)
       {
           SendMessageToPC(oPC, "Please enter a valid amount!");
           DS_CLEAR_ALL(oPC);
           return;
       }

       if(sMiniChestStoredItem == "")
       {
           SendMessageToPC(oPC, "You must set the Mini Chest to a resource type first!");
           DS_CLEAR_ALL(oPC);
           return;
       }

       while(nChestNumber < 31)
       {
         sStoredItem = GetLocalString(oJobJournal,"storagebox"+IntToString(nChestNumber));
         nStoredAmount = GetLocalInt(oJobJournal,"storagebox"+IntToString(nChestNumber)+"amount");

         if(nTransferAmount > nStoredAmount)
         {
           SendMessageToPC(oPC, "You cannot transfer more resources than are in your chest!");
           DS_CLEAR_ALL(oPC);
           return;
         }

         if(sStoredItem == sMiniChestStoredItem)
         {
           SetLocalInt(oJobJournal,"storagebox"+IntToString(nChestNumber)+"amount",nStoredAmount-nTransferAmount);
           SetLocalInt(oTargeted,"storageboxcount",nMiniChestAmount+nTransferAmount);
           SetDescription(oTargeted,"Item Count Stored: " + IntToString(nMiniChestAmount+nTransferAmount));
           nChestNumber = 31;
         }
         nChestNumber++;
       }

       if(nChestNumber == 31)
       {
        SendMessageToPC(oPC,"Matching resources could not be found to transfer!");
       }
       else if(nChestNumber == 32)
       {
        SendMessageToPC(oPC,"Transfer complete!");
       }

     }
     else
     {
        SendMessageToPC(oPC,"You need to target a mini merchant chest!");
     }

  }
  //


  DS_CLEAR_ALL(oPC);


}

void DS_CLEAR_ALL(object oPC)
{

   SetLocalInt( oPC, "ds_node", 0 );
   SetLocalString( oPC, "ds_action", "" );
   DeleteLocalInt(oPC,"ds_check_1");
   DeleteLocalInt(oPC,"ds_check_2");
   DeleteLocalInt(oPC,"ds_check_3");
   DeleteLocalInt(oPC,"ds_check_4");
   DeleteLocalInt(oPC,"ds_check_5");
   DeleteLocalInt(oPC,"ds_check_6");
   DeleteLocalInt(oPC,"ds_check_7");
   DeleteLocalInt(oPC,"ds_check_8");
   DeleteLocalInt(oPC,"ds_check_9");
   DeleteLocalInt(oPC,"ds_check_10");
   DeleteLocalInt(oPC,"ds_check_11");
   DeleteLocalInt(oPC,"ds_check_12");
   DeleteLocalInt(oPC,"ds_check_13");
   DeleteLocalInt(oPC,"ds_check_14");
   DeleteLocalInt(oPC,"ds_check_15");
   DeleteLocalInt(oPC,"ds_check_16");
   DeleteLocalInt(oPC,"ds_check_17");
   DeleteLocalInt(oPC,"ds_check_18");
   DeleteLocalInt(oPC,"ds_check_19");

}

void DS_CLEAR_CHECK(object oPC)
{

   DeleteLocalInt(oPC,"ds_check_1");
   DeleteLocalInt(oPC,"ds_check_2");
   DeleteLocalInt(oPC,"ds_check_3");
   DeleteLocalInt(oPC,"ds_check_4");
   DeleteLocalInt(oPC,"ds_check_5");
   DeleteLocalInt(oPC,"ds_check_6");
   DeleteLocalInt(oPC,"ds_check_7");
   DeleteLocalInt(oPC,"ds_check_8");
   DeleteLocalInt(oPC,"ds_check_9");
   DeleteLocalInt(oPC,"ds_check_10");
   DeleteLocalInt(oPC,"ds_check_11");
   DeleteLocalInt(oPC,"ds_check_12");
   DeleteLocalInt(oPC,"ds_check_13");
   DeleteLocalInt(oPC,"ds_check_14");
   DeleteLocalInt(oPC,"ds_check_15");
   DeleteLocalInt(oPC,"ds_check_16");
   DeleteLocalInt(oPC,"ds_check_17");
   DeleteLocalInt(oPC,"ds_check_18");
   DeleteLocalInt(oPC,"ds_check_19");

}
