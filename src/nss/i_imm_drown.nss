// Any item with the tag: "imm_drown" will gain spell immunity: Drown while this item is equipped

// includes
#include "x2_inc_switches"
#include "inc_ds_records"


void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_EQUIP:{

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );

            // vars
            object oPC=GetPCItemLastEquippedBy();

            // Spell Immunity: Drown enabled
            SetLocalInt(
                oPC,
                "cs_immunity_drown",
                1);

            break;
        }

        case X2_ITEM_EVENT_UNEQUIP:{

            // vars
            object oPC=GetPCItemLastUnequippedBy();

            // Spell Immunity: Drown disabled
            SetLocalInt(
                oPC,
                "cs_immunity_drown",
                0);

            break;

        }

        default:{

            break;

        }

    }

    SetExecutedScriptReturnValue(nResult);

}
