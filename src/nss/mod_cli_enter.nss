#include "nw_i0_tool"
#include "amia_include"
#include "inc_dc_api"
#include "sql_api_players"
#include "class_effects"
#include "inc_call_time"
#include "inc_player_api"

void CreateItemsOnPlayer(object enteringPlayer);
void CheckPrereq(object oPC);
void DailyDC(object oPC);
void CheckWeeklyReset(object oPC);

string sLevels;
int FindPreviousLevel( string sVar )
{
  string sTmp;
  int iPos = FindSubString( sLevels, sVar );
  if ( iPos > -1 )
  {
    iPos += GetStringLength( sVar);
    while ( GetSubString( sLevels, iPos, 1 ) != ";" )
      sTmp += GetSubString( sLevels, iPos++, 1 );
    if ( sTmp != "" )
    {
      return StringToInt( sTmp );
    }
  }
  return -100;
}

void main(){
    object enteringPlayer = GetEnteringObject();

    if(GetIsPlayerBanned(GetPCPublicCDKey(enteringPlayer, TRUE)))
    {
      BootPC(enteringPlayer, "You have been banned. If you believe this was an error, please contact a DM over Discord.");
    }

    if(GetIsDM(enteringPlayer))
    {
        return; // Do nothing, for now.
    }

    object oPCKey = GetItemPossessedBy(enteringPlayer, "ds_pckey");
    int nLycan = GetLocalInt(oPCKey, "lycanapproved");

    if(nLycan == 1)
    {
      SetLocalInt(enteringPlayer,"Prereq_Lycan",1);
    }
    //RDD SR and Immunity Calculations
    int nDDLevels = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,enteringPlayer);
    int nSRIncrease = 0;
    int nImmunityIncrease = 0;
    int nImmunityType;

    // SR
    if(nDDLevels == 20)
    {
      nSRIncrease = 32;
    }
    else if(nDDLevels >= 18)
    {
      nSRIncrease = 24;
    }

    // Immunity % levels
    if(nDDLevels == 20)
    {
      nImmunityIncrease = 100;
    }
    else if(nDDLevels >= 15)
    {
      nImmunityIncrease = 75;
    }
    else if(nDDLevels >= 10)
    {
      nImmunityIncrease = 50;
    }

    // Immunity Type
    if( GetHasFeat( 965, enteringPlayer ) == 1 )
    {// Fire
      nImmunityType = DAMAGE_TYPE_FIRE;
    }
    else if( GetHasFeat( 1210, enteringPlayer ) == 1 )
    {// Fire
      nImmunityType = DAMAGE_TYPE_FIRE;
    }
    else if( GetHasFeat( 1211, enteringPlayer ) == 1 )
    {// Cold
      nImmunityType = DAMAGE_TYPE_COLD;
    }
    else if( GetHasFeat( 1212, enteringPlayer ) == 1 )
    {// Negative
      nImmunityType = DAMAGE_TYPE_NEGATIVE;
    }
    else if( GetHasFeat( 1213, enteringPlayer ) == 1 )
    {// Gas
      nImmunityType = DAMAGE_TYPE_ACID;
    }
    else if( GetHasFeat( 1214, enteringPlayer ) == 1 )
    {// Acid
      nImmunityType = DAMAGE_TYPE_ACID;
    }
    else if( GetHasFeat( 1215, enteringPlayer ) == 1 )
    {//Electric
      nImmunityType = DAMAGE_TYPE_ELECTRICAL;
    }

    effect eImmunityIncrease = EffectDamageImmunityIncrease(nImmunityType,nImmunityIncrease);
    effect eSR = EffectSpellResistanceIncrease(nSRIncrease);
    effect eLink = EffectLinkEffects(eImmunityIncrease, eSR);
    eLink = SupernaturalEffect(eLink);
    eLink = TagEffect(eLink,"DDBonuses");

    if(nDDLevels >= 10)
    {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLink,enteringPlayer);
    }
    //RDD SR and Immunity Calculations end



    //Death Tracker script.
    int index, iLev, iCurLev;
  object oPC = GetEnteringObject();
  sLevels = GetCampaignString( "Amia", GetPCPlayerName( oPC ) + GetName( oPC ) + "Levels" );
  if ( sLevels != "" )
  {
    iCurLev = GetCurrentHitPoints( oPC );
    iLev = FindPreviousLevel( "HP=" );
    if ( iLev > -100 && iCurLev > iLev )
    {
      effect eDamage = EffectDamage( iCurLev - iLev, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY );
      ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC );
    }
    for( index = 0; index < 622; index++ )
    {
      iCurLev = GetHasSpell( index, oPC );
      if ( iCurLev > 0 )
      {
        iLev = FindPreviousLevel( "S" + IntToString( index ) + "=" );
        if ( iLev == -100 )
           iLev = 0;
        while ( iLev < iCurLev )
        {
          DecrementRemainingSpellUses( oPC, index );
          iLev++;
        }
      }
    }
    for( index = 0; index < 480; index++ )
    {
      iCurLev = GetHasFeat( index, oPC );
      if ( iCurLev > 0 )
      {
        iLev = FindPreviousLevel( "F" + IntToString( index ) + "=" );
        if ( iLev == -100 )
          iLev = 0;
        while ( iLev < iCurLev )
        {
          DecrementRemainingFeatUses( oPC, index );
          iLev++;
        }
      }
    }
  }
  //End of Death Tracker script.

    //Negative AB for Heritage feat for Drow/Svir
    effect eNegativeAB = EffectAttackDecrease(1,ATTACK_BONUS_MISC);
    eNegativeAB = SupernaturalEffect(eNegativeAB);

    if(((GetRacialType(oPC) == 33) || (GetRacialType(oPC) == 36)) && GetHasFeat(1238,oPC))
    {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT,eNegativeAB,oPC);
    }


    // Initial setup for player.
    string cdkey = GetPCPublicCDKey(enteringPlayer);
    if(!DreamcoinAccountExists(cdkey))
    {
        SQL_SetupPlayerAccount(cdkey);
        SetupDreamcoinAccount(cdkey);
    }

    int playerXp = GetXP(enteringPlayer);
    int nGold = 5000;


    ApplyAreaAndRaceEffects( enteringPlayer, 1);
    if (playerXp < 2000){
        SetXP(enteringPlayer, 2000);

        GiveGoldToCreature( enteringPlayer, 5000);
        GiveXPToCreature( enteringPlayer, 2000 );


        DelayCommand(1.0f, CreateItemsOnPlayer(enteringPlayer));
    }
    // Daily DC check and weekly DC reset
    if(!GetIsDM(oPC))
    {
    CheckWeeklyReset(oPC);
    DailyDC(oPC);
    }

    if (GetLocalInt(oPC,"HIPSCooldown") != 0) {
        DeleteLocalInt(oPC,"HIPSCooldown");
    }

    //Check DwD and AA prereq
    CheckPrereq( oPC );

    ExecuteScript("race_effects", enteringPlayer); //
    ExecuteScript("subrace_effects", enteringPlayer);
    ExecuteScript("char_templates", enteringPlayer);

}


void CreateItemsOnPlayer(object enteringPlayer)
{
    CreateItemOnObject("ds_dicebag", enteringPlayer);
    CreateItemOnObject("dmfi_pc_emote2", enteringPlayer);
    CreateItemOnObject("ds_pvp_tool", enteringPlayer);
    CreateItemOnObject("pc_dcrod", enteringPlayer);
    CreateItemOnObject("ds_party_item", enteringPlayer);

    object oClothes = CreateItemOnObject( "newb_cloth", enteringPlayer );
    AssignCommand( enteringPlayer, ActionEquipItem( oClothes, INVENTORY_SLOT_CHEST ) );
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

   if((nBAB >= 6) && (nFeatPBS == 1) && ((nRacePC == 1) || (nRacePC == 4) || (nRacePC == 32) || (nRacePC == 33) || (nRacePC == 34) || (nRacePC == 35) || (nRacePC == 41)) && ((nFeatWFShortbow == 1) || (nFeatWFLongbow == 1)) && ((nBardLevel >= 1) || (nSorcLevel >= 1) || (nWizLevel >= 1) || (nAssLevel >= 1)))
   {
     SetLocalInt(oPC,"Prereq_AA",1);
   }
}

void DailyDC(object oPC)
{

   string pcCdKey = GetPCPublicCDKey(oPC);
   int nWeeklyCnt = GetCampaignInt(pcCdKey,"WeeklyDCCount");
   int nCurrentDay = ReturnCurrentDay();
   int nLastDCDay = GetCampaignInt(pcCdKey,"nLastDCDay");
   object oModule = GetModule();

   object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");

   // If its their first time coming onto the server, set value
   if((nLastDCDay == 0))
   {
      SetCampaignInt(pcCdKey,"nLastDCDay",nCurrentDay);
       if ( GetLocalInt (oModule, "testserver") == 1 )
        { return;
        }
      if(nWeeklyCnt < 10)
      {
       ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oPC);
       SendMessageToPC(oPC,"You have recieved a daily log-in DC!");
       SetCampaignInt(pcCdKey,"WeeklyDCCount",nWeeklyCnt+1);

       int playerDreamCoins = GetDreamCoins(pcCdKey);
       SetDreamCoins(pcCdKey, playerDreamCoins + 1);

      }
      else
      {
       SendMessageToPC(oPC,"You have hit your weekly cap of automated DCs!");
      }
   }
   else // They have logged in before
   {
       if((nLastDCDay < nCurrentDay))
       {
         SetCampaignInt(pcCdKey,"nLastDCDay",nCurrentDay);
         if(nWeeklyCnt < 10)
         {
           SendMessageToPC(oPC,"You have recieved a daily log-in DC!");
           SendMessageToPC(oPC,"Automated DCs earned so far this week: " + IntToString(nWeeklyCnt+1));
           SetCampaignInt(pcCdKey,"WeeklyDCCount",nWeeklyCnt+1);

           int playerDreamCoins = GetDreamCoins(pcCdKey);
           SetDreamCoins(pcCdKey, playerDreamCoins + 1);

         }
         else
         {
          SendMessageToPC(oPC,"You have hit your weekly cap of automated DCs!");
         }
        }

   }


}

void CheckWeeklyReset(object oPC)
{

   string PcCdKey = GetPCPublicCDKey(oPC);
   int nCurrentWeek = ReturnCurrentWeek();
   int nLastPCWeek = GetCampaignInt(PcCdKey,"LastWeek");

   if(nCurrentWeek > nLastPCWeek)
   {
     SetCampaignInt(PcCdKey,"WeeklyDCCount",0);
     SetCampaignInt(PcCdKey, "LastWeek", nCurrentWeek);
     SetCampaignInt(PcCdKey, "nPCTime", 0);
   }

}