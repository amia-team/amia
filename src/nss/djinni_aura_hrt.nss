//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  djinni_aura_hrt
//group:   djinni
//used as: OnHeartbeat Aura script for djinni
//date:    Feb 2025
//author:  Maverick

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x0_i0_enemy"
#include "ds_ai2_include"
#include "X0_I0_SPELLS"
#include "inc_td_shifter"
//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


void ApplyEleEffect(object oTarget, string sType);
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{

    object oCritter = GetAreaOfEffectCreator(OBJECT_SELF);
    location lCritter = GetLocation( oCritter );
    string sType = GetLocalString(oCritter,"type");

    object oTarget = GetFirstInPersistentObject();

    while(GetIsObjectValid(oTarget))
    {

      if((GetLocalInt(oCritter, "shutdown") == 0) && (GetLocalInt(oTarget, "djinnihit") == 0))
      {
       ApplyEleEffect(oTarget,sType);
       SetLocalInt(oTarget, "djinnihit",1);
       DelayCommand(6.0,DeleteLocalInt(oTarget,"djinnihit"));
      }
      //Get next target in the AOE
      oTarget = GetNextInPersistentObject();
    }

}

void ApplyEleEffect(object oTarget, string sType)
{
   int nDamage = 50 + Random(50);
   int nDamageType;


   if(sType=="fire")
   {
     nDamageType = DAMAGE_TYPE_FIRE;
   }
   else if(sType=="positive")
   {
     nDamageType = DAMAGE_TYPE_POSITIVE;
   }
   else if(sType=="electric")
   {
     nDamageType = DAMAGE_TYPE_ELECTRICAL;
   }
   else if(sType=="physical")
   {
     switch(Random(3)+1)
     {
       case 1: nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
       case 2: nDamageType = DAMAGE_TYPE_PIERCING; break;
       case 3: nDamageType = DAMAGE_TYPE_SLASHING; break;
     }
   }
   else if(sType=="cold")
   {
     nDamageType = DAMAGE_TYPE_COLD;
   }
   else if(sType=="negative")
   {
     nDamageType = DAMAGE_TYPE_NEGATIVE;
   }
   else if(sType=="sonic")
   {
     nDamageType = DAMAGE_TYPE_SONIC;
   }
   else if(sType=="magic")
   {
     nDamageType = DAMAGE_TYPE_MAGICAL;
   }

   effect eDamage = EffectDamage(nDamage,nDamageType);
   ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);

}
