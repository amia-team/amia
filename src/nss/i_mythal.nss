/*  Mythal Crafting :: Conversation Initialize

    --------
    Verbatim
    --------
    Initializes the mythal crafting conversation

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    20050606  kfw       Initial Release.
    20080901  Terra     Epic clean up
    20111028  Selmak    Recompile for containers
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "x2_inc_itemprop"

#include "inc_td_mythal"
#include "inc_ds_porting"
#include "inc_recall_chg"
#include "inc_recall_stne"

void main( ){

    // Variables
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            object oMythal      = GetNearestObjectByTag( MYTHAL_FORGE, oPC );
            object oReagent     = GetItemActivated( );
            object oItem        = GetItemActivatedTarget( );

            //Recharge Enhanced Recall Stone
            if ( GetTag( oItem ) == "recall_enh" ){
                if (ChargesToAdd(oReagent) == 100){
                    string recallCarry = GetLocalString(oItem, LVAR_RECALL_WP);
                    object divineStone = CreateItemOnObject("recall_div", oPC, 1);
                    string oldName     = GetName(oItem);
                    string divName     = GetSubString(oldName, 15, 50);

                    SetLocalString(divineStone, LVAR_RECALL_WP, recallCarry);
                    SetName(divineStone, "<cÿÓ'>Divine "+divName);
                    DestroyObject(oReagent);
                    DestroyObject(oItem);
                    FloatingTextStringOnCreature("Recall Stone upgraded to Divine!", oPC, FALSE);
                    return;
                }
                if(ChargesToAdd(oReagent) == 15){
                    if (GetLocalInt(oItem, "size") < 15){
                        string bioQty    = GetDescription(oItem, FALSE, TRUE);
                        string bioFirst  = GetSubString(bioQty, 0, 13);
                        string bioLast   = GetSubString(bioQty, 16, 500);
                        SetLocalInt(oItem, "size", 15);
                        SetItemCharges(oItem, 15);
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Recall Stone upgraded to hold 15 charges!", oPC, FALSE);
                        SetDescription(oItem, bioFirst+"15 "+bioLast);
                        return;
                    }
                    if (CanAddCharges(oReagent, oItem) == TRUE){
                        SafeAddCharges(oItem, oReagent, ChargesToAdd(oReagent));
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Added 15 Charges!", oPC, FALSE);
                        return;
                    }
                    else{
                        FloatingTextStringOnCreature("This mythal is too powerful. Use a smaller mythal reagent or upgrade your recall stone first.", oPC, FALSE);
                        return;
                    }
                }
                if(ChargesToAdd(oReagent) == 20){
                    if (GetLocalInt(oItem, "size") < 20){
                        string bioQty    = GetDescription(oItem, FALSE, TRUE);
                        string bioFirst  = GetSubString(bioQty, 0, 13);
                        string bioLast   = GetSubString(bioQty, 16, 500);
                        SetLocalInt(oItem, "size", 20);
                        SetItemCharges(oItem, 20);
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Recall Stone upgraded to hold 20 charges!", oPC, FALSE);
                        SetDescription(oItem, bioFirst+"20 "+bioLast);
                        return;
                    }
                    if (CanAddCharges(oReagent, oItem) == TRUE){
                        SafeAddCharges(oItem, oReagent, ChargesToAdd(oReagent));
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Added 20 Charges!", oPC, FALSE);
                        return;
                    }
                    else{
                        FloatingTextStringOnCreature("This mythal is too powerful. Use a smaller mythal reagent or upgrade your recall stone first.", oPC, FALSE);
                        return;
                    }
                }
                else{
                    if (CanAddCharges(oReagent, oItem) == TRUE){
                        int chargeAdd = ChargesToAdd(oReagent);
                        SafeAddCharges(oItem, oReagent, ChargesToAdd(oReagent));
                        DestroyObject(oReagent);
                        FloatingTextStringOnCreature("Added "+IntToString(chargeAdd)+" Charge(s)!", oPC, FALSE);
                        return;
                    }
                    else{
                        FloatingTextStringOnCreature("This mythal is too powerful. Use a smaller mythal reagent or upgrade your recall stone first.", oPC, FALSE);
                        return;
                    }
                }
            }
            if ( GetTag( oItem ) == "recall_div" ){
                FloatingTextStringOnCreature("You do not need to recharge a Divine Recall Stone!", oPC, FALSE);
                return;
            }

            // Strip temporary item effects
            if( GetObjectType( oItem ) == OBJECT_TYPE_ITEM )
            {
            itemproperty IP = GetFirstItemProperty( oItem );

                while( GetIsItemPropertyValid( IP ) )
                {
                    if( GetItemPropertyDurationType( IP ) == DURATION_TYPE_TEMPORARY ){
                    RemoveItemProperty( oItem , IP );
                    }
                IP = GetNextItemProperty( oItem );
                }

            SendMessageToPC( oPC, "<cÌ&Ì>- The mythal seems to strip your item of its temporary enchantments-</c>" );
            }

            // Player must be within 5 feet of a mythal forge (and the forget itself must exist).
            if( !GetIsObjectValid( oMythal ) || GetDistanceBetween( oPC, oMythal ) > 5.0 ){

                // Notify the player.
                SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Crafting - <cþ  >Error</c> - <cþþþ>You aren't near a Mythal Forge to craft.</c> -" );

                // Candy.
                AssignCommand( oPC, PlaySound( "sff_spellfail" ) );

                break;

            }

            // Player must own the item they want to craft.
            if( GetItemPossessor( oItem ) != oPC ){

                // Notify the player.
                SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Forge - <cþ  >Error</c> - <cþþþ>You cannot craft items that you don't own.</c> -" );

                // Candy.
                AssignCommand( oPC, PlaySound( "sff_spellfail" ) );

                break;

            }

            // Plot or Stolen Items aren't permitted. Checks separate variable to block mythals.
            if( GetPlotFlag( oItem ) || ( GetLocalInt( oItem, "mythalblock" ) == 1 )) {

                // Notify the player.
                SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Forge - <cþ  >Error</c> - <cþþþ>Item is too powerful to be crafted.</c> -" );

                break;

            }

            /* Store variables on player object. */
            /* Setup temporary custom tokens for strings in Conversation. */
            /* Initialize conversation. */
            SetMythalChecks( oPC , oItem , oReagent , oMythal , "mythal" );




            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
