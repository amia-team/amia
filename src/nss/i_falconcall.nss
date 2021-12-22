/*
*   Created By: ZoltanTheRed
*   Stolen By: Mahtan
*   Last Updated: 07-10-2020
*   Copied to make a Falcon version
 */

void main()
{

    object oPC = GetItemActivator();

    int nPCGender = GetGender(oPC);
    int nAppearance = GetAppearanceType(oPC);

    effect eFalconVFX;
    effect eExtraordinaryFalconVFX;


    if(nPCGender == 0){

        if(nAppearance == 0){

            eFalconVFX = EffectVisualEffect(1134, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 1){

            eFalconVFX = EffectVisualEffect(1136, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 2){

            eFalconVFX = EffectVisualEffect(1138, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 3){

            eFalconVFX = EffectVisualEffect(1142, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 4){

            //Half elf version acts weird.
            eFalconVFX = EffectVisualEffect(1140, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 5){

            eFalconVFX = EffectVisualEffect(1144, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 6){

            eFalconVFX = EffectVisualEffect(1146, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }
    }

    if(nPCGender == 1){

        if(nAppearance == 0){

            eFalconVFX = EffectVisualEffect(1135, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 1){

            eFalconVFX = EffectVisualEffect(1137, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 2){

            eFalconVFX = EffectVisualEffect(1139, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 3){

            eFalconVFX = EffectVisualEffect(1143, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 4){

            eFalconVFX = EffectVisualEffect(1141, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 5){

            eFalconVFX = EffectVisualEffect(1145, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }

        if(nAppearance == 6){

            eFalconVFX = EffectVisualEffect(1147, FALSE);
            eExtraordinaryFalconVFX = ExtraordinaryEffect(eFalconVFX);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraordinaryFalconVFX, oPC);
        }
    }

}
