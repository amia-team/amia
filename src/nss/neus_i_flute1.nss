void main( ){

    object oPC = GetPCSpeaker();

    if(GetIsObjectValid(oPC)){

        AssignCommand(oPC,PlaySound("as_cv_flute1"));

        ApplyEffectToObject(    DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_BARD_SONG ),
                                oPC, 15.0 );

    }

    return;

}
