//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
// Maverick00053

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"


int RezChance(object oMaster);

void RaiseMe(object oCritter, location lLocation, object oMaster, string sTag, string sResRef);

void PMBuff(object oHench,object oMaster, string sTag);

int getPoints(object oMaster);
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter = OBJECT_SELF;
    object oKiller = GetLastKiller();
    object oMaster = GetMaster(oCritter);
    effect eVFX = EffectVisualEffect(VFX_IMP_UNSUMMON);
    location lLocation = GetLocation(oCritter);
    string sTag = GetTag(oCritter);
    string sResRef = GetResRef(oCritter);
    int nRandom = Random(100)+1;
    int nRez = RezChance(oMaster);

    int nRespawnOff = GetLocalInt(oCritter,"respawnoff");

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lLocation);

    if(nRespawnOff == 0)
    {
    if(nRandom <= nRez)
    {
      DelayCommand(2.0,RaiseMe(oCritter, lLocation, oMaster, sTag, sResRef));
    }
    }
}

int RezChance(object oMaster)
{
    int nPMLvl = GetLevelByClass(CLASS_TYPE_PALE_MASTER,oMaster);
    int nBonus;

    if(nPMLvl == 20)
    {
      nBonus = 20;
    }
    int nRez = 10 + nPMLvl + nBonus;
    return nRez;
}

void RaiseMe(object oCritter, location lLocation, object oMaster, string sTag, string sResRef)
{
    effect eVFX2 = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    object oHench = CreateObject(OBJECT_TYPE_CREATURE,sResRef,lLocation,FALSE,sTag);
    AddHenchman(oMaster, oHench);

    PMBuff(oHench,oMaster,sTag);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX2,lLocation);

}

void PMBuff(object oHench,object oMaster, string sTag)
{
   int nPoints = getPoints(oMaster);
   effect eABIncrease;
   effect eDamIncrease;
   effect eBuff;

   if(sTag == "pmanimundead")
   {

     if(nPoints > 17)
     {
        nPoints = nPoints - 17;
        nPoints = nPoints/2;

        eABIncrease = EffectAttackIncrease(nPoints, ATTACK_BONUS_MISC);
        eDamIncrease = EffectDamageIncrease(nPoints,DAMAGE_TYPE_MAGICAL); // Using normal int variable instead of damage_bonus constants because the max damage possible doesnt create weirdness like normal
        eBuff = EffectLinkEffects(eABIncrease,eDamIncrease);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eBuff,oHench);
     }
   }
   else if(sTag == "pmsummonud")
   {

     if(nPoints > 22)
     {
        nPoints = nPoints - 22;
        nPoints = nPoints/2;

        eABIncrease = EffectAttackIncrease(nPoints, ATTACK_BONUS_MISC);
        eDamIncrease = EffectDamageIncrease(nPoints,DAMAGE_TYPE_MAGICAL); // Using normal int variable instead of damage_bonus constants because the max damage possible doesnt create weirdness like normal
        eBuff = EffectLinkEffects(eABIncrease,eDamIncrease);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eBuff,oHench);
     }
   }
}

int getPoints(object oMaster)
{
   int nPMLvl = GetLevelByClass(CLASS_TYPE_PALE_MASTER,oMaster);
   int nWizLvl = GetLevelByClass(CLASS_TYPE_WIZARD,oMaster);
   int nSorcLvl = GetLevelByClass(CLASS_TYPE_SORCERER,oMaster);
   int nAssLvl = GetLevelByClass(CLASS_TYPE_ASSASSIN,oMaster);
   int nBardLvl = GetLevelByClass(CLASS_TYPE_BARD,oMaster);

   int nPoints = nPMLvl + (nWizLvl/2) + (nSorcLvl/2) + (nAssLvl/2) + (nBardLvl/2);

   if(nPMLvl == 20)  // 20 PM gets +1 points
   {
     nPoints = nPoints + 1;
   }

   return nPoints;
}
