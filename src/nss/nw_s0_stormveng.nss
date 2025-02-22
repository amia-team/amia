//::///////////////////////////////////////////////
//:: Storm of Vengeance
//:: NW_S0_StormVeng.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an AOE that decimates the enemies of
    the cleric over a 30ft radius around the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 8, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

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


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_STORM);
    effect eVis = EffectVisualEffect(VFX_FNF_STORM);
    location lTarget = GetSpellTargetLocation();

    if( GetIsPolymorphed( OBJECT_SELF ) && GetLevelByClass( CLASS_TYPE_SHIFTER, OBJECT_SELF ) > 0 )
    {
       int stromcd = GetLocalInt(OBJECT_SELF,"stormvengcd");

       if(stromcd == 0)
       {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
        //Create an instance of the AOE Object using the Apply Effect function
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(10));
        SetLocalInt(OBJECT_SELF,"stormvengcd",1);
        DelayCommand(30.0,DeleteLocalInt(OBJECT_SELF,"stormvengcd"));

       }
       else
       {
         SendMessageToPC(OBJECT_SELF,"Storm of Vengeance is on cool down for 5 rounds. This is a Shifter form only cool down.");
       }


    }
    else
    {
        int nRounds = 10;
        if (GetMetaMagicFeat() == METAMAGIC_EXTEND) {
            nRounds = nRounds * 2;
        }
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
      //Create an instance of the AOE Object using the Apply Effect function
      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nRounds));
    }
}

