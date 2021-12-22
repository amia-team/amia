/*BLACKSMITH SCRIPT
Created by
Lilac Soul's NWN Script Generator, v. 1.6
for download info please visit
http://lilacsoul.revility.com
*/

int lsn=7;
//lsstype=2

void SetItemLocals()
{
SetLocalString(OBJECT_SELF, "lsn1", "medkitx1x10");
SetLocalInt(OBJECT_SELF, "lsc_medkitx1x10", 3);
SetLocalString(OBJECT_SELF, "lsi1_medkitx1x10", "basehealerskit1");
SetLocalString(OBJECT_SELF, "lsi2_medkitx1x10", "athelasleaves");
SetLocalString(OBJECT_SELF, "lsi3_medkitx1x10", "butterflymush");
SetLocalInt(OBJECT_SELF, "lss_medkitx1x10", -10);
SetLocalInt(OBJECT_SELF, "lsv_medkitx1x10", VFX_FNF_DISPEL_GREATER);

SetLocalString(OBJECT_SELF, "lsn2", "medkitx3x10");
SetLocalInt(OBJECT_SELF, "lsc_medkitx3x10", 3);
SetLocalString(OBJECT_SELF, "lsi1_medkitx3x10", "basehealerskit3");
SetLocalString(OBJECT_SELF, "lsi2_medkitx3x10", "chinchonabark");
SetLocalString(OBJECT_SELF, "lsi3_medkitx3x10", "glowberries");
SetLocalInt(OBJECT_SELF, "lss_medkitx3x10", -10);
SetLocalInt(OBJECT_SELF, "lsv_medkitx3x10", VFX_FNF_DISPEL_GREATER);

SetLocalString(OBJECT_SELF, "lsn3", "medkitx6x10");
SetLocalInt(OBJECT_SELF, "lsc_medkitx6x10", 3);
SetLocalString(OBJECT_SELF, "lsi1_medkitx6x10", "basehealerskit6");
SetLocalString(OBJECT_SELF, "lsi2_medkitx6x10", "forestheart");
SetLocalString(OBJECT_SELF, "lsi3_medkitx6x10", "morningglory");
SetLocalInt(OBJECT_SELF, "lss_medkitx6x10", -10);
SetLocalInt(OBJECT_SELF, "lsv_medkitx6x10", VFX_FNF_DISPEL_GREATER);

SetLocalString(OBJECT_SELF, "lsn4", "medkitx10x10");
SetLocalInt(OBJECT_SELF, "lsc_medkitx10x10", 4);
SetLocalString(OBJECT_SELF, "lsi1_medkitx10x10", "basehealerskit10");
SetLocalString(OBJECT_SELF, "lsi2_medkitx10x10", "forestheart");
SetLocalString(OBJECT_SELF, "lsi3_medkitx10x10", "forestheart");
SetLocalString(OBJECT_SELF, "lsi4_medkitx10x10", "roselily");
SetLocalInt(OBJECT_SELF, "lss_medkitx10x10", -10);
SetLocalInt(OBJECT_SELF, "lsv_medkitx10x10", VFX_FNF_DISPEL_GREATER);

SetLocalString(OBJECT_SELF, "lsn5", "craftedheal");
SetLocalInt(OBJECT_SELF, "lsc_craftedheal", 3);
SetLocalString(OBJECT_SELF, "lsi1_craftedheal", "baseheal");
SetLocalString(OBJECT_SELF, "lsi2_craftedheal", "morningglory");
SetLocalString(OBJECT_SELF, "lsi3_craftedheal", "roselily");
SetLocalInt(OBJECT_SELF, "lss_craftedheal", -10);
SetLocalInt(OBJECT_SELF, "lsv_craftedheal", VFX_FNF_DISPEL_GREATER);

SetLocalString(OBJECT_SELF, "lsn6", "craftedrestore");
SetLocalInt(OBJECT_SELF, "lsc_craftedrestore", 5);
SetLocalString(OBJECT_SELF, "lsi1_craftedrestore", "restorebase");
SetLocalString(OBJECT_SELF, "lsi2_craftedrestore", "butterflymush");
SetLocalString(OBJECT_SELF, "lsi3_craftedrestore", "butterflymush");
SetLocalString(OBJECT_SELF, "lsi4_craftedrestore", "glowberries");
SetLocalString(OBJECT_SELF, "lsi5_craftedrestore", "glowberries");
SetLocalInt(OBJECT_SELF, "lss_craftedrestore", -10);
SetLocalInt(OBJECT_SELF, "lsv_craftedrestore", VFX_FNF_DISPEL_GREATER);

SetLocalString(OBJECT_SELF, "lsn7", "craftedpotionofg");
SetLocalInt(OBJECT_SELF, "lsc_craftedpotionofg", 8);
SetLocalString(OBJECT_SELF, "lsi1_craftedpotionofg", "greatrestorepot");
SetLocalString(OBJECT_SELF, "lsi2_craftedpotionofg", "perfectionseeds");
SetLocalString(OBJECT_SELF, "lsi3_craftedpotionofg", "athelasleaves");
SetLocalString(OBJECT_SELF, "lsi4_craftedpotionofg", "butterflymush");
SetLocalString(OBJECT_SELF, "lsi5_craftedpotionofg", "chinchonabark");
SetLocalString(OBJECT_SELF, "lsi6_craftedpotionofg", "glowberries");
SetLocalString(OBJECT_SELF, "lsi7_craftedpotionofg", "morningglory");
SetLocalString(OBJECT_SELF, "lsi8_craftedpotionofg", "roselily");
SetLocalInt(OBJECT_SELF, "lss_craftedpotionofg", -10);
SetLocalInt(OBJECT_SELF, "lsv_craftedpotionofg", VFX_FNF_DISPEL_GREATER);

}

void CreateGold(object oTarget, int nAmount)
{
CreateItemOnObject("nw_it_gold001", oTarget, nAmount);
}

void main()
{
object oOwner=OBJECT_SELF;

if (!GetLocalInt(OBJECT_SELF, "lsvar_set"))
{
SetItemLocals();
SetLocalInt(OBJECT_SELF, "lsvar_set", TRUE);
}

if (lsn==0) return;

object oItem;
int bOkay, nGold, nCount, nNum, nLoop, nLoops, nHasGold, nVis;
string sCur, sReq;

for (nLoop=1; nLoop<=lsn; nLoop++)
   {
   sCur=GetLocalString(OBJECT_SELF, "lsn"+IntToString(nLoop));

   nNum=GetLocalInt(OBJECT_SELF, "lsc_"+sCur);

   for (nLoops=1; nLoops<=nNum; nLoops++)
      {

      sReq=GetLocalString(OBJECT_SELF, "lsi"+IntToString(nLoops)+"_"+sCur);
      if (GetStringLeft(sReq, 8)=="  gold  ")
         {
         nGold=StringToInt(GetStringRight(sReq, GetStringLength(sReq)-8));
         if (GetGold(oOwner)>=nGold) nCount++;

         }
      else if (GetItemPossessedBy(oOwner, sReq)!=OBJECT_INVALID)
         {
         SetLocalObject(OBJECT_SELF, "ls__"+IntToString(nLoops), GetItemPossessedBy(oOwner, sReq));

         nCount++;
         }
      }

   if (GetLocalInt(OBJECT_SELF, "lss_"+sCur)==-10) bOkay=TRUE;
   else if (GetLastSpell()==GetLocalInt(OBJECT_SELF, "lss_"+sCur)) bOkay=TRUE;
   else bOkay=FALSE;

   if (bOkay && (nCount==nNum)) bOkay=TRUE;
   else bOkay=FALSE;
   if (bOkay==TRUE)
      {

      if (nGold>0)
      {
      nHasGold=GetGold(oOwner);
      DestroyObject(GetItemPossessedBy(oOwner, "NW_IT_GOLD001"));
      DelayCommand(0.2, CreateGold(oOwner, nHasGold-nGold));
      }
      for (nLoops=1; nLoops<=nNum; nLoops++)
         {
         oItem=GetLocalObject(OBJECT_SELF, "ls__"+IntToString(nLoops));
         DestroyObject(oItem);
         }
      CreateItemOnObject(sCur, oOwner);
      int nVis=GetLocalInt(OBJECT_SELF, "lsv_"+sCur);
      if (nVis!=-10) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), oOwner);
      }

   oItem=OBJECT_INVALID;
   bOkay=FALSE;
   nGold=0;
   nCount=0;
   sCur="";
   sReq="";
   nNum=0;
   }
}

