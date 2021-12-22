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
// main
//-------------------------------------------------------------------------------

void main(){

    object oCritter = OBJECT_SELF;

    effect eConceal = EffectConcealment(25, MISS_CHANCE_TYPE_NORMAL);
    eConceal = SupernaturalEffect(eConceal);

    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConceal, oCritter));

    location lCritter = GetLocation( oCritter );
    object oTarget  = GetFirstObjectInShape( SHAPE_SPHERE, 300.0, lCritter, FALSE,
                                            OBJECT_TYPE_CREATURE );
    int nCritters = GetLocalInt( oCritter, "enemies" );

    while ( GetIsObjectValid( oTarget ) )
    {
        if ( GetIsEnemy( oTarget, oCritter ) == TRUE && GetIsPC( oTarget ) == TRUE )
        {
            ++nCritters;
            SetLocalObject( oCritter, "pc_"+IntToString( nCritters ), oTarget );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 300.0, lCritter, FALSE,
                                        OBJECT_TYPE_CREATURE );
    }
    SetLocalInt( oCritter, "enemies", nCritters );

    //Continue with standard script
    DelayCommand( SPAWNBUFFDELAY, OnSpawnRoutines( oCritter ) );

    CreateMySpellLists( oCritter );

    SetLocalString( oCritter, "ai", "ds_ai2" );

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
