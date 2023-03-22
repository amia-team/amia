// Generic summoner. Used for summon reskins on DC requests.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/24/2013 PoS              Initial Release
// 22/03/2023 Frozen           Changed to handle all generic summon widgets in one script
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
    object oItem        = GetItemActivated();
    string sItem        = GetResRef (oItem);
    string sSummon;
    effect eSummon      = EffectSummonCreature( sSummon, VFX_FNF_SUMMON_MONSTER_1, 0.5 );

        if      (sItem == "gen_summon" ) { sSummon = "gen_sum_cre" ; }
        else if (sItem == "gen_summon2") { sSummon = "gen_sum_cre2"; }
        else if (sItem == "gen_summon3") { sSummon = "gen_sum_cre3"; }
        else if (sItem == "gen_summon4") { sSummon = "gen_sum_cre4"; }
        else if (sItem == "gen_summon5") { sSummon = "gen_sum_cre5"; }

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
