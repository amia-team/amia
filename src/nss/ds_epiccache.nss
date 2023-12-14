//Kamina: This script is salvaged from the ds_secret_trans script but
//specifically outlines the actions of the epic dungeon cache.
//
//
//
//
//also works for setting buried treasure
//msheeler  9/14/2015 - added support for inventory items to bypass the search check
//                      also removed OOC feedback from failed checks
// Edit: Mav - 12/4/2023 - Fix an error when sBypassItem is set to ""
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"



void main(){

    object oPC          = GetEnteringObject();
    object oPLC;
    string sTarget      = GetLocalString( OBJECT_SELF, "target" );
    string sSpawnpoint  = GetLocalString( OBJECT_SELF, "spawnpoint" );
    string sResref      = GetLocalString( OBJECT_SELF, "resref" );
    string sDestination = GetLocalString( OBJECT_SELF, "destination_rr" );
    string sBypassItem  = GetLocalString( OBJECT_SELF, "bypass_item_tag" );
    int nDestType       = GetLocalInt( OBJECT_SELF, "destination_type" );
    int nDC             = GetLocalInt( OBJECT_SELF, "DC" );
    int nBlockTime      = GetLocalInt( OBJECT_SELF, "BlockTime" );

    if ( GetIsBlocked( ) > 0 ){

        return;
    }

    SetBlockTime( OBJECT_SELF, nBlockTime, 30 );

    if ( GetObjectType( GetNearestObjectByTag( sTarget ) ) == OBJECT_TYPE_PLACEABLE ){

        return;
    }

    SendMessageToPC( oPC, "You feel like you should Search this area." );
    int checkedItem = 0;

    if(sBypassItem!="")
    {
     if ( GetItemPossessedBy ( oPC, sBypassItem ) != OBJECT_INVALID ) {
        checkedItem = 1;
        // SendMessageToPC( oPC, "You have the bypass item" );
     }
    }

    if ( checkedItem == 0 ) {

        //SendMessageToPC( oPC, "You need to search!" );
        if ( GetIsPC( oPC ) && GetDetectMode( oPC ) == DETECT_MODE_ACTIVE ) {

            // Use a standard D&D style skill check
            if ( GetIsSkillSuccessfulPrivate( oPC, SKILL_SEARCH, nDC ) ){

               // Search successful
               oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResref, GetLocation( GetWaypointByTag( sSpawnpoint ) ), FALSE, sTarget );
               SetLocalString(oPLC, "destination_rr", sDestination);
               SetLocalInt(oPLC, "destination_type", nDestType);

               effect eHint = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );

               ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eHint, GetLocation( oPLC ), 20.0 );

               DestroyObject( oPLC, 300.0 );
            }
            else{

               if ( nBlockTime ){

                   // SendMessageToPC( oPC, "You find nothing. You can try again in "+IntToString( nBlockTime )+" minutes and 30 seconds." );
               }
               else{

                   // SendMessageToPC( oPC, "You find nothing. You can try again in 30 seconds." );
               }
            }
        }
    }
    else {
            // Has item to bypass search
            SendMessageToPC( oPC, "You have the bypass item, so I am going to make you a door!" );
            oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResref, GetLocation( GetWaypointByTag( sSpawnpoint ) ), FALSE, sTarget );
            SetLocalString(oPLC, "destination_rr", sDestination);
            SetLocalInt(oPLC, "destination_type", nDestType);

            effect eHint = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );

            ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eHint, GetLocation( oPLC ), 20.0 );

            DestroyObject( oPLC, 300.0 );

            SetBlockTime( OBJECT_SELF, 0, 21 );

       }
    }
