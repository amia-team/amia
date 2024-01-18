void main(){

    object pc      = GetMaster(OBJECT_SELF);

    int i = 15;
         while (i > 0){
            object swarmDie = GetHenchman(pc,1);
            effect unsummon = EffectVisualEffect(VFX_IMP_PDK_RALLYING_CRY);
            location swarmSpot = GetLocation(swarmDie);

            if(GetIsObjectValid(swarmDie)){
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT,unsummon,swarmSpot);
                RemoveHenchman(pc,swarmDie);
                DestroyObject(swarmDie,0.1);
            }
            i= (i - 1);
        }
    SetLocalInt(pc,"spawned",0);
    SendMessageToPC(pc, "Your swarm fled from battle.");
}
