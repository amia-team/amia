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
    int summonSet       = GetLocalInt(widget, "custom_set");
    string name         = GetName(summon);
    string widgetBio    = GetDescription(widget, FALSE, TRUE);

    if(GetIsDM(pc)){
        if((GetObjectType(summon) == OBJECT_TYPE_CREATURE) && (GetTag(summon) == "cust_summon")){
            if(summonSet == 0){
                json summonStored         = ObjectToJson(summon, TRUE);
                itemproperty uniqueRanged = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
                itemproperty uniqueOne    = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

                SetLocalJson(widget, "summon_critter", summonStored);
                SetLocalString(widget,"summonName",name);
                SetLocalInt(widget, "custom_set", 1);
                SetLocalInt(widget, "summonChoice", 1);
                SetName(widget,"<cÿÔ¦>Summon "+ name + "</c>");
                SetDescription(widget,"This widget will summon <cÿÔ¦>"+ name +"</c>.",TRUE);
                RemoveItemProperty(widget, uniqueRanged);
                IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
                FloatingTextStringOnCreature("Custom Summon set to <cÿÔ¦>"+ name +"</c>. You can give this item to the player or add another summon.", pc, TRUE);
            }
            else if((summonSet == 0 && GetLocalString(widget, "summonName") != "") || summonSet == 1){
                json summonStored2        = ObjectToJson(summon, TRUE);
                itemproperty uniqueOne    = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

                SetLocalJson(widget, "summon_critter2", summonStored2);
                SetLocalString(widget,"summonName2",name);
                SetLocalInt(widget, "custom_set", 2);
                SetDescription(widget,widgetBio + " Use the widget on itself to cycle through other stored summons.\n\nSummon 2: <cÿÔ¦>"+ name +"</c>.",TRUE);
                IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
                FloatingTextStringOnCreature("Custom Summon 2 set to <cÿÔ¦>"+ name +"</c>. You can give this item to the player or add another summon.", pc, TRUE);
            }
            else if(summonSet == 2){
                json summonStored3        = ObjectToJson(summon, TRUE);
                itemproperty uniqueOne    = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

                SetLocalJson(widget, "summon_critter3", summonStored3);
                SetLocalString(widget,"summonName3",name);
                SetLocalInt(widget, "custom_set", 3);
                SetDescription(widget,widgetBio + "\n\nSummon 3: <cÿÔ¦>"+ name +"</c>.",TRUE);
                IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
                FloatingTextStringOnCreature("Custom Summon 3 set to <cÿÔ¦>"+ name +"</c>. You can give this item to the player now.", pc, TRUE);
            }
            else if(summonSet == 3){
                itemproperty uniqueOne = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

                IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
                FloatingTextStringOnCreature("You have already set the maximum number of summons. You can give this to the player.", pc, TRUE);
            }
        }
        else if((GetObjectType(summon) == OBJECT_TYPE_CREATURE) && (GetTag(summon) != "cust_summon")){
            itemproperty uniqueOne = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

            IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            FloatingTextStringOnCreature("You must use one of the summon templates for this item. Select a creature with the correct template.", pc, TRUE);
        }
        else{
            itemproperty uniqueOne = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

            IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            FloatingTextStringOnCreature("Use this item on a summon NPC template to set the summon.", pc, TRUE);
        }
    }
    else if(summon == widget && GetLocalInt(widget, "custom_set") >= 2){
        if(GetLocalInt(widget, "summonChoice") != 2 && GetLocalInt(widget, "summonChoice") != 3){
            itemproperty uniqueOne = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

            SetLocalInt(widget, "summonChoice", 2);
            IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            SetName(widget, "<cÿÔ¦>Summon "+ GetLocalString(widget, "summonName2")+"</c>");
            FloatingTextStringOnCreature("Set to "+ GetLocalString(widget, "summonName2")+".", pc, TRUE);
        }
        else if(GetLocalInt(widget, "summonChoice") == 2 && GetLocalString(widget, "summonName3") != ""){
            itemproperty uniqueOne = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

            SetLocalInt(widget, "summonChoice", 3);
            IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            SetName(widget, "<cÿÔ¦>Summon "+ GetLocalString(widget, "summonName3")+"</c>");
            FloatingTextStringOnCreature("Set to "+ GetLocalString(widget, "summonName3")+".", pc, TRUE);
        }
        else if(GetLocalInt(widget, "summonChoice") == 2 && GetLocalString(widget, "summonName3") == ""){
            itemproperty uniqueOne = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

            SetLocalInt(widget, "summonChoice", 1);
            IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            SetName(widget, "<cÿÔ¦>Summon "+ GetLocalString(widget, "summonName")+"</c>");
            FloatingTextStringOnCreature("Set to "+ GetLocalString(widget, "summonName")+".", pc, TRUE);
        }
        else if(GetLocalInt(widget, "summonChoice") == 3){
            itemproperty uniqueOne = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

            SetLocalInt(widget, "summonChoice", 1);
            IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            SetName(widget, "<cÿÔ¦>Summon "+ GetLocalString(widget, "summonName")+"</c>");
            FloatingTextStringOnCreature("Set to " + GetLocalString(widget, "summonName")+".", pc, TRUE);
        }
    }
    else if(summon == widget && GetLocalInt(widget, "custom_set") <= 1){
        itemproperty uniqueOne = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

        IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
        FloatingTextStringOnCreature("You only have one summon saved on this widget. Use on the ground to summon.", pc, TRUE);
    }
    else if(GetIsObjectValid(GetAssociate(4, pc, 1))){
        itemproperty uniqueOne = ItemPropertyCastSpell(329, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);

        IPSafeAddItemProperty(widget, uniqueOne, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
        SendMessageToPC(pc, "You cannot have this summon alongside another summon. Unsummon before you try to call on this one.");
    }
    else{
        location targetSpot  = GetItemActivatedTargetLocation();
        int pcLevel          = GetLevelByPosition(1, pc) + GetLevelByPosition(2, pc) + GetLevelByPosition(3, pc);
        float summonDuration = 3600.0 * pcLevel;
        effect summonVFX     = EffectVisualEffect(481, FALSE, 1.0);
        int summonChoice     = GetLocalInt(widget, "summonChoice");

        if(summonChoice == 1 || summonChoice == 0){
            json newSum      = GetLocalJson(widget, "summon_critter");
            object newSummon = JsonToObject(newSum, targetSpot, pc, TRUE);

            AddHenchman(pc, newSummon);
            GhostSummon(pc);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, summonVFX, targetSpot);
            SendMessageToPC(pc, "Summon Duration: "+ FloatToString(summonDuration, 0, 0) +" seconds.");
            DelayCommand(summonDuration, RemoveSummon(pc));
        }
        else{
            json newSum      = GetLocalJson(widget, "summon_critter"+IntToString(summonChoice));
            object newSummon = JsonToObject(newSum, targetSpot, pc, TRUE);

            AddHenchman(pc, newSummon);
            GhostSummon(pc);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, summonVFX, targetSpot);
            SendMessageToPC(pc, "Summon Duration: "+ FloatToString(summonDuration, 0, 0) +" seconds.");
            DelayCommand(summonDuration, RemoveSummon(pc));
        }
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
