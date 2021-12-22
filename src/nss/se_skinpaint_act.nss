//-----------------------------------------------------------------------------
// Header
//-----------------------------------------------------------------------------
// script:  se_skinpaint_act
// group:   Items
// used as: action script
// date:    19 October 2011
// author:  Selmak
// Notes:   Action script for paint pots and paint dispenser.
//          Item requested by GreatPigeon.

//-----------------------------------------------------------------------------
// Changelog
//-----------------------------------------------------------------------------
// 07/19/2012 - Glim - Added color change of Leather 1 to Helmet currently on,
//                     along with the Leather 1 colors to use under Constants.

#include "x2_inc_itemprop"

//-----------------------------------------------------------------------------
//Constants
//-----------------------------------------------------------------------------

const int SKIN_COLOR_ROUGE = 103;//This is the default colour, do not touch! :P
const int PAINT_GP_COST    = 30; //Set this to zero for free paint dispensing
const int PAINT_USES       = 10; //Set this to -1 for unlimited paint
const int HELM_COLOR_ROUGE = 103;//This is the default colour, shouldn't change much.
const int HELM_COLOR_SKIN  = 2;  //This is the starting colour, do not touch! :P


//-----------------------------------------------------------------------------
//Prototypes
//-----------------------------------------------------------------------------

//Paints oPC's skin if there is paint available in oPaint if bToggle is set, or
//removes paint from oPC if bToggle is not set.
void TogglePaint( object oPaint, int bToggle );

//Create a new paint pot on oTarget.  If nGoldCost is not zero, a charge will
//be incurred to oPC on creation.
void CreatePaintPot( object oPC, object oTarget, object oDispenser, int nGoldCost );

//Modify the item's paint colour.  This works with both the dispenser and paint
//pots, but can only be set by DM.
void ModPaintColor( object oPaintItem, int nModifier );


//-----------------------------------------------------------------------------
//Main
//-----------------------------------------------------------------------------

void main(){

    object oPC, oPaintItem, oTarget;

    int nAction;
    oPC = GetLastSpeaker();

    //Check to see if there is a valid speaker
    if ( GetIsObjectValid( oPC ) ){

        //Get selected conversation action.
        nAction     = GetLocalInt( oPC, "ds_node" );

        //Get the item which was used to start the conversation
        oPaintItem  = GetLocalObject( oPC, "paint_item" );

        //Get the object which was targeted
        oTarget     = GetLocalObject( oPC, "dispense_target" );

        DeleteLocalInt( oPC, "ds_node" );
        DeleteLocalObject( oPC, "dispense_target" );

        switch(nAction){

            case 1:     TogglePaint( oPaintItem, 1 );       break;
            case 2:     TogglePaint( oPaintItem, 0 );       break;
            case 3: if ( GetGold( oPC ) > PAINT_GP_COST ){

                        CreatePaintPot( oPC, oTarget, oPaintItem, PAINT_GP_COST );

                    }
                    else{

                        SendMessageToPC( oPC, "Not enough gold to make a paint pot." );

                    }
                    break;

            //Allows DM to change the colour in steps of 1, 5, or 50.
            case 4:     ModPaintColor( oPaintItem, 1 ) ;    break;
            case 5:     ModPaintColor( oPaintItem, -1 );    break;
            case 6:     ModPaintColor( oPaintItem, 5 );     break;
            case 7:     ModPaintColor( oPaintItem, -5 );    break;
            case 8:     ModPaintColor( oPaintItem, 50 );    break;
            case 9:     ModPaintColor( oPaintItem, -50 );   break;
            //Cleanup
            case 40:    DeleteLocalString( oPC, "ds_action" );
                        DeleteLocalObject( oPC, "paint_item" );
                                                            break;

            default:                                        break;
        }

        //Debug
        //SendMessageToPC( oPC, "Debug: Picked node " +IntToString( nAction ) );

    }

}

//-----------------------------------------------------------------------------
//Functions
//-----------------------------------------------------------------------------

void TogglePaint( object oPaint, int bToggle ){

    object oPC = GetItemPossessor( oPaint );

    object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);

    int nOrigColor;

    int nNewColor;

    int nUsesLeft = GetLocalInt( oPaint, "paint_uses" );

    //If we are toggling paint OFF
    if ( !bToggle ){

        //Get and clean variables for skin colour
        nOrigColor = GetLocalInt( oPaint, "stored_skin" );
        DeleteLocalInt( oPaint, "paint_applied" );
        DeleteLocalInt( oPaint, "stored_skin" );
        //Restore original skin colour
        SetColor( oPC, COLOR_CHANNEL_SKIN, nOrigColor );

        //If helm equipped, make sure it changes color too, even if it's already right! (just in case)
        if (oHelm != OBJECT_INVALID)
        {
            string sHelm = GetTag(oHelm);
            IPDyeArmor(oHelm, ITEM_APPR_ARMOR_COLOR_LEATHER1, HELM_COLOR_SKIN);
            object oReEquip = GetItemPossessedBy(oPC, sHelm);
            DelayCommand(1.0, ActionEquipItem(oReEquip, INVENTORY_SLOT_HEAD));
        }

    }
    //otherwise we're toggling paint ON
    else{

        if ( nUsesLeft != 0 ){

            //Store current skin colour
            nOrigColor = GetColor( oPC, COLOR_CHANNEL_SKIN );
            SetLocalInt( oPaint, "paint_applied", 1 );
            SetLocalInt( oPaint, "stored_skin", nOrigColor );
            //Check to see if a custom paint colour has been set
            nNewColor = GetLocalInt( oPaint, "paint_color" );
            //If not, default to rouge.
            if ( nNewColor == - 1 ) nNewColor = SKIN_COLOR_ROUGE;
            //Set new skin colour
            SetColor( oPC, COLOR_CHANNEL_SKIN, nNewColor );

            //If helm equipped, make sure it changes color too, even if it's already right! (just in case)
            if (oHelm != OBJECT_INVALID)
            {
                string sHelm = GetTag(oHelm);
                IPDyeArmor(oHelm, ITEM_APPR_ARMOR_COLOR_LEATHER1, HELM_COLOR_ROUGE);
                object oReEquip = GetItemPossessedBy(oPC, sHelm);
                DelayCommand(1.0, ActionEquipItem(oReEquip, INVENTORY_SLOT_HEAD));
            }
        }

        if ( nUsesLeft > 0 ){
        //Decrease number of uses
        nUsesLeft--;
        SetLocalInt( oPaint, "paint_uses", nUsesLeft );
        //Tell the PC how much paint they have left
        SendMessageToPC( oPC, "Your paint pot has "+ IntToString( nUsesLeft )
                            + " uses remaining." );


        }
        else if ( nUsesLeft == - 1 ){

            //Tell the PC how much paint they have left
            SendMessageToPC( oPC, "Your paint pot has limitless uses." );

        }

        else{

            //Dispose of the empty pot
            DestroyObject(oPaint, 0.0);
            SendMessageToPC( oPC, "Your paint pot was empty and has been removed for you." );

        }

    }

}

void CreatePaintPot( object oPC, object oTarget, object oDispenser, int nGoldCost ){

    if ( !GetIsObjectValid( oTarget ) ) return;
    if ( !GetIsPC( oTarget ) ) return;

    object oPaint = CreateItemOnObject( "imsc_paint", oTarget );
    int nPaintColor = GetLocalInt( oDispenser, "paint_color" );

    //It is possible to create paint pots with a different colour to the
    //default if the DM sets it.
    if ( nPaintColor > 0 ){

        //Inherits dispenser's paint colour.
        SetLocalInt( oPaint, "paint_color", nPaintColor );

    }
    else{
        //Default colour.
        SetLocalInt( oPaint, "paint_color", -1 );

    }

    //Each paint pot can start with a limited number of uses, or unlimited.
    //Uses are determined by the defined constant.
    SetLocalInt( oPaint, "paint_uses", PAINT_USES );

    //
    if ( nGoldCost > 0 ){

        TakeGoldFromCreature( nGoldCost, oPC, TRUE );

    }


}

void ModPaintColor( object oPaintItem, int nModifier ){

    int nColor = GetLocalInt( oPaintItem, "paint_color" );
    object oPC = GetItemPossessor( oPaintItem );
    nColor += nModifier;
    //Wrap around if value is now out of bounds
    if ( nColor < 0 ) nColor += 175;
    if ( nColor > 175 ) nColor -= 175;

    SetLocalInt( oPaintItem, "paint_color", nColor );

    SendMessageToPC( oPC, "Colour is now set to " + IntToString( nColor ) );

}

