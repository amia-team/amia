//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_pc_war
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

void main (){

    object pc         = GetItemActivator();
    object widget     = GetItemActivated();
    object guardNPC   = GetItemActivatedTarget();
    object inArea     = GetArea(pc);
    int guardCount    = GetLocalInt(widget, "guardCount");
    int warCheck      = GetLocalInt(inArea, "war");

    if(GetIsDM(pc)){
        if((GetObjectType(guardNPC) == OBJECT_TYPE_CREATURE) && (GetTag(guardNPC) == "settle_elitguard" || GetTag(guardNPC) == "settle_mageguard" || GetTag(guardNPC) == "settle_scutguard" || GetTag(guardNPC) == "settle_stndguard" || GetTag(guardNPC) == "settle_cns_guard" || GetTag(guardNPC) == "settle_und_guard")){
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
            itemproperty uniqueSelf   = ItemPropertyCastSpell(335, IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
            string guardName          = GetLocalString(widget,"guardName");

            RemoveItemProperty(widget, uniqueRanged);
            IPSafeAddItemProperty(widget, uniqueSelf, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            SetName(widget,"Summon "+guardName+" Troops");
            SetDescription(widget,"This widget will summon a group of settlement guards with infinite duration to act as your troops, which only works in a war area as set by a DM. They will disappear if you remove them from your party, rest, or die.",TRUE);
            FloatingTextStringOnCreature("Troops finalized. You may give this item to the player now.", pc, TRUE);
        }
        else{
            FloatingTextStringOnCreature("Use this item on a guard NPC to set the guard object, or finalize it by targeting itself.", pc, TRUE);
        }
    }
    else if(warCheck == 1){
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
            SetTag(henchGuard1, "guard_template");
            i = (i - 1);
        }
        int i2 = subGuard;
        while (i2 > 0){
            object henchGuard2 = JsonToObject(getGuard2, pcSpot, pc, TRUE);
            AddHenchman(pc, henchGuard2);
            SetTag(henchGuard2, "guard_template");
            i2 = (i2 - 1);
        }
        int i3 = subGuard;
        while (i3 > 0){
            object henchGuard3 = JsonToObject(getGuard3, pcSpot, pc, TRUE);
            AddHenchman(pc, henchGuard3);
            SetTag(henchGuard3, "guard_template");
            i3 = (i3 - 1);
        }
        int i4 = subGuard;
        while (i4 > 0){
            object henchGuard4 = JsonToObject(getGuard4, pcSpot, pc, TRUE);
            AddHenchman(pc, henchGuard4);
            SetTag(henchGuard4, "guard_template");
            i4 = (i4 - 1);
        }
    }
    else{
        SendMessageToPC(pc,"You can only summon these guards in an area where war is taking place!");
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
