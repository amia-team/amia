//:: FileName jes_xpdown
//:: Created By: Jes
//:: Created On: 28/4/2019

void RemoveXPFromParty(int nXP, object oPC, int bAllParty=TRUE)
{

if (!bAllParty)
   {
   nXP=(GetXP(oPC)-nXP)>=0 ? GetXP(oPC)-nXP : 0;
   SetXP(oPC, nXP);
   }
else
   {
   object oMember=GetFirstFactionMember(oPC, TRUE);

   while (GetIsObjectValid(oMember))
      {
      nXP=(GetXP(oMember)-nXP)>=0 ? GetXP(oMember)-nXP : 0;
      SetXP(oMember, nXP);
      oMember=GetNextFactionMember(oPC, TRUE);
      }
   }
}
void main()
{

object oPC = GetPCSpeaker();

RemoveXPFromParty(432000, oPC, FALSE);

}
