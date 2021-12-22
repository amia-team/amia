//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_trans_pages
//group:   transmutation
//used as: item activation script
//date:    apr 03 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void AddPage( object oPC, object oItem, object oTarget, int nSpell );

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
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);

            if ( GetTag( oTarget ) != "ds_trans_open" ){

                //wrong target
                SendMessageToPC( oPC, "You must use this item on the Book of Transmutation!" );
                return;
            }

            if ( sItemName == "Page: Flame Weapon" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_FLAME_WEAPON );
            }

            if ( sItemName == "Page: Melf's Acid Arrow" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_MELFS_ACID_ARROW );
            }

            if ( sItemName == "Page: Cone of Cold" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_CONE_OF_COLD );
            }

            if ( sItemName == "Page: Bless Weapon" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_BLESS_WEAPON );
            }

            if ( sItemName == "Page: Knock" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_KNOCK );
            }

            if ( sItemName == "Page: Fireball" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_FIREBALL );
            }

            if ( sItemName == "Page: Darkfire" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_DARKFIRE );
            }

            if ( sItemName == "Page: Ice Storm" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_ICE_STORM );
            }

            if ( sItemName == "Page: Call Lightning" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_CALL_LIGHTNING );
            }
            if ( sItemName == "Page: Greater Ruin" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_EPIC_RUIN );
            }

            if ( sItemName == "Page: Dirge" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_DIRGE );
            }

            if ( sItemName == "Page: Mestil's Acid Sheath" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_MESTILS_ACID_SHEATH );
            }

            if ( sItemName == "Page: Continual Light" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_CONTINUAL_FLAME );
            }

            if ( sItemName == "Page: Greater Magic Weapon" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_GREATER_MAGIC_WEAPON );
            }
            if ( sItemName == "Page: Greater Sanctuary" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_ETHEREALNESS );
            }

            if ( sItemName == "Page: Great Thunderclap" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_GREAT_THUNDERCLAP );
            }

            if ( sItemName == "Page: Circle Against Alignment" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_MAGIC_CIRCLE_AGAINST_GOOD );
            }

            if ( sItemName == "Page: Weird" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_WEIRD );
            }

            if ( sItemName == "Page: Light" ){

                //activate spell on book
                AddPage( oPC, oItem, oTarget, SPELL_LIGHT );
            }

            if( sItemName == "Page: Ability" ){

                AddPage( oPC, oItem, oTarget, SPELL_BULLS_STRENGTH );
            }
        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void AddPage( object oPC, object oItem, object oTarget, int nSpell ){

    string sSpell   = IntToString( nSpell );

    //activate spell on book
    SetLocalInt( oTarget, "ds_spell_"+sSpell, 1 );

    //destroy page
    DestroyObject( oItem, 0.5 );

    //feedback
    SendMessageToPC( oPC, "Page added to the Book of Transmutation!" );
}

