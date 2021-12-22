// OnSpawn event of a boss. Makes a fancy entrance.
//
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
    ExecuteScript("j_ai_onspawn", OBJECT_SELF);

    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        EffectVisualEffect(VFX_DUR_GHOST_TRANSPARENT),
        oBoss
        );

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_WORD),
        GetLocation(oBoss)
        );

}

