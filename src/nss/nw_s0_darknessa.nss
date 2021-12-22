// nw_s0_darknessa - Darkness (On Enter)
// Copyright (c) 2001 Bioware Corp.
//
// Rundown:
// Step 1 - Checks for Darkness Immunity on creature skin
// Step 2 - Removes existing Darkness effects individually (has to be seperate)
// Step 3 - Checks for Ultravision Effect on target, applies only invisibility
// Step 4 - Applies new Darkness effects individually (has to be seperate)
// Step 5 - Starts tracking in case of multiple Darkness AoEs overlapping
//
// Revision History
// Date       Name                Description
// ---------- ------------------  --------------------------------------------
// 02/28/2002 Preston Watamaniuk  Initial Release
// 08/16/2003 jpavelch            Added handling for subraces.
// 12/13/2004 jpavelch            Merged in NWN patch 1.65 changes.
// 12/10/2005 kfw                 disabled SEI, True Race compatibility added
// 2008/07/05 disco               new blindness/underwater system
// 2008/07/05 disco               new racial trait system
// 2012/02/10 PoS                 Added immunity for creatures above 41 CR, hopefully to prevent easy boss kills
// 2013/04/09 Glim                Fixes for overlapping Darkness spells and Ultravision

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "amia_include"


void main(){

    // vars
    object oPC = OBJECT_SELF;
    object oTarget = GetEnteringObject();

    //Check for Darkness Immunity and end if found
    itemproperty ipImmune = ItemPropertySpellImmunitySpecific( IP_CONST_IMMUNITYSPELL_DARKNESS );
    object oHide = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oTarget );
    if( IPGetItemHasProperty( oHide, ipImmune, DURATION_TYPE_PERMANENT, FALSE ) == TRUE )
    {
        return;
    }

    string szRace=GetSubRace(oPC);

    effect eDark = EffectDarkness();
    effect eInvis = EffectInvisibility( INVISIBILITY_TYPE_DARKNESS );
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDark, eDur);

    //April 2013: If already affected, remove the old effect before applying new one
    effect eAOE = GetFirstEffect(oTarget);

    while (GetIsEffectValid(eAOE))
    {
        //Removes the Darkness (blindness) portion of the effect
        if( GetEffectType( eAOE ) == EFFECT_TYPE_DARKNESS )
        {
            RemoveEffect(oTarget, eAOE);
        }
        //Removes the Darkness (invisibility) portion of the effect
        else if( GetEffectType( eAOE ) == EFFECT_TYPE_INVISIBILITY && GetEffectDurationType( eAOE ) == DURATION_TYPE_PERMANENT )
        {
            RemoveEffect(oTarget, eAOE);
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
    /*  True Races vulnerability handling    */
    ApplyAreaAndRaceEffects( oTarget, 0, 2 );

    //Continue applying new effect
    if(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetEffectSpellId(eLink)));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetEffectSpellId(eLink), FALSE));
        }
        // Creatures immune to the darkness spell are not affected.
        if ( ResistSpell(OBJECT_SELF,oTarget) != 2 || GetChallengeRating( oTarget ) < 42.0 )
        {
            //Fire cast spell at event for the specified target
            if( GetHasEffect( EFFECT_TYPE_ULTRAVISION, oTarget ) == FALSE )
            {
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget );
            }
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eInvis, oTarget );
        }
        /*  True Races vulnerability handling    */
        ApplyAreaAndRaceEffects( oTarget, 0, 1 );

        //Tracking for multiple Darkness spells
        int nTracking = GetLocalInt( oTarget, "Darkness" );
        nTracking = nTracking + 1;
        SetLocalInt( oTarget, "Darkness", nTracking );
    }
}
