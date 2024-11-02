//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_death
//group:   ds_ai
//used as: OnDamage
//date:    dec 23 2007
//author:  disco
// Edited: Maverick00053, August 19th 2019
// Created an invasion version

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"

void RaiseMe(object oCritter, location eLoc);
void Reward(object oArea, float fCR, object oCritter);
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter         = OBJECT_SELF;
    float  fCR              = GetChallengeRating(oCritter);
    object oKiller          = GetLastKiller();
    object oArea            = GetArea(oCritter);
    string sCritterRes      = GetResRef(oCritter);
    effect eVFX             = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);
    effect eVis             = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    location eLoc           = GetLocation(oCritter);


    // Undead invasion auto raise mechanics

    if((GetTag(oCritter) == "raiseme") && (GetLocalInt(oArea,"invasion_area") == 1))
    {
      DelayCommand(6.0,ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, eLoc));
      DelayCommand(6.5,RaiseMe(oCritter, eLoc));
    }
    else if((GetTag(oCritter) == "raiseme2") && (GetLocalInt(oArea,"invasion_area") == 1))
    {
      DelayCommand(13.0,ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, eLoc));
      DelayCommand(13.5,RaiseMe(oCritter, eLoc));
    }
    else if((GetTag(oCritter) == "raiseme3") && (GetLocalInt(oArea,"invasion_area") == 1))
    {
      DelayCommand(29.0,ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, eLoc));
      DelayCommand(29.5,RaiseMe(oCritter, eLoc));
    }
    //

    if(sCritterRes == "ds_yellowfang_6")
    {
      Reward(oArea, fCR, oCritter);
    }
    else if(sCritterRes == "chosenofkilma002")
    {
      Reward(oArea, fCR, oCritter);
    }
    else if(sCritterRes == "invasiontrollbs")
    {
      Reward(oArea, fCR, oCritter);
    }
    else if(sCritterRes == "invasionbeastbs")
    {
      Reward(oArea, fCR, oCritter);
    }

    // Invasion Emotes

    if(sCritterRes == "invasioncreat003")
    {
      AssignCommand(OBJECT_SELF, SpeakString("*The demon crumbles to the ground leaving behind something of interest*",TALKVOLUME_TALK));
    }
    else if(sCritterRes == "invasioncreat004")
    {
       AssignCommand(OBJECT_SELF, SpeakString("*The demon explodes in a fiery death. A damaged, but functional artifact remains behind*",TALKVOLUME_TALK));
       //Invasion clean up
       DeleteLocalInt(oArea,"invasion_area");
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,OBJECT_SELF);
    }
    else if(sCritterRes == "invasiondead004")
    {
       AssignCommand(OBJECT_SELF, SpeakString("*The massive skeletal dragon crumbles to the ground. The bones continue to tremble as they begin to reform*",TALKVOLUME_TALK));
    }
    else if(sCritterRes == "invasiondead006")
    {
       AssignCommand(OBJECT_SELF, SpeakString("*The necromancer finally falls! It's corpse crumbling to the ground and slowly turned to ash as its remains blew away*",TALKVOLUME_TALK));
       //Invasion clean up
       DeleteLocalInt(oArea,"invasion_area");
    }
    else
    {
       //Invasion clean up
       DeleteLocalInt(oArea,"invasion_area");
    }

    //OnDeath custom ability usage
    string sDE = GetLocalString( oCritter, "DeathEffect" );
    if( sDE != "" )
    {
        SetLocalObject( oCritter, sDE, oKiller );
        ExecuteScript( sDE, oCritter );
    }

    if( GetLastKiller() != OBJECT_SELF && GetLocalInt( oCritter, L_ISDEAD ) != 1 ){

        // Set have died once, stops giving out multiple amounts of XP.
        SetLocalInt( oCritter, L_ISDEAD, 1 );

        // Reward XP.
        int nXPResult = RewardXPForKill( );

        // Generate treasure ONLY on non rasiable guys.
        if((GetTag(oCritter) != "raiseme") || (GetTag(oCritter) != "raiseme2") || (GetTag(oCritter) != "raiseme3"))
        {
        GenerateLoot( oCritter, nXPResult );
        }
    }


    //Invasion clean up - Take 2 - Make sure the variable is deleted with lag, etc.
    DeleteLocalInt(oArea,"invasion_area");
}

void RaiseMe(object oCritter, location eLoc)
{
    CreateObject(OBJECT_TYPE_CREATURE,GetResRef(oCritter),eLoc, FALSE);

}


void Reward(object oArea, float fCR, object oCritter)
{
   int nXP;
   int nCR = FloatToInt(fCR);
   int nLevel;

   object oPC = GetFirstPC();

   while(GetIsObjectValid(oPC))
   {

     if(GetArea(oPC) == oArea)
     {
        if(GetLocalInt(oPC, "gotinvasionreward") == 0)// Check to make sure this launches once per person
        {
          nLevel = GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC);
          nXP = GetXP(oPC);
          if(nLevel != 30)
          {
            SetXP(oPC,nXP+(100*nCR));
          }
          else
          {
            SetXP(oPC,nXP+1);
          }
          int temp =(1500*nCR);
          if(temp > 100000)
          {
            temp = 100000;
          }
          GiveGoldToCreature(oPC,temp);
          FloatingTextStringOnCreature("-You have been issued a reward from the Guild for helping-",oPC);
          SetLocalInt(oPC,"gotinvasionreward",1);
          DelayCommand(30.0,DeleteLocalInt(oPC,"gottrophyreward"));

          if(GetResRef(oCritter)=="demoninvaboss")
          {
           CreateItemOnObject("demon_token",oPC);
          }
        }
     }
     oPC = GetNextPC();
   }
}
