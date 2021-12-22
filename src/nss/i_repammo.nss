/* Nominal Price Repeatable Ammo

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    040506      kfw         Initial release.
    8-4-2017    msheeler    changed charge for ammo restock to a flat 100gp
    4-2-2021    Jes         Changed charge to 1000gp, raised max stack to 999
    ----------------------------------------------------------------------------

    --------
    Verbatim
    --------
    Resets stack quantity and sets ammo to stolen & undroppable for a nominal charge.

*/

#include "x2_inc_switches"
void main( ){

    // Variables
    int nEvent          = GetUserDefinedItemEventNumber( );
    int nResult         = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            object oItem        = GetItemActivatedTarget( );
            string szTag        = GetTag( oItem );
            int nItemType       = GetBaseItemType( oItem );
            int nCurrentStack   = GetItemStackSize( oItem );
            int nCurrentCost    = GetGoldPieceValue( oItem );
            int nMaxStack       = 999;
            float fGP           = 0.0;
            int nGP             = 0;


            // Filter: (1) Disco's Ammo (prefix 'ds_poison_'),
            if( GetSubString( szTag, 0, 10 ) == "ds_poison_" ){
                SendMessageToPC( oPC, "- This ammo drips with poison and can't be stored in your bag. -" );
                break;
            }

            // Filter: (2) Request Ammo (prefix 'ds_imbue_'),
            if( GetSubString( szTag, 0, 9 ) == "ds_imbue_" ){
                SendMessageToPC( oPC, "[You can't store this type of ammo.]" );
                break;
            }


            // Bolt, Bullet, Arrows have 999 max. stack sizes instead.
            if( nItemType == BASE_ITEM_BOLT     ||
                nItemType == BASE_ITEM_BULLET   ||
                nItemType == BASE_ITEM_ARROW    )
                nMaxStack = 999;


            // Verify Item Status
            if( GetIsObjectValid( oItem ) &&
                (   nItemType == BASE_ITEM_BOLT         ||
                    nItemType == BASE_ITEM_ARROW        ||
                    nItemType == BASE_ITEM_DART         ||
                    nItemType == BASE_ITEM_SHURIKEN     ||
                    nItemType == BASE_ITEM_BULLET       ||
                    nItemType == BASE_ITEM_THROWINGAXE  )   ){

                // Fully stocked ?
                if( nCurrentStack >= nMaxStack ){
                    // Notify the player.
                    SendMessageToPC( oPC, "- Your ammo is already fully stocked. -" );
                    break;
                }

                /* Calculate gold needed. */

                // GP = 1 + 5% of Deficit stock * Unit cost.

                //Removed this calculation for a requested 100gp flat charge by DM request
                //fGP = 1.0 + 0.05 * ( nMaxStack - nCurrentStack ) * ( nCurrentCost / nCurrentStack );

                nGP = 1000; // removed for flat rate charge requested --> FloatToInt( fGP )

                // Verify Gold Status.
                if( nGP > GetGold( oPC ) ){
                    // Notify the player.
                    SendMessageToPC( oPC, "- You need " + IntToString( nGP ) + " gold to restock your ammo! -" );
                    break;
                }

                // Charge the player a nominal fee.
                AssignCommand( oItem, TakeGoldFromCreature( nGP, oPC, TRUE ) );

                // Set ammo to stolen, to prevent the player from selling.
                SetStolenFlag( oItem, TRUE );

                // Set ammo to undroppable, to prevent the player transferring.
                //SetItemCursedFlag( oItem, TRUE );

                //Let the PC know that it is recharging (just delayed to fix an exploit)
                SendMessageToPC( oPC, "- Ammo is being restocked... -" );

                // Reset ammo stack quantity.
                DelayCommand( 6.0, SetItemStackSize( oItem, 999 ) );

                // Notify the player.
                DelayCommand( 6.0, SendMessageToPC( oPC, "- Ammo restocked! -" ) );

            }

            // Error, invalid item type, notify the player.
            else
                SendMessageToPC( oPC, "- Error: Only bolts, arrows, darts, shurikens, bullets or throwing axes are permissible! -" );


            break;

        }

        default:    break;

    }

    SetExecutedScriptReturnValue( nResult );

}
