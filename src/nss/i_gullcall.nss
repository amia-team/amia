/*
*   Created By: ZoltanTheRed
*   Stolen By: Mahtan
*   Last Updated: 07-10-2020
*   Copied to make a Seagull version
 */

void main()
{

    object oPC = GetItemActivator();

    int nPCGender = GetGender(oPC);
    int nAppearance = GetAppearanceType(oPC);

    effect eGullVFX;
    effect eExtraordinaryGullVFX;


    if(nPCGender == 0){

        if(nAppearance == 0){

            eGullVFX = EffectVisualEffect(1120, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 1){

            eGullVFX = EffectVisualEffect(1122, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 2){

            eGullVFX = EffectVisualEffect(1124, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 3){

            eGullVFX = EffectVisualEffect(1128, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 4){

            //Half elf version acts weird.
            eGullVFX = EffectVisualEffect(1126, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 5){

            eGullVFX = EffectVisualEffect(1130, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 6){

            eGullVFX = EffectVisualEffect(1132, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }
    }

    if(nPCGender == 1){

        if(nAppearance == 0){

            eGullVFX = EffectVisualEffect(1121, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 1){

            eGullVFX = EffectVisualEffect(1123, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 2){

            eGullVFX = EffectVisualEffect(1125, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 3){

            eGullVFX = EffectVisualEffect(1129, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 4){

            eGullVFX = EffectVisualEffect(1127, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 5){

            eGullVFX = EffectVisualEffect(1031, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }

        if(nAppearance == 6){

            eGullVFX = EffectVisualEffect(1133, FALSE);
            eExtraordinaryGullVFX = ExtraordinaryEffect(eGullVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryGullVFX, oPC);
        }
    }

}
