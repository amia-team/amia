//::///////////////////////////////////////////////
//:: Summon Slaad
//:: NW_S0_SummSlaad
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a Red Slaad to aid the threatened slaad
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "inc_td_shifter"
#include "amia_include"

void main()
{
    // Expertise/Improved Expertise disabling for Shifters
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE, FALSE );
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, FALSE );

    //Declare major variables
    float fDuration;
    effect eSummon;

    if( GetIsPolymorphed( OBJECT_SELF ) )
    {
        eSummon = EffectSummonCreature("planar_1_n",VFX_FNF_SUMMON_MONSTER_3);
        fDuration = RoundsToSeconds( GetNewCasterLevel( OBJECT_SELF ) );
        eSummon = EffectShifterEffect( eSummon, OBJECT_SELF);
    }
    else
    {
        eSummon = EffectSummonCreature("NW_S_SLAADRED",VFX_FNF_SUMMON_MONSTER_3);
        fDuration = NewHoursToSeconds(24);
    }

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration );
}
