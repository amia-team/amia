//::///////////////////////////////////////////////
//:: Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the targeted creature one extra partial
    action per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
// Modified March 2003: Remove Expeditious Retreat effects
// Modified May 19 2020: Cooldown based abiliity - Maverick00053

#include "x0_i0_spells"

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

    object oPC = OBJECT_SELF;
    //make sure feat is always available
    IncrementRemainingFeatUses( oPC, FEAT_EPIC_BLINDING_SPEED );

    //check block time
    if ( GetIsBlocked( oPC, "ds_BS_b" ) > 0 )
    {
        string sRecharge = IntToString( GetIsBlocked( oPC, "ds_BS_b" ) );
        SendMessageToPC( oPC, "You cannot use your Blinding Speed ability for another " +sRecharge+ " seconds!" );
        return;
    }


    int nCD = 210;
    DelayCommand( IntToFloat( nCD ), FloatingTextStringOnCreature( "<c þ >You can now Blinding Speed again!</c>", oPC, FALSE ) );

    //find adjustment to block time
    int nMin;

    while( nCD >= 60 )
    {
        nMin++;
        nCD = nCD - 60;
    }

    //apply the cooldown time
    SetBlockTime( oPC, nMin, nCD, "ds_BS_b" );

    //Declare major variables
    object oTarget = OBJECT_SELF;//GetSpellTargetObject();

    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(SPELL_HASTE, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_HASTE, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(SPELL_MASS_HASTE, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(GetSpellId(), oTarget) == TRUE)
    {
        RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
    }

    effect eHaste = EffectHaste();
    effect eVis = EffectVisualEffect(460);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHaste, eDur);

    //BH: If polymorphed, whatever they cast is created by their skin
    if(GetIsPolymorphed( OBJECT_SELF ))
    {
        eLink = EffectShifterEffect( eLink, OBJECT_SELF);
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Check for metamagic extension

    // Apply effects to the currently selected target.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(GetHitDice( oPC )));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


