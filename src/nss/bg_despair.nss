/*  Blackguard's Aura of Despair Spell.

    --------
    Verbatim
    --------
    This spellscript links from bg_spells script
    and casts the Aura of Despair spell.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    051506  Aleph       Initial release.
    070713  PoS         Removed visual, made undispellable.
    ----------------------------------------------------------------------------

*/

#include "amia_include"

void main()
{
    // Variables.
    object oPC      = OBJECT_SELF;
    int nBGD_rank   = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );

    // Candy.
    // Not the cause of the unexpected wall of fire VFX. -The1Kobra
	ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE ), oPC );

    // Aura of Despair spell.
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, ExtraordinaryEffect( EffectAreaOfEffect( 47, "bg_des_en", "****", "bg_des_ex" ) ), oPC );
}
