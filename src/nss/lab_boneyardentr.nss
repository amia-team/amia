/*

OnEnter script for the Boneyard to absorb any nearby Splinters

*/

void main()
{
    object oCritter = GetAreaOfEffectCreator( OBJECT_SELF );
    object oTarget = GetEnteringObject();

    if( GetResRef( oTarget ) == "lab_splinter" )
    {
        int nSize = GetAppearanceType( oCritter );
        float fMaxHP = IntToFloat( GetMaxHitPoints( oCritter ) );
        int nHeal = FloatToInt( fMaxHP * 0.02 );

        effect eVis = EffectVisualEffect( VFX_COM_CHUNK_BONE_MEDIUM );
        effect eHeal = EffectHeal( nHeal );

        AssignCommand( oTarget, ActionJumpToLocation( GetLocation( oCritter ) ) );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget ) );
        DelayCommand( 1.0, DestroyObject( oTarget ) );
        DelayCommand( 1.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oCritter ) );
        DelayCommand( 1.6, ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oCritter ) );

        if( nSize != 868 )
        {
            DelayCommand( 1.7, SetCreatureAppearanceType( oCritter, nSize + 1 ) );
            string sAbsorb = "<cеее>**Re-absorbs a Splinter of itself, growing larger...**</c>";
            AssignCommand( oCritter, SpeakString( sAbsorb, TALKVOLUME_TALK ) );
            FloatingTextStringOnCreature( sAbsorb, oCritter, FALSE );
        }
    }
}
