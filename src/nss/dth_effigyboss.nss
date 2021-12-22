// OnDeath event of a boss. Makes a fancy death.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/17/2006 bbillington      Initial release.
//

#include "logger"

void main( )
{
    object oBoss = OBJECT_SELF;

    // Execute default OnSpawn script.
    ExecuteScript("j_ai_ondeath", OBJECT_SELF);

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_DEATH_L),
        oBoss
        );

}
