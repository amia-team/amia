 /*  i_ds_campingtool

--------
Verbatim
--------
manages the camping tool placeable widgets

---------
Changelog
---------

Date    Name        Reason
------------------------------------------------------------------
062206  Disco       Start of header
062306  Disco       Bugfix
101106  Disco       Added chairs and tables
121306  Disco       Some changes
12/25/13 Glim       Facing setup for sittable objects

------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_td_rest"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void SpawnItem( object oPC, string sResRef, string sTagPrefix, location lTarget, int nFlagIt=FALSE );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){
        case X2_ITEM_EVENT_ACTIVATE:

            //variables from event
            object oPC        = GetItemActivator();
            object oItem      = GetItemActivated();
            object oTarget    = GetItemActivatedTarget();
            string sItemName  = GetName(oItem);
            location lTarget  = GetItemActivatedTargetLocation();


            if ( GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ){

                SendMessageToPC( oPC, "You cannot pile those on top of each other, my friend." );
                return;
            }

            if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

                SendMessageToPC( oPC, "BEHAVE!" );
                return;
            }

            //check for spawntriggers
            if ( GetNearestObjectByTag( "ds_plc_blocker", oPC ) != OBJECT_INVALID ){

                SendMessageToPC( oPC, "This is not a picnic area, my friend." );
                log_exploit(  oPC, GetArea( oPC), "PLC spawn in hunting area" );
                return;
            }

            if ( sItemName == "Camper's Paradise Cushions" ){

                SpawnItem( oPC, "chairuse002", "cp3_", lTarget, TRUE );
                return;
            }
            else if ( sItemName == "Camper's Paradise Bedroll" ){

                SpawnItem( oPC, "plc_bedrolls", "cp7_", lTarget, TRUE );
                return;
            }
            else if ( sItemName == "Camper's Paradise Tip-up Stool" ){

                SpawnItem( oPC, "tha_stool", "cp8_", lTarget, TRUE );
                return;
            }
            else if ( sItemName == "Camper's Paradise Cot" ){

                SpawnItem( oPC, "plc_cot", "cp19_", lTarget, TRUE );
                return;
            }
            else if ( sItemName == "Camper's Paradise Map" ){

                SpawnItem( oPC, "x0_maps", "cp20_", lTarget, TRUE );
                return;
            }
            else if ( sItemName == "Arena Rules" ){

                SpawnItem( oPC, "ds_arena_rules", "cp9_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Spider Chair" ){

                SpawnItem( oPC, "chairuse004", "cp10_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Chair" ){

                SpawnItem( oPC, "tha_chair", "cp11_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Bench" ){

                SpawnItem( oPC, "bench001", "cp12_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Table" ){

                SpawnItem( oPC, "plc_table", "cp13_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Bed" ){

                SpawnItem( oPC, "plc_bed", "cp14_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Plant" ){

                SpawnItem( oPC, "plc_pottedplant", "cp15_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Mirror" ){

                SpawnItem( oPC, "x2_plc_mirror", "cp16_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Large Rug" ){

                SpawnItem( oPC, "x0_ruglarge", "cp17_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Small Rug" ){

                SpawnItem( oPC, "plc_throwrug", "cp18_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Round Khemian Carpet" ){

                SpawnItem( oPC, "x0_roundrugorien", "cp19_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Normal Khemian Carpet" ){

                SpawnItem( oPC, "glm_normkhemcarp", "cp20_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Large Khemian Carpet" ){

                SpawnItem( oPC, "x0_rugoriental", "cp21_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Bear Skin Rug" ){

                SpawnItem( oPC, "x0_bearskinrug1", "cp22_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Candle" ){

                SpawnItem( oPC, "ds_plc_candle", "cp23_", lTarget );
                return;
            }
            else if ( sItemName == "Furniture: Candelabra" ){

                SpawnItem( oPC, "ds_plc_candelabr", "cp24_", lTarget );
                return;
            }

            // no tents or fireplaces inside a house
            if ( GetIsAreaInterior( GetArea( oPC ) ) && GetIsAreaNatural( GetArea( oPC ) ) == AREA_ARTIFICIAL ){

                SendMessageToPC( oPC, "Do you try that at home, as well?" );
                return;
            }

            if      ( sItemName == "Camper's Paradise Red Tent" ){

                SpawnItem( oPC, "x2_plc_tent_r", "cp1_", lTarget, TRUE );
            }
            else if ( sItemName == "Camper's Paradise Purple Tent" ){

                SpawnItem( oPC, "x2_plc_tent_b", "cp2_", lTarget, TRUE );
            }
            else if ( sItemName == "Camper's Paradise Firetop" ){

                SpawnItem( oPC, "plc_campfr", "cp4_", lTarget, TRUE );
            }
            else if ( sItemName == "Camper's Paradise Fishsoup Kit" ){

                SpawnItem( oPC, "plc_campfrwpot", "cp5_", lTarget, TRUE );
            }
            else if ( sItemName == "Camper's Paradise Roastbeef Kit" ){

                SpawnItem( oPC, "plc_campfrwspit", "cp6_", lTarget, TRUE );
            }




        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}



//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------

//spawns/removes an item with a tag based on the PCs name and an item prefix
void SpawnItem(object oPC, string sResRef, string sTagPrefix, location lTarget, int nFlagIt=FALSE ){

    //create a tage for each object that consists of the PC name and the item
    string sTag       = sTagPrefix + GetPCPublicCDKey( oPC);
    object oPlaceable = GetObjectByTag(sTag);

    if( oPlaceable == OBJECT_INVALID ){

        object oNearestPC   = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
        location lNearestPC = GetLocation( oNearestPC );
        location lPC        = GetLocation( oPC );

        //if a PC tries to place the item at his own feet
        if ( GetDistanceBetweenLocations( lTarget, lPC ) < 1.5 ){

            SendMessageToPC( oPC, "You should not place this item on your own feet, my friend." );
        }
        //if a PC tries to place the item at another PC's feet
        else if ( GetDistanceBetweenLocations( lTarget, lNearestPC ) < 1.5 && oNearestPC != OBJECT_INVALID){

            SendMessageToPC( oPC, "You should not place this item on another person's feet, my friend." );
        }
        //create object
        else{

            object oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lTarget, FALSE, sTag );
            SetName( oPLC, GetName( oPC )+"'s "+GetName( oPLC ) );
            SetPlotFlag( oPLC, FALSE );

            if ( nFlagIt ){

                SetLocalInt( oPLC, PLC_VAR_NAME, 1 );
            }

            //If it's a sittable object, rotate 180 degress for easier placement
            if ( sResRef == "chairuse002" ||
                 sResRef == "tha_stool"   ||
                 sResRef == "chairuse004" ||
                 sResRef == "tha_chair"   ||
                 sResRef == "bench001" )
            {
                float fFace = GetFacing( oPC );
                SetFacing( fFace );
            }

            if ( sTagPrefix != "cp17_" &&
                 sTagPrefix != "cp18_" &&
                 sTagPrefix != "cp19_" &&
                 sTagPrefix != "cp20_" &&
                 sTagPrefix != "cp21_" ){

                SetUseableFlag( oPLC, TRUE );
            }
        }
    }
    else{

        //no removal if somebody uses the chair/cushion
        if( GetIsPC( GetSittingCreature( oPlaceable ) ) ){

            SendMessageToPC( oPC, "You cannot remove your "+GetName(oPlaceable)+". Somebody is sitting on it.");
        }
        //remove object
        else{

            SendMessageToPC( oPC,"You removed your "+GetName(oPlaceable)+".");
            DestroyObject(oPlaceable);
        }
    }
}


