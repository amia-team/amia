void main()
{
   object oPC = GetLastUsedBy();
   object oFaction = GetObjectByTag("f_preyt");
   int nRep = GetReputation(oFaction,oPC);
   if(nRep <= 10)
   {
    AdjustReputation(oPC,oFaction,50);
    AdjustReputation(oFaction,oPC,50);
   }
   BeginConversation("c_hunter_exit",oPC);
}
