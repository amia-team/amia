/*
   Lycan On Hit
   ------------
   Will have a chance to infect on hit, will scale with level.

   12/10/21 - Maverick00053
   Edit: 12/7/23 - Maverick00053
*/

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwnx_feat"
#include "nwnx_creature"

void main()
{
    object oLycan = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    string sLycanType = GetLocalString(oLycan, "lycanType");
    int nLevel = GetLevelByPosition(1,oTarget) + GetLevelByPosition(2,oTarget) + GetLevelByPosition(3,oTarget);
    int nRandom = Random(4*nLevel) + 1;
    int nInfectedCheck = GetPCKEYValue(oTarget,"lycanInfected");


    ;

    if((GetHasFeat(1249,oTarget) == TRUE) || (GetHasFeat(1250,oTarget) == TRUE) || (GetHasFeat(1251,oTarget) == TRUE)
    || (GetHasFeat(1252,oTarget) == TRUE) || (GetHasFeat(1253,oTarget) == TRUE) || (GetHasFeat(1254,oTarget) == TRUE)
    || (GetHasFeat(1276,oTarget) == TRUE) || (GetHasFeat(1299,oTarget) == TRUE) || (GetHasFeat(1300,oTarget) == TRUE)
    || (GetHasFeat(1301,oTarget) == TRUE) || (nInfectedCheck==1))
    {
      return;
    }
    else if((GetLevelByClass(CLASS_TYPE_PALADIN,oTarget) >= 1) || (GetLevelByClass(CLASS_TYPE_MONK,oTarget) >= 20)
    || (GetIsImmune(oTarget,IMMUNITY_TYPE_DISEASE)==TRUE) || (GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oTarget) >= 1))
    {
      return;
    }
    else if(nRandom == 5)
    {
       if((sLycanType == "") || (sLycanType == "wolf"))
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1249) ); // 1249 Werewolf
       }
       else if(sLycanType == "bear")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1250));  // 1250 Werebear
       }
       else if(sLycanType == "cat")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1251));   // 1251 Werecat
       }
       else if(sLycanType == "boar")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1252));  // 1252 Wereboar
       }
       else if(sLycanType == "bat")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1253));    // 1253 Werebat
       }
       else if(sLycanType == "rat")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1254));  // 1254 Wererat
       }
       else if(sLycanType == "chicken")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1276));  // 1276 Werechicken
       }
       else if(sLycanType == "owl")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1329));  // 1329 Wereowl
       }
       else if(sLycanType == "crocodile")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1330));  // 1330 Werecroc
       }
       else if(sLycanType == "shark")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1331));  // 1331 Wereshark
       }
       else if(sLycanType == "fox")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1332));  // 1332 Werefox
       }
       else if(sLycanType == "raccoon")
       {
         DelayCommand( 5.0, NWNX_Creature_AddFeat( oTarget, 1333));  // 1333 Wereraccoon
       }
       SendMessageToPC(oTarget, "*You start to feel ill, like something instead right. Your body shivers and you start to feel sick*");
       SetPCKEYValue(oTarget,"lycanInfected",1);
    }
}

