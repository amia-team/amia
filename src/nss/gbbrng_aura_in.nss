//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  gbbrng_aura_in
//group:   gbbrng
//used as: OnEnter Aura script for Gibbering Mouther
//date:    sept 21 2012
//author:  Glim

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void DoGibberingSave( object oCritter, object oTarget );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oTarget = GetEnteringObject();
    object oCritter = GetAreaOfEffectCreator( OBJECT_SELF );

    //check to see if the target has already saved vs. Gibbering from this critter
    object oGibber = GetLocalObject( oTarget, "Gibber" );

    if( oGibber != oCritter && GetIsEnemy( oTarget, oCritter ) == TRUE )
    {
        DoGibberingSave( oCritter, oTarget );
    }
}

void DoGibberingSave( object oCritter, object oTarget )
{
    if( WillSave( oTarget, 14, SAVING_THROW_TYPE_MIND_SPELLS, oCritter ) == 0 )
    {
        effect eConfuse = EffectConfused();
        effect eVis = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_NEGATIVE );
        float fDur = RoundsToSeconds( d2(1) );
        string sName = GetName( oTarget );

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfuse, oTarget, fDur );
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur );

        AssignCommand( oCritter, SpeakString( "<c¥  >**The sound of the Mouther's costant whispering and muttering of chaotic gibberish momentarily drives "+sName+" insane!**</c>" ) );
    }
    SetLocalObject( oTarget, "Gibber", oCritter );
}
