//::///////////////////////////////////////////////
//:: Quillfire
//:: [x0_s0_quillfire.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a cluster of quills at a target. Ranged Attack.
    2d8 + 1 point /2 levels (max 5)

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 02, 2003
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/14/2012 Mathias          A 4d6 piercing needle per 5 caster levels to a max of 5.
//

#include "NW_I0_SPELLS"
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

    //Declare major variables.
    object  oTarget     = GetSpellTargetObject();
    int     nCasterLvl  = GetNewCasterLevel(OBJECT_SELF);
    int     nDamage     = 0;
    int     nMetaMagic  = GetMetaMagicFeat();
    int     nCnt;
    effect  eVis        = EffectVisualEffect(VFX_COM_BLOOD_SPARK_SMALL);
    effect  eMissile    = EffectVisualEffect(359);
    int     nMissiles   = (nCasterLvl)/5;
    float   fDist       = GetDistanceBetween(OBJECT_SELF, oTarget);
    float   fDelay      = fDist/(3.0 * log(fDist) + 2.0);

    // Limit missiles to five.
    if(nMissiles == 0) {
        nMissiles = 1;
    } else if (nMissiles > 5) {
        nMissiles = 5;
    }

    // Only affect hostiles.
    if(!GetIsReactionTypeFriendly(oTarget)) {

        // Fire cast spell at event for the specified target.
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_QUILLFIRE));

        // Apply a single damage hit for each missile instead of as a single mass.
        for (nCnt = 1; nCnt <= nMissiles; nCnt++) {

            // Roll damage.
            int nDam = d6(4);

            // Apply metamagic feats.
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                if( !GetIsPolymorphed( OBJECT_SELF ) )
                {
                  nDam = 24;// Damage is at max.
                }
            }
            if (nMetaMagic == METAMAGIC_EMPOWER)
            {
                if( !GetIsPolymorphed( OBJECT_SELF ) )
                {
                  nDam = nDam + nDam/2; // Damage is +50%.
                }
            }

            nDam = GetReflexAdjustedDamage(nDam, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL);

            // Set damage effect.
            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_PIERCING);

            // Apply damage and VFX.
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
        }
    }

    // Play the sound
    PlaySound("cb_ht_dart1");
}



