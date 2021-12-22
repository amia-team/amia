// OnDeath event of the Chosen's Altar.  Removes the plot flag from Chosen.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/02/2004 jpavelch         Initial release.
//

void main( )
{
    object oAltar = OBJECT_SELF;
    object oChosen = GetLocalObject( oAltar, "Chosen" );

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_MAGBLUE),
        oChosen
    );
    SetPlotFlag( oChosen, FALSE );
}
