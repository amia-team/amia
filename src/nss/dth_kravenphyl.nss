// OnDeath event of the Kraven Coffin.  Removes the plot flag from
// Kraven and has a % chance of dropping an Orb of Destiny.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/02/2004 jpavelch         Initial release.
// 12/20/2004 jpavelch         Changed to 10% chance.
// 11/01/2005 bbillington      Removed the Orb of Destiny drop.

void main( )
{
    object oSacrophagus = OBJECT_SELF;
    object oKraven      = GetLocalObject( oSacrophagus, "Kraven" );

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_PWSTUN),
        oKraven
    );
    SetPlotFlag( oKraven, FALSE );

}
