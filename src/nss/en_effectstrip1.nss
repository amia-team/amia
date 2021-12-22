// OnEnter event of effect stripper trigger.  Removes all effects from
// a PC.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/17/2004 jpavelch         Initial Release.
// 20050615   jking            SafeRemoveAllEffects
//

#include "amia_include"


void main( )
{
    object oPC = GetEnteringObject( );
    if ( !GetIsPC(oPC) ) return;

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION),
        oPC
    );

    SafeRemoveAllEffects(oPC);
}
