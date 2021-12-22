/*
    Custom NPC Ability:
    Wall of Ice
    - Creates a long wall of ice around the target, trapping them inside
    - Wall is bashable both from inside and out, with 500 HP and 10 DR
*/

#include "amia_include"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetLocalObject( oCaster, "abl_wallofice" );
    location lTarget = GetBehindLocation( oTarget );
    effect eIce = EffectVisualEffect( VFX_DUR_ICESKIN );
    effect eStorm = EffectVisualEffect( VFX_FNF_ICESTORM );
    float fDestroy = IntToFloat( GetHitDice( oCaster ) * 6 );

    int nWall = GetLocalInt( oCaster, "IceWall" );
        nWall = nWall + 1;
    string sWall = IntToString( nWall );
           sWall = "wall_of_ice_"+sWall;

    ActionCastFakeSpellAtLocation( SPELL_ICE_STORM, lTarget );
    DelayCommand( 3.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eStorm, lTarget ) );
    DelayCommand( 4.8, CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "wall_of_ice", lTarget, FALSE, sWall, fDestroy ) );
    DelayCommand( 4.9, TurnToFaceObject( oCaster, GetNearestObjectByTag( sWall ) ) );
    DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eIce, GetNearestObjectByTag( sWall ) ) );

    SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_WALL_OF_FIRE ) );
}
