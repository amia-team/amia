// Conversation action to cast harm on the PC speaker.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/22/2004 jpavelch         Initial Release.
//

void main( )
{
    object oPC = GetPCSpeaker( );

    ActionCastFakeSpellAtObject(
        SPELL_HARM,
        oPC
    );

    int nDamage = GetCurrentHitPoints( oPC ) - d4( );

    DelayCommand(
        1.0,
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE),
            oPC
        )
    );
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(246),
        oPC
    );
}
