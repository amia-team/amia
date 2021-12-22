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
void DoTrill( object oCritter );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oCritter = OBJECT_SELF;

    DelayCommand( SPAWNBUFFDELAY, OnSpawnRoutines( oCritter ) );

    CreateMySpellLists( oCritter );

    SetLocalString( oCritter, "ai", "ds_ai2" );

    effect eCold = EffectDamageShield( d8(1), DAMAGE_BONUS_1, DAMAGE_TYPE_COLD );
           eCold = SupernaturalEffect( eCold );

    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCold, oCritter ) );

    float fDelay = TurnsToSeconds( d3(2) );

    DelayCommand( fDelay, DoTrill( oCritter ) );

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

void DoTrill( object oCritter )
{
    location lCritter = GetLocation( oCritter );

    effect eTrill = EffectVisualEffect( VFX_FNF_HOWL_MIND );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eTrill, oCritter );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 30.5, lCritter, FALSE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        int nSave = WillSave( oTarget, 30, SAVING_THROW_TYPE_MIND_SPELLS, oCritter );

        if( nSave == 0 )
        {
            effect eStun = EffectStunned();
                   eStun = SupernaturalEffect( eStun );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun, oTarget, IntToFloat( d4(1) ) );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 30.5, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    }
}
