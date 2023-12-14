/*
   On damage script for blocking rocks or other objects in the dynamic dungeon tool system

 - Maverick00053 11/11/2023
*/

void main()
{
   object oPLC = OBJECT_SELF;
   object oPC = GetLastDamager();
   string sPLC = GetResRef(oPLC);
   int nDamageTypeFire = GetDamageDealtByType(DAMAGE_TYPE_FIRE);
   int nDamageTypeCold = GetDamageDealtByType(DAMAGE_TYPE_COLD);
   int nDamageTypeElec = GetDamageDealtByType(DAMAGE_TYPE_ELECTRICAL);
   int nDamageTypeAcid = GetDamageDealtByType(DAMAGE_TYPE_ACID);
   int nTotalDamage = GetTotalDamageDealt();
   int nRecentlyHit = GetLocalInt(oPC,"dungdamblock");
   int nRecentlyHitEffective = GetLocalInt(oPC,"dungdamblockeffective");
   int nDamageTaken = GetLocalInt(oPLC,"damagetaken");
   int nLevel = GetLocalInt(oPLC,"level");
   int nDamageAmount = nLevel*2;
   effect eBurn = EffectVisualEffect(VFX_FNF_FIREBALL);
   effect eCool = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1); // VFX_IMP_FROST_L
   effect eElec = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION); // VFX_IMP_FROST_L
   effect eAcid = EffectVisualEffect(VFX_FNF_HORRID_WILTING); // VFX_IMP_FROST_L

   // These are for blockages that cant be removed with damage. Expand as needed.
   if((sPLC == "magicalblockage") || (sPLC == "rockblockage"))
   {
     SendMessageToPC(oPC,"Your attacks appear ineffective. Perhaps brute force isn't the answer?");
     return;
   }

   if(nDamageTypeFire>0 && ((sPLC == "iceblockage")) && ((nDamageTaken+nDamageTypeFire) >= nDamageAmount))
   {
     if(sPLC == "iceblockage")
     AssignCommand(oPLC,ActionSpeakString("*The ice begins to melt down rapidly*"));

     ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eBurn,GetLocation(oPLC));
     DestroyObject(oPLC,0.5);
   }
   else if(nDamageTypeFire>0 && ((sPLC == "iceblockage")))
   {
     SetLocalInt(oPLC,"damagetaken",nDamageTaken+nDamageTypeFire);
     if(nRecentlyHitEffective==0)
     {
      SendMessageToPC(oPC,"Your attack appears effective. Keep going!");
      SetLocalInt(oPC,"dungdamblockeffective",1);
      DelayCommand(6.0,DeleteLocalInt(oPC,"dungdamblockeffective"));
     }

   }
   else if(nDamageTypeCold>0 && ((sPLC == "magmablockage")) && ((nDamageTaken+nDamageTypeCold) >= nDamageAmount))
   {
     if(sPLC == "magmablockage")
     AssignCommand(oPLC,ActionSpeakString("*The magma begins to cool and crack rapidly*"));

     ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eCool,GetLocation(oPLC));
     DestroyObject(oPLC,0.5);
   }
   else if(nDamageTypeCold>0 && ((sPLC == "magmablockage")))
   {
     SetLocalInt(oPLC,"damagetaken",nDamageTaken+nDamageTypeCold);
     if(nRecentlyHitEffective==0)
     {
      SendMessageToPC(oPC,"Your attack appears effective. Keep going!");
      SetLocalInt(oPC,"dungdamblockeffective",1);
      DelayCommand(6.0,DeleteLocalInt(oPC,"dungdamblockeffective"));
     }

   }
   else if(nDamageTypeElec>0 && ((sPLC == "chargedcblockage")) && ((nDamageTaken+nDamageTypeElec) >= nDamageAmount))
   {
     if(sPLC == "chargedcblockage")
     AssignCommand(oPLC,ActionSpeakString("*The crystals begin to overload, and then quickly explode*"));

     ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eElec,GetLocation(oPLC));
     DestroyObject(oPLC,0.5);
   }
   else if(nDamageTypeElec>0 && ((sPLC == "chargedcblockage")))
   {
     SetLocalInt(oPLC,"damagetaken",nDamageTaken+nDamageTypeElec);
     if(nRecentlyHitEffective==0)
     {
      SendMessageToPC(oPC,"Your attack appears effective. Keep going!");
      SetLocalInt(oPC,"dungdamblockeffective",1);
      DelayCommand(6.0,DeleteLocalInt(oPC,"dungdamblockeffective"));
     }

   }
   else if(nDamageTypeAcid>0 && ((sPLC == "mushroomblockage")) && ((nDamageTaken+nDamageTypeAcid) >= nDamageAmount))
   {
     if(sPLC == "mushroomblockage")
     AssignCommand(oPLC,ActionSpeakString("*The mushroom's regeneration slows then stops as the flesh melts away*"));

     ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eAcid,GetLocation(oPLC));
     DestroyObject(oPLC,1.0);
   }
   else if(nDamageTypeAcid>0 && ((sPLC == "mushroomblockage")))
   {
     SetLocalInt(oPLC,"damagetaken",nDamageTaken+nDamageTypeAcid);
     if(nRecentlyHitEffective==0)
     {
      SendMessageToPC(oPC,"Your attack appears effective. Keep going!");
      SetLocalInt(oPC,"dungdamblockeffective",1);
      DelayCommand(6.0,DeleteLocalInt(oPC,"dungdamblockeffective"));
     }
   }
   else
   {
     effect eHeal = EffectHeal(10000);
     ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oPLC);
     if(nRecentlyHit==0)
     {
       SendMessageToPC(oPC,"Your attack doesn't appear to be effective, perhaps try another type of damage?");
       SetLocalInt(oPC,"dungdamblock",1);
       DelayCommand(6.0,DeleteLocalInt(oPC,"dungdamblock"));
     }

   }


}
