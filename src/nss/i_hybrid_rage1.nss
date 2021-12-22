// Fear aura from the Hybrid Rage item.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/18/2011 PoS              Initial Release.
//

#include "x2_inc_spellhook"

void main(){

    // Variables.
    object oCreature    = GetEnteringObject( );
    object oItem        = GetItemPossessedBy( oCreature, "hybrid_rage" );

    effect eFear        = EffectFrightened();
    effect eVFX         = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );

    effect eLink        = EffectLinkEffects( eFear, eVFX );

    // Hack to prevent PC fearing themselves
    if( GetIsObjectValid( oItem ) ) {
        return;
    }

    // Fear if Will 30 DC is failed
    if( !MySavingThrow( SAVING_THROW_WILL, oCreature, 30, SAVING_THROW_TYPE_FEAR ) )
    {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oCreature, RoundsToSeconds( 5 ) );
    }
}
