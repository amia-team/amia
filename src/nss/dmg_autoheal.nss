// On Damaged event.  Auto-heals creature all damage.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 12/08/2003 jpavelch         Initial Release.
//

void main( )
{
    object oSelf = OBJECT_SELF;

    int nHeal = GetMaxHitPoints( oSelf ) - GetCurrentHitPoints( oSelf );
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectHeal(nHeal),
        oSelf
    );
}

