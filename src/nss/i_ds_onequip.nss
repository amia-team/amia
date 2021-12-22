
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC;
    object oItem;

    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
    int nSpell;

    string sVariable;

    switch ( nEvent ){

        case X2_ITEM_EVENT_EQUIP:

            oPC         = GetPCItemLastEquippedBy();        // The player who equipped the item
            oItem       = GetPCItemLastEquipped();         // The item that was equipped
            nSpell      = GetLocalInt( oItem, "Spell" );
            sVariable   = GetLocalString( oItem, "Variable" );

            if ( sVariable != "" ){

                SetLocalInt( oPC, sVariable, 1 );
            }

            if ( nSpell ){

                AssignCommand( oPC, ActionCastSpellAtObject( nSpell, oPC, 1, TRUE, 0, 1, TRUE ) );
            }

        break;


        case X2_ITEM_EVENT_UNEQUIP:

            oPC         = GetPCItemLastUnequippedBy();        // The player who equipped the item
            oItem       = GetPCItemLastUnequipped();         // The item that was equipped
            nSpell      = GetLocalInt( oItem, "Spell" );
            sVariable   = GetLocalString( oItem, "Variable" );

            if ( sVariable != "" ){

                DeleteLocalInt( oPC, sVariable );
            }


            if ( nSpell ){

                RemoveEffectsBySpell( oPC, nSpell );
            }

        break;
    }


    if (GetCurrentHitPoints(oPC) < -9)
    {
        if (GetIsPC(oPC))
        {
            ExecuteScript("mod_pla_death", oPC);
        }
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue( nResult );
}





