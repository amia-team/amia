// Charming Lute (OnHeartbeat)
//
// For 15 rounds, an aura surrounds the user which casts charm monster on
// all hostile creatures in the aura's area.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/20/2012 Mathias          Initial Release.
//

void main() {

        // Variables.
        object oCreature;
        object oPC              = GetItemActivator();
        int    nMaxHD           = 19;    // Creatures above 19 HD won't be affected.
        int    nCharmDC         = 14 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
        int    nLevel           = GetLevelByClass( CLASS_TYPE_SORCERER, oPC );
        int    nDuration        = 3 + ( nLevel / 2 ); // Duration of effect (3 rounds + 1 / 2 caster levels)
        effect eCharm           = EffectDazed( );
        effect eVFX             = EffectVisualEffect( VFX_DUR_PIXIEDUST );
        effect eLink            = EffectLinkEffects( eCharm, eVFX );
        int    bDebug           = FALSE;  // set to TRUE to see debug messages

        // Apply feat bonuses
        if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oPC ) ){
            nCharmDC += 6;
        } else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC ) ){
            nCharmDC += 4;
        } else if ( GetHasFeat( FEAT_SPELL_FOCUS_ENCHANTMENT, oPC ) ){
            nCharmDC += 2;
        }

        // Cycle through objects inside the aura.
        oCreature = GetFirstInPersistentObject( );
        while( GetIsObjectValid( oCreature ) ) {

            // !!DEBUG!!
            if (bDebug) { SendMessageToPC( oPC, "- " + GetName(oCreature) + " is still in the aura(3)." );  }

            // Dont affect the caster, non-hostiles, or creatures over the HD limit.
            if ( ( oCreature != oPC ) &&
                 ( GetIsReactionTypeHostile( oCreature, oPC ) == TRUE ) &&
                 ( GetHitDice( oCreature ) <= nMaxHD ) ) {

                if ( !WillSave( oCreature, nCharmDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC ) ) {

                    // Apply the effect to the object
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oCreature, RoundsToSeconds( nDuration ) );
                }
            }

            // Get next target in the aura.
            oCreature = GetNextInPersistentObject( );
        }
}
