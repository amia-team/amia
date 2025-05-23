// OnSpawn event of Lesser Decoy.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/01/2004 jpavelch         Initial release.
//

void main( )
{
    object oSelf = OBJECT_SELF;

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2),
        GetLocation(oSelf)
    );

    PlayVoiceChat( VOICE_CHAT_HELLO );
}
