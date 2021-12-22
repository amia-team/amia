//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_spawn
//group:   ds_ai
//used as: OnSpawn
//date:    dec 23 2007
//author:  disco

//  20071119  disco       Moved cleanup scripts to amia_include
//  2013/11/13 Glim       Added functionality for special ability usage onspawn.

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oCritter = OBJECT_SELF;

    //Phane Spawn
    string sTag = GetTag(oCritter);
    string sCopy = "phane2";
    if(sTag == sCopy)
    {
        effect eExit = EffectVisualEffect(VFX_DUR_GHOST_SMOKE, FALSE);
        object oAttack = GetNearestEnemy(oCritter);
        object oPhane = GetObjectByTag("phane");
        int iMaxHP = GetMaxHitPoints(oPhane);
        int iRealHP = GetCurrentHitPoints(oPhane);
        int iLevelHP = (iMaxHP - iRealHP);
        effect eDamage = EffectDamage(iLevelHP, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);

        DelayCommand(0.5, ActionAttack(oAttack));
        DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCritter));
        DelayCommand(11.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eExit, oCritter, 1.0));
        DestroyObject(oCritter, 12.0);
    }

    //Normal Script
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
