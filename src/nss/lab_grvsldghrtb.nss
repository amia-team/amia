/*

OnHeartbeat script for the Graveyard Sludge to animate any nearby Deathbringer
or Mageguard corpses as Skeletal versions.

*/

void AnimateCorpse( location lTarget, string sTag );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oCritter = GetAreaOfEffectCreator( OBJECT_SELF );
    location lCritter = GetLocation( oCritter );
    location lTarget;

    effect eAnimVis = EffectVisualEffect( VFX_IMP_RAISE_DEAD );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid( oTarget ) )
    {
        if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD && GetIsDead( oTarget ) == TRUE )
        {
            if( GetResRef( oTarget ) == "lab_deathbringer" && GetLocalInt( oTarget, "Animated" ) != 1 )
            {
                SetLocalInt( oTarget, "Animated", 1 );
                lTarget = GetLocation( oTarget );
                ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAnimVis, lTarget );
                AssignCommand( oCritter, SpeakString( "<c ¥ >*reanimates a nearby Deathbringer*</c>" ) );
                DestroyObject( oTarget, 0.5 );
                DelayCommand( 1.0, AnimateCorpse( lTarget, "lab_skeldethbrng" ) );
            }
            else if( GetResRef( oTarget ) == "lab_mageguard" && GetLocalInt( oTarget, "Animated" ) != 1 )
            {
                SetLocalInt( oTarget, "Animated", 1 );
                lTarget = GetLocation( oTarget );
                ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAnimVis, lTarget );
                AssignCommand( oCritter, SpeakString( "<c ¥ >*reanimates a nearby Mageguard*</c>" ) );
                DestroyObject( oTarget, 0.5 );
                DelayCommand( 1.0, AnimateCorpse( lTarget, "lab_magegrd_skel" ) );
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    }
}

void AnimateCorpse( location lTarget, string sTag )
{
    CreateObject(OBJECT_TYPE_CREATURE, sTag, lTarget );
}
