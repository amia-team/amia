// OnSpawn event of a boss. Makes a fancy entrance.
//
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/16/2006 bbillington      Initial release.
//

#include "logger"

void main( )
{
    object oBoss = OBJECT_SELF;

    // Execute default OnSpawn script.
    ExecuteScript("j_ai_onspawn", OBJECT_SELF);

    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        EffectVisualEffect(VFX_DUR_ICESKIN),
        oBoss
    );

    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        EffectVisualEffect(VFX_DUR_GLOW_WHITE),
        oBoss
    );

}
