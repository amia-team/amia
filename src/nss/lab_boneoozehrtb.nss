/*

OnHeartbeat script for the Bone Ooze to engulf nearby targets and apply
ability damage until they escape.

*/

void main()
{
    object oCritter = GetAreaOfEffectCreator( OBJECT_SELF );

    effect eTrap = EffectCutsceneParalyze();
    effect eInvis = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
    effect eLink1 = EffectLinkEffects( eTrap, eInvis );
           eLink1 = SupernaturalEffect( eLink1 );

    effect eSTR = EffectAbilityDecrease( ABILITY_STRENGTH, d6(1) );
    effect eDEX = EffectAbilityDecrease( ABILITY_DEXTERITY, d6(1) );
    effect eCON = EffectAbilityDecrease( ABILITY_CONSTITUTION, d6(1) );
    effect eLink2 = EffectLinkEffects( eSTR, eDEX );
           eLink2 = EffectLinkEffects( eLink2, eCON );
    effect eConHit = EffectVisualEffect( VFX_COM_BLOOD_LRG_YELLOW );

    object oTarget = GetFirstInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        //if not already swallowed, do a reflex save and swallow on failure
        if( GetLocalInt( oTarget, "Swallowed" ) == 1 )
        {
            if( ReflexSave( oTarget, 38, SAVING_THROW_TYPE_NONE, oCritter ) == 0 )
            {
                AssignCommand( oTarget, ActionJumpToLocation( GetLocation( oCritter ) ) );
                DelayCommand( 0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, 5.5 ) );
                SetLocalInt( oTarget, "Swallowed", 1 );

                string sName = GetName( oTarget );
                string sSwallow = "<cеее>**Engulfs "+sName+" as they get too close and begins digesting them!**</c>";
                SpeakString( sSwallow, TALKVOLUME_TALK );
                FloatingTextStringOnCreature( sSwallow, oCritter, FALSE );
            }
            else
            {
                SetLocalInt( oTarget, "Swallowed", 0 );
            }
        }
        //if already swallowed, do ability damage and progress counter
        else if( GetLocalInt( oTarget, "Swallowed" ) >= 1 )
        {
            if( ReflexSave( oTarget, 38, SAVING_THROW_TYPE_NONE, oCritter ) == 0 )
            {
                AssignCommand( oTarget, ActionJumpToLocation( GetLocation( oCritter ) ) );
                DelayCommand( 0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, 5.5 ) );
                SetLocalInt( oTarget, "Swallowed", GetLocalInt( oTarget, "Swallowed" ) + 1 );

                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget );
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eConHit, oTarget );
            }
            else
            {
                SetLocalInt( oTarget, "Swallowed", 0 );
            }
        }
        oTarget = GetNextInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );
    }
}
