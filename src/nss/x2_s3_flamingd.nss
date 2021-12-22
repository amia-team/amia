// OnHit Castspell Fire Damage property for the
// flaming weapon spell (x2_s0_flmeweap).
//
// We need to use this property because we can not
// add random elemental damage to a weapon in any
// other way and implementation should be as close
// as possible to the book.
//
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2003-07-17 Georg Zoeller    Initial Release.
// 2005-04-06 James E King III Delayed damage to reduce crashing and fixed
//                             spell giving too much damage.
// 032606     kfw              Lag optimization: Medium flame for each hit, IF canned, may squeeze some extra latency!

void main(){

  // Get Caster Level
  object oCaster    = OBJECT_SELF;
  int nLevel        = GetCasterLevel( oCaster );
  object oTarget    = GetSpellTargetObject( );

  if( !GetIsObjectValid( oTarget ) )
        return;

  // Assume minimum caster level if variable is not found
  if( nLevel == 0 )
     nLevel = 1;

  // @@@ AmiaAddition: Spell caps damage at 1d4 +10 - missing in standard code
  if( nLevel > 10 )
     nLevel = 10;

  int nDmg = d4() + nLevel;

  effect eDmg   = EffectDamage( nDmg, DAMAGE_TYPE_FIRE );
  effect eVis   = EffectVisualEffect( VFX_IMP_FLAME_M );

  /*
  if (nDmg < 10) // if we are doing below 10 point of damage, use small flame
    eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
  else
    eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
  */

  // @@@ AmiaAddition: Do not link these like Georg did; may prevent crash
  //                   none of the other scripts link them (blade barrier,
  //                   fireball, wall of fire).
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDmg, oTarget );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );

    return;

}
