/*
    Environmental Damage Triggers
        OnHeartbeat damage to any in the trigger area. Used for environmental
        effects that cannot be disabled.
*/

void main()
{
    int nType1 = GetLocalInt( OBJECT_SELF, "dmg_type_1" );
    int nType2 = GetLocalInt( OBJECT_SELF, "dmg_type_2" );
    int nDice = GetLocalInt( OBJECT_SELF, "dmg_dice" );
    int nInterval = GetLocalInt( OBJECT_SELF, "interval" );
    int nDC = GetLocalInt( OBJECT_SELF, "save_dc" );
    int nSave = GetLocalInt( OBJECT_SELF, "save_type" );
    int nConst = GetLocalInt( OBJECT_SELF, "save_const" );
    int nCount;
    effect eDam1;
    effect eDam2;

    object oTarget = GetFirstInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        //added optional interval, default is every 2 rounds
        nCount = GetLocalInt( oTarget, GetName( OBJECT_SELF ) );
        if( nCount == nInterval )
        {
            //If save_type is 0, there is no save for this hazard
            if( nSave == 1 )
            {
                if( FortitudeSave( oTarget, nDC, nConst, OBJECT_SELF ) == 0 )
                {
                    //apply damage as denoted by local variables
                    eDam1 = EffectDamage( d4( nDice ), nType1, DAMAGE_POWER_NORMAL );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam1, oTarget );
                    if( nType2 != 0 )
                    {
                        eDam2 = EffectDamage( d4( nDice ), nType2, DAMAGE_POWER_NORMAL );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam2, oTarget );
                    }
                }
            }
            else if( nSave == 2 )
            {
                if( ReflexSave( oTarget, nDC, nConst, OBJECT_SELF ) == 0 )
                {
                    //apply damage as denoted by local variables
                    eDam1 = EffectDamage( d4( nDice ), nType1, DAMAGE_POWER_NORMAL );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam1, oTarget );
                    if( nType2 != 0 )
                    {
                        eDam2 = EffectDamage( d4( nDice ), nType2, DAMAGE_POWER_NORMAL );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam2, oTarget );
                    }
                }
            }
            else if( nSave == 3 )
            {
                if( WillSave( oTarget, nDC, nConst, OBJECT_SELF ) == 0 )
                {
                    //apply damage as denoted by local variables
                    eDam1 = EffectDamage( d4( nDice ), nType1, DAMAGE_POWER_NORMAL );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam1, oTarget );
                    if( nType2 != 0 )
                    {
                        eDam2 = EffectDamage( d4( nDice ), nType2, DAMAGE_POWER_NORMAL );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam2, oTarget );
                    }
                }
            }
            else
            {
                //apply damage as denoted by local variables
                eDam1 = EffectDamage( d4( nDice ), nType1, DAMAGE_POWER_NORMAL );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam1, oTarget );
                if( nType2 != 0 )
                {
                    eDam2 = EffectDamage( d4( nDice ), nType2, DAMAGE_POWER_NORMAL );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam2, oTarget );
                }
            }

            //check if this is first application, send descriptive text if so
            if( GetLocalObject( oTarget, GetName( OBJECT_SELF ) ) != OBJECT_SELF )
            {
                SendMessageToPC( oTarget, GetLocalString( OBJECT_SELF, "text" ) );
                SetLocalObject( oTarget, GetName( OBJECT_SELF ), OBJECT_SELF );
            }

            SetLocalInt( oTarget, GetName( OBJECT_SELF ), 0 );
            oTarget = GetNextInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );
        }
        else
        {
            nCount = nCount + 1;
            SetLocalInt( oTarget, GetName( OBJECT_SELF ), nCount );
        }
    }
}
