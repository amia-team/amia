//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_damaged
//group:   Jobs & crafting
//used as: OnDamaged NPC event script
//date:    january 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_j_lib"



void main(){

    object oPC  = GetLastAttacker();
    object oNPC = OBJECT_SELF;
    object oOwner = GetLocalObject( oNPC, DS_J_USER );

    SendMessageToPC( oOwner, CLR_ORANGE+"Your "+GetName(oNPC)+" in "+GetName(GetArea(oNPC))+" has been killed by "+GetName(oPC)+"." );
    log_to_exploits( oPC, "ds_j: attacked NPC ("+GetTag( oNPC )+")", GetResRef( GetArea( oPC ) ), 0 );

    int nAnimals  = GetLocalInt( oOwner, GetResRef( oNPC ) );

    //remove spawn block on oUser
    SetLocalInt( oOwner, GetResRef( oNPC ), ( nAnimals - 1 ) );

    //set new time
    effect eGore = EffectVisualEffect( VFX_COM_CHUNK_RED_LARGE );

    ApplyEffectToObject ( DURATION_TYPE_INSTANT, eGore, oNPC );

    SafeDestroyObject( oNPC );
}
