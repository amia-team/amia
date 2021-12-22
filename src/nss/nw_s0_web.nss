//::///////////////////////////////////////////////
//:: Web
//:: NW_S0_Web.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a mass of sticky webs that cling to
    and entangle target who fail a Reflex Save
    Those caught can make a new save every
    round.  Movement in the web is 1/6 normal.
    The higher the creatures Strength the faster
    they move out of the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////

//  1/27/2017   msheeler    added function to tag the AOE so we know
//                          which if it was created with Web or Greater Shadow
//                          Conjuration Web.

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
    effect eAOE = EffectAreaOfEffect(AOE_PER_WEB);

    //Grab the spell ID so we can tag the AoE with the version
    int nSpellId = GetSpellId();

    location lTarget = GetSpellTargetLocation();
    int nDuration = GetNewCasterLevel(OBJECT_SELF) / 2;
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0


    int nHD = GetHitDice(OBJECT_SELF);
    // Dirty fix for the spider companion web spam. Will always make sure it only fires once.
    if((GetRacialType(OBJECT_SELF) == RACIAL_TYPE_VERMIN) && (!GetIsPC(OBJECT_SELF)))
    {
      int i;
      for ( i=1; i<(1 + nHD/5); ++i ){
      DecrementRemainingSpellUses(OBJECT_SELF,SPELL_WEB);
      }
    }

    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    //tag the AoE with the Spell ID that created the AoE which will be SPELL_WEB or
    //SPELL_GREATER_SHADOW_CONJURATION_WEB
    DelayCommand (0.1, SetLocalInt (GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget, 1), "nSpellId", nSpellId));
}
