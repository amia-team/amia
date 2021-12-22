/*
    Environmental Sickening Triggers
        OnHeartbeat application (or re-application) of Sickened effect:
            -2 to all attack rolls, damage, saving throws and skill checks.
*/

#include "NW_I0_SPELLS"

void main()
{
    int nDC = GetLocalInt( OBJECT_SELF, "save_dc" );
    int nSave = GetLocalInt( OBJECT_SELF, "save_type" );
    int nConst = GetLocalInt( OBJECT_SELF, "save_const" );

    object oTarget = GetFirstInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        //If save_type is 0, there is no save for this hazard
        if( nSave == 1 )
        {
            if( FortitudeSave( oTarget, nDC, nConst, OBJECT_SELF ) == 0 )
            {
                //apply effect
                effect eSick = SupernaturalEffect( CreateDoomEffectsLink() );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSick, oTarget, 5.9 );
            }
        }
        else if( nSave == 2 )
        {
            if( ReflexSave( oTarget, nDC, nConst, OBJECT_SELF ) == 0 )
            {
                //apply effect
                effect eSick = SupernaturalEffect( CreateDoomEffectsLink() );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSick, oTarget, 5.9 );
            }
        }
        else if( nSave == 3 )
        {
            if( WillSave( oTarget, nDC, nConst, OBJECT_SELF ) == 0 )
            {
                //apply effect
                effect eSick = SupernaturalEffect( CreateDoomEffectsLink() );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSick, oTarget, 5.9 );
            }
        }
        //check if this is first application, send descriptive text if so
        if( GetLocalObject( oTarget, GetName( OBJECT_SELF ) ) != OBJECT_SELF )
        {
            SendMessageToPC( oTarget, GetLocalString( OBJECT_SELF, "text" ) );
            SetLocalObject( oTarget, GetName( OBJECT_SELF ), OBJECT_SELF );
        }

        oTarget = GetNextInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );
    }
}
