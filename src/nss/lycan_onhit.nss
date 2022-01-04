/*
   Lycan On Hit
   ------------
   Will have a chance to infect on hit, will scale with level.

   12/10/21 - Maverick00053
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
    int nRandom = Random(100*nLevel) + 1;

    if((GetHasFeat(1249,oTarget) == TRUE) || (GetHasFeat(1250,oTarget) == TRUE) || (GetHasFeat(1251,oTarget) == TRUE)
    || (GetHasFeat(1252,oTarget) == TRUE) || (GetHasFeat(1253,oTarget) == TRUE) || (GetHasFeat(1254,oTarget) == TRUE)
    || (GetHasFeat(1276,oTarget) == TRUE))
    {
      return;
    }

    if(GetLevelByClass(CLASS_TYPE_PALADIN,oLycan) >= 1)
    {
      return;
    }

    if(nRandom == 5)
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
       SendMessageToPC(oTarget, "*You start to feel ill, like something instead right. Your body shivers and you start to feel sick*");
    }
}
