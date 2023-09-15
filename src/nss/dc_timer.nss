 /*
    Maverick00053 - DC_Timer Script

    A consistent 5 minute timer to add time to players accounts till
    they hit 2 hours, and grant them a DC as a result.

    13/jul/2023     Jes         Added auto DM payment, same script with no weekly cap.
    11/sep/2023     Frozen      Changed dc to uncapped
*/


#include "inc_dc_api"

void main()
{
  object oModule = GetModule();
  object oPlayer = GetFirstPC();
  string PcCdKey = GetPCPublicCDKey(oPlayer);
  int nWeeklyCnt;
  int nPCTime;

  while(GetIsObjectValid(oPlayer))
  {

    if(!GetIsDM(oPlayer))
    {
    PcCdKey = GetPCPublicCDKey(oPlayer);
    nPCTime = GetCampaignInt(PcCdKey, "nPCTime");
    nPCTime = nPCTime + 5;
    nWeeklyCnt = GetCampaignInt(PcCdKey, "WeeklyDCCount");


    if(nPCTime >= 120) // 2 Hours
    {
       if ( GetLocalInt (oModule, "testserver") == 1 )
        { return;
        }
       else //(nWeeklyCnt < 10)
       {

         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oPlayer);
         SendMessageToPC(oPlayer,"You have earned a DC for playing for 2 hours!");
         SendMessageToPC(oPlayer,"Automated DCs earned so far this week: " + IntToString(nWeeklyCnt+1));
         SetCampaignInt(PcCdKey,"WeeklyDCCount",nWeeklyCnt+1);

         int playerDreamCoins = GetDreamCoins(PcCdKey);
         SetDreamCoins(PcCdKey, playerDreamCoins + 1);

       }
       /*
       else
       {
         SendMessageToPC(oPlayer,"You have hit your weekly cap of automated DCs!");
       }
       */
       SetCampaignInt(PcCdKey, "nPCTime", 0);
    }
    else
    {
     SetCampaignInt(PcCdKey, "nPCTime", nPCTime);
    }

    }

    if(GetIsDM(oPlayer))
    {
    PcCdKey = GetPCPublicCDKey(oPlayer);
    nPCTime = GetCampaignInt(PcCdKey, "nPCTime");
    nPCTime = nPCTime + 5;

    if(nPCTime >= 120) // 2 Hours
    {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oPlayer);
         SendMessageToPC(oPlayer,"You have earned 2 DC's for DM'ing for 2 hours!");

         int playerDreamCoins = GetDreamCoins(PcCdKey);
         SetDreamCoins(PcCdKey, playerDreamCoins + 2);

         SetCampaignInt(PcCdKey, "nPCTime", 0);
    }
    else
    {
     SetCampaignInt(PcCdKey, "nPCTime", nPCTime);
    }

    }

    oPlayer = GetNextPC();
  }


  DelayCommand(300.0,ExecuteScript("dc_timer",oModule));
}
