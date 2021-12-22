//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_qst_act
//group:   quest
//used as: action script
//date:    aug 02 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = OBJECT_SELF;
    object oNPC     = GetLocalObject( oPC, "ds_target" );
    int nNode       = GetLocalInt( oPC, "ds_node" );

    if ( GetTag( oNPC ) == "rua_priest" && nNode == 1 ){

        object oRing = GetItemByName( oPC, "Cursed Ring of the Chieftain" );

        if ( GetIsObjectValid( oRing ) ){

            SetPCKEYValue( oPC, "rua_ring", 2 );

            IPRemoveMatchingItemProperties( oRing, ITEM_PROPERTY_WEIGHT_INCREASE, DURATION_TYPE_PERMANENT );
            IPRemoveMatchingItemProperties( oRing, IP_CONST_CASTSPELL_ACTIVATE_ITEM, DURATION_TYPE_PERMANENT );

            int nDie = d3();
            int nDamType;

            switch ( nDie ) {

                case 1:     nDamType = IP_CONST_DAMAGETYPE_BLUDGEONING;    break;
                case 2:     nDamType = IP_CONST_DAMAGETYPE_PIERCING;    break;
                case 3:     nDamType = IP_CONST_DAMAGETYPE_SLASHING;    break;
            }

            itemproperty ipRes = ItemPropertyDamageResistance( nDamType, IP_CONST_DAMAGERESIST_5 );

            IPSafeAddItemProperty( oRing, ipRes );

            SetName( oRing, "Uncursed Ring of the Chieftain" );

            SetItemCursedFlag( oRing, FALSE );
        }
    }

}

