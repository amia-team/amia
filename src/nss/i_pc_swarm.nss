//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_pc_swarm
//date:    Jan 16 2024
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

    object pc        = GetItemActivator();
    object swarmer   = GetItemActivated();
    object swarmUse  = GetItemActivatedTarget();
    int swarmCount   = GetLocalInt(swarmer, "swarmCount");

    if(GetIsDM(pc)){
        if((GetObjectType(swarmUse) == OBJECT_TYPE_CREATURE) && (GetResRef(swarmUse) == "swarm_summon")){
            if(swarmCount == 0){
                json swarm1  = ObjectToJson(swarmUse, TRUE);
                string name1 = GetName(swarmUse);

                SetLocalJson(swarmer, "swarm_critter1", swarm1);
                SetLocalInt(swarmer, "swarmCount", 1);
                SetLocalString(swarmer,"swarmName",name1);
                FloatingTextStringOnCreature("Swarm object set. Use this item on itself to finalize, or add another object.", pc, TRUE);
            }
            else if(swarmCount == 1){
                json swarm2  = ObjectToJson(swarmUse, TRUE);

                SetLocalJson(swarmer, "swarm_critter2", swarm2);
                SetLocalInt(swarmer, "swarmCount", 2);
                FloatingTextStringOnCreature("Swarm object set. Use this item on itself to finalize, or add another object.", pc, TRUE);
            }
            else if(swarmCount == 2){
                json swarm3  = ObjectToJson(swarmUse, TRUE);

                SetLocalJson(swarmer, "swarm_critter3", swarm3);
                SetLocalInt(swarmer, "swarmCount", 3);
                FloatingTextStringOnCreature("Swarm object set. Use this item on itself to finalize.", pc, TRUE);
            }
            else if(swarmCount == 3){
                FloatingTextStringOnCreature("Maximum swarm objects set. Use this item on itself to finalize.", pc, TRUE);
            }

        }
        else if((GetObjectType(swarmUse) == OBJECT_TYPE_CREATURE) && (GetResRef(swarmUse) != "swarm_summon")){
            FloatingTextStringOnCreature("You must use the Swarm Summon Template creature base. Select a creature with the correct base template.", pc, TRUE);
        }
        else if(swarmUse == swarmer){
            itemproperty uniqueRanged = GetFirstItemProperty(swarmer);
            itemproperty uniqueSelf   = ItemPropertyCastSpell(335, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
            string swarmName          = GetLocalString(swarmer,"swarmName");

            RemoveItemProperty(swarmer, uniqueRanged);
            IPSafeAddItemProperty( swarmer, uniqueSelf, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE );
            SetName(swarmer,"Summon Swarm: "+swarmName+" Group");
            SetDescription(swarmer,"This widget will summon a swarm of creatures with infinite duration. Use it again to unsummon.",TRUE);
            FloatingTextStringOnCreature("Swarm finalized. You may give this item to the player now.", pc, TRUE);
        }
        else{
            FloatingTextStringOnCreature("Use this item on a monster to set the swarm creature, or finalize it by targeting itself.", pc, TRUE);
        }
    }
    else if(GetLocalInt(pc,"spawned") != 1){
        int henchQty      = GetLocalInt(swarmer, "qty");
        int subSwarm      = henchQty / swarmCount;
        int swarm2        = subSwarm;
        int swarm3        = henchQty - (subSwarm + swarm2);

        json getSwarm1    = GetLocalJson(swarmer,"swarm_critter1");
        json getSwarm2    = GetLocalJson(swarmer,"swarm_critter2");
        json getSwarm3    = GetLocalJson(swarmer,"swarm_critter3");
        location pcSpot   = GetLocation(pc);

        int i = subSwarm;
        while (i > 0){
            object henchSwarm1  = JsonToObject(getSwarm1, pcSpot, pc, TRUE);
            AddHenchman(pc, henchSwarm1);
            i = (i - 1);
        }
        int i2 = swarm2;
        while (i2 > 0){
            object henchSwarm2 = JsonToObject(getSwarm2, pcSpot, pc, TRUE);
            AddHenchman(pc, henchSwarm2);
            i2 = (i2 - 1);
        }
        int i3 = swarm3;
        while (i3 > 0){
            object henchSwarm3 = JsonToObject(getSwarm3, pcSpot, pc, TRUE);
            AddHenchman(pc, henchSwarm3);
            i3 = (i3 - 1);
        }
        SetLocalInt(pc,"spawned",1);
    }
    else{
        int dieQty = GetLocalInt(swarmer, "qty");

        int i = (dieQty + 1);
            while (i > 0){
                object swarmDie = GetHenchman(pc,1);
                effect unsummon = EffectVisualEffect(VFX_IMP_PDK_RALLYING_CRY);
                location swarmSpot = GetLocation(swarmDie);

                if(GetIsObjectValid(swarmDie) && (GetResRef(swarmUse) == "swarm_summon")){
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,unsummon,swarmSpot);
                    RemoveHenchman(pc,swarmDie);
                    DestroyObject(swarmDie,0.1);
                }
                i = (i - 1);
            }
        SetLocalInt(pc,"spawned",0);
        SendMessageToPC(pc, "Unsummoned your swarm.");
    }

}
