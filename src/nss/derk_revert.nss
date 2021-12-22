void main()
{
    object oPC = GetPCSpeaker();
    object oFamiliar = GetAssociate( ASSOCIATE_TYPE_FAMILIAR, oPC );

    if( !GetIsObjectValid( oFamiliar ) ){

        SendMessageToPC( oPC, "Unfortunate, you don't even have a familiar." );
        return;
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), oFamiliar );
    SetCreatureAppearanceType( oFamiliar, GetLocalInt( oPC, "default_ac_app" ) );
}
