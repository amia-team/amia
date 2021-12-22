// Spell-like Ability: Displacement
#include "x2_inc_switches"
void DoDisplacement(object oPC);
void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:{

            object oPC = GetItemActivator();
            AssignCommand(oPC,DoDisplacement(oPC));

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}

void DoDisplacement(object oPC)
{
            float  fDuration    = RoundsToSeconds( GetHitDice( oPC ) );   // 1 round per level

            // anim
            AssignCommand( oPC, PlaySound("sce_positive"));

            // 50% concealment
            effect eDisp=EffectLinkEffects( EffectConcealment( 50,  MISS_CHANCE_TYPE_NORMAL),  EffectVisualEffect(VFX_DUR_INVISIBILITY));

            // slap it on
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDisp, oPC, fDuration);

}
