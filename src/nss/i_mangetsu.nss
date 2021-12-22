//DC item for and from Neus
//obsolete

#include "x2_inc_switches"

void DoEarlyNewMoon(object oVictim);

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:{

            object oPC=GetItemActivator();
            object oVictim=GetItemActivatedTarget();

            if(     (GetObjectType(oVictim)!=OBJECT_TYPE_CREATURE)      ||
                    (GetIsEnemy(
                        oVictim,
                        oPC)==FALSE)                                    ){

                        FloatingTextStringOnCreature(
                            "<cþ  >Mangetsu only works on enemy NPCs or PCs.</c>",
                            oPC,
                            FALSE);

                        break;

            }

            if(GetHasFeat(
                FEAT_STUNNING_FIST,
                oPC)==FALSE){

                FloatingTextStringOnCreature(
                    "<cþ  >Mangetsu requires three uses of Stunning Fist to be used.</c>",
                    oPC,
                    FALSE);

                break;

            }

            DecrementRemainingFeatUses(
                oPC,
                FEAT_STUNNING_FIST);
            if(GetHasFeat(
                FEAT_STUNNING_FIST,
                oPC)==FALSE){

                FloatingTextStringOnCreature(
                    "<cþ  >Mangetsu requires three uses of Stunning Fist to be used.</c>",
                    oPC,
                    FALSE);
                    IncrementRemainingFeatUses(oPC,FEAT_STUNNING_FIST);

                break;

            }
            DecrementRemainingFeatUses(
                oPC,
                FEAT_STUNNING_FIST);
            if(GetHasFeat(
                FEAT_STUNNING_FIST,
                oPC)==FALSE){

                FloatingTextStringOnCreature(
                    "<cþ  >Mangetsu requires three uses of Stunning Fist to be used.</c>",
                    oPC,
                    FALSE);
                    IncrementRemainingFeatUses(oPC,FEAT_STUNNING_FIST);
                    IncrementRemainingFeatUses(oPC,FEAT_STUNNING_FIST);

                break;

            }
            DecrementRemainingFeatUses(
                oPC,
                FEAT_STUNNING_FIST);
            AssignCommand(
                oPC,
                DoEarlyNewMoon(oVictim));

            AssignCommand(
                oPC,
                ActionAttack(
                    oVictim,
                    FALSE));

            break;

        }

        default:{

            break;

        }

    }

    SetExecutedScriptReturnValue(nResult);

}

void DoEarlyNewMoon(object oVictim){

    object oPC=OBJECT_SELF;
    int iTouchAttack = TouchAttackMelee(oVictim,TRUE);
    if(iTouchAttack>0){
        int nDamage=d10(4);
        int nDC;
        if(iTouchAttack==1){
            nDC=30;
            }
        if(iTouchAttack==2){
            nDC=35;
            }
        effect eDamage=EffectDamage(
            nDamage,
            DAMAGE_TYPE_SLASHING);
        effect eDeath = EffectDeath(FALSE,TRUE);

        // candy
        effect eDamagetwo=EffectLinkEffects(
            eDamage,
            EffectVisualEffect(VFX_IMP_TORNADO));
        effect eDeathtwo=EffectLinkEffects(
            eDeath,
            EffectVisualEffect(VFX_DUR_DEATH_ARMOR));

        // slap it on
        int FortSave = FortitudeSave(oVictim,nDC,SAVING_THROW_TYPE_DEATH);
        if(FortSave==0){
               DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oVictim));
               DelayCommand(0.2f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oVictim));
               DelayCommand(0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oVictim));
               DelayCommand(0.4f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oVictim));
               DelayCommand(0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oVictim));
               DelayCommand(0.6f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oVictim));
               DelayCommand(0.7f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), oVictim));
               DelayCommand(0.8f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), oVictim));
               DelayCommand(0.9f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), oVictim));
               DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oVictim));

               DelayCommand(0.6f,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), GetLocation(oVictim),0.3f));
               DelayCommand(1.4f,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), GetLocation(oVictim),0.3f));
               DelayCommand(1.6f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PARALYZED), oVictim,1.0f));
               DelayCommand(1.8f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), oVictim));
               DelayCommand(1.8f,ApplyEffectToObject(
                    DURATION_TYPE_INSTANT,
                    eDeathtwo,
                    oVictim,
                    0.0));
        }
        else{
           DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oVictim));
           DelayCommand(0.2f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oVictim));
           DelayCommand(0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oVictim));
           DelayCommand(0.4f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oVictim));
           DelayCommand(0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oVictim));
           DelayCommand(0.6f,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oVictim));
           ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                eDamagetwo,
                oVictim,
                0.0);
            }
    }

}
