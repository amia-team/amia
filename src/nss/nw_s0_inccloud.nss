//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "inc_td_shifter"
void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    // Anti Shifter Spam cool down
    if( GetIsPolymorphed( OBJECT_SELF ) && GetLevelByClass( CLASS_TYPE_SHIFTER, OBJECT_SELF ) > 0 )
    {
       int inccloudcd = GetLocalInt(OBJECT_SELF,"inccloudcd");

       if(inccloudcd == 0)
       {
        SetLocalInt(OBJECT_SELF,"inccloudcd",1);
        DelayCommand(6.0,DeleteLocalInt(OBJECT_SELF,"inccloudcd"));
       }
       else
       {
         SendMessageToPC(OBJECT_SELF,"Incendiary Cloud is on cool down for 5 rounds. This is a Shifter form only cool down.");
         return;
       }
    }

    //Declare major variables, including the Area of Effect object.
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGFIRE);
    //Capture the spell target location so that the AoE object can be created.
    location lTarget = GetSpellTargetLocation();
    int nDuration = GetNewCasterLevel( OBJECT_SELF );
    effect eImpact = EffectVisualEffect(260);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    if(nDuration < 1)
    {
        nDuration = 1;
    }
    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Create the object at the location so that the objects scripts will start working.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

