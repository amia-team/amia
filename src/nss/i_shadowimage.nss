/*  Item :: Shadow Image :: OnUse: Unique Power: Target [Self]: Clone

    --------
    Verbatim
    --------
    This script will create a clone of the wand user!

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082206  kfw         Initial release.
    082306  kfw         Inventory items drop bugfix.
    041107  kfw         Equipped items and gold bugfix.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "x2_inc_switches"
#include "amia_include"


/* Constants. */
const string VFX                = "cs_vfx";
const string IMAGE              = "cs_image";


/* Function prototypes. */

// Removes all the items and gold from the target's inventories.
void RemoveAllItemsAndGold( object oSource, object oTarget );


void main(){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch(nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oItem        = GetItemActivated( );
            object oPC          = GetItemActivator( );
            location lOrigin    = GetLocation( oPC );
            object oImage       = GetLocalObject( oItem, IMAGE );
            int nVFX            = GetLocalInt( oItem, VFX );



            // Image doesn't exist, create one.
            if( !GetIsObjectValid( oImage ) ){

                // Create.
                oImage = CopyObjectFixed( oPC, lOrigin );

                // Add the image to the user's party.
                AddHenchman( oPC, oImage );

                // Make the image follow you.
                AssignCommand( oImage, ActionForceFollowObject( oPC, 15.0 ) );

                // Make sure the follow command isn't interrupted.
                SetCommandable( FALSE, oImage );

                // Candy.
                DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), oImage ) );
                DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_GHOST_TRANSPARENT ), oImage ) );

                // Purge all items from the image's inventory so that they don't drop when it's 'killed.'
                DelayCommand( 3.0, RemoveAllItemsAndGold( oPC, oImage ) );

                // Store image object pointer on item for future reference.
                SetLocalObject( oItem, IMAGE, oImage );

                // Notify the player.
                FloatingTextStringOnCreature( "<cþþ>- You've created a shadow image of yourself, which will last 3 hours. -</c>", oPC, FALSE );

                // Despawn in 3 hours.
                DestroyObject( oImage, NewHoursToSeconds( 3 ) );

            }
            // Image exists already, destroy it.
            else{

                // Destroy.
                DestroyObject( oImage, 1.0 );

                // Candy.
                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), oImage );

                // Notify the player.
                FloatingTextStringOnCreature( "<cþþ>- You've dispelled your shadow image. -</c>", oPC, FALSE );

            }

            break;

        }

        default:
            break;

    }

    SetExecutedScriptReturnValue( nResult );
    return;

}



/* Function definitions. */

// Removes all the items and gold from the target's inventories.
void RemoveAllItemsAndGold( object oSource, object oTarget ){

    // Variables.
    object oItem        = GetFirstItemInInventory( oTarget );


    // Cycle the target's inventory.
    while( GetIsObjectValid( oItem ) ){
        // Purge.
        DestroyObject( oItem );
        oItem           = GetNextItemInInventory( oTarget );
    }

    // Cycle the target's equipped inventory.
    int nSlot           = 0;
    oItem               = GetItemInSlot( nSlot, oTarget );

    while( nSlot++ < NUM_INVENTORY_SLOTS ){

        // Purge.
        if( GetIsObjectValid( oItem ) )
            DestroyObject( oItem );

        oItem           = GetItemInSlot( nSlot, oTarget );

    }

    // Purge all gold from the target.
    AssignCommand( oSource, TakeGoldFromCreature( GetGold( oTarget ), oTarget, TRUE ) );

    return;

}
