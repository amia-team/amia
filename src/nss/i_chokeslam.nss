// Custom Ability: Choke Slam
//
// The script rolls the user's Attack v. target's AC, then an Attack roll v.
// Discipline if the hit lands. If the hit lands, the attack deals 1d3 + 13
// damage. If the discipline check fails, then the opponent is considered
// 'Knockdowned' for a round, and silent for 9 rounds.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/09/2012 Mathias          Initial release.
//

#include "x2_inc_switches"
#include "inc_ds_records"
#include "amia_include"

void ActivateItem( )
{
    // Variables.
    object      oPC         = GetItemActivator();
    object      oTarget     = GetItemActivatedTarget();
    string      sTalkStr    = "*Chokeslams " + GetName( oTarget ) + "!*";
    int         nTargetAC   = GetAC( oTarget );
    int         nBardLevel  = GetLevelByClass( CLASS_TYPE_BARD, oPC );
    int         nPCBAB      = GetBaseAttackBonus( oPC );
    int         nPCStr      = GetAbilityModifier( ABILITY_STRENGTH, oPC );
    int         nDamage     = d3( 1 ) + 13;
    effect      eDamage     = EffectDamage( nDamage );
    effect      eEffects    = GetFirstEffect( oPC );
    effect      eKnockdown  = EffectKnockdown( );
    effect      eSilence    = EffectSilence( );
    effect      eVFX        = EffectVisualEffect( VFX_IMP_DUST_EXPLOSION );
    effect      eShake      = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE  );
    float       fSilenceDur = 72.0;
    int         nAttack;
    int         bDebug      = TRUE;  // Set to TRUE to see debug information.

    // Return if the target is the PC, or invalid.
    if( ( !GetIsObjectValid( oTarget ) ) || ( oTarget == oPC ) ) {

        SendMessageToPC( oPC, "Invalid target for this ability." );
        return;
    }

    // Calculate attack roll.
    nAttack = d20(1) + nPCBAB + nPCStr + 2;

    // Calculate bard song bonus to attack.
    if ( nBardLevel < 8 ) {

        nAttack += 1;

    } else {

        nAttack += 2;
    }

    // Roll attack to hit.
    if ( nAttack >= nTargetAC ) {

        // Debug
        if ( bDebug ) { SendMessageToPC( oPC, "Hit: attack of " + IntToString( nAttack ) + " vs ac of " + IntToString( nTargetAC ) ); }

        // Speak the string
        AssignCommand( oPC, ActionSpeakString( sTalkStr ) );

        // Apply the damage and VFX.
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eShake, oTarget);

        // Roll target's discipline againt the attack roll.
        if ( !GetIsSkillSuccessful( oTarget, SKILL_DISCIPLINE, nAttack ) ) {

            // Make the target prone, and silenced
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0 );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSilence, oTarget, fSilenceDur );
        }

    } else {

        // Debug
        if ( bDebug ) { SendMessageToPC( oPC, "Miss: attack of " + IntToString( nAttack ) + " vs ac of " + IntToString( nTargetAC ) ); }
    }
}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}
