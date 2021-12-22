// OnSpawn event of a creature for glowy eyes.
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
    object oCreature = OBJECT_SELF;

    // Execute default OnSpawn script.
    ExecuteScript("j_ai_onspawn", OBJECT_SELF);

    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        EffectVisualEffect(VFX_EYES_RED_FLAME_ELF_MALE),
        oCreature
        );

}
