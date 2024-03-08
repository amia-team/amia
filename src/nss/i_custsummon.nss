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
int HenchCount(object pc);

void RemoveSummon(object pc);

void GhostSummon(object pc);

void main (){

    object pc           = GetItemActivator();
    object widget       = GetItemActivated();
    object summon       = GetItemActivatedTarget();
    object pcKey        = GetItemPossessedBy(pc, "ds_pckey");
    int summonSet       = GetLocalInt(pc, "custom_spawned");
    string name         = GetName(summon);
    string partialPckey = GetSubString(GetTag(pcKey), 0, 15);
    string summonResRef = partialPckey +"_"+ name;

    if(GetIsDM(pc)){
        if((GetObjectType(summon) == OBJECT_TYPE_CREATURE) && (GetTag(summon) == "cust_summon")){
            if(summonSet == 0){
                json summonStored         = ObjectToJson(summon, TRUE);
                itemproperty uniqueRanged = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
                itemproperty uniqueSelf   = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);


                SetLocalJson(widget, "summon_critter", summonStored);
                SetLocalString(widget,"summonName",name);
                SetName(widget,"<cÿÔ¦>Summon "+ name + "</c>");
                SetDescription(widget,"This widget will summon <cÿÔ¦>"+ name +"</c>.",TRUE);
                RemoveItemProperty(widget, uniqueRanged);
                IPSafeAddItemProperty(widget, uniqueSelf, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
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
    else if(GetIsObjectValid(GetAssociate(4, pc, 1))){
        object currentSummon = GetAssociate(4, pc, 1);
        location targetSpot  = GetItemActivatedTargetLocation();
        location curSumLoc   = GetLocation(currentSummon);
        int pcLevel          = GetLevelByPosition(1, pc) + GetLevelByPosition(2, pc) + GetLevelByPosition(3, pc);
        float summonDuration = 3600.0 * pcLevel;
        effect summonVFX     = EffectVisualEffect(481, FALSE, 1.0);
        effect unsummon      = EffectVisualEffect(99);
        json newSum          = GetLocalJson(widget, "summon_critter");
        object newSummon     = JsonToObject(newSum, targetSpot, pc, TRUE);

        AddHenchman(pc, newSummon);
        GhostSummon(pc);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, summonVFX, targetSpot);
        SendMessageToPC(pc, "Duration: "+ FloatToString(summonDuration, 0, 0) +" seconds.");
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,unsummon,curSumLoc);
        DestroyObject(currentSummon);
        SendMessageToPC(pc, "You cannot have this summon alongside another summon.");
        DelayCommand(summonDuration, RemoveSummon(pc));
    }
    else{
        location targetSpot  = GetItemActivatedTargetLocation();
        int pcLevel          = GetLevelByPosition(1, pc) + GetLevelByPosition(2, pc) + GetLevelByPosition(3, pc);
        float summonDuration = 3600.0 * pcLevel;
        effect summonVFX     = EffectVisualEffect(481, FALSE, 1.0);
        json newSum          = GetLocalJson(widget, "summon_critter");
        object newSummon = JsonToObject(newSum, targetSpot, pc, TRUE);

        AddHenchman(pc, newSummon);
        GhostSummon(pc);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, summonVFX, targetSpot);
        SendMessageToPC(pc, "Summon Duration: "+ FloatToString(summonDuration, 0, 0) +" seconds.");
        DelayCommand(summonDuration, RemoveSummon(pc));
    }
}

int HenchCount(object pc){
    int henchCount;
    int h = 1;
    while (GetIsObjectValid(GetHenchman(pc,h))){
        henchCount = h;
        h = h + 1;
    }
    return henchCount;
}
void RemoveSummon(object pc){
    int dieQty = HenchCount(pc);

    int i = (dieQty);
        while (i > 0){
            object summonDie = GetHenchman(pc,i);
            effect unsummon = EffectVisualEffect(99);
            location summonSpot = GetLocation(summonDie);

            if(GetIsObjectValid(summonDie)){
                if(GetTag(summonDie) == "cust_summon"){
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,unsummon,summonSpot);
                    RemoveHenchman(pc,summonDie);
                    DestroyObject(summonDie,0.1);
                    i = (i - 1);
                }
            }
        }
    SendMessageToPC(pc, "Unsummoned your summon.");
}

void GhostSummon(object pc){
    int henchQty = HenchCount(pc);

    int i = (henchQty);
        while (i > 0){
            object summonGhost = GetHenchman(pc,i);

            if(GetIsObjectValid(summonGhost)){
                if(GetTag(summonGhost) == "cust_summon"){
                    effect ghost = EffectCutsceneGhost();
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ghost, summonGhost);
                    i = (i - 1);
                }
            }
        }
}
