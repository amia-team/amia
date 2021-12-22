// OnSpawn event of a boss. Makes a fancy entrance.
//
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/11/2006 bbillington      Initial release.
//

#include "logger"

void main( )
{
    object oBoss = OBJECT_SELF;

    // Execute default OnSpawn script.
    ExecuteScript("ds_ai2_spawn", OBJECT_SELF);

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_HORRID_WILTING),
        GetLocation(oBoss)
    );

}
