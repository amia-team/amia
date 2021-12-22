// OnSpawn event of Goblin Tongue.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/24/2005 bbillington       Initial release.
//

void main( )
{
    object oSelf = OBJECT_SELF;

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_SMOKE_PUFF),
        GetLocation(oSelf)
    );
}
