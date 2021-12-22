/*
*   Created By: ZoltanTheRed
*   Stolen By: Mahtan
*   Last Updated: 07-10-2020
*   Copied to make a Raven version
 */

void main()
{

    object oPC = GetItemActivator();

    int nPCGender = GetGender(oPC);
    int nAppearance = GetAppearanceType(oPC);

    effect eRavVFX;
    effect eExtraordinaryRavVFX;


    if(nPCGender == 0){

        if(nAppearance == 0){

            eRavVFX = EffectVisualEffect(1064, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 1){

            eRavVFX = EffectVisualEffect(1066, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 2){

            eRavVFX = EffectVisualEffect(1068, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 3){

            eRavVFX = EffectVisualEffect(1072, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 4){

            //Half elf version acts weird.
            eRavVFX = EffectVisualEffect(1070, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 5){

            eRavVFX = EffectVisualEffect(1074, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 6){

            eRavVFX = EffectVisualEffect(1076, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }
    }

    if(nPCGender == 1){

        if(nAppearance == 0){

            eRavVFX = EffectVisualEffect(1065, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 1){

            eRavVFX = EffectVisualEffect(1067, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 2){

            eRavVFX = EffectVisualEffect(1069, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 3){

            eRavVFX = EffectVisualEffect(1073, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 4){

            eRavVFX = EffectVisualEffect(1071, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 5){

            eRavVFX = EffectVisualEffect(1075, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }

        if(nAppearance == 6){

            eRavVFX = EffectVisualEffect(1077, FALSE);
            eExtraordinaryRavVFX = ExtraordinaryEffect(eRavVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryRavVFX, oPC);
        }
    }

}
