//------------------------------------------------------------------------------
// Custom Aura Script - Obyrith Madness Heartbeat - Uzollru Creature
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// prototypes
//------------------------------------------------------------------------------
void ObyrithMadness();

//------------------------------------------------------------------------------
// main
//------------------------------------------------------------------------------
void main()
{
    object oCritter = GetAreaOfEffectCreator();
    location lCritter = GetLocation( oCritter );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 37.0, lCritter, FALSE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        //Check to see if already made save or already affected, if so cancel
        int nMadness = GetLocalInt( oTarget, "ObyMad" );
        int nRace = GetRacialType( oTarget );
        int nLawChaos = GetAlignmentLawChaos( oTarget );
        int nGoodEvil = GetAlignmentGoodEvil( oTarget );
        int nBaseRace = GetRacialType( oTarget );

        if( nBaseRace == RACIAL_TYPE_CONSTRUCT  ||
            nBaseRace == RACIAL_TYPE_OOZE       ||
            nBaseRace == RACIAL_TYPE_UNDEAD )
        {
            //do nothing, skip to next target
        }
        else if ( GetIsEnemy( oTarget, oCritter ) && nMadness == 0 )
        {
            int nWill = WillSave( oTarget, 27, SAVING_THROW_TYPE_NONE, oCritter );

            if( nLawChaos == ALIGNMENT_CHAOTIC && nGoodEvil == ALIGNMENT_EVIL && nRace == RACIAL_TYPE_OUTSIDER )
            {
                SetLocalInt( oTarget, "ObyMad", 2 );
            }
            else if( nWill == 0 )
            {
                AssignCommand( oTarget, ObyrithMadness() );
                SignalEvent( oTarget, EventSpellCastAt( oCritter, SPELLABILITY_HOWL_CONFUSE) );
                AssignCommand( oTarget, SpeakString( "<c¥  >**cries out in abject horror at the sight of the Obyrith's alien form**</c>" ) );
                SetLocalInt( oTarget, "ObyMad", 1 );
                SetLocalObject( oTarget, "Obyrith", oCritter );
            }
            else
            {
                SetLocalInt( oTarget, "ObyMad", 2 );
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 37.0, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    }
}

void ObyrithMadness()
{
    //Check to see if affected by Greater Restoration or Heal since application of Madness, if so cancel effect
    int nGResto = GetLocalInt( OBJECT_SELF, "GResto" );
    int nHeal = GetLocalInt( OBJECT_SELF, "Heal" );
    if( nGResto == 1 || nHeal == 1 )
    {
        return;
    }

    //Make sure the creature is commandable for the round
    SetCommandable( TRUE );

    //Clear all previous actions.
    ClearAllActions( TRUE );

    //Roll a random int to determine this rounds effects
    int nRandom = d10(1);

    if( nRandom  == 1 )
    {
        ActionRandomWalk();
        DelayCommand( 5.6, ClearAllActions(TRUE) );
    }
    else if ( nRandom >= 2 && nRandom  <= 5 )
    {
        ClearAllActions(TRUE);
        DelayCommand( 1.0, ClearAllActions(TRUE) );
        DelayCommand( 2.0, ClearAllActions(TRUE) );
        DelayCommand( 3.0, ClearAllActions(TRUE) );
        DelayCommand( 4.0, ClearAllActions(TRUE) );
        DelayCommand( 5.0, ClearAllActions(TRUE) );
    }
    else if( nRandom >= 6 && nRandom <= 10 )
    {
        object oTarget = GetNearestCreature( CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, 1, CREATURE_TYPE_IS_ALIVE, TRUE);
        ActionAttack( oTarget );
        DelayCommand( 1.0, ActionAttack( oTarget ) );
        DelayCommand( 2.0, ActionAttack( oTarget ) );
        DelayCommand( 3.0, ActionAttack( oTarget ) );
        DelayCommand( 4.0, ActionAttack( oTarget ) );
        DelayCommand( 5.0, ActionAttack( oTarget ) );
    }
    DelayCommand( 5.5, SetCommandable( FALSE ) );

    //Visual Effect and repeat next round
    effect eVis = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, 7.0 );
    DelayCommand( 6.0, ObyrithMadness() );
}
