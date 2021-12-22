/*
    Custom Spell - Wall of Stone
    Sor/Wiz lvl 5 (ranged)
    Creates a wall PLC with 8 Hardness and 75HP, lasting Turns per Level.
*/

#include "x0_i0_spells"

void main( )
{

    effect eStone = SupernaturalEffect( EffectVisualEffect( VFX_DUR_PROT_STONESKIN ) );
    effect eDust = EffectVisualEffect( 460 );
    effect eRocks = EffectVisualEffect( 354 );
    effect eVFX = EffectLinkEffects( eDust, eRocks );

    object oPC = GetLastSpellCaster( );
    object oTarget = GetSpellTargetObject( );
    location lTarget = GetSpellTargetLocation( );
    int nCasterLvl  = GetCasterLevel( oPC );

    //duration
    float fDur = HoursToSeconds( nCasterLvl * 3 );
    if( GetMetaMagicFeat() == METAMAGIC_EXTEND )
    {
        float fDur = ( fDur * 2 );
    }
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDur ) )+" seconds." );

    //prep wall's new tag based on how many walls already cast (for tracking)
    int nWall = GetLocalInt( oPC, "StoneWall" );
        nWall = nWall + 1;
    string sWall = IntToString( nWall );
           sWall = "wall_of_stone_"+sWall;
    SetLocalInt( oPC, "StoneWall", nWall );

    //make sure we don't put the wall on top of someone, infront of them instead
    if( GetIsObjectValid( oTarget ) )
    {
        lTarget = GetAheadLocation( oTarget );
    }

    //facing fix
    float fFace = GetFacing( oPC );
    if( fFace <= 180.0 )
    {
        fFace = fFace + 90.0;
    }
    else if( fFace >= 181.0 )
    {
        fFace = fFace - 90.0;
    }

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX, lTarget );

    DelayCommand( 0.1, CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "pc_stone_wall", lTarget, FALSE, sWall, fDur ) );

    DelayCommand( 0.2, AssignCommand( GetNearestObjectByTag( sWall ), SetFacing( fFace ) ) );
    DelayCommand( 0.4, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eStone, GetNearestObjectByTag( sWall ) ) );
}
