// Based off the Alarm PnP spell, for Amia.
//
// Creates an AoE field that will alert the caster to a stealther's presence if
// they are in stealth mode upon entering the AoE and fail a will save. If the
// will save is made, no dialogue is sent to the caster, and no saving throw is
// registered in combat log.
//
// Duration: 2 Hours per Caster Level
// Spell School: Abjuration
// Spell Level: 1
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/06/2016 Maverick00053    Initial Release
// 04/09/2016 PaladinOfSune    Fixes
//

#include "x2_inc_spellhook"

void DestroyAlarm( object oWP ){

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

void main(){

    if (!X2PreSpellCastCode()){
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object      oCaster = OBJECT_SELF;
    location    lTarget = GetSpellTargetLocation( );
    int         nDur    = GetCasterLevel( oCaster ) * 2;
    float       fDur    = HoursToSeconds( nDur );

    object      oAlarm  = GetLocalObject( oCaster, "alarm" );

    // Removes the current Alarm if one already exists
    if( GetIsObjectValid( oAlarm ) ) {
        DestroyAlarm( oAlarm );
        FloatingTextStringOnCreature( "Alarm already found! Removing...", oCaster, FALSE );
    }

    // Create a PLC marker - this makes removing existing Alarms much easier
    oAlarm = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_spl_alarm", lTarget, FALSE );

    AssignCommand( oAlarm, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, EffectAreaOfEffect( 54, "spl_alarm_en", "****", "****" ), lTarget, fDur ) );

    FloatingTextStringOnCreature( "New Alarm created! Duration: " + IntToString( nDur ) + " hours.", oCaster, FALSE );

    SetLocalObject( oCaster, "alarm", oAlarm );
    SetLocalObject( oAlarm, "caster", oCaster );
    SetLocalInt( oAlarm, "caster_class", GetLastSpellCastClass()); // For DC calculation in enter script

    DestroyObject( oAlarm, fDur );
    DelayCommand( fDur, DeleteLocalObject( oCaster, "alarm" ) );
}
