//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_open
//group:   transmutation
//used as: item activation script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void SetAvailableSpells( object oPC, object oItem );
void SetSpell( object oPC, object oItem, int nCheck, int nSpell );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();

            //open converstation
            AssignCommand( oPC, ActionStartConversation( oPC, "ds_transmutation", TRUE, FALSE ) );

            //do checks
            SetAvailableSpells(  oPC, oItem );

            //set action script
            SetLocalString( oPC, "ds_action", "ds_trans_actions" );
            DeleteLocalInt( oPC, "ds_spell" );
            DeleteLocalInt( oPC, "ds_node" );


        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void SetAvailableSpells( object oPC, object oItem ){

    //1 = flame weapon
    SetSpell( oPC, oItem, 1, SPELL_FLAME_WEAPON );

    //2 = Melf's Acid Arrow
    SetSpell( oPC, oItem, 2, SPELL_MELFS_ACID_ARROW );

    //3 = Cone of Cold
    SetSpell( oPC, oItem, 3, SPELL_CONE_OF_COLD );

    //4 = Bless Weapon
    SetSpell( oPC, oItem, 4, SPELL_BLESS_WEAPON );

    //5 = Knock
    SetSpell( oPC, oItem, 5, SPELL_KNOCK );

    //6 = Fireball
    SetSpell( oPC, oItem, 6, SPELL_FIREBALL );

    //7 = Darkfire
    SetSpell( oPC, oItem, 7, SPELL_DARKFIRE );

    //8 = Ice Storm
    SetSpell( oPC, oItem, 8, SPELL_ICE_STORM );

    //9 = Call Lightning
    SetSpell( oPC, oItem, 9, SPELL_CALL_LIGHTNING );

    //10 = Greater Ruin
    SetSpell( oPC, oItem, 10, SPELL_EPIC_RUIN );

    //11 = Dirge
    SetSpell( oPC, oItem, 11, SPELL_DIRGE );

    //12 = Acid Sheath
    SetSpell( oPC, oItem, 12, SPELL_MESTILS_ACID_SHEATH );

    //13 = Continual Light
    SetSpell( oPC, oItem, 13, SPELL_CONTINUAL_FLAME );

    //14 = Greater Magical Weapon
    SetSpell( oPC, oItem, 14, SPELL_GREATER_MAGIC_WEAPON );

    //15 = Greater sanctuary
    SetSpell( oPC, oItem, 15, SPELL_ETHEREALNESS );

    //16 = Great Thunderclap
    SetSpell( oPC, oItem, 16, SPELL_GREAT_THUNDERCLAP );

    //17 = Circle Against Alignment
    SetSpell( oPC, oItem, 17, SPELL_MAGIC_CIRCLE_AGAINST_GOOD );

    //18 = Weird
    SetSpell( oPC, oItem, 18, SPELL_WEIRD );

    //19 = Light
    SetSpell( oPC, oItem, 19, SPELL_LIGHT );

    //20 = Ability
    SetSpell( oPC, oItem, 20, SPELL_BULLS_STRENGTH );
}

void SetSpell( object oPC, object oItem, int nCheck, int nSpell ){

    string sCheck   = IntToString( nCheck );
    string sSpell   = IntToString( nSpell );

    if ( GetLocalInt( oItem, "ds_spell_"+sSpell ) > 0 ){

        SetLocalInt( oPC, "ds_check_"+sCheck, 1 );
    }

}
