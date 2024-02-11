//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S0_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// Editted: 2.10.2024 - Mav + Jes - Reworking Darkness to no longer use EffectDarkness because it sucks

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"

void main()
{
    string DARKNESS_PROHIBITED = "NO_DARKNESS";

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    object oPC=OBJECT_SELF;

    if (GetLocalInt(GetArea(oPC),DARKNESS_PROHIBITED) == TRUE) {
        SendMessageToPC(oPC,"The Darkness Spell Fizzles!");
        return;
    }

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(55,"nw_s0_darknessa","****","nw_s0_darknessb");
    location lTarget = GetSpellTargetLocation();
    int nDuration = GetNewCasterLevel(oPC);

    // Duration override from Item scripts
    int nDuration_override=0;

    // Used for drow racial item and old assassian darkness
    if( ( nDuration_override=GetLocalInt( oPC, "darkduration") ) >0 )
    {
       nDuration=nDuration_override;
       DeleteLocalInt( oPC , "darkduration");
    }

    // Blackguard PrC PnP Spells.
    if( GetLocalInt( oPC, "bgdark" ) ){
        nDuration = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
        DeleteLocalInt( oPC, "bgdark" );
    }
    else if( GetLocalInt( oPC, "bgdeepdark" ) ){
        nDuration = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC ) * 2;
        DeleteLocalInt( oPC, "bgdeepdark" );
    }

    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (GetIsPolymorphed(OBJECT_SELF)){/*Disable metamagic if shifted*/}
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}
