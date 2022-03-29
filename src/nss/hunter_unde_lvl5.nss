int StartingConditional()
{
   object oPC = GetPCSpeaker();
   int nPCLevel = GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC);

   if(nPCLevel >= 5)
   {
     return FALSE;
   }
   else
   {
     return TRUE;
   }
}
