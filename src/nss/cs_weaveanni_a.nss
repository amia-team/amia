// Aura of Weave Annihilation (OnEnter Aura)
//
// Creates an area of effect that dispels everything within and causes spell failure.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/29/2012 PoS              Initial Release.
//

#include "X0_I0_SPELLS"

void main()
{
    // Variables.
    object oModule          = GetModule();
    object oItem            = GetLocalObject( oModule, "weaveanni_item" );
    object oPC              = GetLocalObject( oModule, "weaveanni_user" );

    int    nCount;
    int    nEffectRemoved;

    int    nHP              = GetCurrentHitPoints( oPC );
    int    nLastHP          = GetLocalInt( oItem, "current_hp" );

    int    nDC              = nLastHP - nHP;

    int    nSave            = GetSkillRank( SKILL_CONCENTRATION, oPC );

    int    nRandom          = d20();

    string sName            = GetName( oPC );

    effect eVFX             = EffectVisualEffect( 292 );
    effect eSpellFailure    = EffectSpellFailure();

    eSpellFailure           = ExtraordinaryEffect( eSpellFailure );

    if( nDC > 0 )
    {
        if( nSave + nRandom < nDC )
        {
            FloatingTextStringOnCreature( "<c þþ><c  þ>"+sName+"</c> : Concentration Save : *failure* : (" +IntToString( nSave )+ " + " +IntToString( nRandom )+ " = " +IntToString( nSave + nRandom )+ " vs. DC: " +IntToString( nDC )+ ")</c>", oPC, FALSE );

            effect eEffect = GetFirstEffect( oPC );
            while( GetIsEffectValid( eEffect ) )
            {
                if( GetEffectSubType( eEffect ) == SUBTYPE_EXTRAORDINARY )
                {
                    if( GetEffectType( eEffect ) == EFFECT_TYPE_AREA_OF_EFFECT )
                    {
                        RemoveEffect( oPC, eEffect );
                        DeleteLocalObject( oModule, "weaveanni_user" );
                        DeleteLocalObject( oModule, "weaveanni_item" );
                        DeleteLocalInt( oItem, "current_hp" );
                        return;
                    }
                }
                eEffect = GetNextEffect( oPC );
            }
        }
        else
        {
            FloatingTextStringOnCreature( "<c þþ><c  þ>"+sName+"</c> : Concentration Save : *success* : (" +IntToString( nSave )+ " + " +IntToString( nRandom )+ " = " +IntToString( nSave + nRandom )+ " vs. DC: " +IntToString( nDC )+ ")</c>", oPC, FALSE );
        }
    }

    SetLocalInt( oItem, "current_hp", nHP );

    object oTarget = GetFirstInPersistentObject();
    while( GetIsObjectValid( oTarget ) )
    {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSpellFailure, oTarget, 6.0 );

        effect eEffect = GetFirstEffect( oTarget );
        while( GetIsEffectValid( eEffect ) )
        {
            if( Random( 2 ) == 0 )
            {
                if( GetEffectSubType( eEffect ) == SUBTYPE_EXTRAORDINARY || GetEffectSubType( eEffect ) == SUBTYPE_SUPERNATURAL )
                {
                    if( GetEffectType( eEffect ) != EFFECT_TYPE_MOVEMENT_SPEED_DECREASE && GetEffectType( eEffect ) != EFFECT_TYPE_AREA_OF_EFFECT && GetEffectType( eEffect ) != EFFECT_TYPE_SPELL_FAILURE )
                    {
                        nEffectRemoved = 1;
                        RemoveEffect( oTarget, eEffect );
                    }
                }
                else
                {
                    nEffectRemoved = 1;
                    RemoveEffect( oTarget, eEffect );
                }
            }

            eEffect = GetNextEffect( oTarget );
        }

        if( nEffectRemoved == 1 )
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
        }

        nEffectRemoved = 0;

        // Get the new target.
        oTarget = GetNextInPersistentObject();
    }
}
