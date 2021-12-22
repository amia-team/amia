/*
*   Created By: ZoltanTheRed
*   Last Updated: 09-30-2017
*
 */

void main()
{

    object oPC = GetItemActivator();

    int nPCGender = GetGender(oPC);
    int nAppearance = GetAppearanceType(oPC);

    effect eBirbVFX;
    effect eExtraordinaryBirbVFX;


    if(nPCGender == 0){

        if(nAppearance == 0){

            eBirbVFX = EffectVisualEffect(1078, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 1){

            eBirbVFX = EffectVisualEffect(1080, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 2){

            eBirbVFX = EffectVisualEffect(1082, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 3){

            eBirbVFX = EffectVisualEffect(1086, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 4){

            //Half elf version acts weird.
            eBirbVFX = EffectVisualEffect(1084, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 5){

            eBirbVFX = EffectVisualEffect(1088, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 6){

            eBirbVFX = EffectVisualEffect(1090, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }
    }

    if(nPCGender == 1){

        if(nAppearance == 0){

            eBirbVFX = EffectVisualEffect(1079, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 1){

            eBirbVFX = EffectVisualEffect(1081, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 2){

            eBirbVFX = EffectVisualEffect(1083, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 3){

            eBirbVFX = EffectVisualEffect(1087, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 4){

            eBirbVFX = EffectVisualEffect(1085, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 5){

            eBirbVFX = EffectVisualEffect(1089, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }

        if(nAppearance == 6){

            eBirbVFX = EffectVisualEffect(1091, FALSE);
            eExtraordinaryBirbVFX = ExtraordinaryEffect(eBirbVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBirbVFX, oPC);
        }
    }

}
