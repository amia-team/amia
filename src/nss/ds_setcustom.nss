/*

    Set Custom Token for talk scripts

*/
void main()
{
   object oPC = GetPCSpeaker();
   string sTalked = GetLocalString( oPC, "last_chat");
   SetCustomToken(92308831,sTalked);
   SetLocalString(oPC,"setcustomtoken",sTalked);
}
