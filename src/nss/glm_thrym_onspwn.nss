//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_spawn
//group:   ds_ai
//used as: OnSpawn
//date:    dec 23 2007
//author:  disco

//  20071119  disco       Moved cleanup scripts to amia_include

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void DoFrigidStare( object oCritter );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oCritter = OBJECT_SELF;

    DelayCommand( SPAWNBUFFDELAY, OnSpawnRoutines( oCritter ) );

    CreateMySpellLists( oCritter );

    SetLocalString( oCritter, "ai", "ds_ai2" );

    //specific for Thrym Hound OnSpawn
    effect eCounter1 = EffectDamageShield( d8(1), DAMAGE_BONUS_4, DAMAGE_TYPE_PIERCING );
    effect eCounter2 = EffectDamageShield( d8(1), DAMAGE_BONUS_4, DAMAGE_TYPE_COLD );
    effect eCounter = EffectLinkEffects( eCounter1, eCounter2 );
           eCounter = SupernaturalEffect( eCounter );

    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCounter, oCritter ) );

    DelayCommand( 6.0, DoFrigidStare( oCritter ) );


    //silent communication
    SetListening( OBJECT_SELF, TRUE );
    SetListenPattern( OBJECT_SELF, M_ATTACKED, 1001 );

    //set TS on self if it's on the hide.
    //you can't detect hide properties like effects
    object oHide = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oCritter );

    itemproperty IP = GetFirstItemProperty( oHide );

    while( GetIsItemPropertyValid( IP ) ){

        if( GetItemPropertyType( IP ) == ITEM_PROPERTY_TRUE_SEEING ) {

            effect eTS = SupernaturalEffect( EffectTrueSeeing() );

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eTS, oCritter );

            return;
        }

        IP = GetNextItemProperty( oHide );
    }
}

void DoFrigidStare( object oCritter )
{
    vector oCasterPos = GetPosition( oCritter );
    object oTarget = GetAttackTarget( oCritter );
    string sName = GetName( oTarget );
    location lTarget = GetLocation( oTarget );
    float fDistance = GetDistanceBetween( oTarget, oCritter );
    int nStareUse = GetLocalInt( oCritter, "StareUse" );
    int nStareCount = GetLocalInt( oCritter, "StareCount" );

    if( nStareCount == nStareUse && fDistance <= 18.0 )
    {
        object oVictim = GetFirstObjectInShape( SHAPE_SPELLCYLINDER, 18.0, lTarget, TRUE, OBJECT_TYPE_CREATURE, oCasterPos );

        if( GetIsObjectValid( oVictim ) )
        {
            SpeakString( "<c ее>**breaths a line of ice and sleet at "+sName+" and anyone standing behind them**</c>" );
        }

        while( GetIsObjectValid( oVictim ) )
        {
            int nSave = ReflexSave( oVictim, 24, SAVING_THROW_TYPE_COLD, oCritter);

            if( nSave == 0 )
            {
                effect eDamage = EffectDamage( d6(14), DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
                effect eVFX = EffectVisualEffect( VFX_IMP_FROST_L );
                effect eFrigid = EffectLinkEffects( eDamage, eVFX );

                ApplyEffectToObject( DURATION_TYPE_INSTANT, eFrigid, oVictim );
            }
            else if( nSave == 1 )
            {
                effect eDamage = EffectDamage( d6(7), DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
                effect eVFX = EffectVisualEffect( VFX_IMP_FROST_S );
                effect eFrigid = EffectLinkEffects( eDamage, eVFX );

                ApplyEffectToObject( DURATION_TYPE_INSTANT, eFrigid, oVictim );
            }
            oVictim = GetNextObjectInShape( SHAPE_SPELLCYLINDER, 18.0, lTarget, TRUE, OBJECT_TYPE_CREATURE, oCasterPos );
        }
        nStareUse = d4(1);
        nStareCount = 0;
        SetLocalInt( oCritter, "StareUse", nStareUse );
        SetLocalInt( oCritter, "StareCount", nStareCount );
    }
    else if( nStareCount == nStareUse && fDistance >= 18.1 )
    {
        nStareUse = d4(1);
        nStareCount = 0;
        SetLocalInt( oCritter, "StareUse", nStareUse );
        SetLocalInt( oCritter, "StareCount", nStareCount );
    }
    else if( nStareCount != nStareUse )
    {
        nStareCount = nStareCount + 1;
        SetLocalInt( oCritter, "Starecount", nStareCount );
    }
    DelayCommand( 6.0, DoFrigidStare( oCritter ) );
}
