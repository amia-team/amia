// Inspire Courage
//
// Uses one Bard Song per use, lasts Round/Bard level. Creates a 10
// meter aura, and enemies which enter the aura must roll
// Concentration vs Taunt or suffer -4 AB.  Allies which enter the
// aura gain +20% physical damage immunity.  The caster gains
// +20% physical damage immunity, but suffers -4 AC and -50% str
// modified damage.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/14/2012 Mathias          Initial Release.
//
#include "x2_inc_switches"
#include "inc_ds_records"
#include "amia_include"

void ActivateItem() {


    // Variables
    object oPC          = GetItemActivator();
    int    nDuration    = 10;
    effect eAOE         = EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR, "cs_inspcrage_a", "****", "****");
    effect eHowl        = EffectVisualEffect(VFX_FNF_HOWL_ODD);
    int    bDebug       = FALSE;  // set to TRUE to see debug messages

    //check block time
    if ( GetIsBlocked( oPC, "ds_RDD_b" ) > 0 ) {

        string sRecharge = IntToString( GetIsBlocked( oPC, "ds_RDD_b" ) );
        SendMessageToPC( oPC, "Your energy reserves are still recovering, allowing for your draconic ability in " +sRecharge+ " seconds!" );
        return;
    }

    //find constituation adjustment to block time
    int nCD = 10 * GetAbilityModifier( ABILITY_CONSTITUTION, oPC );
    int nMin;
    int nSec;

    //set cooldown adjustment for later use
    if ( nCD == 0 ) {
        nMin = 5;
        nSec = 0;
    } else if ( nCD > 0 && nCD <= 60 ) {
        nMin = 4;
        nSec = ( 60 - nCD );
    } else if ( nCD > 60 && nCD <= 120 ) {
        nMin = 3;
        nSec = ( 120 - nCD );
    } else if ( nCD > 120 && nCD <= 180 ) {
        nMin = 2;
        nSec = ( 180 - nCD );
    } else if ( nCD > 180 && nCD <= 240 ) {
        nMin = 1;
        nSec = ( 240 - nCD );
    } else if ( nCD > 240 && nCD <= 300 ) {
        nMin = 0;
        nSec = ( 300 - nCD );
    } else if ( nCD > 300 ) {
        nMin = 0;
        nSec = 0;
    }

    // Trigger the howl effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHowl, oPC);

    // Apply the aura
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, RoundsToSeconds( nDuration ) );

    // !!DEBUG!!
    if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oPC) + " activated Inspire Courage for " + IntToString(nDuration) + " rounds. -" ); }

    // Apply the cooldown time.
    SetBlockTime( oPC, nMin, nSec, "ds_RDD_b" );

}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}
