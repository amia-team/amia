// Enter script for the Alarm spell.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/06/2016 Maverick00053    Initial Release
// 04/09/2016 PaladinOfSune    Fixes
//

// Manually calculates the save since we're not using Bioware spell functions here
int GetSaveDC( object oCaster, int nCasterClass ) {

    int nClassAbility;
    int nSpellSchoolBonus;
    int nBaseDC = 11;

    if ( GetHasFeat( FEAT_SPELL_FOCUS_ABJURATION, oCaster ) )
        nSpellSchoolBonus = 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster ) )
        nSpellSchoolBonus = 4;
    else if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster ) )
        nSpellSchoolBonus = 2;

    switch ( nCasterClass ) {
        case CLASS_TYPE_RANGER:
            nClassAbility = GetAbilityModifier( ABILITY_WISDOM, oCaster );
            break;
        case CLASS_TYPE_BARD:
            nClassAbility = GetAbilityModifier( ABILITY_CHARISMA, oCaster );
            break;
        case CLASS_TYPE_SORCERER:
            nClassAbility = GetAbilityModifier( ABILITY_CHARISMA, oCaster );
            break;
        case CLASS_TYPE_WIZARD:
            nClassAbility = GetAbilityModifier( ABILITY_INTELLIGENCE, oCaster );
            break;
        default:
            nClassAbility = 0;
            break;
    }
    return nBaseDC + nClassAbility + nSpellSchoolBonus;
}

void DestroyAlarm( object oWP ) {

    // Destroys any Alarm AoEs in the radius - ANY Alarm AoEs, which isn't great. Can be improved later if needed
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_SMALL, GetLocation( oWP ), TRUE, OBJECT_TYPE_AREA_OF_EFFECT );
    while ( GetIsObjectValid( oTarget ) ) {
        if ( GetTag( oTarget ) == "VFX_PER_ALARM" ) {
            DestroyObject( oTarget );
            break;
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_SMALL, GetLocation( oWP ), TRUE, OBJECT_TYPE_AREA_OF_EFFECT );
    }
    DestroyObject( oWP ); // Destroy the PLC marker too
}

void Alarm( object oCaster, object oWP, object oTarget ) {

    // Cooldown check
    if ( GetLocalInt( oTarget, "alarm_cooldown" ) ) {
        return;
    }

    if ( oCaster == oTarget ) {
        FloatingTextStringOnCreature( "Your Alarm is located here.", oCaster, FALSE );
    } else {
        int nDC = GetSaveDC( oCaster, GetLocalInt( oWP, "caster_class" ) );

        int nTargetRoll = d20();
        int nTargetWill = GetWillSavingThrow( oTarget );

        // If the target passes the check and doesn't roll a 1, they get info on their successful save. Otherwise, the caster gets informed and the target knows nothing.
        if ( nTargetRoll > 1 && nTargetRoll + nTargetWill > nDC ) {
            FloatingTextStringOnCreature( "<c þþ><c¡dÑ>" + GetName( oTarget ) + "</c> : Will Save vs. Spell : *success* : (" +IntToString( nTargetRoll )+ " + " +IntToString( nTargetWill )+ " = " +IntToString( nTargetWill + nTargetRoll )+ " vs. DC: " +IntToString( nDC )+ ")</c>", oTarget, FALSE );
        } else {
            FloatingTextStringOnCreature( "Your Alarm is triggered: a ringing sound is heard!", oCaster, FALSE );
        }
    }

    // Set 2 round cooldown
    SetLocalInt( oTarget, "alarm_cooldown", 1 );
    DelayCommand( RoundsToSeconds( 2 ), DeleteLocalInt( oTarget, "alarm_cooldown" ) );
}

void main(){

    object oTarget = GetEnteringObject( );
    object oWP     = GetAreaOfEffectCreator( );
    object oCaster = GetLocalObject( oWP, "caster" );

    // Delete the Alarm if the caster has left the server
    if( !GetIsObjectValid( oCaster ) ) {
        DestroyAlarm( oWP );
        return;
    }

    AssignCommand( oCaster, Alarm( oCaster, oWP, oTarget ) );
}
