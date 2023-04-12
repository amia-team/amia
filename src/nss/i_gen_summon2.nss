// Generic summoner. Used for summon reskins on DC requests.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/24/2013 PoS              Initial Release
// 22/03/2023 Frozen           Updated to refere generic summons to single script usage

// Includes
/*
#include "x2_inc_switches"
#include "inc_ds_records"
#include "inc_td_appearanc"
#include "inc_ds_summons"

void ActivateItem( )
{
    // Major variables.
    object oPC          = GetItemActivator();
    location lLocation  = GetItemActivatedTargetLocation();
    string sSummon      = "gen_sum_cre2";
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
*/
#include "x2_inc_switches"
#include "inc_ds_records"

void main( )
{
   object oPC          = GetItemActivator();
   object oItem        = GetItemActivated();
   string sItem        = GetTag (oItem);
   string sResRef      = GetResRef (oItem);
   
   if (sItem == "gen_summon2"){
        SetTag (oItem, "gen_summon");
        FloatingTextStringOnCreature ( "Widget updated, please use again", oPC, FALSE);
        }
   else{
        FloatingTextStringOnCreature ( "ERROR, Please notify a dev/dm what happend and: gen2, " +sItem +", " +sResRef, oPC, FALSE);
        }
}
