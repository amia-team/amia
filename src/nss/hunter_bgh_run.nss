void main()
{
   object oPC = GetLastUsedBy();
   FadeToBlack(oPC,FADE_SPEED_FASTEST );
   BeginConversation("c_hunter_bgh",oPC);
}
