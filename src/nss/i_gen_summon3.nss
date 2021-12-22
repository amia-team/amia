// Generic summoner. Used for summon reskins on DC requests.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/24/2013 PoS              Initial Release
//

// Includes
#include "x2_inc_switches"
#include "inc_ds_records"
#include "inc_td_appearanc"
#include "inc_ds_summons"

void ActivateItem( )
{
    // Major variables.
    object oPC          = GetItemActivator();
    location lLocation  = GetItemActivatedTargetLocation();
    string sSummon      = "gen_sum_cre3";
    effect eSummon      = EffectSummonCreature( sSummon, VFX_FNF_SUMMON_MONSTER_1, 0.5 );

    ApplyEffectAtLocation( DURATION_TYPE_PERMANENT, eSummon, lLocation );

    // Handle reskins/optional visuals.
    DelayCommand( 2.0, HandleSummonVisuals( oPC, 1 ) );
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );
    object oPC = GetItemActivator();

    switch ( nEvent )
    {
        case X2_ITEM_EVENT_ACTIVATE:
            AssignCommand( oPC, ActivateItem() ); // Assign to PC so it dominates targets properly
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}
