/*
    Custom Spell: (NPC ONLY)
    Trap the Soul (Phane Boss)
    - Succeed at a Will save of be "trapped" inside a Temporal Soul Cyst PLC
    until the PLC is destroyed or 15min passes. Spell Resistance applies.
*/

#include "x0_i0_spells"

void main()
{
    //Gather spell details
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject( );
    location lTarget = GetSpellTargetLocation( );
    int nCasterLvl;
    int nSpellPen = 0;
    int nDC;
    int nSR;
    int nCHA = 0;
    float fDur;

    //Check for Spell Penetration feats
    if( GetHasFeat( FEAT_SPELL_PENETRATION, oCaster ) == TRUE )
    {
        nSpellPen = 2;
    }
    if( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION, oCaster ) == TRUE )
    {
        nSpellPen = 4;
    }
    if( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION, oCaster ) == TRUE )
    {
        nSpellPen = 6;
    }

    //Run normally if cast by a PC
    if( GetIsPC( oCaster ) && !GetIsDMPossessed( oCaster ) )
    {
        SendMessageToPC( oCaster, "This spell is not permitted for PC use." );
        return;
    }
    //Otherwise generate custom attributes for NPCs
    else
    {
        nCasterLvl = GetHitDice( oCaster );
        nSR = ( d20( 1 ) + nCasterLvl + nSpellPen );
        nCHA = GetAbilityModifier( ABILITY_CHARISMA, oCaster );
        nDC = ( 10 + 8 + nCHA );
    }

    //remove Evocation bonus since all Custom spell slots are Evocation based
    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster ) == TRUE )
    {
        nDC = nDC - 6;
    }
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCaster ) == TRUE )
    {
        nDC = nDC - 4;
    }
    else if( GetHasFeat( FEAT_SPELL_FOCUS_EVOCATION, oCaster ) == TRUE )
    {
        nDC = nDC - 2;
    }

    //add in appropriate Spell Focus bonus to save DC
    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster ) == TRUE )
    {
        nDC = nDC + 6;
    }
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster ) == TRUE )
    {
        nDC = nDC + 4;
    }
    else if( GetHasFeat( FEAT_SPELL_FOCUS_CONJURATION, oCaster ) == TRUE )
    {
        nDC = nDC + 2;
    }

    //Make sure target isn't already affected by Temporal Stasis, Null Time or
    //Trap Soul (they would not mix well)
    if( GetLocalInt( oTarget, "Temporal_Stasis" ) == 1 ||
        GetLocalInt( oTarget, "Null_Time" ) == 1 ||
        GetLocalInt( oTarget, "Trapped_Soul" ) == 1 )
    {
        return;
    }

    SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_HOLD_MONSTER ) );

    //Spell Resistance applies
    if( GetSpellResistance( oTarget ) < nSR )
    {
        //Will Save
        if( !MySavingThrow( SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster ) )
        {
            CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "temporalsoulcyst", lTarget, FALSE, "", 900.0 );

            SetLocalInt( oTarget, "Trapped_Soul", 1 );

            object oGem = GetNearestObjectByTag( "temporalsoulcyst", oTarget );

            string sName = GetName( oTarget );
            string sSpeak = "**The Phane throws a Temporal Cyst at " + sName + " , trapping their soul within the crystal!**";
            FloatingTextStringOnCreature( sSpeak, oCaster, FALSE );
            SpeakString( sSpeak, TALKVOLUME_TALK );

            event eCystSpawn = EventUserDefined( 33333 );

            DelayCommand( 0.1, SetLocalObject( oGem, "trapedsoul", oTarget ) );
            DelayCommand( 0.2, SignalEvent( oGem, eCystSpawn ) );
        }
    }
}
