/*
   Summon Vassal Feat for Lordship Class

   12/7/21 - Maverick00053

*/
void main()
{
     object oPC = OBJECT_SELF;
     object oWidget = GetItemPossessedBy(oPC, "l_vassal");
     location lTarget = GetSpellTargetLocation();
     int nFemale = GetLocalInt(oWidget, "vassalFemale");
     int nRace = GetLocalInt(oWidget, "vassalRace");
     int nLevelLord = GetLevelByClass(54,oPC);
     int nLevel = GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC);
     int nEpic = 0;
     int nSkillP = GetSkillRank(SKILL_PERSUADE,oPC,TRUE);
     string sName = GetLocalString(oWidget, "vassalName");
     string sHenchmen;
     effect eStr;
     effect eCon;
     effect eRegen;
     effect eLink;
     int nEffect;

     if(nSkillP >= 30)
     {
        eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
        eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,6);
        eRegen = EffectRegenerate(1,6.0);
        nEffect=1;
        eLink = EffectLinkEffects(eStr,eCon);
        eLink = EffectLinkEffects(eLink,eRegen);

     }
     else if(nSkillP >= 25)
     {
        eStr = EffectAbilityIncrease(ABILITY_STRENGTH,2);
        eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,5);
        nEffect=1;
        eLink = EffectLinkEffects(eStr,eCon);
     }
     else if(nSkillP >= 20)
     {
        eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,4);
        nEffect=1;
        eLink = eCon;

     }
     else if(nSkillP >= 15)
     {
        eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,3);
        nEffect=1;
        eLink = eCon;
     }
     else if(nSkillP >= 10)
     {
        eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,2);
        nEffect=1;
        eLink = eCon;
     }


     if((nLevel >= 20) && (nLevelLord == 5))
     {
       nEpic = 1;
     }

     if(nRace == 0)
     {
       nRace = 1;
     }


     if(nFemale == 1)
     {
        if(nEpic == 1)
        {
          switch(nRace)
          {
            case 1: sHenchmen = "summon_vassal4"; break;
            case 2: sHenchmen = "summon_vassal8"; break;
            case 3: sHenchmen = "summon_vassal12"; break;
            case 4: sHenchmen = "summon_vassal16"; break;
            case 5: sHenchmen = "summon_vassal20"; break;
          }

        }
        else
        {
          switch(nRace)
          {
            case 1: sHenchmen = "summon_vassal3"; break;
            case 2: sHenchmen = "summon_vassal7"; break;
            case 3: sHenchmen = "summon_vassal11"; break;
            case 4: sHenchmen = "summon_vassal15"; break;
            case 5: sHenchmen = "summon_vassal19"; break;
          }
        }
     }
     else
     {
        if(nEpic == 1)
        {
          switch(nRace)
          {
            case 1: sHenchmen = "summon_vassal2"; break;
            case 2: sHenchmen = "summon_vassal6"; break;
            case 3: sHenchmen = "summon_vassal10"; break;
            case 4: sHenchmen = "summon_vassal14"; break;
            case 5: sHenchmen = "summon_vassal18"; break;
          }

        }
        else
        {
          switch(nRace)
          {
            case 1: sHenchmen = "summon_vassal1"; break;
            case 2: sHenchmen = "summon_vassal5"; break;
            case 3: sHenchmen = "summon_vassal9"; break;
            case 4: sHenchmen = "summon_vassal13"; break;
            case 5: sHenchmen = "summon_vassal17"; break;
          }
        }
     }



     object oHench = CreateObject(OBJECT_TYPE_CREATURE,sHenchmen,lTarget,FALSE);
     AddHenchman(oPC, oHench);

     if(nEffect == 1)
     {
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oHench);
	   SetTag (oHench, ("vassal_"+GetPCPublicCDKey( oPC )));
     }

     if(sName != "")
     {
       SetName(oHench, sName);
     }

}
