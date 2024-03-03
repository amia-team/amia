//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_custsummon
//date:    Feb 29 2024
//author:  Jes

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"
//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void main (){

    object pc           = GetItemActivator();
    object widget       = GetItemActivated();
    object summon       = GetItemActivatedTarget();
    object pcKey        = GetItemPossessedBy(pc, "ds_pckey");
    int summonSet       = GetLocalInt(pc, "custom_spawned");
    string name         = GetName(summon);
    string partialPckey = GetSubString(GetTag(pcKey), 0, 15);
    string summonResRef = partialPckey + "_"+ name;

    if(GetIsDM(pc)){
        if((GetObjectType(summon) == OBJECT_TYPE_CREATURE) && (GetTag(summon) == "cust_summon")){
            if(summonSet == 0){
                json summonStored          = ObjectToJson(summon, TRUE);
                itemproperty uniqueRanged  = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
                itemproperty uniqueRanged1 = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);


                SetLocalJson(widget, "summon_critter", summonStored);
                SetLocalInt(widget, "custom_spawned", 1);
                SetLocalString(widget,"summonName",name);
                SetName(widget,"Summon "+ name);
                SetDescription(widget,"This widget will summon <cÿÔ¦>"+ name +"</c>. Use it again to unsummon.",TRUE);
                RemoveItemProperty(widget, uniqueRanged);
                IPSafeAddItemProperty(widget, uniqueRanged1, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
                FloatingTextStringOnCreature("Custom Summon set to <cÿÔ¦>"+ name +"</c>. You can give this item to the player now.", pc, TRUE);
            }
            else{
                FloatingTextStringOnCreature("You have already set this summon. You can give it to the player.", pc, TRUE);
            }
        }
        else if((GetObjectType(summon) == OBJECT_TYPE_CREATURE) && (GetTag(summon) != "cust_summon")){
            FloatingTextStringOnCreature("You must use one of the summon templates for this item. Select a creature with the correct template.", pc, TRUE);
        }
        else{
            FloatingTextStringOnCreature("Use this item on a summon NPC template to set the summon.", pc, TRUE);
        }
    }
    else{
        location targetSpot  = GetLocation(summon);
        int pcLevel          = GetLevelByPosition(1, pc) + GetLevelByPosition(2, pc) + GetLevelByPosition(3, pc);
        float summonDuration = 60.0 * pcLevel;
        effect summonNew     = EffectSummonCreature(summonResRef, VFX_NONE, 0.1, 0);
        effect summonVFX     = EffectVisualEffect(481, FALSE, 1.0);

        JsonToTemplate(GetLocalJson(widget,"summon_critter"), summonResRef, RESTYPE_UTC);
        AssignCommand(pc, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, summonNew, targetSpot, summonDuration ));
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, summonVFX, targetSpot);
    }
}
