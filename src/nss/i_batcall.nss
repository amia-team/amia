/*
*   Created By: ZoltanTheRed
*   Stolen By: Mahtan
*   Last Updated: 07-10-2020
*   Copied to make a Bat version
 */

void main()
{

    object oPC = GetItemActivator();

    int nPCGender = GetGender(oPC);
    int nAppearance = GetAppearanceType(oPC);

    effect eBatVFX;
    effect eExtraordinaryBatVFX;


    if(nPCGender == 0){

        if(nAppearance == 0){

            eBatVFX = EffectVisualEffect(1092, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 1){

            eBatVFX = EffectVisualEffect(1094, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 2){

            eBatVFX = EffectVisualEffect(1096, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 3){

            eBatVFX = EffectVisualEffect(1100, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 4){

            //Half elf version acts weird.
            eBatVFX = EffectVisualEffect(1098, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 5){

            eBatVFX = EffectVisualEffect(1102, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 6){

            eBatVFX = EffectVisualEffect(1104, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }
    }

    if(nPCGender == 1){

        if(nAppearance == 0){

            eBatVFX = EffectVisualEffect(1093, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 1){

            eBatVFX = EffectVisualEffect(1095, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 2){

            eBatVFX = EffectVisualEffect(1097, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 3){

            eBatVFX = EffectVisualEffect(1101, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 4){

            eBatVFX = EffectVisualEffect(1099, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 5){

            eBatVFX = EffectVisualEffect(1103, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }

        if(nAppearance == 6){

            eBatVFX = EffectVisualEffect(1105, FALSE);
            eExtraordinaryBatVFX = ExtraordinaryEffect(eBatVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryBatVFX, oPC);
        }
    }

}
