//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  I_ds_copy
//group:   dm tools
//used as: activation script
//date:    dec 20 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"
#include "inc_nwnx_events"
//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            // item activate variables
            object oPC       = InstantGetItemActivator();
            object oTarget   = InstantGetItemActivatedTarget();
            object oItem;
            object oNPC;
            int nSlot;
            int nGold;
            location lWP;

            if ( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

                CopyItemFixed( oTarget, oPC, TRUE );
            }
            else if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

                //get spawn location
                lWP = GetLocation( GetWaypointByTag( "ds_copy" ) );

                //create creature
                oNPC  = CopyObjectFixed( oTarget, lWP );

                //set to non-hostile
                ChangeToStandardFaction( oNPC, STANDARD_FACTION_COMMONER );

                //feedback
                SendMessageToPC( oPC, "Created " + GetName( oNPC ) + " in " + GetName( GetArea( oNPC ) ) );

                //copy vars
                SetLocalString( oNPC, "MyStore", GetLocalString( oTarget, "MyStore" ) );

                //strip NPC made from a PC
                if ( GetIsPC( oTarget ) ){

                    object oItem = GetFirstItemInInventory( oNPC );

                    while ( GetIsObjectValid( oItem ) == TRUE ){

                        DestroyObject( oItem, 2.0 );

                        oItem = GetNextItemInInventory( oNPC );
                    }
                }

                //make equiped stuff undroppable
                for ( nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++ ){

                    oItem = GetItemInSlot( nSlot, oNPC );

                    //unequip if valid
                    if ( GetIsObjectValid( oItem ) ){

                        SetDroppableFlag( oItem, FALSE );
                    }
                }

                //strip gold
                nGold = GetGold( oNPC );

                AssignCommand( oPC, TakeGoldFromCreature( nGold, oNPC, TRUE ) );

                DelayCommand( 1.0, SendMessageToPC( oPC, GetName( oNPC ) + " has " + IntToString( GetGold( oNPC ) ) + " gold!" ) );
            }
            else{

                //feedback
                SendMessageToPC( oPC, "You can only use this on creatures and items!" );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

