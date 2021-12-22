/*
    Custom Spell - Wall of Iron
    Sor/Wiz lvl 6 (ranged)
    Creates a wall PLC with 10 Hardness and 150HP, lasting Turns per Level.
*/

#include "x0_i0_spells"

void main( )
{

    effect eIron = SupernaturalEffect( EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR ) );
    effect eDust = EffectVisualEffect( 460 );
    effect eSpike = EffectVisualEffect( 253 );
    effect eVFX = EffectLinkEffects( eDust, eSpike );

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

    //prep wall's new tag based on how many walls already cast (for tracking)
    int nWall = GetLocalInt( oPC, "IronWall" );
        nWall = nWall + 1;
    string sWall = IntToString( nWall );
           sWall = "wall_of_iron_"+sWall;
    SetLocalInt( oPC, "IronWall", nWall );

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

    DelayCommand( 0.2, CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "pc_iron_wall", lTarget, FALSE, sWall, fDur ) );
    DelayCommand( 0.4, AssignCommand( GetNearestObjectByTag( sWall ), SetFacing( fFace ) ) );
    DelayCommand( 0.6, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eIron, GetNearestObjectByTag( sWall ) ) );
}
