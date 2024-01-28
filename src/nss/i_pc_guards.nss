//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_pc_guards
//date:    Jan 17 2024
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
int AllyCheck(object widget, object pc);

void main (){

    object pc         = GetItemActivator();
    object widget     = GetItemActivated();
    object guardNPC   = GetItemActivatedTarget();
    object inArea     = GetArea(pc);
    int guardCheck    = GetLocalInt(widget, "settlement_1");
    int areaCheck     = GetLocalInt(inArea, "settlement");
    int guardCount    = GetLocalInt(widget, "guardCount");
    int alliedArea    = AllyCheck(widget, pc);

    if(GetIsDM(pc)){
        if((GetObjectType(guardNPC) == OBJECT_TYPE_CREATURE) && (GetTag(guardNPC) == "guard_template")){
            if(guardCount == 0){
                json guard1  = ObjectToJson(guardNPC, TRUE);
                string name1 = GetName(guardNPC);

                SetLocalJson(widget, "guard_critter1", guard1);
                SetLocalInt(widget, "guardCount", 1);
                SetLocalString(widget,"guardName",name1);
                FloatingTextStringOnCreature("Guard object 1 set. Use this item on itself to finalize, or add another object.", pc, TRUE);
            }
            else if(guardCount == 1){
                json guard2  = ObjectToJson(guardNPC, TRUE);

                SetLocalJson(widget, "guard_critter2", guard2);
                SetLocalInt(widget, "guardCount", 2);
                FloatingTextStringOnCreature("Guard object 2 set. Use this item on itself to finalize, or add another object.", pc, TRUE);
            }
            else if(guardCount == 2){
                json guard3  = ObjectToJson(guardNPC, TRUE);

                SetLocalJson(widget, "guard_critter3", guard3);
                SetLocalInt(widget, "guardCount", 3);
                FloatingTextStringOnCreature("Guard object 3 set. Use this item on itself to finalize, or add another object.", pc, TRUE);
            }
            else if(guardCount == 3){
                json guard4  = ObjectToJson(guardNPC, TRUE);

                SetLocalJson(widget, "guard_critter4", guard4);
                SetLocalInt(widget, "guardCount", 4);
                FloatingTextStringOnCreature("Guard object 4 set. Use this item on itself to finalize.", pc, TRUE);
            }
            else if(guardCount == 4){
                FloatingTextStringOnCreature("Maximum guard objects set. Use this item on itself to finalize.", pc, TRUE);
            }

        }
        else if((GetObjectType(guardNPC) == OBJECT_TYPE_CREATURE) && (GetTag(guardNPC) != "guard_template")){
            FloatingTextStringOnCreature("You must use one of the guard templates for this item. Select a creature with the correct template.", pc, TRUE);
        }
        else if(guardNPC == widget){
            itemproperty uniqueRanged = GetFirstItemProperty(widget);
            itemproperty uniqueSelf   = ItemPropertyCastSpell(335, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
            string guardName          = GetLocalString(widget,"guardName");

            RemoveItemProperty(widget, uniqueRanged);
            IPSafeAddItemProperty(widget, uniqueSelf, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            SetName(widget,"Summon "+guardName+" Guard Group");
            SetDescription(widget,"This widget will summon a group of settlement guards with infinite duration, which only works in your settlement, surrounding areas, or in allied lands. Use it again to unsummon.",TRUE);
            FloatingTextStringOnCreature("Guards finalized. You may give this item to the player now.", pc, TRUE);
        }
        else{
            FloatingTextStringOnCreature("Use this item on a guard NPC to set the guard object, or finalize it by targeting itself.", pc, TRUE);
        }
    }
    else if((GetLocalInt(pc,"guard_spawned") != 1) && (alliedArea == 1) && (GetLocalInt(pc, "swarm_spawned") != 1)){
        int guardQty      = GetLocalInt(widget, "qty");
        int guardTypes    = GetLocalInt(widget,"guardCount");
        int subGuard      = (guardQty / guardTypes);

        json getGuard1    = GetLocalJson(widget,"guard_critter1");
        json getGuard2    = GetLocalJson(widget,"guard_critter2");
        json getGuard3    = GetLocalJson(widget,"guard_critter3");
        json getGuard4    = GetLocalJson(widget,"guard_critter4");
        location pcSpot   = GetLocation(pc);

        int i = subGuard;
        while (i > 0){
            object henchGuard1  = JsonToObject(getGuard1, pcSpot, pc, TRUE);
            AddHenchman(pc, henchGuard1);
            i = (i - 1);
        }
        int i2 = subGuard;
        while (i2 > 0){
            object henchGuard2 = JsonToObject(getGuard2, pcSpot, pc, TRUE);
            AddHenchman(pc, henchGuard2);
            i2 = (i2 - 1);
        }
        int i3 = subGuard;
        while (i3 > 0){
            object henchGuard3 = JsonToObject(getGuard3, pcSpot, pc, TRUE);
            AddHenchman(pc, henchGuard3);
            i3 = (i3 - 1);
        }
        int i4 = subGuard;
        while (i4 > 0){
            object henchGuard4 = JsonToObject(getGuard4, pcSpot, pc, TRUE);
            AddHenchman(pc, henchGuard4);
            i4 = (i4 - 1);
        }
        SetLocalInt(pc,"guard_spawned",1);
    }
    else if(GetLocalInt(pc, "swarm_spawned") == 1){
        SendMessageToPC(pc, "You cannot summon your guards while you have a swarm. Unsummon your swarm to proceed.");
    }
    else if(GetLocalInt(pc,"guard_spawned") == 1){
        int dieQty = HenchCount(pc);

        int i = dieQty;
            while (i > 0){
                object guardDie = GetHenchman(pc,i);
                effect unsummon = EffectVisualEffect(VFX_IMP_PDK_RALLYING_CRY);
                location guardSpot = GetLocation(guardDie);

                if(GetIsObjectValid(guardDie)){
                    if(GetTag(guardDie) == "guard_template"){
                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,unsummon,guardSpot);
                        RemoveHenchman(pc,guardDie);
                        DestroyObject(guardDie,0.1);
                    }
                i = (i - 1);
                }

            }
        DeleteLocalInt(pc,"guard_spawned");
        SendMessageToPC(pc, "Your guards have returned to their duties.");
    }
    else{
        SendMessageToPC(pc,"You can only summon your guards in your approved settlement areas!");
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

int AllyCheck(object widget, object pc){
    int settlement = GetLocalInt(widget, "settlement_1");
    int areaCheck  = GetLocalInt(GetArea(pc), "settlement");
    int allyCount  = GetLocalInt(widget, "ally_count");
    int alliedArea;
    int a = 1;
    while (a <= allyCount){
        string allyNumber = (IntToString(a));
        if(GetLocalInt(widget, "settlement_"+allyNumber) == areaCheck){
            alliedArea = 1;
            a = a + 1;
        }
        else{
            a = a + 1;
        }
    }
    return alliedArea;
}
