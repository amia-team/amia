// OnDeath event of a boss. Makes a fancy death.
//
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/18/2006 bbillington      Initial release.
//

#include "logger"

void main( )
{
    object oBoss = OBJECT_SELF;

    // Execute default OnSpawn script.
    ExecuteScript("j_ai_ondeath", OBJECT_SELF);

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION),
        GetLocation(oBoss)
    );

}
