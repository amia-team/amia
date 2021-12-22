/*
i_tha_items

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
this is a general item trigger script for the Forrstakrr mod

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
06-21-2006      disco      Bugfix
19-11-2007      disco      Now using inc_ds_records
------------------------------------------------
*/
//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void WinterPants(object oPC, object oItem, object oSpellTarget);
void BoomBolt(object oPC, object oSpellTarget);
void DeleteItem(object oPC,object oTarget);


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){
    int nEvent = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
    object oPC;      //The player character using the item
    object oItem;    //The item being used
    object oSpellOrigin; //The origin of the spell
    object oSpellTarget; //The target of the spell
    object oTarget;
    location lTarget;
    string sItemName;

    switch (nEvent){
        case X2_ITEM_EVENT_ACTIVATE:
            oPC = GetItemActivator();
            oItem = GetItemActivated();
            oTarget = GetItemActivatedTarget();
            sItemName = GetName(oItem);

            if(sItemName == "Ticket to Forrstakkr"){
                AssignCommand(oPC,ActionJumpToObject(GetWaypointByTag("tha_trader_landing")));
            }
            else if (sItemName == "The Destructor"){

                DeleteItem( oPC, oTarget );
            }
            else if (sItemName == "Insurance Paper (1000 gold)"){
                DestroyObject(oItem);
                GiveGoldToCreature(oPC,1000);
            }
            else if (sItemName == "Insurance Paper (2500 gold)"){
                DestroyObject(oItem);
                GiveGoldToCreature(oPC,2500);
            }
            else if (sItemName == "Insurance Paper (5000 gold)"){
                DestroyObject(oItem);
                GiveGoldToCreature(oPC,5000);
            }
            else if (sItemName == "Insurance Paper (10000 gold)"){
                DestroyObject(oItem);
                GiveGoldToCreature(oPC,10000);
            }
            else if (sItemName == "Insurance Paper (25000 gold)"){
                DestroyObject(oItem);
                GiveGoldToCreature(oPC,25000);
            }
            else if(sItemName == "The Reputator"){
                int nReputation = tha_reputation(oTarget,0);
                int nNewReputation = 1;
                if (nReputation>6){
                    nNewReputation = 0-nReputation;
                }
                nReputation = tha_reputation(oTarget,nNewReputation);
                SendMessageToPC(oPC,GetName(oTarget)+"'s reputation is set to "+IntToString(tha_reputation(oTarget,0)));
            }
        break;

        case X2_ITEM_EVENT_ONHITCAST:
            oItem = GetSpellCastItem();           // The item triggering this spellscript
            oPC = OBJECT_SELF;                      // The player triggering it
            oSpellTarget = GetSpellTargetObject();  // What the spell is aimed at
            sItemName = GetName(oItem);
            if (sItemName == "BoomBolt"){
                BoomBolt(oPC,oSpellTarget);
            }
            else if (sItemName == "WinterPants"){
                WinterPants(oPC,oItem,oSpellTarget);
            }
        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------


//migth be a bit lagtastic
void WinterPants(object oPC, object oItem, object oSpellTarget){
    int nBugger = Random(100);

    if (nBugger!= 13){
         return;
    }
    //if nBugger == 13 then the armour's stove explodes

    SendMessageToPC(oPC,"Warning: You tinkered with your WinterPants. GICA's Extended Warranty is now Void. Thanks for being our customer!");

    // boom the pc
    int nHealth = GetCurrentHitPoints( oPC );
    int nDamage = nHealth/2;
    effect eOuch = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
    effect eKnockDown = EffectKnockdown();
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockDown, oPC,3.0);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eOuch, oPC);

    //knock over the enemy
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockDown, oSpellTarget,4.0);

    //explosion + disclaimer
    PlaySound("sim_pulsfire");
    ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING, 1.0, 1.0);
    FloatingTextStringOnCreature("Your WinterPants' stove exploded!", oPC, TRUE);
    CreateItemOnObject("tha_wreckage",oPC,1);
    DelayCommand(1.0,DestroyObject(oItem));
}

void BoomBolt(object oPC,object oSpellTarget){

    if(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == "tha_boombow"){

        effect eSonic = EffectDamage(d6(),DAMAGE_TYPE_FIRE);
        effect eFire = EffectDamage(d6(),DAMAGE_TYPE_SONIC);
        effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSpellTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSonic, oSpellTarget,4.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oSpellTarget,4.0);
    }
    else {

        FloatingTextStringOnCreature("The BoomBolts will only go BOOM when used with a BoomBow!", oPC, TRUE);
    }
}


void DeleteItem( object oPC,object oTarget ){

    SetPlotFlag( oTarget, FALSE );

    if ( GetTag( oTarget ) == "ds_pckey" ){

        FlushPCKEY( oPC, GetName( oTarget ) );

        DestroyObject( oTarget, 1.0 );

        SetLocalInt( oPC, "ds_done", 0 );
    }
    else{

        DestroyObject( oTarget, 0.0 );
    }
}
