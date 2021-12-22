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

    object oPC  = GetLastDamager();
    object oNPC = OBJECT_SELF;

    //delete self if attacked by a non-PC
    if ( !GetIsPC( oPC ) && !GetIsPC( GetMaster( oPC ) ) ){

        //only for animals
        if ( GetRacialType( oNPC ) == RACIAL_TYPE_ANIMAL ){

            object oOwner = GetLocalObject( oNPC, DS_J_USER );
            int nAnimals  = GetLocalInt( oOwner, GetResRef( oNPC ) );

            //remove spawn block on oUser
            SetLocalInt( oOwner, GetResRef( oNPC ), ( nAnimals - 1 ) );

            //set new time
            effect eGore = EffectVisualEffect( VFX_COM_CHUNK_RED_LARGE );

            ApplyEffectToObject ( DURATION_TYPE_INSTANT, eGore, oNPC );

            SafeDestroyObject( oNPC );

            return;
        }
    }
    else{

        ActionAttack( oPC );
    }

    //keep NPC healthy
    effect eHeal = EffectHeal( 200 );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oNPC );
}
