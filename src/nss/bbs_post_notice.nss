#include "bbs_include"
#include "nwnx_webhook"
void main()
{
  object oPC = GetPCSpeaker();
  object oNotice = GetItemPossessedBy(oPC, "bbs_notice");
  if (GetIsObjectValid(oNotice))
  {
    //string nPoster = GetName(oPC) + " (" + GetPCPlayerName(oPC) + ")";
    string nPoster = GetLocalString(oNotice, "bbs_Name");
    string nTitle = GetLocalString(oNotice, "bbs_Title");
    string nMessage = GetLocalString(oNotice, "bbs_Message");
    ActionTakeItem(oNotice, oPC);
    bbs_add_notice(OBJECT_SELF, nPoster, nTitle, nMessage, "");
    NWNX_WebHook_SendWebHookHTTPS("discord.com", "/api/webhooks/750101475073589328/5CQTYgnR92sjiNoEXc8EBA0TDcGyLJ1BcIrdZV9gLdmy9H1qNPtarK6xF7UOs9wn-aLr/slack", nMessage);
    bbs_change_page(-1000);
  }
  object oPCS = GetFirstPC();
  while ( oPCS != OBJECT_INVALID )
  {
    SendMessageToPC(oPCS, "<c¦ ¦>Bulletin boards around the isle have been updated with new postings.</c>");
    oPCS = GetNextPC();
  }
}
