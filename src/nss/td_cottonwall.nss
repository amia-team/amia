#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_i0_position"

object CreateCottonCandy( location lTarget ){

    object o = CreateObject( OBJECT_TYPE_PLACEABLE, "cottoncandy", lTarget, FALSE, "cottoncandymustdie" );
    DelayCommand( 600.0, DestroyObject( o ) );
    return o;
}

void ClearCandy(){

    object o = GetFirstObjectInArea( );
    while( GetIsObjectValid( o ) ){

        if( GetTag( o ) == "cottoncandymustdie" ){
            DestroyObject( o );
        }

        o = GetNextObjectInArea( );
    }
}

location GetBehindLocationX(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngleOpposite = GetOppositeDirection(fDir);
    return GenerateNewLocation(oTarget,
                               0.5,
                               fAngleOpposite,
                               fDir);
}


location GetStepLeftLocationX(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetLeftDirection(fDir);
    return GenerateNewLocation(oTarget,
                               2.0,
                               fAngle,
                               fDir);
}

location GetStepRightLocationX(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetRightDirection(fDir);
    return GenerateNewLocation(oTarget,
                               2.0,
                               fAngle,
                               fDir);
}

void main(){

    ClearCandy();

    location lTarget = GetSpellTargetLocation();

    object oLayer1Origo = CreateCottonCandy( lTarget );
    object oLayer2Origo = CreateCottonCandy( GetBehindLocationX( oLayer1Origo ) );

    CreateCottonCandy( GetStepRightLocationX( CreateCottonCandy( GetStepRightLocationX( oLayer1Origo ) ) ) );
    CreateCottonCandy( GetStepLeftLocationX( CreateCottonCandy( GetStepLeftLocationX( oLayer1Origo ) ) ) );

    CreateCottonCandy( GetStepLeftLocationX( CreateCottonCandy( GetStepLeftLocationX( oLayer2Origo ) ) ) );
    CreateCottonCandy( GetStepRightLocationX( CreateCottonCandy( GetStepRightLocationX( oLayer2Origo ) ) ) );
}
