/* Harper Scout Item: Chime of Interruption
    o All foes within a Large radius of the Harper Scout, suffer 50% arcane spell failure for 4 rounds */
#include "x2_inc_switches"

void KillInvis( object oPC ){

    effect eEff = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEff ) ){
        nType=GetEffectType( eEff );

        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY )
            RemoveEffect( oPC, eEff );

        eEff = GetNextEffect( oPC );
    }
}

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object oPC=GetItemActivator();
            location lLoc=GetLocation(oPC);

            KillInvis( oPC );

            // sound anim
            AssignCommand(
                oPC,
                PlaySound("as_cv_bell2"));

            // cycle thru all foes within radius
            object oVictim=GetFirstObjectInShape(
                SHAPE_SPHERE,
                RADIUS_SIZE_LARGE,
                lLoc,
                OBJECT_TYPE_CREATURE);

            while(oVictim!=OBJECT_INVALID){

                // foes of the Harper Scout only
                if( (GetIsEnemy(
                        oVictim,
                        oPC)==TRUE) &&
                    (oVictim!=oPC)  ){

                    effect eInterruption=EffectVisualEffect(VFX_IMP_SILENCE);
                    eInterruption=EffectLinkEffects(
                        eInterruption,
                        EffectSpellFailure(50));
                    eInterruption=ExtraordinaryEffect(eInterruption);


                    ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eInterruption,
                        oVictim,
                        RoundsToSeconds(4));

                }

                // get the next foe
                oVictim=GetNextObjectInShape(
                    SHAPE_SPHERE,
                    RADIUS_SIZE_LARGE,
                    lLoc,
                    OBJECT_TYPE_CREATURE);

            }

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
