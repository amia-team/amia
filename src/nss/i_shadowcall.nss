/*
*   Created By: ZoltanTheRed
*   Stolen By: Mahtan
*   Last Updated: 07-10-2020
*   Copied to make a Shadow version
 */

void main()
{

    object oPC = GetItemActivator();

    int nPCGender = GetGender(oPC);
    int nAppearance = GetAppearanceType(oPC);

    effect eShadeVFX;
    effect eExtraordinaryShadeVFX;


    if(nPCGender == 0){

        if(nAppearance == 0){

            eShadeVFX = EffectVisualEffect(1050, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 1){

            eShadeVFX = EffectVisualEffect(1052, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 2){

            eShadeVFX = EffectVisualEffect(1054, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 3){

            eShadeVFX = EffectVisualEffect(1058, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 4){

            //Half elf version acts weird.
            eShadeVFX = EffectVisualEffect(1056, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 5){

            eShadeVFX = EffectVisualEffect(1060, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 6){

            eShadeVFX = EffectVisualEffect(1062, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }
    }

    if(nPCGender == 1){

        if(nAppearance == 0){

            eShadeVFX = EffectVisualEffect(1051, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 1){

            eShadeVFX = EffectVisualEffect(1053, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 2){

            eShadeVFX = EffectVisualEffect(1055, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 3){

            eShadeVFX = EffectVisualEffect(1059, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 4){

            eShadeVFX = EffectVisualEffect(1057, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 5){

            eShadeVFX = EffectVisualEffect(1061, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }

        if(nAppearance == 6){

            eShadeVFX = EffectVisualEffect(1063, FALSE);
            eExtraordinaryShadeVFX = ExtraordinaryEffect(eShadeVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryShadeVFX, oPC);
        }
    }

}
