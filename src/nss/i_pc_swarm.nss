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
    int swarmVFX     = GetLocalInt(swarmUse,"vfx");

    if(GetIsDM(pc)){
        if(GetObjectType(swarmUse) == OBJECT_TYPE_CREATURE){
            json swarm                = ObjectToJson(swarmUse, TRUE);
            itemproperty uniqueRanged = GetFirstItemProperty(swarmer);
            itemproperty uniqueSelf   = ItemPropertyCastSpell(335, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);

            SetLocalJson(swarmer, "swarm_critter", swarm);
            RemoveItemProperty(swarmer, uniqueRanged);
            IPSafeAddItemProperty( swarmer, uniqueSelf, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE );
            SetLocalInt(swarmer, "vfx",swarmVFX);
        }
        else{
            FloatingTextStringOnCreature("Use this item on a monster to set the swarm creature.", pc, TRUE);
        }
    }
    else if(GetLocalInt(swarmer,"spawned") != 1){
        json getSwarm     = GetLocalJson(swarmer,"swarm_critter");
        location pcSpot   = GetLocation(pc);
        int henchQty      = GetLocalInt(swarmer, "qty");

        int i = henchQty;
        while (i > 0){
            object henchSwarm = JsonToObject(getSwarm, pcSpot, pc, FALSE);
            int vfxSwarm      = GetLocalInt(swarmer,"vfx");
            effect vfx        = EffectVisualEffect(vfxSwarm);
            AddHenchman(pc, henchSwarm);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, vfx, henchSwarm);
            i = (i - 1);
        }
        SetLocalInt(swarmer,"spawned",1);
    }
    else{
        int dieQty = GetLocalInt(swarmer, "qty");

        int i = dieQty;
            while (i > 0){
                object swarmDie = GetHenchman(pc,1);
                effect unsummon = EffectVisualEffect(VFX_IMP_UNSUMMON);
                location swarmSpot = GetLocation(swarmDie);

                SendMessageToPC(pc,"Henchman name is "+(GetName(swarmDie)));
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT,unsummon,swarmSpot);
                RemoveHenchman(pc,swarmDie);
                DestroyObject(swarmDie,0.1);
                i = (i - 1);
            }
        SetLocalInt(swarmer,"spawned",0);
    }

}
