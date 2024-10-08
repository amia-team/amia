/////////////////////////////////////////////////////////////////////////////////////////////////
//This script is for heavy script based js properties/items/widgets                            //
//200 times same armor                                                                         //
//created by Frozen-ass                                                                        //
//date: 07-11-2022                                                                             //
//                                                                                             //
//Contains:                                                                                    //
//-armor appearance storace function                                                           //
//-Hair/tattoo dye/set kits + unlim                                                                                             //
//                                                                                             //
//edits:                                                                                       //
//16-april-2023 Frozen  added hair, tattoo and both kits                                       //                                                   //
/////////////////////////////////////////////////////////////////////////////////////////////////


#include "x2_inc_switches"
#include "nwnx_object"
#include "nwnx_item"
#include "inc_ds_actions"
//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
// armor appearance storace function
void tailor_look ( object oPC, object oItem, object oTarget );

// Get a Cached 2DA string.  If its not cached read it from the 2DA file and cache it.
string GetCachedACBonus(string sFile, int iRow);

// For ac Check to make sure some one cant change ac value of a item
int CompareAC(int sFirst, object oSecond);

// Launces the hair dye and tattoo conversations
void HairAndTattoo  ( object oPC, object oItem, string sResRef );

//-------------------------------------------------------------------------------
//main
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
            string sResRef   = GetResRef( oItem );

            if ( sResRef == "js_tailorkit" )    { tailor_look( oPC, oItem, oTarget ); }
            if ( sResRef == "js_hairdye_kit" )  { HairAndTattoo( oPC, oItem, sResRef ); }
            if ( sResRef == "js_tattoo_kit" )   { HairAndTattoo( oPC, oItem, sResRef ); }
            if ( sResRef == "hair_and_tattoo" ) { HairAndTattoo( oPC, oItem, sResRef ); }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void tailor_look ( object oPC, object oItem, object oTarget ) {

int iSet     = GetLocalInt( oItem, "tailor_set" );

// If widget is used on itself, flushes the set appearance
if ( oTarget == oItem ){
    DeleteLocalString( oItem, "armor_app" );
    SetLocalInt( oItem, "tailor_set", 1 );
    SetName( oItem, "");
    SendMessageToPC(oPC, "Tailor kit flushed");
    return;
   }

// fires off the appearance copy settings if item is an armor
if (GetBaseItemType( oTarget ) == BASE_ITEM_ARMOR){
    // if widget oItem is not set with an appearance
    if ( iSet <= 1 ){

        SetLocalInt( oItem, "armor_ac", GetItemAppearance( oTarget, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO) );
        SetLocalString( oItem, "armor_app", NWNX_Item_GetEntireItemAppearance( oTarget ) );
        SetName( oItem, "<c~��>Tailor Kit: </c><c �2>Set</c>");
        SetLocalInt( oItem, "tailor_set", 2 );
        SendMessageToPC(oPC, "Item Apearance copied to tailor kit");
        return;
        }

    // if widget oItem is set with an appearance
    if ( iSet == 2 ){

        int nAc    = GetLocalInt( oItem, "armor_ac" );

        // Informs the player if they use on a item with a difirent base ac type then the copied type
        if (!CompareAC( nAc, oTarget )) {
            SendMessageToPC(oPC, "You may only apply the appearance on armor with the same base AC values.");
            return;
        }

        // Loads the item apearance to the item, creates a copy and destroys original armor, this is needed to display change without reloading game
        else {
            string sArmorapp    = GetLocalString ( oItem, "armor_app" );

                NWNX_Item_RestoreItemAppearance( oTarget, sArmorapp );
                CopyItem (oTarget, oPC, TRUE);
                DestroyObject (oTarget, 0.0f);
                SendMessageToPC(oPC, "Item Apearance applied to "+GetName ( oTarget ));
                }
            }
        }
// if used on any thing but an armor will state it needs to be an armor
else {
    SendMessageToPC(oPC, "This can only be used on Armor");
    }
}

// This controlls base ac value comparison check (stolen from the tlr scripts)
int CompareAC(int sFirst, object oSecond) {
object oItem     = GetItemActivated();

    int iFirstApp = GetLocalInt ( oItem, "armor_ac" );
    int iSecondApp = GetItemAppearance(oSecond, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);

    string sFirstAC = GetCachedACBonus("parts_chest", iFirstApp);
    string sSecondAC = GetCachedACBonus("parts_chest", iSecondApp);

    return (StringToInt(sFirstAC) == StringToInt(sSecondAC));
}

string GetCachedACBonus(string sFile, int iRow) {
    string sACBonus = GetLocalString(GetModule(), sFile + IntToString(iRow));

    if (sACBonus == "") {
        sACBonus = Get2DAString(sFile, "ACBONUS", iRow);

        if (sACBonus == "") {
            sACBonus = "-1";

            string sCost = Get2DAString(sFile, "COSTMODIFIER", iRow);
            if (sCost == "" ) sACBonus = "-2";
        }

        SetLocalString(GetModule(), sFile + IntToString(iRow), sACBonus);
    }

    return sACBonus;
}
//-------------------------------------------------------------------------------
void HairAndTattoo ( object oPC, object oItem, string sResRef ){

            //int iPrice = 0;
            //SetCustomToken(7002, IntToString(0));
            clean_vars( oPC, 4 );

            int iOk = 1;
            {
            SetLocalInt( oPC, "ds_check_20", 1 );
            }

            //set action script
            SetLocalString( oPC, "ds_action", "td_action_styler" );
            SetLocalObject( oPC, "ds_item", oItem );

            string sFirstLine = "";

                // launches hair dye conversation
                if ( sResRef == "js_hairdye_kit" )
                {
                    SetLocalInt( oPC, "ds_check_1", iOk );
                        {
                        sFirstLine = "Greetings, would you fancy your hair dyed?";
                        }

                    SetCustomToken(7000, sFirstLine);
                }

                // launches tattoo conversation
                if ( sResRef == "js_tattoo_kit" )
                {
                SetLocalInt( oPC, "ds_check_2", iOk );
                {
                sFirstLine = "Greetings! Would you fancy to modify your tattoos!";
                }
                SetCustomToken(7000, sFirstLine);
                }

                // launches tattoo/hairdye conversation
                if ( sResRef == "hair_and_tattoo" )
                {
                SetLocalInt( oPC, "ds_check_3", iOk );
                SetLocalInt( oPC, "ds_check_4", iOk );
                {
                sFirstLine = "Greetings! I can remake your tattoos or dye your hair!";
                }
                SetCustomToken(7000, sFirstLine);
                }
    AssignCommand( oPC, ActionStartConversation( oPC, "td_styler", TRUE, FALSE ) );
}
