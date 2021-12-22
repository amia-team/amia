//::///////////////////////////////////////////////
//:: Deadly Holy Trap
//:: NW_T1_HolyDeadC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering undead with a dose of holy
    water for 12d10 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
//:://////////////////////////////////////////////

// 2008-04-11    Disco    Added PvP system

#include "NW_I0_SPELLS"
#include "inc_ds_traps"

void main()
{
    int nDamage1    = d10(12);
    int nDamage2    = d4(8);

    //Declare major variables
    object oTarget  = GetEnteringObject();

    //----------------------------------------------------------------
    //trap pvp system
    //----------------------------------------------------------------
    int nTrapStatus = GetTrapStatus( oTarget, OBJECT_SELF );

    if ( nTrapStatus < 0 ){

        return;
    }

    object oOwner   = GetLocalObject( OBJECT_SELF, TRAP_CREATOR );
    //----------------------------------------------------------------

    //The original code rolled an attack and checked target's AC, but never
    //actually checked against the AC.  Commented out for efficiency.
    //
    //int nAC = GetAC(oTarget);
    //Make attack roll
    //int nRoll = d20(1) + 10 + 2;

    effect eDam;
    effect eVis     = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eAttDec  = EffectAttackDecrease( 1 );

    int nUpgrade    = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );

    //if (nRoll > 0)
    //{
    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        eDam = EffectDamage( nDamage1, DAMAGE_TYPE_DIVINE );
        if (nUpgrade){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eAttDec, oTarget, RoundsToSeconds(5) );

        }

        //Apply Holy Damage and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        //----------------------------------------------------------------
        //trap pvp system
        //----------------------------------------------------------------
        //transfer PvP settings
        TransferPvpMode( oTarget, oOwner, nTrapStatus, nDamage1, "divine" );
        //----------------------------------------------------------------
    }
    else
    {
        eDam = EffectDamage( nDamage2, DAMAGE_TYPE_DIVINE );
        //Apply Holy Damage and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        //----------------------------------------------------------------
        //trap pvp system
        //----------------------------------------------------------------
        //transfer PvP settings
        TransferPvpMode( oTarget, oOwner, nTrapStatus, nDamage2, "divine" );
        //----------------------------------------------------------------
    }

    //}

}

