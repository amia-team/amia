/*
    Custom Spell:
    Damning Darkness
    - Level 4 Ranged
    - Darkness AoE effect plus damage per round applied
        through OnHeartbeat AoE script.

    Initial Cast Script
*/

#include "x0_i0_spells"
#include "inc_td_shifter"
void main( )
{
    //Gather spell details
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject( );
    location lTarget = GetSpellTargetLocation( );
    int nCasterLvl;
    float fDur;

    //Run normally if cast by a PC
    if( GetIsPC( oCaster ) && !GetIsDMPossessed( oCaster ) )
    {
        nCasterLvl = GetNewCasterLevel( oCaster );
        fDur = RoundsToSeconds( nCasterLvl );
    }
    //Otherwise generate custom attributes for NPCs
    else
    {
        nCasterLvl = GetHitDice( oCaster );
        fDur = RoundsToSeconds( nCasterLvl );
    }

    //set duration
    if( GetMetaMagicFeat() == METAMAGIC_EXTEND )
    {
        float fDur = ( fDur * 2 );
    }

    effect eAOE = EffectAreaOfEffect( AOE_PER_DARKNESS, "", "spl_damningdarkb", "" );
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDur );
}
