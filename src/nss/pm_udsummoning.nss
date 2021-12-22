/*
    Palemaster new summoning abilities

    - Maverick00053

*/

#include "ds_ai2_include"
#include "inc_ds_summons"

void CheckHenchmen(object oMaster, string sTag); // Check your henchmen and remove old ones before adding new ones

void PMBuff(object oHench,object oMaster, string sTag, int nPoints); // Adds the PM buffs post 17 and 22 points

int getPoints(object oMaster);  // Gets the PM/Sorc/Bard/Wiz points

int RezChance(object oMaster);   // Gets the chance of Rez for henchmen on death

void AnimateDead(object oMaster, object oWidget, location lLocation, int nPoints); // The Animate Undead Spell

void SummonUndead(object oMaster, object oWidget, location lLocation, int nPoints); // Summon Undead Spell

void SummonGreaterUndead(object oMaster, location lLocation, int nPoints); // Summon Greater Undead Spell

void main()
{

    object oMaster = OBJECT_SELF;
    object oWidget = GetItemPossessedBy(oMaster, "pm_animateud");
    object oWidget2 = GetItemPossessedBy(oMaster, "pm_summonud");
    location lLocation = GetLocation(oMaster);
    int nPoints = getPoints(oMaster);
    int nSpellID = GetSpellId();


    if(nSpellID == 623)
    {
      AnimateDead(oMaster,oWidget,lLocation,nPoints);
    }
    else if(nSpellID == 624)
    {
      SummonUndead(oMaster,oWidget2,lLocation,nPoints);
    }
    else if(nSpellID == 627)
    {
      SummonGreaterUndead(oMaster,lLocation,nPoints);
    }

}

void CheckHenchmen(object oMaster, string sTag)
{
   // Max Henchmen for Server is set to 30
    effect eVFX = EffectVisualEffect(VFX_IMP_UNSUMMON);
    int i;
    for(i=1; i<=30; i++)
    {
     object oHench = GetHenchman(oMaster,i);
     location lLocation = GetLocation(oHench);
     if(GetTag(oHench) == sTag)
     {
       ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lLocation);
       DestroyObject(oHench,0.1);
     }
    }
}

void PMBuff(object oHench,object oMaster, string sTag, int nPoints)
{
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

void AnimateDead(object oMaster, object oWidget, location lLocation, int nPoints)
{

    effect eVFX = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    string sTag = "pmanimundead";
    object oHench;
    object oHench2;
    object oHench3;
    object oHench4;
    object oHench5;
    object oHench6;
    object oHench7;
    object oHench8;
    object oHench9;
    object oHench10;
    int nRez = RezChance(oMaster);

    CheckHenchmen(oMaster, sTag);

    if(nPoints >= 17) // 2x Archers/Etc (Customization)
    {

     if(!GetIsObjectValid(oWidget))
     {
       oWidget = CreateItemOnObject( "pm_animateud",oMaster,1,"pm_animateud");
     }

     int nChoice = GetLocalInt(oWidget,"summonset");
     string sChoice1 = "undead_hen_9";
     string sChoice2 = "undead_hen_9";

     if(nChoice == 2) // Ghoul Lord x2
     {
       sChoice1 = "undead_hen_10";
       sChoice2 = "undead_hen_10";
     }
     else if(nChoice == 3) // Allip x2
     {
       sChoice1 = "undead_hen_13";
       sChoice2 = "undead_hen_13";
     }
     else if(nChoice == 4) // Skeletal Archer, Ghoul Lord
     {
       sChoice1 = "undead_hen_9";
       sChoice2 = "undead_hen_10";
     }
     else if(nChoice == 5) // Skeletal Archer, Allip
     {
       sChoice1 = "undead_hen_9";
       sChoice2 = "undead_hen_13";
     }
     else if(nChoice == 6) // Ghoul Lord, Allip
     {
       sChoice1 = "undead_hen_10";
       sChoice2 = "undead_hen_13";
     }
     else if(nChoice == 7) // Skeleton x10
     {
       sChoice1 = "undead_hen_14";
       sChoice2 = "undead_hen_14";
       oHench3 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench4 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench5 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench6 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench7 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench8 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench9 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench10 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       AddHenchman(oMaster, oHench3);
       AddHenchman(oMaster, oHench4);
       AddHenchman(oMaster, oHench5);
       AddHenchman(oMaster, oHench6);
       AddHenchman(oMaster, oHench7);
       AddHenchman(oMaster, oHench8);
       AddHenchman(oMaster, oHench9);
       AddHenchman(oMaster, oHench10);
       PMBuff(oHench3,oMaster,sTag,nPoints);
       PMBuff(oHench4,oMaster,sTag,nPoints);
       PMBuff(oHench5,oMaster,sTag,nPoints);
       PMBuff(oHench6,oMaster,sTag,nPoints);
       PMBuff(oHench7,oMaster,sTag,nPoints);
       PMBuff(oHench8,oMaster,sTag,nPoints);
       PMBuff(oHench9,oMaster,sTag,nPoints);
       PMBuff(oHench10,oMaster,sTag,nPoints);
     }
     else if(nChoice == 8) // Zombie x10
     {
       sChoice1 = "undead_hen_15";
       sChoice2 = "undead_hen_15";
       oHench3 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench4 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench5 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench6 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench7 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench8 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench9 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench10 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       AddHenchman(oMaster, oHench3);
       AddHenchman(oMaster, oHench4);
       AddHenchman(oMaster, oHench5);
       AddHenchman(oMaster, oHench6);
       AddHenchman(oMaster, oHench7);
       AddHenchman(oMaster, oHench8);
       AddHenchman(oMaster, oHench9);
       AddHenchman(oMaster, oHench10);
       PMBuff(oHench3,oMaster,sTag,nPoints);
       PMBuff(oHench4,oMaster,sTag,nPoints);
       PMBuff(oHench5,oMaster,sTag,nPoints);
       PMBuff(oHench6,oMaster,sTag,nPoints);
       PMBuff(oHench7,oMaster,sTag,nPoints);
       PMBuff(oHench8,oMaster,sTag,nPoints);
       PMBuff(oHench9,oMaster,sTag,nPoints);
       PMBuff(oHench10,oMaster,sTag,nPoints);
     }

     oHench = CreateObject(OBJECT_TYPE_CREATURE,sChoice1,lLocation,FALSE,sTag);
     oHench2 = CreateObject(OBJECT_TYPE_CREATURE,sChoice2,lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     AddHenchman(oMaster, oHench2);
     PMBuff(oHench,oMaster,sTag,nPoints);
     PMBuff(oHench2,oMaster,sTag,nPoints);
     nPoints = nPoints - 17;
     nPoints = nPoints/2;
     SendMessageToPC(oMaster,"Your mastery of necromancy increases your minions AB/Damage by " + IntToString(nPoints));

    }
    else if(nPoints >= 14) // Skeletal Archer + Ghoul Lord
    {
     oHench = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_9",lLocation,FALSE,sTag);
     oHench2 = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_10",lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     AddHenchman(oMaster, oHench2);
     PMBuff(oHench,oMaster,sTag,nPoints);
     PMBuff(oHench2,oMaster,sTag,nPoints);

    }
    else if(nPoints >= 11) // Lesser Archer +  Ghoul Rogue
    {
     oHench = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_7",lLocation,FALSE,sTag);
     oHench2 = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_8",lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     AddHenchman(oMaster, oHench2);
     PMBuff(oHench,oMaster,sTag,nPoints);
     PMBuff(oHench2,oMaster,sTag,nPoints);
    }
    else if(nPoints >= 8) // Mohrg x2
    {
     oHench = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_1",lLocation,FALSE,sTag);
     oHench2 = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_1",lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     AddHenchman(oMaster, oHench2);
     PMBuff(oHench,oMaster,sTag,nPoints);
     PMBuff(oHench2,oMaster,sTag,nPoints);
    }
    else if(nPoints <= 7) // Mohrg
    {
     oHench = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_1",lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     PMBuff(oHench,oMaster,sTag,nPoints);
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lLocation);
    SendMessageToPC(oMaster,"Your chance to reanimate a fallen undead minion is " + IntToString(nRez) + "%");

}

void SummonUndead(object oMaster, object oWidget, location lLocation, int nPoints)
{

    effect eVFX = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    string sTag = "pmsummonud";
    object oHench;
    object oHench2;
    object oHench3;
    object oHench4;
    object oHench5;
    object oHench6;
    object oHench7;
    object oHench8;
    object oHench9;
    object oHench10;
    int nRez = RezChance(oMaster);

    CheckHenchmen(oMaster, sTag);

    if(nPoints >= 22) // Greater Mummy (Customization)
    {

     if(!GetIsObjectValid(oWidget))
     {
       oWidget = CreateItemOnObject( "pm_summonud",oMaster,1,"pm_summonud");
     }

     int nChoice = GetLocalInt(oWidget,"summonset");
     string sChoice1 = "undead_hen_6";

     if(nChoice == 2) // Lesser Vampire
     {
       sChoice1 = "undead_hen_12";
     }
     else if(nChoice == 3) // Blaspheme
     {
       sChoice1 = "undead_hen_11";
     }
     else if(nChoice == 4) // Skeleton x10
     {
       sChoice1 = "undead_hen_14";
       oHench2 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench3 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench4 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench5 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench6 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench7 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench8 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench9 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       oHench10 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_14",lLocation,FALSE,sTag);
       AddHenchman(oMaster, oHench2);
       AddHenchman(oMaster, oHench3);
       AddHenchman(oMaster, oHench4);
       AddHenchman(oMaster, oHench5);
       AddHenchman(oMaster, oHench6);
       AddHenchman(oMaster, oHench7);
       AddHenchman(oMaster, oHench8);
       AddHenchman(oMaster, oHench9);
       AddHenchman(oMaster, oHench10);
       PMBuff(oHench2,oMaster,sTag,nPoints);
       PMBuff(oHench3,oMaster,sTag,nPoints);
       PMBuff(oHench4,oMaster,sTag,nPoints);
       PMBuff(oHench5,oMaster,sTag,nPoints);
       PMBuff(oHench6,oMaster,sTag,nPoints);
       PMBuff(oHench7,oMaster,sTag,nPoints);
       PMBuff(oHench8,oMaster,sTag,nPoints);
       PMBuff(oHench9,oMaster,sTag,nPoints);
       PMBuff(oHench10,oMaster,sTag,nPoints);
     }
     else if(nChoice == 5) // Zombie x10
     {
       sChoice1 = "undead_hen_15";
       oHench2 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench3 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench4 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench5 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench6 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench7 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench8 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench9 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       oHench10 = CreateObject(OBJECT_TYPE_CREATURE,"undead_hen_15",lLocation,FALSE,sTag);
       AddHenchman(oMaster, oHench2);
       AddHenchman(oMaster, oHench3);
       AddHenchman(oMaster, oHench4);
       AddHenchman(oMaster, oHench5);
       AddHenchman(oMaster, oHench6);
       AddHenchman(oMaster, oHench7);
       AddHenchman(oMaster, oHench8);
       AddHenchman(oMaster, oHench9);
       AddHenchman(oMaster, oHench10);
       PMBuff(oHench2,oMaster,sTag,nPoints);
       PMBuff(oHench3,oMaster,sTag,nPoints);
       PMBuff(oHench4,oMaster,sTag,nPoints);
       PMBuff(oHench5,oMaster,sTag,nPoints);
       PMBuff(oHench6,oMaster,sTag,nPoints);
       PMBuff(oHench7,oMaster,sTag,nPoints);
       PMBuff(oHench8,oMaster,sTag,nPoints);
       PMBuff(oHench9,oMaster,sTag,nPoints);
       PMBuff(oHench10,oMaster,sTag,nPoints);
     }

     oHench = CreateObject(OBJECT_TYPE_CREATURE,sChoice1,lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     PMBuff(oHench,oMaster,sTag,nPoints);
     nPoints = nPoints - 22;
     nPoints = nPoints/2;
     SendMessageToPC(oMaster,"Your mastery of necromancy increases your minions AB/Damage by " + IntToString(nPoints));

    }
    else if(nPoints >= 19) // Mummy
    {
     oHench = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_5",lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     PMBuff(oHench2,oMaster,sTag,nPoints);

    }
    else if(nPoints >= 15) // Wight
    {
     oHench = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_4",lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     PMBuff(oHench,oMaster,sTag,nPoints);
    }
    else if(nPoints >= 12) // Dread Wraith
    {
     oHench = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_3",lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     PMBuff(oHench,oMaster,sTag,nPoints);
    }
    else if(nPoints <= 11) // Wraith
    {
     oHench = CreateObject(OBJECT_TYPE_CREATURE, "undead_hen_2",lLocation,FALSE,sTag);
     AddHenchman(oMaster, oHench);
     PMBuff(oHench,oMaster,sTag,nPoints);
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVFX,lLocation);
    SendMessageToPC(oMaster,"Your chance to reanimate a fallen undead minion is " + IntToString(nRez) + "%");

}

void SummonGreaterUndead(object oMaster, location lLocation, int nPoints)
{
    int nPMLvl = GetLevelByClass(CLASS_TYPE_PALE_MASTER,oMaster);
    int nWizLvl = GetLevelByClass(CLASS_TYPE_WIZARD,oMaster);
    int nSorcLvl = GetLevelByClass(CLASS_TYPE_SORCERER,oMaster);
    int nAssLvl = GetLevelByClass(CLASS_TYPE_ASSASSIN,oMaster);
    int nBardLvl = GetLevelByClass(CLASS_TYPE_BARD,oMaster);

    int nDuration = nPMLvl + nWizLvl + nSorcLvl + nAssLvl + nBardLvl;

    float fDuration = RoundsToSeconds(nDuration*10);
    int nBonusTurnResistance = 6;
    int nVfx = VFX_FNF_SUMMON_UNDEAD;
    string szUndead = "undead_";

    //time feedback
    SendMessageToPC( oMaster, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );

    //--------------------------------------------------------------------------------
    //GS + Summon nerf
    //--------------------------------------------------------------------------------

    if ( GetHasSpellEffect( SPELL_ETHEREALNESS, oMaster ) && nPoints > 16 ){

        RemoveEffectsBySpell( oMaster, SPELL_ETHEREALNESS );
        SendMessageToPC( oMaster, "Summoning level 23+ monsters removes GS." );
    }


    if(nPoints >= 24) // Winterwight
    {
        nVfx        = 496;       // the nice summon undead vfx
        szUndead   += "7";
    }
    else if(nPoints >= 20) // Greater Mummy
    {
        nVfx        = VFX_IMP_HARM;
        szUndead   += "6";
    }
    else if(nPoints >= 16) // Mummy
    {
        nVfx        =VFX_IMP_HARM;
        szUndead   += "5";
    }
    else if(nPoints >= 13) // Wight
    {
        nVfx        =VFX_IMP_HARM;
        szUndead   += "4";
    }
    else if(nPoints <= 12) // Dread Wraith
    {
        szUndead   += "3";

    }

    effect eUndeadSummon = EffectSummonCreature( szUndead, nVfx, 1.0, 0 );

    // summon
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eUndeadSummon, lLocation, fDuration );

    // bonus turning resistance for summons cast by Palemasters
    if ( nBonusTurnResistance > 0 ){

        DelayCommand( 1.0, FindSummonAndDoBonusTurnResistance( oMaster, szUndead, nBonusTurnResistance ) );
    }

    // Handle reskins/optional visuals.
    DelayCommand( 1.5, HandleSummonVisuals( oMaster, 1 ) );


}
