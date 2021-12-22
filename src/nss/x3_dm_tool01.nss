//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  x3_dm_tool01
//group:   dm tools
//used as: DM Custom Feat 01 special ability
//date:    dec 4 2008
//author:  ron
//notes:   original script by disco (dec 20 2007). adapted to dm_tool use

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){


    // item activate variables
    object oPC       = OBJECT_SELF;
    object oTarget   = GetSpellTargetObject();
    object oItem;
    object oNPC;
    string sBio;
    int nSlot;
    int nGold;
    location lWP;


    if ( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        oItem = CopyItemFixed( oTarget, oPC, TRUE );

        sBio  = GetDescription( oTarget );

        SetDescription( oItem, sBio );
    }
    else if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

        if ( GetSkillRank( SKILL_TUMBLE , oTarget , FALSE ) == 127 ){

            //feedback
            SendMessageToPC ( oPC , "You cannot use the CopyCat on DM Avatars!" );

            return;
        }

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
    }
    else{

        //feedback
        SendMessageToPC( oPC, "You can only use this on creatures and items!" );
    }
}
