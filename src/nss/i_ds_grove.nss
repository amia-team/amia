//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_grove
//group:   grove/bark scripts
//used as: OnActivation script
//date:    aug 11 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "nw_i0_generic"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//creates portal to the Duir
void grove_portal( object oPC, location lTarget );

//creates quasi random location around Duir
location grove_exitpoint( object oPC );

//shows PCs with Duir insignias
void grove_memberlist( object oPC );

//calls PCs with Duir insignias
void grove_pager( object oPC );

//show people in the grove if the item is used in the grove
void grove_inhabitants(  object oPC, location lTarget );

//take Duir insignias and expell
void grove_excommunicate( object oTarget );

//give Duir insignias
void grove_inaugerate( object oTarget );

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
            location lTarget = GetItemActivatedTargetLocation();

            if ( sItemName == "Duir Insignia Wand" ){

                if ( oTarget == oPC ){

                    //clicked on self
                    grove_memberlist( oPC );

                }
                else if ( GetIsPC( oTarget ) ){

                    //clicked on other PC
                    if ( GetItemPossessedBy( oTarget, "ds_grove" ) != OBJECT_INVALID ){

                        grove_excommunicate( oTarget );
                    }
                    else{

                        grove_inaugerate( oTarget );
                    }
                }
                else if ( GetName( oTarget ) == "The Great Duir Tree" ){

                    //clicked on Duir
                    grove_pager( oPC );
                }
                else{

                    //clicked on ground
                    grove_inhabitants( oPC, lTarget );
                }
            }
            else if ( sItemName == "Duir Insignia" && GetLocalInt( GetModule(), "Module" ) != 2 ){

                SendMessageToPC( oPC, "You can only use this item on Amia island!" );
            }
            else if ( sItemName == "Duir Insignia" && oTarget == OBJECT_INVALID ){

                string sTileSet = GetTilesetResRef( GetArea( oPC ) );

                if ( sTileSet == TILESET_RESREF_FOREST ||
                     sTileSet == TILESET_RESREF_RURAL ||
                     sTileSet == TILESET_RESREF_RURAL_WINTER ||
                     sTileSet == "tcr10" || // City/Rural base set
                     sTileSet == "twl01" || // Rural Wildlands
                     sTileSet == "ttw01" ) { // Wild Woods

                    grove_portal( oPC, lTarget );
                }
                else{

                    SendMessageToPC( oPC, "You can only use this item in rural or forest areas!" );
                }
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void grove_portal( object oPC, location lTarget ){

    location lExitPoint = grove_exitpoint( oPC );

    object oEntryPortal = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_grove_portal", lTarget );
    object oExitPortal  = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_grove_portal", lExitPoint );

    DelayCommand( 0.1, SetLocalLocation( oEntryPortal, "ds_destination", lExitPoint ) );
    DelayCommand( 0.1, SetLocalLocation( oExitPortal, "ds_destination", lTarget ) );

    effect eVis         = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR  );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oEntryPortal, 20.0 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oExitPortal, 20.0 );

    DestroyObject( oEntryPortal, 11.0 );
    DestroyObject( oExitPortal, 11.0 );

}

location grove_exitpoint( object oPC ){

    object oExitPoint   = GetObjectByTag( "ds_root_exit" );

    location lExitPoint = GetLocation( oExitPoint );

    float fAngle        = IntToFloat( Random( 360 ) );
    float fDistance     = IntToFloat( Random( 0 ) + 5 );
    float fFacing       = GetFacing( oPC );

    return GenerateNewLocationFromLocation( lExitPoint, fDistance, fAngle, fFacing );
}

void grove_memberlist( object oPC ){

    object oPlayer  = GetFirstPC();

    SendMessageToPC( oPC, "The following people have Duir insignia:");

    while ( GetIsObjectValid( oPlayer ) ) {

        object oBark = GetLocalObject( oPlayer, "ds_bark" );

        if ( GetIsObjectValid( oBark ) ) {

            SendMessageToPC( oPC, " * " + GetName( oPlayer ) );
        }

        oPlayer = GetNextPC();
    }
}

void grove_pager( object oPC ){

    object oPlayer  = GetFirstPC();

    SendMessageToPC( oPC, "The following people have received a call:");

    while ( GetIsObjectValid( oPlayer ) ) {

        object oBark = GetLocalObject( oPlayer, "ds_bark" );

        if ( GetIsObjectValid( oBark ) ) {

            SendMessageToPC( oPlayer, "Your Duir Bark vibrates" );
            SendMessageToPC( oPC, " * " + GetName( oPlayer ) );
        }

        oPlayer = GetNextPC();
    }
}

void grove_inhabitants(  object oPC, location lTarget ){

    object oPlayer = GetFirstPC();
    string sArea   = GetTag( GetAreaFromLocation( lTarget ) );

    if ( sArea != "ds_grove" ){

        SendMessageToPC( oPC, "The Duir's powers don't reach that far.");
        return;
    }

    SendMessageToPC( oPC, "The following people are in the grove:");

    while ( GetIsObjectValid( oPlayer ) ) {

        sArea = GetTag( GetArea( oPlayer ) );

        if ( sArea == "ds_grove" ) {

            SendMessageToPC( oPC, " * "+GetName(oPlayer) );
        }

        oPlayer = GetNextPC();
    }
}

void grove_excommunicate( object oTarget ){

    object oObj         = GetFirstItemInInventory( oTarget );
    object oWaypoint    = GetWaypointByTag( "ds_excommunicate" );
    int nResult         = 0;

    while ( oObj != OBJECT_INVALID ) {

        if ( GetTag( oObj ) == "ds_grove" ){

            nResult = 1;

            DestroyObject( oObj );
        }

        oObj = GetNextItemInInventory( oTarget );
    }

    if ( nResult == 1 ){

        FloatingTextStringOnCreature( "You are no longer a member of the Circle of Balance.", oTarget, TRUE );
    }

    if ( GetTag( GetArea( oTarget ) ) == "ds_grove" ){

        AssignCommand( oTarget, JumpToObject( oWaypoint, 0 ) );
    }
}

void grove_inaugerate( object oTarget ){

    CreateItemOnObject( "ds_duir_insignia", oTarget );

    FloatingTextStringOnCreature( "You are now a member of the Circle of Balance.", oTarget, TRUE );
}
